# Journal de bord

* SAE 52 - Installation d’un ERP/CRM
* Evan NODARI, Tom PAQUET, Andy XIONG
* 22/09/2026


## Séance n° 1

* 22/09/2026 - 13h-16h
* Travail effectué : Prise de connaissance du sujet + installation des VMs + docker + importation des CSV
* A faire à la prochaine séance : continuer la SAE
* Difficultés rencontrées : Problème surtout concernant Andy avec l'installation de Docker
* Remarques sur la séances (membre absent, pbe technique, ...) : aucune


## Séance n° 2

* 30/09/2026 - 13h-16h
* Travail effectué : 
  - Développement du script `import.csv.sh` pour l'injection directe des données CSV dans MariaDB (via `LOAD DATA INFILE`).
  - Création du script `install.sh` pour orchestrer le déploiement (démarrage de l'infrastructure Docker, attente de la disponibilité d'Apache, lancement de l'import).
  - Configuration finale du `docker-compose.yml` avec l'intégration de la variable `DOLI_COMPANY_NAME`.
* A faire à la prochaine séance : Rédiger le rapport de projet final, mettre au propre le README et faire le push final sur le dépôt Git.
* Difficultés rencontrées : 
  - Le script d'import se lançait avant que la base de données ne soit totalement initialisée (résolu par l'ajout d'une boucle d'attente `curl` dans `install.sh`).
  - L'activation forcée du module "Tiers" en SQL bloquait l'interface (curseur interdit) car elle court-circuitait la génération des permissions PHP de Dolibarr.
* Remarques sur la séances (membre absent, pbe technique, ...) : Suite au problème de droits, nous avons pris la décision technique de garder l'activation du module métier manuelle. L'automatisation se concentre sur l'infrastructure et l'injection des données. Ce choix sera justifié dans le rapport.


## Séance n° 3

* À définir
* Travail effectué : Rédaction du rapport, finalisation du README avec les justifications techniques (choix de l'architecture dissociée et gestion des modules), nettoyage des fichiers et rendu final.
* A faire à la prochaine séance : N/A (Fin du projet)
* Difficultés rencontrées : À compléter si besoin.
* Remarques sur la séances (membre absent, pbe technique, ...) : À compléter si besoin.


## Séance n° 4

* 06/10/2026 - 8h30/11h30 - 14h30/17h30
* Travail effectué : Modification des scripts restore.sh et backup.sh (ajout de commentaire et résolution de bugs)
* A faire à la prochaine séance : N/A (Fin du projet)
* Difficultés rencontrées : Problème avec la restauration (La restauration supprimait la table des users) c'était du à un problème avec le chemin de la backup
* Remarques sur la séances :








gantt
    title SAE 52 - Installation d'un ERP/CRM (Planning Réel)
    dateFormat  DD/MM/YYYY
    axisFormat %d/%m
    
    section Séance 1 (22/09)
    Prise de connaissance & Infrastructure VMs       :done, s1_1, 22/09/2026, 1d
    Installation Docker & Import CSV initial         :done, s1_2, 22/09/2026, 1d
    
    section Séance 2 (30/09)
    Développement scripts (import.csv.sh / install.sh) :done, s2_1, 30/09/2026, 1d
    Configuration docker-compose & Fix boucle d'attente :done, s2_2, 30/09/2026, 1d
    Arbitrage technique (activation manuelle Tiers)    :done, s2_3, 30/09/2026, 1d
    
    section Séance 3 (Intermédiaire)
    Rédaction du rapport & Structuration README         :done, s3_1, 01/10/2026, 05/10/2026
    
    section Séance 4 (06/10)
    Refactoring & Commentaires (backup.sh / restore.sh) :done, s4_1, 06/10/2026, 1d
    Fix bug critique (restauration table users)        :done, s4_2, 06/10/2026, 1d
    Rendu final du projet                             :milestone, active, 06/10/2026, 0d
