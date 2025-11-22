variable "env" {
  type = string
}

variable "project_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "server_ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t4g.micro"
}

variable "key_name" {
  type = string
}

variable "storage_size" {
  type    = number
  default = 30
}
