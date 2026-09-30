# SAE 52 - Déploiement Automatisé d'un ERP/CRM (Dolibarr)

**Équipe :** Evan NODARI, Tom PAQUET, Andy XIONG  
**Date :** Septembre 2026  
**Module :** SAE 52 - Installation d'un ERP/CRM  

## 📌 Présentation du projet

Ce projet a pour objectif d'automatiser le déploiement d'un environnement Dolibarr ERP/CRM à l'aide de conteneurs Docker, et d'y injecter un jeu de données initial (Tiers/Sociétés) via des scripts Bash et SQL. 

L'architecture repose sur deux conteneurs :
- **MariaDB** (Base de données)
- **Dolibarr** (Serveur Web Apache + PHP + Application)

## 🏗️ Architecture des fichiers

- `docker-compose.yml` : Définit l'infrastructure, les volumes, les réseaux et les variables d'environnement natives (nom de la base, identifiants, nom de l'entreprise).
- `install.sh` : Script d'orchestration. Il démarre les conteneurs, attend que le service web soit pleinement opérationnel, configure le pays par défaut en base de données, et déclenche l'importation.
- `import.csv.sh` : Script d'injection de données. Il copie le fichier CSV dans le conteneur MariaDB et exécute la commande `LOAD DATA INFILE` pour populer la table `llx_societe`.
- `import_tiers.csv` : Le jeu de données contenant la liste des clients/fournisseurs.

## 🛠️ Démarche Technique et Justifications

**1. Orchestration avec boucle d'attente active**
Le démarrage d'un conteneur ne signifie pas que le service applicatif est prêt. Le script `install.sh` utilise une commande `curl` dans une boucle `until` pour interroger le port 80. L'importation des données ne se déclenche que lorsque Apache renvoie un code HTTP 200/302, garantissant que la base de données a terminé son initialisation interne.

**2. Gestion de l'activation des modules (Choix de conception)**
Durant le développement, l'activation forcée du module "Tiers" via une injection SQL directe (`INSERT INTO llx_const`) entraînait un problème de droits d'accès (interface grisée, impossibilité de cliquer). Cette méthode court-circuitait le moteur de permissions PHP de Dolibarr.
**Solution retenue :** Pour préserver l'intégrité et la sécurité de l'application, nous avons fait le choix technique de configurer l'infrastructure, la société et les données automatiquement, mais de laisser l'activation du module métier à l'administrateur lors de la première connexion. Cela permet à Dolibarr de générer correctement les caches et les droits de session. Le pays de la société est quant à lui injecté en SQL pour éviter le blocage de configuration initiale.

## 🚀 Instructions d'installation et de lancement

**1. Nettoyer l'environnement (Optionnel mais recommandé pour un test à blanc)**
Si une ancienne installation existe, purgez les conteneurs et les volumes :
`docker compose down -v`

**2. Rendre les scripts exécutables**
Sous environnement Linux/Git Bash, assurez-vous que les scripts ont les droits d'exécution :
`chmod +x install.sh import.csv.sh`

**3. Lancer le déploiement automatisé**
Exécutez le script principal :
`./install.sh`
Le script va démarrer Docker, patienter pendant l'initialisation de Dolibarr (environ 30 à 60 secondes), configurer le pays, et injecter les données Tiers.

**4. Finalisation de la configuration (Validation du fonctionnement)**
- Ouvrez un navigateur et accédez à l'URL : **`http://localhost`**
- Connectez-vous avec les identifiants par défaut (`admin` / `admin`).
- Naviguez dans **Configuration > Modules/Applications**.
- Activez le module **Tiers** (Gestion de la relation client).
- L'onglet **Tiers** apparaît dans le menu supérieur. En cliquant dessus, vous constaterez que la liste des entreprises a bien été importée par nos scripts.