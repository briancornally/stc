#############################################################################
# VARIABLES
#############################################################################

variable "resource_group_suffix" {
  type = string
  default = "app1"
}

variable "location" {
  type    = string
  default = "southeastasia"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "prefix" {
  type    = string
  default = "tc"
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

variable "DbPassword" {
  type    = string
}

locals {
  common_tags = {
    environment = var.environment
    costcenter = var.costcenter
  }
}

