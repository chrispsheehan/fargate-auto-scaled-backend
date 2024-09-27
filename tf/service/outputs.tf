output "cluster_name" {
  value = module.ecs.cluster_name
}

output "service_name" {
  value = module.ecs.service_name
}

output "lb_listener_arn" {
  value = module.load_balancer.listener_arn
}
