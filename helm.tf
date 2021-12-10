resource "helm_release" "promtail" {
  name  = "promtail"
  chart = "charts/promtail"
}

resource "helm_release" "loki" {
  name      = "loki"
  chart     = "charts/loki"
  namespace = "monitoring"

  depends_on = [
    helm_release.promtail
  ]
}

resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "charts/grafana"
  namespace = "monitoring"

  values = [
    templatefile("charts/grafana/values.yaml", { adminUser = "${var.grafana_admin_user}", adminPassword = "${var.grafana_admin_password}" })
  ]

  depends_on = [
    helm_release.loki
  ]
}
