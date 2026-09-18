resource "oci_load_balancer_load_balancer" "k3s_lb" {
  compartment_id = var.compartment_id
  display_name   = "k3s-public-lb"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.k3s_subnet.id]
  is_private     = false

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_backend_set" "http_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  name             = "http_backend_set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 80
  }
}

# Associa o Master (onde roda o Traefik/Ingress por padrão) ao Load Balancer
resource "oci_load_balancer_backend" "http_backends" {
  for_each         = oci_core_instance.k3s_nodes
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  backendset_name  = oci_load_balancer_backend_set.http_backend_set.name
  ip_address       = each.value.private_ip
  port             = 80
}

resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_lb.id
  name                     = "http_listener"
  default_backend_set_name = oci_load_balancer_backend_set.http_backend_set.name
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend_set" "https_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  name             = "https_backend_set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 443
  }
}

resource "oci_load_balancer_listener" "https_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_lb.id
  name                     = "https_listener"
  default_backend_set_name = oci_load_balancer_backend_set.https_backend_set.name
  port                     = 443
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend" "https_backends" {
  for_each         = oci_core_instance.k3s_nodes
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  backendset_name  = oci_load_balancer_backend_set.https_backend_set.name
  ip_address       = each.value.private_ip
  port             = 443
}