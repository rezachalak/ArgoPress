resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace?1:0
  metadata {
    name = var.argocd_namespace
  }
}
resource "helm_release" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd
  ]
  name             = "argocd-${var.argocd_name}"
  repository       = var.helm_repo_url
  chart            = "argo-cd"
  namespace        = var.argocd_namespace
  create_namespace = false
  version          = var.argocd_helm_chart_version == "" ? null : var.argocd_helm_chart_version

  values = [
    templatefile(
      "./templates/values.yaml.tpl",
      {
        "argocd_ingress_enabled"          = var.argocd_ingress_enabled
        "argocd_ingress_class"            = "alb"
        "argocd_server_host"              = var.argocd_server_host
        "argocd_load_balancer_name"       = "argocd-${var.argocd_name}-alb-ingress"
        "argocd_ingress_tls_acme_enabled" = true
        "argocd_acm_arn"                  = data.terraform_remote_state.eks.outputs.aws_acm_certificate_arn
      }
    )
  ]

  set {
    name  = "server.service.type"
    value = "NodePort"
    type  = "string"
  }
}

data "kubernetes_service" "argo_nodeport" {
  depends_on = [
    helm_release.argocd
  ]
  metadata {
    name      = "argocd-${var.argocd_name}-server"
    namespace = var.argocd_namespace
  }
}
