terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

locals {
  workload = "bigbank79"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "mssql" {
  source   = "./modules/mssql"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  public_ip_address_to_allow    = var.public_ip_address_to_allow
  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  public_network_access_enabled = var.mssql_public_network_access_enabled
  admin_admin                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
}
