# LuckyCrax — Cahier des charges pour Codex

Version de conception : 4 novembre 2026. Projet : **7 Deadly Crax**, place **Arène cubique**.

## 1. Mission et statut des décisions

Développer LuckyCrax, un Crax rare inspiré de la figurine Lucky Gold Crax de la référence jointe. Réaliser sa tête 3D à partir du **véritable CraxSourire existant**, ses compétences, ses animations, VFX et sons, puis le raccorder au combat, à la collection, à la sélection avant combat, au casino, à la progression, au livre de compétences et aux trophées.

Ce dossier décrit une intégration à réaliser. Il ne contient pas de personnage déjà installé, de nouveaux IDs Roblox ou de sons déjà téléversés. Les propositions ci-dessous ne doivent pas être confondues avec des décisions explicites du créateur.

**Règles validées par le créateur :**

| Élément | Exigence validée |
|---|---|
| Identité | LuckyCrax ; tête seule, base CraxSourire ; fidélité à la figurine jointe |
| Rareté | Rare |
| Vie maximale | 105 PV |
| Mêlée ordinaire | 8 dégâts |
| Attaque de base | PILE OU FACE : Pile, projectile direct à 12 dégâts ; Face, version à rebonds à 16 dégâts |
| Fréquence de base | Tirage serveur aléatoire entre 6 et 9 secondes de combat |
| Niveau 1 | Deux dés ; chiffres réels de 1 à 6 ; modélisation soignée et VFX travaillés |
| Niveau 2 | Trèfle à quatre feuilles dorées, texturé, cohérent avec LuckyCrax ; principe d'une protection/esquive après plusieurs coups reçus |
| Niveau 3 | Machine à sous au-dessus de la tête ET au-dessus de la barre de PV ; trois colonnes ; exactement trois symboles différents défilent dans chaque colonne ; résultat toujours gagnant |
| Jackpot soin | Trois symboles de soin : récupération nominale de 25 PV |
| Jackpot pièces | Ouverture de la vraie bouche ; rafale d'environ six pièces ; 5 dégâts par pièce ; rebonds pendant 4 secondes |
| Jackpot triche | Résultat rare ; désactivation des compétences ennemies pendant 7 secondes |

**Choix encore non validés :** vitesse chiffrée, probabilités exactes, fréquence des niveaux 1 et 3, calcul de dégâts des dés, seuil et durée du trèfle, nom et scénario MAX. Le dossier fournit des réglages de travail explicites pour permettre un prototype cohérent. Les isoler dans une configuration facilement modifiable.

## 2. Apparence et modélisation

Référence : `references/LuckyCrax_reference.jpeg`. Utiliser les figurines aux dents dorées visibles dans les résultats du haut de l'image ; les autres résultats de recherche et éléments de téléphone ne font pas partie du design.

### Tête canonique

- Cloner et adapter le modèle CraxSourire réellement utilisé dans le jeu. Conserver son volume, son sourire, les proportions des gencives et la disposition des dents.
- Tête blanche, yeux noirs en arcs souriants, gencives roses, deux rangées de grandes dents dorées. Garder les dents séparées et leur forme Crax ; éviter une plaque jaune uniforme.
- Métal doré lisible : reliefs arrondis, petits biseaux, variations de lumière et reflets maîtrisés. L'or doit rester doré dans l'arène comme dans les aperçus.
- Visage blanc à aspect de figurine vinyle ; gencives douces et propres ; aucune surexposition qui efface les yeux ou le sourire.
- Reproduire les motifs noirs latéraux seulement dans la mesure où ils sont lisibles sur la référence. Ne pas inventer des tatouages détaillés à partir de pixels flous.
- Conserver les éléments arrière standards du modèle de base lorsqu'ils font partie de son identité dans le jeu. Ne pas ajouter arbitrairement cheveux, couronne ou accessoires permanents.
- **Tête seule : aucun corps, sweat rouge, bras, pantalon ou chaussures.** Les pièces, dés, trèfle et rouleaux sont des éléments de compétence temporaires.

### Exigences de production

