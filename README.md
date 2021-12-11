# Setup

## Set variables
Ideally use a `.tfvars` file to set needed variables such as the **kube config path and credentials**, in order to keep a sane and consistent use of the default variables.

## Create state backend
As a quick and temporary solution to develop between machines and **not make the tfstate publicly available**, the cluster's own kubernetes backend is being used. Secrets in k8s have a 1MB size limitation but hopefully that won't be reached. \
Unfortunately, Terraform doesn't support variables or dynamic values in the backend configuration, so a separate file will be used. \
Create a `backend.conf` and make sure that `secret_suffix` and `config_path` match what you have in your `variables.tf` or `.tfvars`:

```bash
secret_suffix = "state"
config_path = "~/.kube/config"
```

## Init, plan and apply

Specify your backend config while performing the init, and plan/apply the rest as per the usual:

```bash
terraform init -backend-config="backend.conf"
terraform plan
terraform apply
```
