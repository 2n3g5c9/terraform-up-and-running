output "connection_name" {
  value       = google_sql_database_instance.this.connection_name
  description = "Connect to the database at this endpoint."
}
