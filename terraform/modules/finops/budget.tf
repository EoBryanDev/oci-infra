# Alarme de gasto: dispara e-mail em qualquer gasto real ou previsto >= R$1.
# Serviço de Budgets é gratuito; o e-mail vai direto (sem tópico/CAT).
resource "oci_budget_budget" "free_tier" {
  compartment_id = var.tenancy_ocid
  amount         = var.budget_amount_brl
  reset_period   = "MONTHLY"
  description    = "Guarda-corpo Always Free: qualquer gasto fora do free dispara alerta"
  # Alvo obrigatório (API exige): tenancy inteira via compartment root.
  target_type = "COMPARTMENT"
  targets     = [var.tenancy_ocid]
}

resource "oci_budget_alert_rule" "actual_spend" {
  budget_id      = oci_budget_budget.free_tier.id
  type           = "ACTUAL"
  threshold      = var.budget_amount_brl
  threshold_type = "ABSOLUTE"
  recipients     = var.budget_alert_email
  message        = "Gasto real >= R$1 detectado na tenancy (fora do Always Free?)"
}

resource "oci_budget_alert_rule" "forecast_spend" {
  budget_id      = oci_budget_budget.free_tier.id
  type           = "FORECAST"
  threshold      = var.budget_amount_brl
  threshold_type = "ABSOLUTE"
  recipients     = var.budget_alert_email
  message        = "Previsao de gasto >= R$1 na tenancy (fora do Always Free?)"
}
