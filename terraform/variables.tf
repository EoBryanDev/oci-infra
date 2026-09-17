variable "compartment_id" {
  description = "OCID do Compartment na Oracle Cloud"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acesso às instâncias"
  type        = string
}