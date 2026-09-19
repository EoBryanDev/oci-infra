# Trava dura: provisionar além do shape atual FALHA em vez de cobrar.
# Nomes oficiais: docs.oracle.com "Compute Quotas"
# (compute-core/standard-a1-core-count, compute-memory/standard-a1-memory-count).
# Escopo AD (doc Oracle: valor vale por AD); single-AD/single-region = teto efetivo.
resource "oci_limits_quota" "free_tier_guardrails" {
  compartment_id = var.tenancy_ocid
  name           = "free-tier-guardrails"
  description    = "Congela o shape do portfolio: 4 OCPU / 24GB A1 na tenancy"

  statements = [
    "set compute-core quota standard-a1-core-count to ${var.max_a1_ocpus} in tenancy",
    "set compute-memory quota standard-a1-memory-count to ${var.max_a1_memory_gb} in tenancy",
  ]
}
