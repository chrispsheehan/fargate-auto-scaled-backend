locals {
  private_vpc_name = "ecs-private-vpc"
  api_stage_name   = "dev"

  private_subnet_cidrs = [for s in data.aws_subnet.subnets : s.cidr_block]
}