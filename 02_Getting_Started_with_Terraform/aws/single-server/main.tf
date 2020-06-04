terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

resource "aws_instance" "single_server" {
  ami           = "ami-0e2512bd9da751ea8"
  instance_type = "t3.nano"

  tags = {
    Name = "single-server"
  }
}
