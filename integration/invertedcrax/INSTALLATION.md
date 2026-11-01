# InvertedCrax — intégration pour le projet Roblox existant

## Contenu et état réel

Le code du personnage est maintenant fourni : catalogue épique (120 PV, 8 de mêlée, vitesse lue dans CraxCatalog.Crax_Monster), progression cumulative, fiche et quatre niveaux dans le livre, répartition du poids épique au casino, sélection via les catalogues existants, moteur serveur, rendu client et victoire MAX.

Ce paquet s’installe dans la place déjà analysée ; il ne remplace pas toute la place par un nouveau jeu. Il ne crée aucun DataStore ni profil parallèle, ne remet aucun profil à zéro et ne donne pas le personnage à tous les joueurs. PlayerInventory et ses magasins CraxProfiles_v1 / CraxProfiles_Studio_v1 restent inchangés. L’acquisition se fait au casino ; niveaux et possession utilisent le pipeline existant. Aucun nouveau trophée n’est ajouté.

Les ressources tête seule, .blend, FBX/OBJ, aperçus et 19 WAV sont incluses. Les rendus sont des rendus Blender réels. Le personnage jouable conserve le véritable rig natif du Crax Sourire et sa croix courbée existante, avec un traitement noir/blanc ; le FBX de tête complet sert à l’édition et à l’aperçu, et ne remplace pas directement les références de combat. La croix lissée du fichier Blender reste un export supplémentaire : aucun MeshId nouveau n’est inventé pour l’utiliser automatiquement.

**Limite de validation : aucun lancement de Studio n’est possible ici.** Les tests exécutent le Luau, les sources réelles modifiées et des objets de services simulés. Ils ne valident pas le moteur de rendu Roblox, la réplication réelle à deux clients, les DataStores ou les permissions d’assets.

## Installation — une seule commande

1. Enregistrez une copie de votre place. **Arrêtez Play.**
2. Ouvrez `INSTALLER_INVERTEDCRAX.lua` comme texte. Copiez **tout le fichier**, qui constitue UNE commande complète, dans la barre de commande de Studio et exécutez-le.
3. Attendez le message « InvertedCrax installé » puis lancez Play.

L’installateur vérifie les 21 sources concernées avant d’en changer une seule. Si une source a été modifiée depuis votre export, il s’arrête en nommant le fichier, sans écraser votre travail. Il n’écrit ni dans les autres interfaces ni dans vos données persistantes.

Il ajoute six sources, un RemoteEvent serveur vers clients, un template et un aperçu. La base Crax_Monster n’est pas modifiée. Ses pivots, pièces et conventions restent ceux du combattant existant.

Une réexécution identique ne crée aucun doublon. Si une source installée a été retouchée, la commande s’arrête plutôt que de l’écraser. En cas d’erreur pendant l’écriture, les sources déjà changées sont restaurées et les objets créés sont supprimés.

La sauvegarde est `ServerStorage.InvertedCrax_Integration_Backup_V1`. Elle contient les sources originales et les versions installées, pas des profils de joueurs.

## Sons et icône

Les 19 WAV sont dans `assets/invertedcrax/audio`. Importez-les dans Roblox sous le propriétaire de l’expérience et vérifiez leurs permissions. Aucun identifiant réel ne peut être déduit des fichiers WAV.

Dans Studio, Play arrêté, sélectionnez les objets Sound importés, nommés comme les fichiers du manifeste (par exemple MuteTrigger, CopyCapture, TeleportArrive). Exécutez ensuite tout `BRANCHER_AUDIO_ET_ICONE.lua` dans la barre de commande. Vous pouvez sélectionner un dossier contenant ces Sound.

Pour l’icône SILENCE, sélectionnez également un ImageLabel nommé `SilenceIcon` dont Image contient l’identifiant réel que vous aurez fourni. L’icône n’a pas été inventée. En son absence, un X blanc et le texte SILENCE restent affichés.

Les valeurs sont enregistrées dans les attributs de `ReplicatedStorage.CraxInvertedUserAssets`. Les réglages centraux sont lus par `CraxInvertedConfig` au lancement de Play. Une valeur manquante n’entraîne aucune attente infinie et ne bloque pas la capacité. Les WAV n’ont pas été écoutés ici ; leur format et absence de saturation numérique ont été vérifiés.

## Règles implémentées

