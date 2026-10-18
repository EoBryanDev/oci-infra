# Identidade do monitor de Always Free.
#
# O exporter Prometheus que publica o consumo do free tier roda DENTRO do
# cluster e lê a Usage API com INSTANCE PRINCIPAL: a credencial é a identidade
# da própria VM, não um par de chaves. Consequências práticas:
#   * zero segredo no cluster (nada para vazar, nada para rotacionar);
#   * zero credencial no Git/state, ao contrário de uma chave de API;
#   * o export só pode o que esta policy permite (leitura de metadados).
#
# Aqui vive só a permissão. O workload está em
# k8s/apps/infra/observability/free-tier/exporter.yaml.
#
# Custo desta observabilidade: nenhum. Usage API e Monitoring são APIs de
# metadados (não faturadas) e o exporter NUNCA chama o Object Storage — a
# franquia de 50.000 requests/mês é exatamente o que ele mede, então um monitor
# que a consumisse envenenaria a própria medição.
#
# Escopo mínimo: `read usage-reports` é o resource-type que autoriza
# request-summarized-usages (USAGE) e o de custo (COST). Não há verbo de
# escrita envolvido — o monitor não pode mexer em nada.

resource "oci_identity_dynamic_group" "cluster_nodes" {
  compartment_id = var.tenancy_ocid
  name           = "k3s-nodes"
  description    = "Instancias do cluster k3s (leitura de consumo/custo do Always Free)"

  # As instâncias (k3s-master/k3s-worker) vivem no compartment raiz da tenancy.
  # Se um dia migrarem de compartment, este é o único ponto a ajustar.
  matching_rule = "All {instance.compartment.id = '${var.tenancy_ocid}'}"
}

resource "oci_identity_policy" "always_free_observer" {
  compartment_id = var.tenancy_ocid
  name           = "always-free-observer-policy"
  description    = "Leitura de metadados de billing para o exporter de Always Free"

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.cluster_nodes.name} to read usage-reports in tenancy",
    # Budgets entram na mesma leitura para o exporter expor o teto (R$1) como
    # métrica — assim o painel mostra consumo do free tier E gasto lado a lado.
    "Allow dynamic-group ${oci_identity_dynamic_group.cluster_nodes.name} to read usage-budgets in tenancy",
  ]
}
