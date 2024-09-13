variable "project_name" {
  type = string
}

variable "private_vpc_id" {
  type = string
}

variable "private_vpc_cidr_block" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_domain" {
  type        = string
  description = "domain to forward api calls to i.e. load balancer http://fargate-auto-scaled-backend-lb-311523723.eu-west-2.elb.amazonaws.com"
}
