variable "name" {
  description = "ECR repository name."
  type        = string

  validation {
    condition     = var.name == lower(var.name)
    error_message = "ECR repository name must be in lowercase."
  }
}

variable "name_prefix" {
  description = "CodeBuild project name prefix to indicate details."
  type        = string

  validation {
    condition     = var.name_prefix == lower(var.name_prefix)
    error_message = "ECR repository name prefix must be in lowercase."
  }
}

variable "name_postfix" {
  description = "CodeBuild project name postfix to indicate details."
  type        = string

  validation {
    condition     = var.name_postfix == lower(var.name_postfix)
    error_message = "ECR repository name postfix must be in lowercase."
  }
}

variable "image_tag_mutability" {
  description = "Image tag mutability settings."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  type        = bool
  default     = false
}

variable "tags" {
  description = "ECR repository tags."
  type        = object({})
  default     = {}
}
