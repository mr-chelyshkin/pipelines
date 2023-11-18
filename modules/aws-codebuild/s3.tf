resource "aws_s3_bucket" "codebuild_artifacts" {
  count         = var.artifacts_enabled ? 1 : 0
  bucket        = "codebuild-artifacts-${var.name}"
  force_destroy = true

  tags = {
    "definition" : "pipelines"
    "source" : var.source_url
    "project" : var.name
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_versioning" "codebuild_artifacts_versioning" {
  count  = var.artifacts_enabled ? 1 : 0
  bucket = aws_s3_bucket.codebuild_artifacts[0].id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "codebuild_artifacts_block_public_access" {
  count                   = var.artifacts_enabled ? 1 : 0
  bucket                  = aws_s3_bucket.codebuild_artifacts[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}