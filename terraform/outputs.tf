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