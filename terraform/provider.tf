terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

# AWS provider config
provider "aws" {
  region = "us-east-1"
}

# Proxmox provider config
provider "proxmox" {
  pm_api_url          = "https://your-proxmox-host:8006/api2/json"
  pm_api_token_id     = "terraform@pve!mytoken"
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}