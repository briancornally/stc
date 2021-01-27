

#############################################################################
# RESOURCES
#############################################################################
# https://registry.terraform.io/modules/Azure/vnet/azurerm/latest?tab=inputs

module "vnet-main" {
  source              = "Azure/vnet/azurerm"
  version             = "2.3.0"
  resource_group_name = var.resource_group_name
  # location            = var.location
  vnet_name           = var.resource_group_name
  address_space       = var.vnet_cidr_range
  subnet_prefixes    = var.subnet_prefixes
  subnet_names        = var.subnet_names
  nsg_ids             = {}

  tags = {
    environment = "dev"
    costcenter  = "it"

  }
}

#############################################################################
# OUTPUTS
#############################################################################

output "vnet_id" {
  value = module.vnet-main.vnet_id
}
