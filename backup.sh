#!/bin/bash
# sauvegarde de dolibarr (la base)



# Création d'un dossier avec la date pour pas écraser les anciennes sauvegardes
DATE=$(date +%Y%m%d_%H%M%S) # Le nom du dossier est l'année/mois/jour_Heure/minutes/secondes
mkdir -p backups/$DATE


# export de la base de données dans un fichier .sql
docker compose exec -T mariadb mariadb-dump -u root -proot dolibarr_db > backups/$DATE/dolibarr_db.sql

# fichiers tar pour zipper les dossiers liés aux conteneurs
# -c (Create) : Indique à tar de créer une nouvelle archive.
# -z (gzip) : Indique de compresser l'archive. 
# -f (File) : Indique que vous allez lui donner le nom du fichier final
tar -czf "backups/$DATE/files_backup.tar.gz" ./html ./documents 2>/dev/null


# Affiche le résultat pour vérifier que les fichiers existent
echo "Sauvegarde faite dans backups/$DATE"
ls -lh backups/$DATE
