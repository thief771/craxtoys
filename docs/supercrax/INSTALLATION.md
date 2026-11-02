# Installer SuperCrax dans la place existante

Ce lot s’installe dans **7 Deadly Crax / Arène cubique**, sur les systèmes inspectés. Ce n’est pas une place Roblox autonome. Studio n’est pas accessible dans cet environnement : le code, les meshes, les illustrations et les sons sont livrés, mais l’import et la validation en jeu restent à effectuer.

## 1. Sauvegarde et import du vrai modèle

1. Arrêter **Play**. Enregistrer une copie de la place (`Enregistrer sous…`). Garder cette copie jusqu’à validation des tests.
2. Dans l’importateur 3D de Studio, ouvrir [`SuperCrax_ACCESSOIRES_IMPORT.fbx`](../../assets/supercrax/model/SuperCrax_ACCESSOIRES_IMPORT.fbx). Utiliser le propriétaire de l’expérience pour les ressources. Importer **toutes les pièces**, sans les fusionner ni supprimer leurs noms. Ne pas ajouter le FBX complet comme personnage : l’installateur conserve le rig CraxSourire natif.
3. Conserver les trois petits meshes `FIT_HeadCenter`, `FIT_Front`, `FIT_Up`. Ils servent uniquement à aligner les accessoires et ne seront pas visibles sur le personnage. Ne pas déplacer les pièces séparément. Un déplacement ou une échelle uniforme de l’ensemble est accepté.
4. Vérifier que les meshes sont publiés et utilisables par l’expérience, puis sélectionner **une seule racine** contenant les 15 meshes Super et les 3 repères. L’importateur peut ajouter un dossier supérieur : sélectionner celui qui contient toutes les pièces. Si ses options renommant les objets sont activées, les désactiver.

Les matériaux importés ne conditionnent pas le résultat : l’apparence en jeu applique la palette vinyle aux vrais meshes. Les pièces n’ajoutent ni collisions, ni portée de frappe. Le modèle Blender et le FBX complet sont fournis pour inspection et retouche.

## 2. Une seule commande d’installation

Ouvrir [`INSTALLER_SUPERCRAX.lua`](../../integration/supercrax/INSTALLER_SUPERCRAX.lua), copier **tout le contenu**, puis le coller dans la barre de commande Studio, **Play arrêté**, avec la racine importée sélectionnée. Ne pas coller les balises d’un bloc Markdown.

La commande :

- vérifie les sources **actuellement présentes**, les points de raccordement uniques et les vrais MeshId importés avant de modifier quoi que ce soit ;
- ajoute cinq sources, un événement VFX, le template et le preview dérivés de `ServerStorage.CraxTemplates.Crax_Monster` ;
- adapte 14 sources existantes sans rétablir d’anciennes versions complètes ;
- garde leurs versions exactes dans `ServerStorage.SuperCrax_Integration_Backup_V1` ;
- annule la transaction si une écriture échoue et ne crée aucun doublon lorsqu’on la relance.

Si une source est annoncée « version non reconnue », le précontrôle s’arrête sans modification. Il faut adapter le raccordement à cette source actuelle ; **ne pas remplacer cette source par le fichier de revue**. Les sources de `integration/supercrax/review` documentent le résultat sur l’export analysé, elles ne sont pas une commande à recopier par-dessus le jeu.

Enregistrer la place puis lancer un **nouveau Play**, pour recharger les modules et le client. SuperCrax n’est pas offert aux joueurs : l’obtention, les achats et les sauvegardes utilisent les systèmes existants.

## 3. Brancher les 19 sons et les quatre illustrations

Les fichiers sont dans [`assets/supercrax/audio`](../../assets/supercrax/audio) et [`assets/supercrax/illustrations`](../../assets/supercrax/illustrations). Les illustrations sont des rendus du vrai modèle, pas des captures Studio.

1. Importer les WAV via les outils d’assets Roblox. Vérifier leurs permissions pour l’expérience et leur chargement. Créer des objets `Sound` temporaires dont les noms correspondent aux fichiers sans `.wav` (`SteelStart`, `LaserLoop`…). Leur `SoundId` doit être le véritable ID obtenu après import. Le manifeste décrit les 19 noms et durées.
2. Importer les quatre PNG. Créer quatre `ImageLabel` temporaires nommés `SuperLaserIcon`, `SuperFrostIcon`, `SuperInvincibleIcon`, `SuperMaxIcon`, et renseigner leur propriété `Image` avec les vrais IDs importés.
3. **Play arrêté**, sélectionner ces objets ou leur dossier parent, puis exécuter tout [`BRANCHER_ASSETS_SUPERCRAX.lua`](../../integration/supercrax/BRANCHER_ASSETS_SUPERCRAX.lua). La commande lit leurs vrais IDs et les enregistre dans les attributs de `ReplicatedStorage.CraxSuperUserAssets` ; elle peut être relancée.
4. Retirer les objets temporaires, enregistrer, puis lancer un **nouveau Play**. Le dossier d’IDs est conservé, y compris après retour arrière.

