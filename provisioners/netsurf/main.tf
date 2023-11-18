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

  name              = "netsurf"
  description       = "App for manage Wi-Fi from console"
  build_image       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  build_spec        = "./buildspec.yaml"
  artifacts_path    = ["./bin/netsurf"]
  artifacts_enabled = true
  source_url        = "https://github.com/mr-chelyshkin/NetSurf"
  source_branch     = "main"
}
