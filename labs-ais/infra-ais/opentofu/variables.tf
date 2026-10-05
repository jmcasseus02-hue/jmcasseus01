# variables.tf — tout ce qui peut changer d'un environnement a l'autre

variable "pve_endpoint"  { type = string }
variable "pve_api_token" { type = string, sensitive = true }

variable "node_name"   { type = string, default = "E19-RIQ-PVE01" } # noeud qui heberge le modele
variable "template_id" { type = number, default = 9000 }            # ID du modele cloud-init
variable "storage"     { type = string, default = "zdata" }         # stockage ZFS (replication)
variable "bridge"      { type = string, default = "vmbr0" }
variable "ci_user"     { type = string, default = "admin" }
variable "ssh_pubkey"  { type = string, default = "~/.ssh/id_ed25519.pub" }

# Description des VM a provisionner (PBS est installe a part, par ISO)
variable "vms" {
  type = map(object({
    vmid   = number
    ip     = string
    vlan   = number
    cores  = number
    memory = number
    disk   = number
  }))
}
