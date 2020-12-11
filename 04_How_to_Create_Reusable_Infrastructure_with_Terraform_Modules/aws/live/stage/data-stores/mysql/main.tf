locals {
  project = "terraform-up-and-running"
  region  = "us-east-1"
  env     = "stage"

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
    region = "us-east-1"
    bucket = "2n3g5c9-terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  project = local.project

  db_instance_type = local.db_instance_type
  db_name          = local.db_name
  db_secret_id     = local.db_secret_id
}
