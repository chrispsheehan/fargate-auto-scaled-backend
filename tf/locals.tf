locals {
  formatted_name      = replace(var.project_name, "-", "_")
  cloudwatch_log_name = "/ecs/${local.formatted_name}"

  private_vpc_name = "ecs-private-vpc"
  api_stage_name   = "dev"

  container_port     = 3000
  load_balancer_port = 80

  private_subnet_cidrs = [for s in data.aws_subnet.subnets : s.cidr_block]
}