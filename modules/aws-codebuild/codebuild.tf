resource "aws_codebuild_project" "codebuild" {
  name           = "${var.name_prefix}-${var.name}-${var.name_postfix}"
  description    = var.description
  service_role   = aws_iam_role.codebuild_role.arn
  build_timeout  = var.build_timeout
  source_version = var.source_branch
  tags           = var.tags

  source {
    type            = "GITHUB"
    location        = var.source_url
    buildspec       = var.build_spec
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

  environment {
    compute_type = var.build_compute
    image        = "${var.image_hub.image}:${var.image_hub.tag}"
    type         = var.arch == "arm64" ? "ARM_CONTAINER" : "LINUX_CONTAINER"

    image_pull_credentials_type = var.image_hub.type == "ecr" ? "SERVICE_ROLE" : "CODEBUILD"
  }

  artifacts {
    type     = var.artifacts_bucket != null ? "S3" : "NO_ARTIFACTS"
    location = var.artifacts_bucket != null ? var.artifacts_bucket.id : null
    path     = var.artifacts_bucket != null ? var.artifacts_path : null
  }
}

resource "aws_codebuild_source_credential" "source_credential" {
  count       = var.credentials != null ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.credentials.token
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  count        = var.credentials.useWebHooks ? 1 : 0
  project_name = aws_codebuild_project.codebuild.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "refs/tags/v[0-9]+\\.[0-9]+\\.[0-9]+$"
    }
  }
}

