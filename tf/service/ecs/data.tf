data "aws_ecr_repository" "this" {
  name = var.project_name
}

data "aws_ecr_image" "this" {
  repository_name = data.aws_ecr_repository.this.name
  most_recent     = true
}
