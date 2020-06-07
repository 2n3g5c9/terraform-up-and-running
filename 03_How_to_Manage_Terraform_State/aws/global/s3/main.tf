locals {
  service = "terraform-up-and-running"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "2n3g5c9-${local.service}-state"

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
    Name    = "2n3g5c9-${local.service}-state"
    service = local.service
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.service}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}