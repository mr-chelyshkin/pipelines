variable "name" {
  description = "S3 bucket name."
  type        = string

  validation {
    condition     = var.name == lower(var.name)
    error_message = "The bucket name must be in lowercase."
  }
}

variable "name_prefix" {
  description = "S3 bucket name prefix to indicate details."
  type        = string

  validation {
    condition     = var.name_prefix == lower(var.name_prefix)
    error_message = "S3 bucket name prefix prefix must be in lowercase."
  }
}

variable "name_postfix" {
  description = "CodeBuild project name postfix to indicate details."
  type        = string

  validation {
    condition     = var.name_postfix == lower(var.name_postfix)
    error_message = "S3 bucket name postfix must be in lowercase."
  }
}

variable "tags" {
  description = "S3 bucket tags."
  type        = object({})
  default     = {}
}