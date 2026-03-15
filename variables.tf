variable "bootstrap_repo_url" {
  type    = string
  default = "git@github.com:joerx/lab-cluster.sh.git"
}

variable "bootstrap_chart_version" {
  default = "0.1.0-33385a00"
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

variable "infisical_auth" {
  type = object({
    client_id     = string
    client_secret = string
  })
}

variable "infisical_project" {
  type = string
}

variable "infisical_path" {
  type    = string
  default = "/shared/argocd/bootstrap"
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

variable "external_dns" {
  default = false
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
