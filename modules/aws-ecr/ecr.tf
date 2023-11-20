resource "aws_ecr_repository" "ecr" {
  name                 = "${var.name_prefix}-${var.name}-${var.name_postfix}"
  image_tag_mutability = var.image_tag_mutability

  force_delete = true
  tags         = var.tags

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
