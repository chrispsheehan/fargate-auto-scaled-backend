locals {
  ecs_service_arn = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.service_name}"
  task_set_arn    = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-set/${var.cluster_name}/${var.service_name}/*"
}