output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}

output "image_uri" {
  value = local.image_uri
}