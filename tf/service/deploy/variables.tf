variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "deployment_config_name" {
  description = "The deployment configuration strategy for CodeDeploy."
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "service_name" {
  type = string
}

variable "codedeploy_app_name" {
  type = string
}

variable "codedeploy_group_name" {
  type = string
}

variable "app_specs_bucket" {
  type = string
}

variable "load_balancer_arn" {
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

variable "lb_green_target_group" {
  type = string
}

variable "lb_blue_target_group" {
  type = string
}

variable "appautoscaling_policy_scale_up_arn" {
  type = string
}

variable "appautoscaling_policy_scale_down_arn" {
  type = string
}