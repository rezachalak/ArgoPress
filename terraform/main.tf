module "argocd" {
  source = "./modules/argocd"
  argocd_name = "argocd"
  helm_repo_url = "https://argoproj.github.io/argo-helm"
  argocd_namespace = "argo"
  argocd_helm_chart_version = "5.34.5"
  argocd_ingress_enabled = false
  # argocd_server_host = ""
  # name             = "argocd"
  # namespace_name   = "argo"
  # create_namespace = true
  # repository       = "https://argoproj.github.io/argo-helm"
  # chart            = "argo-cd"
  # chart_version    = "5.34.5"
  # helm_values      = "../helm-values/argocd-values.yml"
}

data "kubernetes_secret" "argo_init_password" {
  depends_on = [ module.argoApps ]
  metadata {
    name = "argocd-initial-admin-secret"
    namespace = var.argoNamespace
  }
}

data "kubernetes_secret" "argo_password" {
  depends_on = [ module.argocd ]
  metadata {
    name = "argocd-secret"
    namespace = var.argoNamespace
  }
}
locals {
  argoInitPassword = data.kubernetes_secret.argo_init_password.data["password"]
  argoPassword = data.kubernetes_secret.argo_init_password.data["password"]
}

module "argoApps" {
  depends_on = [ module.argocd ]
  source                = "./modules/argo_apps"
  argoNamespace         = var.argoNamespace
  argoUsername          = var.argoUsername
  argoPassword          = local.argoPassword
  argoServerAddr        = "kubernetes.default.svc:443"
  helmAppsGitRepoUrl    = "https://github.com/rezachalak/ArgoPress.git"
  helmAppsGitRepoBranch = "main"
  helmBasePath          = "charts"
  helmApps = {
    longhorn = {
      app_name        = "longhorn"
      repo_url        = "https://charts.longhorn.io"
      values_path     = ["../helm-values/longhorn-values.yml"]
      namespace       = "longhorn-system"
      target_revision = "v1.5.1"
    },
    wordpress = {
      app_name    = "wordpress"
      repo_url    = "../charts/wordpress"
      values_path = ["../helm-values/wordpress-values.yml"]
      namespace   = "wordpress"
      target_revision = "main"
    },
    cert-manager = {
      app_name        = "cert-manager"
      repo_url        = "https://charts.jetstack.io"
      values_path     = ["../helm-values/cert-manager-values.yml",]
      namespace       = "cert-manager"
      target_revision = "v1.13.1"
    },
    ingress = {
      app_name        = "ingress-nginx"
      repo_url        = "https://kubernetes.github.io/ingress-nginx"
      values_path     = ["../helm-values/nginx-ingress-values.yml"]
      namespace       = "ingress-nginx"
      target_revision = "v1.9.4"
    }
  }
  # gitUsername = ""
  # gitPassword = ""
  # gitSSHPrivateKey = ""
  destinationCluster = var.destinationCluster
}

# resource "argocd_repository_credentials" "myRepoCred" {
#   url = var.appGitRepoUrl
#   username = var.gitUsername
#   password = var.gitPassword
#   ssh_private_key = var.gitSSHPrivateKey
#   depends_on = [ helm_release.argocd ]
# }

# resource "kubernetes_namespace" "namespace" {
#   for_each = var.helmApps
#   metadata {
#     labels = {
#       created-by = "terraform"
#     }
#     name = each.value["namespace"]
#   }
# }