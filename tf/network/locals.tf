locals {
  interface_endpoints = {
    ecr_api = "ecr.api"
    ecr_dkr = "ecr.dkr"
    logs    = "logs"
  }
  private_vpc_id       = data.aws_vpc.private.id
  private_subnet_ids   = data.aws_subnets.private.ids
  private_subnet_cidrs = [for s in data.aws_subnet.subnets : s.cidr_block]
}