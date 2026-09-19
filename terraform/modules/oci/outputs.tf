output "lb_public_ip" {
  description = "IP Público do Load Balancer (Aponte seu domínio para cá)"
  value       = oci_load_balancer_load_balancer.k3s_lb.ip_address_details[0].ip_address
}

output "master_public_ip" {
  description = "IP Público do K3s Master (Para acesso SSH)"
  value       = oci_core_instance.k3s_nodes["k3s-master"].public_ip
}

output "worker_public_ip" {
  description = "IP Público do K3s Worker (Para acesso SSH)"
  value       = oci_core_instance.k3s_nodes["k3s-worker"].public_ip
}

output "master_private_ip" {
  description = "IP privado do master (K3S_URL interno do worker)"
  value       = oci_core_instance.k3s_nodes["k3s-master"].private_ip
}

output "github_secret_OCI_USER_OCID" {
  description = "OCID do usuario para o GitHub Actions"
  value       = oci_identity_user.pipeline_user.id
}

output "github_secret_OCI_FINGERPRINT" {
  description = "Fingerprint da chave de API gerada"
  value       = oci_identity_api_key.pipeline_api_key.fingerprint
}

output "github_secret_OCI_PRIVATE_KEY" {
  description = "Chave Privada PEM (Marque como sensitive no TF, mas copie para o GitHub)"
  value       = tls_private_key.pipeline_key.private_key_pem
  sensitive   = true
}

output "pg_backup_bucket" {
  description = "Bucket dos backups do Postgres"
  value       = oci_objectstorage_bucket.pg_backups.name
}

output "pg_backup_namespace" {
  description = "Namespace Object Storage (endpoint S3)"
  value       = data.oci_objectstorage_namespace.this.namespace
}

output "github_secret_S3_ACCESS_KEY" {
  description = "Access Key S3 do backup (copiar para o GitHub)"
  value       = oci_identity_customer_secret_key.backup_svc.id
}

output "github_secret_S3_SECRET_KEY" {
  description = "Secret Key S3 do backup (copiar para o GitHub)"
  value       = oci_identity_customer_secret_key.backup_svc.key
  sensitive   = true
}
