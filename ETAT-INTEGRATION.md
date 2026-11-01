# État réel — InvertedCrax

## Ressources produites

- Modèle tête seule, scène Blender, FBX, OBJ/MTL et aperçus.
- Croix arrière et repères d’alignement pour import Studio.
- 19 WAV originaux, manifeste avec identifiants Roblox vides et générateur Python.

Les WAV sont vérifiés numériquement (format, durée, absence de saturation) ; ils n’ont pas été écoutés. Les géométries et rendus ont été contrôlés dans Blender. Aucun identifiant Roblox n’est inventé.

## Fonctionnalités non livrées

Aucun des éléments suivants n’est encore implémenté ou raccordé pour InvertedCrax :

- Catalogue Épique et statistiques 120 PV / 8 de mêlée / vitesse normale existante.
- Possession, sauvegarde, sélection, aperçu en jeu et tirage au casino.
- Achats et application des niveaux dans le livre.
- MUTE et SILENCE aux points de déclenchement de toutes les capacités.
- PIRATAGE et vulnérabilité dans le moteur et le pipeline de dégâts.
- COPIER-COLLER au troisième impact de mêlée réellement reçu.
- CTRL-Z synchronisé avec l’horloge active, la position interne et les PV.
- Cinématique de victoire ERREUR 404, VFX et lecture des sons en jeu.
- Installateur unique relançable et retour arrière des modifications du jeu.
- Tests à deux clients, sauvegarde réelle et non-régression.

Ce dépôt et l’archive de ressources ne constituent donc PAS une version jouable complète. Ils ne doivent pas être publiés comme une intégration terminée.

## Ressources Roblox nécessaires au raccordement

Importer les nouvelles pièces dans Studio sous le propriétaire de l’expérience ; transmettre ensuite leur modèle .rbxm avec les vrais MeshId pour vérifier les transformations. Les WAV s’importent séparément ; leurs futurs IDs seront configurables et leur absence ne devra pas bloquer le gameplay.

L’icône SILENCE reste à fournir. Les règles de réapplication et le cas SILENCE à la seconde 10 de CTRL-Z doivent être explicités avant une intégration complète. Ces étapes ne remplacent pas le développement et les tests du code serveur et client qui restent à faire.
