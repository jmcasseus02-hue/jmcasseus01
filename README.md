# jmcasseus01

Dépôt de travaux pratiques réalisés dans le cadre de la formation **AIS** (Administrateur d'Infrastructures Sécurisées).

## Contenu

| Dossier | Description |
|---|---|
| [`labs-ais/infra-ais/`](labs-ais/infra-ais/) | Provisionnement de VM Proxmox avec OpenTofu, puis configuration Ansible : DNS/DHCP (BIND + Kea), domaine Active Directory Samba, serveur de fichiers, proxy Zabbix |
| [`labs-ais/labo-proxmox-auto/`](labs-ais/labo-proxmox-auto/) | Playbook Ansible de création automatisée de VM Debian et de conteneurs Alpine sur Proxmox via l'API |
| [`tp-n8n/`](tp-n8n/) | n8n et PostgreSQL avec Docker Compose sur Debian 12, publiés en HTTPS derrière Nginx, premier workflow webhook |
| [`tp-glpi-niveau2/`](tp-glpi-niveau2/) | Infrastructure complète sous Proxmox autour de GLPI : Active Directory, PKI interne, LDAPS, notifications SMTP, GLPI Agent déployé par GPO |
| [`tp-intune/`](tp-intune/) | Gestion d'un poste Windows 11 depuis le cloud avec Microsoft Intune : inscription automatique, conformité, chiffrement BitLocker silencieux |

Chaque labo possède son propre README avec les étapes d'utilisation.

## Sécurité

Aucun secret n'est versionné : les jetons API et mots de passe sont à placer dans des fichiers chiffrés `ansible-vault` (`vault.yml`, `secrets.yml`), exclus par le `.gitignore`.
