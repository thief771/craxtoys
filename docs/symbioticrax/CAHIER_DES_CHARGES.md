# SymbiotiCrax — cahier des charges détaillé pour Codex

> **Mission :** développer et intégrer SymbiotiCrax dans le jeu Roblox existant « 7 Deadly Crax » / « Arène cubique ». Partir du vrai Crax Sourire du projet, reproduire sa tête symbiotique avec une très grande fidélité à la photo fournie et livrer un personnage fonctionnel dans le combat, la collection, le casino, le livre de compétences et les trophées. Ce document demande un développement 3D et du code de jeu, pas une nouvelle image illustrative.
>
> **État :** conception préparée pour Codex. Ce document ne prouve pas que le modèle, les sons, les scripts ou les intégrations sont déjà créés. Distinguer les caractéristiques approuvées, les idées conservées et les propositions d’implémentation ci-dessous.

## 1. Ce que l’utilisateur a confirmé

| Élément | Exigence confirmée |
|---|---|
| Nom affiché | **SymbiotiCrax** — respecter cette orthographe |
| Rareté | **Épique** |
| Vie de base | **125 PV** |
| Dégâts de mêlée ordinaires | **8** |
| Vitesse | **Vitesse normale du Crax Sourire**, à lire dans le catalogue existant |
| Base du modèle | **Le Crax Sourire réel du jeu**, historiquement identifié comme `Crax_Monster` |
| Partie à modéliser | **Uniquement la tête** de la figurine de référence |
| Direction artistique | Symbiote inspiré de Venom, extrêmement fidèle à la photo fournie |
| Compétences | L’utilisateur apprécie la proposition de progression et demande de la conserver pour ce cahier des charges |
| Présentation | VFX détaillés, sons originaux et intégration cohérente au jeu existant |

Les noms de compétences, valeurs et règles proposés dans les sections suivantes sont conservés comme base de conception. L’utilisateur n’a pas encore validé séparément chaque nombre, délai, interaction ou nom de trophée. Ne pas les présenter comme des arbitrages explicitement approuvés.

### Cadre pour avancer sans réinventer le personnage

- Ne pas changer les caractéristiques confirmées pour rééquilibrer discrètement le personnage.
- Garder les propositions de compétences dans une configuration centralisée et modifiable.
- Pour les points ouverts, appliquer les conventions existantes lorsqu’elles règlent réellement le cas. Sinon, exposer une valeur de travail dans la configuration et la signaler dans les notes de livraison.
- Une question de gameplay bloquante peut être regroupée avec les autres questions importantes. Elle ne doit pas arrêter le travail indépendant sur le modèle, les ressources, l’audit ou les adaptateurs.
- Aucun nouveau prix, pourcentage global de rareté, seuil de progression ou coefficient de récompense n’est approuvé par ce document.

## 2. Référence visuelle : priorité absolue

### 2.1 Ressources à fournir à Codex

1. Ce document.
2. **La photo de la figurine symbiotique jointe par l’utilisateur**, actuellement nommée `image(20261102-225609).png` dans l’export de travail.
3. Le dernier export du projet Roblox et le vrai modèle Crax Sourire qui s’y trouve.

La photo doit être réellement consultée. Une description textuelle ne remplace pas son observation. Si elle manque dans la session de Codex, demander uniquement cette ressource nécessaire tout en poursuivant l’audit du projet.

### 2.2 Ce qu’il faut reconnaître immédiatement

Le résultat doit rester identifiable comme **un Crax Sourire possédé par un symbiote**, avec son volume rond et son immense sourire. Il ne faut pas fabriquer une tête humanoïde générique de Venom, puis lui ajouter un sourire Crax.

Sur la vue fournie :

- La tête est ronde, large, de type figurine vinyle, avec une face très expressive.
- Le noir du symbiote recouvre presque toute la surface visible. Ce n’est pas une séparation géométrique en une moitié blanche propre et une moitié noire propre.
- Des plages blanches irrégulières traversent le front et la zone centrale/gauche visible. La matière noire les encercle et semble les absorber.
- Un grand œil blanc allongé apparaît du côté droit de l’image, avec une pointe supérieure marquée et un contour noir organique.
- La dentition garde des dents Crax larges et arrondies du côté gauche visible, puis évolue vers des dents plus longues, étroites et pointues sur la zone davantage transformée.
- La bouche est immense, avec une cavité sombre et des gencives rosées visibles.
- Une grosse langue rouge rosé sort près du centre/droite de la bouche, avance vers l’extérieur, part à droite de l’image et se recourbe vers le bas puis vers l’intérieur.
- Plusieurs tentacules épais et arrondis émergent du sommet du crâne, en courbes et en boucles.
- D’autres filaments plus longs se prolongent vers la droite et l’arrière de la silhouette. Ils ne sont pas tous identiques ni disposés comme des rayons réguliers.
- Le matériau noir présente des bourrelets, des creux, des nervures et des reflets qui donnent une impression de substance vivante.

### 2.3 Ce qui n’appartient pas au modèle demandé

