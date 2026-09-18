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