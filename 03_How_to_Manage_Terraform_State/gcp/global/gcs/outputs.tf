output "gcs_bucket_uri" {
  value       = google_storage_bucket.tf_state.self_link
  description = "The URI of the GCS bucket."
}