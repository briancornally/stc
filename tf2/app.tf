
resource "azurerm_resource_group" "tapp" {
  name     = "${var.prefix}-${var.resource_group_suffix}"
  location = var.location
}

resource "azurerm_app_service_plan" "tapp" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.tapp.location
  resource_group_name = azurerm_resource_group.tapp.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "tapp" {
  name                = "${var.prefix}-${var.environment}-${random_integer.rand.result}"
  location            = azurerm_resource_group.tapp.location
  resource_group_name = azurerm_resource_group.tapp.name
  app_service_plan_id = azurerm_app_service_plan.tapp.id

  site_config {
    app_command_line = "serve"
    linux_fx_version = "DOCKER|servian/techchallengeapp:latest"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    "VTT_DBHOST"                          = "tca-35955.postgres.database.azure.com"
    "VTT_DBNAME"                          = "db2"
    "VTT_DBPASSWORD"                      = var.DbPassword
    "VTT_DBPORT"                          = "5432"
    "VTT_DBUSER"                          = "login@tca-35955"
    "VTT_LISTENHOST"                      = "0.0.0.0"
    "VTT_LISTENPORT"                      = "80"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}

