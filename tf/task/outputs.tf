output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.ecs_log_group.name
}