Utiliser Blender pour les formes nécessaires : pièces biseautées et gravées, dés, trèfle et boîtier des rouleaux. Livrer les sources `.blend`, exports compatibles avec le pipeline Roblox existant et textures réellement utilisées. Conserver les noms des objets, les UV, les normales, les matériaux et la séparation utile des éléments. Aucun objet de démonstration géant ne doit rester dans Workspace après installation.

Prévoir des repères de montage stables : centre de tête, avant, haut et sortie réelle de la bouche. Les noms sont à adapter au projet, pas à imposer aveuglément à une architecture existante.

**Une seule définition visuelle canonique** doit alimenter la collection, les cartes, les aperçus détaillés, la sélection précombat, le casino, le livre et le combattant. Normaliser les cadrages sur la tête logique ; les accessoires temporaires ne doivent pas réduire le visage dans une miniature. Conserver une taille comparable aux autres Crax sans modifier la hitbox pour compenser un cadrage.

## 3. Combat et autorité serveur

Le serveur décide des cibles, tirages, délais, collisions, dégâts, soins, protections, interruptions et durées. Le client dessine et joue les sons à partir de ces événements ; il ne choisit jamais un résultat gagnant ou une valeur de dégâts.

- Utiliser le système de santé, d'équipes, de mouvement et de collision existant.
- Vitesse : proposition de départ = vitesse normale de CraxSourire, valeur à relever dans le catalogue actuel.
- Chaque action possède un identifiant d'activation et une identité de manche/match. Rejeter les messages anciens.
- Les timers utilisent le temps de combat actif. Geler les durées lorsque le système de pause du combat le demande.
- Ne pas déclencher d'action pendant l'attente, la visée, le changement d'arène, la fin de manche ou une cinématique.
- Une seule compétence nécessitant une animation de lancement à la fois. Conserver une seule action en attente par compétence, sans rafale de rattrapage après une interruption.
- Réutiliser les règles existantes pour invulnérabilité, esquive, réduction, silence et mort. Aucun double retrait de PV entre un projectile serveur et son effet d'impact client.
- Les pièces de combat sont des projectiles visuels : elles ne donnent aucune monnaie et ne modifient pas le casino.

## 4. Attaque de base — PILE OU FACE

### Séquence

1. Le serveur programme un déclenchement dans **6 à 9 secondes** de combat actif, selon un tirage uniforme proposé.
2. LuckyCrax fait apparaître une grosse pièce dorée devant lui et la lance en tournoyant. Le résultat est fixé côté serveur avant la révélation.
3. Il frappe la pièce avec ses dents ou la propulse depuis le sourire selon la faisabilité du rig. Le départ doit toujours correspondre au vrai avant de la bouche.
4. Le projectile est dirigé vers la position d'un ennemi valide au moment du tir. Pas de poursuite automatique continue ajoutée sans validation.

### Résultats

| Tirage | Trajectoire | Dégâts |
|---|---|---:|
| Pile | Tir direct vers l'ennemi ; fin au premier impact valide | 12 |
| Face | Trajectoire initiale vers l'ennemi, puis jusqu'à deux rebonds sur les parois si la cible n'est pas touchée ; fin au premier impact ennemi | 16 |

La version Face conserve le principe à rebonds proposé auparavant. Proposition de sécurité : expiration du projectile après 3 secondes, même sans impact. Proposition de probabilités : **50 % / 50 %**, à confirmer.

Le délai 6–9 s s'interprète comme un prochain instant de déclenchement tiré après une activation. Si une autre compétence occupe LuckyCrax à l'échéance, l'action attend la fin de cette animation ; elle n'est ni multipliée ni retirée au hasard. Afficher clairement ce comportement dans le prototype.

### Rendu

Pièce épaisse avec tranche striée, biseaux, sourire Crax gravé côté Pile et trèfle côté Face. Rotation stable, anticipation courte, reflet balayé, traînée dorée et petites étincelles au rebond. À l'impact : petit éclatement de lumière et de fragments de pièces cosmétiques, très bref et lisible.

Sons distincts : lancer/tintement, révélation Pile ou Face, claquement des dents, vol, rebond et impact ennemi. Aucun long son d'impact quand le tir manque.

