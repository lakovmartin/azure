terraform {
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
}
# Specify Terraform Version
required_version = ">= 1.1.1"
}

provider "azurerm" {
  features {}
}

variable "storage_account_name" {
  description = "The name of the storage account used by the function app"
  type        = string
  default     = "examplestoragename"
}

variable "app_service_plan_name" {
  description = "The name of the app service plan used by the function app"
  type        = string
  default     = "exampleserviceplanName"
}

variable "function_app_name" {
  description = "The name of the function app"
  type        = string
  default     = "examplefunctionappname"
}

variable "resource_group_name" {
  description = "The name of the new resource group the resources will be deployed in"
  type        = string
  default     = "exampleresourcegroupname"
}


resource "azurerm_resource_group" "function-rg" {
  name     = var.resource_group_name
  location = "UK South"
}

resource "azurerm_storage_account" "function-storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.function-rg.name
  location                 = azurerm_resource_group.function-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function-plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.function-rg.location
  resource_group_name = azurerm_resource_group.function-rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function-app" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.function-rg.location
  resource_group_name        = azurerm_resource_group.function-rg.name
  app_service_plan_id        = azurerm_app_service_plan.function-plan.id
  storage_account_name       = azurerm_storage_account.function-storage.name
  storage_account_access_key = azurerm_storage_account.function-storage.primary_access_key
  https_only                 = true
  os_type                    = "linux"
  version                    = "~4"
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }
}