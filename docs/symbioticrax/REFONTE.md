# Refonte de présentation — 3 novembre 2026

Cette révision reprend les références fournies : matière noire brillante, filaments organiques recourbés, visage asymétrique, crocs plus nombreux et langue rose. La tête native CraxSourire reste conservée, sans corps ajouté.

## Contamination

Les anciens points sont remplacés par une enveloppe locale sur l’hémisphère avant de la tête : un tiers au premier coup, deux tiers au deuxième, trois tiers lors de l’explosion. La matière pulse et de petits filaments bougent. La propagation de chaque stade prend 0,24 s. Le troisième coup consomme toujours les marques et déclenche les mêmes dégâts serveur ; le client garde la couverture complète 0,65 s, puis la supprime. Il ne s’agit pas d’un quatrième état de gameplay.

Les secteurs suivent le repère et les dimensions de `Head`. Ils utilisent une surface ellipsoïdale approchée : les yeux et dents saillants peuvent encore dépasser, et les variantes de tête doivent être contrôlées dans Studio. Les pièces sont locales, ancrées, sans collision, sans touch/query. La qualité mobile réduit les subdivisions. Expiration, mort, fin de round et suppression du propriétaire nettoient les effets.

## Langue et MAX

La langue animée comporte 32 sections sur mobile, 56 en qualité standard, un sillon sombre, un relief pulsé et un enroulement de plus d’un tour autour de la cible pendant la traction. Le centre de la cible et sa taille déterminent l’enroulement ; les positions et dégâts restent décidés par le serveur. Le MAX utilise 36/64 sections, une capture dimensionnée à la victime, des fils humides entre les mâchoires, des sons de préparation/fermeture et une légère impulsion de caméra à l’impact. Les contrôles de restitution de caméra existants restent actifs.

## Modèle et son

La moitié transformée possède deux crocs étroits par racine dentaire d’origine. Les noms des 31 accessoires et des 13 repères restent compatibles avec l’installateur. Les matériaux Blender ajoutent microrelief et reflet de surface ; les nervures plus larges et le relief de langue sont aussi géométriques. Les nœuds de matériau Blender ne sont pas une texture PBR Roblox : l’apparence Studio utilise les meshes importés, leur couleur et SmoothPlastic. Un éclairage Studio adapté reste nécessaire pour juger le résultat.

Quatorze sons ont été resynthétisés avec des couches humides, adhésives ou graves selon l’action. L’atlas conserve ses 21 plages et sa durée de 13,47 s. Il faut réimporter le nouveau WAV et brancher son véritable ID. Les fichiers n’ont pas été écoutés dans cet environnement ; le diagnostic client et la page ECOUTER.html permettent de contrôler le mixage.

## Mise à jour d’une installation existante

1. Arrêter Play et enregistrer une copie de la place. Garder les IDs d’assets actuellement utilisés.
2. Exécuter le `RETOUR_ARRIERE_SYMBIOTICRAX.lua` de l’installation existante. Il refuse de retirer des sources modifiées depuis l’installation : en cas de conflit, conserver ces modifications et comparer les sources au lieu de forcer le retrait.
3. Importer le nouveau FBX accessoires, sélectionner sa racine et exécuter le nouvel `INSTALLER_SYMBIOTICRAX.lua`. Réexécuter simplement l’installateur sur une V1 existante ne la met pas à jour : sa garde d’idempotence retourne sans changement.
4. Importer et autoriser le nouvel atlas audio et les illustrations régénérées, puis utiliser `BRANCHER_ASSETS_SYMBIOTICRAX.lua` avec les nouveaux IDs. Enregistrer, fermer/rouvrir et lancer un nouveau Play.
5. Tester les trois stades à deux joueurs, différentes orientations et tailles de tête, expiration, mort, murs, traction, interruption du MAX, retour caméra et sons côté spectateur. Vérifier le coût sur un appareil mobile.

## Validation locale

`npm test` vérifie les trois personnages ; la suite client SymbiotiCrax contient 30 assertions, dont couverture 1/3 → 2/3 → 3/3, présence de filaments, consommation visuelle temporaire et nettoyage. Les services Roblox restent simulés. `tools/validate_sym_audio.py` contrôle les formats et les plages. Le modèle doit passer `validate_model.py` après reconstruction, et le ZIP est vérifié par CRC et SHA-256.

Aucun import, rendu en jeu, test réseau ou test d’écoute Roblox Studio n’a été exécuté ici. Les rendus Blender montrent les ressources exportées, pas une capture du moteur Roblox.
