variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "initial_task_count" {
  type = number
}

variable "max_az" {
  type = number
}

variable "image_uri" {
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
