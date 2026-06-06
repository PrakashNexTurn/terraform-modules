output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "kube_config" {
  description = "Kubernetes configuration for connecting to the cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "node_resource_group" {
  description = "Resource group containing AKS cluster nodes"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "tenant_id" {
  description = "Tenant ID of the system-assigned managed identity"
  value       = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
}

output "kubelet_identity" {
  description = "Kubelet identity configuration"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity
}

output "cluster_portal_fqdn" {
  description = "Portal FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.portal_fqdn
}

output "cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster (if private cluster is enabled)"
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "additional_node_pool_ids" {
  description = "IDs of additional node pools"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.additional : k => v.id }
}
