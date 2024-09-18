data "aws_route_tables" "subnet_route_tables" {
  filter {
    name   = "association.subnet-id"
    values = var.private_subnet_ids
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(var.private_subnet_ids)
  id       = each.value
}
