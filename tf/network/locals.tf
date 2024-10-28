locals {
  deregistration_delay    = 15
  blue_target_group_name  = length("${var.project_name}-tg-blue") <= 32 ? "${var.project_name}-tg-blue" : error("blue_target_group_name exceeds 32 characters")
  green_target_group_name = length("${var.project_name}-tg-green") <= 32 ? "${var.project_name}-tg-green" : error("green_target_group_name exceeds 32 characters")
  interface_endpoints = {
    ecr_api = "ecr.api"
    ecr_dkr = "ecr.dkr"
    logs    = "logs"
  }
  private_vpc_id         = data.aws_vpc.private.id
  private_vpc_cidr_block = data.aws_vpc.private.cidr_block
  private_subnet_ids     = data.aws_subnets.private.ids
  private_subnet_cidrs   = [for s in data.aws_subnet.subnets : s.cidr_block]
}