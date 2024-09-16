resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "example" {
  name   = "example"
  role   = aws_iam_role.example.id
  policy = data.aws_iam_policy_document.example.json
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  vpc_id          = var.private_vpc_id
  traffic_type    = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "${var.project_name}-vpc-flow-logs"
  retention_in_days = 1
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.private_vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.this.id]
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.private_vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.this.id]
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true
}

# Data source to get the Amazon-managed prefix list for the ECR API
data "aws_prefix_list" "ecr_api" {
  name = "com.amazonaws.${var.region}.ecr.api"
}

# Data source to get the Amazon-managed prefix list for the ECR Docker
data "aws_prefix_list" "ecr_dkr" {
  name = "com.amazonaws.${var.region}.ecr.dkr"
}

resource "aws_security_group" "this" {
  name   = "${var.project_name}-api-gateway-sg"
  vpc_id = var.private_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_route_table" "private" {
  for_each = toset(var.private_subnet_ids)
  subnet_id = each.value
}

resource "aws_route" "ecr_api_route" {
  for_each = data.aws_route_table.private

  route_table_id             = each.value.id
  destination_prefix_list_id = data.aws_prefix_list.ecr_api.prefix_list_id
  vpc_endpoint_id            = aws_vpc_endpoint.ecr_api.id
}

resource "aws_route" "ecr_dkr_route" {
  for_each = data.aws_route_table.private

  route_table_id             = each.value.id
  destination_prefix_list_id = data.aws_prefix_list.ecr_dkr.prefix_list_id
  vpc_endpoint_id            = aws_vpc_endpoint.ecr_dkr.id
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.project_name}-vpc-link"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.this.id]
}

resource "aws_apigatewayv2_integration" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
  integration_method = "ANY"
  integration_uri    = var.lb_listener_arn

  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}
