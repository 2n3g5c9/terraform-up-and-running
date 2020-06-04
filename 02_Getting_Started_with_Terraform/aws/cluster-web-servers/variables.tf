variable "server_port" {
  description = "The port the server will use for HTTP requests."
  type        = number
  default     = 8080
}

variable "alb_name" {
  description = "The name of the ALB."
  type        = string
  default     = "cluster-web-servers-asg"
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances."
  type        = string
  default     = "cluster-web-servers-sg"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB."
  type        = string
  default     = "cluster-web-servers-alb-sg"
}