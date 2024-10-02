output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.ecs.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}
