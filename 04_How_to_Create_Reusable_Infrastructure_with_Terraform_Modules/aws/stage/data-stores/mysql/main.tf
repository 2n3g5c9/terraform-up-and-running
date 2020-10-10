terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
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
  source = "../../../modules/data-stores/mysql"

  db_name = "example_database_stage"
  db_secret_id = "mysql-master-password-stage"
}
