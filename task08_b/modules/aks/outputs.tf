output "aks_id" {
  description = "The ID of the Azure Kubernetes Service cluster."
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_kube_config" {
  description = "The KubeConfig block for the AKS cluster (object)."
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config[0]
  sensitive   = true
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_principal_id" {
  description = "The Principal ID of the AKS cluster's Kubelet Managed Identity."
  value       = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}

output "aks_kube_config_raw" {
  description = "The raw KubeConfig content for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive   = true
}

output "aks_node_identity_client_id" {
  description = "Client ID of the User-Assigned Managed Identity for AKS nodes."
  value       = azurerm_user_assigned_identity.aks_node_identity.client_id
}
