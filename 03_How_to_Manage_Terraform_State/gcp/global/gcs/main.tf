locals {
  service = "terraform-up-and-running"
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
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_storage_bucket" "tf_state" {
  name = "2n3g5c9-${local.service}-state"

  location      = "us-east1"
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  force_destroy = false

  labels = {
    service = local.service
  }
}