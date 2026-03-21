output "authelia_admin_password" {
  description = "Generated Authelia admin password. Store this securely after the first apply."
  value       = var.authelia != null ? random_password.authelia_admin[0].result : null
  sensitive   = true
}

output "authelia_admin_username" {
  description = "Default Authelia admin username."
  value       = var.authelia != null ? var.authelia.admin_username : null
}
