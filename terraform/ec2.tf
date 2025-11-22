resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-karol"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFz7SoZaDJkeaVbnqfd/n0u3uha3TYHESbRYlIbOCIAn"
}

data "aws_ami" "debian_trixie_arm" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-13-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  owners = ["136693071363"] # Debian official
}


module "server" {
  for_each = toset(var.environments)

  env          = each.key
  source       = "./modules/server"
  namespace    = "${var.project_name}-${each.key}"
  key_name     = "${var.project_name}-karol"
  server_ami   = data.aws_ami.debian_trixie_arm.id
  project_name = var.project_name

  providers = {
    aws.region = aws.tokyo
  }
}
