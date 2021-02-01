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

variable "environment" {
  type    = string
  default = "tf"
}

locals {
  common_tags = {
    environment = var.environment
    costcenter  = var.costcenter
  }
  saname = "tf${lower(var.suffix)}${random_integer.sa_num.result}"
  sarg   = "tf-${var.suffix}-be"
}
