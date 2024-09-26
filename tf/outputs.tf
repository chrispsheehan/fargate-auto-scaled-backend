output "url" {
  value = "${module.vpc_link.api_invoke_url}/host"
}

output "task_definition_arn" {
  value = module.task_definition.task_definition_arn
}

output "cluster_name" {
  value = module.ecs.cluster_name
}

output "service_name" {
  value = module.ecs.service_name
}
