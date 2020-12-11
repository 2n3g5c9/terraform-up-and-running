locals {
  project = "terraform-up-and-running"
  region  = "us-east1"
  zone    = "${local.region}b"

  service = "mysql"
}

terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
  zone    = local.zone
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
  name             = "${local.project}-${random_id.db_name_suffix.hex}"
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