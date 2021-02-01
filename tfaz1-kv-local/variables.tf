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

variable "environment" {
  type    = string
  default = "dev"
}

variable "costcenter" {
  type    = string
  default = "IT"
}

variable "dbpassword" {
  type    = string
}

locals {
  common_tags = {
    environment = var.environment
    costcenter  = var.costcenter
  }
  kvname = "${var.environment}-${var.suffix}-kv"
  kvrg="${var.environment}-${var.suffix}-kv"
}

