# Installer et essayer PolariCrax dans « Arène cubique »

Le kit contient le code, les modèles, les VFX, les illustrations et les sons. **Roblox Studio n’a pas été exécuté ici.** L’import et les tests à deux clients restent nécessaires. Ce lot cible la place existante avec les raccordements Inverted/Super/Sym/Lucky déjà installés ; il ne crée pas un jeu autonome dans une place vide.

## Installation en STOP

1. Arrêter Play et enregistrer une copie de la place actuelle.
2. Importer [`PolariCrax_ACCESSOIRES_IMPORT.fbx`](../../assets/polaricrax/model/PolariCrax_ACCESSOIRES_IMPORT.fbx) sous le propriétaire de l’expérience. Conserver les **seize meshes**, leurs noms et leurs positions relatives. Ne pas fusionner, supprimer ou déplacer séparément les petits repères. Publier les meshes avec les autorisations de cette expérience.
3. Placer la racine complète dans **`ServerStorage.PolariCrax_Import`**. L’installateur utilise cet emplacement explicite et ignore la sélection. Aucun modèle géant de démonstration ne doit rester dans Workspace.
4. Copier **tout le contenu** de [`INSTALLER_POLARICRAX.lua`](../../integration/polaricrax/INSTALLER_POLARICRAX.lua) et l’exécuter comme une seule commande dans la barre de commande, Play arrêté. Ne pas coller les fichiers `review` par-dessus les scripts du jeu.
5. Importer et brancher l’audio et les illustrations ci-dessous. Enregistrer, fermer puis rouvrir la place et lancer un **nouveau Play**, afin de recharger les modules.

La commande vérifie les dépendances, noms, meshes publiés, repères et ancrages des sources avant modification. Elle lit l’éditeur avec `GetEditorSource`, écrit avec `UpdateSourceAsync` et protège chaque écriture contre les changements concurrents. Elle sauvegarde vingt adaptations et neuf nouvelles sources dans **`ServerStorage.PolariCrax_Backup_V1`**. La répétition est sans doublons. Une source modifiée depuis l’installation ou une transaction incomplète entraîne un refus explicite ; ne pas remettre d’anciens scripts pour contourner ce refus.

Le personnage jouable est une copie du vrai **`ServerStorage.CraxTemplates.Crax_Monster`**, avec son rig et ses deux arcs noirs natifs. L’installateur ajoute uniquement le casque à cette copie. Le FBX tête complète, l’OBJ/MTL et `PolariCrax.blend` sont fournis pour la revue artistique ; **ne pas substituer le FBX complet au rig du jeu**. Les cadrans et éclats importés restent dans la bibliothèque et apparaissent uniquement pendant les capacités/scènes.

## Brancher les vrais IDs

Importer [`PolariCrax_AUDIO_ATLAS.wav`](../../assets/polaricrax/audio/PolariCrax_AUDIO_ATLAS.wav), exactement **12,22 secondes**, avec les autorisations de l’expérience. Il regroupe dix-neuf sons originaux, séparés par 120 ms. Les WAV individuels et une [page d’écoute](../../assets/polaricrax/audio/ECOUTER.html) sont fournis.

Créer un `Sound` temporaire nommé **`PolariCrax_AUDIO_ATLAS`** et renseigner son vrai `SoundId` importé. Préparer aussi quatre `ImageLabel` avec les vrais IDs des PNG transparents :

| Fichier dans `assets/polaricrax/illustrations` | Nom de l’ImageLabel |
|---|---|
| `PolariAttract.png` | `PolariAttractIcon` |
| `PolariInvert.png` | `PolariInvertIcon` |
| `PolariStop.png` | `PolariStopIcon` |
| `PolariMax.png` | `PolariMaxIcon` |

Sélectionner ces objets ou leur dossier parent, puis exécuter tout [`BRANCHER_ASSETS_POLARICRAX.lua`](../../integration/polaricrax/BRANCHER_ASSETS_POLARICRAX.lua), Play arrêté. Les IDs sont stockés dans `ReplicatedStorage.CraxPolariUserAssets`. Les objets temporaires peuvent ensuite être retirés. Sans IDs, les pouvoirs fonctionnent avec textes d’icônes de secours et sans sons ; aucune ressource publiée n’est inventée.

