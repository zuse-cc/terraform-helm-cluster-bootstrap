variable "bootstrap_repo_url" {
  type    = string
  default = "git@github.com:joerx/lab-cluster.sh.git"
}

variable "bootstrap_chart_version" {
  default = "0.1.0-41b887f0"
}

variable "bootstrap_chart_repo" {
  default = "oci://ghcr.io/joerx/helm"
}

variable "argocd_chart_version" {
  default = "9.4.2"
}

variable "argocd_chart_repo" {
  default = "https://argoproj.github.io/argo-helm"
}

variable "target_revision" {
  type    = string
  default = "main"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name to register the cluster deploy key on"
  default     = "lab-cluster.sh"
}

variable "infisical" {
  type = object({
    auth = object({
      client_id     = string
      client_secret = string
    })
    # project_id = optional(string) # Required when authelia.enabled = true
    project_slug = string
    environment  = string
    path         = string
  })
}

variable "authelia" {
  description = "Enable in-cluster authelia instance for oauth"
  default     = null

  type = object({
    admin_password         = string
    admin_password_version = number
  })
}

variable "cluster_name" {
  type = string
}

variable "cluster_domain" {
  type    = string
  default = null
}

variable "autosync" {
  default = false
  type    = bool
}

variable "external_dns_enabled" {
  default = true
  type    = bool
}

variable "letsencrypt_enabled" {
  default = true
  type    = bool
}

variable "letsencrypt_email" {
  type    = string
  default = null
}

variable "ghcr_username" {
  type = string
}

variable "ghcr_password" {
  type = string
}
