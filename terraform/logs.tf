locals {
  services = ["backend"]

  log_groups_product = setproduct(var.environments, local.services)

  log_groups = {
    for pair in local.log_groups_product : "${pair[1]}-${pair[0]}" => {
      name    = "/logs/${var.project_name}/${pair[0]}/${pair[1]}"
      env     = pair[0]
      service = pair[1]
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  for_each = local.log_groups

  name              = each.value["name"]
  retention_in_days = 30

  tags = {
    Environment = each.value["env"]
    Service     = each.value["service"]
  }
}
