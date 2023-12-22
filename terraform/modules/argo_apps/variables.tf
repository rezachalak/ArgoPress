variable "argoUsername" {
  type        = string
  description = "argo username"
}

variable "argoPassword" {
  type        = string
  description = "argo password"

}

variable "argoServerAddr" {
  type        = string
  description = "ArgoCD Address"
}

variable "argoNamespace" {
  type = string
  description = "The namespace where the argo apps will be stored"
}
variable "helmAppsGitRepoUrl" {
  type        = string
  description = "The git repository containing helm charts"
}

variable "helmAppsGitRepoBranch" {
  type        = string
  description = "The git branch of the specified repository containing helm charts"
}

variable "helmBasePath" {
  type        = string
  description = "Path of where the helm charts located"
}

variable "helmApps" {
  type        = map(object({ app_name = string, values_path = list(string), namespace = string, target_revision = string, repo_url = string, destination_cluster = string, destination_cluster = string }))
  description = "The list of helm apps specifications"
  # default = [ {} ]
}

variable "gitUsername" {
  type        = string
  description = "Username to authenticate to git (for private repositories)"
  default     = ""
}

variable "gitPassword" {
  type        = string
  description = "Password to authenticate to git (for private repositories)"
  default     = ""
  sensitive   = true
}

variable "gitSSHPrivateKey" {
  type        = string
  description = "SSH Private Key to authenticate in git (for private repositories)"
  default     = ""
  sensitive   = true
}

variable "destinationCluster" {
  type        = string
  description = "The address of api-server of th Kubernetes Cluster where the argocd applications will be deployed to"
  default     = "https://kubernetes.default.svc"
}