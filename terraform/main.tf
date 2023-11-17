resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  version          = "v1.13.1"
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  set {
    name  = "installCRDs"
    value = true
  }
}


resource "kubernetes_manifest" "clusterissuer_letsencrypt" {
  count      = var.create_k8s_manifests ? 1 : 0
  depends_on = [helm_release.cert-manager]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt"
    }
    "spec" = {
      "acme" = {
        "email" = "example@email.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-secret"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
}

resource "helm_release" "longhorn" {
  name             = "longhorn"
  namespace        = "longhorn-system"
  version          = "v1.5.1"
  create_namespace = true
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"

  set {
    name  = "numberOfReplicas"
    value = "1"
  }
}
resource "helm_release" "ingress" {
  name             = "ingress"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  set {
    name  = "controller.hostNetwork"
    value = true
  }
  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  set {
    name = "controller.allowSnippetAnnotations"
    value = true
  }
}

locals {
  # This hash forces Terraform to redeploy if a new template file is added or changed, or values are updated
  wordpress_chart_hash = sha1(join("", [for f in fileset(var.charts_path/wordpress, "**/*.yaml") : filesha1("${var.charts_path}/wordpress/${f}")]))
}

resource "helm_release" "wordpress" {
  name       = "wordpress"
  namespace  = "default"
  repository = "${var.charts_path}"
  chart      = "wordpress"
  version    = "1.16.0"
  values = [
    file("${var.charts_path}/wordpress/values.yaml")
  ]

  depends_on = [helm_release.longhorn, helm_release.cert-manager, helm_release.ingress]
  set {
    name  = "wordpress-chart-hash"
    value = local.wordpress_chart_hash
  }
}