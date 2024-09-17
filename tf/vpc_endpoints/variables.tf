variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}