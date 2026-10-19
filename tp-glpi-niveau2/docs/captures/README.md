# Captures de preuve

Nommer les fichiers avec le numéro d'étape pour garder l'ordre, par exemple `07-ldap-test-ok.png`.

| Fichier attendu | Ce que la capture doit montrer |
| --- | --- |
| 01-proxmox-machines.png | Les cinq machines dans l'arborescence Proxmox |
| 02-dcdiag.png | `dcdiag /q` sans erreur |
| 02-dns-resolution.png | Résolution directe et inverse de glpi.labo-ais.lan |
| 03-dhcp-cli01.png | `ipconfig /all` sur CLI01 (adresse, DNS, suffixe) |
| 04-ldaps-636.png | Connexion LDAPS sur le port 636 |
| 06-https-cadenas.png | GLPI en HTTPS sans avertissement |
| 07-ldap-test-ok.png | Test de l'annuaire réussi dans GLPI |
| 07-profils-ad.png | j.dupont en Technicien, m.martin en Self-Service |
| 08-mailpit-notifications.png | Mails de création, suivi et résolution dans Mailpit |
| 09-gpresult.png | La GPO de déploiement appliquée sur CLI01 |
| 09-parc-cli01.png | CLI01 dans Parc > Ordinateurs avec ses logiciels |
| 10-backup-ok.png | Sauvegarde datée et `sha256sum -c` OK |
| 10-restauration.png | Machine restaurée et comptage de tickets identique |
| 11-durcissement.png | Ports ouverts sur GLPI01, TOTP actif |

Avant de publier une capture, masquer les mots de passe, jetons et adresses IP publiques.
