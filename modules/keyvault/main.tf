data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "databricks" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Delete", "Get", "List", "Set", "Purge"]
  }

  # FIXME: Should be controlled with AzureDatabricks user
  lifecycle {
    ignore_changes = [access_policy]
  }
}

resource "azurerm_key_vault_secret" "datalake_connection_string" {
  name         = "dlsconnectionstring"
  value        = var.datalake_connection_string
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "datalake_access_key" {
  name         = "dlsaccesskey"
  value        = var.datalake_access_key
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "databricks_sp_secret" {
  name         = "dlsserviceprincipalsecret"
  value        = var.databricks_sp_secret
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "synapse_sql_administrator_login" {
  name         = "synapselogin"
  value        = var.synapse_sql_administrator_login
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "synapse_sql_administrator_login_password" {
  name         = "synapseloginpassword"
  value        = var.synapse_sql_administrator_login_password
  key_vault_id = azurerm_key_vault.databricks.id
}
