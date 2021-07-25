provider "aws" {
  region  = "us-east-1"
  profile = "carim"
}

terraform {
  required_version = "=0.15.0"
  
  backend "s3" {
    bucket = "carim-prod-infrastructure-terraform"
    key    = "state/carim-ar.tfstate"
    region = "us-east-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile = "carim"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = "3.50.0"
    }
  }
}
