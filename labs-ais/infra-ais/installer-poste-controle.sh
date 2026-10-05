#!/usr/bin/env bash
# Installe OpenTofu + Ansible sur le poste de controle (Debian/Ubuntu ou WSL Debian).
set -e
sudo apt update
sudo apt install -y gnupg curl python3 python3-pip git

# --- OpenTofu ---
curl -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/it.sh
sudo bash /tmp/it.sh --install-method deb

# --- Ansible ---
sudo apt install -y ansible
ansible-galaxy collection install community.general

echo "OK : $(tofu version | head -1) / $(ansible --version | head -1)"
