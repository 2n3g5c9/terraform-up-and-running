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
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}
// You need to manually add a secret in AWS Secrets Manager named mysql-master-password-stage.
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t3.micro"

  name              = "example_database"
  username          = "admin"
  password          = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]

  skip_final_snapshot = true
}
