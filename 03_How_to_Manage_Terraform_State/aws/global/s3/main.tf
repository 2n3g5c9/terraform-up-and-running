locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east-1"

  s3_bucket_name      = "${local.account}-${local.project}-state"
  dynamodb_table_name = "${local.project}-locks"
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

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name    = local.s3_bucket_name
    service = local.project
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
