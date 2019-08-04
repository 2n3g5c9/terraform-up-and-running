provider "google" {
  project = "terraform-up-and-running"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

output "single-web-server-public_ip" {
  value = "${google_compute_instance.single-web-server.network_interface.0.access_config.0.nat_ip}"
}

# 02 - Single Web Server
resource "google_compute_instance" "single-web-server" {
  name         = "single-web-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network       = "single-web-server-network"
    access_config = {}
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash 
                            echo "Hello, World" > index.html 
                            nohup busybox httpd -f -p "${var.server_port}" & 
                            EOF
}

resource "google_compute_firewall" "default" {
  name        = "web-server-firewall"
  description = "Allows TCP inbound traffic on port ${var.server_port}"
  network     = "single-web-server-network"

  allow {
    protocol = "tcp"
    ports    = ["${var.server_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_network" "single-web-server-network" {
  name        = "single-web-server-network"
  description = "Network for the single web server example"
}
