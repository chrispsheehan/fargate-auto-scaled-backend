resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_iam_policy" "logs_access_policy" {
  name   = "${var.formatted_name}_logs_access_policy"
  policy = data.aws_iam_policy_document.logs_policy.json
}

resource "aws_iam_policy" "ecr_access_policy" {
  name   = "${var.formatted_name}_ecr_access_policy"
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.private_vpc_id
  name   = "${var.project_name}-ecs-sg"

  ingress {
    from_port       = 0
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.load_balancer_security_group_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]      # Allow all IPv6 traffic
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.cloudwatch_log_name
  retention_in_days = 1
}

resource "aws_ecs_service" "ecs" {
  name                  = var.project_name
  launch_type           = "FARGATE"
  cluster               = aws_ecs_cluster.cluster.id
  task_definition       = var.task_definition_arn
  desired_count         = var.initial_task_count
  wait_for_steady_state = true

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
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  # Auto-rollback and rolling deployment settings
  deployment_minimum_healthy_percent = 50  # 50% of tasks must remain healthy during deployment
  deployment_maximum_percent         = 200 # Can scale up to 200% during the deployment process

  # Health check grace period (in seconds) for the new tasks
  health_check_grace_period_seconds = 60

  force_new_deployment = false
}
