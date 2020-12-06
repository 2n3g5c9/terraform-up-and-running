# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_instance_type" {
  description = "Type of the database instance."
  type        = string
}

variable "db_name" {
  description = "The name to use for the database."
  type        = string
}

variable "db_secret_id" {
  description = "The ID of the database secret, needs to be created manually."
  type        = string
}