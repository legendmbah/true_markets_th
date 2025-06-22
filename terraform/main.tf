resource "proxmox_vm_qemu" "rocky_vm" {
  count       = var.server_count
  name        = "rocky-vm-${format("%02d", count.index + 1)}"
  target_node = "proxmox"
  clone       = "rocky9-cloudinit-template"
  full_clone  = true

  cores  = 2
  memory = 2048
  scsihw = "virtio-scsi-pci"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = "00:11:22:33:44:${format("%02x", count.index + 1)}"
  }

  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  os_type    = "cloud-init"
  ipconfig0  = "ip=192.168.1.${100 + count.index}/24,gw=192.168.1.1"
  sshkeys    = file("/mnt/d/tm_takehome/true_markets_th/tmadmin_pubkey.pub")
  ciuser     = "tmadmin"
  cipassword = "Default_Super"
}
