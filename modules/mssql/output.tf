output "fully_qualified_domain_name" {
  value = azurerm_mssql_server.default.fully_qualified_domain_name
}

output "server_id" {
  value = azurerm_mssql_server.default.id
}
