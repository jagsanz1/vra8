provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  required_providers {
    vra = {
      source  = "local/vmware/vra"
      version = ">= 0.3.9"
    }
  }
  required_version = ">= 0.13"
}

provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure = true
}
