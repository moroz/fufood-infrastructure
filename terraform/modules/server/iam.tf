data "aws_caller_identity" "account" {}

resource "aws_iam_instance_profile" "_" {
  name = "${var.namespace}-ec2-instance-profile"
  role = aws_iam_role._.name
}

data "aws_iam_policy_document" "ec2_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "_" {
  name = "${var.namespace}-ec2-instance-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy.json
}
resource "aws_iam_role_policy" "ec2" {
  name = "${var.namespace}-ec2-policy"
  role = aws_iam_role._.id

  policy = data.aws_iam_policy_document.on_premises_permissions.json
}

data "aws_iam_policy_document" "on_premises_permissions" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]

    resources = ["*"]
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

    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.account.account_id}:log-group:/logs/${var.project_name}/${var.env}/*:*"
    ]
  }
}
