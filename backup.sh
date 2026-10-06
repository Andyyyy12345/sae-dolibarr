#!/bin/bash
# sauvegarde de dolibarr (la base + les documents)



# Création d'un dossier avec la date pour pas écraser les anciennes sauvegardes
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p backups/$DATE


# export de la base de données dans un fichier .sql
docker compose exec -T mariadb mariadb-dump -u root -proot dolibarr_db > backups/$DATE/dolibarr_db.sql

# Affiche le résultat pour vérifier que les fichiers existent
echo "Sauvegarde faite dans backups/$DATE"
ls -lh backups/$DATE
