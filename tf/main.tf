resource "aws_route_table" "rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-rt"
  }
}

resource "aws_subnet" "public_subnet" {
  count = local.az_count

  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, local.az_count + count.index)


  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "public_association" {
  count = local.az_count

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = data.aws_vpc.vpc.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_iam_policy" "logs_access_policy" {
  name   = "${local.formatted_name}_ecr_access_policy"
  policy = data.aws_iam_policy_document.logs_policy.json
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "logs_access_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.logs_access_policy.arn
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = local.container_definitions
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${var.project_name}-ecs-sg"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = local.cloudwatch_log_name
  retention_in_days = 1
}

resource "aws_ecs_service" "ecs" {
  depends_on = [aws_lb.lb, aws_cloudwatch_log_group.ecs_log_group]

  name                  = var.project_name
  launch_type           = "FARGATE"
  cluster               = aws_ecs_cluster.cluster.id
  task_definition       = aws_ecs_task_definition.task.arn
  desired_count         = var.initial_task_count
  wait_for_steady_state = false  # Disable waiting for steady state to enable iteration  ##########

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.public_subnet.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  force_new_deployment = true  # This forces a new deployment on every apply
}

resource "aws_security_group" "lb_sg" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${var.project_name}-lb-sg"

  ingress {
    from_port   = var.load_balancer_port
    to_port     = var.load_balancer_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"

  enable_deletion_protection = false

  security_groups = [aws_security_group.lb_sg.id]
  subnets         = aws_subnet.public_subnet[*].id

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "tg" {
  depends_on = [aws_lb.lb]

  name     = "${var.project_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  target_type = "ip"

  health_check {
    interval            = 60
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.load_balancer_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_sqs_queue" "my_queue" {
  name = "${var.project_name}-queue"
}

resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_scaled_task_count
  min_capacity       = var.initial_task_count
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.project_name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }

    cooldown         = 60
    metric_aggregation_type = "Average"
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${var.project_name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = 0
    }

    cooldown         = 60
    metric_aggregation_type = "Average"
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name                = "${var.project_name}-scale-up-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = var.sqs_scale_up_trigger
  alarm_actions             = [aws_appautoscaling_policy.scale_up.arn]
  dimensions = {
    QueueName = aws_sqs_queue.my_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name                = "${var.project_name}-scale-down-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = var.sqs_scale_down_trigger
  alarm_actions             = [aws_appautoscaling_policy.scale_down.arn]
  dimensions = {
    QueueName = aws_sqs_queue.my_queue.name
  }
}
