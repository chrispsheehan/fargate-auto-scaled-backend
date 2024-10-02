resource "aws_codedeploy_app" "ecs_app" {
  name             = var.codedeploy_app_name
  compute_platform = "ECS"
}

resource "aws_iam_role" "this" {
  name               = "${var.project_name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_policy.json
}

resource "aws_iam_policy" "elb_policy" {
  name        = "${var.project_name}-ELBPolicy"
  description = "Policy for ELB actions"
  policy      = data.aws_iam_policy_document.elb_policy.json
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "${var.project_name}-ECSPolicy"
  description = "Policy for ECS actions"
  policy      = data.aws_iam_policy_document.ecs_policy.json
}

resource "aws_iam_policy" "codedeploy_policy" {
  name        = "${var.project_name}-CodeDeployPolicy"
  description = "Policy for CodeDeploy actions"
  policy      = data.aws_iam_policy_document.codedeploy_policy.json
}

resource "aws_iam_policy" "autoscaling_policy" {
  name        = "${var.project_name}-AutoScalingPolicy"
  description = "Policy for Auto Scaling actions"
  policy      = data.aws_iam_policy_document.autoscaling_policy.json
}

resource "aws_iam_policy" "s3_policy" {
  name        = "${var.project_name}-S3Policy"
  description = "Policy for S3 actions"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_policy" "passrole_policy" {
  name        = "${var.project_name}-PassRolePolicy"
  description = "Policy for IAM PassRole action"
  policy      = data.aws_iam_policy_document.passrole_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_elb_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.elb_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecs_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_codedeploy_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.codedeploy_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_autoscaling_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_passrole_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.passrole_policy.arn
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.ecs_app.name
  deployment_config_name = var.deployment_config_name
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
      termination_wait_time_in_minutes = 1
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