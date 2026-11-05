Le lot actuel est **PolariCrax** : [état et tests](docs/polaricrax/TESTS_ET_ETAT.md), [installation](docs/polaricrax/INSTALLATION.md), [analyse et réglages](docs/polaricrax/ANALYSE_ET_CHOIX.md). Les statuts historiques des lots précédents suivent.

Le dernier lot est **LuckyCrax** : [état réel, limites et imports restants](docs/luckycrax/ETAT.md), [installation](docs/luckycrax/INSTALLATION.md), [tests locaux](docs/luckycrax/TESTS.md). Le statut ci-dessous concerne le lot historique InvertedCrax.

# État réel — InvertedCrax

Le ZIP d’intégration contient maintenant les ressources ET le code : six nouvelles sources, vingt et une sources existantes adaptées, installateur unique, retour arrière et configuration des vrais IDs audio/icône.

Implémenté dans les sources : personnage tête seule, registre épique 120 PV / mêlée 8 / vitesse commune existante, livre à quatre niveaux cumulatifs, casino, utilisation de la sauvegarde/sélection existante, MUTE, SILENCE aux déclenchements, PIRATAGE, vulnérabilité, COPIER-COLLER, CTRL-Z, rendu client et protocole de victoire ERREUR 404.

Validation locale : compilation Luau des 30 scripts de production complets ; tests des règles, catalogues réels, moteur serveur et véritable CombatHealth avec services simulés ; exécution de l’installateur/retour arrière et du cycle VFX client sur objets simulés. Détails dans `integration/invertedcrax/TESTS.md`.

À faire dans Roblox Studio : exécuter l’installateur sur la place correspondante, importer/autoriser les WAV et fournir l’icône éventuelle, puis vérifier deux clients, rendu, DataStores, achats et non-régression des autres Crax. Aucun de ces tests Studio n’a été effectué ici et aucune place n’a été publiée.

Les aperçus sont des rendus Blender. Le rig jouable est une copie/recoloration du vrai rig natif, incluant sa croix courbe existante ; la nouvelle croix lissée du FBX est une ressource supplémentaire sans ID fictif. Les WAV sont originaux et vérifiés numériquement, mais non écoutés ici.

Le paquet est prêt à être essayé sur une copie de la place ; il ne doit pas être décrit comme validé en production avant les vérifications Studio documentées.
