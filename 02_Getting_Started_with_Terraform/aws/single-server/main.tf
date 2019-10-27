terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

resource "aws_instance" "example" {
  ami           = "ami-0d5ae5525eb033d0a"
  instance_type = "t3.nano"

  tags = {
    Name = "terraform-example"
  }
}
