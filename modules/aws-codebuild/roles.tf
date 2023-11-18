data "aws_iam_policy_document" "codebuild_policy" {
  dynamic "statement" {
    for_each = var.artifacts_enabled ? [1] : []

    content {
      actions = ["s3:PutObject"]
      resources = [
        "${aws_s3_bucket.codebuild_artifacts[0].arn}/*",
        aws_s3_bucket.codebuild_artifacts[0].arn
      ]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "PipelinesCodeBuildRole-${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  count  = var.artifacts_enabled ? 1 : 0
  name   = "pipelines-${var.name}"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.artifacts_enabled ? 1 : 0
  role       = aws_iam_role.codebuild_role.name
  policy_arn = var.artifacts_enabled ? aws_iam_policy.codebuild_policy[0].arn : ""
}