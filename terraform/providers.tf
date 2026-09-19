terraform {
  required_version = ">= 1.0.0"

  backend "http" {}

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
