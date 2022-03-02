output "factorio_connection_string" {
  value = "${aws_route53_record.factorio_record.fqdn}:${var.server_port}"
}