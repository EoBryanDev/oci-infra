locals {
  nodes = ["k3s-master", "k3s-worker"]
}

resource "oci_core_instance" "k3s_nodes" {
  for_each            = toset(local.nodes)
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = each.key
  shape               = var.instance_shape

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.k3s_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}