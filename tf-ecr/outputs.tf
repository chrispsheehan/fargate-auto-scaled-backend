output "ecr_registry_id" {
  value = aws_ecr_repository.this.registry_id
}

output "ecr_repository_name" {
  value = aws_ecr_repository.this.name
}
