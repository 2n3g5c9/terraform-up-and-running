locals {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "${local.region}-b"
  env     = "prod"
}

terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
}

terraform {
  backend "gcs" {
    bucket = "2n3g5c9-terraform-up-and-running-state"
    prefix = "stage/data-stores/mysql/terraform.tfstate"
  }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  project = local.project

  db_name     = "${local.project}-${local.env}"
  db_password = var.db_password
}
