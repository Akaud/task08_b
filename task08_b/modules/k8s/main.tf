resource "kubectl_manifest" "secret_provider_class" {
  provider = kubectl.aks_cluster_context
  yaml_body = templatefile("./k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = var.aks_node_identity_client_id
    kv_name                    = var.keyvault_name
    redis_url_secret_name      = var.redis_hostname
    redis_password_secret_name = var.redis_password
    tenant_id                  = var.tenant_id
  })
}

resource "kubectl_manifest" "app_deployment" {
  provider = kubectl.aks_cluster_context
  yaml_body = templatefile("./k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = var.acr_login_server
    app_image_name   = var.image_name
    image_tag        = "latest"
  })
  depends_on = [
    kubectl_manifest.secret_provider_class
  ]

  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

resource "kubectl_manifest" "app_service" {
  provider   = kubectl.aks_cluster_context
  yaml_body  = file("./k8s-manifests/service.yaml")
  depends_on = [kubectl_manifest.app_deployment]

  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
}

data "kubernetes_service" "app_service_lb" {
  provider = kubernetes.aks_cluster_context
  metadata {
    name = "redis-flask-app-service"
  }
  depends_on = [kubectl_manifest.app_service]
}
