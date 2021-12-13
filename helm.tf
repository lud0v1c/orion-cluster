resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = ">= 23.2.0"

  namespace = "monitoring"

  values = [
    templatefile("helm/configs/kube-prometheus-stack/values.yaml", { grafana_admin_user = "${var.grafana_admin_user}", grafana_admin_password = "${var.grafana_admin_password}" })
  ]

  depends_on = [
    kubernetes_secret.grafana_admin_credentials
  ]
}

resource "helm_release" "loki" {
  name = "loki"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = ">= 2.8.1"

  namespace = "monitoring"

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

resource "helm_release" "promtail" {
  name = "promtail"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = ">= 3.9.1"

  set {
    name  = "config.lokiAddress"
    value = "http://loki.monitoring:3100/loki/api/v1/push"
  }

  depends_on = [
    helm_release.loki
  ]
}
