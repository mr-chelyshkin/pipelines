variable "bucket_arn" {
  description = "CloudFront distribution S3 bucket ARN."
  type        = string
}

variable "bucket_id" {
  description = "CloudFront distribution S3 bucket ARN."
  type        = string
}

variable "bucket_domain" {
  description = "CloudFront distribution S3 bucket domain."
  type        = string
}

variable "name" {
  description = "CloudFront project name."
  type        = string

  validation {
    condition     = var.name == lower(var.name)
    error_message = "The CloudFront project name must be in lowercase."
  }
}

variable "name_prefix" {
  description = "CloudFront project name prefix to indicate details."
  type        = string

  validation {
    condition     = var.name_prefix == lower(var.name_prefix)
    error_message = "The CloudFront project name prefix must be in lowercase."
  }
}

variable "tags" {
  description = "CloudFront tags."
  type        = map(string)
  default     = {}
}