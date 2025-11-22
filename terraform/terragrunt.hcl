locals {
  env         = get_env("ENV", "staging")
  secrets   = yamldecode(file("./vars/vars.yml"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-${local.secrets.project_name}-${local.env}-${local.secrets.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    profile        = local.secrets.aws_profile
    region         = local.secrets.aws_region
    dynamodb_table = "terraform-locks-${local.secrets.aws_region}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "${local.secrets.aws_region}"
  profile = "${local.secrets.aws_profile}"
}
EOF
}

inputs = merge(
  local.secrets,
  {
    env = local.env
  }
)

