resource "azurerm_mssql_server_extended_auditing_policy" "log" {
  server_id              = var.mssql_server_id
  log_monitoring_enabled = true
}

# TODO: Depends on "/databases/master"
resource "azurerm_monitor_diagnostic_setting" "audit" {
  name                       = "mssql-audit"
  target_resource_id         = "${var.mssql_server_id}/databases/master"
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
}
