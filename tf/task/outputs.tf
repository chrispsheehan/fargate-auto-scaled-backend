output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.task.revision
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.ecs_log_group.name
}

output "app_specs_bucket" {
  value = aws_s3_bucket.app_specs.bucket
}
