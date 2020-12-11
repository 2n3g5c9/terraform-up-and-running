locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east-1"
  env     = "prod"

  service = "cluster-web-servers"

  ami           = "ami-0885b1f6bd170450c" // ubuntu 20.04 LTS
  instance_type = "t3a.nano"              // 2 vCPUs for a 1h 12m burst / 0.5 GiB
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
  region = local.region
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "2n3g5c9-terraform-up-and-running-state"
    key    = "prod/services/cluster-web-servers/terraform.tfstate"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "cluster_web_servers" {
  source = "../../../../modules/services/cluster-web-servers"

  cluster_name           = "webservers-${local.env}"
  db_remote_state_bucket = "${local.account}-${local.project}-state"
  db_remote_state_key    = "${local.env}/data-stores/mysql/terraform.tfstate"

  ami           = local.ami
  instance_type = local.instance_type
  min_size      = local.min_size
  max_size      = local.max_size
}