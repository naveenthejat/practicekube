provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "aks_cluster" {
  name     = "aks-cluster-rg"
  location = "eastus"
}
resource "azurerm_virtual_network" "aks_cluster" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.aks_cluster.location}"
  resource_group_name = "${azurerm_resource_group.aks_cluster.name}"

  subnet {
    name           = "aks-subnet"
    address_prefix = "10.0.1.0/24"
  }
}
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = "${azurerm_resource_group.aks_cluster.location}"
  resource_group_name = "${azurerm_resource_group.aks_cluster.name}"
  dns_prefix          = "aks-cluster"

  agent_pool_profile {
    name            = "agentpool1"
    count           = 3
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
  }

  service_principal {
    client_id     = "YOUR_APP_ID"
    client_secret = "YOUR_APP_SECRET"
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"
    pod_cidr       = "10.244.0.0/16"
  }

  depends_on = [
    azurerm_virtual_network.aks_cluster
  ]
}
