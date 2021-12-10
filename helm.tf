resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "charts/grafana"
  namespace = "logging"

  values = [
    templatefile("charts/grafana/values.yaml", { adminUser = "${var.grafana_admin_user}", adminPassword = "${var.grafana_admin_password}" })
  ]
}

resource "helm_release" "loki" {
  name      = "loki"
  chart     = "charts/loki"
  namespace = "logging"

  depends_on = [
    helm_release.grafana
  ]
}
