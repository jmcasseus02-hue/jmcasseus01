# infra-ais — Provisionnement et configuration du site de Riquet (Espace 19)

Dépôt d'infrastructure décrite dans le code (IaC) du projet AIS.
- **OpenTofu** provisionne les VM (clonage du modèle cloud-init).
- **Ansible** configure l'intérieur des VM (services, durcissement).

## Arborescence
```
opentofu/   → création des VM (les 4 VM Debian ; PBS s'installe par ISO)
ansible/    → configuration : rôles commun, dns, domaine, fichiers, zabbix-proxy
```

## Prérequis (une seule fois)
1. Poste de contrôle (EPN / WSL Debian) : `./installer-poste-controle.sh`
2. Un **modèle cloud-init** existe sur Proxmox (VMID 9000) sur le stockage `zdata`.
3. Une **clé SSH** : `~/.ssh/id_ed25519.pub`.
4. Un **jeton API Proxmox** (voir plus bas), reporté dans `opentofu/terraform.tfvars`.

## Jeton API Proxmox (sur un nœud)
```
pveum user add tofu@pve
pveum acl modify / -user tofu@pve -role Administrator
pveum user token add tofu@pve provision --privsep 0
```
Copier la valeur affichée dans `terraform.tfvars` → `pve_api_token`.

## Déploiement
```
cd opentofu
tofu init
tofu plan       # vérifier ce qui va être créé
tofu apply      # crée les 4 VM + génère ansible/inventory.generated.ini

cd ../ansible
ansible all -m ping                 # vérifier l'accès SSH
ansible-vault create group_vars/secrets.yml   # y mettre ad_admin_password
ansible-playbook site.yml --ask-vault-pass
```

## Ordre logique
DNS d'abord (rien ne résout sans lui), puis le domaine, puis les fichiers, puis la supervision.
PBS (sauvegarde) est installé séparément depuis son ISO.

## Sécurité
- Les secrets (mot de passe AD, etc.) vont dans `group_vars/secrets.yml` **chiffré par ansible-vault** — jamais en clair.
- Le jeton API et l'état OpenTofu (`*.tfstate`) sont exclus de Git (voir `.gitignore`).
