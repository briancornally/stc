

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "kv" {
  name     = "${var.environment}-${var.suffix}-kv"
  location = var.location
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
resource "azurerm_key_vault" "kv" {
  name                        = "${var.environment}-${var.suffix}-kv"
  location                    = azurerm_resource_group.kv.location
  resource_group_name         = azurerm_resource_group.kv.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "set",
      "get",
      "list"
    ]
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret
resource "azurerm_key_vault_secret" "kvdbpassword" {
  name         = "dbpassword"
  value        = var.dbpassword
  key_vault_id = azurerm_key_vault.kv.id
}