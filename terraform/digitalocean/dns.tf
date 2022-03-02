data "terraform_remote_state" "dns" {
  backend = "remote"

  config = {
    organization = "${var.tfc_org}"

    workspaces = {
      name = "${var.tfc_workspace}"
    }
  }
}

resource "aws_route53_record" "factorio_record" {
  zone_id = data.terraform_remote_state.dns.outputs.route53_zone_id
  name    = "factorio.jdefrank.aws.hashidemos.io"
  type    = "A"
  ttl     = 300
  records = [digitalocean_droplet.factorio.ipv4_address]
}
