terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.region]
    }
  }
}

resource "aws_instance" "_" {
  ami                    = var.server_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile._.name

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name                = var.namespace
    DeploymentGroupName = var.namespace
  }

  root_block_device {
    volume_size = var.storage_size
  }
}

resource "aws_eip" "_" {
  instance = aws_instance._.id
}

output "eip" {
  value = aws_eip._
}
