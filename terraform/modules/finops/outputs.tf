output "budget_id" {
  description = "OCID do budget Always Free"
  value       = oci_budget_budget.free_tier.id
}

output "quota_id" {
  description = "OCID da quota de guardrails"
  value       = oci_limits_quota.free_tier_guardrails.id
}
