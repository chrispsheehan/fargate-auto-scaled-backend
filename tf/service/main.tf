module "ecs" {
  source = "./ecs"

  project_name                    = var.project_name
  initial_task_count              = var.initial_task_count
  container_port                  = var.container_port
  load_balancer_port              = var.load_balancer_port
  lb_target_group_arn             = var.lb_target_group_arn
  task_definition_arn             = var.task_definition_arn
  private_vpc_id                  = var.private_vpc_id
  private_subnet_ids              = var.private_subnet_ids
  load_balancer_security_group_id = var.load_balancer_security_group_id
}

module "auto_scaling" {
  source = "./auto_scaling"

  project_name                = var.project_name
  ecs_cluster_name            = module.ecs.cluster_name
  ecs_name                    = module.ecs.service_name
  initial_task_count          = var.initial_task_count
  max_scaled_task_count       = var.max_scaled_task_count
  auto_scale_cool_down_period = var.auto_scale_cool_down_period
  sqs_scale_up_trigger        = var.sqs_scale_up_trigger
  sqs_scale_down_trigger      = var.sqs_scale_down_trigger
}
