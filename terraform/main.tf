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
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = "00:11:22:33:44:${format("%02x", count.index + 1)}"
  }

  disk {
    slot     = "scsi0"
    size     = "20G"
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
  }

  os_type    = "cloud-init"
  ipconfig0  = "ip=192.168.1.${100 + count.index}/24,gw=192.168.1.1"
  sshkeys    = file("/mnt/d/tm_takehome/true_markets_th/tmadmin_pubkey.pub")
  ciuser     = var.ssh_user
  cipassword = var.ssh_password
}

resource "null_resource" "generate_inventory" {
  depends_on = [proxmox_vm_qemu.rocky_vm]

  provisioner "local-exec" {
    command = <<-EOT
      echo "[true_markets_thvm]" > ../ansible/inventory.yml
%{ for vm in proxmox_vm_qemu.rocky_vm ~}
      echo "${split(",", split("=", vm.ipconfig0)[1])[0]} ansible_user=${var.ssh_user}" >> ../ansible/inventory.yml
%{ endfor ~}
      echo "" >> ../ansible/inventory.yml
      echo "[true_markets_thvm:vars]" >> ../ansible/inventory.yml
      echo "ansible_user=${var.ssh_user}" >> ../ansible/inventory.yml
      echo "ansible_python_interpreter=/usr/bin/python3" >> ../ansible/inventory.yml
      echo "ansible_ssh_private_key_file='${var.private_key_path}'" >> ../ansible/inventory.yml
      echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../ansible/inventory.yml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "ansible_post_provision" {
  depends_on = [
    proxmox_vm_qemu.rocky_vm,
    null_resource.generate_inventory
  ]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting 5 minutes for Rocky instance(s) to stabilize..."
      sleep 300
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory.yml ../ansible/proxmox_post_provision.yml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}