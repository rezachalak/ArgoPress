terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
  }
}
