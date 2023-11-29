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

  tags = {
    "definition" : local.prefix
    "source" : local.code_source
    "project" : local.name
  }
}

module "artifacts" {
  source = "../../modules/aws-s3"

  name         = local.name
  name_prefix  = local.prefix
  name_postfix = "artifacts"

  tags = {
    "definition" : local.prefix
    "source" : local.code_source
    "project" : local.name
  }
}

module "distribute" {
  source = "../../modules/aws-cloudfront-dist"

  name          = local.name
  name_prefix   = local.prefix
  bucket_domain = module.artifacts.bucket-domain
  bucket_id     = module.artifacts.bucket-id
  bucket_arn    = module.artifacts.bucket-arn

  tags = {
    "definition" : local.prefix
    "source" : local.code_source
    "project" : local.name
  }
}

module "deb_armv8-a_glibc-2-31" {
  source = "../../modules/aws-codebuild"

  name          = local.name
  name_prefix   = local.prefix
  source_url    = local.code_source
  source_branch = "main"
  region        = data.terraform_remote_state.variables.outputs.aws-region

  name_postfix = "deb_armv8-a_glibc-2-31"
  arch         = "arm64"
  description  = "[NetSurf]:linux-deb_arm64-armv8-a_glibc-2-31-13"
  build_spec   = ".infra/build/linux_armv8-a/buildspec.yaml"

  tags = {
    "definition" : local.prefix
    "source" : local.code_source
    "project" : local.name
  }

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
    name : module.image-hub.ecr-name
    image : module.image-hub.ecr-url
    tag : "deb-glibc_2-31-13"
    type : "ecr"
  }
}
