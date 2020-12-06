locals {
  db_instance_type = "db.t3.micro" // 2 vCPUs / 1 GiB
  db_name          = "example_database_stage"
  db_secret_id     = "mysql-master-password-stage"
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
    bucket = "2n3g5c9-terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_instance_type = local.db_instance_type
  db_name          = local.db_name
  db_secret_id     = local.db_secret_id
}
