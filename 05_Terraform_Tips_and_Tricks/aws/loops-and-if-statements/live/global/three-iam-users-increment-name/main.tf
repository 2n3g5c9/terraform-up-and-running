locals {
  region = "us-east-1"
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

resource "aws_iam_user" "example" {
  count = 3

  name = "${var.user_name_prefix}.${count.index}"
}
