# Backups do Postgres (CNPG barman via S3-compatível). Tudo free (20GB OS).
# Credenciais S3 saem em outputs sensitive -> GH Secrets -> role Ansible.
# NUNCA commitar valores: só nomes passam pelo Git.
data "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "pg_backups" {
  compartment_id = var.compartment_id
  name           = var.pg_backup_bucket
  namespace      = data.oci_objectstorage_namespace.this.namespace
  versioning     = "Enabled"
}

resource "oci_identity_user" "backup_svc" {
  compartment_id = var.compartment_id
  description    = "Usuario de servico para backups do Postgres no Object Storage"
  name           = "pg-backup-svc-user"
  email          = "pg-backup-svc@dev.com"
}

resource "oci_identity_group" "backup_svc" {
  compartment_id = var.compartment_id
  description    = "Grupo de servico para backups do Postgres"
  name           = "pg-backup-svc-group"
}

resource "oci_identity_user_group_membership" "backup_svc" {
  group_id = oci_identity_group.backup_svc.id
  user_id  = oci_identity_user.backup_svc.id
}

resource "oci_identity_policy" "backup_svc" {
  compartment_id = var.compartment_id
  description    = "Permite ao backup gerenciar buckets e objetos do compartment"
  name           = "pg-backup-svc-policy"
  statements = [
    "Allow group ${oci_identity_group.backup_svc.name} to manage buckets in tenancy",
    "Allow group ${oci_identity_group.backup_svc.name} to manage objects in tenancy",
  ]
}

resource "oci_identity_customer_secret_key" "backup_svc" {
  display_name = "pg-backup-s3"
  user_id      = oci_identity_user.backup_svc.id
}
