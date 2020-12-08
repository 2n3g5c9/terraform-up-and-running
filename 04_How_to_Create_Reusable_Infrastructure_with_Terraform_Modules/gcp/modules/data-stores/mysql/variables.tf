# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The database password must contain at least 8 characters."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_tier" {
  description = "The tier to use for the database."
  type        = string
  default     = "db-f1-micro" // Shared vCPUs / 0.6 GB / up to 3,062 GB

  validation {
    condition     = can(regex("db-[[:alnum:]]+-[[:alnum:]]+", var.db_tier))
    error_message = "The database tier doesn't have a proper format."
  }
}

variable "db_version" {
  description = "The version to use for the database."
  type        = string
  default     = "MYSQL_8_0"

  validation {
    condition     = can(regex("MYSQL_[[:digit:]]_[[:digit:]]", var.db_version))
    error_message = "The database version doesn't have a proper format."
  }
}
