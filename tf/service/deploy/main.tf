resource "aws_codedeploy_app" "ecs_app" {
  name             = var.codedeploy_app_name
  compute_platform = "ECS"
}

resource "aws_iam_role" "this" {
  name               = "${var.project_name}-codedeploy_role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_policy.json
}

resource "aws_iam_role_policy" "codedeploy_role_policy" {
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.codedeploy_policy.json
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name = aws_codedeploy_app.ecs_app.name
  # Shifts 10% of the traffic in the first increment, then shifts the remaining 90% after 5 minutes
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"
  deployment_group_name  = var.codedeploy_group_name
  service_role_arn       = aws_iam_role.this.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.lb_listener_arn]
      }

      target_group {
        name = var.lb_blue_target_group
      }

      target_group {
        name = var.lb_green_target_group
      }
    }
  }
}