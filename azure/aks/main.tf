resource "azurerm_kubernetes_cluster" "aks" {

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group

  dns_prefix = var.cluster_name

  default_node_pool {
    name       = "system"
    vm_size    = local.config.vm_size
    node_count = local.config.node_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control_enabled = true

  tags = local.tags
}

data "azurerm_container_registry" "acr" {
  name                = "nextopsacrdemo"
  resource_group_name = "NexTOps-RCS"
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"

  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
