locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "${local.region}-b"
  env     = "prod"

  image        = "ubuntu-os-cloud/ubuntu-2004-lts"
  machine_type = "f1-micro" // 1 vCPU for 20% / 0.6 GB
  min_size     = 2
  max_size     = 2
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
    prefix = "prod/services/cluster-web-servers/terraform.tfstate"
  }
}

module "cluster-web-servers" {
  source = "../../../../modules/services/cluster-web-servers"

  project                = local.project
  db_remote_state_bucket = "${local.account}-${local.project}-state"
  db_remote_state_key    = "${local.env}/data-stores/mysql/terraform.tfstate"

  image        = local.image
  machine_type = local.machine_type
  min_size     = local.min_size
  max_size     = local.max_size
}
