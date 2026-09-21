# Records gerenciados pelo Terraform. Como ainda não existem,
# são CRIADOS (sem import). Se um dia houver records manuais para adotar,
# usar: terraform import module.cloudflare.cloudflare_record.argo <zone_id>/<record_id>
resource "cloudflare_record" "argo" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.argo_subdomain
  type    = "A"
  content = var.lb_public_ip
  proxied = true # nuvem laranja: TLS da borda + Origin Cert atrás
  ttl     = 1    # 1 = automático quando proxied
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.grafana_subdomain
  type    = "A"
  content = var.lb_public_ip
  proxied = true # nuvem laranja: TLS da borda + Origin Cert atrás
  ttl     = 1    # 1 = automático quando proxied
}

resource "cloudflare_record" "palpitai" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.palpitai_subdomain
  type    = "A"
  content = var.lb_public_ip
  proxied = true # nuvem laranja: TLS da borda + Origin Cert atrás
  ttl     = 1    # 1 = automático quando proxied
}

resource "cloudflare_record" "eobryandev" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.eobryandev_subdomain
  type    = "A"
  content = var.lb_public_ip
  proxied = true # nuvem laranja: TLS da borda + Origin Cert atrás
  ttl     = 1    # 1 = automático quando proxied
}
