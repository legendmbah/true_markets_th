variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID (format: user@pam!token-name)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "server_count" {
  description = "Number of Proxmox Rocky Linux VMs to deploy"
  type        = number
}

variable "ssh_user" {
  type        = string
  description = "Username for SSH access"
  default     = "tmadmin"
}

variable "ssh_password" {
  type        = string
  description = "Password for the SSH user"
  sensitive   = true
}

variable "private_key_path" {
  description = "Path to the private SSH key used by Ansible to connect to the VMs"
  type        = string
}