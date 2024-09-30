variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "codedeploy_app_name" {
  type = string
}

variable "lb_listener_arn" {
  type = string
}

variable "lb_green_target_group_arn" {
  type = string
}

variable "lb_blue_target_group_arn" {
  type = string
}