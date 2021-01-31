#############################################################################
# VARIABLES
#############################################################################

variable "suffix" {
  type = string
  default = "tc"
}

variable "location" {
  type    = string
  default = "southeastasia"
}

variable "environment" {
  type    = string
  default = "dev"
}

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
  default = ["int", "db"]
}

variable "dbnames" {
  type    = list(string)
  default = ["db1","db2","db3"]
}

variable "dbpassword" {
  type    = string
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
  default = "60"
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
  type = list(string)
  default = ["Microsoft.Sql"]
}

locals {
  common_tags = {
    environment = var.environment
    costcenter = var.costcenter
  }
  dbname= var.dbnames[0]
}

