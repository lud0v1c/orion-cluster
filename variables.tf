variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "remote_state_secret_suffix" {
  type    = string
  default = "state"
}

variable "nfs_server" {
  type = string
}

variable "nfs_path" {
  type = string
}

variable "volume_music_path" {
  type = string
}

variable "volume_data_path" {
  type = string
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}
