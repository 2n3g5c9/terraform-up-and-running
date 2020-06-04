variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "firewall_name" {
  description = "The name of the firewall."
  type        = string
  default     = "single-web-server-firewall"
}

