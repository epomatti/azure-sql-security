variable "group" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "sku" {
  type = string
}

variable "max_size_gb" {
  type = number
}

variable "admin_admin" {
  type = string
}

variable "admin_login_password" {
  type      = string
  sensitive = true
}

variable "public_network_access_enabled" {
  type = bool
}

variable "public_ip_address_to_allow" {
  type = string
}

variable "default_subnet_id" {
  type = string
}
