output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = module.cluster_web_servers.alb_dns_name
}