## 5. Niveau 1 — DÉS PIPÉS

Le principe des deux dés est validé ; les chiffres de combat ci-dessous sont des **propositions de prototype**.

### Dés et animation

Deux véritables dés 3D, coins arrondis et biseautés, matériau ivoire/vinyle de qualité, détails métalliques dorés et accents rouges cohérents avec l'univers Lucky. Chaque dé porte **les chiffres 1, 2, 3, 4, 5 et 6 sur ses six faces**. Ne pas remplacer la numérotation par une valeur flottante aléatoire sans rapport avec la face visible.

Faces opposées proposées : 1/6, 2/5 et 3/4. Tirage indépendant de chaque dé par le serveur. L'animation s'arrête sur les deux valeurs réelles ; pas de re-tirage client pour correspondre à une simulation physique imprévisible.

LuckyCrax fait surgir les dés à ses côtés, les fait tournoyer puis les lance devant lui. Deux ou trois rebonds visuels contrôlés, arrêt lisible, mise en évidence des faces gagnantes et onde d'impact dorée.

### Proposition de règles complètes

- Déclenchement automatique toutes les **12–16 s** de combat actif ; délai à confirmer.
- Animation totale autour de **1,2 s** ; cible/zone définie au lancement.
- Deux dés indépendants de 1 à 6, équiprobables.
- Dégâts proposés : **2 × somme des dés** sur une seule zone d'impact commune.
- Si les dés forment un double : **+8 dégâts**. Exemples : 2 + 5 = 14 ; double 3 = 20 ; double 6 = 32.
- Rayon de travail proposé : **5 studs**, à adapter à l'échelle réelle de l'arène.
- Un seul paquet de dégâts par activation et par ennemi dans cette zone. Les rebonds purement visuels des dés ne réinfligent pas les dégâts.

VFX : arcs dorés courts autour des dés, poussière lumineuse au contact, chiffres accentués au résultat, effet de double plus spectaculaire et compact. Sons : mouvement des dés, rebonds feutrés/métalliques, arrêt des deux valeurs, accent sonore spécial pour un double.

## 6. Niveau 2 — PORTE-BONHEUR

Validé : un **trèfle à quatre feuilles dorées**, bien modélisé et texturé, cohérent avec LuckyCrax et associé au principe de protection/esquive proposé.

### Trèfle

Quatre feuilles distinctes en forme de cœur, léger galbe, nervures sculptées ou intégrées dans des textures adaptées, bords biseautés, tige courte et or travaillé. Silhouette immédiatement lisible, sans ressembler à une croix ou à quatre sphères collées.

Le trèfle apparaît près de la tête dans un espace qui laisse le sourire, les PV et les rouleaux visibles. Brève croissance organique des feuilles, rotation lente de présentation puis petit éclat à l'esquive. Pas de grand halo opaque qui cache le Crax.

### Proposition de règles complètes

- Après **trois attaques ennemies distinctes** ayant réellement retiré des PV, préparer une charge de porte-bonheur.
- Le troisième coup est bien subi ; la protection concerne le prochain coup admissible.
- Une charge au maximum ; expiration proposée après **4 secondes**.
- La prochaine attaque admissible est esquivée : dégâts nuls et pas d'application des statuts liés à ce même coup.
- L'esquive consomme le trèfle. Pas d'invulnérabilité globale pendant quatre secondes.
- Ne pas compter chaque micro-tick d'un même effet continu comme une nouvelle attaque. Employer une identité d'attaque et les règles existantes du jeu.
- Geler le compteur pendant qu'une charge est prête ; retour à zéro après consommation ou expiration, proposition à valider.

Visuel de l'esquive : bref décalage élastique ou rémanence dorée, sans téléportation réelle ni changement arbitraire de position serveur. Sons distincts pour la préparation, la charge prête, l'esquive et l'expiration.

## 7. Niveau 3 — JACKPOT

### Machine à sous

