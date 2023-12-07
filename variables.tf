variable "location" {
  type    = string
  default = "eastus2"
}

variable "public_ip_address_to_allow" {
  type = string
}

variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_public_network_access_enabled" {
  type = bool
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type = string
}

variable "mssql_create_elastic_pool" {
  type = bool
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_sqldeveloper_user_password" {
  type      = string
  sensitive = true
}
