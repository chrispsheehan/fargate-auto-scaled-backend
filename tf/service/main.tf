module "ecs" {
  source = "./ecs"

  project_name         = var.project_name
  initial_task_count   = var.initial_task_count
  container_port       = var.container_port
  load_balancer_port   = local.load_balancer_port
  task_definition_arn  = var.task_definition_arn
  private_vpc_id       = local.private_vpc_id
  private_subnet_ids   = local.private_subnet_ids
  lb_target_group_arn  = module.load_balancer.blue_target_group_arn
  lb_security_group_id = module.load_balancer.security_group_id
}

module "load_balancer" {
  source = "./load_balancer"

  project_name           = var.project_name
  container_port         = var.container_port
  load_balancer_port     = local.load_balancer_port
  private_vpc_id         = local.private_vpc_id
  private_vpc_cidr_block = local.private_vpc_cidr_block
  private_subnet_cidrs   = local.private_subnet_cidrs
  private_subnet_ids     = local.private_subnet_ids
}

module "deploy" {
  source = "./deploy"

  project_name              = var.project_name
  codedeploy_app_name       = var.codedeploy_app_name
  region                    = var.region
  cluster_name              = module.ecs.cluster_name
  service_name              = module.ecs.service_name
  lb_listener_arn           = module.load_balancer.listener_arn
  lb_blue_target_group_arn  = module.load_balancer.blue_target_group_arn
  lb_green_target_group_arn = module.load_balancer.green_target_group_arn
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