Ne pas reproduire le corps, les bras, le torse, les vêtements, les jambes ou les chaussures de la figurine. Le tatouage ou motif de torse éventuel ne doit pas être déplacé sur la tête par invention. Ne pas reproduire le fond, l’interface de vente ou le filigrane présents sur la capture.

### 2.4 Ce que la photo ne permet pas de certifier

La référence montre principalement une vue de face en trois-quarts. L’arrière complet, le dessous et la profondeur exacte des tentacules ne sont pas documentés par cette seule image.

Les prolongements non visibles doivent être cohérents avec la silhouette observée et les conventions du jeu, mais présentés comme une interprétation. Ne pas prétendre à une reproduction exacte d’une face jamais montrée.

## 3. Construction du modèle 3D

### 3.1 Conserver une base réellement compatible

- Cloner le vrai modèle de référence du Crax Sourire depuis les ressources actuelles.
- Examiner le `Head`, le pivot, l’échelle, l’orientation frontale, les yeux, les gencives, les dents et les conventions d’animation avant de les modifier.
- Préserver la compatibilité avec les mouvements et rebonds de l’arène, les aperçus de collection et les animations de bouche.
- Conserver une taille de tête et une hitbox compatibles avec les autres Crax. Les tentacules et la langue au repos sont des éléments visuels ; ils ne doivent pas agrandir implicitement la collision de mêlée.
- Vérifier la convention de marque dorsale du jeu et conserver ce qui doit être hérité du Crax Sourire. Ne pas ajouter un grand emblème arbitraire sans référence.

### 3.2 Sculpture du symbiote

Créer une véritable enveloppe 3D asymétrique qui épouse le crâne. Les bords doivent donner l’impression que la matière s’étale sur le vinyle et remonte autour des yeux et de la bouche.

Exigences de qualité :

- Contours irréguliers, épaisseurs variables, petits replis et transitions convaincantes.
- Pas de simple sphère noire superposée au Crax d’origine.
- Pas de bandes plates flottantes, de pics disposés uniformément ou de plaques carrées déguisées en matière organique.
- Pas de z-fighting, de peau d’origine qui traverse les surfaces ou de jour entre le masque et la tête.
- Une face lisible de près comme dans une vignette de collection.
- Une matière noire brillante avec des reflets contrôlés : rester noir, sans devenir une boule chromée grise ni une masse invisible sans détails.

Employer les outils de modélisation appropriés disponibles dans l’environnement. Pour les éléments organiques importants, privilégier un vrai travail de maillage. Ne pas présenter un assemblage provisoire de primitives comme une finition définitive.

### 3.3 Yeux, dents et bouche

- Reprendre les placements des yeux de la base et les retravailler pour correspondre à la photo.
- Les grands yeux blancs doivent épouser la courbure du crâne ; éviter deux autocollants rectangulaires.
- Conserver la transition visible entre dents Crax arrondies et crocs plus agressifs.
- Les crocs doivent avoir une vraie épaisseur et rester correctement implantés dans les gencives.
- La cavité buccale reste sombre et suffisamment profonde pour recevoir la langue et rendre les morsures crédibles.
- Vérifier la bouche fermée, légèrement ouverte et en morsure complète. Les dents et gencives ne doivent pas se traverser.

### 3.4 Langue et tentacules

La langue est un élément majeur du design et du pouvoir de base.

Au repos : volume épais, base attachée dans la bouche, courbe proche de la référence, extrémité effilée et recourbée. Elle ne doit pas ressembler à un cylindre uniforme ou à une corde rouge.

En action : transition continue entre repos, préparation, projection, enroulement, traction et retour. Une extension spectaculaire ne doit pas provoquer d’étirement rigide d’un seul bloc.

Prévoir une méthode d’animation adaptée : maillage articulé, chaîne de segments soigneusement raccordés ou autre solution justifiée. Les jonctions ne doivent pas être visibles en gros plan. La racine de la langue reste attachée à la bouche dans toutes les orientations du Crax.

Les tentacules du crâne ont des longueurs et épaisseurs différentes, avec des courbes souples et une silhouette asymétrique. Le mouvement au repos doit être discret et déphasé entre les brins. Éviter une agitation permanente qui brouille le visage.

### 3.5 Points d’attache et organisation

Prévoir des points nommés et stables pour la racine de langue, le départ des filaments, les morsures, les projections, les sons et les éclats. Le nom exact doit suivre les conventions du projet ; un préfixe propre au personnage évitera les collisions.

Séparer clairement les éléments permanents du skin et les objets temporaires des compétences. Une désactivation de VFX ne doit pas enlever les tentacules qui font partie du design.

## 4. Progression conservée

Le pouvoir de base est disponible au niveau initial. Les niveaux 1, 2 et 3 ajoutent les capacités proposées. Le niveau MAX ajoute la présentation de victoire et son trophée ; il ne doit pas secrètement ajouter un bonus de dégâts.

**Hypothèse de progression à expliciter :** les compétences acquises restent cumulativement disponibles aux niveaux supérieurs, selon les conventions déjà utilisées par le jeu. Ne pas retirer une compétence précédente sans instruction.

### Tableau des propositions de travail

