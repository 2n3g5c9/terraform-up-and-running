locals {
  service = "single-web-server"

  ami           = "ami-0885b1f6bd170450c" // ubuntu 20.04 LTS
  instance_type = "t3a.nano"              // 2 vCPUs for a 1h 12m burst / 0.5 GiB
}

terraform {
  required_version = ">= 0.14, < 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "this" {
  ami                    = local.ami
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF

  tags = {
    Name    = local.service
    service = local.service
  }
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Allows HTTP traffic on port ${var.server_port} from all sources"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = var.security_group_name
    service = local.service
  }
}
