terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.1.0"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.22.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region = "us-east-1"
}

resource "digitalocean_project" "factorio" {
  name        = "factorio"
  description = "A project to house a factorio server"
  resources   = [digitalocean_droplet.factorio.urn]
}

data "digitalocean_droplet_snapshot" "factorio-snapshot" {
  name_regex  = "^factorio"
  region      = var.region
  most_recent = true
}

data "digitalocean_ssh_key" "key" {
  name = var.ssh_key_name
}