variable "zone_name" {
  type        = string
  description = "Zona DNS na Cloudflare (ex: synit.top)"
}

variable "lb_public_ip" {
  type        = string
  description = "IP público do OCI LB (vem do módulo oci)"
}

variable "argo_subdomain" {
  type        = string
  default     = "argo"
  description = "Subdomínio do ArgoCD (ex: argo -> argo.synit.top)"
}

variable "grafana_subdomain" {
  type        = string
  default     = "grafana"
  description = "Subdomínio do Grafana (ex: grafana -> grafana.synit.top)"
}

variable "palpitai_subdomain" {
  type        = string
  default     = "palpitai"
  description = "Subdomínio do PalpitAI (ex: palpitai -> palpitai.synit.top)"
}
