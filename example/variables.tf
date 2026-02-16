variable "kubeconfig_path" {
  description = "value"
  default     = "~/.kube/config"
  type        = string
}

variable "infisical_auth_client_id" {
  type = string
}

variable "infisical_auth_client_secret" {
  type = string
}

variable "infisical_project" {
  type = string
}

variable "infisical_path" {
  type    = string
  default = "/shared/argocd/bootstrap"
}

variable "github_token" {
  type = string
}

variable "github_username" {
  type = string
}

variable "cluster_name" {
  default = "my-lab-cluster"
}
