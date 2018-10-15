#----------------------------------------------
# Provider
#----------------------------------------------

variable "azure_client_id" {
  type = "string"
}

variable "azure_client_secret" {
  type = "string"
}

variable "azure_tenant_id" {
  type = "string"
}

variable "azure_subscription_id" {
  type = "string"
}

#----------------------------------------------
# Environment
#----------------------------------------------

variable "environment_name" {
  type = "string"
}

locals {
  environment_shortname = "${substr(var.environment_name, 0, 1)}"
}