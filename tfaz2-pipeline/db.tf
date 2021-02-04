#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_resource_group" "db" {
  name     = local.dbrg
  location = var.location
}


# https://registry.terraform.io/modules/Azure/postgresql/azurerm/latest
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule
module "postgresql" {
  source = "Azure/postgresql/azurerm"

  resource_group_name = azurerm_resource_group.db.name
  location            = azurerm_resource_group.db.location

  server_name                  = local.dbservername
  sku_name                     = "GP_Gen5_2"
  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  administrator_login          = var.dblogin
  administrator_password       = var.dbpassword
  server_version               = "9.6"
  ssl_enforcement_enabled      = false
  db_names                     = var.dbnames
  db_charset                   = "UTF8"
  db_collation                 = "English_United States.1252"

  postgresql_configurations = {
    backslash_quote = "on",
  }

  vnet_rule_name_prefix = "postgresql-vnet-rule-"
  vnet_rules = [
    { name = var.subnet_names[0], subnet_id = azurerm_subnet.subnet0.id }
  ]

  tags = local.common_tags

  depends_on = [azurerm_resource_group.db]
}

############################################################################
# PROVISIONERS
############################################################################

resource "null_resource" "db_seed" {

  depends_on = [module.postgresql]

  provisioner "local-exec" {
    on_failure = fail
    command    = <<EOT
set 
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
az postgres server firewall-rule create -g ${azurerm_resource_group.db.name} -s ${module.postgresql.server_name} -n updatedbIpDeleteme --start-ip-address $myip --end-ip-address $myip
docker run --rm -e VTT_DBUSER=${var.dblogin}@${module.postgresql.server_name} -e VTT_DBPASSWORD="${var.dbpassword}" -e VTT_DBNAME=${local.dbname} -e VTT_DBPORT=5432 -e VTT_DBHOST=${module.postgresql.server_name}.postgres.database.azure.com -e VTT_LISTENHOST=0.0.0.0 -e VTT_LISTENPORT=3000 brian2nw/stc:latest
az postgres server firewall-rule delete --yes -g ${azurerm_resource_group.db.name} -s ${module.postgresql.server_name} -n updatedbIpDeleteme
EOT
  }
}

output "dbname" {
  value = module.postgresql.server_name
}

output "dbuser" {
  value = "${var.dblogin}@${module.postgresql.server_name}"
}