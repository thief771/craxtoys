# Commande actuelle : PolariCrax V2

La [commande d’installation](COMMANDE_INSTALLATION.lua) détecte une installation existante et applique la [mise à jour V2](../v2/README.md) dans le jeu ouvert. Sans installation préalable, elle installe directement la V2 complète. Arrêter Play avant la commande, puis enregistrer et lancer un nouveau Play après réussite.

# Installer directement dans le jeu ouvert

Aucun autre fichier de jeu n'est nécessaire. Ouvrir votre jeu actuel dans Roblox Studio, arrêter Play et afficher la **Barre de commande** depuis Affichage ou Fenêtre selon la version de Studio.

1. Copier tout [COMMANDE_INSTALLATION.lua](COMMANDE_INSTALLATION.lua) avec **Raw**, puis coller dans la barre de commande et valider.
2. La commande récupère l'installateur de cette version précise du dépôt. Elle utilise les 16 meshes déjà importés sous `Workspace.PolariCrax_ACCESSOIRES_IMPORT` ou `ServerStorage.PolariCrax_Import`.
3. Elle vérifie les sources actuelles avant modification et crée `ServerStorage.PolariCrax_Backup_V1`. Une version incompatible est refusée ; ne pas restaurer d'anciens scripts pour contourner ce refus.
4. Après le message de réussite, enregistrer et lancer un nouveau Play. L'installation doit être validée à deux clients dans Studio.

Les requêtes HTTP sont activées temporairement pour récupérer la commande, puis leur réglage antérieur est rétabli. Si le téléchargement est refusé, aucun script n'est installé : copier directement le contenu intégral de [l'installateur](INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua) dans la barre de commande, après avoir placé le modèle importé sous `ServerStorage.PolariCrax_Import`.

Pour retirer PolariCrax uniquement : arrêter Play et exécuter [COMMANDE_RETOUR_ARRIERE.lua](COMMANDE_RETOUR_ARRIERE.lua). Elle préserve les modifications concurrentes en refusant d'écraser une source éditée après installation.

Les sons et illustrations nécessitent toujours leurs vrais identifiants Roblox ; voir [le guide](LIRE-MOI.txt). Le modèle n'est pas importé depuis Internet par cette commande : les meshes doivent être présents dans le jeu, comme dans le dernier fichier fourni.

`CombatState` peut être absent en STOP : RoundManager le crée au lancement. L’installateur vérifie cette initialisation dans le script actif, sans créer de dossier provisoire. Correction vérifiée avec 103 assertions d’installation/retrait, dont installation sans CombatState, refus d’un initialiseur absent ou désactivé, et préservation des éditions concurrentes.

Correction Bat : le raccordement utilise l’entrée unique de `stepLamp` et vérifie la structure de sa minuterie. Le sérialiseur conserve les sauts de ligne des ancrages. Un test compare les 46 chaînes avant/après avec les opérations JSON, applique le raccordement au script Bat transmis et vérifie que la pause décale seulement son échéance absolue. La suite `npm run test:polari` inclut ce contrôle.
