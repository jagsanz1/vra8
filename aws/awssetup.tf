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

resource "vra_cloud_account_aws" "this" {
  name        = "tf-vra-cloud-account-aws"
  description = "terraform test cloud account aws"
  access_key  = var.access_key
  secret_key  = var.secret_key
  regions     = ["us-east-1", "us-east-2"]

  tags {
    key   = "cloud"
    value = "aws"
  }
}

data "vra_region" "region_east_1" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-east-1"
}

data "vra_region" "region_east_2" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-east-2"
}

# Configure a new Cloud Zone
resource "vra_zone" "this" {
  name        = "AWS US East Zone"
  description = "Cloud Zone configured by Terraform"
  region_id   = data.vra_region.region_east_1.id

  tags {
    key   = "cloud"
    value = "aws"
  }
}

# Create a new Project
resource "vra_project" "this" {
  name        = "Terraform Project"
  description = "Project configured by Terraform"

  zone_assignments {
    zone_id       = vra_zone.this.id
    priority      = 1
    max_instances = 0
  }

  shared_resources = false

  # Deprecated, please use administrator_roles instead.
  #administrators = ["jorgega@vmware.com"]

  administrator_roles {
    email = "jorgega@vmware.com"
    type = "user"
  }
  operation_timeout = 6000
  machine_naming_template = "$${resource.name}-$${####}"

}

data "vra_project" "this" {
  name = vra_project.this.name
  depends_on = [vra_project.this]
}