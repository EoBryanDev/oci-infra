terraform {
  required_version = ">= 1.0.0"
  
  backend "http" {} 
  
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  config_file_profile = "DEFAULT"
}