#----------------------------------------------
# Resource Group
#----------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

#----------------------------------------------
# Function App
#----------------------------------------------

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.name}-asp"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function" {
  name                      = "${var.name}"
  location                  = "${azurerm_resource_group.resource_group.location}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.app_service_plan.id}"
  storage_connection_string = "${azurerm_storage_account.storage.primary_connection_string}"

  identity = {
    type = "SystemAssigned"
  }
}

#----------------------------------------------
# Application Insights
#----------------------------------------------

resource "azurerm_application_insights" "application_insights" {
  name                = "${var.name}-insights"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${azurerm_resource_group.resource_group.location}"
  application_type    = "Web"
}

#----------------------------------------------
# Storage
#----------------------------------------------

resource "random_string" "storage_suffix" {
  length  = 4
  special = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "${substr(lower(replace(var.name, "-", "")),0,20)}${lower(random_string.storage_suffix.result)}"
  resource_group_name      = "${azurerm_resource_group.resource_group.name}"
  location                 = "${azurerm_resource_group.resource_group.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
