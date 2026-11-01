# InvertedCrax — version corrigée : tête seule

Cette version remplace la proposition avec un corps. Aucun sweat, bras, jambe ou chaussure dans le personnage corrigé. Le fichier précédent reste uniquement comme sauvegarde ; ne pas l'importer dans le jeu.

Conservés : les véritables coques, les dents et les yeux du Crax Sourire exporté ; tête noire vinyle, dents noires, contour du sourire et yeux blancs, X blanc courbé à l'arrière. Le visage conserve ses sommets d'origine. Le X reste la surface continue créée pour supprimer les jointures des anciens segments.

La tête est recentrée à l'origine, sans modifier son échelle. La référence originale est conservée dans une collection masquée du .blend. Les vues face/dos/trois-quarts sont des rendus réels Blender de cette version.

Fichiers :
- InvertedCrax_TeteSeule.blend : modèle éditable, référence et scène de rendu.
- InvertedCrax_TeteSeule.fbx : tête visuelle complète, pièces séparées.
- InvertedCrax_TeteSeule.obj + .mtl : export équivalent.
- InvertedCrax_Croix_IMPORT.fbx : seulement le nouveau X et les trois repères FIT_HeadCenter/FIT_Front/FIT_Up pour un futur raccordement au rig natif. Les repères ne font pas partie du personnage jouable.
- correct_head_only.py : script Blender de correction.
- validation.json : vérification des objets, des dimensions et de la conservation de la géométrie.

Pour examiner le modèle dans Studio, Play arrêté, importer InvertedCrax_TeteSeule.fbx dans un modèle temporaire séparé. Ne pas remplacer directement Crax_Monster ni les Fighter existants : un modèle visuel importé ne remplace pas à lui seul le rig et les points d'entrée du combat.

Le futur installateur utilisera la base native clonée pour garder ses conventions de combat, et le mesh de croix importé. InvertedCrax_Croix_IMPORT.fbx remplace le précédent fichier InvertedCrax_NewParts_IMPORT.fbx qui contenait le corps. Garder les noms et les pièces séparées à l'import.

Aucun catalogue, profil, script de combat ou pouvoir n'est modifié par ces fichiers. Le gameplay n'est pas encore raccordé. Les tests réalisés ici concernent la scène Blender, ses exports et la géométrie ; pas l'exécution Roblox.
