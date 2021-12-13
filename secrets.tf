resource "kubernetes_secret" "grafana_admin_credentials" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = "monitoring"
  }

  data = {
    username = var.grafana_admin_user
    password = var.grafana_admin_password
  }

  type = "kubernetes.io/basic-auth"

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
