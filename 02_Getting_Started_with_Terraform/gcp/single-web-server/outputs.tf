output "single_web_server_public_ip" {
  value = google_compute_instance.single_web_server.network_interface.0.network_ip
}