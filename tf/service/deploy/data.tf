data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "app_specs" {
  bucket = var.app_specs_bucket
}

data "aws_iam_policy_document" "codedeploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "elb_policy" {
  statement {
    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateListener"
    ]
    effect = "Allow"
    resources = [
      var.load_balancer_arn,
      var.lb_green_target_group_arn,
      var.lb_blue_target_group_arn
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeRules"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = [
      "ecs:UpdateTaskSet",
      "ecs:UpdateService",
      "ecs:DescribeTaskSets",
      "ecs:DescribeServices",
      "ecs:DeleteTaskSet",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet"
    ]
    effect = "Allow"
    resources = [
      var.cluster_arn,
      local.ecs_service_arn
    ]
  }
}

data "aws_iam_policy_document" "codedeploy_policy" {
  statement {
    actions = [
      "codedeploy:StopDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:CreateDeployment"
    ]
    effect = "Allow"
    resources = [
      aws_codedeploy_app.ecs_app.arn,
      aws_codedeploy_deployment_group.this.arn
    ]
  }
}

data "aws_iam_policy_document" "autoscaling_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribePolicies",
      "autoscaling:PutScalingPolicy",
      "autoscaling:ExecutePolicy",
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    effect = "Allow"
    resources = [
      local.ecs_service_arn,
      var.appautoscaling_policy_scale_up_arn,
      var.appautoscaling_policy_scale_down_arn
    ]
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      data.aws_s3_bucket.app_specs.arn,
      "${data.aws_s3_bucket.app_specs.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "passrole_policy" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
    ]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}
