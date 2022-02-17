packer {
  required_plugins {
    amazon = {
      version = "1.0.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type        = string
  description = "The version of Factorio to install"
}

data "amazon-ami" "aws_linux_2" {
  region = "us-east-1"
  filters = {
    image-id            = "ami-0a8b4cd432b1c3063"
    virtualization-type = "hvm"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}

source "amazon-ebs" "factorio" {
  ami_name                = "jdefrank-factorio-${var.version}"
  instance_type           = "t2.micro"
  region                  = "us-east-1"
  source_ami              = data.amazon-ami.aws_linux_2.id
  ami_virtualization_type = "hvm"
  ssh_username            = "ec2-user"
  tags = {
    Owner = "jdefrank"
  }
}

build {
  hcp_packer_registry {
    bucket_name = "factorio"
    description = "Factorio Images"
    bucket_labels = {
      "team" = "solutions engineering"
      "os"   = "linux"
    }
  }
  sources = [
    "source.amazon-ebs.factorio"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum install -y unzip zip",
      "sudo curl -Ls 'https://www.factorio.com/get-download/${var.version}/headless/linux64' -o factorio_headless.tar.xz",
      "sudo xz -d factorio_headless.tar.xz",
      "sudo tar -xf factorio_headless.tar",
      "sudo rm factorio_headless.tar",
      "sudo mv factorio /opt/factorio",
      "sudo mkdir /opt/factorio/config",
      "sudo groupadd factorio",
      "sudo adduser --no-create-home -g factorio factorio",
      "sudo passwd -l factorio"
    ]
  }

  provisioner "file" {
    source      = "./files/factorio.service"
    destination = "~/factorio.service"
  }

  provisioner "shell" {
    inline = [
      "sudo mv ~/factorio.service /etc/systemd/system/factorio.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable factorio"
    ]
  }
}