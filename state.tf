data "terraform_remote_state" "this" {
  backend = "kubernetes"
  config = {
    secret_suffix    = var.remote_state_secret_suffix
    load_config_file = true
    config_path      = var.kube_config
  }
}
