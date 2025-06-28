terraform {
  required_providers {
    kubectl = {
      source                = "alekc/kubectl"
      version               = "~> 2.1"
      configuration_aliases = [kubectl.aks_cluster_context]
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = "~> 2.0"
      configuration_aliases = [kubernetes.aks_cluster_context]
    }
  }
}