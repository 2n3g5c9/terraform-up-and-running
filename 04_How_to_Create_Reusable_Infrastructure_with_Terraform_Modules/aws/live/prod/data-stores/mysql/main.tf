locals {
  db_instance_type = "db.t3.micro"
  db_name          = "example_database_prod"
  db_secret_id     = "mysql-master-password-prod"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"
}

terraform {
  backend "s3" {
    bucket = "2n3g5c9-terraform-up-and-running-state"
    key    = "prod/data-stores/mysql/terraform.tfstate"
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
