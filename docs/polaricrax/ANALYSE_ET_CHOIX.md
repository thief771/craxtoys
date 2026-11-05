# PolariCrax — analyse et choix d’intégration

La base inspectée est la version du dépôt comprenant InvertedCrax, SuperCrax, SymbiotiCrax et LuckyCrax. La place n’est pas accessible en exécution Roblox depuis cet environnement. Les vingt sources utiles sont conservées dans `tests/fixtures/polari-inspected-sources.json` pour rendre les tests reproductibles ; l’installateur adapte les buffers réels de l’éditeur et ne remet pas ces anciennes copies à leur place.

Les points d’entrée réutilisés sont `CraxCatalog`, `CraxSkillCatalog`, `CraxVictoryCatalog`, `CraxEffectsCatalog`, `CraxRouletteConfig`, `CraxSkinServer`, `ArenaMovement`, `BiteHit`, `CombatHealth`, `CraxAbilityGate`, `CraxSkillResolver`, `CraxAbilityClock`, `RoundManager`, `ArenaCamera`, `CopEmClient` et `CraxBookCinema`. Inventaire, possession, sélection et achats restent gérés par leurs chemins génériques existants. Les menus hors livre ne sont pas réécrits.

## Personnage et modèle

Identifiant : `Crax_Polari`, nom **PolariCrax**, Rare, 110 PV, mêlée ordinaire 7, vitesse reprise de CraxSourire. Le modèle provient du véritable OBJ CraxSourire fourni précédemment : ses 48 groupes et 22 865 sommets sont conservés. Les yeux sont les deux arcs noirs natifs, le sourire conserve ses deux rangées, avec dents ivoire et gencives roses.

La référence principale est l’image du casque rouge brillant jointe au message du 5 novembre 2026. La tête seule reçoit une coque rouge fermée sur le dessus, une bande bordeaux, un front en M violet et deux protections de joue. Le dos est une continuation interprétée de cette coque : la référence ne montre que l’avant. Le modèle de repos ne porte ni cadran ni éclat. Les cinq pièces de casque et les huit ressources/repères transitoires sont séparés dans le FBX, avec trois repères d’ajustement du casque, soit seize meshes au total.

Les surfaces et les matières sont réellement modélisées. Les rendus sont ceux des meshes livrés, pas des captures du moteur Roblox. La fidélité artistique finale et l’éclairage en jeu doivent être approuvés dans Studio. Les protections ont été ajustées après un contrôle de visibilité : aucun des 350 points visibles échantillonnés sur les yeux et des 2 864 points visibles échantillonnés sur les dents n’est masqué par le casque dans la vue frontale Blender.

## Temps suspendu et états existants

Le verrou de position existant nettoie notamment des champs de capture. Il ne convient pas à une pause qui doit conserver ces champs. PolariCrax suspend donc la simulation centrale du combat à l’entrée de son Heartbeat et ajoute un motif de pause unique aux combattants et alliés du combat via `CraxAbilityGate`. Il ne remplace pas les vitesses, trajectoires ou captures par des copies différées.

Les chronomètres relatifs restent immobiles. Les échéances absolues inspectées sont prolongées de la seule durée omise : tuyaux/bonus/transit Plumber, toiles/poison Spidey, fureur et contrôles Fléau, référence temporelle Fantastic, fin visuelle Ghosty et ralentissements cinématiques Deadly. Le retrait de la pause enlève uniquement son motif ; un autre contrôle conserve sa priorité. La fenêtre d’esquive de 0,35 s ne commence réellement à s’écouler que lorsque la cible est libérée des autres contrôles. Les axes annoncés restent fixes et ne poursuivent pas la cible.

La place inspectée emploie un `CombatState` et deux racines `Fighter1`/`Fighter2`, plus les alliés exposés par `Deadly.MotionTargets`. L’arrêt cible cette simulation et ces modèles ; il ne modifie pas `Workspace.Gravity`, la vitesse globale du serveur, les avatars du monde ou les données des joueurs. Une architecture à plusieurs combats parallèles aurait besoin d’une instance de contrôleur par combat ; elle n’est pas présente dans les sources inspectées.

## Valeurs conservées et prototypes configurables

Toutes les valeurs demandées sont conservées : impulsion 6–9 s, charge 0,4 s, dégâts 10 ; attraction 2 s et aucun dégât ; inversion 12, une fois ; arrêt 1,2 s, cinq éclats simultanés à 6, plafond de trois touches par cible et activation, soit 18 maximum. Le paquet final de chaque éclat est plafonné à 6 après les modificateurs et avant les passifs de sauvetage ; une réduction reste applicable et une amplification ne dépasse pas le plafond demandé. La charge est comprise dans la cadence de base : la prochaine disponibilité est planifiée dès son démarrage, avec les pauses et priorités du combat existantes. Les niveaux sont cumulatifs. MAX utilise le déclencheur existant après le résultat serveur et n’ajoute aucun dégât ni récompense.

Les valeurs non définies dans le message sont isolées dans `CraxPolariConfig` :

| Réglage | Valeur de travail |
|---|---|
| Délai attraction | 10–14 s actives après son cycle |
| Délai Temps suspendu | 22–28 s actives après son cycle |
| Tic-tac préalable | 0,6 s |
| Fenêtre d’esquive | 0,35 s de contrôle réellement retrouvé |
| Avertissement d’inversion | 0,25 s, violet puis rouge |
| Courbure magnétique | interpolation exponentielle à 1,2/s ; vitesse conservée |
| Répulsion | normale intérieure inclinée de 28°, vitesse conservée |
| Déviation à l’impact | ±13°, uniquement après dégâts réellement confirmés |
| Projectile | vitesse 38 studs/s, durée 2,5 s, rayon logique 0,28 |
| Éventail | rayon 10 studs, cinq axes figés ; aucun recalage après la reprise |
| Exécution | 9 s ; dernier tic 4,2 s, claquement 5,2 s, trophée 5,6 s |
| Achats | barème Rare existant de Spidey : 5 000 / 15 000 / 30 000 / 50 000 Coins ou 30 / 80 / 150 / 250 Gems |
| Casino | masse Rare totale inchangée ; partage égal entre ses membres, Polari inclus ; poids des autres raretés conservés |

Le titre demandé **L’ULTIME SECONDE** est utilisé dans le livre, la scène et le trophée. Identifiant stable : `PolariFinalSecond`. Les prix et la redistribution Rare sont des choix de reprise de l’existant, visibles ici, à valider en économie réelle.
