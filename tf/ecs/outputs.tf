output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.ecs.name
}

output "lb-url" {
  value = "http://${aws_lb.lb.dns_name}:${var.load_balancer_port}"
}