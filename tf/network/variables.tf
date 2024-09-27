variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "container_port" {
  type = number
}

variable "load_balancer_port" {
  type = number
}

variable "api_stage_name" {
  type = string
}

variable "private_vpc_name" {
  type = string
}

variable "load_balancer_listener_arn" {
  type        = string
  description = "generated from ecs load balancer deployment"
}
