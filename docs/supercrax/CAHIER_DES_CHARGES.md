# SuperCrax — cahier des charges complet pour Codex

## 1. Mission et méthode

Développer et intégrer entièrement **SuperCrax** dans le jeu Roblox Studio **7 Deadly Crax**, place **Arène cubique**. Livrer un personnage jouable et fini : modèle fidèle à la référence, comportement en combat, progression, VFX, sons, cinématique MAX, inventaire, sélection, casino et sauvegarde via les systèmes existants.

**La fidélité du design aux photos et au CraxSourire existant est une priorité absolue.** Ne pas livrer une boule générique avec une perruque approximative. Ne pas se contenter de créer un dossier ou d'ajouter une définition au catalogue : vérifier le parcours complet depuis l'obtention jusqu'au combat et à la victoire.

Les règles marquées « validé » reprennent les décisions du créateur. Les directions artistiques et règles techniques proposées servent à rendre l'implémentation précise ; elles ne constituent pas des décisions de gameplay supplémentaires déjà approuvées. Les points non tranchés sont regroupés à la fin. Avancer sur tout ce qui est défini sans bloquer l'ensemble du projet.

Avant d'éditer, inspecter le projet actuel, ses consignes et ses sources réelles. Les noms de scripts ci-dessous sont des repères issus d'exports antérieurs, pas une garantie de version. Ne pas remettre d'anciennes versions complètes pour introduire SuperCrax. Préserver les correctifs d'InvertedCrax, Ghosty, Killa et des autres Crax.

## 2. Identité et référence visuelle — VALIDÉ

| Élément | Décision |
|---|---|
| Nom affiché | SuperCrax |
| Rareté | Commun ; employer la valeur interne déjà utilisée pour cette rareté |
| Base réelle du modèle | CraxSourire existant dans le projet |
| Inspiration | Superman, d'après la photo fournie |
| Périmètre du modèle | La tête, son skin et sa chevelure ; aucun corps complet demandé |
| PV de base | 100 |
| Dégâts de mêlée de base | 8 |
| Vitesse | Non fixée ; reprendre provisoirement la vitesse normale du CraxSourire, sans inventer une valeur |
| Progression | Pouvoir de base, niveaux 1 à 3, puis cinématique MAX |

**Référence à joindre à Codex :** `image(20261102-131036).png` (la photo montrant deux figurines de superhéros dans les nuages). La figurine bleue et rouge sert de direction principale. La variante noire et dorée ne constitue pas un second skin à développer dans ce lot.

### Exigences de modélisation

- Partir du véritable CraxSourire : conserver son volume de tête, sa silhouette, son sourire très large, la construction des dents, la courbure de ses yeux souriants et son langage de figurine vinyle. Identifier le nom interne réel de son template avant de cloner.
- Reproduire la référence, adaptée à une tête seule : expression joviale et sûre d'elle, surface claire du visage, détails propres et proportions cohérentes avec les autres Crax.
- Ajouter une **vraie chevelure noire en volume** sur la partie supérieure du crâne : coiffée en arrière, mèches sculptées lisibles, implantation ajustée à la courbure de la tête et **boucle caractéristique sur le front**. Elle doit être reconnaissable de face, de trois quarts, de profil et de dos.
- Ni casque noir uniforme, ni pointes aléatoires, ni cheveux flottant au-dessus du modèle. Éviter les intersections avec les yeux et les dents. Prévoir un contour propre aux tempes et à la nuque.
- Sur le skin, **placer le symbole de Superman rouge et jaune juste sous la tête/zone du visage**, centré sur la partie inférieure avant visible. Avec le périmètre « tête seule », intégrer ce motif à la zone de skin disponible, sans créer de torse pour le porter. Préserver le sourire ; ne pas recouvrir la bouche par le symbole.
- Palette de la version classique : noir pour les cheveux, visage clair, bleu pour la partie de costume représentée dans le skin, emblème rouge et jaune. Utiliser la photo pour les teintes et leur répartition.
- Matière de figurine vinyle : reflets soignés, couleurs lisibles, détails sculptés. Éviter le métal permanent ; l'aspect acier appartient à la compétence.
- Conserver taille globale, pivot, ancrage visuel et socle compatibles avec les autres Crax. Les accessoires ne doivent pas augmenter involontairement la collision physique ou la portée des attaques.
- Modèle identique entre inventaire, aperçu du livre, casino, combat et cinématique ; ne pas utiliser un substitut simplifié dans un de ces écrans.
- Si Blender ou un outil de modélisation est utilisé, livrer le fichier source et les exports importables. Si l'outil manque, le signaler précisément, sans prétendre avoir produit un modèle fidèle déjà terminé.

