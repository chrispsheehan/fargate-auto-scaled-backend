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

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "api_stage_name" {
  type = string
}

variable "initial_task_count" {
  type = number
}

variable "image_tag" {
  type = string
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
  type    = number
  default = 3000
}

variable "load_balancer_port" {
  type    = number
  default = 80
}

variable "is_destroy" {
  type        = bool
}