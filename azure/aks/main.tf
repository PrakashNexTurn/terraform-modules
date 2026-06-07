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
