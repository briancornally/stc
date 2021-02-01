

#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_resource_group" "net" {
  name     = local.netrg
  location = var.location
}

resource "azurerm_virtual_network" "tapp" {
  name                = local.netname
  address_space       = var.vnet_cidr_range
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name

  tags = local.common_tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "subnet0" {
  name                 = var.subnet_names[0]
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.tapp.name
  address_prefixes     = [var.subnet_prefixes[0]]

  delegation {
    name = "delegation"

    service_delegation {
      name    = var.subnet0delegationName
      actions = var.subnet0delegationActions
    }
  }

  service_endpoints = ["Microsoft.Sql"]
}

