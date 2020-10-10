# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}

variable "db_secret_id" {
  description = "The ID of the database secret."
  type        = string
}