data "infisical_identity_details" "current" {}

data "infisical_projects" "p" {
  slug = var.infisical.project_slug
}

resource "infisical_secret" "ghcr_secret" {
  name         = local.ghcr_pull_secret_name
  value        = jsonencode({ username = var.ghcr_username, password = var.ghcr_password })
  env_slug     = var.infisical.environment
  workspace_id = data.infisical_projects.p.id
  folder_path  = var.infisical.path
}
