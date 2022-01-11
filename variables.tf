variable "do_token" {
  type        = string
  description = "token for Digital Ocean"
}

variable "ssh_key_name" {
  type        = string
  description = "name of ssh key to add to the droplet"
}

variable "region" {
  type        = string
  default     = "nyc1"
  description = "region to deploy the droplet and where the snapshot is stored"
}

variable "size" {
  type        = string
  default     = "s-1vcpu-1gb"
  description = "size of the droplet to make. Use this link to find the sizes: https://docs.digitalocean.com/reference/api/api-reference/#operation/list_all_sizes"
}

variable "private_key" {
  type        = string
  description = "the path on your machine where the private key is located for SSH to droplets"
}

variable "server_name" {
  type        = string
  default     = "default_name"
  description = "name of the factorio server"
}

variable "server_description" {
  type        = string
  default     = "default_description"
  description = "description of the factorio server"
}

variable "server_password" {
  type        = string
  default     = "default_password"
  description = "password of the factorio server"
}

variable "source_ip" {
  type        = string
  description = "your external IP to allow SSH access to the VM"
}

variable "admins" {
  type        = list(string)
  description = "server admins"
}