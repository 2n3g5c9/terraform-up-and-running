locals {
  db_tier = "db-f1-micro"

  service = "terraform-up-and-running"
}

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "google" {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "us-east1-b"
}

terraform {
  backend "gcs" {
    bucket = "2n3g5c9-terraform-up-and-running-state"
    prefix = "stage/data-stores/mysql/terraform.tfstate"
  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "this" {
  name             = "${local.service}-${random_id.db_name_suffix.hex}"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
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