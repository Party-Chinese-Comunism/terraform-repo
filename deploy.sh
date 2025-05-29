#!/bin/bash
set -e

echo "===> Iniciando Terraform"
cd terraform
terraform init
terraform apply -auto-approve

VM_IP=$(terraform output -raw vm_ip)
cd ../ansible

echo "===> Criando inventory.ini"
echo "[web]" > inventory.ini
echo "$VM_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini

echo "===> Executando Ansible Playbook"
ansible-playbook -i inventory.ini playbook.yml
