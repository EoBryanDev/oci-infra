# A zona é REFERÊNCIA (data source), não recurso gerenciado.
# Motivo: a zona synit.top já existe no dashboard Cloudflare e é dona de
# plano/settings. O Terraform gerencia SÓ os records (dns.tf).
# Se usássemos resource + import na zona, um `terraform destroy` poderia
# apagar a zona inteira. Data source elimina esse risco.
data "cloudflare_zone" "this" {
  name = var.zone_name
}
