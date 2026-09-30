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

echo "[1/2] Restauration de la base..."
docker compose exec -T mariadb mariadb -u root -proot -e "DROP DATABASE IF EXISTS dolibarr_db; CREATE DATABASE dolibarr_db;"
docker compose exec -T mariadb mariadb -u root -proot dolibarr_db < "$SRC/dolibarr_db.sql"

if [ -f "$SRC/documents.tar.gz" ]; then
    echo "[2/2] Restauration des documents..."
    docker compose exec -T dolibarr tar xzf - -C /var/www < "$SRC/documents.tar.gz"
fi

docker compose restart dolibarr
echo "Restauration terminée."
