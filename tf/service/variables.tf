variable "project_name" {
  type = string
}

variable "codedeploy_app_name" {
  type = string
}

variable "codedeploy_group_name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_vpc_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "task_definition_arn" {
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
  description = "Amount of time to wait between autoscaling actoins"
  type        = number
  default     = 30
}

variable "sqs_scale_up_trigger" {
  description = "The average number of SQS messages in the queue required to trigger scale UP"
  type        = number
  default     = 4
}

variable "sqs_scale_down_trigger" {
  description = "The average number of SQS messages in the queue required to trigger scale DOWN"
  type        = number
  default     = 2
}

variable "max_az" {
  description = "limit the amount of azs"
  type        = number
  default     = 3
}
