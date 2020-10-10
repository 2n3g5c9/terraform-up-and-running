locals {
  service = "single-server"

  image        = "ubuntu-os-cloud/ubuntu-2004-lts"
  machine_type = "e2-micro"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "google" {
  version = "~> 3.0"

  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
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