| Déblocage | Nom proposé | Principe | Valeurs de travail conservées |
|---|---|---|---|
| Base | Langue prédatrice | Attraper, tirer vers soi, mordre | 16 dégâts ; délai aléatoire de 8 à 12 s |
| Niveau 1 | Contamination | Trois marques de mêlée déclenchent une explosion | 15 dégâts supplémentaires ; soin de 5 PV |
| Niveau 2 | Armure vivante | La perte réelle de PV nourrit une protection temporaire | Seuil 30 PV ; durée 4 s ; réduction de 35 % |
| Niveau 3 | Nous sommes deux | Parasite poursuivant puis accroché à l’ennemi | Accrochage 3 s ; ralentissement 25 % ; 3 dégâts/s ; soin de retour 5 PV |
| MAX | Nous sommes SymbiotiCrax | Exécution de victoire avec langue et énorme mâchoire | Chronologie et durée à déterminer |

## 5. Pouvoir de base — Langue prédatrice

### 5.1 Intention

Un prédateur organique qui capture un adversaire, le rapproche puis l’attaque. Le contact doit être visible et physiquement cohérent avec l’arène. La langue ne doit pas passer à travers l’ennemi sans réaction ni ramener brutalement une cible par téléportation.

### 5.2 Séquence attendue

1. Préparation lisible : ouverture de bouche, langue qui se contracte, léger mouvement des tentacules.
2. Projection depuis le véritable point d’attache dans la bouche.
3. Détection serveur d’un impact ou d’un échec.
4. Si la cible est touchée : enroulement visuel cohérent et mise en place du contrôle autorisé.
5. Traction progressive vers SymbiotiCrax avec collisions et limites d’arène respectées.
6. Morsure terminale, impact visuel et sonore au bon instant.
7. Libération de la cible et retour animé de la langue à sa position de repos.

### 5.3 Dégâts et contacts

Valeur proposée : **16 dégâts au total pour la morsure de compétence**. Ne pas ajouter automatiquement 8 dégâts de collision, 8 dégâts de mêlée et 16 dégâts de morsure sur le même instant.

Les dégâts passent par le système de santé existant. Une cible invulnérable ne perd pas de PV par écriture directe. Un contact visuel peut produire un effet d’impact sans simuler une perte de PV qui n’a pas eu lieu.

Le déplacement et les contrôles doivent être distincts des dégâts. Une réduction de dégâts ne signifie pas automatiquement une immunité à la traction, et inversement ; suivre les règles actuelles du jeu ou exposer le point ouvert.

### 5.4 Échec et interruption

La langue qui rate se rétracte sans dégâts. Si la cible meurt, disparaît, change d’arène ou devient invalide, supprimer la capture et libérer les verrous appartenant à cette capacité.

Une fin de round, un abandon ou un reset ne doit laisser aucune cible immobilisée, aucune langue tendue et aucun son en boucle.

### 5.5 Réglages ouverts

Portée, largeur de contact, vitesse de projection, choix de cible, temps de préparation, durée maximale de capture, vitesse de traction, mobilité du lanceur et point de départ du délai de récupération restent à préciser.

Le délai proposé de 8 à 12 secondes est tiré par le serveur. S’il s’agit de temps de combat actif, sa mesure doit utiliser l’horloge existante et respecter les pauses de combat ; ne pas supposer qu’un simple délai en temps réel convient.

## 6. Niveau 1 — Contamination

### 6.1 Principe conservé

Chaque contact de mêlée ayant réellement retiré des PV ajoute une marque noire à sa victime. À la troisième marque, les trois marques se rejoignent, éclatent et sont consommées.

Valeurs proposées : **15 dégâts supplémentaires**, puis **5 PV rendus au propriétaire** selon la condition de soin retenue.

### 6.2 Règles techniques nécessaires

- Compteur associé au couple propriétaire/victime, pas un compteur global partagé entre tous les joueurs.
- Un même impact confirmé ne peut pas ajouter plusieurs marques parce que plusieurs événements ou frames l’observent.
- Ne pas compter automatiquement les dégâts périodiques du parasite, le saignement ou l’explosion elle-même comme de nouvelles mêlées.
- Ne pas déclencher de boucle où l’explosion réapplique immédiatement ses propres marques.
- Le soin doit passer par le système de santé, respecter le maximum de PV et les interdictions de soin existantes.
- Une marque ne doit pas survivre accidentellement au round ou au départ de son propriétaire.

### 6.3 VFX

Une marque est une petite masse noire en relief, avec un cœur sombre, des nervures et quelques ramifications courtes. À deux marques, la tension augmente et des filaments commencent à les relier. À trois, la matière converge vers un point avant l’éclatement.

La couleur de fond reste noire ; employer des reflets blancs/gris froids et éventuellement une très faible teinte organique pour la lisibilité. Ne pas introduire un énorme effet vert toxique qui éloigne le personnage de la référence.

L’explosion doit contenir une déformation organique, des éclaboussures contrôlées et une brève impulsion lumineuse, sans cacher toute l’arène.

### 6.4 Points ouverts

Durée de conservation des marques, participation de Langue prédatrice, possibilité de nettoyer les marques et condition exacte du soin si les dégâts d’explosion sont entièrement bloqués. Recommandation de travail : ne pas accorder de soin offensif à partir d’une perte de PV nulle ; ce choix n’est pas encore validé par l’utilisateur.

