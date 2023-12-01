locals {
  user = "sqldeveloper"
}

resource "azuread_user" "sqldeveloper" {
  account_enabled     = true
  user_principal_name = "${local.user}@${var.entraid_tenant_domain}"
  display_name        = local.user
  mail_nickname       = local.user
  password            = var.sqldeveloper_user_password
}
