resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "this" {
  name             = "${var.project}-${random_id.db_name_suffix.hex}"
  database_version = var.db_version

  deletion_protection = false

  settings {
    tier = var.db_tier
  }
}

resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.this.name
  password = var.db_password
}

resource "google_sql_database" "this" {
  name     = var.db_name
  instance = google_sql_database_instance.this.name
}