resource "aws_codebuild_project" "codebuild" {
  name           = "pipelines-${var.name}-${var.name_postfix}"
  description    = var.description
  service_role   = aws_iam_role.codebuild_role.arn
  build_timeout  = var.build_timeout
  source_version = var.source_branch

  tags = {
    "definition" : "pipelines"
    "source" : var.source_url
    "project" : var.name
  }

  source {
    type            = "GITHUB"
    location        = var.source_url
    buildspec       = var.build_spec
    git_clone_depth = 1
  }

  environment {
    compute_type                = var.build_compute
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  dynamic "artifacts" {
    for_each = var.artifacts_enabled ? var.artifacts_path : []
    content {
      type           = "S3"
      location       = aws_s3_bucket.codebuild_artifacts[0].bucket
      path           = dirname(artifacts.value)
      name           = basename(artifacts.value)
      namespace_type = "NONE"
      packaging      = "ZIP"
    }
  }
  dynamic "artifacts" {
    for_each = var.artifacts_enabled ? [] : [1]
    content {
      type = "NO_ARTIFACTS"
    }
  }
}
