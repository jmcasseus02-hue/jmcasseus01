# Labo automatisation Proxmox — 2 VM + 2 conteneurs

## Prérequis sur la machine de contrôle

```bash
python3 -m pip install proxmoxer requests
ansible-galaxy collection install -r requirements.yml
```

`community.proxmox` a récupéré les modules Proxmox de `community.general`
(dépréciés depuis la 13.x, suppression prévue en 15.0). Les modules
utilisés ici sont `community.proxmox.proxmox_kvm` pour les VM QEMU et
`community.proxmox.proxmox` pour les conteneurs LXC — deux modules
distincts, car Proxmox gère ces deux types d'instances avec des API et
des mécanismes de provisioning différents.

## Prérequis côté Proxmox

1. Un jeton API dédié (`ansible@pve!ansible-token`), avec un rôle limité
   aux permissions nécessaires (VM.Allocate, VM.Config.*, Datastore.AllocateSpace…),
   plutôt que `root@pam`.
2. Un modèle cloud-init pour les VM (vmid 9000 par défaut), déjà présent
   sur le nœud. Cette étape reste manuelle car l'import de disque
   (`qm importdisk`) n'a pas d'équivalent API direct : elle passe par SSH.
3. Le template Alpine des conteneurs (`ostemplate`) déjà téléchargé sur le
   stockage `local` (`pveam download local alpine-3.20-default_...`).

## Secret du token API

Ne jamais mettre `api_token_secret` en clair. Créer le fichier chiffré :

```bash
ansible-vault create group_vars/all/vault.yml
```

et y placer :

```yaml
vault_pve_api_token_secret: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## Structure

```
labo-proxmox-auto/
├── playbook.yml
├── requirements.yml
├── group_vars/all/main.yml   # catalogue unique des VM et conteneurs
└── roles/
    ├── proxmox_vms/tasks/main.yml   # clonage + config des VM
    └── proxmox_cts/tasks/main.yml   # création des conteneurs
```

## Pourquoi un catalogue unique (`group_vars/all/main.yml`)

Toutes les VM et tous les conteneurs sont décrits comme des entrées de
liste (`proxmox_vms`, `proxmox_cts`). Les rôles bouclent dessus avec
`loop`. Ajouter une troisième VM revient à ajouter cinq lignes dans le
catalogue, sans toucher aux tâches — c'est ce qui rend l'exercice
réellement extensible plutôt qu'une suite de tâches copiées-collées.

## VM vs conteneurs : deux logiques de provisioning

- **VM** : on **clone** un modèle cloud-init existant (`clone:` +
  `newid:`), puis on ajuste CPU/mémoire/réseau/IP dans une deuxième passe
  (`update: true`). Cloud-init s'occupe d'injecter la config réseau au
  premier démarrage.
- **Conteneurs** : on **crée directement** depuis une archive de template
  (`ostemplate:`) en une seule tâche, réseau et ressources inclus dès la
  création — pas de notion de clonage ici.

## Piège réseau déjà rencontré sur ce labo

La chaîne `net0` attendue par Proxmox est **positionnelle** :
`virtio,bridge=vmbr0` (le type d'interface doit précéder les options).
Un filtre Jinja comme `union()` traite les éléments comme un ensemble et
peut les réordonner, produisant `bridge=vmbr0,virtio`, que Proxmox
rejette. La solution retenue ici est une simple concaténation de chaîne
(`set_fact` dans `proxmox_vms/tasks/main.yml`), qui garantit l'ordre.

## Bascule VLAN

Une seule variable, `network_vlan`, vide par défaut (réseau à plat).
La renseigner (ex: `"10"`) ajoute automatiquement `tag=10` à toutes les
interfaces, VM comme conteneurs, sans autre modification.

## Exécution

```bash
ansible-playbook playbook.yml --ask-vault-pass
```

Le playbook est idempotent : le rejouer sans rien changer au catalogue
ne recrée ni ne redémarre les instances déjà à l'état voulu.
