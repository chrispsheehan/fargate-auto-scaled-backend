locals {
  ecs_service_arn = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.service_name}"
}