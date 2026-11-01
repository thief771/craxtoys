# Vérifications exécutées

Commande : `npm test`, Node.js et luau-web 1.5.1 (compilateur/interpréteur Luau WebAssembly). Dépendance verrouillée avec intégrité dans package-lock.json.

Résultat : **201 assertions réussies**, aucun échec, et compilation des **30 scripts Luau de production complets** (sources nouvelles, sources modifiées, installateur, retour arrière et branchement audio).

| Groupe | Assertions | Ce qui est exécuté |
| --- | ---: | --- |
| Règles déterministes | 75 | Troisième coup exact, minimum 8, absence d’empilement, consommation, formules d’arrondi, instant 10/20, pauses, décès/identité/round, réapplication et contrôle des déclenchements Fantastic/Fléau |
| Catalogues réels modifiés | 21 | Statistiques, vitesse commune, grille de prix existante, 4 niveaux, absence de trophée inventé, conservation des masses de rareté au casino, condition MAX |
| Véritable moteur serveur Inverted | 21 | MUTE à rayon mesuré, absence de dégâts directs, direction/vitesse, vulnérabilité unique, protection anti-létale, copie/consommation, restauration de position interne/PV, annulation par mort |
| Véritable CombatHealth + moteur Inverted | 12 | Application des pertes de PV, capture du troisième impact, copie remplaçant la base, consommation sur impact réel, vulnérabilité, arrondi après modificateurs, immunité, zéro de contrecoup conservé, écriture des PV internes |
| Véritables installateur et retour arrière | 62 | Précontrôles, refus d’un nom déjà utilisé ou d’une source obsolète, erreur d’écriture injectée et restauration transactionnelle, sources sauvegardées, modèles/événement, réexécution sans doublons, protection des modifications ultérieures, restauration exacte et réinstallation |
| Véritable client VFX sur objets simulés | 10 | Compteur sans SILENCE, propriétés GUI booléennes valides, indicateurs SILENCE/PIRATAGE, appels MUTE/Mark/Restore, copie prête à 8 sans faux bonus, boucle unique, retrait des connexions et destruction des objets |

Les tests utilisent les véritables textes Luau livrés, avec des représentations minimales des services et objets Roblox. Ils ne lancent pas Roblox Studio. Les assertions du client portent sur ses callbacks et son nettoyage, pas sur une image rendue par Roblox ni sur toute la chronologie caméra du MAX.

Les adaptations de SILENCE sont recensées dans silence-audit.json. Les conditions de démarrage ont été revues ; ce contrôle statique et ces tests ne démontrent pas à eux seuls la non-régression de tous les personnages dans le moteur réel.

Les contrôles Blender (0 pièce de corps, dimensions, conservation des sommets et exports) sont consignés dans assets/invertedcrax/head-only/validation.json. Les aperçus sont des rendus Blender examinés. Les WAV ont été relus/contrôlés numériquement ; aucune écoute n’a été effectuée ici.

## Non exécuté dans cet environnement

Installation réelle dans la place Studio, imports et permissions des assets, sauvegarde/DataStore, transactions avec deux profils réels, réplication à deux clients, chronologie/rendu caméra de la victoire, profils mobile/tablette et performances sur appareil. La procédure de vérification réelle figure dans INSTALLATION.md. Aucun résultat non exécuté n’est annoncé réussi.
