#!/bin/bash

echo "=========================================="
echo "  Lancement du déploiement de Dolibarr   "
echo "=========================================="

echo "[1/3] Démarrage des conteneurs..."
docker compose up -d

echo "[2/3] Initialisation automatique de Dolibarr..."
# Tant que la requête HTTP sur localhost ne renvoie pas un code 200, 301 ou 302, on boucle (s = silent, o = jette le contenu HTML de la page reçue, w = affiche uniquement le code HTTP, q = quiet, E = extended-regexp)
until curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -qE "200|301|302"; do
    # Pause de 3s entre chaque test pour ne pas surcharger le CPU
    sleep 3
    echo -n "."
done
echo ""
echo "Dolibarr est prêt !"

# Pause de 5s pour s'assurer que la base de données finalise son initialisation
sleep 5
echo "[3/3] Configuration du pays et importation des données CSV..."

# Définit la France (ID 1) comme pays de la société pour éviter la redirection obligatoire
docker exec sae-dolibarr-mariadb-1 mariadb -u root -proot dolibarr_db -e "
  INSERT INTO llx_const (name, value, type, visible, entity) 
  VALUES ('MAIN_INFO_SOCIETE_COUNTRY', '1', 'chaine', 0, 1) 
  ON DUPLICATE KEY UPDATE value='1';
"

if [ -f "./import.csv.sh" ]; then
    ./import.csv.sh
else
    echo "Erreur : import.csv.sh introuvable !"
    exit 1
fi

echo "====================================================="
echo " Installation terminée avec succès !                 "
echo " Accès web : http://localhost                        "
echo "                                                     "
echo " ACTION REQUISE :                                    "
echo " Connectez-vous (admin/admin) et activez le module   "
echo " 'Tiers' manuellement pour voir les données importées."
echo "====================================================="
