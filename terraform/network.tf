resource "oci_core_vcn" "k3s_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "k3s-vcn"
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  enabled        = true
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "k3s_sec_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k3s_vcn.id

  # Regra de saída (Egress) - Libera tudo
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Regra de entrada (Ingress) - SSH exclusivo do seu IP
  ingress_security_rules {
    source   = var.meu_ip
    protocol = "6" # TCP
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Regra de entrada (Ingress) - HTTP/HTTPS abertos para o Load Balancer/Web
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_subnet" "k3s_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.k3s_vcn.id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = oci_core_route_table.public_rt.id
  security_list_ids = [oci_core_security_list.k3s_sec_list.id]
}