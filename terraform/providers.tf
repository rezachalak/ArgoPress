
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

provider "helm" {
  kubernetes {
    config_context = "minikube"
    config_path    = "~/.kube/config"
    # config_path = "../kubeconfig" # Path to your Kubernetes config file
  }
}


provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "minikube"
}

provider "argocd" {
  kubernetes {
    # config_path = "~/.kube/config"
    config_context = "minikube"
  }
  port_forward_with_namespace = "argo"
  username                    = var.argoUsername
  password                    = local.argoPassword
  # password = local.argocdAdminPassword.data["admin.password"]
}