locals {
  service = "single-server"

  ami           = "ami-0885b1f6bd170450c" // ubuntu 20.04 LTS
  instance_type = "t3.nano"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"
}

resource "aws_instance" "this" {
  ami           = local.ami
  instance_type = local.instance_type

  tags = {
    Name    = local.service
    service = local.service
  }
}
