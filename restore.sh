#!/bin/bash
# Restauration depuis une sauvegarde : ./restore.sh backups/<horodatage>
# Scénario PRA : docker compose down -v  ->  ./install.sh  ->  ./restore.sh <dossier>
set -euo pipefail
cd "$(dirname "$0")"

SRC="${1:-}"
if [ -z "$SRC" ] || [ ! -f "$SRC/dolibarr_db.sql" ]; then
    echo "Usage : $0 backups/<horodatage>"
    exit 1
fi

echo "Restauration de la base..."
docker compose exec -T mariadb mariadb -u root -proot -e "DROP DATABASE IF EXISTS dolibarr_db; CREATE DATABASE dolibarr_db;"
docker compose exec -T mariadb mariadb -u root -proot dolibarr_db < "$SRC/dolibarr_db.sql"

docker compose restart dolibarr
echo "Restauration terminée."