### Validation visuelle avant finition

Présenter des vues de face, profil, dos et trois quarts, plus une comparaison côte à côte avec la photo et le CraxSourire de base. Vérifier également le rendu aux petites tailles réelles du jeu. La coiffure, la boucle, le sourire et l'emblème doivent rester lisibles dans les aperçus.

## 3. Progression et statistiques — VALIDÉ

Les niveaux débloquent des capacités cumulatives : le niveau 2 conserve les lasers, le niveau 3 conserve les niveaux précédents. MAX ajoute une exécution de victoire, pas un pouvoir de combat supplémentaire non demandé.

| Stade | Contenu |
|---|---|
| Base | Dash circulaire en trois tours, avec Homme d'acier temporaire |
| Niveau 1 | Rayon laser |
| Niveau 2 | Souffle gelé |
| Niveau 3 | L'Invincible SuperCrax et kryptonite |
| MAX | Exécution : congélation, charge laser de 1,5 s, éclatement |

Ne pas augmenter silencieusement les 100 PV ou les 8 dégâts en montant de niveau. Prix des compétences, ordre dans les listes et mécanisme de prestige doivent suivre les conventions réelles du jeu ; aucun montant n'a encore été fixé pour SuperCrax.

## 4. Pouvoir de base — dash circulaire / « Tornade d'acier »

Le comportement est validé ; « Tornade d'acier » est un nom de travail proposé.

- Le serveur tire un délai aléatoire **entre 8 et 12 secondes de combat actif**.
- SuperCrax effectue **trois tours circulaires en 1,5 seconde au total**, soit une cadence visuelle de 0,5 seconde par tour.
- Son déplacement est aléatoire, décidé par le serveur, en restant dans l'arène. Le centre, le rayon et le sens exact des cercles restent des paramètres de réalisation à mettre au point ; ne pas confondre cette attaque avec une simple rotation sur place.
- Pendant ces 1,5 seconde, SuperCrax se renforce en **Homme d'acier** : il ne subit aucun dégât ordinaire.
- Un ennemi touché reçoit **2 × les dégâts de mêlée**, donc **16 dégâts de base**. Ce contact de compétence remplace le contact normal de 8 ; il ne produit pas 16 + 8.
- L'invulnérabilité s'arrête exactement avec la compétence. Elle ne donne pas de soin ni de bonus permanent.
- Après le niveau 3, la kryptonite reste mortelle même pendant Homme d'acier.

La possibilité de toucher plusieurs fois le même ennemi au cours des trois tours n'a pas été tranchée. Proposition d'équilibrage : une seule touche de 16 par ennemi et par activation ; la garder explicitement provisoire.

### VFX et son proposés

Transformation progressive très brève en métal brossé, reflet blanc/bleu qui balaie la tête, mèche encore reconnaissable, trois traînées circulaires rouge et bleu avec noyau blanc, anneaux de pression et petites étincelles à l'impact. Les traînées doivent traduire le chemin réel et ne pas masquer les adversaires.

