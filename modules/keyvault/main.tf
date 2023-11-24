data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "current" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_key" "generated" {
  name         = "mssql-tde-key"
  key_vault_id = azurerm_key_vault.default.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  # rotation_policy {
  #   automatic {
  #     time_before_expiry = "P30D"
  #   }

  #   expire_after = "P90D"
  # }

  depends_on = [azurerm_role_assignment.current]
}
