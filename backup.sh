#!/bin/bash
# sauvegarde de dolibarr (la base + les documents)



# on crée un dossier avec la date pour pas écraser les anciennes sauvegardes
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p backups/$DATE


# export de la base de données dans un fichier .sql
docker compose exec -T mariadb mariadb-dump -u root -proot dolibarr_db > backups/$DATE/dolibarr_db.sql


# archive du dossier documents de dolibarr
docker compose exec -T dolibarr tar czf - -C /var/www documents > backups/$DATE/documents.tar.gz


# on affiche le résultat pour vérifier que les fichiers ne sont pas vides
echo "Sauvegarde faite dans backups/$DATE"
ls -lh backups/$DATE