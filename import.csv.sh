#!/bin/bash

CONTAINER_DB="sae-dolibarr-mariadb-1"
DB_NAME="dolibarr_db"

# On pointe vers le fichier dans le dossier data
CSV_SOURCE="data/import_tiers.csv"
CSV_TARGET="/tmp/import_tiers.csv"

echo "=== Démarrage de l'importation ==="

# 1. Transfert du fichier CSV dans le conteneur
echo "[1/2] Transfert du fichier CSV vers le conteneur MariaDB..."
docker cp $CSV_SOURCE $CONTAINER_DB:$CSV_TARGET

# 2. Injection via le compte root de MariaDB dans le conteneur pour s'affranchir des restrictions de droits 
# -e indique à MariaDB d'exécuter la commande SQL qui suit, puis de se fermer immédiatement.
echo "[2/2] Injection des données dans la table llx_societe..."
docker exec -it $CONTAINER_DB mariadb -u root -proot $DB_NAME -e "
LOAD DATA INFILE '$CSV_TARGET'
INTO TABLE llx_societe
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nom, client, fournisseur, address, zip, town, status, phone, email);"

echo "=== Importation terminée avec succès ! ==="