Audio : impulsion de mise en acier, souffle de déplacement rythmé par les trois tours, accent d'impact unique par touche effective, retour discret à l'état normal. Ne pas lancer le son d'impact à chaque image ou sur un ennemi déjà comptabilisé.

## 5. Niveau 1 — Rayon laser — VALIDÉ

- Deux rayons rouges issus des **deux yeux** de SuperCrax.
- Chaque rayon a sa **direction aléatoire indépendante**, choisie par le serveur. Ils ne sont pas obligatoirement parallèles et ne suivent pas automatiquement l'ennemi le plus proche.
- Durée : **2,5 secondes**.
- Dégâts : **15 PV par seconde d'exposition**, par ennemi, au maximum.
- Si une victime est touchée par les deux rayons en même temps, le total reste **15 PV/s**, jamais 30.
- Exposition intégrale de 2,5 s : **37,5 dégâts de base maximum par victime et par activation**, avant les règles de protection/réduction existantes.
- Les dégâts cessent lorsque la victime quitte les deux rayons ; ils reprennent sur nouvelle exposition pendant la même activation, sans dépasser le temps réel d'exposition.
- Déclenchement séparé des autres compétences, avec délai serveur aléatoire **entre 5 et 8 secondes de combat actif**.
- Ne pas superposer les lasers avec la Tornade d'acier ou le Souffle gelé. Si une compétence occupe SuperCrax, attendre sa fin pour lancer une attaque prête.
- Les lasers ne donnent aucune invulnérabilité à eux seuls.

L'orientation fixe ou mobile pendant les 2,5 s n'a pas été précisée. Proposition : tirer une direction par rayon au lancement et la conserver pendant l'activation. Si la tête bouge, garder un départ cohérent avec les yeux et une géométrie calculée côté serveur.

### Réalisation attendue

Rayons multi-couches : noyau clair, corps rouge saturé, halo doux, points lumineux sur les yeux et impacts lumineux aux obstacles. Utiliser des attaches réellement placées sur les yeux, pas deux rayons provenant du centre de la tête. L'impact visuel doit coïncider avec la portée et les obstacles du calcul serveur.

Dégâts calculés sur le temps d'exposition via le système de combat, sans arrondir abusivement chaque tick. Une union des victimes des deux rayons par intervalle évite le double dégât. Prévoir une détection continue adaptée aux déplacements rapides.

Audio original : allumage net, boucle énergétique stable, crépitements d'impact limités, extinction courte sans clic audio. La boucle s'arrête à la mort, en fin de round et en cas d'interruption.

## 6. Niveau 2 — Souffle gelé — VALIDÉ

### Déclenchement et forme

- Après **3 contacts avec des Crax ennemis**, SuperCrax prépare le souffle.
- **Canalisation de 2 secondes avant de tirer**.
- Puis souffle glacé **large et épais**, pendant **3,5 secondes**.
- Il est dirigé vers la partie de l'arène **la plus éloignée de SuperCrax**, et couvre toute sa longueur dans cette direction. Ce n'est pas un ciblage automatique du Crax le plus éloigné.
- La largeur exacte et la règle géométrique de sélection de cette direction doivent être explicites et configurables après inspection de la forme réelle de l'arène.

### Gel, entretien et brisure

- Tout ennemi dans le souffle est immobilisé et fragilisé.
- Le gel possède une durée de **5 secondes**, entretenue tant que la victime reste exposée : chaque exposition valide repousse l'expiration à « maintenant + 5 secondes ».
- Après la dernière exposition, la victime reste donc gelée jusqu'à 5 secondes supplémentaires.
- Exemple : victime exposée aux 3,5 s complètes → jusqu'à **8,5 s** de gel depuis sa première exposition, sauf brisure anticipée.
- Si **SuperCrax lui-même retouche la victime fragilisée**, il brise la glace, libère la victime et lui inflige **35 dégâts au total**, en remplacement des **8 dégâts de mêlée**.
- La brisure consomme cet état : pas plusieurs frappes à 35 sur la même congélation.
- Une victime libérée par brisure ne doit pas être immédiatement regelée par **le même souffle**.
- Le souffle n'a pas de dégâts directs chiffrés validés. Ne pas lui ajouter de dégâts continus sans accord.
- Les lasers ne doivent pas être interprétés comme un contact de mêlée qui brise la glace.
- Ne pas appliquer une vulnérabilité générale supplémentaire au motif du mot « fragilisé » : son effet défini est la brisure à 35 par SuperCrax.

