# État réel et validation

Les sources, modèle, ressources, installation réversible et tests sont livrés dans ce dépôt. Les essais du moteur Roblox et l’import des assets n’ont pas été effectués ici : ce lot est prêt à être essayé dans une copie de la place, sans promesse de validation en production.

## Ce qui a été exécuté localement

| Vérification | Résultat et portée |
|---|---|
| Compilation Luau | sources complètes Polari, vingt adaptations et commandes compilées avec `luau-web` |
| Vrai serveur et vrai CombatHealth adapté | 51 assertions : cadence comprenant la charge, puis ciblage actualisé, dégâts10/déviation, attraction sans dégâts, inversion12 unique, arrêt1,2, verrou imbriqué conservé, fenêtre réellement jouable, cinq axes fixes, plafond de 18 dégâts même après amplification, autre victime indépendante, allié ignoré, interruption/Triche/départ, absence de spam hors combat |
| Vrais adaptateurs de pause | 24 assertions sur leurs fonctions extraites des sources adaptées : bonus, transit conservé, poison/toile, fureur, contrôle externe, Ghosty et Deadly ; échéances prolongées, mêmes objets de capture et vitesses, aucun retrait d’un verrou étranger |
| Vrais catalogues | 59 assertions : anciens personnages conservés, Rare110/mêlée7, prix et identifiant/titre MAX cohérents, masse Rare et poids des autres raretés préservés |
| Commande éditeur et retrait | 99 assertions : lecture du buffer visible plutôt que Source périmé, précontrôles sans mutation et état interne inconnu refusé, rollback, vingt-neuf entrées sauvegardées, répétition sans doublons, retrait et réinstallation, refus de conflit, correction humaine concurrente conservée |
| Vrai client de présentation | 31 assertions sur services simulés : événements périmés rejetés, étincelle violette d’anticipation, projectile et mur retirés, cinq éclats, reprise avant tir, propriété caméra MAX, coupure des sons du combat, volume utilisateur changé puis restitué, effet musical temporaire retiré, originaux visibles et toutes connexions nettoyées sur fin/interruption |
| Lecture audio | dix assertions sur le vrai lecteur : attente du chargement, régions natives, lectures indépendantes, boucle bornée, pause/reprise/arrêt/nettoyage |
| Fichiers audio | dix-neuf WAV originaux, PCM16 mono44 100, segments exactement identiques à l’atlas de 12,22 s, crête <0,47, aucun ID Roblox publié ; écoute humaine et autorisations non vérifiées |
| Modèle Blender | SHA256 de l’OBJ source, 48 groupes et 22 865 sommets conservés, seize meshes FBX relus, casque fermé au-dessus, cadran/éclats exclus du repos, direction de l’éclat corrigée et vérifiée ; 350 points visibles des yeux et 2 864 des dents sans occultation par le casque |
| Régressions sur le montage actuel | suites serveur Super/Sym/Lucky relancées contre le CombatHealth adapté Polari et leurs vrais runtimes ; anciennes suites conservées dans `npm test` |
| Livrable | ZIP avec CRC et SHA256 de chaque fichier, somme de l’archive séparée |

Le client utilise des objets graphiques simulés : ce test prouve ses décisions, le protocole et le nettoyage, pas la qualité du rendu ou de la réplication dans Roblox. Les adaptateurs de pause sont testés sur leurs vraies fonctions avec des états représentatifs ; les combinaisons de toutes les familles doivent encore être exercées dans le moteur. Le contrôle géométrique des yeux/sourire est effectué dans Blender, séparément de ces doubles Roblox.

## Reproduire les contrôles

```sh
npm ci
npm run build:polari
npm test
blender -b -t 4 --python tools/validate_polari_model.py
npm run package:polari
```

Pour reconstruire les ressources :

```sh
blender -b -t 4 --python assets/polaricrax/model/build_polaricrax.py -- --assets-only
blender -b -t 4 --python assets/polaricrax/model/render_views.py
blender -b -t 4 --python assets/polaricrax/model/render_illustrations.py
python3 assets/polaricrax/audio/generate_audio.py
npm run build:polari
```

Les réglages non spécifiés sont explicitement provisoires dans [ANALYSE_ET_CHOIX.md](ANALYSE_ET_CHOIX.md) et `CraxPolariConfig`. Les étapes d’import, tests deux clients/mobile, sauvegarde/achats et retour arrière sont dans [INSTALLATION.md](INSTALLATION.md). Aucun asset Roblox ni place n’a été publié depuis cet environnement ; seuls les fichiers et le code sont livrés.