Boîtier miniature premium, or biseauté et accents rouges, **trois vraies colonnes animées** séparées, avec une ligne centrale de résultat. Chaque colonne fait défiler les mêmes trois signes, tous distincts et reconnaissables.

Il faut voir les signes défiler dans une ouverture masquée proprement, puis les rouleaux ralentir et s'arrêter l'un après l'autre. Ne pas simuler la machine avec un simple texte changeant instantanément au-dessus de la tête.

Placement obligatoire : **tête → barre de PV → machine à sous**. Calculer les offsets à partir de la taille de la tête et des dimensions réelles de la barre de vie. Si une jauge ou un statut occupe déjà cet espace, réorganiser les éléments. Aucun rouleau ne doit recouvrir le nombre de PV, quelle que soit la distance de caméra ou le format d'écran.

### Trois signes uniquement — décision validée

Le créateur a précisé qu'il veut **exactement trois symboles**. Chacune des trois colonnes fait défiler ces trois signes :

1. **Cœur doré/vert** : soin nominal de 25 PV.
2. **Pièce gravée Crax** : rafale de six pièces à 5 dégâts chacune, avec rebonds pendant quatre secondes.
3. **Joker/tricheur violet et or** : compétences de la cible bloquées pendant sept secondes ; résultat rare.

Aucun quatrième symbole, aucun « 7 » décoratif et aucune combinaison perdante. Les seuls résultats finaux possibles sont trois cœurs, trois pièces ou trois jokers. Les trois rouleaux s'arrêtent successivement sur le même signe choisi par le serveur.

### Sélection proposée

| Triplet final | Effet | Probabilité proposée |
|---|---|---:|
| Trois cœurs | Soin nominal de 25 PV | 45 % |
| Trois pièces | Rafale de six pièces | 45 % |
| Trois jokers | Triche : compétences ennemies bloquées 7 s | 10 % |

Les pourcentages ne sont **pas encore validés**. Exigences fermes : résultat toujours gagnant ; triche sensiblement plus rare que les deux autres sorties.

Fréquence proposée : **18–24 s** de combat actif. Animation proposée : **1,8 s**. Le serveur tire une récompense pondérée unique, puis les trois rouleaux s'arrêtent sur ce même symbole. Ne pas tirer trois colonnes indépendantes qui pourraient produire une défaite.

### A. Soin — trois cœurs

Récupération nominale de **25 PV**, plafonnée à **105 PV**. Exemple : 90 → 105, soin effectif de 15 ; 50 → 75, soin effectif de 25. Le serveur publie le soin réellement appliqué.

VFX : cœurs qui quittent la machine et rejoignent la tête, impulsion dorée/verte, petits « + » verts et nombre du soin effectif. À pleine vie, ne pas afficher un faux +25 ni dépasser 105 ; indiquer visuellement « PV MAX » sans re-tirage caché. Son de gain positif et organique à Lucky, distinct du tir de pièces.

### B. Rafale — trois pièces

LuckyCrax ouvre **sa vraie bouche** et émet environ six pièces. Réglage de travail retenu : **six projectiles**, espacés d'environ 0,10 s, en direction de la cible serveur avec un léger éventail lisible.

- **5 dégâts par pièce**.
- **4 secondes de vie par pièce**, à compter de son émission.
- Rebonds sur les limites réelles de l'arène. Les pièces restent dans le plan et l'épaisseur prévus par le système de combat.
- Proposition anti-abus : une pièce ne peut infliger qu'un seul impact de dégâts à un même ennemi pendant sa durée de vie. Elle peut continuer à rebondir visuellement et atteindre un autre ennemi valide.
- Contre une seule cible, six pièces représentent donc au maximum **30 dégâts bruts** avant réductions ou esquives.
- Une pièce ne touche ni son propriétaire ni ses alliés.
- Les pièces ne doivent pas traverser les Crax ou les murs : utiliser les collisions logiques/sweeps existants, pas seulement un événement Touched dépendant du framerate.

Animation de bouche articulée et réversible : anticipation, ouverture, départ des pièces au repère de bouche, petites réactions de recul, fermeture et retour exact au repos. Aucun doublon de tête ou de mâchoire gigantesque.

