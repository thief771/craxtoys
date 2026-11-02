# Règles de SuperCrax

## Confirmées par le créateur

- Tornade : **une touche par tour**, soit jusqu’à 3 × 16 = 48 par victime si les trois passages touchent.
- Canalisation du souffle : **mobile**, sans bonus de protection.
- Après le sauvetage : **maintien strict à 1 PV**, aucun soin.
- Prix : reprendre CraxSourire, **5000/15000/30000/50000 Coins**, **30/80/150/250 Gems**. Les sources lisent la grille du catalogue existant pour rester cohérentes avec le jeu.
- Tout ce qui est marqué validé dans le [cahier des charges](CAHIER_DES_CHARGES.md), notamment rareté Commun, tête seule, 100 PV, mêlée 8, niveaux cumulatifs, laser limité à 15/s et MAX sans nouveau pouvoir.

## Choix de réalisation provisoires et exposés

Ces choix rendent le lot exécutable. Ils ne sont pas présentés comme des décisions d’équilibrage approuvées. Les paramètres numériques sont dans `ReplicatedStorage.CraxSuperConfig`, les règles de géométrie/statut dans `CraxSuperRuntime` et `CraxSuperRules`.

| Sujet | Valeur livrée |
|---|---|
| Cadence | Premier délai au début du combat actif ; suivants après la fin de l’attaque. Option `CooldownOrigin` : `End` ou `Launch`. |
| Attaques simultanées | Une seule active ; priorité à la plus anciennement prête, égalité souffle puis dash puis laser. |
| Compteur souffle | 3 mêlées ordinaires réellement dommageables, remise à zéro au départ du souffle. Option `FrostContactPolicy='MeleeAndDash'` disponible ; laser exclu. |
| Dash et brisure | `DashCanShatter=false`. Si activé, remplacement unique par 35, jamais 16 + 35. |
| Cercles | Rayon 0,8 × rayon de tête, centre aléatoire contenu dans les bords internes. Sens aléatoire. Transition d’entrée continue de 0,10 s pour éviter une téléportation au premier cercle ; déplacement angulaire de trois tours sur 1,5 s. À régler visuellement dans Studio. |
| Laser | Directions indépendantes fixées au départ ; origines aux vrais yeux ; largeur mathématique 0,065 × rayon de tête, victim radius inclus dans le test ; arrêt aux murs/occludeurs canoniques. |
| Souffle | Coin interne le plus éloigné, choisi au tir ; largeur 28 % du petit côté de l’arène (11,2 sur les dimensions inspectées 48 × 40). Affichage de la zone avec les mêmes bornes serveur. |
| SILENCE | Interdit les nouveaux départs et le premier sauvetage mortel, comme la convention inspectée du Fléau. Une attaque déjà partie continue ; une invincibilité déjà acquise reste active. Les pauses de combat utilisent la porte de statuts existante. |
| Kryptonite | Une par héros lié ; coin accessible le plus éloigné avec marge de rayon ; ramassage atomique par un ennemi ; dépôt à la dernière position du porteur s’il disparaît/meurt. Modificateur ×1,5 non cumulatif. Plusieurs cristaux restent liés à leurs héros respectifs. |
| Casino | Partage égal du poids total Commun entre les entrées Commun, Super inclus ; poids total par rareté et compensation des doublons conservés. Part individuelle à confirmer selon l’économie souhaitée. |
| Noms | « Dash circulaire », « EXÉCUTION MAX » ; aucun trophée ou récompense inédit ajouté. Le médaillon MAX reçoit son illustration propre. |
| Cinématique | 8,2 s, dont 1,5 s de charge des yeux ; durée identique au registre de victoire. |
| Visuel | Version bleue/rouge seulement ; chevelure et S adaptés à la zone du menton pour garder la vraie bouche et la tête seule. |

`LaserAim` et `FrostAim` indiquent la méthode livrée ; d’autres méthodes demanderaient du code. Le dépôt de kryptonite est la règle livrée (`KryptoniteDropOnLoss=true`), pas un système de variantes d’équipes complet. Ne pas déduire qu’un champ descriptif active une nouvelle règle de ciblage.
