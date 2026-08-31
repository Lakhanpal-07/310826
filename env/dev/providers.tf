terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " 5.3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "3108"
    storage_account_name = "stg31082026"
    container_name       = "3108con"
    key                  = "cicd.tfstate"
  }
}
provider "azurerm" {
  features {}
}
