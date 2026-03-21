mock_provider "helm" {}

mock_provider "github" {}

mock_provider "infisical" {}

mock_provider "random" {}

variables {
  cluster_name  = "dev-my-cluster"
  ghcr_username = "example-token"
  ghcr_password = "octocat"

  infisical = {
    project_slug = "abc123"
    path         = "/"
    environment  = "tst"
    auth = {
      client_id     = "cli3nt-1d"
      client_secret = "s3cr3t"
    }
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

run "set_sensitive_credentials" {
  assert {
    condition     = anytrue([for s in helm_release.bootstrap_secrets.set_sensitive : s.name == "universalAuth.clientSecret" && s.value == var.infisical.auth.client_secret])
    error_message = "should set universalAuth.clientSecret as sensitive value"
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap_secrets.set_sensitive : s.name == "universalAuth.clientId" && s.value == var.infisical.auth.client_id])
    error_message = "should set universalAuth.clientId as sensitive value"
  }
}

run "authelia_disabled_by_default" {
  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "authelia.enabled" && s.value == "false"])
    error_message = "should set authelia.enabled to false when authelia variable is null"
  }

  assert {
    condition     = length(infisical_secret.authelia_users) == 0
    error_message = "should not create authelia_users secret when authelia is disabled"
  }

  assert {
    condition     = length(random_password.authelia_admin) == 0
    error_message = "should not generate a password when authelia is disabled"
  }
}

run "authelia_enabled" {
  variables {
    authelia = {
      admin_password_version = 1
    }
  }

  assert {
    condition     = anytrue([for s in helm_release.bootstrap.set : s.name == "authelia.enabled" && s.value == "true"])
    error_message = "should set authelia.enabled to true when authelia variable is set"
  }

  assert {
    condition     = length(infisical_secret.authelia_users) == 1
    error_message = "should create authelia_users secret when authelia is enabled"
  }

  assert {
    condition     = length(random_password.authelia_admin) == 1
    error_message = "should generate a random password when authelia is enabled"
  }
}
