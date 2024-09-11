variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "initial_task_count" {
  description = "number of tasks to run on the ECS instance **superceded by auto-scaling**"
  default     = 2

  validation {
    condition     = var.initial_task_count >= 2
    error_message = "The initial_task_count must be at least 2."
  }
}

variable "min_scaled_task_count" {
  description = "minimum number of tasks to be running during auto-scaling"
  default     = 2

  validation {
    condition     = var.min_scaled_task_count >= var.initial_task_count
    error_message = "The var.min_scaled_task_count must at least equal var.initial_task_count"
  }
}

variable "max_scaled_task_count" {
  description = "maximum number of tasks to be running during auto-scaling"
  default     = 3

  validation {
    condition     = var.max_scaled_task_count > var.min_scaled_task_count
    error_message = "The var.max_scaled_task_count must at least equal var.min_scaled_task_count"
  }
}

variable "max_az" {
  description = "limit the amount of azs"
  default     = 3
}

variable "project_name" {
  type    = string
  default = "fargate-nextjs-webapp"
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
