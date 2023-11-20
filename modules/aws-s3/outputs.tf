output "bucket-id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket-arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket-name" {
  value = var.name
}