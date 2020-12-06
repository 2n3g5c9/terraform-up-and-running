locals {
  instance_type = "t3a.nano" // 2 vCPUs for a 1h 12m burst / 0.5 GiB
  min_size      = 2
  max_size      = 2
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
    key    = "stage/services/cluster-web-servers/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "cluster_web_servers" {
  source = "../../../../modules/services/cluster-web-servers"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "2n3g5c9-terraform-up-and-running-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = local.instance_type
  min_size      = local.min_size
  max_size      = local.max_size
}