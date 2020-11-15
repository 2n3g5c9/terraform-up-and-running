terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"
}

// You need to manually add a secret in AWS Secrets Manager.
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_secret_id
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = var.db_instance_type

  name     = var.db_name
  username = "admin"
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]

  skip_final_snapshot = true
}