### VFX et audio proposés

Pendant la canalisation : particules froides convergeant vers la bouche, baisse locale de saturation, condensation, lueur blanche/bleue. Pendant le souffle : flux volumineux composé de plusieurs couches, cœur directionnel, brume périphérique légère, cristaux distincts et traces de givre temporaires.

La victime prend une enveloppe de glace adaptée à sa silhouette, semi-transparente et facettée, avec fissures et reflets. Préserver une lecture du Crax gelé et la lisibilité de ses PV. La glace ne doit pas devenir une collision physique parasite. À la brisure : éclats, courte onde blanche et son sec de cristal.

Audio original : inspiration froide durant 2 s, souffle soutenu durant 3,5 s, congélation individuelle et brisure à 35. Ne pas multiplier la boucle principale par le nombre de victimes.

## 7. Niveau 3 — L'Invincible SuperCrax — VALIDÉ

### Sauvetage mortel

Lorsqu'un dégât ordinaire devrait tuer SuperCrax :

1. Le serveur intercepte le dégât **avant la résolution de mort**.
2. SuperCrax reste à **1 PV**.
3. Il ne peut plus mourir de dégâts ordinaires pour le reste du round.
4. Une **grosse kryptonite verte**, bien visible, apparaît dans l'arène.

Il **conserve tous ses pouvoirs**, leurs niveaux et leurs compteurs : Tornade d'acier, lasers et Souffle gelé. L'état n'est pas un mode de fuite sans compétences.

Ne pas transformer ce passif en résurrection après attribution d'une victoire. Une fois activé, les dégâts ordinaires doivent être bloqués, y compris les dégâts périodiques. Les interactions avec les soins restent à définir ; aucune régénération automatique n'est demandée.

### Kryptonite

| Situation | Résultat validé |
|---|---|
| SuperCrax touche sa kryptonite au sol | Mort immédiate |
| Un ennemi la touche | Ramassage et bonus de vitesse de **50 %** tant qu'il la porte |
| Le porteur touche le SuperCrax concerné | Mort immédiate de SuperCrax, animation spéciale |
| Un ennemi sans kryptonite le touche | Pas de mort par dégâts ordinaires |
| Contact kryptonite pendant Homme d'acier | La mort par kryptonite reste prioritaire |

La mort doit déclencher la procédure normale du jeu : attribution correcte, fin de round, scores, nettoyage. Ne pas simplement détruire la figurine ou forcer un écran local.

### Présentation attendue

Activation : coup mortel visuellement absorbé, bref choc de lumière, indication lisible du passage à 1 PV. Apparition de la kryptonite : cristal vert volumineux, facettes travaillées, lueur et particules contenues, signal sonore distinct.

Sur le porteur : kryptonite attachée ou en orbite proche, aura verte lisible et traînée de vitesse. Le bonus est un modificateur réversible, pas une réécriture permanente de sa vitesse.

Animation de mort proposée : réaction à proximité du cristal, propagation de veines vertes/fissures lumineuses, tremblement, extinction de l'aura héroïque et effondrement de la tête. Animation courte compatible avec le rythme des rounds. Elle doit rester distincte de l'exécution MAX.

## 8. Exécution MAX — congélation puis lasers — VALIDÉ

Nom proposé : **ZÉRO ABSOLU**, non imposé par le créateur.

