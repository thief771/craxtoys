# Installer LuckyCrax dans la place existante

Ce lot vise la place possédant déjà les raccordements InvertedCrax, SuperCrax et SymbiotiCrax du dépôt. Ce n’est pas une place autonome. Il contient des ressources importables et une commande complète, sans ID Roblox inventé. Les tests du moteur Studio restent à effectuer et l’adaptateur BlackSpida manque encore.

## Installation

1. Arrêter Play et enregistrer une copie de la place. Conserver les corrections actuelles : ne jamais réinstaller d’anciens scripts pour satisfaire un ancrage refusé.
2. Importer [`LuckyCrax_FX_IMPORT.fbx`](../../assets/luckycrax/model/LuckyCrax_FX_IMPORT.fbx) avec l’importateur 3D, sous le propriétaire de l’expérience. Conserver les **32 meshes**, leurs noms, leur disposition relative et les trois petits repères `LFX_Origin`, `LFX_Up`, `LFX_Front`. Ne pas fusionner, décimer, supprimer ou déplacer séparément ces pièces. Publier les meshes avec leurs autorisations réelles.
3. Placer la racine complète dans **`ServerStorage`**, nommée exactement **`LuckyCrax_Import`**. Aucun objet sélectionné n’est utilisé par l’installateur. Le modèle original reste à cet emplacement ; aucun grand modèle de démonstration ne doit rester dans Workspace.
4. Ouvrir [`INSTALLER_LUCKYCRAX.lua`](../../integration/luckycrax/INSTALLER_LUCKYCRAX.lua), copier **tout** son contenu et l’exécuter comme une seule commande dans la barre de commande Studio, Play arrêté. Ne pas copier les fichiers `review` par-dessus les scripts actuels.
5. Brancher les ressources ci-dessous, enregistrer la place, fermer et rouvrir Studio, puis lancer un **nouveau Play**. Un ancien Play conserve son cache de modules.
6. Tester sur une copie de la place avec **Test → Start Server → deux joueurs**, puis mobile/tablette. Ne publier la place qu’après ces vérifications.

La commande lit les sources réelles de l’éditeur avec `GetEditorSource`, vérifie les ancrages uniques et écrit avec `UpdateSourceAsync` en refusant toute modification concurrente. Elle sauvegarde les 26 scripts adaptés et les dix nouvelles sources dans `ServerStorage.LuckyCrax_Backup_V1`, puis crée ses objets marqués `LuckyOwned`. Une deuxième exécution vérifie l’installation et ne crée aucun doublon. Un conflit conserve une sauvegarde incomplète pour examen ; il ne faut pas la supprimer pour forcer la suite.

L’installateur clone/recolore le rig natif CraxSourire de la place pour les previews et le combat. **Ne pas substituer le FBX complet au rig jouable.** `LuckyCrax_TeteSeule.fbx`, OBJ/MTL et `LuckyCrax.blend` sont fournis pour la revue artistique et les retouches. Les éventuels noms Studio déjà différents seront signalés par le précontrôle.

## Sons et illustrations

Importer [`LuckyCrax_AUDIO_ATLAS.wav`](../../assets/luckycrax/audio/LuckyCrax_AUDIO_ATLAS.wav), exactement **16,24 secondes**, sous le propriétaire de l’expérience. Il contient 25 sons avec 120 ms de séparation. Les WAV individuels, les plages et une [page d’écoute](../../assets/luckycrax/audio/ECOUTER.html) sont fournis.

Créer un `Sound` temporaire nommé **`LuckyCrax_AUDIO_ATLAS`**, renseigner son vrai `SoundId`, puis préparer les quatre `ImageLabel` suivants avec les vrais IDs des PNG importés :

| Image | Nom de l’objet temporaire |
|---|---|
| `assets/luckycrax/illustrations/LuckyDice.png` | `LuckyDiceIcon` |
| `LuckyClover.png` | `LuckyCloverIcon` |
| `LuckyJackpot.png` | `LuckyJackpotIcon` |
| `LuckyMax.png` | `LuckyMaxIcon` |

