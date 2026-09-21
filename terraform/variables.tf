# --- OCI: autenticação (via secrets da pipeline, nunca commitadas) ---
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "region" {}

# --- OCI: infraestrutura ---
variable "compartment_id" {
  type        = string
  description = "OCID do Compartment"
}

variable "availability_domain" {
  type        = string
  description = "Availability Domain (ex: Uocm:US-ASHBURN-AD-1)"
}

variable "image_id" {
  type        = string
  description = "OCID da imagem do SO"
}

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH"
}

variable "meu_ip" {
  type        = string
  description = "Meu IP público com CIDR para liberar SSH"
}

variable "meu_ip_adm" {
  description = "IP da maquina adm para gerenciar o K3s"
  type        = string
}

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "ocpus_per_node" {
  type    = number
  default = 2
}

variable "memory_per_node" {
  type    = number
  default = 12
}

# --- Cloudflare: DNS GitOps ---
variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Token API Cloudflare (template Edit zone DNS). Via secret TF_VAR_cloudflare_api_token."
}

variable "cloudflare_zone_name" {
  type        = string
  default     = "synit.top"
  description = "Zona DNS na Cloudflare"
}

variable "argo_subdomain" {
  type        = string
  default     = "argo"
  description = "Subdomínio do ArgoCD"
}

variable "grafana_subdomain" {
  type        = string
  default     = "grafana"
  description = "Subdomínio do Grafana"
}

variable "palpitai_subdomain" {
  type        = string
  default     = "palpitai"
  description = "Subdomínio do PalpitAI"
}

variable "eobryandev_subdomain" {
  type        = string
  default     = "eobryandev"
  description = "Subdomínio do portfólio"
}

# --- FinOps: guardrails Always Free ---
variable "budget_alert_email" {
  type        = string
  default     = "Eobryandev@gmail.com"
  description = "E-mail dos alertas de gasto (não sensível, sem secret)"
}
