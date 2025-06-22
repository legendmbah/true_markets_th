variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "server_count" {
  description = "Number of Proxmox Rocky Linux VMs to deploy"
  type        = number
}