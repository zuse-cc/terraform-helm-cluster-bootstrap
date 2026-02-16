module "argocd" {
  source = "./.."

  autosync        = true
  cluster_name    = var.cluster_name
  github_token    = var.github_token
  github_username = var.github_username

  infisical_auth = {
    client_id     = var.infisical_auth_client_id
    client_secret = var.infisical_auth_client_secret
  }

  infisical_project = var.infisical_project
  infisical_path    = var.infisical_path
}
