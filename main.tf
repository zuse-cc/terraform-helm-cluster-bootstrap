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
    "autosync.enabled"      = var.autosync,
    "infisical.project"     = var.infisical_project,
    "infisical.path"        = var.infisical_path
  }
}

resource "tls_private_key" "bootstrap" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "bootstrap" {
  title      = "k8s-${var.cluster_name}"
  repository = var.github_repo
  key        = tls_private_key.bootstrap.public_key_openssh
  read_only  = true
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
  chart      = "cluster-bootstrap-argo"
  repository = var.bootstrap_chart_repo
  version    = var.bootstrap_chart_version
  namespace  = local.argocd_namespace

  set_sensitive = [
    {
      name  = "source.sshPrivateKey"
      value = tls_private_key.bootstrap.private_key_openssh
    }
  ]

  set = [
    for k, v in local.bootstrap_values : {
      name  = k,
      value = v
    }
  ]

  depends_on = [
    helm_release.argocd,
    github_repository_deploy_key.bootstrap,
  ]
}

resource "helm_release" "bootstrap_secrets" {
  name             = "bootstrap-secrets"
  chart            = "cluster-bootstrap-secrets"
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
