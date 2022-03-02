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

variable "server_port" {
  default     = 34197
  description = "port which factorio will listen on"
}

variable "source_ip" {
  type        = string
  description = "your external IP to allow SSH access to the VM"
}

variable "admins" {
  type        = list(string)
  description = "server admins"
}

variable "private_key_path" {
  type        = string
  description = "path to the private ssh key"
}

variable "tfc_org" {
  type        = string
  description = "your tfc organization"
}

variable "tfc_workspace" {
  type        = string
  description = "the workspace where "
}