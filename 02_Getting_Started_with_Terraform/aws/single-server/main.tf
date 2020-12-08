locals {
  service = "single-server"
  region  = "us-east-1"

  ami           = "ami-0885b1f6bd170450c" // ubuntu 20.04 LTS
  instance_type = "t3a.nano"              // 2 vCPUs for a 1h 12m burst / 0.5 GiB
}

terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = local.region
}

resource "aws_instance" "this" {
  ami           = local.ami
  instance_type = local.instance_type

  tags = {
    Name    = local.service
    service = local.service
  }
}
