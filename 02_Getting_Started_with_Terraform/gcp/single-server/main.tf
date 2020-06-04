provider "google" {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_instance" "single_server" {
  name         = "single-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }

  network_interface {
    network       = "default"
  }
}

