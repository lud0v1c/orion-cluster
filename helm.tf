resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "charts/grafana"
  namespace = "logging"
}
