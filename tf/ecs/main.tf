resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_iam_policy" "logs_access_policy" {
  name   = "${local.formatted_name}_logs_access_policy"
  policy = data.aws_iam_policy_document.logs_policy.json
}

resource "aws_iam_policy" "ecr_access_policy" {
  name   = "${local.formatted_name}_ecr_access_policy"
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "logs_access_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.logs_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = local.container_definitions
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.private_vpc_id
  name   = "${var.project_name}-ecs-sg"

  # Open ingress rule: Allow all traffic from any IP (IPv4 and IPv6)
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]      # Allow all IPv6 traffic
  }

  # Open egress rule: Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]      # Allow all IPv6 traffic
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = local.cloudwatch_log_name
  retention_in_days = 1
}

resource "aws_ecs_service" "ecs" {
  # depends_on = [aws_lb.lb, aws_cloudwatch_log_group.ecs_log_group]

  name                  = var.project_name
  launch_type           = "FARGATE"
  cluster               = aws_ecs_cluster.cluster.id
  task_definition       = aws_ecs_task_definition.task.arn
  desired_count         = var.initial_task_count
  wait_for_steady_state = false # Disable waiting for steady state to enable iteration  ##########

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  force_new_deployment = true # This forces a new deployment on every apply
}

resource "aws_security_group" "lb_sg" {
  vpc_id = var.private_vpc_id
  name   = "${var.project_name}-lb-sg"

  # Open ingress rule: Allow all traffic from any IP (IPv4 and IPv6)
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]      # Allow all IPv6 traffic
  }

  # Open egress rule: Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]      # Allow all IPv6 traffic
  }
}

resource "aws_lb" "lb" {
  name               = "${var.project_name}-lb"
  internal           = true
  load_balancer_type = "application"

  enable_deletion_protection = false

  security_groups = [aws_security_group.lb_sg.id]
  subnets         = var.private_subnet_ids

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "tg" {
  depends_on = [aws_lb.lb]

  name     = "${var.project_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.private_vpc_id

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
