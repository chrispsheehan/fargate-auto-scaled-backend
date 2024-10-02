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

data "aws_iam_policy_document" "codedeploy_policy" {
  statement {
    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DeregisterTargets",
      "ecs:UpdateTaskSet",
      "ecs:UpdateService",
      "ecs:DescribeTaskSets",
      "ecs:DescribeServices",
      "ecs:DeleteTaskSet",
      "ecs:CreateTaskSet",
      "codedeploy:StopDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:CreateDeployment",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:DescribeAutoScalingGroups"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      data.aws_s3_bucket.app_specs.arn,
      "${data.aws_s3_bucket.app_specs.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}
