# 1. Cria a chave privada/pública RSA (Substitui a geração manual)
resource "tls_private_key" "pipeline_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# 2. Cria o Grupo
resource "oci_identity_group" "pipeline_group" {
  compartment_id = var.compartment_id # Deve ser o Root Compartment (Tenancy OCID)
  description    = "Grupo de servico para automacao do GitHub Actions"
  name           = "github-cicd-eobryandev-group"
}

# 3. Cria o Usuário de Serviço
resource "oci_identity_user" "pipeline_user" {
  compartment_id = var.compartment_id # Deve ser o Root Compartment
  description    = "Usuario de servico para executar o Terraform na pipeline"
  name           = "github-cicd-eobryandev-user"
  email          = "github-cicd-eobryandev@dev.com"
}

# 4. Associa o Usuário ao Grupo
resource "oci_identity_user_group_membership" "pipeline_membership" {
  group_id = oci_identity_group.pipeline_group.id
  user_id  = oci_identity_user.pipeline_user.id
}

# 5. Cria a Política de Permissão (Auditável)
resource "oci_identity_policy" "pipeline_policy" {
  compartment_id = var.compartment_id
  description    = "Permite que a pipeline gerencie os recursos da conta"
  name           = "github-cicd-eobryandev-policy"
  statements = [
    "Allow group ${oci_identity_group.pipeline_group.name} to manage all-resources in tenancy"
  ]
}

# 6. Anexa a Chave Pública ao Usuário da OCI (Cria a API Key)
resource "oci_identity_api_key" "pipeline_api_key" {
  user_id   = oci_identity_user.pipeline_user.id
  key_value = tls_private_key.pipeline_key.public_key_pem
}