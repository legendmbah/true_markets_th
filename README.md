# Proxmox VM Provisioning Automation

## Requirements

- Proxmox VE server with a Rocky 9.6 cloud-init template
- API Token with rights to clone and create VMs
- Terraform v1.5+
- Ansible
- SSH key pair

## Setup

1. Create `terraform.tfvars` and add your VM list and token secret.
2. Make sure your Proxmox host has the cloud-init template named `rocky9-cloudinit-template`.
3. Make sure your public SSH key is in `~/.ssh/id_rsa.pub`.

## Usage

```bash
./promox_vm_deploy.sh

