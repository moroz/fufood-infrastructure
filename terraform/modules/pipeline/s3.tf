resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket        = local.artifact_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.bucket

  rule {
    id     = "expire-artifacts"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}
