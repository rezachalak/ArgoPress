
# variable "charts_path" {
#   default = "../charts"
#   type    = string
# }

# variable "create_k8s_manifests" {
#   type = bool
# }

variable "argoUsername" {
  type        = string
  description = "argo username"
}

variable "argoPassword" {
  type        = string
  description = "argo password"

}

variable "argoNamespace" {
  type        = string
  description = "Name of the namespace where argocd is installed"
}

variable "argoServerAddr" {
  type        = string
  description = "ArgoCD Address"
}

variable "destinationCluster" {
  type = string
  description = "https://kubernetes.default.svc"
}