Sélectionner ces objets ou leur dossier parent puis exécuter [`BRANCHER_ASSETS_LUCKYCRAX.lua`](../../integration/luckycrax/BRANCHER_ASSETS_LUCKYCRAX.lua), en STOP. Les IDs sont stockés dans `ReplicatedStorage.CraxLuckyUserAssets` ; les objets temporaires peuvent ensuite être retirés. Enregistrer puis nouveau Play.

Pendant Play **côté CLIENT**, exécuter [`DIAGNOSTIC_AUDIO_CLIENT.lua`](../../integration/luckycrax/DIAGNOSTIC_AUDIO_CLIENT.lua). Il vérifie le chargement, la durée et les 25 plages, puis les fait écouter séparément. Vérifier permissions de l’expérience, modération et mixage réel. Chaque cue utilise un Sound indépendant et une plage bornée ; la boucle des rouleaux est stoppée sur interruption. Sans IDs, les pouvoirs fonctionnent silencieusement et le livre emploie des textes de secours.

## Vérification simple

- Collection, sélection, livre, casino : vraie tête blanche à dents dorées, Rare, 105 PV, mêlée 8 ; comparer face/profils/arrière à la référence. Pas de corps, pas de géométrie géante, pas de doublon de mâchoire.
- Base : Pile 12 sans rebond ; Face 16 avec deux rebonds ; première cible seulement ; pas d’allié touché. Dés : chiffres serveur lisibles, opposés corrects, exemples 2+5→14, 3+3→20, 6+6→32, une application de zone par victime.
- Trèfle : subir trois vrais coups ; le troisième retire des PV ; le suivant est esquivé une fois. Tester laser continu, poison, capture Sym, critique Spidey, collision réciproque, expiration, pause et mort.
- Jackpot : machine au-dessus des PV, trois signes seulement, trois colonnes identiques au résultat. Soin 90→105 affiche +15 ; 105 affiche PV MAX. Six pièces maximum 30 bruts sur une cible, durée individuelle 4 s, ouverture puis fermeture exacte de la vraie bouche.
- Triche : annulation du pouvoir déjà actif, sept secondes actives, déplacement/mêlée ordinaires conservés, aucun redémarrage d’ancien projectile et aucun statut restauré trop tard. Tester Super, Inverted, Sym, Deadly/alliés et les autres familles ; **BlackSpida nécessite ses sources avant ce test**. Consulter Output et `CombatState.LuckyUnsupportedFamilies`.
- MAX : seulement Lucky gagnant niveau 4 ; vrai vaincu, coffre et rouleaux, pluie de pièces cosmétique, pièce ramenée aux dents, titre, retour caméra/FOV/visibilités. Tester départ, nouveau round et interruption à chaque phase, spectateur et portrait. Aucun second dégât ni gain d’argent.
- Persistance : anciens profils intacts, obtention Rare, doublons, quatre achats, reconnexion, trophée équipé. Quêtes, téléporteurs, menus et victoires des autres Crax doivent conserver leur comportement. Ces tests nécessitent Studio.

## Revenir en arrière

Arrêter Play, exécuter tout [`RETOUR_ARRIERE_LUCKYCRAX.lua`](../../integration/luckycrax/RETOUR_ARRIERE_LUCKYCRAX.lua), enregistrer puis nouveau Play. La commande restaure les sources exactes sauvegardées et retire ses objets ; elle conserve les imports originaux, les IDs utilisateur et les données joueur.

Si une source a changé après installation, le retour arrière refuse de l’écraser : fusionner avec la sauvegarde ou reprendre la copie de place. Retirer Lucky avant les lots dont il adapte les sources. Le retour arrière ne supprime pas les possessions Lucky dans les DataStores.

Pour intégrer une version plus récente de la place ou BlackSpida, exécuter [`DIAGNOSTIC_SOURCES_ACTUELLES.lua`](../../integration/luckycrax/DIAGNOSTIC_SOURCES_ACTUELLES.lua) en STOP et conserver tous les blocs Output entre BEGIN et END. Cette commande lit les buffers de l’éditeur sans modifier la place.