Uniquement si **SuperCrax au niveau MAX gagne le round**, pour le public autorisé selon le système de cinématiques existant.

### Séquence impérative

1. **L'ennemi vaincu est immobile au milieu de la scène.**
2. **SuperCrax apparaît à côté de lui comme s'il volait** : tête légèrement surélevée, inclinaison et flottement contrôlés. Aucun corps complet n'est à inventer.
3. Il **souffle un vent glacial** qui recouvre puis gèle complètement le Crax ennemi.
4. Une fois l'ennemi gelé, SuperCrax **charge ses deux yeux en rouge pendant exactement 1,5 seconde**.
5. Il tire ses lasers sur le Crax gelé.
6. **Le Crax gelé et sa glace partent en éclats.** Il ne suffit pas de casser une coque en laissant le Crax intact au milieu.
7. Les fragments se dispersent, s'estompent et la caméra revient proprement au jeu.

Le timing total reste à définir après animation. La durée annoncée au RoundManager doit correspondre à la durée réelle, y compris entrée, fin et restitution de caméra. La charge de 1,5 s doit rester explicite et non raccourcie.

### Qualité de réalisation

Clones locaux du vrai gagnant et du vrai perdant ; préserver leurs skins. Mise en scène avec caméra cadrant clairement les deux têtes, transition fluide, gros plan mesuré sur la charge et impact final lisible. Éviter tremblements permanents et flashes blancs couvrant tout l'écran.

Glace progressive en plusieurs étapes, lumière rouge réfractée dans les fissures avant explosion, fragments correspondant aux volumes/couleurs de la victime. Utiliser des fragments visuels simulés ou une fragmentation préparée, pas une destruction coûteuse du modèle original.

Sons : arrivée en vol, souffle froid, cristallisation, montée de laser de 1,5 s, décharge, fracas de glace et retombées cristallines. Synchronisation aux mêmes horodatages que les événements visuels.

La scène est une présentation d'une victoire déjà décidée : aucun dégât de combat, aucun deuxième décès ni attribution doublée. Nettoyer caméra, FOV, transparences, modèles, lumières, sons, effets et éventuel verrou musical, même sur interruption ou départ d'un joueur.

## 9. Direction VFX et audio générale

Le créateur demande des **VFX très travaillés et des effets sonores originaux**. Viser un rendu de figurine cartoon premium, cohérent avec 7 Deadly Crax et lisible en arène.

Palette : rouge/bleu/blanc pour le héros ; acier pour la protection ; cyan/blanc pour le gel ; rouge pour les yeux ; vert exclusivement pour la kryptonite. Donner à chaque capacité une anticipation, une phase active, un impact et une extinction.

Prévoir des niveaux de qualité et une limite d'émetteurs, de lumières et de fragments. Réutiliser les objets lorsque pertinent, nettoyer systématiquement. La réduction de qualité ne doit pas masquer les zones dangereuses. La simulation serveur ne dépend jamais de la présence d'un VFX client.

Créer des SFX originaux si l'environnement permet la synthèse/production audio. Fournir des fichiers sources/exportables et des variantes cohérentes. Pas de faux identifiants Roblox ou d'affirmation qu'un audio est publié alors qu'il n'a pas été importé. Préparer une table de configuration explicite des assets à renseigner si l'import doit être fait par le créateur.

Prévoir clés séparées : SteelStart, CircleDash, DashHit, SteelEnd, LaserStart, LaserLoop, LaserEnd, FrostCharge, FrostLoop, FreezeApply, IceShatter, LastStand, KryptoniteSpawn, KryptonitePickup, KryptoniteDeath, FinaleFly, FinaleLaserCharge, FinaleLaserShot, FinaleShatter. Les noms sont proposés ; adopter les conventions du projet.