- **MUTE** : délai serveur aléatoire de 5 à 9 secondes actives entre impulsions. Rayon mesuré entre les faces internes de Workspace.Arenaleft et Workspace.ArenaRight, divisé par deux. Dans l’export analysé : largeur utile 48, rayon 24. Aucun dégât direct. Détection par centre des cibles dans le plan X/Y canonique du moteur ; les effets sont projetés dans l’arène publique pour les spectateurs proches.
- **SILENCE** : 5 secondes actives. Contrôles ajoutés aux points de démarrage de Crax Sourire, Spidey, Ghosty, Fantastic, Plumber, Golden, Fléau et de la famille Deadly. Ils ne bloquent pas la boucle de simulation, les contacts de mêlée, les déplacements normaux ni la continuation d’une capacité déjà engagée. Les attaques composées déjà démarrées, par exemple une charge annoncée ou les tirs d’un Pulsar engagé, terminent leur séquence.
- **PIRATAGE** : 4 secondes. Nouvelle direction choisie par le serveur à l’application puis à chaque échéance d’une seconde ; le module conserve la norme de vitesse. Il modifie le mouvement existant et respecte ses immobilisations et modes prioritaires. Le moteur normal retrouve la direction courante à expiration ; il ne téléporte pas la cible et ne restaure pas arbitrairement une ancienne direction.
- **Vulnérabilité** : 5 secondes, intensité ×1,10, sans empilement. Dans la chaîne existante : ajustement de base/copied melee et des sorties → protection Fléau → renforcement Fantastic → vulnérabilité → plafonds/immunités de Deadly → arrondi final pour l’interaction Inverted/vulnérable. Les protections qui annulent entièrement l’impact restent à zéro. Une copie remplace la base avant les modificateurs et ne s’ajoute pas aux 8. Un contrecoup explicitement nul reste nul.
- **COPIER-COLLER** : troisième impact de collision/mêlée ayant réellement retiré des PV, compté depuis CombatHealth. Mémorise ce troisième montant ; ne retient pas le maximum. Une seule copie en attente ; consommation au premier impact de mêlée efficace. Les pouvoirs ne comptent pas. Les deux sens d’un contact sont traités séparément, sans événements récursifs. Les copies sortantes sont consommées avant de compter les nouvelles pertes simultanées.
- **CTRL-Z** : une seule pose à 10 secondes actives, retour à 20. Position interne et PV exacts enregistrés. Les autres délais, statuts, scores, compteurs, vitesses et forces en cours ne sont pas réinitialisés. La mort, un autre round ou la disparition du modèle annulent la balise. Pas de résurrection.
- **MAX / ERREUR 404** : utilise CraxVictoryCatalog et RoundVictoryStartedAt/Kind/EndsAt du protocole existant. Uniquement victoire de round avec niveau 4. Copies visuelles, X, noir/blanc local à la caméra, rémanences, fragments, aspiration et « 404 — CRAX NOT FOUND ». Aucun dégât ou récompense supplémentaire. Le personnage étant une tête seule, une inclinaison de tête remplace la levée de main devenue inapplicable. Caméra, transparences et indicateurs sont restaurés à la fin ou à l’interruption.

Les prix reprennent la grille existante de Crax Sourire à l’exécution : pas de nouvelle grille commerciale. La masse totale de probabilité épique est conservée et partagée avec la nouvelle entrée, conformément à la redistribution existante de Fléau ; les autres masses de rareté ne changent pas.

## Choix techniques sur les interactions non définies

Ces choix sont explicites, pas présentés comme des décisions antérieures du joueur :

- Réappliquer SILENCE, PIRATAGE et vulnérabilité rafraîchit leurs échéances sans cumuler l’intensité ni créer un deuxième contrôleur.
- Une mêlée entièrement annulée/esquivée ne charge pas le compteur et ne consomme pas une copie.
- Deux InvertedCrax copient les PV effectivement perdus ; pas de propagation récursive artificielle.
- SILENCE couvrant l’instant de pose à 10 secondes fait perdre cette occasion de CTRL-Z pour le round, plutôt que de différer la pose. Une balise déjà posée termine son retour même sous SILENCE.
- L’horloge suit les étapes actives du moteur, sa suspension globale et les pauses de capacité déjà définies pour le porteur. Les statuts suivent l’horloge active commune ; les ressources visuelles ne choisissent jamais leurs victimes ou leurs dégâts.

## Validation dans Studio — à effectuer

Sur une copie de la place, avec deux clients et des profils de test :

1. Vérifier collection, rareté Épique, 120 PV, mêlée 8 et vitesse identique à la référence commune. Vérifier l’aperçu et l’acquisition au casino sans don universel.
2. Tester chaque achat dans le livre, leur application au round suivant, puis quitter/rejoindre pour vérifier possession et niveaux persistants. Tester Coins et Gems avec des soldes de test.
3. Tester MUTE face à chaque famille : aucun nouveau déclenchement pendant SILENCE, mais une attaque déjà engagée ou un projectile lancé continue ; mêlée et mouvement restent possibles. Contrôler aussi les invocations Deadly dans/hors du rayon.
4. Tester les changements de direction pendant 4 secondes, une immobilisation prioritaire, la fin du contrôle temporaire, la vulnérabilité et les protections.
5. Faire recevoir trois mêlées distinctes à InvertedCrax : 5 puis 25 puis 12 doit charger 12 ; un pouvoir ne compte pas ; une prochaine cible protégée ne consomme pas la copie ; cible vulnérable transforme 12 en 13. Tester les deux places et deux InvertedCrax.
6. CTRL-Z : observer pose à 10 et retour à 20 secondes actives, PV restaurés à la hausse ET à la baisse, annulation par mort/fin de round, pause/reprise, SILENCE à la pose et après la pose.
7. MAX : niveau 4 seulement, victoire seulement, texte exact, aucun double déclenchement, aucune récompense additionnelle. Interrompre la scène en quittant le duel et vérifier caméra/couleurs/transparences/GUI.
8. Vérifier les sons importés, leurs permissions, leur volume, la lisibilité des VFX, puis les profils ordinateur/téléphone/tablette et les arènes publiques. Les nouveaux effets réduisent leurs émissions et fragments sur appareil tactile ; les performances réelles restent à mesurer.
9. Réexécuter l’installateur, puis tester le retour arrière sur la copie de place. Les sources retouchées après installation doivent être préservées par refus d’écrasement.

## Retour arrière

Play arrêté, exécuter tout `RETOUR_ARRIERE.lua` dans la barre de commande. Les sources doivent encore correspondre aux versions installées ; sinon la commande s’arrête avant toute restauration et demande une comparaison manuelle.

Le retour arrière retire les modules, l’événement, le template et l’aperçu ajoutés, et restaure exactement les 21 sources originales. Les possessions/niveaux déjà sauvegardés ne sont pas effacés, et le dossier d’IDs utilisateur est conservé pour une réinstallation. Le personnage ne sera plus disponible dans les catalogues d’origine.
