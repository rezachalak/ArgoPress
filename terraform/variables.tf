
variable "charts_path" {
  default = "../charts"
  type    = string
}

variable "create_k8s_manifests" {
  type = bool
}