## 7. Niveau 2 — Armure vivante

### 7.1 Principe conservé

Après **30 PV réellement perdus**, le symbiote referme son enveloppe pendant **4 secondes** et réduit les dégâts reçus de **35 %**. Le compteur ne se recharge pas pendant la protection.

### 7.2 Traitement de la santé

- Compter la perte de PV confirmée après protections, pas le montant brut d’une attaque annoncée.
- Utiliser le pipeline existant de réduction de dégâts ; ne pas appliquer la réduction deux fois.
- Ne pas transformer cette protection en invulnérabilité totale.
- Définir ce qui se passe lorsqu’un seul impact franchit le seuil : protection sur les coups suivants ou autre règle explicitement signalée.
- Sans validation contraire, cette capacité ne constitue pas un sauvetage automatique à 1 PV et n’annule pas rétroactivement un coup déjà mortel.
- Déterminer si le dépassement du seuil est perdu ou reporté et documenter ce choix.

### 7.3 Transformation visuelle

La matière existante se propage depuis ses bords. Elle recouvre progressivement les plages encore découvertes, épaissit le masque et tend les tentacules. Les yeux blancs peuvent paraître plus agressifs sans changer arbitrairement de forme ou de couleur.

Les impacts génèrent une déformation localisée ou une réaction de petits filaments protecteurs. À la fin, la matière se retire vers son état initial : ne pas laisser une ancienne couche ou un matériau sombre appliqué définitivement.

Éviter une coque opaque uniforme qui efface les dents, la langue et toute la sculpture. Le personnage doit rester reconnaissable pendant sa protection.

## 8. Niveau 3 — Nous sommes deux

### 8.1 Principe conservé

Une petite masse de symbiote se détache, poursuit une cible, s’y accroche, puis revient fusionner avec son créateur.

Valeurs proposées : **3 secondes d’accrochage**, **ralentissement de 25 %**, **3 dégâts par seconde**, puis **5 PV de soin au retour**. **Un seul parasite actif à la fois.**

À exposition complète, les dégâts de travail représentent 9 PV de base avant les modificateurs du jeu. Ne pas multiplier les dégâts par le nombre de frames.

### 8.2 Cycle de vie

États suggérés : préparation, détachement, poursuite, accrochage, retour, fusion, nettoyage.

Le serveur possède la cible, les dégâts, le ralentissement, la durée et la condition du soin. Le client représente la créature, ses filaments et les effets. Le parasite ne doit pas devenir un troisième combattant indépendant compté comme vainqueur ou détenteur d’un inventaire.

Si le projet possède déjà un gestionnaire d’entités secondaires, l’étendre. Sinon, créer un adaptateur limité à cette capacité sans refondre le combat entier.

### 8.3 Déplacement et ralentissement

Le parasite doit rester dans les limites de l’arène et rejoindre sa cible par une trajectoire lisible. Une cible invalide ne doit pas être poursuivie indéfiniment.

La vitesse ralentie doit être un modificateur identifié par sa source, supprimé proprement en fin d’effet. Ne pas recalculer successivement `vitesse *= 0.75` à chaque frame. Suivre la politique de cumul déjà existante.

### 8.4 Design du parasite

Petit volume noir asymétrique, miniature de l’identité du personnage : yeux blancs, petite bouche, appendices mous et mouvement bondissant ou rampant. La séparation et la fusion doivent donner l’impression de matière qui se partage puis se rejoint.

Un filament temporaire peut souligner le départ et le retour. Éviter un lien permanent traversant toute l’arène comme un câble rigide.

### 8.5 Points ouverts

Déclenchement, récupération, vitesse, durée maximale de poursuite, choix de cible, possibilité de rater, contrôle pendant l’accrochage et condition du soin au retour. Ces réglages doivent être visibles dans la configuration et identifiés comme des propositions.

## 9. MAX — cinématique et trophée

### 9.1 Concept conservé

Titre de travail : **NOUS SOMMES SYMBIOTICRAX**. Il n’est pas encore confirmé comme nom définitif du trophée.

L’ennemi est immobilisé au centre de la présentation. Des filaments noirs remontent autour de lui. Une énorme mâchoire de symbiote se déploie derrière SymbiotiCrax. La langue capture le vaincu, le tire vers cette mâchoire, qui se referme. La matière se rétracte ensuite, SymbiotiCrax retrouve sa tête normale et termine face caméra avec le titre du trophée.

### 9.2 Qualité attendue

- Une préparation qui annonce l’arrivée de la masse noire, pas une apparition instantanée sans transition.
- Une mâchoire volumétrique, avec lèvres organiques, cavité profonde, crocs en plusieurs plans et animation crédible.
- Une langue réellement raccordée à la bouche, puis à la victime capturée.
- Une victime complète, correctement centrée et dimensionnée, accessoires compris.
- Un impact final stylisé : éclats noirs, filaments qui se rétractent, onde de pression, brume légère et poussière. Conserver le ton cartoon figurine du jeu.
- Une silhouette et des matériaux lisibles malgré la dominante noire.
- Une pose finale de prédateur satisfait, avec langue et tentacules encore légèrement animés.

