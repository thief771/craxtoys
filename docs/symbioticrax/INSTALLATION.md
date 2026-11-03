# SymbiotiCrax — installation dans la place existante

**Le kit contient du code et de vrais meshes. Il faut encore les importer puis tester dans Roblox Studio. Aucune place n’a été exécutée ou publiée depuis cet environnement.** Les images sont des rendus du modèle livré.

Pour mettre à jour une installation existante, suivre [la procédure de refonte](REFONTE.md#mise-à-jour-dune-installation-existante) : la simple réexécution de l’installateur ne met pas une V1 à jour.

## Ordre court

1. **Arrêter Play** et enregistrer une copie de la place actuelle. Ce lot vise les systèmes de `7 Deadly Crax / Arène cubique`, avec le raccordement SuperCrax déjà installé. Il n’installe pas un jeu autonome dans une place vide. Conserver les corrections actuelles : ne pas réinstaller une ancienne version des scripts pour satisfaire un ancrage.
2. Importer [`SymbiotiCrax_ACCESSOIRES_IMPORT.fbx`](../../assets/symbioticrax/model/SymbiotiCrax_ACCESSOIRES_IMPORT.fbx) avec l’importateur 3D, sous le propriétaire de l’expérience. Conserver **les 31 meshes et les 13 repères**, sans fusionner ni renommer les pièces. Terminer la publication des meshes et vérifier leur autorisation dans l’expérience. Les repères ne sont pas visibles sur le personnage final. Ne pas déplacer les pièces séparément ; une transformation uniforme de l’ensemble est prise en compte.
3. Sélectionner **une seule racine** contenant toutes les pièces importées. Ouvrir [`INSTALLER_SYMBIOTICRAX.lua`](../../integration/symbioticrax/INSTALLER_SYMBIOTICRAX.lua), copier tout son contenu et l’exécuter dans la barre de commande Studio **en STOP**. C’est une commande complète ; ne pas copier les sources du dossier `review` par-dessus les scripts du jeu.
   Après succès, déplacer le modèle d’import original dans `ServerStorage` pour le conserver sans laisser une seconde figurine dans l’arène. L’installateur utilise sa propre copie.
4. Importer l’atlas audio et les quatre PNG comme décrit ci-dessous, puis exécuter la commande de branchement. Enregistrer la place, la fermer et la rouvrir, puis lancer un **nouveau Play** pour recharger modules et LocalScripts.
5. Effectuer les tests à deux joueurs ci-dessous avant publication de la place existante.

Le FBX complet, l’OBJ/MTL et le `.blend` servent à revoir ou retoucher la tête. L’installateur emploie le **vrai rig CraxSourire présent dans la place**, pas un remplacement générique importé du personnage complet. Les meshes additionnels sont ajustés avec `FIT_HeadCenter`, `FIT_Front`, `FIT_Up`, `SYM_Mouth` et neuf racines de tentacules.

## Ce que vérifie la commande

- Mode STOP, classes et dépendances existantes, absence de doublons, import complet, vrais MeshId des accessoires et repères orthogonaux.
- Lecture des **sources visibles dans l’éditeur**, via `ScriptEditorService:GetEditorSource`. Préparation des 18 adaptations avant écriture ; ancrages uniques obligatoires.
- Écriture avec `UpdateSourceAsync` et comparaison du contenu courant dans le callback, puis relecture de contrôle. Une édition concurrente ne doit pas être écrasée.
- Sauvegarde des sources exactes dans `ServerStorage.SymbiotiCrax_Backup_V1`. Aucun attribut réservé `RBX_ReimportId` n’est réassigné : l’import est cloné par Roblox, seuls les attributs propres au lot sont ajoutés.
- Ajout de huit sources, un événement serveur VFX, une copie des accessoires, un template et un preview dérivés de `Crax_Monster`. Une seconde exécution ne crée pas de doublons.

Une erreur normale d’écriture déclenche la restauration. **Si une édition concurrente empêche une restauration sûre, la sauvegarde reste marquée `Incomplete` et la commande affiche les chemins concernés.** Ne pas publier ce résultat partiel ; comparer les entrées `Original`/`Installed` à l’éditeur, préserver le travail concurrent, ou reprendre la copie de place. Une réexécution refuse cet état au lieu de l’effacer.

Si le précontrôle annonce « source actuelle non reconnue », aucune adaptation n’a commencé. Il faut adapter l’ancrage à cette source actuelle. Ne pas remplacer le fichier par une ancienne version de revue. Si `ScriptEditorService` est refusé par le contexte Studio, garder le diagnostic : aucune écriture de secours aveugle dans `.Source` n’est tentée.

## Audio : un seul WAV à importer

Importer [`SymbiotiCrax_AUDIO_ATLAS.wav`](../../assets/symbioticrax/audio/SymbiotiCrax_AUDIO_ATLAS.wav), **13,47 secondes**, sous le propriétaire de l’expérience. Il regroupe 21 sons originaux, séparés par 120 ms de silence. Les WAV individuels, le générateur, les plages exactes et une page d’écoute sont aussi fournis : [`ECOUTER.html`](../../assets/symbioticrax/audio/ECOUTER.html).

Créer un `Sound` temporaire nommé **`SymbiotiCrax_AUDIO_ATLAS`**, avec son véritable `SoundId` obtenu après import. Aucune publication audio n’a été faite ici et aucun ID n’est inventé ou emprunté à SuperCrax.

Importer également les illustrations et préparer quatre `ImageLabel` temporaires :

| Fichier | Nom de l’ImageLabel |
|---|---|
| `assets/symbioticrax/illustrations/SymMarksIcon.png` | `SymMarksIcon` |
| `SymArmourIcon.png` | `SymArmourIcon` |
| `SymParasiteIcon.png` | `SymParasiteIcon` |
| `SymMaxIcon.png` | `SymMaxIcon` |

Renseigner leur propriété `Image` avec les vrais IDs importés. Sélectionner les objets temporaires ou leur dossier parent et exécuter tout [`BRANCHER_ASSETS_SYMBIOTICRAX.lua`](../../integration/symbioticrax/BRANCHER_ASSETS_SYMBIOTICRAX.lua), Play arrêté. Les IDs sont conservés dans les attributs de `ReplicatedStorage.CraxSymUserAssets`. Retirer les objets temporaires, enregistrer et lancer un nouveau Play.

**Pendant Play, côté CLIENT**, exécuter [`DIAGNOSTIC_AUDIO_CLIENT.lua`](../../integration/symbioticrax/DIAGNOSTIC_AUDIO_CLIENT.lua). Il vérifie le chargement avec un délai maximal de 15 s, la durée, les plages, puis fait écouter chaque passage. En cas d’échec, son message indique l’ID, le statut disponible et les permissions à vérifier. L’écoute humaine reste nécessaire ; un message « chargé » ne prouve pas que le mixage en combat est bon.

Chaque événement utilise un `Sound` indépendant avec `PlaybackRegion` ; la traction utilise une `LoopRegion` bornée à son segment. La lecture attend le chargement, une durée incompatible est refusée et les boucles s’arrêtent avec leur capacité. Les segments restent configurés dans `CraxSymAudioMap` ; ne pas remplacer l’atlas par une compilation réordonnée.

Sans ID audio, les pouvoirs fonctionnent silencieusement. Sans images, le livre affiche les sceaux 3 / 35 % / DUO / MAX ; le trophée reste enregistré par son vrai identifiant logique. Les ressources Roblox doivent être autorisées et, le cas échéant, modérées avant de devenir utilisables.

## Test simple dans Studio

Utiliser une copie de la place, puis **Test → Start Server avec deux joueurs**.

1. **Persistance :** un profil ancien conserve monnaies, possessions, niveaux et trophée équipé ; un nouveau profil reçoit seulement les personnages de départ prévus. Vérifier gain réel au casino, doublon Épique, sélection autorisée seulement si possédé, reconnexion et achats sauvegardés. Aucun don universel n’est ajouté pour contourner l’obtention.
2. **Modèle :** regarder face, profils, arrière, langue et tentacules dans collection, sélection, casino, livre et combat. Vérifier taille, pivot, hitbox native inchangée, cadrage de l’ensemble, animation de bouche et absence d’intersections. Comparer à la photo fournie ; l’arrière reste une interprétation. Vérifier mobile et tablette.
3. **Niveaux :** base 125 PV, mêlée 8, vitesse CraxSourire ; achats confirmés selon GhostyCrax : 5000/15000/30000/50000 Coins ou 30/80/150/250 Gems. Contamination puis armure puis parasite, conservés aux niveaux supérieurs. MAX ajoute le trophée et la scène, sans dégâts supplémentaires.
4. **Langue :** tester réussite, échec, cible morte/partie, capture près des quatre murs, interruption et verrou concurrent (gel/Fantastic). Projection depuis la bouche, traction progressive, une seule morsure de 16, pas de +8 au même instant, rétraction et aucun verrou résiduel. Vérifier la portée, la lisibilité de l’enroulement et l’alignement serveur/visuel.
5. **Contamination :** trois mêlées dommageables sur la même victime → une explosion de 15, puis soin de 5 seulement si l’explosion retire des PV. Tester invulnérabilité, expiration, deux propriétaires et changements de round. Langue, explosion et parasite ne posent pas de marque par défaut.
6. **Armure :** après 30 PV effectivement perdus, les coups suivants sont réduits de 35 % pendant 4 s actives ; pas de recharge durant la protection, pas de sauvetage mortel. Vérifier soin plafonné, SILENCE et autres réductions.
7. **Parasite :** un seul par héros, poursuite bornée, accrochage 3 s, ralentissement ×0,75 sans cumul par frame, au plus 9 dégâts de base, retour et soin de 5 conditionnel. Vérifier perte de cible, mort du propriétaire, retrait du ralentissement et audio.
8. **MAX :** uniquement le vrai gagnant SymbiotiCrax niveau 4. Une tête de héros, un vaincu complet, grande mâchoire, capture, fermeture, disparition du vaincu, rétraction et titre doré. Vérifier le trophée dans le livre et son équipement. Tester portrait, spectateur proche, abandon et nouveau round à chaque phase : caméra/FOV/transparences doivent être restitués, sans seconde récompense.
9. **Régression :** Inverted, Super, Killa, Ghosty, Fléau, Golden, Fantastic, Deadly et Plumber conservent leurs menus, contrôles, sons et victoires. Contrôler quêtes génériques et scores, nombre d’objets après plusieurs rounds, performances sur appareil mobile et fermeture/réouverture de Studio.

Les tests automatisés locaux sont dans [TESTS.md](TESTS.md). Ils ne remplacent pas ces vérifications du moteur, des DataStores et des permissions.

## Revenir en arrière

Arrêter Play et exécuter tout [`RETOUR_ARRIERE_SYMBIOTICRAX.lua`](../../integration/symbioticrax/RETOUR_ARRIERE_SYMBIOTICRAX.lua). Il vérifie les sources de l’éditeur, restaure leurs versions exactes antérieures et supprime seulement les éléments qu’il possède. Les imports originaux, IDs utilisateur et données joueur sont conservés.

Si une source a été éditée depuis l’installation, le retrait refuse de l’écraser. Faire la fusion avec la sauvegarde ou reprendre la copie de place. Retirer SymbiotiCrax avant de retirer SuperCrax : les raccordements de ce lot s’appuient sur sa version installée. Enregistrer puis nouveau Play ; la publication de la place reste une opération distincte.
