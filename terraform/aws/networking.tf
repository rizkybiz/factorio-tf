module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.5"

  name                 = "jdefrank-demo-vpc"
  cidr                 = "192.168.0.0/16"
  azs                  = ["us-east-1a"]
  private_subnets      = ["192.168.2.0/24"]
  public_subnets       = ["192.168.1.0/24"]
  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Owner = "jdefrank"
  }
}

resource "aws_security_group" "factorio_access" {
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.source_ip}/32"]
  }

  ingress {
    description = "Game Client UDP"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}