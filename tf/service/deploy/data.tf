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
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "codedeploy:*"
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
}
