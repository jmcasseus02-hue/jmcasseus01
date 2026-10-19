#!/bin/bash
# Sauvegarde applicative de GLPI : base, fichiers et configuration.
# Planifiee par /etc/cron.d/backup-glpi, conservation 14 jours.
set -euo pipefail
DEST=/srv/backup/glpi/$(date +%F_%H%M)
mkdir -p "$DEST" && chmod 700 /srv/backup/glpi

cd /var/www/glpi
sudo -u www-data php bin/console glpi:maintenance:enable >/dev/null
mariadb-dump --single-transaction --routines glpi | gzip > "$DEST/glpi.sql.gz"
sudo -u www-data php bin/console glpi:maintenance:disable >/dev/null

tar -czf "$DEST/glpi-files.tar.gz"  /var/lib/glpi
tar -czf "$DEST/glpi-config.tar.gz" /etc/glpi /var/www/glpi/inc/downstream.php \
  /etc/apache2/sites-available/glpi.conf /etc/ssl/certs/glpi.crt /etc/ssl/private/glpi.key

cd "$DEST" && sha256sum *.gz > SHA256SUMS
find /srv/backup/glpi -mindepth 1 -maxdepth 1 -type d -mtime +14 -exec rm -rf {} +
logger -t backup-glpi "Sauvegarde terminee : $DEST"
