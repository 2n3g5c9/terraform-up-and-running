locals {
  region = "us-east-1"

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
  region = local.region
}

module "cluster-web-servers" {
  source = "../../../../modules/services/cluster_web_servers"

  ami = local.ami

  server_text = var.server_text

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = local.instance_type
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.cluster_web_servers.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
