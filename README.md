# 7 Deadly Crax — InvertedCrax

Version **tête seule**, créée à partir du véritable Crax Sourire du projet Roblox. Aucun corps, bras, jambe ou chaussure. Tête noire, yeux blancs fermés, sourire à dents noires et croix blanche courbe à l’arrière.

![InvertedCrax de face](assets/invertedcrax/head-only/face.png)

[Vue de dos](assets/invertedcrax/head-only/dos.png) · [Vue de trois quarts](assets/invertedcrax/head-only/trois-quarts.png)

## Fichiers

Tous les fichiers se trouvent dans [`assets/invertedcrax/head-only`](assets/invertedcrax/head-only).

- [Archive complète](assets/invertedcrax/head-only/InvertedCrax-TeteSeule.zip).
- [Scène Blender éditable](assets/invertedcrax/head-only/InvertedCrax_TeteSeule.blend).
- [FBX de la tête complète](assets/invertedcrax/head-only/InvertedCrax_TeteSeule.fbx).
- [OBJ](assets/invertedcrax/head-only/InvertedCrax_TeteSeule.obj) et [matériaux MTL](assets/invertedcrax/head-only/InvertedCrax_TeteSeule.mtl).
- [Croix et repères pour le futur raccordement au rig natif](assets/invertedcrax/head-only/InvertedCrax_Croix_IMPORT.fbx).
- [Instructions et limites](assets/invertedcrax/head-only/LIRE-MOI.md).

La scène Blender conserve une référence originale masquée. Les aperçus sont des rendus réels du modèle. Le script Python est celui utilisé pour la correction, à titre de traçabilité ; il dépend de la scène intermédiaire précédente et de chemins de l’environnement de création. Il ne constitue pas un installateur autonome.

## Vérifications et état du jeu

Contrôle Blender : 25 pièces de tête, aucune pièce de corps, échelle conservée et écart maximal des sommets du visage inférieur à 0,000002 unité. Les rendus face/dos ont été examinés. Le détail est dans [`validation.json`](assets/invertedcrax/head-only/validation.json).

**Ces fichiers ne constituent pas encore l’intégration du personnage dans le jeu.** Les pouvoirs, le casino, les achats, la sauvegarde et la cinématique ne sont pas raccordés. Aucun test dans Roblox Studio ou à deux clients n’est annoncé.

Pour examiner le modèle, importer le FBX complet dans un modèle temporaire, avec Play arrêté. Ne pas remplacer directement les combattants ou le Crax Sourire original. Les trois objets `FIT_…` du fichier de croix sont uniquement des repères techniques à retirer des futures copies jouables.

## Audio et archive de ressources

[19 WAV et générateur](assets/invertedcrax/audio) · [Archive de toutes les ressources produites](dist/InvertedCrax-Ressources.zip) · [État détaillé des fonctionnalités manquantes](ETAT-INTEGRATION.md).

Cette archive contient les ressources réalisées ; elle ne contient pas de gameplay InvertedCrax terminé.
