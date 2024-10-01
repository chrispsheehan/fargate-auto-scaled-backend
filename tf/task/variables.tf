variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "api_stage_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "image_uri" {
  type = string
}

variable "app_specs_bucket" {
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