### 9.3 Caméra et synchronisation

Utiliser la propriété exclusive de caméra déjà prévue pour les cinématiques du projet. Les caméras génériques de victoire ou de défaite ne doivent pas se battre avec celle du personnage.

Une seule représentation visible de SymbiotiCrax et une seule victime. Si la scène utilise des clones isolés, masquer les originaux au moyen de l’infrastructure existante, puis restaurer exactement leur visibilité.

Le cadrage doit s’adapter au volume complet de la scène et au format de l’écran. Ne pas couper le haut de la mâchoire, les tentacules ou la victime sur mobile.

Définir une unique chronologie centrale : préparation, déploiement, capture, fermeture, rétraction, pose, titre et retour. Les sons, VFX, caméra et signaux serveur doivent lire les mêmes repères.

La durée finale est ouverte. Une fois retenue, elle doit être cohérente dans le catalogue de victoire, le gestionnaire de round et le client. Ne pas reprendre une durée arbitraire d’un autre personnage.

### 9.4 Trophée et livre

Conserver la présentation dorée cohérente avec les autres Crax : vignette MAX, trophée de page gauche, légende et éventuel titre équipé. Le même identifiant et le même nom doivent être utilisés par le livre, le catalogue de victoire et le registre des trophées.

Si le nom de travail est retenu, prévoir une mise à l’échelle et une largeur adaptées à sa longueur. Ne pas laisser un ancien libellé « DÉVOREUR », « ERREUR 404 » ou « CRAX D’ACIER » hérité d’une copie de script.

Aucun dégât ni gain supplémentaire ne doit être accordé simplement parce qu’une animation MAX se joue.

## 10. Direction VFX commune

### 10.1 Palette et couches

Palette dominante : noir profond, reflets gris froids, blancs des yeux et dents, rouge rosé de la langue et des gencives. Le symbiote doit rester la matière principale.

Pour chaque action importante, travailler au moins les fonctions suivantes, avec une solution adaptée : anticipation, mouvement principal, contact, effet résiduel et disparition. Cela ne signifie pas multiplier arbitrairement les émetteurs.

### 10.2 Effets à développer

- Déformations ou ondulations de matière sur la tête.
- Filaments souples et effilés.
- Petites gouttes visqueuses qui se détachent puis disparaissent proprement.
- Traces de contamination attachées à la bonne surface et suivant la cible.
- Brèves projections aux contacts confirmés.
- Rappel de matière vers le personnage lors des soins et de la fusion.
- Armure qui se propage et se rétracte depuis les zones existantes.
- Impulsion finale et rétraction cohérentes lors de l’exécution MAX.

Les sons et effets d’impact doivent distinguer une attaque qui rate, une capture qui réussit et une attaque dont les dégâts sont bloqués. Ne pas afficher une grosse perte de PV ou un soin fictif.

### 10.3 Lisibilité et performance

- Les particules ne doivent pas cacher durablement les PV ou l’adversaire.
- Les effets suivent le bon repère d’arène, y compris dans les projections destinées aux spectateurs.
- Prévoir une qualité réduite sur mobile : moins de filaments secondaires, de gouttelettes et de particules, mais conserver la langue, les états et les informations importantes.
- Réutiliser des objets si l’infrastructure le permet et borner le nombre d’effets simultanés.
- Éviter les créations d’objets sans limite à chaque frame.
- Les VFX ne doivent pas ajouter de collision, modifier les PV ou déplacer physiquement les combattants côté client.

## 11. Direction sonore originale

### 11.1 Objectif

Créer une identité sonore spécifique : matière élastique, tensions humides stylisées, claquements de dents, grondement grave discret, étirement et réabsorption. Produire des sons originaux ; ne pas extraire des voix ou musiques de films.

Éviter les bruits excessivement aigus, les volumes saturés et une accumulation continue de sons boueux. La sensation de puissance doit venir de l’attaque, du timbre et du rythme, pas uniquement d’un volume élevé.

### 11.2 Liste des événements à sonoriser

| Événement | Intention |
|---|---|
| Préparation de langue | Contraction élastique et tension croissante |
| Projection | Fouet organique rapide |
| Échec et retour | Rétraction plus légère, sans impact |
| Capture | Accroche visqueuse courte et nette |
| Traction | Tension continue qui cesse avec la libération |
| Morsure et mêlée | Impact percutant, dents et matière, synchronisé au contact |
| Première/deuxième marque | Petit dépôt organique ; discrète montée en intensité |
| Explosion de contamination | Convergence, éclatement bref et impulsion grave |
| Soin confirmé | Réabsorption courte, distincte du dégât |
| Déploiement d’armure | Enveloppement et épaississement de matière |
| Impact sur armure | Réaction amortie, limitée pour ne pas jouer chaque frame |
| Retrait d’armure | Relâchement et retour au skin normal |
| Départ du parasite | Séparation humide et petit appel organique |
| Accrochage/retour/fusion | Trois étapes reconnaissables |
| MAX | Déploiement massif, capture, morsure finale, rétraction et ponctuation du titre |

