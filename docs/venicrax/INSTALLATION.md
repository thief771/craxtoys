# VeniCrax — installation dans Roblox Studio

Place de base : **copie jeu mardi** (SHA-256 `9bb61b5e…a8ed35d257849cc075343c7ac79881fd3529344a8487`), avec PolariCrax et l'équilibrage du 7 novembre déjà installés.
Travailler sur **une copie** de la place. Toutes les commandes se lancent **Play arrêté**, dans la **barre de commande** (Affichage → Barre de commande).

## 1. Importer le modèle (une fois)

1. **Avatar → Import 3D**, choisir `assets/venicrax/model/VeniCrax_ACCESSOIRES_IMPORT.fbx`.
2. Dans l'Explorateur, déplacer le modèle importé dans **ServerStorage** et le renommer **`VeniCrax_Import`**.
   Il doit contenir 11 MeshPart : `V_HelmetShell`, `V_HelmetInner`, `V_HelmetCrest`, `V_HelmetBrow`, `V_VenomVeins`, `V_Fangs`, `V_FangsCore`, `V_VenomDrops`, `V_FitOrigin`, `V_FitUp`, `V_FitFront`.

## 2. Installer

Copier tout le contenu de `integration/venicrax/INSTALLER_VENICRAX.lua` dans la barre de commande, Entrée.
Message attendu : `VeniCrax installé : 7 modules, 12 raccordements…`. Si une vérification échoue, **rien n'est modifié** et le message dit pourquoi.

Ce que fait la commande :
- crée `CraxVeniConfig`, `CraxVeniRules`, `CraxVeniAppearance`, `CraxVeniAudio`, `CraxVeniAudioMap` (ReplicatedStorage), `CraxVeniRuntime` (ServerScriptService), `CraxVeniClient` (StarterPlayerScripts), l'événement `CraxVeniFX` ;
- crée le gabarit `ServerStorage.CraxTemplates.Crax_Veni` et l'aperçu `ReplicatedStorage.CraxPreviews.Crax_Veni` ;
- ajoute VeniCrax aux catalogues (Épique, 100 PV, mêlée 5), au livre, aux trophées et au casino (masse Épique inchangée, partagée à égalité) ;
- raccorde `ArenaMovement`, `CombatHealth`, `RoundManager`, `ArenaCamera`, `CopEmClient`, `CraxBookCinema` ;
- garde une sauvegarde exacte dans `ServerStorage.VeniCrax_Backup_V1`.

**Enregistrer** la place.

## 3. Sons, texture du casque, icônes

1. Importer comme ressources Roblox (Gestionnaire de ressources ou Creator Hub) :
   - `assets/venicrax/audio/VeniCrax_Audio_Atlas.wav` (son) — 21 sons dans un seul fichier de 21,96 s ;
   - `assets/venicrax/model/VeniCrax_Helmet_Color.png` et `VeniCrax_Helmet_Normal.png` (images).
2. Ouvrir `integration/venicrax/BRANCHER_SONS_ET_TEXTURES.lua`, remplacer les `0` par les IDs, coller dans la barre de commande.
3. **Enregistrer**, puis lancer un **nouveau Play**.

On peut écouter les sons avant import : `assets/venicrax/audio/ECOUTER.html`.

## 4. Vérifications en jeu (deux clients)

| Quoi | Attendu |
| --- | --- |
| Sélection | VeniCrax visible et sélectionnable une fois possédé (donner-le avec l'outil admin habituel). |
| Base · Morsure lente | Losanges verts au-dessus de la cible à chaque collision ; à la 3ᵉ, brume verte et −2 PV par seconde pendant 5 s (10). |
| N1 · Cobra Ricochet | Un cobra vert part vers un mur, rebondit (éclaboussure), mord : −5 puis −3/s pendant 3 s. |
| N2 · Distillation | Après 5 pertes de poison, trois orbes tournent autour de VeniCrax ; au prochain rebond mural : +8 PV, gerbe verte et dorée. Recharge 15 s. |
| N3 · Mue toxique | Une mue translucide reste sur place ; au contact ennemi, cercle qui grandit, nuage toxique 0,7 s après ; la cible est empoisonnée. |
| MAX | Victoire **par poison** au niveau 4 : cobra craché, ricochet, deux tours autour de la tête, pause, resserrement, fissures vertes, éclatement en morceaux de vinyle, titre **ÉTREINTE DU COBRA**. Une victoire sans poison donne la victoire normale. |
| Nettoyage | K.-O., abandon, nouvelle manche : plus aucun cobra, brume, mue ou cercle à l'écran. |

Dans Output, aucune erreur `CraxVeni…` côté Serveur ni Client.

## Retour arrière

`integration/venicrax/RETOUR_ARRIERE_VENICRAX.lua`, Play arrêté : restaure exactement les 12 sources d'origine et retire tout ce que VeniCrax a créé. Refuse d'agir si une de ces sources a été modifiée depuis l'installation.

## Réglages

Toutes les valeurs sont dans `CraxVeniConfig` (ReplicatedStorage). Celles de la fiche validée : Morsure lente 3 contacts / 2 PV/s / 5 s ; Cobra 5 + 3 PV/s / 3 s. Propositions modifiables : Distillation (5 pertes, +8, 15 s), délais du cobra (7–10 s) et de la mue (14–18 s), nuage de 4,8 de rayon, titre MAX.