VFX : six flashs courts, traînées dorées individualisées, éclats aux rebonds et impacts. Son de départ synchronisé à chaque pièce avec variations contrôlées ; limiter le cumul sonore quand plusieurs pièces frappent à la fois.

### C. Triche — trois jokers

La combinaison rare déclenche un bref effet de joker truqué, un clin d'œil/jeu du sourire selon le rig, puis une marque de triche sur l'ennemi ciblé. Un compteur clair affiche **7 s** et décroît avec le temps de combat actif.

Pendant ces sept secondes :

- Bloquer les attaques spéciales de base, les compétences débloquées et les déclenchements passifs de compétence du Crax ciblé.
- Interrompre les compétences en cours par leurs fonctions normales d'annulation et retirer leurs sorties actives lorsque ces fonctions le prévoient : projectiles, zones, invulnérabilité temporaire, boucliers ou invocations de compétence.
- Conserver le mouvement ordinaire, la mêlée à la valeur normale de la cible, la santé, le skin de base, l'inventaire et les niveaux acquis. L'effet n'est pas une paralysie ni une suppression permanente.
- Ne pas modifier directement tous les attributs du Crax puis restaurer une vieille copie sept secondes plus tard : cela écraserait les autres effets reçus entre-temps.
- Employer un motif de suppression temporaire indépendant, compatible avec le silence d'InvertedCrax et les autres statuts. Une source ne doit pas lever le blocage encore actif d'une autre source.
- À l'expiration, reprendre les compétences normalement sans lancer toutes les actions en retard simultanément.
- La durée est individuelle par cible et nettoyée lors d'une mort, d'une fin de manche ou d'un changement de combattant.

Ciblage proposé si plusieurs ennemis sont présents : **une cible principale choisie par le serveur**, pas toute l'arène. La portée multi-cible n'a pas été demandée. Les cinématiques de victoire, qui n'infligent aucun dégât de combat, gardent leur gestion normale.

Visuel distinct du soin : liens/jokers dorés et violets autour du visage, icône de compétence barrée et bref effet de cartes truquées. Aucun effet écran permanent ni copie visuelle d'ERROR 404. Sons : résultat rare, accent de triche, fermeture du blocage puis libération.

## 8. Niveau MAX, exécution et trophée — proposition à valider

Le créateur n'a pas encore défini le nom ni le scénario MAX de LuckyCrax. Proposition : **LE GROS LOT**, réservée à l'exécution et au trophée ; le niveau 3 reste nommé JACKPOT.

Scénario proposé, environ neuf secondes :

1. 0–1,2 s : transition vers une scène de casino au centre de l'arène, LuckyCrax et le vrai vaincu seuls.
2. 1,2–3 s : une machine à sous stylisée se construit autour de la cible ; pièces et jetons orbitent de façon organisée.
3. 3–5 s : les trois rouleaux ralentissent avec anticipation, lumières progressives et suspens sonore.
4. 5–6,5 s : combinaison gagnante spectaculaire, pluie de pièces dorées et disparition cartoon du vaincu dans le coffre du jackpot.
5. 6,5–8 s : LuckyCrax récupère une pièce sur ses dents, pose face caméra ; titre doré « LE GROS LOT ».
6. Fin : retour propre à l'arène et restitution de la caméra/UI.

Cette scène est cosmétique : aucun gain réel de monnaie, aucune deuxième mort, aucune altération du résultat serveur. Respecter les priorités de caméra existantes. Ne jamais capturer les alliés ou les autres Crax d'une équipe composite à la place du vrai vaincu.

Trophée : même modèle/icône dorée que les trophées MAX déjà fonctionnels. Case 4 du livre et trophée de page gauche dorés à l'obtention du MAX, avec le nom retenu. Avant acquisition : état verrouillé existant. L'identifiant technique du trophée doit rester stable si son titre est renommé ultérieurement.

## 9. Direction VFX et audio transversale

### VFX

Style cartoon premium de figurine : formes sculptées lisibles, or riche, blanc vinyle, rouge casino, touches de vert pour la chance et le soin, violet pour la triche. Rien ne doit masquer la tête ou ses PV.

