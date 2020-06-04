terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

resource "aws_instance" "single_web_server" {
  ami                    = "ami-0e2512bd9da751ea8"
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.single_web_server.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF

  tags = {
    Name = "single-web-server"
  }
}

resource "aws_security_group" "single_web_server" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
