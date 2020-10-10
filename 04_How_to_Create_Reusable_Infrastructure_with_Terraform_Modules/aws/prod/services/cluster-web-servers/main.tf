provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

module "cluster_web_servers" {
  source = "../../../modules/services/cluster-web-servers"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "2n3g5c9-terraform-up-and-running-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}