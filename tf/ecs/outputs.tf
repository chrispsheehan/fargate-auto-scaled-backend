output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.ecs.name
}

output "lb-arn" {
  value = aws_lb.lb.arn
}