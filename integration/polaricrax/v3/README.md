# Nouvelle fin MAX — exécution magnétique, puis éclatement de l’adversaire

**Play arrêté**, copier tout `REFAIRE_FIN_POLARICRAX.lua` dans la barre de commande de Studio. Enregistrer, puis lancer un nouveau Play et gagner avec PolariCrax au niveau MAX. Ce correctif (révision 5) met à jour uniquement le client Polari et ses VFX ; il conserve le volume réglé dans votre jeu, l'ID audio et les scripts des autres personnages. Il s'applique à une V3 ou à la révision audio 4 et se réexécute sans doublons. Après installation, ne pas réappliquer les anciennes commandes de révision 3/4.

**Aucun trophée n'apparaît et aucun son de révélation de trophée n'est joué.** L'adversaire se brise visuellement en fragments. Les récompenses et le résultat du combat restent ceux du serveur existant.

| Temps | Action visible |
| --- | --- |
| 0–1,2 s | Plan sur PolariCrax, ouverture progressive du cadre vers l'adversaire. |
| 0,65–2,4 s | L'adversaire est soulevé dans le champ magnétique. |
| 1,1–3,2 s | Exactement cinq éclats de plasma se placent en spirale autour de lui. |
| 3,2–4,2 s | Les axes se verrouillent ; lumière dorée et dernier tic. |
| 4,2–4,85 s | Arrêt net de l'orbite, des particules et de la lévitation. |
| 4,85–5,2 s | Les cinq éclats convergent simultanément. |
| 5,2 s | Impact, ondes de choc et remplacement de la silhouette par des fragments colorés. |
| 5,2–7,4 s | Dispersion des fragments, chute et disparition progressive. |
| 6,7–9 s | Retour sur le vainqueur, puis restitution douce de la caméra du jeu. |

Les personnages montrés sont des copies locales. Le registre des corps visuels détachés est utilisé lorsqu'il existe ; les originaux sont masqués temporairement puis restaurés. Le décor sombre est placé devant l'arène pour garder l'action lisible. Le cadrage tient compte de la taille des têtes et du format de l'écran. Les éclats de l'adversaire sont des fragments procéduraux reprenant ses couleurs, et non une découpe dynamique exacte du maillage Roblox. Les volumes des sons ne sont pas augmentés par cette mise à jour.

Tests locaux : séquence avant/après impact, absence de trophée, cinq projectiles, fragments mobiles/ordinateur, positions numériques, orientations verticales, caméra, snapshots détachés, restauration après interruption, conflits d'installation et conservation des réglages audio. **Le rendu final et le timing perçu doivent encore être vérifiés dans Roblox Studio**, idéalement à deux clients et sur mobile. Aucun test local ne garantit une animation sans défaut dans une place personnalisée.

Génération : `python3 tools/build_polari_finale.py`, tests : `npm run test:polari`, livraison : `npm run package:polari:v3`.

---

## Correctif : aucun son en combat après redémarrage

**Play arrêté**, copier tout `CORRIGER_AUDIO_POLARICRAX.lua` dans la barre de commande en mode édition. Il met à jour uniquement le module audio et le client Polari, et enregistre l'ID audio fourni `126174551693820` dans `ReplicatedStorage.CraxPolariUserAssets`. Enregistrer ensuite la place, puis lancer un nouveau Play et un combat. Le correctif exige une V3 installée, préserve les éditions des autres personnages et refuse d'écraser des modifications des deux modules remplacés.

Le chargement reçoit maintenant un objet Sound pour éviter l'ambiguïté de type d'asset. L'ID est relu lors des événements audio pour supporter une configuration répliquée après le chargement du module. Pour les joueurs assis dans l'arène, le mixage est local et n'est plus atténué par la distance entre la caméra et l'arène logique ; les spectateurs conservent le son spatial. Ces corrections sont testées localement, mais l'audibilité pendant votre combat reste à vérifier dans Studio.

Après ce correctif (révision 4), ne pas réappliquer l'ancienne commande V3 (révision 3). Réexécuter le correctif audio est sans doublons. Régénération de l'ensemble : `python3 tools/build_polari_audio_fix.py`, puis `npm run package:polari:v3`.

---

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
| MAX | Exécution magnétique suivie d'une fragmentation de l'adversaire ; aucun trophée affiché. Voir la nouvelle commande en tête de ce guide. |

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
