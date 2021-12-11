variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "remote_state_secret_suffix" {
  type    = string
  default = "state"
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}
