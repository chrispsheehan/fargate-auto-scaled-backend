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

variable "api_stage_name" {
  type = string
}

variable "initial_task_count" {
  type = number
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "container_port" {
  type = number
}

variable "load_balancer_port" {
  type = number
}

variable "load_balancer_security_group_id" {
  type = string
}

variable "aws_lb_target_group_arn" {
  type = string
}
