provider "google" {
  project = "terraform-up-and-running"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

# 01 - Single Server
resource "google_compute_instance" "single-server" {
  name         = "single-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network       = "single-server-network"
    access_config = {}
  }
}

resource "google_compute_network" "single-server-network" {
  name        = "single-server-network"
  description = "Network for the single server example"
}
