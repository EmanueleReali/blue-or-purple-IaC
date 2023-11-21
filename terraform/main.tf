terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = "52dcfd9b-faf4-4a5b-aaf8-4d5a815a06e4"
  client_secret   = "Q4m8Q~JBTWmWBfEB.X_kejLCqPsXIScczBWBAcI~"
  tenant_id       = "ce5c47ef-5061-41b0-b92f-bb2bcbfd6b72"
  subscription_id = "8b7d19bd-5c73-4366-ab89-2449d95b230f"
}



resource "azurerm_resource_group" "example" {
  name     = "C9LAB-RG-ER"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "C9LAB-AKS-ER-TF"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}
