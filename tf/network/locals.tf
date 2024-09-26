locals {
  api_stage_name   = "dev"
  container_port     = 3000
  load_balancer_port = 80
  private_subnet_cidrs = [for s in data.aws_subnet.subnets : s.cidr_block]
}