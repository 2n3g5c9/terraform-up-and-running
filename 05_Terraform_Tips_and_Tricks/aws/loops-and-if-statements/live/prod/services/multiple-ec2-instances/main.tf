locals {
  region = "us-east-1"

  ami           = "ami-0885b1f6bd170450c" // ubuntu 20.04 LTS
  instance_type = "t4a.nano"              // 2 vCPUs for a 1h 12m burst / 0.5 GiB
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

resource "aws_instance" "example_1" {
  count         = 3
  ami           = local.ami
  instance_type = local.instance_type
}

resource "aws_instance" "example_2" {
  count             = length(data.aws_availability_zones.all.names)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  ami               = local.ami
  instance_type     = local.instance_type
}

data "aws_availability_zones" "all" {}
