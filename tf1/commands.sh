az account show

terraform

rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup *.tfplan

terraform import azurerm_resource_group.rg /subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/tca
terraform import module.vnet-main.azurerm_virtual_network.vnet /subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/tca/providers/Microsoft.Network/virtualNetworks/tca
terraform import 'module.vnet-main.azurerm_subnet.subnet[0]' /subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/tca/providers/Microsoft.Network/virtualNetworks/tca/subnets/web
terraform import 'module.vnet-main.azurerm_subnet.subnet[1]' /subscriptions/c568096a-90af-455c-91d0-31314d3fbbf5/resourceGroups/tca/providers/Microsoft.Network/virtualNetworks/tca/subnets/database

terraform init; 
terraform init; terraform plan -out tf1.tfplan; 
terraform plan -out tf1.tfplan; terraform apply tf1.tfplan
terraform apply tf1.tfplan
terraform init; terraform plan -out tf1.tfplan; terraform apply tf1.tfplan


docker pull docker.pkg.github.com/servian/techchallengeapp/techchallengeapp:latest
