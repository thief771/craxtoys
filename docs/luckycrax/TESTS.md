# Vérifications locales et vérifications restantes

Environnement : Node 24, `luau-web` 1.5.1, Python 3, Blender 4.3.2. Les tests exécutent les sources Luau de production avec des services Roblox simulés. Ils ne simulent pas le moteur de rendu, les permissions d’assets, les DataStores ou la réplication réseau réelle.

## Commandes reproductibles

```sh
npm ci
npm run build:lucky
npm test
blender -b -t 4 --python tools/validate_lucky_model.py
npm run package:lucky
```

Pour reconstruire les ressources :

```sh
blender -b -t 4 --python assets/luckycrax/model/build_luckycrax.py
blender -b -t 4 --python assets/luckycrax/model/render_illustrations.py
python3 assets/luckycrax/audio/generate_audio.py
npm run build:lucky
```

Le générateur d’intégration utilise la fixture fournie et ne nécessite pas le diagnostic externe original tant que la liste de scripts ne change pas.

## Résultats couverts

| Contrôle | Vérification réelle |
|---|---|
| Compilation | toutes les sources Lucky complètes, commandes et adaptations `review` compilées en Luau |
| Règles/autorité/santé | 78 assertions : 36 couples de dés, 100 000 tirages pondérés, sérialisation, sweep et coin de mur, Pile 12/Face 16, troisième coup subi, esquive unique, laser continu et troisième attaque subie jusqu’au dernier tick, collision réciproque, double, soin plafonné/+15/PV MAX, six pièces max30, expiration et deux sources de Triche indépendantes |
| Catalogues | 56 assertions : anciens personnages conservés, Rare105/mêlée8, grille Rare, trophée cohérent, masse Rare totale et autres raretés préservées |
| Commande éditeur | 121 assertions : buffer visible plus récent que Source, précontrôle sans mutation, erreur d’écriture et rollback, 36 entrées de sauvegarde, répétition, retrait, réinstallation, refus d’édition ultérieure, conservation d’une correction concurrente |
| Client | 25 assertions : rejet ancien round, pièces/dés, trois fenêtres, résultat imposé serveur, trèfle consommé, rafale conservée, +15/PV MAX, MAX, départ du siège, restauration caméra/FOV/originaux et déconnexion des événements |
| Audio | dix assertions de cycle lecture/chargement/régions/boucle/pause/arrêt ; WAV individuels identiques aux plages de l’atlas, PCM16 mono44 100, crête <0,47, 25 cues, durée16,24, ID publié vide |
| Familles adaptées | suites Super/Inverted/Sym relancées avec les vrais runtimes de `review` Lucky ; annulation réelle dash/acier/sauvetage consommé, strict1PV conservé, capture/armure/charge passive Sym annulées, MUTE propre annulé ; aucune compatibilité BlackSpida prétendue |
| Modèle | fichier source vérifié par SHA256, coordonnées des 22 865 sommets des 48 groupes comparées à l’original, 32 meshes relus depuis le FBX exporté, six chiffres face caméra et à l’endroit après transformation des repères, opposés1/6 2/5 3/4, quatre feuilles distinctes, aucun corps |
| Illustrations | quatre PNG RGBA640 avec alpha0–255 et contenu entier à l’intérieur du canevas ; vues LuckyJackpot/MAX et bibliothèque FX inspectées |
| Archive | CRC de chaque entrée et SHA256 de chaque fichier, somme de l’archive séparée |

Les anciennes suites Inverted/Super/Sym sont également exécutées par `npm test`. Une suite ancienne seule ne valide pas le montage Lucky : c’est la raison de la suite supplémentaire sur les runtimes adaptés.

## Limites des preuves

Le client utilise des modèles/systèmes graphiques simulés : le test prouve ses décisions et son nettoyage, pas le rendu des meshes, des glyphes, du reflet ou du coffre sur un appareil. La validation d’orientation du dé effectue séparément les transformations 3D Blender réelles. Les WAV ne sont pas audités à l’oreille ici. Le cas négatif BlackSpida prouve un refus explicite d’une famille inconnue, **pas une annulation de ses pouvoirs**.

À effectuer dans Studio : import et autorisations des 32 meshes, atlas et PNG ; tests deux clients et spectateurs, portrait/mobile/tablette ; cadrage, HP et rouleaux, pauses, coffre, collisions et bouche ; tous les achats/possessions/trophées/DataStores ; annulations de chaque famille et alliés ; BlackSpida après accès à ses sources ; performances et absence d’objets résiduels sur plusieurs rounds. La grille détaillée est dans [INSTALLATION.md](INSTALLATION.md).
