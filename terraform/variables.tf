variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "vm_configs" {
  type = list(object({
    hostname = string
    ip       = string
    mac      = string
    cpu      = number
    ram      = number
    disk     = number
  }))
}
