locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east-1"
  env     = "stage"

  service = "mysql"

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
    region = local.region
    bucket = "${local.account}-${local.project}-state"
    key    = "${local.env}/data-stores/${local.service}/terraform.tfstate"

    dynamodb_table = "${local.project}-locks"
    encrypt        = true
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