Les variations de hauteur et de gain restent modérées. Une variation aléatoire ne doit pas modifier la durée d’une séquence critique sans prise en compte dans la synchronisation.

### 11.3 Livraison et ID Roblox

Livrer les WAV sources, une correspondance entre fichiers et événements, ainsi qu’un moyen simple de les écouter avant l’installation.

L’utilisateur a récemment privilégié un seul WAV regroupant plusieurs effets pour SuperCrax. Pour SymbiotiCrax, proposer ce conditionnement pratique si cela convient : un WAV unique avec des séparations propres et une table exacte des débuts/fins de chaque passage. Cette préférence de livraison ne remplace pas la validation des nouveaux sons.

Si un atlas audio unique est retenu :

- Chaque effet utilise sa plage ; ne jamais jouer toute la compilation à chaque attaque.
- Les boucles restent à l’intérieur de leur segment.
- Les sons courts s’arrêtent avant le segment suivant, indépendamment du framerate.
- Plusieurs événements simultanés doivent pouvoir lire indépendamment le même asset.
- Le fichier importé doit correspondre aux horodatages livrés.

Les nouveaux ID existent seulement après import dans Roblox. Ne pas inventer d’ID, ne pas réutiliser l’ID de SuperCrax comme s’il contenait les sons de SymbiotiCrax et ne pas annoncer une intégration audio complète tant que les fichiers ne sont pas associés à des assets utilisables.

### 11.4 Validation réelle obligatoire

Prévoir un test CLIENT qui vérifie le chargement, la durée du fichier, les plages et une écoute directe. Il doit donner des diagnostics exploitables si un asset est refusé, non autorisé, incomplet ou jamais déclenché.

Vérifier ensuite le combat réel et les spectateurs : un son bien présent dans un tableau de configuration ne prouve pas qu’il est joué. Une caméra éloignée ou une arène projetée ne doit pas rendre par erreur tous les effets inaudibles.

## 12. Audit du projet avant intégration

Les noms ci-dessous viennent de l’architecture déjà observée. Ils servent de points de recherche, pas de garantie que le dernier export est identique.

| Système | Éléments historiques à examiner |
|---|---|
| Catalogue et skins | `CraxCatalog`, `CraxSkinServer`, `CraxTemplates`, `CraxPreviews`, éditeur/publieur d’aperçus |
| Combat | `ArenaMovement`, `CombatHealth`, `BiteHit`, événements de dégâts confirmés |
| Rounds | `RoundManager`, `ArenaPlayers`, état de combat et jeton de match |
| Compétences | `CraxSkillCatalog`, `CraxSkillResolver`, gestion des niveaux et validation des achats |
| Contrôles | `CraxAbilityGate`, `CraxPositionLock`, ralentissements, horloge et silence existants |
| Collection | `PlayerInventory`, `InventoryClient`, équipage et sélection serveur |
| Casino | `CraxRouletteConfig`, serveur de roulette, doublons et protections d’achat |
| Livre | `CopEmClient`, modules d’icônes, `CraxBookCinema` et système de recherche |
| Victoire et trophées | `CraxVictoryCatalog`, registre/serveur de trophées, client de victoire |
| Caméra | `ArenaCamera` et infrastructure d’exclusion des cinématiques |

Rechercher les duplications, sources actives et sauvegardes. Un module ancien dans ServerStorage ne doit pas être confondu avec le module réellement utilisé.

Ne pas restaurer un vieux catalogue complet pour ajouter un personnage. Lire et préserver la version actuelle, en particulier les correctifs de SuperCrax, InvertedCrax, KillaCrax et des autres personnages.

## 13. Architecture d’intégration proposée

Identifiant interne suggéré : `Crax_Symbioti`. Ce choix technique n’est pas un changement du nom affiché SymbiotiCrax. Le fixer une seule fois et le réutiliser partout ; vérifier les conventions réelles du projet avant de l’adopter.

Organisation suggérée, adaptable à l’existant :

- Configuration centrale : chiffres, délais, réglages ouverts, références audio et visuelles.
- Règles pures testables : compteurs, seuils, durées, progression et résolution des états.
- Adaptateur serveur : mouvements, contacts, santé, captures, ralentissements et événements.
- Présentation client : modèle animé, VFX, audio et cinématique.
- Adaptateur d’apparence et ressources du modèle.

Réutiliser le moteur existant plutôt que créer un second système autonome de dégâts et de rounds.

## 14. Autorité serveur et cycle de combat

Le serveur choisit les cibles, les délais aléatoires, les captures, les pertes de PV, les soins et les changements de vitesse. Le client ne peut pas fournir un montant de dégâts ou déclarer une capture réussie de son propre chef.

Chaque activation doit être rattachée au propriétaire, à l’arène/match, au round et à un identifiant d’activation. Un message tardif d’un ancien round doit être rejeté.

Appliquer les règles du jeu pour SILENCE, gel, pauses, invulnérabilités et capacités déjà en cours. Les comportements de référence peuvent distinguer « empêcher un nouveau déclenchement » et « annuler une action déjà lancée » ; ne pas confondre les deux.

