terraform {
  backend "s3" {
    bucket = "set from '-backend-config' flag"
    region = "set from '-backend-config' flag"
    key    = "set from '-backend-config' flag"
  }
}

data "terraform_remote_state" "variables" {
  backend = "s3"
  config = {
    bucket = var.variables_bucket_name
    region = var.variables_bucket_region
    key    = var.variables_bucket_file
  }
}

module "codebuild" {
  source = "../../modules/aws-codebuild"

  description       = "NetSerf binary, os: linux, arch: arm64, march: armv8-a"
  name              = "netsurf"
  name_postfix      = "linux_armv8-a"
  build_image       = "chelyshkin/netsurf-ci:latest-arm64"
  build_spec        = "./buildspec.yaml"
  artifacts_path    = ["./bin/netsurf"]
  artifacts_enabled = true
  source_url        = "https://github.com/mr-chelyshkin/NetSurf"
  source_branch     = "main"
}
