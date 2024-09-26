variable "project_name" {
  type = string
}

variable "private_vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "initial_task_count" {
  type = number
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

variable "task_definition_arn" {
  type = string
}
