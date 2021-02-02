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

variable "azdevopssp" {
  type = string
  default = "c7ebe7b1-6756-4623-aebe-fa1e61d010ee"
}

variable "azdevopstenant" {
  type = string
  default = "d5170891-80d3-48d7-b234-133c0715d5d9"
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

