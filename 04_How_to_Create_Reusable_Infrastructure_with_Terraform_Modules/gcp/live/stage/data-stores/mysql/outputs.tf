output "connection_name" {
  description = "Connect to the database at this endpoint."
  value       = module.mysql.connection_name
}
