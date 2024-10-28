resource "aws_security_group" "lb_sg" {
  vpc_id = local.private_vpc_id
  name   = "${var.project_name}-lb-sg"

  ingress {
    from_port   = var.load_balancer_port
    to_port     = var.load_balancer_port
    protocol    = "tcp"
    cidr_blocks = local.private_subnet_cidrs
  }

  egress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [local.private_vpc_cidr_block]
  }
}

resource "aws_lb" "lb" {
  name               = "${var.project_name}-lb"
  internal           = true
  load_balancer_type = "application"

  enable_deletion_protection = false

  security_groups = [aws_security_group.lb_sg.id]
  subnets         = local.private_subnet_ids

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "tg_blue" {
  name     = local.blue_target_group_name
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = local.private_vpc_id

  target_type = "ip"

  deregistration_delay = local.deregistration_delay

  health_check {
    interval            = 10
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "tg_green" {
  name     = local.green_target_group_name
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = local.private_vpc_id

  target_type = "ip"

  deregistration_delay = local.deregistration_delay

  health_check {
    interval            = 10
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.load_balancer_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tg_blue.arn
        weight = 100
      }
      target_group {
        arn    = aws_lb_target_group.tg_green.arn
        weight = 0
      }
    }
  }
}

resource "aws_security_group" "api_gateway_vpc_link" {
  name        = "${var.project_name}-api-gateway-vpc-link-sg"
  description = "Security group for API Gateway VPC link"
  vpc_id      = local.private_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.private_subnet_cidrs
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.private_subnet_cidrs
  }
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.project_name}-vpc-link"
  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.api_gateway_vpc_link.id]
}

resource "aws_apigatewayv2_integration" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
  integration_method = "ANY"
  integration_uri    = var.load_balancer_listener_arn

  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.api_stage_name
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}
