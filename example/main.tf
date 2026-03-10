module "argocd" {
  source = "./.."

  autosync     = true
  cluster_name = var.cluster_name

  infisical_auth = {
    client_id     = var.infisical_auth_client_id
    client_secret = var.infisical_auth_client_secret
  }

  infisical_project = var.infisical_project
  infisical_path    = var.infisical_path
}
