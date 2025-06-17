#!/bin/bash

set -e

echo "[*] Applying Terraform..."
cd terraform
terraform init
terraform apply -auto-approve

echo "[✓] Terraform complete."

echo "[*] Running Ansible post-provisioning..."
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml

