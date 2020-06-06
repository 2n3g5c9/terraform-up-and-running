provider "google" {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_instance" "this" {
  name         = "single-web-server"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network       = "default"
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash 
                            echo "Hello, World" > index.html 
                            nohup busybox httpd -f -p "${var.server_port}" & 
                            EOF
}

resource "google_compute_firewall" "this" {
  name        = var.firewall_name
  description = "Allows TCP inbound traffic on port ${var.server_port}"

  network     = "default"

  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }

  source_ranges = ["0.0.0.0/0"]
}
