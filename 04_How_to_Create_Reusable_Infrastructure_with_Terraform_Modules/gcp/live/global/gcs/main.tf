locals {
  account = "2n3g5c9"
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "${local.region}-b"
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

resource "google_storage_bucket" "tf_state" {
  name = "${local.account}-${local.project}-state"

  location      = local.region
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  force_destroy = false

  labels = {
    service = local.project
  }
}