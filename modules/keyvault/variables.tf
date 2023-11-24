variable "group" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "datalake_connection_string" {
  type      = string
  sensitive = true
}

variable "datalake_access_key" {
  type      = string
  sensitive = true
}

variable "databricks_sp_secret" {
  type      = string
  sensitive = true
}

variable "synapse_sql_administrator_login" {
  type      = string
  sensitive = true
}

variable "synapse_sql_administrator_login_password" {
  type      = string
  sensitive = true
}
