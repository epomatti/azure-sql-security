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

  certificate_permissions = [
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "SetIssuers",
    "Update",
  ]
}

# resource "azurerm_key_vault_certificate" "example" {
#   name         = "tde"
#   key_vault_id = azurerm_key_vault.example.id

#   certificate {
#     contents = filebase64("certificate-to-import.pfx")
#     password = ""
#   }
# }

### Certificate ###
# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "rsa" {
#   key_algorithm   = "RSA"
#   private_key_pem = tls_private_key.rsa.private_key_pem

#   subject {
#     common_name  = "example.com"
#     organization = "ACME Examples, Inc"
#   }

#   validity_period_hours = 12

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }
