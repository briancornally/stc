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

variable "costcenter" {
  type    = string
  default = "IT"
}

variable "dbpassword" {
  type    = string
}

locals {
  environment = terraform.workspace
  common_tags = {
    environment = terraform.workspace
    costcenter  = var.costcenter
  }
  kvname = "${terraform.workspace}-${var.suffix}-kv"
  kvrg="${terraform.workspace}-${var.suffix}-kv"
}

