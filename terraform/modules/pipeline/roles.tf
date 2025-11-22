resource "aws_iam_role" "codepipeline_role" {
  name               = local.codepipeline_role_name
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_policy.json
}

resource "aws_iam_role_policy" "codepipeline_role" {
  name = "${local.codepipeline_role_name}-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = file("./policies/codepipeline_policy.json")
}

resource "aws_iam_role_policy" "codebuild_role" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.build_role_policy.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = local.codebuild_role_name
  assume_role_policy = data.aws_iam_policy_document.build_role_assume_policy.json
}