En combat, choisir une spatialisation audible à l'échelle réelle de l'arène. Pour la cinématique, employer le mixage local prévu par le jeu. Vérifier les droits d'utilisation des assets dans l'expérience, leur chargement et leur durée réelle. Pas de son détruit avant sa fin, pas de boucle fantôme, pas de volume arbitrairement poussé pour masquer un mauvais routage. Tester en situation avec les autres sons et la musique.

## 10. Autorité serveur et interactions

Le serveur décide : délais aléatoires, trajectoires, collisions, dégâts, victimes, état gelé, brisure, activation à 1 PV, création/ramassage de kryptonite, bonus de vitesse et mort. Le client présente ces décisions.

- Utiliser un identifiant de match, de round, de SuperCrax et d'activation dans les événements utiles pour ignorer les paquets périmés.
- Compter le temps de combat actif, pas le temps passé au menu, en visée ou en cinématique.
- Sérialiser les compétences actives : pas de laser pendant le souffle ou la Tornade. Définir une priorité et une attente bornée pour éviter qu'une capacité prête ne soit affamée.
- Réinitialiser délais, compteurs et états à chaque round. Aucun retard ou effet d'un round précédent ne doit atteindre le suivant.
- Gérer la mort pendant la canalisation et le tir. Ne pas accorder d'invulnérabilité à la canalisation du souffle ni aux lasers sans demande.
- Réutiliser les tests d'ennemi/alliance, protections et pipeline de dégâts existants. Préserver crédits de dégâts et éliminations.
- Immobiliser via le système de statuts : ne pas écraser définitivement la vitesse ou l'ancrage. À la fin du gel, recalculer la mobilité avec les autres statuts encore actifs.
- Appliquer le bonus kryptonite à partir d'une vitesse de référence/modificateur. Des contacts répétés ne doivent pas cumuler +50 % en boucle.
- Ramassage atomique : un seul porteur. Nettoyer la kryptonite et ses bonus en fin de round et gérer départ/mort du porteur.
- Les règles de SILENCE existantes doivent être respectées. Vérifier leur convention pour les compétences déjà actives et le passif mortel ; ne pas inventer une exception permanente pour SuperCrax.
- La mort par kryptonite doit être une cause dédiée, validée serveur, qui contourne explicitement les protections de SuperCrax concernées et empêche un nouveau sauvetage à 1 PV.

## 11. Intégration complète au jeu

Inspecter les systèmes réellement actifs, en repérant aussi les scripts doublons qui pourraient remplacer l'interface ou les définitions en cours d'exécution.

### Catalogue, modèle et combat

Ajouter une entrée unique et stable (identifiant proposé `Crax_Super`, à adapter uniformément si le projet emploie une autre convention). Relier nom affiché, rareté Commun, template réel, PV 100, contact 8, vitesse de référence, pouvoir et progression. Publier le modèle et le preview par les mécanismes existants. Vérifier qu'il apparaît réellement en arène après sélection.

Repères connus à inspecter : `CraxCatalog`, `CraxSkillCatalog`, `CraxEffectsCatalog`, `CraxVictoryCatalog`, `CombatHealth`, `ArenaMovement`, `ArenaPlayers`, `CraxSkillResolver`, `RoundManager`, `CraxSkinServer`. Ce ne sont pas des fichiers à remplacer aveuglément.

### Inventaire et sélection

Intégrer vignette, preview 3D, nom, rareté, statistiques, description, onglets pouvoir/effet et sélection. Respecter la propriété réelle : pas de déblocage gratuit implicite, pas de modification des inventaires existants. Même identifiant dans les données joueur et le catalogue. Vérifier sauvegarde/reconnexion, équipement et déséquipement.

Repères connus : `PlayerInventory`, `StarterGui.InventoryGui.InventoryClient`, `CraxTemplates`, `CraxPreviews`.

### Livre de compétences

Quatre étapes cohérentes : Rayon laser, Souffle gelé, L'Invincible SuperCrax, exécution MAX. Les textes doivent indiquer les vraies valeurs et le comportement. Utiliser les prix et conventions du projet sans inventer des montants présentés comme validés. Suivre le masquage/recherche des Crax non possédés.

