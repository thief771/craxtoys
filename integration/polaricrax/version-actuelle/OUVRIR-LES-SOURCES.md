# Ouvrir le jeu et ses sources

## Dans Roblox Studio

1. Télécharger `dist/copie-jeu-PolariCrax-installe.rbxl` : ouvrir sa page GitHub et cliquer sur **Download raw file** (icône de téléchargement). Ne pas enregistrer la page Web avec « Enregistrer sous ».
2. Ouvrir Roblox Studio, puis **Fichier → Ouvrir depuis un fichier** et sélectionner le `.rbxl` téléchargé. Ne pas utiliser l’importateur de modèles 3D pour ce fichier.
3. Activer **Affichage → Explorateur**. Déplier **ServerScriptService**, **ReplicatedStorage**, ou **StarterPlayer → StarterPlayerScripts**, puis double-cliquer sur un Script, LocalScript ou ModuleScript pour lire son code.
4. Exemples : `ServerScriptService → CraxPolariRuntime` et `StarterPlayer → StarterPlayerScripts → CraxPolariClient`.

PolariCrax est déjà installé dans cette copie. Ne pas coller les sources par-dessus les scripts du jeu : les sauvegardes et raccordements sont déjà présents. Ne pas confondre les dossiers de sauvegarde de ServerStorage avec les scripts actifs.

## Sur GitHub et dans le ZIP

- Le fichier `.rbxl` et les ZIP sont binaires : GitHub ne peut pas afficher leurs sources.
- Les 29 scripts lisibles sont dans [le dossier sources](sources). Cliquer sur un fichier `.lua` pour afficher son texte, ou sur **Raw** pour le lire seul.
- Télécharger [Magneto-PolariCrax-sources.zip](../../../dist/Magneto-PolariCrax-sources.zip) avec **Download raw file**, puis extraire l’archive. Les fichiers sont rangés par service Roblox et peuvent être lus avec un éditeur de texte.
- Ce ZIP rassemble les 20 scripts adaptés et les 9 nouveaux scripts de cette intégration ; ce n’est pas l’export de tous les scripts du jeu. Les autres scripts restent dans le `.rbxl` complet.

Si Studio refuse le fichier ou n’ouvre pas un script, relever le message exact affiché : le rendu et l’ouverture dans Studio n’ont pas été vérifiés depuis cet environnement.
