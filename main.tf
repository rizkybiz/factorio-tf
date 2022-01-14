terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
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

resource "digitalocean_droplet" "factorio" {
  image    = data.digitalocean_droplet_snapshot.factorio-snapshot.id
  name     = "factorio-server"
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.key.id]
  vpc_uuid = digitalocean_vpc.factorio-vpc.id

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_key)
    timeout     = "2m"
  }

  provisioner "file" {
    content = templatefile("files/config.tftpl", {
      server_name        = var.server_name
      server_description = var.server_description
      password           = var.server_password
    })
    destination = "/opt/factorio/config/config.json"
  }

  provisioner "file" {
    content     = jsonencode(var.admins)
    destination = "/opt/factorio/config/admins.json"
  }

  provisioner "file" {
    source      = "./saves.zip"
    destination = "/opt/factorio/saves.zip"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl daemon-reload",
      "sudo unzip /opt/factorio/saves.zip -d /opt/factorio/",
      "sudo rm /opt/factorio/saves.zip",
      "sudo chown -R factorio:factorio /opt/factorio",
      "sudo systemctl start factorio"
    ]
  }
}