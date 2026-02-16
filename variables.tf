variable "bootstrap_repo_url" {
  type    = string
  default = "https://github.com/joerx/lab-cluster.sh.git"
}

variable "target_revision" {
  type    = string
  default = "main"
}

variable "github_token" {
  type = string
}

variable "github_username" {
  type = string
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

variable "argocd_chart_version" {
  default = "9.4.2"
}

variable "external_dns" {
  default = true
  type    = bool
}
