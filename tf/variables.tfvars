project_name          = "fargate-auto-scaled-backend"
codedeploy_app_name   = "fargate-auto-scaled-backend-ecs-codedeploy"
codedeploy_group_name = "fargate-auto-scaled-backend-ecs-blue-green-group"
region                = "eu-west-2"
private_vpc_name      = "ecs-private-vpc"
api_stage_name        = "dev"
container_port        = 3000