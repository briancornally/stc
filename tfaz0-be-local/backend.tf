# Deploy terraform backend on azure storage
# credit for this file & method to https://github.com/ned1313/Implementing-Terraform-on-Microsoft-Azure
##################################################################################
# RESOURCES
##################################################################################
resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "be" {
  name     = local.sarg
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.saname
  resource_group_name      = azurerm_resource_group.be.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account_sas" "state" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "17520h")

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
  }
}

#############################################################################
# PROVISIONERS
#############################################################################

resource "null_resource" "tfbe" {

  depends_on = [azurerm_storage_container.ct]

  provisioner "local-exec" {
    command = <<EOT
echo 'storage_account_name = "${azurerm_storage_account.sa.name}"' >> backend-config.txt
echo 'container_name = "terraform-state"' >> backend-config.txt
echo 'key = "terraform.tfstate"' >> backend-config.txt
echo 'sas_token = "${data.azurerm_storage_account_sas.state.sas}"' >> backend-config.txt
EOT
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "resource_group_name" {
  value = azurerm_resource_group.be.name
}