Prévoir trois illustrations de compétences adaptées aux sceaux et le même traitement de trophée MAX que les autres Crax. Ne pas reprendre les images d'Inverted. Vérifier ImageLabel, hiérarchie, ZIndex, chargement des assets et redimensionnement dans les écrans réels.

Repères connus : `CopEmClient`, `CraxBookCinema`, système de prestige et résolution des niveaux.

### Casino / roulette

Intégrer SuperCrax au groupe **Commun** par la configuration réelle du casino (`CraxRouletteConfig` ou équivalent). Reprendre le mécanisme de pondération existant, conserver les probabilités globales par rareté et ne pas attribuer arbitrairement une probabilité spécifique non validée. Relier preview, silhouette éventuelle, animation de tirage, attribution serveur, doublons et sauvegarde. Vérifier qu'un vrai tirage peut l'attribuer et qu'il devient sélectionnable ensuite.

### Effets, trophées, quêtes et récompenses

Ajouter les statuts nécessaires (gel/fragilité, acier, kryptonite) aux présentations prévues sans dupliquer les systèmes. Les trophées éventuels suivent le modèle d'attribution existant ; ne pas inventer de récompense ou d'exploit supplémentaire. Les quêtes génériques de combat, victoires, dégâts, obtention ou progression doivent reconnaître SuperCrax via leurs mécanismes normaux.

### Victoire et caméra

Réserver l'exécution aux victoires de **SuperCrax MAX**, avec vérification de l'identité réelle du gagnant. Publier des métadonnées complètes avant le marqueur déclenchant la scène, selon le protocole actuel : gagnant, Crax, niveau, type, début, fin, round. Éviter plusieurs scripts concurrents publiant la même victoire. Ne jamais déclencher une cinématique Killa, Ghosty ou Inverted pour SuperCrax, ou inversement.

## 12. Points de gameplay encore à trancher

Ne pas présenter les propositions ci-dessous comme déjà approuvées. Les rendre configurables et les signaler clairement au créateur avant de figer la livraison.

1. **Tornade :** une seule touche par victime et par activation, ou une par tour ? Proposition : 16 maximum par victime/activation.
2. **Cadences :** le délai aléatoire commence-t-il au lancement ou à la fin de la compétence ? Proposition : nouveau délai après la fin ; premier délai au début du combat actif.
3. **Compteur du souffle :** contacts de mêlée ordinaires uniquement ou contacts de Tornade inclus ? Proposition : mêlée ordinaire validée, sans compter les ticks laser, et remise à zéro au déclenchement.
4. **Géométrie :** rayon/centre des trois cercles, épaisseur/portée des lasers, largeur du souffle et calcul du côté le plus éloigné. Choisir à partir des dimensions actuelles de l'arène et montrer un test visuel.
5. **Canalisation :** SuperCrax reste-t-il mobile pendant les 2 s ? Ne pas l'immobiliser arbitrairement sans le signaler.
6. **Brisure + Tornade :** une collision de Tornade peut-elle briser la glace ? Si oui, priorité unique à définir : 35 au total, sans addition 16 + 35. Sinon, réserver la brisure à la mêlée normale.
7. **Passif et SILENCE :** respecter la convention actuelle des passifs mortels ; exposer le résultat exact.
8. **Kryptonite :** lieu de spawn équitable, devenir à la mort/déconnexion du porteur, éventuelle portée entre plusieurs SuperCrax et règles en équipes. Proposition : cristal lié à son propriétaire, spawn accessible à distance raisonnable, dépôt au sol si porteur disparaît.
9. **Soins après sauvetage :** maintien strict à 1 PV ou soins autorisés avec état d'invulnérabilité conservé ? Aucun choix explicite à ce stade.
10. **Économie :** prix d'amélioration et poids individuel dans le groupe Commun à confirmer selon les conventions en place.
11. **Noms :** Tornade d'acier et Zéro absolu sont proposés, les autres noms viennent des demandes du créateur.

