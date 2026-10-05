# versions.tf — fournisseur et versions requises
terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"   # fournisseur Proxmox moderne, compatible OpenTofu
      version = ">= 0.60"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint      # ex : https://10.19.20.11:8006/
  api_token = var.pve_api_token     # ex : tofu@pve!provision=xxxxxxxx-....
  insecure  = true                  # certificat auto-signé du labo

  # bpg a besoin d'un accès SSH au noeud pour certaines opérations (import cloud-init)
  ssh {
    agent    = false
    username = "root"
  }
}
