# Using User-Assigned to make it all automated for TDE
resource "azurerm_user_assigned_identity" "mssql" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.group
  location            = var.location
}

resource "azurerm_role_assignment" "key" {
  scope                = var.tde_key_vault_key_resource_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.mssql.principal_id
}

### SQL Server ###
data "azurerm_client_config" "current" {}

data "azuread_user" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_mssql_server" "default" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.group
  location            = var.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  public_network_access_enabled                = var.public_network_access_enabled
  transparent_data_encryption_key_vault_key_id = var.tde_key_vault_key_id

  # Administrator Login
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_login_password

  azuread_administrator {
    login_username = data.azuread_user.current.user_principal_name
    object_id      = data.azurerm_client_config.current.object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }

  # Managed Identity
  primary_user_assigned_identity_id = azurerm_user_assigned_identity.mssql.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mssql.id]
  }

  depends_on = [azurerm_role_assignment.key]
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

# Allow Azure Services to connect.
resource "azurerm_mssql_firewall_rule" "allow_access_to_azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_virtual_network_rule" "default" {
  name      = "default-subnet"
  server_id = azurerm_mssql_server.default.id
  subnet_id = var.default_subnet_id
}