Le kit est très puissant pour un Commun. Ne pas modifier silencieusement les valeurs demandées pour l'équilibrer ; mesurer le résultat et proposer séparément des ajustements si nécessaire.

## 13. Vérification et critères de livraison

- Modèle comparé à la référence et au CraxSourire ; cheveux sculptés, boucle, sourire et symbole reconnaissables. Pas de corps ajouté.
- Nouveau joueur et joueur existant : pas de reset de données ; obtention, inventaire, sélection, sauvegarde et réapparition fonctionnels.
- Casino : rareté Commun, attribution réelle, traitement normal des doublons et previews corrects.
- Niveaux : capacités indisponibles avant leur déblocage, cumul correct ensuite ; seuls les joueurs/personnages au MAX ont l'exécution.
- Tornade : trois tours/1,5 s, 16 dégâts suivant la règle retenue, collisions sans traversée des murs, invulnérabilité strictement bornée.
- Lasers : directions indépendantes, durée 2,5 s, exposition correcte, deux rayons superposés toujours limités à 15/s ; mesurer 37,5 sur cible exposée toute la durée sans réduction.
- Souffle : troisième contact, 2 s d'attente, 3,5 s de vent, gel entretenu puis 5 s depuis dernière exposition, brisure unique à 35 remplaçant 8, pas de regel par le même souffle après brisure.
- Mort : dégât mortel direct et périodique interceptés avant décès, passage à 1 PV, compétences conservées, contact kryptonite réellement mortel même pendant acier.
- Kryptonite : un porteur, bonus +50 % sans cumul, retrait propre, collisions et attribution validées serveur.
- Deux clients et, si le jeu le permet, plusieurs ennemis : cohérence des trajectoires, états, sons, caméras, victoire et nettoyage.
- Exécution : vrai skin adverse, gel puis charge rouge de 1,5 s puis éclatement de la victime ; aucun impact sur les données du round terminé.
- Interruption : mort, nouveau round, changement de personnage, départ d'un joueur et fermeture d'interface ne laissent aucun effet/son/modificateur fantôme.
- Régression : Inverted, Ghosty, Killa, Golden, Fantastic et autres Crax gardent leurs comportements et leurs propres cinématiques.
- Distinguer les tests exécutés des tests restant à faire dans Roblox Studio. Aucune affirmation de validation en jeu sans l'avoir réalisée.

## 14. Livrables attendus de Codex

1. Implémentation complète dans le projet actuel, avec changements ciblés et justifiés.
2. Modèle final et sources de modélisation si produites, previews et références nécessaires.
3. Configuration centrale des valeurs et identifiants, sans magie dispersée dans les scripts.
4. VFX finalisés et table audio avec fichiers originaux produits et identifiants réels disponibles ; liste explicite de tout asset restant à importer.
5. Textes français du catalogue, des pouvoirs, des statuts et du livre.
6. Validation des règles ci-dessus et rapport court des tests réellement exécutés.
7. Installation adaptée au flux du créateur : si absence d'accès direct au projet, commande Roblox Studio à exécuter en **STOP**, avec vérification préalable, sauvegarde, retour arrière et réexécution sans doublons. Ne pas produire une commande qui écrase tout le jeu.
8. Guide d'import puis **nouveau Play** pour recharger les modules et clients ; rappeler la sauvegarde du projet après validation.
9. Résumé final clair : éléments terminés, fichiers modifiés, décisions provisoires, assets manquants et vérifications restant à faire.

**Objectif final : SuperCrax doit sembler appartenir au jeu dès l'origine, avec une fidélité forte à la photo et une finition visuelle/sonore cohérente à tous les endroits où il apparaît.**
