output "argocd-password" {
  value = data.kubernetes_secret.argo_password.data
  sensitive = true
}