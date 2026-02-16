# terraform-helm-cluster-bootstrap

Terraform module to bootstrap Kubernetes clusters using helm and ArgoCD. The module acts as a thin domain 
adapter between the infrastructure layer providing the k8s cluster and the ArgoCD repo providing the cluster 
control plane and application support layer (telemetry, certs, etc.)

It is intentionally only doing the bare minimum: Providing a minimal bootstrap configuration, leaving
most cluster operations to ArgoCD and the cloud native toolchain that is much better suited for the job.
To get things going in a fresh cluster, we need to do three things:

- Deploy ArgoCD itself, we can do that using their upstream helm chart
- Deploy a manifest for the ArgoCD bootstrap application along with GH creds to clone the repo
- Deploy secret zero: The initial set of credentials needed for external-dns to set up SecretStores 

Using a helm release here prevents the pre-flight validation that `kubernetes_*` resources would need:
We are essentially using helm as an adapter between TF and k8s to handle k8s resource lifecycle outside of TF

This removes the need for complex orchestration logic on the Terraform side and allows this to work even with 
the cluster created in the same apply operation as the `helm_release`.


## Prerequisites

Terraform, `jq` and a recent version of the [Github CLI](https://cli.github.com/) are required.

## Usage

You need a k8s cluster running and a kube config file pointing to it.

Create a local `.terraform.tfvars` file with the necessary credentials:

```hcl
# example/terraform.tfvars
infisical_auth_client_id     = "..."
infisical_auth_client_secret = "..."
infisical_project            = "..."
infisical_path               = "..."
github_token                 = "..."
github_username              = "..."
```

To apply locally you may need to provide a custom `kubeconfig_path` to Terraform:

```sh
cd example/
terraform apply -var kubeconfig_path=$KUBECONFIG
```

### Code Formatting

To format all Terraform code, test and tfvars files:

```sh
make fmt
```

### Tests

The following will run all included Terraform tests locally:

```sh
make test
```

## Releasing

To create a new release in GH, which will also publish release assets:

```sh
make release VERSION=v0.2.1
```
