output "id" {
  value = azurerm_key_vault.default.id
}

output "vault_uri" {
  value = azurerm_key_vault.default.vault_uri
}

output "keyvault_key_id" {
  value = azurerm_key_vault_key.generated.id
}
