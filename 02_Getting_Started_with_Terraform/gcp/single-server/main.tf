locals {
  project = "terraform-up-and-running"
  service = "single-server"
  region  = "us-east1"
  zone    = "${local.region}b"

  image        = "ubuntu-os-cloud/ubuntu-2004-lts"
  machine_type = "f1-micro" // 1 vCPU for 20% / 0.6 GB
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

resource "google_compute_instance" "this" {
  name         = local.service
  machine_type = local.machine_type

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = "default"
  }

  labels = {
    service = local.service
  }
}
