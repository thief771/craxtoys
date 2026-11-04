# Analyse de l’existant

Le ZIP fourni contient un cahier Markdown et une photo JPEG. Le cahier sert de spécification à cette demande ; ses propositions de réglages restent des prototypes. Il ne contient ni scripts du jeu actuel ni modèle Roblox supplémentaire.

Le dépôt contient le diagnostic de la place, les raccordements InvertedCrax, SuperCrax et SymbiotiCrax, les scripts serveur/client correspondants et le véritable OBJ CraxSourire fourni précédemment. L’analyse utilise les versions intégrées SymbiotiCrax, puis InvertedCrax, puis le diagnostic pour les autres scripts. Les 26 sources de référence utiles sont figées dans `tests/fixtures/lucky-inspected-sources.json` ; elles servent aux tests, jamais à écraser la place actuelle.

| Système existant | Raccordement LuckyCrax |
|---|---|
| `CraxCatalog`, templates et previews | `Crax_Lucky`, Rare, 105 PV, contact 8, vitesse du CraxSourire |
| `ArenaMovement`, `BiteHit`, `CombatHealth` | simulation serveur existante, dégâts confirmés et soins réels |
| `CraxSkillCatalog`, `CopEmClient`, `CraxBookCinema` | quatre niveaux cumulatifs, mêmes illustrations dans icône et description, identifiant de trophée stable |
| `CraxRouletteConfig` | ajout à la masse Rare existante, redistribution égale explicitement provisoire |
| possession, sélection, profil et achats génériques | réutilisation des catalogues ; aucun remplacement de DataStore ou don automatique |
| `CraxSilenceGate`, `CraxAbilityGate`, pauses cinématiques | deux blocages indépendants, temps actif, respect des phases de combat |
| runtimes Super/Inverted/Sym/Deadly et familles historiques | annulation des pouvoirs avant blocage, restauration par simulation normale sans anciennes copies d’attributs |
| `ArenaCamera`, victoire de round | propriété temporaire de caméra Lucky, scène MAX cosmétique de neuf secondes |

Le modèle jouable utilise une copie du vrai `ServerStorage.CraxTemplates.Crax_Monster` et sa mâchoire native. Les vrais noms inspectés comprennent `UpperGums`, `LowerGums`, `UpperShell`, `LowerShell`, `EyeLeft`, `EyeRight` et les deux rangées `Tooth_0_*` / `Tooth_1_*`. Le FBX complet sert à la revue artistique ; seul le FBX des accessoires VFX doit être importé pour l’installation.

La photo montre une tête blanche, des yeux noirs en sourire et des dents dorées séparées. L’OBJ original conserve ses 48 groupes et ses 22 865 sommets, sans corps. Les petits motifs latéraux de la photo sont insuffisamment lisibles pour les reproduire fidèlement ; ils n’ont pas été remplacés par des marques inventées. La croix arrière native est conservée.

**Absence réelle :** aucune source BlackSpida n’a été trouvée dans le dépôt ou les diagnostics disponibles. La Triche refuse une famille inconnue et affiche la raison ; ce refus n’est pas une intégration BlackSpida. Un exporteur en lecture seule est fourni pour récupérer les sources actuelles nécessaires. La compatibilité de toutes les familles demandée par le cahier reste donc ouverte.
