output "zone_id" {
  description = "ID da zona Cloudflare"
  value       = data.cloudflare_zone.this.id
}

output "argo_fqdn" {
  description = "FQDN público do ArgoCD"
  value       = cloudflare_record.argo.hostname
}
