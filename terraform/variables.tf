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

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}