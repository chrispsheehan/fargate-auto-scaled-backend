locals {
    interface_endpoints = {
        ecr_api = "ecr.api"
        ecr_dkr = "ecr.dkr"
        logs    = "logs"
    }
    private_subnet_cidrs = [for s in data.aws_subnet.subnets : s.cidr_block]
}