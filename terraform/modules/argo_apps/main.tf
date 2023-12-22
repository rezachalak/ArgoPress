resource "argocd_account_token" "name" {
  
}

resource "argocd_application" "helmApps" {
  for_each   = var.helmApps
  metadata {
    name      = each.value.app_name
    namespace = var.argoNamespace
    labels = {
      test = "true"
    }
  }

  spec {
    destination {
      server    = var.destinationCluster
      namespace = each.value.namespace
    }

    source {
      repo_url        = each.value.repo_url
      # path            = each.value.repo_path
      target_revision = each.value.target_revision
      helm {
        value_files = each.value.values_path
      }
    }
  }
}

# The namespace the project will reside in
resource "kubernetes_namespace" "app_namespace" {
  for_each   = var.helmApps
  metadata {
    name = each.value.namespace_name
  }
}

# Create the ArgoCD Project.
module "project" {
  for_each = var.helmApps
  source  = "project-octal/argocd-project/kubernetes"
  version = "1.0.4"
  namespace = var.argoNamespace
  # argocd_namespace = var.argocd_namespace
  name             = each.value.app_name
  description      = each.value.project_description
  destinations = [
    {
      server    = each.value.destination_cluster
      namespace = kubernetes_namespace.app_namespace.metadata.0.name
    }
  ]
  permissions = [
    {
      name = "developer-read-only"
      description = "A read-only role for the developers"
      policies = [
        {
          resource = "applications"
          action = "get"
          object = "*"
        }
      ]
    }
  ]
}