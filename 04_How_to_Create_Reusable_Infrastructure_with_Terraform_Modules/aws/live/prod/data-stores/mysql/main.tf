locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east-1"
  env     = "prod"

  db_instance_type = "db.t3.micro" // 2 vCPUs / 1 GiB
  db_name          = "example_database_${local.env}"
  db_secret_id     = "mysql-master-password-${local.env}"
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
    bucket = "${local.account}-${local.project}-state"
    key    = "${local.env}/data-stores/mysql/terraform.tfstate"
    region = local.region

    dynamodb_table = "${local.project}-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_instance_type = local.db_instance_type
  db_name          = local.db_name
  db_secret_id     = local.db_secret_id
}
