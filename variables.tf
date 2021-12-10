variable "kube_config" {
  type    = string
  default = "~/.kube/orion"
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type = string
}