Chaque action comprend anticipation, lancement, mouvement, contact ou échec, puis dissipation. Les traînées suivent les vrais projectiles ; les impacts arrivent à l'endroit des collisions serveur. Éviter les grands rectangles opaques, les sphères génériques seules, les flashs blancs saturés et les particules sans direction.

Aucune surface superposée coplanaire qui scintille. Toute transformation doit restaurer la pose et les matériaux de repos. Prévoir une qualité réduite avec moins de particules et de détails secondaires, sans retirer les informations utiles.

### Audio

Créer ou sélectionner des sons originaux cohérents : métal de pièce chaud et net, dés tactiles, mécanisme de roulette/rouleaux, sonnette de jackpot, trèfle et soin plus doux, triche plus sournoise. Les sons doivent réellement jouer en jeu, pas seulement exister dans un dossier.

Cues minimaux : CoinFlip, CoinRevealPile, CoinRevealFace, CoinLaunch, CoinBounce, CoinHit, DiceLaunch, DiceBounce, DiceSettle, DiceDouble, CloverReady, CloverDodge, CloverExpire, ReelsStart, ReelsLoop, ReelStop, JackpotHeal, JackpotCoins, JackpotCheat, CoinVolley, CheatEnd et les accents du scénario MAX retenu.

Une boucle de rouleaux doit être présente pendant la rotation puis s'arrêter réellement. Différencier contact et absence de contact. Positionner les sons d'attaque au bon Crax ; la cinématique utilise son propre contexte audio. Nettoyer les boucles sur interruption et mort.

Fournir les WAV/OGG sources. Si un atlas WAV unique est choisi, livrer la carte exacte des segments, des marges silencieuses, les régions de boucle et les tests de lecture de chaque segment. Aucun ID Roblox fictif, aucun démarrage du fichier entier à chaque cue. Vérifier les permissions de l'expérience après import et garder les sons existants des autres Crax.

## 10. Intégration complète au jeu

### Audit obligatoire avant de modifier le projet

Lire les sources actuelles du jeu. Les noms déjà observés incluent CraxCatalog, CraxSkillCatalog, CraxVictoryCatalog, CopEmClient, PlayerInventory, ArenaMovement, CombatHealth et RoundManager ; **relever l'architecture réelle actuelle** plutôt que remplacer une ancienne version supposée.

Préférer une extension LuckyCrax et des adaptateurs ciblés. Un identifiant de travail possible est `Crax_Lucky`, à confirmer après contrôle des collisions de noms. Ne pas supprimer ni restaurer des catalogues entiers pour ajouter cette entrée.

### Collection et sélection

Ajouter l'entrée rare, le modèle canonique, les aperçus et les descriptions. Même tête et mêmes matériaux dans toutes les interfaces et dans le combat. Les compétences ne doivent pas être listées comme de faux « effets » permanents dans l'inventaire.

### Casino

Intégrer LuckyCrax au circuit rare existant et aux mécanismes de gain/possession déjà en place. Les probabilités de drop et prix ne sont pas fournis : reprendre la politique existante et les rendre visibles dans la configuration pour validation. Ne pas modifier silencieusement la distribution des autres Crax ni leurs sauvegardes.

### Progression et livre

Raccorder les achats, les niveaux acquis, les coûts selon la grille existante et les conditions de révélation des sceaux. Ne pas réutiliser les IDs d'images de SuperCrax/SymbiotiCrax comme s'ils appartenaient à LuckyCrax.

Ordre du livre : 1 DÉS PIPÉS ; 2 PORTE-BONHEUR ; 3 JACKPOT ; 4 trophée doré MAX au nom d'exécution finalement retenu. Les icônes montreront LuckyCrax dans un style cartoon cohérent avec SuperCrax. Les fenêtres de description doivent utiliser exactement les mêmes illustrations, sur fond transparent, sans carré noir superposé.

### Statuts et compatibilité

