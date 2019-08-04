provider "google" {
  project = "terraform-up-and-running"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

# 03 - Cluster Web Servers
resource "google_compute_autoscaler" "cluster-web-servers-autoscaler" {
  name        = "cluster-web-servers-autoscaler"
  description = "Autoscaling policy for web servers"
  zone        = "europe-west1-b"
  target      = "${google_compute_instance_group_manager.cluster-web-servers-group.self_link}"

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_instance_template" "cluster-web-servers-template" {
  name           = "cluster-web-servers-template"
  description    = "Template for the instances in the group of web severs"
  machine_type   = "f1-micro"
  can_ip_forward = false

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  }

  network_interface {
    network = "cluster-web-servers-network"
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash 
                            echo "Hello, World" > index.html 
                            nohup busybox httpd -f -p "${var.server_port}" & 
                            EOF
}

resource "google_compute_forwarding_rule" "cluster-web-servers-rule" {
  name        = "cluster-web-servers-rule"
  description = "Forwarding rule for the load balancer on web servers"
  target      = "${google_compute_target_pool.cluster-web-servers-target.self_link}"
  port_range  = "80"
}

resource "google_compute_target_pool" "cluster-web-servers-target" {
  name        = "cluster-web-servers-target"
  description = "Pool of web servers"

  health_checks = [
    "${google_compute_http_health_check.cluster-web-servers-health-check.name}",
  ]
}

resource "google_compute_instance_group_manager" "cluster-web-servers-group" {
  name        = "cluster-web-servers-group"
  description = "Group manager of web servers"
  zone        = "europe-west1-b"

  instance_template = "${google_compute_instance_template.cluster-web-servers-template.self_link}"

  target_pools       = ["${google_compute_target_pool.cluster-web-servers-target.self_link}"]
  base_instance_name = "web-server"
}

resource "google_compute_network" "cluster-web-servers-network" {
  name        = "cluster-web-servers-network"
  description = "Network for the cluster of web servers example"
}

resource "google_compute_http_health_check" "cluster-web-servers-health-check" {
  name         = "cluster-web-servers-health-check"
  description  = "Health checks on port 8080 of the instances in the group of web servers"
  request_path = "/"
  port         = 8080

  timeout_sec        = 1
  check_interval_sec = 1
}
