# Tests réellement exécutés

Environnement : Node.js / luau-web 1.5.1, Python 3, Blender 4.3.2. **Roblox Studio n’a pas été exécuté ici.** Les tests Luau chargent les sources de production et les sources adaptées réelles, avec des services simulés ; ils ne prouvent pas le rendu du moteur ou la réplication réseau.

| Suite SymbiotiCrax | Résultat |
|---|---|
| Compilation | 30 scripts complets : huit nouveaux, 18 adaptés, installation, retrait, branchement et diagnostic audio. |
| Règles pures | 29 assertions : marques par propriétaire/victime, consommation, expiration, seuil d’armure, dépassement, réduction/fin, SILENCE, première intersection continue et déplacement sans dépassement, valeurs confirmées et absence d’IDs fictifs. |
| Runtime réel + `CombatHealth` réel adapté + verrou réel adapté | 35 assertions : morsure unique 16, traction progressive et libération, invalidation, explosion unique 15, soin confirmé 5, protection, SILENCE, réduction d’armure exacte et expiration, absence de sauvetage mortel, dégâts fractionnaires du parasite limités à 9, soin/ralentissement, verrou concurrent, murs, échec, mort du lanceur, soin nul sur parasite bloqué et annulation d’explosion après changement de Crax. |
| Vrais catalogues/casino/trophée | 50 assertions : toutes les entrées antérieures conservées, Épique réel, 125/8/vitesse native, prix Ghosty et achats activés, même ID/titre MAX, durée, poids non Épiques et masse totale par rareté conservés, doublons inchangés. |
| Vraie commande éditeur et retrait | 89 assertions : dépendance absente, source visible différente de la sauvegarde disque, précontrôle sans mutation, erreur d’écriture et restauration, huit sources/18 adaptations, préservation des correctifs indépendants, égalité exacte avec les sources installées compilées, idempotence, refus d’écraser une édition ultérieure, retrait puis réinstallation. Une édition concurrente simulée est préservée et laisse une sauvegarde `Incomplete`, sans restauration aveugle. |
| Vrai client | 19 assertions : rejet de vieux round, langue/réussite/échec, marques, parasite, armure et branchements sonores, un seul Heartbeat de présentation, MAX du vrai gagnant, propriété de caméra, victime entière masquée au bon stade, restitution FOV/visibilité et nettoyage, nouveau round et interruption. |
| Vrai module audio | 10 assertions : attente du chargement, début de plage exact, bornes natives de lecture/boucle, événements simultanés indépendants, pause/reprise, retrait des sons et déconnexion de sa boucle paresseuse. Le moteur sonore lui-même n’est pas simulé : ces tests vérifient la configuration et le cycle de vie. |

| Vrai cadrage des previews | 6 assertions : silhouette complète, conservation des connexions à la réexécution, aucun calcul de cadrage lorsque la vue est fermée, redimensionnement portrait/paysage et déconnexion au retrait. |

Total SymbiotiCrax : **238 assertions**, plus compilation. La commande `npm test` conserve également les suites existantes **InvertedCrax (201)** et **SuperCrax (470)**, soit **909 assertions** au total. Leurs sources de production ne sont pas remplacées par ce lot.

## Ressources vérifiées

- Construction depuis le véritable OBJ fourni. **22 865 sommets natifs comparés, écart maximal 0** ; tête seule, aucune géométrie corporelle. Les crocs sont des déformations additionnelles des dents sources.
- Réimport du FBX accessoires dans une scène Blender vide : **31 meshes + 13 repères**, noms complets, pièces non vides et repères orthogonaux. Le fichier `assets/symbioticrax/model/validation.json` contient les résultats. Cela ne remplace pas un import Studio.
- Vues face, trois quarts, deux profils, dos interprété, bouche entrouverte/ouverte et 128 px rendues depuis les mêmes meshes ; comparaison avec la vraie base et quatre illustrations du livre. La photo originale est consultable dans la conversation, pas incluse dans une comparaison exportée. La fidélité artistique doit encore être approuvée.
- Audio synthétique original, 21 WAV individuels et un atlas de **13,47 s**, PCM mono 16 bits / 44 100 Hz. Débuts/fins correspondent aux frames exactes, 120 ms entre segments, aucun chevauchement, valeurs finies et pic inférieur à 0,47. Aucune voix ou musique de film n’est extraite.
- **Les sons n’ont pas été écoutés ici et ne sont pas publiés dans Roblox.** Une page d’écoute est livrée, ainsi qu’un diagnostic CLIENT de chargement/durée/plages/écoute. Permissions, audibilité, synchronisation réelle, mixage et spectateurs restent à tester.
- Le ZIP est rouvert et contrôlé par CRC et SHA-256 pour chacun de ses fichiers. Une empreinte externe est fournie.

## Vérifications restantes dans Studio

Suivre [INSTALLATION.md](INSTALLATION.md) : import réel et permissions, fidélité/poses/cadrage, gros plan de langue en action, matérialisation de l’armure, tirs/captures près des obstacles, deux clients et spectateurs, sons déclenchés en combat, achats, reconnexion et DataStores, quêtes, trophée équipé, fermeture/réouverture de la place et régression des autres Crax. La caméra MAX utilise une mâchoire issue des vraies pièces dentaires ; sa composition et les sections de langue doivent être vérifiées dans le moteur avant de qualifier la présentation de finale en production.

## Reproduction

```sh
npm ci
npm run build:sym
npm test
npm run package:sym
blender -b --threads 4 --python assets/symbioticrax/model/build_symbioticrax.py
blender -b --threads 4 --python assets/symbioticrax/illustrations/build_illustrations.py
blender -b --threads 4 --python assets/symbioticrax/model/validate_model.py
python3 assets/symbioticrax/audio/generate_audio.py
python3 tools/validate_sym_audio.py
```

L’OBJ original utilisé se trouve dans `assets/supercrax/model/source`, inclus dans le ZIP total. Le modèle conserve la taille de collision de la base ; les nouveaux meshes de langue, enveloppe et tentacules restent purement visuels. Le débruitage OpenImageDenoise est désactivé car indisponible dans le binaire Blender de cet environnement.
