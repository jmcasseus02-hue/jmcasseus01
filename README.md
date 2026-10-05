# jmcasseus01

Dépôt de travaux pratiques réalisés dans le cadre de la formation **AIS** (Administrateur d'Infrastructures Sécurisées).

## Contenu

| Dossier | Description |
|---|---|
| [`labs-ais/infra-ais/`](labs-ais/infra-ais/) | Provisionnement de VM Proxmox avec OpenTofu, puis configuration Ansible : DNS/DHCP (BIND + Kea), domaine Active Directory Samba, serveur de fichiers, proxy Zabbix |
| [`labs-ais/labo-proxmox-auto/`](labs-ais/labo-proxmox-auto/) | Playbook Ansible de création automatisée de VM Debian et de conteneurs Alpine sur Proxmox via l'API |

Chaque labo possède son propre README avec les étapes d'utilisation.

## Sécurité

Aucun secret n'est versionné : les jetons API et mots de passe sont à placer dans des fichiers chiffrés `ansible-vault` (`vault.yml`, `secrets.yml`), exclus par le `.gitignore`.
