variable "project_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_name" {
  type = string
}

variable "initial_task_count" {
  type = number
}

variable "max_scaled_task_count" {
  type = number
}

variable "auto_scale_cool_down_period" {
  type = number
}

variable "cpu_scale_up_threshold" {
  type = number
}

variable "cpu_scale_down_threshold" {
  type = number
}