Pour les immobilisations et captures, utiliser des raisons de verrouillage distinctes. Libérer la langue ne doit pas annuler le gel ou un autre verrou posé par un adversaire.

Nettoyer tous les états à la mort, au changement de round, à l’abandon, au départ d’un joueur, au remplacement d’un modèle et à la destruction du système. Aucun objet, son, ralentissement, marque ou contrôle ne doit rester actif après le combat.

Si plusieurs arènes fonctionnent en parallèle, empêcher tout transfert de cible, VFX, audio ou compteur entre elles.

## 15. Inventaire, sélection et aperçus

- Ajouter une entrée Épique au catalogue courant, avec 125 PV, mêlée 8 et vitesse lue depuis le Crax Sourire.
- Publier un vrai modèle de prévisualisation qui correspond au modèle de combat, pas un ancien Crax Sourire non transformé.
- Cadrer la tête entière en tenant compte de la langue et des tentacules ; éviter un zoom tellement large que le visage devient minuscule.
- Vérifier les rotations de collection, le livre, la fiche, les offres de sélection et les éventuelles silhouettes verrouillées.
- Présenter la rareté Épique avec le style et la couleur utilisés par le projet.
- Un joueur qui ne le possède pas ne doit pas pouvoir l’équiper par un appel distant.
- Préserver la règle souhaitée pour le livre : les Crax non débloqués ne doivent pas être trouvables via la loupe si cette règle fait partie du système actuel.
- Ne pas attribuer le personnage à tous les joueurs pour masquer un bug de sélection.

Les effets affichés dans l’inventaire doivent correspondre aux statuts réellement décidés et au catalogue d’effets partagé. Ne pas remplir la rubrique « Effet » avec des états internes techniques. Les noms finaux de ces statuts restent à préciser.

## 16. Casino et acquisition

Intégrer SymbiotiCrax au groupe **Épique** du tirage existant, sans changer la probabilité globale de cette rareté, le prix du casino, son délai d’achat ou les remboursements de doublons.

La répartition entre les personnages Épiques doit suivre la politique actuelle du jeu. S’il n’existe pas de règle explicite, proposer une répartition et l’exposer ; ne pas décider silencieusement que tous les Épiques ont forcément le même poids.

Vérifier l’existence du modèle et de la fiche avant de rendre le personnage tirable. Les récompenses, doublons, possession et sauvegardes doivent utiliser l’identifiant unique retenu.

Éviter une dépendance circulaire où l’échec de chargement d’une entrée nouvellement ajoutée empêche tout le casino de démarrer.

## 17. Livre de compétences et progression

- Afficher SymbiotiCrax avec son vrai aperçu, sa rareté et ses statistiques cohérentes.
- Conserver quatre évolutions : Contamination, Armure vivante, Nous sommes deux et MAX. Langue prédatrice reste le pouvoir de base, pas un cinquième achat inventé.
- Respecter les achats serveur, la possession, les niveaux, les conditions de dévoilement et les éventuels prestiges.
- Définir les prix selon le barème Épique existant lorsqu’il est clairement établi. Sinon, les laisser explicitement à régler ; ne pas copier les prix Communs par facilité.
- Prévoir des emplacements d’illustrations propres à chaque niveau et une icône de trophée MAX dorée cohérente avec les autres Crax.
- Aucun ID d’image n’est encore fourni pour ce personnage. Livrer les ressources demandées ou signaler l’emplacement manquant, sans recycler les illustrations de SuperCrax ou InvertedCrax.
- Vérifier les vignettes, les fenêtres détaillées, le trophée de page gauche, la case 4, les légendes et les éventuels aperçus 3D du trophée.
- Les descriptions doivent refléter les règles réellement implémentées, pas une ancienne version des propositions.

## 18. Sauvegardes et compatibilité

Conserver les monnaies, possessions, niveaux, trophées équipés et données existantes. Ajouter le nouveau personnage selon le schéma actuel ; ne pas changer de DataStore ou réinitialiser la progression pour simplifier le développement.

Une nouvelle entrée ne doit pas faire perdre des champs inconnus lors de l’enregistrement. Tester aussi les profils anciens qui ne connaissent pas encore SymbiotiCrax.

Si une migration est nécessaire, elle doit être limitée, explicite et reproductible, avec la justification et le comportement de retour arrière documentés.

## 19. Installation stable dans Studio

Le projet a déjà connu des régressions où certains scripts sont revenus à une ancienne version après des modifications de sources. Ne pas reproduire les installateurs qui remplacent aveuglément des fichiers entiers depuis des sauvegardes anciennes.

Pour les scripts existants et ouverts dans Studio, utiliser une lecture et une écriture synchronisées avec l’éditeur, notamment `ScriptEditorService:GetEditorSource` et `UpdateSourceAsync`, selon les possibilités de l’environnement. Vérifier le contenu réellement visible par l’éditeur et détecter les modifications concurrentes.

L’installateur doit :

