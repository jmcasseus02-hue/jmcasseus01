# main.tf — provisionne les VM par clonage du modele cloud-init

locals {
  gateway = "10.19.21.1"   # passerelle du VLAN 21 (pfSense)
  dns     = "10.19.21.1"   # resolveur pour l'amorçage (pfSense) ; bascule vers 10.19.21.10 apres
}

resource "proxmox_virtual_environment_vm" "riquet" {
  for_each  = var.vms
  name      = each.key
  node_name = var.node_name
  vm_id     = each.value.vmid
  tags      = ["riquet", "ansible"]

  clone {
    vm_id = var.template_id
    full  = true
  }

  agent  { enabled = true }
  cpu    { cores = each.value.cores, type = "host" }
  memory { dedicated = each.value.memory }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = each.value.disk
  }

  network_device {
    bridge  = var.bridge
    vlan_id = each.value.vlan
  }

  initialization {
    datastore_id = var.storage
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = local.gateway
      }
    }
    dns { servers = [local.dns] }
    user_account {
      username = var.ci_user
      keys     = [trimspace(file(var.ssh_pubkey))]
    }
  }

  lifecycle {
    ignore_changes = [ initialization[0].user_account[0].keys ]
  }
}

# Genere l'inventaire Ansible automatiquement a partir des VM creees
resource "local_file" "inventaire_ansible" {
  filename = "${path.module}/../ansible/inventory.generated.ini"
  content  = <<-EOT
    [dns]
    E19-RIQ-DNS01 ansible_host=10.19.21.10
    [domaine]
    E19-RIQ-DOM01 ansible_host=10.19.21.11
    [fichiers]
    E19-RIQ-FIC01 ansible_host=10.19.21.12
    [zabbix_proxy]
    E19-RIQ-ZPX01 ansible_host=10.19.21.14
    [riquet:children]
    dns
    domaine
    fichiers
    zabbix_proxy
    [riquet:vars]
    ansible_user=${var.ci_user}
    ansible_python_interpreter=/usr/bin/python3
  EOT
}
