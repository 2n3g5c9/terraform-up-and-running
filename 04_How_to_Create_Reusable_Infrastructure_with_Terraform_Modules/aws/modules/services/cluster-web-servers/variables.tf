# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The base instance AMI."
  type        = string

  validation {
    condition     = length(var.ami > 4 && substr(var.ami, 0, 4) == "ami-")
    error_message = "The ami value must start with \"ami-\"."
  }
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources."
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state."
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t3a.nano)."
  type        = string
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG."
  type        = number

  validation {
    condition     = var.max_size <= 10
    error_message = "The value of max_size should be no greater than 10."
  }
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG."
  type        = number

  validation {
    condition     = var.min_size > 0
    error_message = "The value of min_size should be strictly positive."
  }
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
