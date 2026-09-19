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
  type        = string
  description = "IP da maquina adm para gerenciar o K3s"
}

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "ocpus_per_node" {
  type        = number
  default     = 2
  description = "OCPUs por node (pipeline já injeta via TF_VAR_ocpus_per_node)"
}

variable "memory_per_node" {
  type        = number
  default     = 12
  description = "Memória GB por node (pipeline já injeta via TF_VAR_memory_per_node)"
}

variable "pg_backup_bucket" {
  type        = string
  default     = "pg-backups"
  description = "Bucket Object Storage dos backups do Postgres (free 20GB)"
}
