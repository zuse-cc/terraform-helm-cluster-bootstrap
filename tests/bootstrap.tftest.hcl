mock_provider "helm" {}

variables {
  cluster_name    = "dev-my-cluster"
  github_token    = "example-token"
  github_username = "octocat"

  infisical_project = "abc123"
  infisical_auth = {
    client_id     = "cli3nt-1d"
    client_secret = "s3cr3t"
  }
}

run "sets_correct_cluster_and_domain_name" {
  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "cluster.name" && s.value == var.cluster_name])
    error_message = "should set cluster name"
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "cluster.domain" && s.value == "${var.cluster_name}.local"])
    error_message = "should set cluster domain to ${var.cluster_name}.local"
  }
}

run "set_custom_domain_name_if_provided" {
  variables {
    cluster_domain = "my-cluster.dev.example.com"
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "cluster.domain" && s.value == "${var.cluster_domain}"])
    error_message = "should set cluster domain to ${var.cluster_domain}"
  }
}

run "toggle_autosync_on" {
  variables {
    autosync = true
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "autosync.enabled" && s.value == "true"])
    error_message = "should set autosync to enabled"
  }
}

run "toggle_dns_off" {
  variables {
    external_dns = false
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap_secrets.set_sensitive : s.name == "universalAuth.clientId" && s.value == var.infisical_auth.client_id])
    error_message = "should set universalAuth.clientId as sensitive value"
  }
}

run "set_sensitive_credentials" {
  assert {
    condition     = anytrue([for s in helm_release.bootstrap_secrets.set_sensitive : s.name == "universalAuth.clientSecret" && s.value == var.infisical_auth.client_secret])
    error_message = "should set universalAuth.clientSecret as sensitive value"
  }
}
