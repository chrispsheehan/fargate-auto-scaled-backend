module "ecs" {
  source = "./ecs"

  project_name = var.project_name
  image_uri    = var.image_uri

  region             = var.region
  initial_task_count = var.initial_task_count
  private_vpc_id     = data.aws_vpc.private.id
  private_subnet_ids = data.aws_subnets.private.*.id
}

module "vpc_link" {
  source = "./vpc_link"

  project_name = var.project_name

  target_domain          = module.ecs.lb-url
  private_vpc_id         = data.aws_vpc.private.id
  private_vpc_cidr_block = data.aws_vpc.private.cidr_block
  private_subnet_ids     = data.aws_subnets.private.*.id
}

# module "auto_scaling" {
#   source = "./auto_scaling"

#   project_name = var.project_name
#   ecs_cluster_name = module.ecs.cluster_name
#   ecs_name         = module.ecs.service_name

#   initial_task_count          = var.initial_task_count
#   max_scaled_task_count       = var.max_scaled_task_count
#   auto_scale_cool_down_period = var.auto_scale_cool_down_period
#   sqs_scale_up_trigger        = var.sqs_scale_up_trigger
#   sqs_scale_down_trigger      = var.sqs_scale_down_trigger
# }