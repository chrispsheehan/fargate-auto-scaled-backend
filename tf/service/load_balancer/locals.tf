locals {
  blue_target_group_name  = length("${var.project_name}-tg-blue") <= 32 ? "${var.project_name}-tg-blue" : error("blue_target_group_name exceeds 32 characters")
  green_target_group_name = length("${var.project_name}-tg-green") <= 32 ? "${var.project_name}-tg-green" : error("green_target_group_name exceeds 32 characters")
}