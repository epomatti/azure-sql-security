data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "List",
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
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

  #   expire_after         = "P90D"
  #   notify_before_expiry = "P29D"
  # }

  depends_on = [azurerm_key_vault_access_policy.current]
}
