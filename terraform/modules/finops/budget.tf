# Alarme de gasto: dispara e-mail em qualquer gasto real ou previsto >= R$1.
# Serviço de Budgets é gratuito; o e-mail vai direto (sem tópico/CAT).
resource "oci_budget_budget" "free_tier" {
  compartment_id = var.tenancy_ocid
  amount         = var.budget_amount_brl
  reset_period   = "MONTHLY"
  description    = "Guarda-corpo Always Free: qualquer gasto fora do free dispara alerta"
  # Alvo obrigatório (API exige): o compartment de workload. A API rejeita
  # a tenancy root como target (exemplo oficial usa compartment filho).
  # Como 100% dos recursos do portfólio vivem nele, a cobertura é total.
  target_type = "COMPARTMENT"
  targets     = [var.compartment_id]
}

# Regra ACTUAL.
#
# HISTÓRICO (drift corrigido em 18/10/2026): existiam DUAS regras com o MESMO
# gatilho (R$1): esta, criada pelo módulo, e `synit-budget-alert`, criada à mão
# no console em 21/02/2026 e invisível ao Terraform. Resultado: e-mail dobrado
# no mesmo limiar, e uma regra que nenhum `apply` conseguia explicar.
#
# A reconciliação foi feita ADOTANDO a regra órfã (`import` abaixo) e removendo
# a duplicata gerenciada no mesmo apply — em vez de apagar a órfã por CLI
# (comando ad hoc) ou importá-la só para destruí-la depois (dois applies).
# Saldo final: 1 ACTUAL + 1 FORECAST, ambas sob IaC, zero drift.
#
# Por que a sobrevivente é a do console e não a do módulo: ela usa
# `PERCENTAGE`/100, que acompanha sozinha o `amount` do budget se o teto mudar
# (com `ABSOLUTE` o alerta continuaria apontando para R$1 depois de um reajuste).
import {
  to = oci_budget_alert_rule.actual_spend_console
  id = "budgets/${oci_budget_budget.free_tier.id}/alertRules/ocid1.alertrule.oc1.phx.amaaaaaaoo74z3aa2ih52ea4yocdh5spuhcgiejyoyx4tza6plwovr4lbuea"
}

resource "oci_budget_alert_rule" "actual_spend_console" {
  budget_id      = oci_budget_budget.free_tier.id
  type           = "ACTUAL"
  threshold      = 100
  threshold_type = "PERCENTAGE"
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
