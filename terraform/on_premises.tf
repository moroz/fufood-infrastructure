locals {
  on_premises_pipeline_buckets = [
    for name, pipeline in module.pipeline :
    "${pipeline.pipeline_artifacts_bucket.arn}/*"
  ]
}

resource "aws_iam_user" "on_premises_user" {
  for_each = toset(var.environments)
  name     = "${var.project_name}-${each.key}-on-premises-user"
}

data "aws_iam_policy_document" "on_premises_permissions" {
  for_each = toset(var.environments)

  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]

    resources = concat([
      "arn:aws:s3:::aws-codedeploy-${var.aws_region}/*"
    ], local.on_premises_pipeline_buckets)
  }

  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject",
      "s3:PutObject*",
      "s3:DeleteObject",
    ]

    resources = [
      "${module.assets_cdn[each.key].bucket.arn}/*",
      "${module.assets_cdn[each.key].bucket.arn}"
    ]
  }

  statement {
    actions = ["codedeploy:*"]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      for key, repo in aws_ecr_repository.ecr : repo.arn
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.account.account_id}:log-group:/logs/${var.project_name}/${each.key}/*:*"
    ]
  }

}

resource "aws_iam_user_policy" "on_premises_user" {
  for_each = aws_iam_user.on_premises_user
  user     = each.value.id
  name     = "${each.value.name}-policy"
  policy   = data.aws_iam_policy_document.on_premises_permissions[each.key].json
}
