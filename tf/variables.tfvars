project_name          = "fargate-scaled-backend"
codedeploy_app_name   = "fargate-scaled-backend-ecs-codedeploy"
codedeploy_group_name = "fargate-scaled-backend-ecs-blue-green-group"
app_specs_bucket      = "fargate-scaled-backend-ecs-app-specs"
region                = "eu-west-2"
private_vpc_name      = "ecs-private-vpc"
api_stage_name        = "dev"
container_port        = 3000