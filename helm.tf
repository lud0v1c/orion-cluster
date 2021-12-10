resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "charts/grafana"
  namespace = "logging"

  values = [
    templatefile("charts/grafana/values.yaml", { adminUser = "${var.grafana_admin_user}", adminPassword = "${var.grafana_admin_password}" })
  ]
}
