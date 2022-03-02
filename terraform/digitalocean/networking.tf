resource "digitalocean_vpc" "factorio-vpc" {
  name     = "factorio-vpc"
  region   = "nyc1"
  ip_range = "192.168.1.0/24"
}

resource "digitalocean_firewall" "factorio-server-firewall" {
  name        = "factorio-ports"
  droplet_ids = [digitalocean_droplet.factorio.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["${var.source_ip}/32"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "34197"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}