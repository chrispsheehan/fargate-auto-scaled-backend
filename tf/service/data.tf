data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [var.private_vpc_name]
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}