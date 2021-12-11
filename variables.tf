variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}
