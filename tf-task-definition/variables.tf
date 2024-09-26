variable "project_name" {
  type = string
}

variable "formatted_name" {
  type = string
}

variable "region" {
  type = string
}

variable "api_stage_name" {
  type = string
}

variable "cloudwatch_log_name" {
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
  type = number
}
