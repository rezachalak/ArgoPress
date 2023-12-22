variable "aws_region" {
  type = string
  description = "AWS region to create the infrastructure"
  default = "eu-west-1"
}
variable "helm_repo_url" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "Helm repository"
}

variable "argocd_namespace" {
  description = "Namespace to release argocd into"
  type        = string
  default     = "argocd"
}

variable "create_namespace" {
  type = bool
  description = "Wheter create the given namespace or not"
  default = false
}

variable "argocd_helm_chart_version" {
  description = "argocd helm chart version to use"
  type        = string
  default     = ""
}

variable "argocd_server_host" {
  description = "Hostname for argocd (will be utilised in ingress if enabled)"
  type        = string
  default     = "argocd.calvineotieno.com"
}

variable "argocd_ingress_class" {
  description = "Ingress class to use for argocd"
  type        = string
  default     = "nginx"
}

variable "argocd_ingress_enabled" {
  description = "Enable/disable argocd ingress"
  type        = bool
  default     = true
}

variable "argocd_ingress_tls_acme_enabled" {
  description = "Enable/disable acme TLS for ingress"
  type        = string
  default     = "true"
}

variable "argocd_ingress_ssl_passthrough_enabled" {
  description = "Enable/disable SSL passthrough for ingresss"
  type        = string
  default     = "true"
}

variable "argocd_ingress_tls_secret_name" {
  description = "Secret name for argocd TLS cert"
  type        = string
  default     = "argocd-cert"
}

variable "argocd_name" {
  default = "argocd-demo"
}

