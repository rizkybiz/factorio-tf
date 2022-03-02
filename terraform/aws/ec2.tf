data "hcp_packer_iteration" "factorio_production_iteration" {
  bucket_name = "factorio"
  channel     = "Production"
}

data "hcp_packer_image" "factorio" {
  bucket_name    = "factorio"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.factorio_production_iteration.ulid
  region         = "us-east-1"
}

resource "aws_instance" "factorio" {
  ami                         = data.hcp_packer_image.factorio.cloud_image_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.factorio_access.id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = aws_key_pair.ssh.key_name

  tags = {
    Owner = "jdefrank"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${var.private_key_path}")
  }

  provisioner "file" {
    content = templatefile("./files/config.tftpl", {
      server_name        = var.server_name
      server_description = var.server_description
      password           = var.server_password
    })
    destination = "~/config.json"
  }

  provisioner "file" {
    content     = jsonencode(var.admins)
    destination = "~/admins.json"
  }

  provisioner "file" {
    source      = "./files/saves.zip"
    destination = "~/saves.zip"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv ~/config.json /opt/factorio/config/config.json",
      "sudo mv ~/admins.json /opt/factorio/config/admins.json",
      "sudo mv ~/saves.zip /opt/factorio/saves.zip",
      "sudo systemctl daemon-reload",
      "sudo unzip /opt/factorio/saves.zip -d /opt/factorio/",
      "sudo rm /opt/factorio/saves.zip",
      "sudo chown -R factorio:factorio /opt/factorio",
      "sudo systemctl start factorio"
    ]
  }
}