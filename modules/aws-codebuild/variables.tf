variable "name" {
  description = "CodeBuild project name."
  type        = string
}

variable "description" {
  description = "CodeBuild project description."
  type        = string
}

variable "build_timeout" {
  description = "Build timeout in minutes."
  type        = string
  default     = "5"
}

variable "build_compute" {
  description = "Build compute type."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"

  validation {
    condition     = contains(["BUILD_GENERAL1_SMALL", "BUILD_GENERAL1_MEDIUM", "BUILD_GENERAL1_LARGE", "BUILD_GENERAL1_2XLARGE"], var.build_compute)
    error_message = "The build_compute must be one of the valid AWS CodeBuild compute types: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, or BUILD_GENERAL1_2XLARGE."
  }
}

variable "build_image" {
  description = "Build image container url."
  type        = string
}

variable "build_spec" {
  description = "Path to buildspec file in sources."
}

variable "source_url" {
  description = "GitHub url to project."
  type        = string

  validation {
    condition     = can(regex("^https://github.com/[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$", var.source_url))
    error_message = "The source_url must be a valid GitHub URL in the format 'https://github.com/username/repository'."
  }
}

variable "source_branch" {
  description = "GitHub branch."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.source_branch))
    error_message = "The source_branch must be a valid branch name containing only alphanumeric characters, underscores, periods, and dashes."
  }
}

variable "artifacts_enabled" {
  description = "Enable saving artifacts to bucket."
  type        = bool
}

variable "artifacts_path" {
  description = "List of artifacts path which will be pack as zip package."
  type        = list(string)
}