1. Exiger le mode STOP pour les modifications persistantes de conception.
2. Examiner toutes les dépendances et préparer les modifications avant les écritures.
3. Valider les points de modification et les types d’objets.
4. Créer une sauvegarde des sources et attributs effectivement modifiés.
5. Ne pas échouer à cause d’une tentative de réassignation d’attributs réservés comme `RBX_ReimportId`.
6. Appliquer les changements avec des gardes contre les conflits.
7. Vérifier le résultat et restaurer les éléments modifiés si une écriture échoue.
8. Être idempotent : une seconde exécution n’ajoute pas de doublons ni de wrappers infinis.
9. Ne pas accumuler plusieurs LocalScripts actifs pour la même présentation.
10. Fournir un ordre d’import et d’exécution court et précis.

Après installation : vérifier le jeu, enregistrer, fermer puis rouvrir la place et confirmer que les changements persistent. Distinguer la sauvegarde locale de la publication dans la place existante.

## 20. Critères d’acceptation visuels

Produire des captures du modèle réellement développé, sous un éclairage comparable : face, trois-quarts correspondant à la référence, profils et arrière interprété. Les présenter comme des vues du vrai modèle, pas comme des images de concept indépendantes.

La validation doit vérifier :

- Identité Crax Sourire conservée et tête uniquement.
- Répartition asymétrique du noir et des plages blanches conforme à la vue fournie.
- Grand œil blanc correctement dessiné et raccordé au volume.
- Transition entre dents Crax et crocs symbiotiques.
- Langue épaisse, courbée, bien attachée et lisible.
- Tentacules organiques non uniformes, sans traversées flagrantes.
- Matériau noir détaillé, sans surexposition ni disparition des reliefs.
- Bouche fonctionnelle dans toutes les poses nécessaires.
- Lisibilité dans l’inventaire et le livre, et cadrage correct des accessoires.

Une fidélité insuffisante doit être corrigée sur le modèle. Des particules supplémentaires ne peuvent pas compenser une tête mal sculptée.

## 21. Scénarios de vérification fonctionnelle

| Scénario | Résultat à vérifier |
|---|---|
| Tirage casino | Personnage disponible dans le groupe Épique, autres probabilités et prix conservés |
| Profil ancien | Chargement sans perte, nouvelle entrée compatible |
| Sélection possédée/non possédée | Équipage autorisé uniquement par les règles serveur |
| Compétence de langue ratée | Rétraction propre, zéro dégât, aucun verrou résiduel |
| Capture près d’un mur | Pas de traversée ni de sortie d’arène |
| Cible morte ou partie en capture | Annulation et libération immédiates |
| Trois mêlées confirmées | Une seule explosion, compteurs consommés correctement |
| Plusieurs propriétaires | Marques, parasite et contrôles séparés |
| Armure | Seuil basé sur perte réelle ; réduction et expiration correctes |
| Parasite | Un seul actif, dégâts périodiques bornés, ralentissement non cumulatif par frame |
| Soins | Respect du maximum et des interdictions existantes |
| SILENCE et gel | Respect des règles existantes de déclenchement, durée et verrouillage |
| Fin de round/abandon | Plus aucun effet, son, compteur ou contrôle temporaire |
| MAX | Une seule scène, une seule caméra propriétaire, une victime complète |
| Audio | Sons réellement chargés et audibles aux bons événements, arrêt des boucles |
| Livre | Niveaux, prix, descriptions, images, case MAX et trophée cohérents |
| Nouvelle ouverture Studio | Sources corrigées et ressources toujours présentes |
| Autres Crax | Combat, casino, livre et cinématiques existants fonctionnent encore |

Les tests automatisés doivent cibler les risques réels : autorité serveur, dégâts uniques, fin des contrôles, durée des effets, idempotence et conservation des données. Les vérifications visuelles et audio nécessitent aussi le vrai moteur Studio.

## 22. Livrables attendus de Codex

1. Modèle 3D final de la tête et ses ressources modifiables disponibles.
2. Modèle de combat et aperçu de collection cohérents.
3. Configuration et scripts du personnage adaptés à la dernière version du jeu.
4. VFX des compétences et de l’exécution MAX.
5. Sons originaux exportés et correspondance des événements ; atlas audio si retenu.
6. Branches d’intégration dans les systèmes existants, sans régression des autres personnages.
7. Livre, descriptions et trophée reliés aux bons identifiants.
8. Installateur stable et sauvegarde/retour arrière adaptés aux modifications.
9. Guide court : quoi importer, où, puis quelle commande exécuter.
10. Résultats des vérifications, captures du vrai modèle et liste claire des points restant à valider.

## 23. Points restant à préciser avant une version définitive

- Portée, projection, ciblage, traction et récupération de Langue prédatrice.
- Confirmation des valeurs de travail de chaque compétence.
- Durée et règles exactes des marques de Contamination.
- Interaction de la morsure de compétence avec les marques.
- Traitement du seuil et du dépassement de l’Armure vivante.
- Déclenchement et récupération du parasite, et conditions de soin.
- Noms et icônes définitifs des effets dans l’inventaire.
- Nom définitif, chronologie et durée du MAX.
- Illustrations de progression et choix final du conditionnement audio.

Le document doit rester honnête sur ces points. Le niveau de finition demandé est élevé ; il n’autorise ni à inventer des décisions utilisateur, ni à annoncer des assets publiés ou un fonctionnement réel qui n’ont pas été vérifiés.
