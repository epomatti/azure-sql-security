resource "azurerm_mssql_server_extended_auditing_policy" "log" {
  server_id              = var.mssql_server_id
  log_monitoring_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "audit" {
  name               = "mssql-audit"
  target_resource_id = "${var.mssql_server_id}/databases/master"
  # eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  # eventhub_name                  = azurerm_eventhub.example.name
  log_analytics_workspace_id = var.log_analytic_workspace_id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "AllMetrics"
  }
}
