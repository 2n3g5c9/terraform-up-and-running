locals {
  project = "terraform-up-and-running"
  region  = "us-east-1"

  instance_class = "db.t3.micro" // 2 vCPUs / 1 GiB
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

terraform {
  backend "s3" {
    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

    # bucket         = "<YOUR S3 BUCKET>"
    # key            = "<SOME PATH>/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "<YOUR DYNAMODB TABLE>"
    # encrypt        = true
  }
}

resource "aws_db_instance" "this" {
  identifier_prefix = "${local.project}-"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = local.instance_class

  name     = var.db_name
  username = "admin"
  password = var.db_password

  skip_final_snapshot = true
}
