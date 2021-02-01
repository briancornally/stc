
data "azurerm_key_vault" "kv" {
  name                = local.kvname
  resource_group_name = local.kvname
}

output "vault_uri" {
  value = data.azurerm_key_vault.kv.vault_uri
}

data "azurerm_key_vault_secret" "kv_dbpassword" {
  name         = "dbpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

output "kv_dbpassword_id" {
  value = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.kv_dbpassword.id})"
}

resource "azurerm_key_vault_access_policy" "app1" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = azurerm_app_service.app1.identity.0.tenant_id
  object_id    = azurerm_app_service.app1.identity.0.principal_id

  secret_permissions = [
    "get",
  ]

  depends_on = [azurerm_app_service.app1]
}
