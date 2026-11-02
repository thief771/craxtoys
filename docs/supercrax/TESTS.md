# Vérifications exécutées

Environnement : Node.js 24 / luau-web 1.5.1, Python 3 et Blender 4.3.2. Date : 2 novembre 2026. **Roblox Studio n’a pas été exécuté.**

## Luau et intégration

`npm test` conserve les tests Inverted et exécute les nouveaux tests Super. Les tests chargent les sources de production, sans recopier les règles dans les assertions. Les services Roblox sont simulés : ces résultats prouvent les calculs et chemins exécutés dans ce banc, pas le comportement réseau ou le rendu du moteur Roblox.

| Suite Super | Résultat |
|---|---|
| Compilation | 22 scripts complets : cinq nouveaux, quatorze adaptés, installation, retrait et branchement des assets. |
| Règles pures | 49 assertions : ordonnanceur, bornes, délais, union d’exposition, limite laser, conditions de sauvetage, trois tours et absence de starvation. |
| Runtime serveur réel + verrou de position réel adapté | 213 assertions : calcul laser 37,5, deux tirages de directions, 3 × 16, bornes des cercles, acier borné, charge mobile, gel/expiration/brisure unique, kryptonite et verrou concurrent. |
| Vrai `CombatHealth` adapté + runtime réel | 18 assertions : conservation des dégâts fractionnaires, sauvetage avant fin du round, soins bloqués à 1 PV, SILENCE, contact/recul ordinaire conservés, vrai déclenchement du souffle, vrai remplacement 35, preuve kryptonite invalide refusée, mort normale et retrait du bonus. |
| Vrais catalogues / roulette | 50 assertions : toutes les entrées antérieures conservées, stats et vitesse natives, quatre prix confirmés, pas de nouveau trophée, masse par rareté et compensations inchangées, MAX niveau/durée. |
| Vraie commande installation / retrait, avec Inverted | 59 assertions : conflits, source non supportée, MeshId absent, erreur d’écriture injectée, restauration transactionnelle, conservation de correctifs indépendants dans les 14 sources, réexécution, refus d’écraser une édition ultérieure, retrait exact puis réinstallation. |
| Même commande sur les sources de base sans Inverted | 59 assertions équivalentes ; variantes d’ancrage vérifiées. |
| Vrai client VFX / MAX | 22 assertions : rejet d’ancien round, acier/restauration, lasers, nettoyage de trois souffles et leurs guides, gel/dégel, cristal/porteur, un seul Heartbeat, scène MAX, victime entière masquée après tir, durée annoncée, restitution caméra/transparences et déconnexion à destruction. |

Total Super : **470 assertions** réussies, plus la compilation. Les anciens tests Inverted restent exécutés sans remplacer leurs sources.

## Ressources

- Construction Blender à partir du vrai OBJ fourni, hash source dans `validation-model.json`. Conservation des sommets des 24 pièces natives : écart maximal **0**. Aucun corps. 15 nouveaux meshes, 24 524 triangles accessoires.
- Réimport du FBX accessoires dans une scène Blender vide : **18 meshes** non vides, dont trois repères ; noms requis et orthogonalité vérifiés (`validation-fbx.json`). Ce n’est pas un test de l’importateur Studio.
- Vues face/profil/dos/trois quarts, comparaison base/Super et aperçu 128 px examinés visuellement. Les cheveux, la boucle, le sourire et le S sont présents. À petite taille l’écusson reste petit, à vérifier dans les vraies cartes. La photo d’origine n’existe pas comme fichier local à incorporer à la comparaison.
- Quatre illustrations de capacités rendues depuis le même `.blend`, source livrée. Ce sont des illustrations, leurs VFX ne prouvent pas le rendu client en jeu.
- 19 fichiers WAV originaux : PCM mono 16 bits, 44 100 Hz, nombre de frames/durée et échantillons finis contrôlés, pic ≤ 0,48. Charge MAX : 1,5 s. **Pas d’écoute, publication, contrôle des permissions Roblox ou test de mixage ici.**
- Le ZIP est rouvert, chaque CRC et chaque SHA-256 interne est vérifié par le générateur ; empreinte externe livrée.

## Vérifications restantes

Suivre la liste de [INSTALLATION.md](INSTALLATION.md) : import sous le propriétaire réel, sons/images autorisés, obtention/casino/doublons, achats et sauvegarde/reconnexion, deux clients, interactions de protections, mobile/tablette, sons/musique, spectateurs/caméras, interruption et régression des autres Crax. Les simulations ne permettent pas d’annoncer ces parcours validés dans Studio.

## Reproduire

```sh
npm ci
npm run build:super
npm test
npm run package:super
blender -b --threads 4 --python assets/supercrax/model/validate_fbx.py
```

Reconstruction complète du modèle et des ressources :

```sh
blender -b --threads 4 --python assets/supercrax/model/build_supercrax.py -- assets/supercrax/model/source/CraxSourire_original.obj assets/supercrax/model
blender -b --threads 4 --python assets/supercrax/illustrations/build_illustrations.py
python3 assets/supercrax/audio/generate_super_sfx.py
```

Les renders Cycles de ce build Blender n’utilisent pas le débruitage OpenImageDenoise, indisponible dans son binaire. Les exports sont de vrais meshes, pas des captures composées.
