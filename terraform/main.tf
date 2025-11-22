data "aws_caller_identity" "account" {}

resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project_name}-github"
  provider_type = "GitHub"
}

resource "aws_codedeploy_app" "server" {
  compute_platform = "Server"
  name             = "${var.project_name}-docker"
}

module "deployment_group" {
  for_each              = toset(var.environments)
  source                = "./modules/deployment_group"
  deployment_group_name = "${var.project_name}-${each.key}"
  app_name              = aws_codedeploy_app.server.name
}

module "pipeline" {
  for_each = toset(var.environments)

  source    = "./modules/pipeline"
  base_name = "${var.project_name}-${each.key}-docker"

  github_connection_arn = aws_codestarconnections_connection.github.arn
  git_repo_name         = "jocelyn1110/FuFood"
  git_branch            = each.key
  deployment_group_name = "${var.project_name}-${each.key}"
  aws_region            = var.aws_region
  codebuild_image       = "aws/codebuild/standard:7.0"
  codedeploy_app_name   = aws_codedeploy_app.server.name
  is_arm                = true

  additional_build_env_vars = {
    AWS_ACCOUNT_ID = data.aws_caller_identity.account.account_id
    ENV            = each.key
  }
}
