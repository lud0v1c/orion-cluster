
# Very important - sets a provider for our NFS storage
# since k8s doesn't ship with an internal one
# Thanks to https://www.phillipsj.net/posts/k3s-enable-nfs-storage/
resource "helm_release" "nfs_subdir_external_provisioner" {
  name = "nfs-subdir-external-provisioner"

  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart = "nfs-subdir-external-provisioner"
  version = ">= 4.0.14"

  namespace = "default"

  set {
    name  = "nfs.server"
    value = var.nfs_server
  }
  set {
    name  = "nfs.path"
    value = var.nfs_path
  }
  set {
    name  = "storageClass.name"
    value = "nfs"
  }
  # Keep our files after PV deletion
  set {
    name  = "storageClass.reclaimPolicy"
    value = "Retain"
  }
}

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

# https://artifacthub.io/packages/helm/k8s-at-home/navidrome
resource "helm_release" "navidrome" {
  name = "navidrome"

  repository = "https://k8s-at-home.com/charts/"
  chart      = "navidrome"
  version    = ">= 6.2.0"

  namespace = "media"

  values = [
    "${file("helm/configs/navidrome/values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.media
  ]
}