Sans IDs audio, les sons sont silencieux ; les pouvoirs fonctionnent. Sans IDs image, le livre affiche les sceaux de secours LASER / GEL / 1 PV / MAX. Aucun identifiant de remplacement fictif n’est fourni. L’import peut nécessiter modération et autorisation Roblox : ce lot ne les réalise pas à distance.

## 4. Tester avant publication

Sur une copie de la place, utiliser **Start Server / deux joueurs**, puis vérifier :

1. Un compte existant conserve ses Crax, monnaies, niveaux et sélection. Un nouveau compte reçoit seulement les personnages de départ existants. Un vrai gain de casino SuperCrax l’ajoute à l’inventaire ; un doublon conserve la compensation Commun. Vérifier sauvegarde/reconnexion.
2. Le même visage, coiffure et écusson apparaissent dans l’inventaire, la sélection, le casino, le livre et l’arène. Vérifier tête seule, pivot, aucune collision des cheveux, boutons et menus inchangés, aperçu mobile/tablette et ordre des quatre niveaux.
3. Les achats utilisent **5 000 / 15 000 / 30 000 / 50 000 Coins** ou **30 / 80 / 150 / 250 Gems** ; pas de niveaux gratuits. Base : 100 PV, contact 8, vitesse CraxSourire. Les niveaux sont cumulatifs.
4. Base : délai 8–12 secondes actives, trois tours en 1,5 s, une touche de 16 par victime **par tour**, acier uniquement pendant le dash, pas de contact supplémentaire de 8. Tester près des quatre murs.
5. Niveau 1 : deux directions indépendantes depuis les yeux, 2,5 s, aucune invulnérabilité. Une exposition intégrale sans réduction retire **37,5 PV**, même si les deux lasers touchent. Tester sorties/retours dans le rayon et obstacles.
6. Niveau 2 : troisième mêlée efficace → 2 s de charge mobile → 3,5 s de souffle vers le coin le plus éloigné. Maintien du gel, 5 s après dernière exposition, mêlée du poseur à **35 au total**, libération et absence de regel par ce souffle. Aucun dégât de souffle ajouté ; lasers et dash ne brisent pas la glace par défaut.
7. Niveau 3 : coup mortel direct et périodique → **1 PV**, soins bloqués, pouvoirs conservés. Un ennemi ramasse la kryptonite, sa vitesse vaut ×1,5 sans cumul ; la toucher au sol ou toucher le porteur tue SuperCrax **même en acier**. Vérifier scores, mort du porteur, retrait du bonus et nouveau round. Tester SILENCE avant et après activation.
8. MAX gagnant uniquement : vrais skins locaux, ennemi immobile au centre, vol, gel progressif, charge rouge **1,5 s**, lasers, disparition et fragments de la victime entière, retour caméra à 8,2 s. Tester portrait, spectateur proche, changement de round et départ d’un joueur en pleine scène. Aucun second gain ni dégât.
9. Écouter les 19 sons avec la musique et l’autre client. Contrôler alignement lasers/VFX/dégâts, volume, absence de boucle résiduelle et nombre d’objets après plusieurs rounds. Tester qualité Auto sur appareil tactile.
10. Rejouer Inverted, Ghosty, Killa, Fléau, Golden, Fantastic, Deadly et Plumber : leurs scènes, protections, statuts et quêtes doivent garder leur comportement. Publier uniquement après ces vérifications.

Les tests locaux automatisés sont décrits dans [TESTS.md](TESTS.md). Ils ne remplacent ni Roblox DataStore, ni les achats, ni la réplication réseau et le rendu.

## 5. Retour arrière

Arrêter Play, puis copier et exécuter tout [`RETOUR_ARRIERE_SUPERCRAX.lua`](../../integration/supercrax/RETOUR_ARRIERE_SUPERCRAX.lua). La commande remet les sources exactes présentes avant SuperCrax et enlève ses propres ajouts. Elle conserve l’import d’origine, les IDs utilisateur et les données joueur.

Si un script a été édité depuis l’installation, le retour arrière refuse de l’écraser. Comparer cette édition à la sauvegarde `Entries` ou reprendre la copie de place réalisée à l’étape 1. Modifier des attributs dans `CraxSuperUserAssets` ne provoque pas ce refus. Une modification de code/configuration nécessite une revue des sauvegardes avant le retour arrière automatique.

Enregistrer puis relancer un nouveau Play. Ne pas restaurer l’ancien lot Inverted avant d’avoir retiré SuperCrax, car ses raccordements peuvent en dépendre.
