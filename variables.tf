variable "letsencrypt_email" {
  description = "Email used to order a certificate from Letsencrypt"
}

variable "static_fip" {
  description = "static FIP"
  default     = ""
}

variable "floating_ip_pool" {
    description = "The pool used to get floating ip"
    default = "CUDN Internet"
}

variable "public_url" {
  description = "Public URL for the project"
  default     = ""
}

variable "ssh_key_file" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the SSH public key file"
}

variable "image_name" {
  description = "name of the openstack image"
}

variable "flavor_name" {
  description = "Openstack flavor to use"
}

variable "containerd_version" {
  description = "version of containerd to use"
  default     = "1.3.2"
}

variable "caddy_version" {
  description = "version of caddy to use"
  default     = "2.0.0-rc.2"
}

variable "faasd_version" {
  description = "version of faasd to use"
  default     = "0.8.1"
}

variable "dns_nameservers" {
  type        = list(string)
  description = "DNS Nameservers"
}

variable "public_network" {
  description = "UUID of the external network"
}