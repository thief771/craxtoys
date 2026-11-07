# PolariCrax V2 — mise à jour dans le jeu ouvert

Exécuter la nouvelle commande Studio, **Play arrêté**. Elle choisit la mise à jour si `ServerStorage.PolariCrax_Backup_V1` existe ; sinon, elle utilise l’installateur complet à jour. Aucune copie de place n’est nécessaire.

- **Base :** noyau cyan lumineux, halo violet, deux couronnes sur ordinateur, ailettes, traînée ionique plus large et particules. Anticipation et rotation du projectile renforcées. Pas de nouvel asset à publier.
- **Niveau 1 :** mur d’attraction conservé, halo et surbrillance de la cible, lignes magnétiques plus épaisses. Le premier contact du mur pendant chaque activation inflige **8 dégâts**. Les contacts suivants de la même activation ne répètent pas les dégâts.
- **Niveau 2 :** pouvoir indépendant de l’attraction. Choix uniforme parmi les quatre murs, **1,5 s de charge**, puis **3 s actives**. Collision ennemie : **15 dégâts** et projection vers l’intérieur de l’arène, une fois par cible et activation. Une collision pendant la charge ne fait pas de dégâts. Le mur reste actif jusqu’à la fin des trois secondes.
- **Niveau 3 :** grand cadran et avertissement au-dessus de la cible, cinq éclats annoncés plus lumineux, maintien des positions/vitesses côté serveur et des parties visibles côté client pendant **1,2 s**. Fenêtre d’esquive de **0,35 s**, puis cinq tirs à **6 dégâts**, au plus trois touches par cible (**18 maximum**). Première activation après **5–7 s actives** ; suivantes après **22–28 s actives**. Le niveau est relu pendant le combat pour prendre en compte une amélioration acquise après l’initialisation.

Les contrôles de déplacement restent limités au combat en cours. La pause conserve les autres motifs de verrouillage et restaure les mêmes trajectoires. L’affichage prend en compte le registre des corps visuels détachés lorsqu’il est disponible. Les effets mobiles ont moins de géométrie et de particules ; leur mécanique est identique.

Le délai autonome du mur aléatoire reste un réglage de prototype : **12–16 s actives**, avec un nouveau délai après la fin de son cycle de charge/activation. Les niveaux restent cumulatifs : attraction et mur aléatoire sont deux effets distincts.

## Protection de la place actuelle

La mise à jour vérifie toutes les sources enregistrées dans la sauvegarde V1 avant écriture. Une édition humaine non fusionnée provoque un refus explicite. Elle remplace uniquement les modules Polari et ajoute un petit complément aux descriptions des catalogues actuels. Les scripts de combat des autres personnages ne sont pas remplacés.

`ServerStorage.PolariCrax_Update_V2_Safety` conserve les sources précédant la mise à jour. Les entrées `Installed` de la sauvegarde principale sont actualisées pour que le retour arrière complet Polari reste cohérent. Une erreur d’écriture provoque une restauration ; une édition concurrente conserve le dossier de récupération et signale les chemins en conflit. La répétition est sans doublons.

Enregistrer puis lancer un **nouveau Play** après réussite : les modules Roblox déjà chargés doivent être rechargés. Les IDs audio et illustrations configurés dans `CraxPolariUserAssets` sont conservés ; l’atlas WAV existant reste utilisable.

## Validation

`npm test` et `npm run test:polari` exécutent les tests locaux : règles serveur, dégâts réels avec services simulés, les quatre murs et leurs délais, contacts uniques, gel et interruptions, niveau modifié pendant le combat, effets client sur mobile/ordinateur, entretien des verrous externes, installation, mise à jour atomique et conflits. Le script de génération est `python3 tools/build_polari_current.py` ; les opérations sont sérialisées en préservant les sauts de ligne Lua.

Roblox Studio n’a pas été exécuté dans cet environnement. Vérifier dans une session à deux clients la lisibilité réelle du projectile, l’attraction, les délais du mur et l’immobilité visible de chaque adversaire avant publication.
