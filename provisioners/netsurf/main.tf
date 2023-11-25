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

module "image-hub" {
  source = "../../modules/aws-ecr"

  name         = local.name
  name_prefix  = local.prefix
  name_postfix = "ci_cd"
  tags         = local.tags
}

module "artifacts" {
  source = "../../modules/aws-s3"

  name         = local.name
  name_prefix  = local.prefix
  name_postfix = "artifacts"
  tags         = local.tags
}

module "deb_armv8-a_glibc-2-31" {
  source = "../../modules/aws-codebuild"

  name         = local.name
  name_prefix  = local.prefix
  name_postfix = "deb_armv8-a_glibc-2-31"
  tags         = local.tags

  arch          = "arm64"
  description   = "[NetSurf]:linux-deb_arm64-armv8-a_glibc-2-31-13"
  build_spec    = ".infra/build/linux_armv8-a/buildspec.yaml"
  source_url    = local.code_source
  source_branch = "main"

  credentials = {
    token : data.terraform_remote_state.variables.outputs.netsurf-github-pat
    useWebHooks : true
  }

  artifacts_bucket = {
    id : module.artifacts.bucket-id
    arn : module.artifacts.bucket-arn
    name : module.artifacts.bucket-name
  }
  image_hub = {
    image : module.image-hub.ecr-url
    tag : "deb-glibc_2-31-13"
    type : "ecr"
  }
  region = data.terraform_remote_state.variables.outputs.aws-region
}
