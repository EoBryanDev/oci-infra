variable "tenancy_ocid" {
  type        = string
  description = "OCID da tenancy (budgets e quotas vivem no root)"
}

variable "compartment_id" {
  type        = string
  description = "OCID do compartment de workload (alvo do budget)"
}

variable "budget_alert_email" {
  type        = string
  description = "E-mail que recebe os alertas de gasto (não é sensível)"
}

variable "budget_amount_brl" {
  type        = number
  default     = 1
  description = "Teto simbólico mensal em R$; alertas disparam em >= R$1"
}

variable "max_a1_ocpus" {
  type        = number
  default     = 4
  description = "Teto de OCPUs A1 na tenancy (shape atual do cluster)"
}

variable "max_a1_memory_gb" {
  type        = number
  default     = 24
  description = "Teto de GB A1 na tenancy (shape atual do cluster)"
}
