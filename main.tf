locals {
  argocd_namespace           = "argocd"
  external_secrets_namespace = "external-secrets"
  cluster_domain             = var.cluster_domain != null ? var.cluster_domain : "${var.cluster_name}.local"

  bootstrap_values = {
    "cluster.name"          = var.cluster_name,
    "cluster.domain"        = local.cluster_domain,
    "externalDNS.enabled"   = var.external_dns,
    "source.repoURL"        = var.bootstrap_repo_url,
    "source.targetRevision" = var.target_revision,
    "source.username"       = var.github_username,
    "autosync.enabled"      = var.autosync,
    "infisical.project"     = var.infisical_project,
    "infisical.path"        = var.infisical_path
  }
}

resource "helm_release" "argocd" {
  name             = "argo-cd"
  chart            = "argo-cd"
  repository       = var.argocd_chart_repo
  version          = var.argocd_chart_version
  namespace        = local.argocd_namespace
  create_namespace = true
  wait             = true
}

resource "helm_release" "bootstrap" {
  name       = "bootstrap-argo"
  chart      = "bootstrap-argo"
  repository = var.bootstrap_chart_repo
  version    = var.bootstrap_chart_version
  namespace  = local.argocd_namespace

  set_sensitive = [
    {
      name  = "source.password"
      value = var.github_token
    }
  ]

  set = [
    for k, v in local.bootstrap_values : {
      name  = k,
      value = v
    }
  ]

  depends_on = [
    helm_release.argocd
  ]
}

resource "helm_release" "bootstrap_secrets" {
  name             = "bootstrap-secrets"
  chart            = "bootstrap-secrets"
  repository       = var.bootstrap_chart_repo
  version          = var.bootstrap_chart_version
  namespace        = local.external_secrets_namespace
  create_namespace = true

  set_sensitive = [
    {
      name  = "universalAuth.clientId"
      value = var.infisical_auth.client_id
    },
    {
      name  = "universalAuth.clientSecret"
      value = var.infisical_auth.client_secret
    }
  ]
}
