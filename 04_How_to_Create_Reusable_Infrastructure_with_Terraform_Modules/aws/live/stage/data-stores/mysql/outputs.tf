output "address" {
  description = "Connect to the database at this endpoint."
  value       = module.mysql.address
}

output "port" {
  description = "The port the database is listening on."
  value       = module.mysql.port
}
