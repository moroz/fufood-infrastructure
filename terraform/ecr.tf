resource "aws_ecr_repository" "ecr" {
  for_each = toset(var.docker_repos)

  name                 = "${var.project_name}-${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_lifecycle_policy_document" "ecr" {
  rule {
    priority = 1

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 10
    }
  }
}

resource "aws_ecr_lifecycle_policy" "ecr" {
  for_each = aws_ecr_repository.ecr

  repository = each.value.name
  policy     = data.aws_ecr_lifecycle_policy_document.ecr.json
}
