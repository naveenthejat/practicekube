provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "aks_cluster" {
  name     = "aks-cluster-rg"
  location = "eastus"
}
