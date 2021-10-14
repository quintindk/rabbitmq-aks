locals {
  project = "rabbitmq"
  environment = var.environment
  location = var.location
}

data "azurerm_client_config" "current" {}

## Resource Group
resource "azurerm_resource_group" "rabbit_rg" {
  name = "rg-${local.project}-${local.environment}-${local.location}"
  location = local.location
}

## Key Vault
resource "azurerm_key_vault" "rabbit_kv" {
  name                        = "kv-${local.project}-${local.environment}"
  location                    = azurerm_resource_group.rabbit_rg.location
  resource_group_name         = azurerm_resource_group.rabbit_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_kubernetes_cluster.rabbit_aks.identity[0].principal_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

## Azure Kubernetes
resource "azurerm_kubernetes_cluster" "rabbit_aks" {
  name                        = "aks-${local.project}-${local.environment}"
  location                    = azurerm_resource_group.rabbit_rg.location
  resource_group_name         = azurerm_resource_group.rabbit_rg.name
  dns_prefix                  = "rabbitaks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "SystemAssigned"
  }
}


