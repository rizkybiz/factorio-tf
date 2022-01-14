output "factorio_host" {
  value = "${digitalocean_droplet.factorio.ipv4_address}:34197"
}