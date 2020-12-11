# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_remote_state_bucket" {
  description = "The name of the GCS bucket for the database's remote state."
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in GCS."
  type        = string
}

variable "image" {
  description = "Base instance image."
  type        = string
}

variable "machine_type" {
  description = "Type of the instance."
  type = string
}

variable "max_size" {
  description = "The maximum number of GCE Instances in the Instance Group."
  type        = number

  validation {
    condition     = var.max_size <= 10
    error_message = "The value of max_size should be no greater than 10."
  }
}

variable "min_size" {
  description = "The minimum number of GCE Instances in the Instance Group."
  type = number

  validation {
    condition = var.min_size > 0
    error_message = "The value of min_size should be strictly positive."
  }
}

variable "project" {
  description = "The name of the project and cluster resources prefix."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "server_port" {
  description = "The port the server will use for HTTP requests."
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port >= 1024 && var.server_port <= 65535
    error_message = "The server port must be a private port."
  }
}