# Composição dos módulos por provedor. A raiz não cria recurso direto:
# só injeta variáveis e re-exporta outputs.

module "oci" {
  source = "./modules/oci"

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  image_id            = var.image_id
  ssh_public_key      = var.ssh_public_key
  meu_ip              = var.meu_ip
  meu_ip_adm          = var.meu_ip_adm
  instance_shape      = var.instance_shape
  ocpus_per_node      = var.ocpus_per_node
  memory_per_node     = var.memory_per_node
}

module "cloudflare" {
  source = "./modules/cloudflare"

  zone_name         = var.cloudflare_zone_name
  lb_public_ip      = module.oci.lb_public_ip
  argo_subdomain    = var.argo_subdomain
  grafana_subdomain = var.grafana_subdomain
}

module "finops" {
  source = "./modules/finops"

  tenancy_ocid       = var.tenancy_ocid
  budget_alert_email = var.budget_alert_email
}
