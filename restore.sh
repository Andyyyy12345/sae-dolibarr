#!/bin/bash
# Restauration depuis une sauvegarde : ./restore.sh backups/<horodatage>


set -euo pipefail 
# -e arrête immédiatement le script si une commande échoue.
# -u provoque une erreur si le script tente d'utiliser une variable non définie. 
# -o pipefail fait que si une commande échoue au milieu de la pipeline, la pipeline est considéré comme échoué.


cd "$(dirname "$0")" #Déplace le terminal dans le dossier où se trouve le script.


SRC="backups/${1:-}" #SRC = le premier argument
if [ -z "$SRC" ] || [ ! -f "$SRC/dolibarr_db.sql" ]; then  # Si SRC est nul ou si il n'y a pas le fichier .sql dans le dossier passé en parametre
    echo "Erreur : Pas de fichier .sql dans le dossier donné"
    exit 1
fi


echo "Restauration de la base..."
echo "[1/3] Restauration des dossiers html et documents..."


#Extrait l'archive qui va remplacer les dossiers actuels
# -x (eXtract) : Indique à tar d'extraire les fichiers contenus dans l'archive. 
# -z (gzip) : Indique à tar que l'archive a été compressée avec gzip et qu'il doit d'abord la décompresser avant de pouvoir lire les fichiers.
# -f (File) : Indique que le mot qui suit immédiatement est le nom du fichier archive à ouvrir
tar -xzf "$SRC/dolibarr_files.tar.gz"


docker compose exec -T mariadb mariadb -u root -proot -e "DROP DATABASE IF EXISTS dolibarr_db; CREATE DATABASE dolibarr_db;" # DROP DATABASE IF EXISTS Efface la BDD
docker compose exec -T mariadb mariadb -u root -proot dolibarr_db < "$SRC/dolibarr_db.sql" # Cette ligne récupère le fichier .sql et l'injecte dans la BDD
# -e "..."  permet d'éxécuter directement les commandes SQL entre guillemets sans ouvrir de terminal interactif (Ca évite que l'utilisateur doive entrer quelquechose dans un terminal)
# -T permet de ne pas ouvrir un nouveau terminal (l'action se déroule quand-même mais sans ouvrir un terminal dédié)


docker compose restart dolibarr #Redémarre le docker
echo "Restauration terminée."
