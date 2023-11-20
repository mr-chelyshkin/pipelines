data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${var.region}:*:log-group:/aws/codebuild/${var.name_prefix}-${var.name}-${var.name_postfix}:*",
      "arn:aws:logs:${var.region}:*:log-group:/aws/codebuild/${var.name_prefix}-${var.name}-${var.name_postfix}"
    ]
  }

  dynamic "statement" {
    for_each = var.artifacts_bucket != null ? [1] : []

    content {
      actions = ["s3:PutObject"]
      resources = [
        "${var.artifacts_bucket.arn}/*",
        var.artifacts_bucket.arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.image_hub.type == "ecr" ? [1] : []

    content {
      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken",
      ]
      resources = [
        "arn:aws:ecr:${var.region}:*:repository/${var.image_hub.image}",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.name_prefix}-${var.name}-CodeBuildRole"

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
  count  = var.artifacts_bucket != null ? 1 : 0
  name   = "${var.name_prefix}-${var.name}-CodeBuildPolicy"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.artifacts_bucket != null ? 1 : 0
  role       = aws_iam_role.codebuild_role.name
  policy_arn = var.artifacts_bucket != null ? aws_iam_policy.codebuild_policy[0].arn : ""
}