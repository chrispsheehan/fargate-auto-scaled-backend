locals {
  formatted_name      = replace(var.project_name, "-", "_")
  cloudwatch_log_name = "/ecs/${local.formatted_name}"
  container_definitions = templatefile("${path.module}/container_definitions.tpl", {
    container_name      = var.project_name
    image_uri           = var.image_uri
    container_port      = var.container_port
    base_path           = var.api_stage_name
    cpu                 = var.cpu
    memory              = var.memory
    aws_region          = var.region
    cloudwatch_log_name = local.cloudwatch_log_name
  })
}
