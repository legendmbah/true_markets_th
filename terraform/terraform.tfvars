pm_api_token_secret = "api-token-secret"

vm_configs = [
  {
    hostname = "rocky-vm1"
    ip       = "192.168.1.101"
    mac      = "AA:BB:CC:DD:EE:01"
    cpu      = 2
    ram      = 2048
    disk     = 20
  },

  # ... add more up to rocky-vm#

  {
    hostname = "rocky-vm10"
    ip       = "192.168.1.110"
    mac      = "AA:BB:CC:DD:EE:0A"
    cpu      = 2
    ram      = 2048
    disk     = 20
  }
]
