locals {
  instance_class = "db.t3.micro" // 2 vCPUs / 1 GiB

  service = "terraform-up-and-running"
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
  region = "us-east-1"
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "2n3g5c9-terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "this" {
  identifier_prefix = "${local.service}-"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = local.instance_class

  name     = var.db_name
  username = "admin"
  password = var.db_password

  skip_final_snapshot = true
}