Après enregistrement et nouveau Play, exécuter [`DIAGNOSTIC_AUDIO_CLIENT.lua`](../../integration/polaricrax/DIAGNOSTIC_AUDIO_CLIENT.lua) **côté CLIENT**. Il contrôle le chargement, la durée et les dix-neuf plages puis les fait écouter séparément. Vérifier soi-même les permissions, la modération et le mixage en combat. Chaque son utilise une région exacte, un Sound indépendant et une boucle bornée pour l’attraction ; aucun cue ne démarre l’atlas entier.

## Tests à faire dans Studio

Utiliser une copie de la place et **Test → Start Server avec deux joueurs**.

1. **Apparence et aperçu :** 110 PV, mêlée 7, Rare ; même vraie tête en collection, sélection, livre, casino et combat. Deux petits arcs noirs, casque fermé au-dessus, bande bordeaux, protections violettes, sourire entièrement lisible. Aucun cadran ou éclat au repos, aucun corps. Comparer à la référence ; vérifier éclairage, angles, pivots et hitbox.
2. **Base :** attendre 6–9 s actives, observer 0,4 s de charge violette ; déplacer la cible pendant la charge : l’axe doit correspondre à sa position à la fin. Vérifier 10 dégâts via CombatHealth, déviation légère conservant la vitesse, tir manqué/mur, pas de dégâts d’allié.
3. **Niveau 1 :** mur réellement le plus proche, lignes convergentes pendant 2 s et courbure progressive. Toucher ce mur doit toujours retirer **0 PV** à ce niveau.
4. **Niveau 2 :** contact pendant la polarisation, avertissement rouge 0,25 s, répulsion diagonale vers l’intérieur et **12 dégâts une seule fois**. Le mur doit s’éteindre ; répéter le contact avant une nouvelle activation ne redéclenche rien. Tester les quatre murs et les coins.
5. **Niveau 3 :** tic-tac, pause de 1,2 s limitée à ce combat, exactement cinq éclats et cinq axes fixes. Vérifier que la cible bouge avant le départ simultané et puisse éviter les axes. Vérifier trois impacts maximum par cible et activation, donc **18 dégâts maximum**, alliés exclus. Tester un contrôle externe : après son retrait, la fenêtre complète de 0,35 s doit encore être disponible.
6. **États :** suspendre pendant une capture Sym/Fantastic, un transit Plumber, un bonus étoile, un poison/toile Spidey, la fureur/étourdissement Fléau et les invocations Deadly. Vérifier les durées restantes, la restitution des mêmes trajectoires, les autres motifs de pause et l’absence de tick de rattrapage. Tester Triche Lucky et SILENCE Inverted. Tester K.-O., départ, changement de manche et arrêt de Play à chaque phase : aucun modèle ni contrôle temporaire Polari ne doit rester.
7. **MAX :** seulement au résultat décisif déjà choisi et avec niveau MAX. Son d’arène coupé, vrai vaincu figé, orbite caméra, cinq fragments venant des parois, disposition d’horloge, dernier tic, inversion violette/rouge, claquement et trophée **L’ULTIME SECONDE**. Vérifier la restitution caméra/FOV/audio, y compris une préférence de volume modifiée pendant la scène. Tester départ, nouvelle manche, caméra remplacée, spectateur proche, portrait et tablette ; aucune seconde mort, aucun nouveau dégât ou gain.
8. **Progression :** profil ancien intact, possession nécessaire à la sélection, obtention Rare et doublons, quatre achats sauvegardés, niveaux cumulatifs, trophée du livre et équipement après reconnexion. Comparer casino/monnaies, quêtes, téléporteurs, menus et victoires des autres Crax. Vérifier performances mobiles et absence d’accumulation après plusieurs manches.

## Retour arrière

Arrêter Play et exécuter tout [`RETOUR_ARRIERE_POLARICRAX.lua`](../../integration/polaricrax/RETOUR_ARRIERE_POLARICRAX.lua). Les sources exactes antérieures sont restaurées et les éléments marqués Polari sont retirés ; imports originaux et IDs utilisateur restent disponibles. La commande ne modifie pas directement les DataStores.

Une source éditée depuis l’installation n’est pas écrasée : fusionner avec la sauvegarde ou reprendre la copie de place. Retirer Polari avant les lots dont il adapte les sources. Enregistrer puis nouveau Play. La publication de la place est une opération distincte.

Si la version actuelle de la place diffère et qu’un ancrage est refusé, [DIAGNOSTIC_SOURCES_ACTUELLES.lua](../../integration/polaricrax/DIAGNOSTIC_SOURCES_ACTUELLES.lua) exporte en lecture seule les buffers concernés et les noms des templates. Conserver tous les blocs Output entre BEGIN et END pour adapter le raccordement à cette version.
