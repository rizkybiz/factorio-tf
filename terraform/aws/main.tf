terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.22.0"
    }
  }
}

provider "hcp" {}

provider "aws" {
  region = "us-east-1"
}