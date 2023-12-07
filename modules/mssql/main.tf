# Using User-Assigned to make it all automated for TDE
resource "azurerm_user_assigned_identity" "mssql" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.group
  location            = var.location
}

resource "azurerm_role_assignment" "key" {
  scope = var.tde_key_vault_key_resource_id
  # Provides the required permissions for TDE which are Get, Wrap Key, Unwrap
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


### Auditing ###
resource "azurerm_mssql_server_extended_auditing_policy" "log" {
  server_id              = azurerm_mssql_server.default.id
  log_monitoring_enabled = true

  # Don't know if this is the right dependency
  depends_on = [azurerm_mssql_database.default]
}

resource "azurerm_monitor_diagnostic_setting" "audit" {
  name                       = "mssql-audit"
  target_resource_id         = "${azurerm_mssql_server.default.id}/databases/master"
  log_analytics_workspace_id = var.log_analytic_workspace_id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "Basic"
    enabled  = true
  }

  metric {
    category = "InstanceAndAppAdvanced"
    enabled  = true
  }

  metric {
    category = "WorkloadManagement"
    enabled  = true
  }

  # Don't know if this is the right dependency
  depends_on = [azurerm_mssql_database.default]
}


### Elastic Pool ###

resource "azurerm_mssql_elasticpool" "default" {
  count               = var.elastic_pool_enabled ? 1 : 0
  name                = "sqlep-${var.workload}-default"
  resource_group_name = var.group
  location            = var.location
  server_name         = azurerm_mssql_server.default.name
  license_type        = "LicenseIncluded"
  zone_redundant      = false

  maintenance_configuration_name = "SQL_Default"

  max_size_gb = 100

  sku {
    name     = "StandardPool"
    tier     = "Standard"
    family   = null
    capacity = 50
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 50
  }
}
