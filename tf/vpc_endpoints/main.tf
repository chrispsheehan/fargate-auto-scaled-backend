# Security Group for the VPC Endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.project_name}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.private_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]  # Allow all IPv6 traffic
  }

  # Open egress rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow all IPv4 traffic
    ipv6_cidr_blocks = ["::/0"]  # Allow all IPv6 traffic
  }
}

# ECR API VPC Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.private_vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true
}

# ECR DKR VPC Endpoint (for pulling images)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.private_vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true
}

# CloudWatch Logs VPC Endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.private_vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = true
}

# S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.private_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = data.aws_route_tables.subnet_route_tables.ids
}
