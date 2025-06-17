terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://your-proxmox-host:8006/api2/json"
  pm_api_token_id     = "terraform@pve!mytoken"
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "rocky_vm" {
  count       = length(var.vm_configs)
  name        = var.vm_configs[count.index].hostname
  target_node = "proxmox" # change to your node name
  clone       = "rocky9-cloudinit-template"
  full_clone  = true

  cores  = var.vm_configs[count.index].cpu
  memory = var.vm_configs[count.index].ram
  scsihw = "virtio-scsi-pci"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = var.vm_configs[count.index].mac
  }

  disk {
    slot     = 0
    size     = "${var.vm_configs[count.index].disk}G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  os_type    = "cloud-init"
  ipconfig0  = "ip=${var.vm_configs[count.index].ip}/24,gw=192.168.1.1"
  sshkeys    = file("home/tmadmin/.ssh/id_rsa.pub")
  ciuser     = "tmadmin"
  cipassword = "changeme"
}

resource "null_resource" "ansible_post_config" {
  depends_on = [proxmox_vm_qemu.rocky_vm]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml"
  }
}
