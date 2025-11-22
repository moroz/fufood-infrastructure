resource "aws_s3_bucket" "backups" {
  for_each = toset(var.environments)

  bucket = "${var.project_name}-${each.key}-db-backups"
}

data "aws_iam_policy_document" "backup_upload_policy" {
  for_each = aws_s3_bucket.backups

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "${each.value.arn}/*"
    ]
  }

}

resource "aws_iam_user_policy" "backup_upload_policy" {
  for_each = aws_s3_bucket.backups

  user   = aws_iam_user.on_premises_user[each.key].id
  name   = "${each.value.bucket}-upload-policy"
  policy = data.aws_iam_policy_document.backup_upload_policy[each.key].json
}

resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  for_each = aws_s3_bucket.backups

  bucket = each.value.bucket

  rule {
    id = "expire-backups"

    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
