# PolariCrax V3 — plasma magnétique et sons

Cette mise à jour enrichit la présentation de PolariCrax V2. Elle ne modifie pas les pouvoirs, dégâts ou délais. Elle est fournie sous forme de sources et de commande Studio à copier ; les anciennes copies `.rbxl` et la commande de téléchargement GitHub épinglée à la V2 n'intègrent pas cette livraison.

## Ce qui change

| Moment | Présentation V3 |
| --- | --- |
| Charge | Couronnes entrecroisées, graduations de polarité, filaments électriques mobiles et poussière lumineuse ; montée de condensateur. |
| Projectile | Noyau cyan, halo violet, corona de plasma, vapeur et deux traînées complémentaires ; départ sifflant avec basse courte. |
| Impact | Flash local, doubles fronts d'onde qui s'élargissent et disparaissent, gerbe de plasma et éclats ; attaque métallique et résonance grave. |
| Attraction / inversion | Rubans texturés qui parcourent le mur, flux ondulant et vapeur ; passage au rouge lors de l'armement, souffle magnétique en boucle. |
| Temps suspendu | Champ d'horlogerie doré, filaments figés pendant la suspension, cinq projectiles de plasma annoncés et onde de reprise ; tic sec, chute de fréquence et relance. |
| MAX | Champ magnétique orbital autour de la victime et grande onde de convergence ; impacts, fragments et accord de trophée distincts. |

Les trois textures originales `PolariFlux_Flare.png`, `PolariFlux_Spark.png`, `PolariFlux_Smoke.png` sont livrées en PNG RGBA 256 × 256. Sans import, les effets emploient les textures intégrées de Roblox. Les textures personnalisées prennent le relais après branchement de leurs vrais IDs.

Les 19 WAV ont été resynthétisés en couches : transitoire, composante grave, métal/plasma et premières réflexions. La boucle d'attraction est continue. Les durées et plages de l'atlas restent identiques à la V2 : **12,22 s**, PCM16 mono 44,1 kHz. Un ancien ID reste compatible mais jouera les anciens sons tant que le nouvel atlas n'est pas importé et branché.

## Installer dans votre jeu

1. Arrêter Play et enregistrer une copie de votre place.
2. Si PolariCrax V2 est déjà installé, copier **tout** `METTRE_A_JOUR_POLARICRAX_V3.lua` dans la barre de commande de Studio, puis exécuter. Si votre sauvegarde est encore en V1, appliquer d'abord `../v2/METTRE_A_JOUR_POLARICRAX_V2.lua`, puis la V3. Pour une première installation, utiliser `../version-actuelle/INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua` avec les accessoires importés conformément au guide existant ; cet installateur contient directement les modules V3.
3. Importer le **nouveau** `assets/polaricrax/audio/PolariCrax_AUDIO_ATLAS.wav` dans Roblox. Accorder à votre expérience les permissions d'utilisation. Créer ou sélectionner un `Sound` portant le nom `PolariCrax_AUDIO_ATLAS` et son véritable `SoundId`.
4. Facultatif pour utiliser les textures originales : importer les trois PNG. Les placer sur trois `ImageLabel` ou `Decal` nommés `PolariFlux_Flare`, `PolariFlux_Spark`, `PolariFlux_Smoke`, avec leurs vrais IDs.
5. Sélectionner le Sound et/ou ces objets, puis exécuter `../BRANCHER_ASSETS_POLARICRAX.lua`. Il conserve les autres attributs de `ReplicatedStorage.CraxPolariUserAssets`.
6. Enregistrer, puis démarrer un **nouveau Play**. Exécuter `../DIAGNOSTIC_AUDIO_CLIENT.lua` côté client pour écouter les plages et vérifier le chargement de l'atlas.

Écoute hors Roblox : ouvrir `assets/polaricrax/audio/ECOUTER.html`. Aucun audio ni aucune texture n'a été publié automatiquement ; aucun ID fictif n'est installé.

## Installation et performances

La commande V3 ne remplace que `CraxPolariConfig`, `CraxPolariVFX`, `CraxPolariAudio` et `CraxPolariClient`. Seules les quatre sources de présentation à remplacer sont vérifiées contre la sauvegarde avant écriture ; une édition manuelle de ces modules bloque l'opération. Les modifications des autres scripts, dont `CraxDeadlyRuntime`, sont préservées et ne bloquent pas la V3. Leurs entrées de sauvegarde restent inchangées : le désinstallateur complet continuera de refuser une restauration qui écraserait ces modifications. `ServerStorage.PolariCrax_Update_V3_Safety` conserve les versions précédentes. Une erreur d'écriture déclenche une restauration ; une édition concurrente conserve les sources et la sauvegarde de récupération. Les entrées de la sauvegarde principale sont mises à jour pour conserver la compatibilité avec le désinstallateur Polari existant. Réexécuter la V3 ne crée pas de doublons.

Le profil `Auto` réduit la géométrie/les particules sur appareils tactiles. `Quality='Low'` réduit également les effets sur ordinateur. Les effets gardent une seule boucle de présentation ; au plus 16 impacts transitoires, 32 éclats mobiles ou 96 sur ordinateur, et 28 voix audio. Les projectiles disparaissent même si leur paquet de fin manque. Les effets sont sans collision et nettoyés en fin de manche, à la sortie de l'arène et à la destruction du client. Le MAX restaure caméra et mixage après interruption.

## Validation et limites

Tests locaux : `npm test`. Ils exécutent les modules Luau avec services Roblox simulés, y compris mobile, ordinateur, profil Low avec texture personnalisée, impacts multiples, durée de vie, nettoyage, audio spatial, budget de voix, erreurs d'atlas, mise à jour V3, réexécution, erreurs d'écriture et éditions concurrentes. Les PNG et la boucle audio ont aussi des validations binaires.

Ces tests ne prouvent pas le rendu final dans Roblox Studio. Avant publication, vérifier à deux clients : alignement des quatre murs, visibilité des particules/rubans et des cinq tirs, permissions/modération des assets, mixage avec la musique et performances sur un vrai mobile. Les textures personnalisées sont optionnelles ; les sons exigent un atlas autorisé pour l'expérience.

Régénération : `python3 assets/polaricrax/audio/generate_audio.py`, `python3 assets/polaricrax/vfx/generate_textures.py`, `npm run build:polari:v3`, puis `npm run package:polari:v3`. Le générateur V3 préserve les sources et la commande historique V2.
