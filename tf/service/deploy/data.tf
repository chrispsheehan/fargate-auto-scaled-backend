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
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "codedeploy:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
