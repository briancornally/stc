#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_resource_group" "tdb" {
  name     = "${var.prefix}-db"
}

module "postgresql" {
  source = "Azure/postgresql/azurerm"

  resource_group_name = azurerm_resource_group.tdb.name
  location            = azurerm_resource_group.tdb.location

  server_name                  = "${azurerm_resource_group.tdb.name}-${random_integer.rand.result}"
  sku_name                     = "GP_Gen5_2"
  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  administrator_login          = "login"
  administrator_password       = var.DbPassword
  server_version               = "9.6"
  ssl_enforcement_enabled      = true
  db_names                     = ["db1", "db2", "db3"]
  db_charset                   = "UTF8"
  db_collation                 = "English_United States.1252"

  # firewall_rule_prefix = "firewall-"
  # firewall_rules = [
  #   { name = "test1", start_ip = "10.0.0.5", end_ip = "10.0.0.8" },
  #   { start_ip = "127.0.0.0", end_ip = "127.0.1.0" },
  # ]

#   vnet_rule_name_prefix = "postgresql-vnet-rule-"
#   vnet_rules = [
#     { name = "subnet1", subnet_id = "<subnet_id>" }
#   ]

  tags = local.common_tags

  postgresql_configurations = {
    backslash_quote = "on",
  }

  # depends_on = [azurerm_resource_group.tdb]
}