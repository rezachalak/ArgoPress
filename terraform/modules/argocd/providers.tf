provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "argocd-demo"
      ManagedBy = "Terraform"
    }
  }
}

# get EKS authentication for being able to manage k8s objects from terraform
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "${data.terraform_remote_state.eks.outputs.cluster_name}"]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "${data.terraform_remote_state.eks.outputs.cluster_name}"]
      command     = "aws"
    }
  }
}

// NOTE - # args        = ["eks", "get-token", "--cluster-name", [cluster_name], "--region", [aws_region]]
