variable "env" {
  type = string
}

variable "environments" {
  type    = list(string)
  default = ["staging"]
}

variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "docker_repos" {
  type    = list(string)
  default = []
}
