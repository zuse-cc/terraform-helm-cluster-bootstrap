output "authelia_admin_password" {
  description = "Generated Authelia admin password. Store this securely after the first apply."
  value       = local.admin_password
  sensitive   = true
}

output "authelia_admin_username" {
  description = "Default Authelia admin username."
  value       = var.authelia != null ? var.authelia.admin_username : null
}

output "argocd_endpoint" {
  value = local.argocd_endpoint
}
