packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/digitalocean"
    }
  }
}

variable "apikey" {}

source "digitalocean" "centos8" {
  api_token = "${var.apikey}"
  snapshot_name = "factorio-1.1.50-${timestamp()}"
  image = "centos-8-x64"
  region = "nyc1"
  size = "s-1vcpu-1gb"
  ssh_username = "root"
}

build {
  sources = ["source.digitalocean.centos8"]

  provisioner "shell" {
    script = "./centos-setup.sh"
  }
  
  provisioner "file" {
    source = "factorio.service"
    destination = "/etc/systemd/system/factorio.service"
  }

  provisioner "shell" {
    inline = [
      "sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable factorio"
    ]
  }
}
