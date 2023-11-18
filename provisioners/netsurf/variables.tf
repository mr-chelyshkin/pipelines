variable "variables_bucket_name" {
  description = "S3 bucket name."
  type        = string
  default     = "set from environment variable"
}

variable "variables_bucket_region" {
  description = "S3 bucket region."
  type        = string
  default     = "set from environment variable"
}

variable "variables_bucket_file" {
  description = "File with variables inside bucket."
  type        = string
  default     = "set from environment variable"
}
