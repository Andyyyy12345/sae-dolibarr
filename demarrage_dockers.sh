#!/bin/bash

echo "[1/1] Démarrage des conteneurs..."

# Le "if" exécute la commande et bascule sur le "then" si elle renvoie un code 0 (0 signifie succès)
if docker compose up -d; then
    echo "Conteneurs démarrés"
else
    echo "Erreur lors du démarrage des conteneurs."
    exit 1 # Le 1 renvoie un code 1 (et 1 signifie qu'il y'a eu une erreur)
fi