La Triche doit réellement fonctionner sur toutes les familles de pouvoirs existantes. Prévoir un test particulier contre SuperCrax, InvertedCrax, SymbiotiCrax, BlackSpida et les combattants à invocations/alliés. Conserver les téléporteurs, le démarrage des combats, la progression, le casino et les cinématiques des autres personnages.

## 11. Livraison attendue de Codex

- Modèles et textures de production, sources Blender et exports ; modèles de tête et FX bien séparés.
- Scripts/modules réels et configuration centralisée des valeurs validées et provisoires.
- Sons sources, carte audio éventuelle et instructions de raccordement des vrais IDs importés.
- Installateur simple pour **Arène cubique en STOP**, avec sauvegarde et restauration en cas d'erreur ; aucune dépendance à une sélection ambiguë dans l'Explorateur.
- Guide court : fichiers à importer, ordre exact des actions, commande à coller, emplacement des IDs, sauvegarde puis nouveau Play.
- Diagnostic lisible distinguant fichier manquant, mauvais ID, image non chargée, permissions et script non installé.
- Aucun message « terminé » tant qu'une étape nécessaire a échoué. Ne pas affirmer que le rendu a été vérifié dans Roblox Studio si seuls des tests simulés ont été exécutés.

## 12. Recette et critères d'acceptation

### Identité et systèmes

- [ ] Tête fidèle à la photo ; aucune partie du corps ; dents dorées distinctes et yeux lisibles.
- [ ] 105 PV, mêlée 8 et rareté rare corrects dans le catalogue et en combat.
- [ ] Visuel identique entre collection, sélection, casino, livre et arène ; aucun doublon de visage.
- [ ] LuckyCrax sélectionnable et réellement utilisable après obtention ; aucune régression des téléporteurs.

### Compétences

- [ ] Pile = 12 ; Face = 16 ; intervalle serveur 6–9 s ; trajectoires, expiration et collisions vérifiées.
- [ ] Deux dés numérotés de 1 à 6 ; résultat visible égal au tirage serveur ; pas de dégâts supplémentaires causés par leurs rebonds visuels.
- [ ] Trèfle à quatre feuilles, préparation/esquive/expiration lisibles ; aucune invulnérabilité accidentelle prolongée.
- [ ] Trois rouleaux distincts, trois signes visibles en défilement, toujours un triplet gagnant autorisé.
- [ ] Machine au-dessus des PV, y compris sur écran étroit et dans les caméras de combat.
- [ ] Soin de 25 plafonné à 105 ; affichage du soin réel.
- [ ] Six pièces à 5 dégâts ; quatre secondes par projectile ; rebonds et limites de multi-impact respectés.
- [ ] Triche rare ; sept secondes exactes de combat actif ; blocage de toutes les compétences de combat et restauration sans écraser les autres statuts.
- [ ] Aucun client ne peut imposer son jackpot, son soin ou sa cible par un événement réseau.

### Présentation et nettoyage

- [ ] Chaque lancement, boucle, rebond, impact, résultat et fin dispose du son attendu et audible.
- [ ] Aucun son qui continue après fin de manche, aucune pièce ni aucun rouleau restant dans l'arène.
- [ ] Aucune superposition noire sur les icônes ou descriptions ; trophées MAX cohérents.
- [ ] Tests mort pendant une action, cible disparue, pause, triche pendant une compétence, plusieurs LuckyCrax et changement de manche.
- [ ] Résultats des tirages vérifiés statistiquement sur des simulations serveur ; aucune garantie du rare à chaque début de match.

## 13. Décisions à confirmer après présentation du prototype

1. Probabilités de travail 45 % soin / 45 % pièces / 10 % triche et Pile/Face 50/50.
2. Dés : intervalle 12–16 s, dégâts 2 × somme +8 si double, rayon 5 studs.
3. Trèfle : trois attaques reçues, une esquive, quatre secondes de validité.
4. Jackpot : intervalle 18–24 s, rotation 1,8 s, triche sur une cible.
5. Nom et scénario d'exécution MAX proposés : LE GROS LOT.

**Priorité : respecter les exigences validées. Les valeurs de prototype doivent rester modifiables et explicitement signalées ; ne pas les transformer en décisions définitives sans retour du créateur.**
