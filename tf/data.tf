data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [local.private_vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.private.id]
  }
}