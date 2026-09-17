terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

# A autenticação será puxada automaticamente da pasta ~/.oci/config da sua VPS
provider "oci" {
  config_file_profile = "DEFAULT"
}

# Exemplo: O bloco da sua instância usará a variável ao invés do valor direto
# resource "oci_core_instance" "k3s_master" {
#   compartment_id      = var.compartment_id
#   availability_domain = "..."
#   ...
# }