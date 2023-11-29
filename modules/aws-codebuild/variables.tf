variable "region" {
  description = "AWS region."
  type        = string
}

variable "name" {
  description = "CodeBuild project name."
  type        = string

  validation {
    condition     = var.name == lower(var.name)
    error_message = "The CodeBuild project name must be in lowercase."
  }
}

variable "credentials" {
  description = "Source repository credentials"
  type = object({
    token       = string
    useWebHooks = bool
  })
  default = null
}

variable "name_prefix" {
  description = "CodeBuild project name prefix to indicate details."
  type        = string

  validation {
    condition     = var.name_prefix == lower(var.name_prefix)
    error_message = "The CodeBuild project name prefix must be in lowercase."
  }
}

variable "name_postfix" {
  description = "CodeBuild project name postfix to indicate details."
  type        = string

  validation {
    condition     = var.name_postfix == lower(var.name_postfix)
    error_message = "The CodeBuild project name postfix must be in lowercase."
  }
}

variable "arch" {
  description = "Architecture type for the build environment (arm64 or amd64)."
  type        = string

  validation {
    condition     = contains(["arm64", "amd64"], var.arch)
    error_message = "The arch must be either 'arm64' or 'amd64'."
  }
}

variable "description" {
  description = "CodeBuild project description."
  type        = string
}

variable "tags" {
  description = "CodeBuild tags."
  type        = map(string)
  default     = {}
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

variable "artifacts_path" {
  description = "S3 path for save artifact."
  type        = string
  default     = "releases"
}

variable "artifacts_bucket" {
  description = "S3 bucket data."
  type = object({
    id   = string
    arn  = string
    name = string
  })
  default = null
}

variable "image_hub" {
  description = "Information about the Docker image and its source."
  type = object({
    name  = string
    image = string
    tag   = string
    type  = string
  })

  validation {
    condition     = contains(["ecr", "dockerhub"], var.image_hub.type)
    error_message = "The image type must be 'ecr' or 'dockerhub'."
  }
}
