output "ecr-url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "ecr-arn" {
  value = aws_ecr_repository.ecr.arn
}