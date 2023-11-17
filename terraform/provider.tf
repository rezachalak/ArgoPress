
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig" # Path to your Kubernetes config file
  }
}

provider "kubernetes" {
  config_path = "../kubeconfig"
}