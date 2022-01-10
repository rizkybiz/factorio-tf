packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/digitalocean"
    }
  }
}

variable "apikey" {}

source "digitalocean" "ubuntu" {
  api_token = "${var.apikey}"
  snapshot_name = "factorio-1.1.50-${timestamp()}"
  image = "ubuntu-20-04-x64"
  region = "nyc1"
  size = "s-1vcpu-1gb"
  ssh_username = "root"
}

build {
  sources = ["source.digitalocean.ubuntu"]
  provisioner "shell" {
    inline = [
      "sleep 30s",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update -y --allow-downgrades --allow-remove-essential --allow-change-held-packages",
      "sudo apt-get install -y xz-utils",
      "sudo echo \"Downloading factorio headless...\"",
      "sudo curl -sSL 'https://www.factorio.com/get-download/1.1.50/headless/linux64' -o factorio_headless.tar.xz",
      "sudo xz -d factorio_headless.tar.xz",
      "sudo tar -xf ./factorio_headless.tar",
      "sudo mv factorio /opt/factorio",
      "sudo rm ./factorio_headless.tar",
      "sudo mkdir /opt/factorio/config",
      "sudo adduser --disabled-login --no-create-home --gecos factorio factorio",
      "sudo opt/factorio/bin/x64/factorio --create /opt/factorio/saves/savegame1.zip"
    ]
  }

  provisioner "file" {
    source = "factorio-run.sh"
    destination = "/opt/factorio/factorio-run.sh"
  }

  provisioner "file" {
    source = "factorio.service"
    destination = "/etc/systemd/system/factorio.service"
  }

  provisioner "shell" {
    inline = [
      "sudo systemctl daemon-reload",
      "sudo systemctl enable factorio"
    ]
  }
}
