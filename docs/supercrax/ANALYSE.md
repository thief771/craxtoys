# Analyse des fichiers existants et intégration

## Sources réellement disponibles

Le dépôt `thief771/craxtoys` contient le lot InvertedCrax et ses tests. Le diagnostic exporté de Studio comprend 334 sources, la géométrie et les chemins des templates. Les fichiers fournis comprennent le vrai modèle `base crax sourire.rbxm` et son OBJ. Le cahier des charges joint est conservé dans ce dossier.

Le personnage de base est bien **`ServerStorage.CraxTemplates.Crax_Monster`** (CraxSourire), avec `Head`, `EyeLeft`, `EyeRight`, `UpperGums`, `LowerGums` et les dents. La géométrie OBJ a 48 groupes, dont la croix arrière ; les 24 pièces de visage/tête conservées ont les mêmes sommets que la source. Les quatre vues et le petit aperçu proviennent des meshes exportés. L’écart maximal mesuré des sommets de tête est **0**.

La photo de référence est visible dans la conversation : cheveux noirs coiffés en arrière, boucle frontale, visage clair, grand sourire, version bleue/rouge et écusson. Sa version PNG originale n’est pas présente dans les fichiers locaux : la comparaison exportée met côte à côte **le vrai CraxSourire et SuperCrax**, sans prétendre y inclure la photo. Le visage et les dents restent ceux de la base, les nouvelles pièces sont une adaptation sculptée à la tête seule. La ressemblance finale et la lisibilité en jeu restent à valider par le créateur après import.

L’arène canonique est un plan XY : murs `Arenaleft`, `ArenaRight`, `Arenabottom`, `ArenaTop`, limites internes X = −24…24 et Y = 5…45. Les previews/spectateurs utilisent le système de projection existant `CraxArenaConfigV37`. Les cheveux n’interviennent pas dans le rayon de tête utilisé par le combat.

## Parcours existants réutilisés

| Système inspecté | Raccordement |
|---|---|
| `CraxCatalog`, `CraxTemplates`, `CraxPreviews`, `CraxSkinServer` | Identifiant unique `Crax_Super`, template cloné de la vraie base et mêmes accessoires pour tous les rendus. |
| `PlayerInventory` | `Owned` et `SkillLevels` sont des tables indexées par identifiant ; sérialisation générique conservée, aucun reset ni nouveau DataStore. Personnages de départ inchangés. |
| `StarterGui.InventoryGui.InventoryClient` | Liste réellement possédée, catalogue, effets et preview génériques. Aucun remplacement de son interface. |
| Sélection et configuration d’arène | Catalogue et niveau existants ; le skin serveur applique les accessoires à l’instance jouable. Pas de chemin parallèle d’équipement. |
| `CraxSkillServer`, `CraxSkillResolver` | Propriété et achat serveur existants ; quatre niveaux ajoutés au catalogue. Les prix sont lus depuis CraxSourire. |
| `CopEmClient`, `CraxBookCinema` | Sceaux spécifiques Super et médaillon MAX ; images importables ou labels de secours, aucun emprunt d’illustration Inverted. |
| `CraxRouletteConfig`, `CraxRouletteServer` | Pool Commun réel ; tirage, attribution, doublons et sauvegarde existants. Pas de RemoteEvent client donnant le personnage. |
| `ArenaMovement`, `CraxDeadlyRuntime`, `FleauRuntime` | Simulation existante, vitesse du porteur en modificateur réversible ; aucun second moteur de déplacement. |
| `CombatHealth`, `BiteHit`, `CraxHeal` | Pipeline de dégâts actuel, confirmations réelles, dégâts fractionnaires laser, sauvetage avant mort, cause kryptonite validée avant résultat normal du round. |
| `CraxAbilityGate`, `CraxPositionLock`, `CraxSilenceGate` | Pauses, gel à raison propre, SILENCE aux déclenchements. Le dégel ne libère pas un verrou Fantastic encore actif. |
| `RoundManager`, `CraxVictoryCatalog`, `CraxAbilityClock` | Publication du vrai gagnant/niveau/match avant déclencheur ; scène locale dédiée Super au MAX, durée 8,2 s. |
| Quêtes et récompenses génériques | Événements de combat, obtention, achat et résultat existants ; aucune récompense ou attribution doublée. Validation des compteurs réels encore à faire en Studio. |

## Préservation des versions actuelles

Les fichiers exportés servent à analyser et tester les raccordements, pas à restaurer leurs versions dans Studio. L’installateur applique des ajouts et substitutions **sur le texte Source présent à l’exécution**. Les points d’ancrage doivent être uniques ; les versions supportées avec/sans le lot Inverted sont testées. Une version inconnue provoque un arrêt avant toute écriture.

Cela conserve notamment les correctifs Killa/Ghosty/Inverted situés hors des raccordements. Les tests injectent un commentaire de correctif indépendant dans chaque source et vérifient sa conservation à l’installation et sa restauration exacte au retrait. Cela ne prouve pas qu’une réécriture future et arbitraire de ces fonctions serait compatible : elle sera refusée si les ancrages changent.

Le dossier `integration/supercrax/review` contient les 14 résultats complets pour revue ; `operations.json` décrit les opérations. Les cinq nouvelles sources sont dans `src/supercrax`. Les autres interfaces et fichiers Inverted ne sont pas modifiés par ce lot.

Les sources de catalogue sont chargées via le cache normal Roblox : après installation ou branchement d’assets, il faut **enregistrer et lancer un nouveau Play**.
