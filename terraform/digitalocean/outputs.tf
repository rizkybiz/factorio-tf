output "factorio_connection_string" {
  value = "${aws_route53_record.factorio_record.fqdn}:${var.server_port}"
}

output "factorio_ipv4_connection_string" {
  value = "${digitalocean_droplet.factorio.ipv4_address}:${var.server_port}"
}