provider "google" {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_instance_template" "this" {
  name        = "cluster-web-servers-template"
  description = "Template for the instances in the group of web servers"

  machine_type   = "e2-micro"
  can_ip_forward = false

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = <<-EOF
                            #!/bin/bash
                            echo "Hello, World" > index.html
                            nohup busybox httpd -f -p "${var.server_port}" &
                            EOF
}

resource "google_compute_http_health_check" "this" {
  name        = "cluster-web-servers-hc"
  description = "Health checks on port 8080 of the instances in the group of web servers"

  request_path = "/"
  port         = var.server_port

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10
}

resource "google_compute_target_pool" "this" {
  name        = "cluster-web-servers-target"
  description = "Pool of web servers"

  health_checks = [
    google_compute_http_health_check.this.name,
  ]
}

resource "google_compute_instance_group_manager" "this" {
  name        = "cluster-web-servers-group"
  description = "Group manager of web servers"

  base_instance_name = "web-server"

  version {
    instance_template = google_compute_instance_template.this.id
  }

  named_port {
    name = "http"
    port = var.server_port
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.this.id
    initial_delay_sec = 300
  }

  target_pools = [google_compute_target_pool.this.id]
}

resource "google_compute_autoscaler" "this" {
  name        = "cluster-web-servers-as"
  description = "Autoscaling policy for web servers"

  target = google_compute_instance_group_manager.this.id

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_backend_service" "this" {
  name        = "cluster-web-servers-backend"
  description = "Pool of web servers"

  backend {
    group = google_compute_instance_group_manager.this.instance_group
  }

  health_checks = [
    google_compute_http_health_check.this.id,
  ]
}

resource "google_compute_address" "this" {
  name        = "cluster-web-servers-address"
  description = "IP address of the cluster-web-servers Load Balancer"

  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

resource "google_compute_url_map" "this" {
  name            = "cluster-web-servers-url-map"
  default_service = google_compute_backend_service.this.id
}

resource "google_compute_target_http_proxy" "this" {
  name    = "cluster-web-servers-proxy"
  url_map = google_compute_url_map.this.id
}

resource "google_compute_forwarding_rule" "this" {
  name        = "cluster-web-servers-rule"
  description = "Forwarding rule for the load balancer on web servers"

  ip_address            = google_compute_address.this.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  network_tier          = "STANDARD"

  target     = google_compute_target_http_proxy.this.self_link
  port_range = "80"
}

resource "google_compute_firewall" "this" {
  name        = var.firewall_name
  description = "Allows TCP inbound traffic on port ${var.server_port}"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }

  source_ranges = ["${google_compute_address.this.address}/32", "130.211.0.0/22", "35.191.0.0/16"]
}

