variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_vpc_name" {
  type = string
}

variable "codedeploy_deployment_config_name" {
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

variable "container_port" {
  type = number
}

variable "load_balancer_port" {
  type = number
}

variable "task_definition_arn" {
  type = string
}

variable "load_balancer_arn" {
  type = string
}

variable "lb_listener_arn" {
  type = string
}

variable "lb_blue_target_group" {
  type = string
}

variable "lb_blue_target_group_arn" {
  type = string
}

variable "lb_green_target_group" {
  type = string
}

variable "lb_green_target_group_arn" {
  type = string
}

variable "lb_security_group_id" {
  type = string
}

variable "initial_task_count" {
  description = "initial and minimum number of tasks to run on the ECS instance"
  type        = number
  default     = 2

  validation {
    condition     = var.initial_task_count >= 2
    error_message = "The initial_task_count must be at least 2."
  }
}

variable "max_scaled_task_count" {
  description = "maximum number of tasks to be running during auto-scaling"
  type        = number
  default     = 3

  validation {
    condition     = var.max_scaled_task_count >= 3
    error_message = "The max_scaled_task_count must be greater than the initial_task_count."
  }
}

variable "auto_scale_cool_down_period" {
  description = "Amount of time to wait between autoscaling actions - seconds."
  type        = number
  default     = 60

  validation {
    condition     = var.auto_scale_cool_down_period >= 60
    error_message = "Must be a minimum of 60s to match ECS CPUUtilization metric's reporting interval"
  }
}

variable "cpu_scale_up_threshold" {
  description = "Amount of CPU usage to trigger scale UP - 70 for 70% CPU"
  type        = number
  default     = 50
}

variable "cpu_scale_down_threshold" {
  description = "Amount of CPU usage to trigger scale DOWN - 30 for 30% CPU"
  type        = number
  default     = 20
}

variable "max_az" {
  description = "limit the amount of azs"
  type        = number
  default     = 3
}
