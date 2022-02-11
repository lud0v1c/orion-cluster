############### PV ###############
resource "kubernetes_persistent_volume" "music" {
  metadata {
    name = "music"
  }
  spec {
    capacity = {
      storage = "190Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        path = var.volume_music_path
        read_only = false
        server = var.nfs_server
      }
    }
  }

  depends_on = [
    helm_release.nfs_subdir_external_provisioner,
    kubernetes_namespace.media
  ]
}

resource "kubernetes_persistent_volume" "data_navidrome" {
  metadata {
    name = "data-navidrome"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "nfs"
    persistent_volume_source {
      nfs {
        path = "${var.volume_data_path}/navidrome"
        read_only = false
        server = var.nfs_server
      }
    }
  }

  depends_on = [
    helm_release.nfs_subdir_external_provisioner,
    kubernetes_namespace.media
  ]
}

############### PVC ###############
resource "kubernetes_persistent_volume_claim" "data_navidrome" {
  metadata {
    name = "data-navidrome"
    namespace = "media"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    selector {
        match_labels = {
            app = "navidrome"
        }
    }
    volume_name = "data-navidrome"
    storage_class_name = "nfs"
  }

  depends_on = [
    kubernetes_persistent_volume.data_navidrome
  ]
}

resource "kubernetes_persistent_volume_claim" "music_navidrome" {
  metadata {
    name = "music-navidrome"
    namespace = "media"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "190Gi"
      }
    }
    selector {
        match_labels = {
            app = "navidrome"
        }
    }
    volume_name = "music"
    storage_class_name = "nfs"
  }

  depends_on = [
    kubernetes_persistent_volume.music
  ]
}
