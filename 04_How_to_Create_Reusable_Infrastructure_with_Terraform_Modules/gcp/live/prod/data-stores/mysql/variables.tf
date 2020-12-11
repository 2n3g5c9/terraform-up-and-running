# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_password" {
  description = "The password for the database."
  type        = string

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The database password must contain at least 8 characters."
  }
}