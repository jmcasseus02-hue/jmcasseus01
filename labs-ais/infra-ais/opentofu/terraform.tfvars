# terraform.tfvars — LES VALEURS A ADAPTER

# --- Connexion a Proxmox (a remplir) ---
pve_endpoint  = "https://10.19.20.11:8006/"
pve_api_token = "tofu@pve!provision=REMPLACE-MOI-PAR-LE-JETON"

# --- Contexte du cluster ---
node_name   = "E19-RIQ-PVE01"
template_id = 9000
storage     = "zdata"
bridge      = "vmbr0"
ci_user     = "admin"
ssh_pubkey  = "~/.ssh/id_ed25519.pub"

# --- Les 4 VM Debian (PBS est traite a part) ---
vms = {
  "E19-RIQ-DNS01" = { vmid = 110, ip = "10.19.21.10", vlan = 21, cores = 1, memory = 1024, disk = 12 }
  "E19-RIQ-DOM01" = { vmid = 111, ip = "10.19.21.11", vlan = 21, cores = 2, memory = 2048, disk = 16 }
  "E19-RIQ-FIC01" = { vmid = 112, ip = "10.19.21.12", vlan = 21, cores = 2, memory = 2048, disk = 30 }
  "E19-RIQ-ZPX01" = { vmid = 114, ip = "10.19.21.14", vlan = 21, cores = 1, memory = 1024, disk = 12 }
}
