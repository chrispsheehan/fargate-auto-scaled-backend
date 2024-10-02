locals {
  load_balancer_port     = 80
  private_vpc_id         = data.aws_vpc.private.id
  private_vpc_cidr_block = data.aws_vpc.private.cidr_block
  private_subnet_ids     = data.aws_subnets.private.ids
  private_subnet_cidrs   = [for s in data.aws_subnet.subnets : s.cidr_block]
}