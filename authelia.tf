# bcrypt() generates a new salt on every plan, so the secret value will differ
# each apply even if the password hasn't changed. This is acceptable for a
# bootstrap module - the resulting hash is always valid for the given password.

locals {
  authelia_users_database = var.authelia != null ? jsonencode({
    "users_database" = <<-EOT
      users:
        admin:
          displayname: Admin
          password: "${bcrypt(var.authelia.admin_password)}"
          email: admin@${local.cluster_domain}
          groups:
            - admins
    EOT
  }) : null
}

resource "infisical_secret" "authelia_users" {
  count = var.authelia != null ? 1 : 0

  name             = "authelia-users"
  value_wo         = local.authelia_users_database
  value_wo_version = var.authelia.admin_password_version
  env_slug         = var.infisical.environment
  workspace_id     = data.infisical_projects.p.id
  folder_path      = var.infisical.path
}
