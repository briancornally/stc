#############################################################################
# VARIABLES
#############################################################################

variable "suffix" {
  type    = string
  default = "app1"
}

variable "location" {
  type    = string
  default = "southeastasia"
}

# variable "environment" {
#   type    = string
#   default = "dev"
# }

variable "costcenter" {
  type    = string
  default = "IT"
}

variable "vnet_cidr_range" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_names" {
  type    = list(string)
  default = ["int"]
}

variable "subnet0delegationName" {
  type    = string
  default = "Microsoft.Web/serverFarms"
}

variable "subnet0delegationActions" {
  type    = list(string)
  default = ["Microsoft.Network/virtualNetworks/subnets/action"]
}

variable "subnet0serviceEndpoints" {
  type    = list(string)
  default = ["Microsoft.Sql"]
}

variable "dbnames" {
  type    = list(string)
  default = ["app1", "app2", "app3"]
}

variable "dbpassword" {
  type = string
}

variable "dblogin" {
  type    = string
  default = "login"
}

variable "dbversion" {
  type    = string
  default = "9.6"
}

variable "appimg" {
  type    = string
  default = "DOCKER|servian/techchallengeapp:latest"
}

variable "appcmd" {
  type    = string
  default = "serve"
}

variable "apptimeout" {
  type    = string
  default = "120"
}

variable "appskusize" {
  type = string
  default = "S1"
}

variable "appskutier" {
  type = string
  default = "Standard"
}

variable "app_health_check_path" {
  type = string
  default = "/healthcheck/"
}

locals {
  environment = terraform.workspace
  common_tags = {
    environment = terraform.workspace
    costcenter  = var.costcenter
  }
  dbname = var.dbnames[0]

  # app1name     = "${terraform.workspace}-${var.suffix}-${random_integer.rand.result}"
  app1name     = "${var.suffix}-${random_integer.rand.result}"
  apprg        = "${terraform.workspace}-${var.suffix}-app"
  aspname      = "${terraform.workspace}-${var.suffix}-asp"
  dbrg         = "${terraform.workspace}-${var.suffix}-db"
  dbservername = "${terraform.workspace}-${var.suffix}-${random_integer.rand.result}"
  kvname       = "${terraform.workspace}-${var.suffix}-kv"
  kvrg         = "${terraform.workspace}-${var.suffix}-kv"
  netname      = "${terraform.workspace}-${var.suffix}-net"
  netrg        = "${terraform.workspace}-${var.suffix}-net"
}

