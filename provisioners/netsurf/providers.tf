provider "aws" {
  region = data.terraform_remote_state.variables.outputs.aws-region
}