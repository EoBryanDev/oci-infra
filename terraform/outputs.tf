# Re-exporta outputs dos módulos para manter os mesmos nomes de antes.

output "lb_public_ip" {
  description = "IP Público do Load Balancer (Aponte seu domínio para cá)"
  value       = module.oci.lb_public_ip
}

output "master_public_ip" {
  description = "IP Público do K3s Master (Para acesso SSH)"
  value       = module.oci.master_public_ip
}

output "worker_public_ip" {
  description = "IP Público do K3s Worker (Para acesso SSH)"
  value       = module.oci.worker_public_ip
}

output "argo_fqdn" {
  description = "FQDN público do ArgoCD"
  value       = module.cloudflare.argo_fqdn
}

output "github_secret_OCI_USER_OCID" {
  description = "OCID do usuario para o GitHub Actions"
  value       = module.oci.github_secret_OCI_USER_OCID
}

output "github_secret_OCI_FINGERPRINT" {
  description = "Fingerprint da chave de API gerada"
  value       = module.oci.github_secret_OCI_FINGERPRINT
}

output "github_secret_OCI_PRIVATE_KEY" {
  description = "Chave Privada PEM (Marque como sensitive no TF, mas copie para o GitHub)"
  value       = module.oci.github_secret_OCI_PRIVATE_KEY
  sensitive   = true
}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [k3s_master]
    master-node ansible_host=${module.oci.master_public_ip}

    [k3s_worker]
    worker-node ansible_host=${module.oci.worker_public_ip}

    [all:vars]
    ansible_user=ubuntu
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT

  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
