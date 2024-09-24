data "aws_ecr_repository" "this" {
  name = var.project_name
}

data "aws_ecr_image" "this" {
  repository_name = data.aws_ecr_repository.this.name
  most_recent     = true
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
