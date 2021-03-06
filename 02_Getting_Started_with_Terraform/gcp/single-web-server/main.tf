locals {
  project = "terraform-up-and-running"
  service = "single-web-server"
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

resource "google_compute_address" "this" {
  name        = local.service
  description = "IP address of the Load Balancer"

  address_type = "EXTERNAL"
  network_tier = "STANDARD"
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

    access_config {
      network_tier = "STANDARD"
      nat_ip       = google_compute_address.this.address
    }
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash 
                            echo "Hello, World" > index.html 
                            nohup busybox httpd -f -p "${var.server_port}" & 
                            EOF

  labels = {
    service = local.service
  }
}

resource "google_compute_firewall" "this" {
  name        = var.firewall_name
  description = "Allows TCP inbound traffic on port ${var.server_port}"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }

  source_ranges = ["0.0.0.0/0"]
}
