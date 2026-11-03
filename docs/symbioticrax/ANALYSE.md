# Analyse de l’existant et intégration

Le dépôt a été examiné après SuperCrax (`4b8acad`). Le dernier diagnostic Studio disponible contient 334 sources, les chemins et la géométrie de la base. **Ce diagnostic n’est pas une lecture en direct de votre Studio actuel.** Les versions peuvent avoir évolué depuis ; l’installateur lit donc l’éditeur au moment de son exécution et conserve les corrections indépendantes.

Le vrai CraxSourire est `ServerStorage.CraxTemplates.Crax_Monster`. Son rig contient notamment `Head`, `UpperShell`, `LowerShell`, `UpperGums`, `LowerGums`, `EyeLeft`, `EyeRight` et les dents **`Tooth_0_0`…`Tooth_0_7` / `Tooth_1_0`…`Tooth_1_7`**. Les noms de l’OBJ (`Tooth071`, etc.) diffèrent : l’adaptateur fait la correspondance explicite avant de masquer les huit dents remplacées par les crocs. La tête, le pivot et la hitbox restent natifs.

Le modèle est construit depuis l’OBJ réel déjà fourni, dont le hash est conservé. Les 22 865 sommets natifs sont comparés à une copie de référence : écart maximal nul. L’enveloppe, les plages blanches courbes, les yeux transformés, les crocs, la langue et les neuf tentacules sont des meshes additionnels. Le corps et le filigrane de la photo ne sont pas reproduits. La marque dorsale existante reste héritée dans la place ; l’arrière et les prolongements invisibles sont interprétés. Les couleurs/matériaux effectifs de Studio sont appliqués par l’adaptateur au rig réel.

La photo jointe a été consultée dans la conversation. Elle n’existe pas comme fichier image local à intégrer à un photomontage : la comparaison livrée est **base CraxSourire / modèle SymbiotiCrax**, pas une fausse capture côte à côte avec la photo. Les vues viennent du même vrai modèle Blender, y compris les deux poses de bouche et l’aperçu 128 px. La fidélité finale doit être approuvée après import ; aucune face cachée n’est annoncée comme une reproduction exacte.

L’arène canonique emploie le plan XY, avec X −24…24 et Y 5…45 à l’intérieur des murs `Arenaleft`, `ArenaRight`, `Arenabottom`, `ArenaTop`. Les projections spectateurs suivent `CraxArenaConfigV37`. Le serveur valide owner/match/round/activation ; aucun client ne choisit de dégâts ou de capture. Le parasite reste une entité logique limitée à sa capacité, pas un troisième combattant enregistré.

## Raccordements ciblés

| Source | Changement |
|---|---|
| `CraxCatalog` | Identifiant unique `Crax_Symbioti`, Épique hérité de Ghosty, 125 PV, 8, vitesse Sourire, description et effets. |
| `CraxSkillCatalog` | Quatre niveaux cumulatifs, prix Ghosty confirmés, trophée MAX et textes de règles réelles. |
| `CraxEffectsCatalog` | Contamination, armure et parasite, sans exposer les états internes de capture comme effets d’inventaire. |
| `CraxRouletteConfig` | Ajout Épique avec masse globale conservée. Tirage, doublons, prix et sauvegarde restent ceux du serveur existant. |
| `CraxVictoryCatalog` | MAX Sym, durée 9 s et trophée, sans dégâts/gains supplémentaires. |
| `CraxSkinServer` | Apparence clonée de la vraie base, restauration puis application du skin propre ; mêmes ressources pour preview et combat. |
| `CraxPositionLock` | Déplacement contrôlé d’un verrou exclusif ; les autres raisons restent prioritaires et ne sont pas effacées. |
| `ArenaMovement` | Step du personnage dans la simulation existante, maintien de capture, suppression du contact supplémentaire et modificateur de vitesse. |
| `CraxDeadlyRuntime`, `FleauRuntime` | Même modificateur réversible sur les déplacements secondaires/contrôlés, sans dépendance circulaire au chargement. |
| `CombatHealth` | Réduction d’armure, perte réelle/confirmations, dégâts fractionnaires du parasite, soins confirmés. Réutilisation de `BiteHit`/`CraxHeal`, pas de santé parallèle. |
| `RoundManager` | Métadonnées Sym du vrai gagnant/niveau/match publiées avant le marqueur de scène. |
| `CopEmClient`, `CraxBookCinema` | Illustrations propres, fallback lisible, MAX doré et titre long ; réglages temporaires de titre restaurés pour les autres Crax. |
| `CraxTrophyServer` | Titre Sym mis à l’échelle ; attribution/équipement toujours dérivés des niveaux par le registre existant. |
| `ArenaCamera` | Rend la caméra au propriétaire de la scène Sym et retire sa défaite générique ; retour exact à la fin/interruption. |

Les huit nouvelles sources sont dans `src/symbioticrax` : configuration, règles, runtime serveur, apparence, client, audio, index d’atlas et cadrage des aperçus. `integration/symbioticrax/review` montre les 18 résultats sur les sources inspectées ; **ces fichiers ne doivent pas être copiés par-dessus vos fichiers actuels**.

Le cadrage Sym est également raccordé dans `InventoryClient` et le point de fit partagé de `CraxDeadlyVisuals`. Il utilise les bornes complètes langue/tentacules, préserve la rotation de la caméra, s’adapte au format et ne change pas la branche des autres Crax.

## Parcours conservés et limites

`PlayerInventory`, `InventoryClient`, sélection, `CraxSkillServer`, `CraxSkillResolver` et `CraxRouletteServer` utilisent les catalogues, previews, possessions et niveaux génériques. Leurs formats de données, validations de propriété et événements sont conservés. Aucun DataStore, prix de casino, personnage de départ, don général ou migration de profil n’est ajouté. Les quêtes et scores passent par les événements/résultats actuels.

L’intégration est écrite et testée dans un banc local ; le parcours réel **tirage → possession → équipement → combat → achat → reconnexion → trophée** doit encore être vérifié dans Studio. Il n’existe ici ni accès DataStore réel, ni deux clients Roblox, ni publication d’assets. Les contrôles de compatibilité refusent les versions dont les ancrages ne correspondent plus.
