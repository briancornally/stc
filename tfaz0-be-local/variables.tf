#############################################################################
# VARIABLES
#############################################################################

variable "suffix" {
  type    = string
  default = "tf"
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

locals {
  common_tags = {
    environment = var.environment
    costcenter  = var.costcenter
  }
  saname = "${lower(var.suffix)}${random_integer.sa_num.result}"
  sarg   = "all-${var.suffix}-be"
}
