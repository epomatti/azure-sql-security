resource "azurerm_mssql_server" "default" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.group
  location            = var.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  administrator_login          = var.admin_admin
  administrator_login_password = var.admin_login_password

  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_database" "default" {
  name                 = "sqldb-${var.workload}"
  server_id            = azurerm_mssql_server.default.id
  max_size_gb          = var.max_size_gb
  read_scale           = false
  sku_name             = var.sku
  zone_redundant       = false
  storage_account_type = "Local"
}

resource "azurerm_mssql_firewall_rule" "local" {
  name             = "FirewallRuleLocal"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = var.public_ip_address_to_allow
  end_ip_address   = var.public_ip_address_to_allow
}

# Rule named "AllowAllWindowsAzureIps" with "0.0.0.0" will allow Azure Services to connect.
resource "azurerm_mssql_firewall_rule" "allow_access_to_azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


# resource "azurerm_mssql_virtual_network_rule" "default" {
#   name      = "default-subnet"
#   server_id = azurerm_mssql_server.default.id
#   subnet_id = var.default_subnet_id
# }
