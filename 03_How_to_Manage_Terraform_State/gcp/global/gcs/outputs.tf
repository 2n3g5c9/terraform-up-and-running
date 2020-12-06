output "gcs_bucket_uri" {
  description = "The URI of the GCS bucket."
  value       = google_storage_bucket.tf_state.self_link
}