locals {
  service = "single-web-server"

  image        = "ubuntu-os-cloud/ubuntu-2004-lts"
  machine_type = "e2-micro"
}

provider "google" {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_address" "this" {
  name         = local.service
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
      nat_ip = google_compute_address.this.address
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
