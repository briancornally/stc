
resource "azurerm_resource_group" "app" {
  name     = local.apprg
  location = var.location
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection
resource "azurerm_app_service_plan" "asp" {
  name                = local.aspname
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.appskutier
    size = var.appskusize
  }

  tags = local.common_tags
}

resource "azurerm_app_service" "app1" {
  name                = local.app1name
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    app_command_line = var.appcmd
    linux_fx_version = var.appimg
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    "VTT_DBHOST"                          = "${module.postgresql.server_name}.postgres.database.azure.com"
    "VTT_DBNAME"                          = local.dbname
    "VTT_DBPASSWORD"                      = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.kv_dbpassword.id})"
    "VTT_DBPORT"                          = "5432"
    "VTT_DBUSER"                          = "${var.dblogin}@${module.postgresql.server_name}"
    "VTT_LISTENHOST"                      = "0.0.0.0"
    "VTT_LISTENPORT"                      = "80"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  tags = local.common_tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "app1" {
  app_service_id = azurerm_app_service.app1.id
  subnet_id      = azurerm_subnet.subnet0.id
}

resource "azurerm_monitor_autoscale_setting" "app1" {
  name                = azurerm_app_service_plan.asp.name
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  target_resource_id  = azurerm_app_service_plan.asp.id

  profile {
    name = "${azurerm_app_service_plan.asp.name}-cpu"

    capacity {
      default = 2
      minimum = 1
      maximum = 10
    }

    rule {
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT20M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
    }
  }
}

resource "null_resource" "app_warmup" {

  depends_on = [azurerm_app_service.app1, null_resource.db_seed]

  provisioner "local-exec" {
    on_failure = continue
    command    = <<EOT
curl --max-time ${var.apptimeout} ${azurerm_app_service.app1.default_site_hostname}
EOT
  }
}

output "principal_id" {
  value = azurerm_app_service.app1.identity.0.principal_id
}
