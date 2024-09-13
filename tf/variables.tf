variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "initial_task_count" {
  description = "initial and minimum number of tasks to run on the ECS instance"
  default     = 2

  validation {
    condition     = var.initial_task_count >= 2
    error_message = "The initial_task_count must be at least 2."
  }
}

variable "max_scaled_task_count" {
  description = "maximum number of tasks to be running during auto-scaling"
  default     = 3

  validation {
    condition     = var.max_scaled_task_count >= 3
    error_message = "The max_scaled_task_count must be greater than the initial_task_count."
  }
}

variable "auto_scale_cool_down_period" {
  description = "Amount of time to wait between autoscaling actoins"
  default     = 30
}

variable "sqs_scale_up_trigger" {
  description = "The average number of SQS messages in the queue required to trigger scale UP"
  default = 4
}

variable "sqs_scale_down_trigger" {
  description = "The average number of SQS messages in the queue required to trigger scale DOWN"
  default = 2
}


variable "max_az" {
  description = "limit the amount of azs"
  default     = 3
}

variable "project_name" {
  type    = string
  default = "fargate-auto-scaled-backend"
}

variable "image_uri" {
  type        = string
  description = "docker.io/<dockerhub_username>/<repo_name>:<tag>"
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
