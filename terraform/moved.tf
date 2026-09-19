# A reorganização em módulos muda o endereço dos recursos no state
# (ex: oci_core_vcn.k3s_vcn -> module.oci.oci_core_vcn.k3s_vcn).
# Sem estes blocos, o próximo apply destruiria e RECRIARIA toda a
# infraestrutura (incluindo as VMs do cluster). Com eles, é só rename.
# Após um apply com sucesso, este arquivo pode ser removido.

moved {
  from = oci_core_vcn.k3s_vcn
  to   = module.oci.oci_core_vcn.k3s_vcn
}

moved {
  from = oci_core_internet_gateway.igw
  to   = module.oci.oci_core_internet_gateway.igw
}

moved {
  from = oci_core_route_table.public_rt
  to   = module.oci.oci_core_route_table.public_rt
}

moved {
  from = oci_core_security_list.k3s_sec_list
  to   = module.oci.oci_core_security_list.k3s_sec_list
}

moved {
  from = oci_core_subnet.k3s_subnet
  to   = module.oci.oci_core_subnet.k3s_subnet
}

moved {
  from = oci_core_instance.k3s_nodes
  to   = module.oci.oci_core_instance.k3s_nodes
}

moved {
  from = oci_load_balancer_load_balancer.k3s_lb
  to   = module.oci.oci_load_balancer_load_balancer.k3s_lb
}

moved {
  from = oci_load_balancer_backend_set.http_backend_set
  to   = module.oci.oci_load_balancer_backend_set.http_backend_set
}

moved {
  from = oci_load_balancer_backend.http_backends
  to   = module.oci.oci_load_balancer_backend.http_backends
}

moved {
  from = oci_load_balancer_listener.http_listener
  to   = module.oci.oci_load_balancer_listener.http_listener
}

moved {
  from = oci_load_balancer_backend_set.https_backend_set
  to   = module.oci.oci_load_balancer_backend_set.https_backend_set
}

moved {
  from = oci_load_balancer_listener.https_listener
  to   = module.oci.oci_load_balancer_listener.https_listener
}

moved {
  from = oci_load_balancer_backend.https_backends
  to   = module.oci.oci_load_balancer_backend.https_backends
}

moved {
  from = tls_private_key.pipeline_key
  to   = module.oci.tls_private_key.pipeline_key
}

moved {
  from = oci_identity_group.pipeline_group
  to   = module.oci.oci_identity_group.pipeline_group
}

moved {
  from = oci_identity_user.pipeline_user
  to   = module.oci.oci_identity_user.pipeline_user
}

moved {
  from = oci_identity_user_group_membership.pipeline_membership
  to   = module.oci.oci_identity_user_group_membership.pipeline_membership
}

moved {
  from = oci_identity_policy.pipeline_policy
  to   = module.oci.oci_identity_policy.pipeline_policy
}

moved {
  from = oci_identity_api_key.pipeline_api_key
  to   = module.oci.oci_identity_api_key.pipeline_api_key
}
