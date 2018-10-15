#----------------------------------------------
# Environment
#----------------------------------------------

variable "environment_name" {
  type = "string"
}

locals {
  environment_shortname = "${substr(var.environment_name, 0, 1)}"
}

#----------------------------------------------
# API Management
#----------------------------------------------

variable "name" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "West Europe"
}
