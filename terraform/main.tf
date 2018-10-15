provider "azurerm" {
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
  subscription_id = "${var.azure_subscription_id}"
}

module "azure_function" {
  source              = "./modules/azure_function"
  name                = "horizon-${local.environment_shortname}-datalogger-tesla"
  resource_group_name = "horizon-${local.environment_shortname}-datalogger-tesla"
  environment_name    = "${var.environment_name}"
}
