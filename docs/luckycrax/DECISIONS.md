# Valeurs fermes et valeurs de travail

Les valeurs fermes sont : Rare, tête seule, 105 PV, mêlée 8, Pile 12 / Face 16, intervalle de base aléatoire 6–9 secondes actives, deux dés 1–6, quatre feuilles en cœur, trois colonnes et trois signes, toujours un triplet gagnant, soin nominal 25 plafonné à 105, six pièces à 5 pendant quatre secondes chacune, Triche sept secondes. Aucune pièce visuelle ne donne de monnaie.

Les valeurs suivantes sont **provisoires**, isolées dans `src/luckycrax/CraxLuckyConfig.lua`, et ne sont pas des arbitrages validés par le créateur :

| Sujet | Prototype livré |
|---|---|
| Vitesse | celle du vrai CraxSourire existant |
| Pile/Face | 50/50, serveur uniquement ; vitesse 32, durée 3 s, deux rebonds Face |
| Dés | délai 12–16 s, animation 1,2 s, rayon 5 ; dégâts `2 × somme + 8 si double` |
| Trèfle | trois attaques distinctes réellement dommageables ; troisième coup subi ; une esquive du prochain coup pendant 4 s ; compteur remis à zéro après utilisation/expiration |
| Jackpot | délai 18–24 s, animation 1,8 s ; soin 45 %, pièces 45 %, Triche 10 % |
| Prix | grille Rare existante de SpideyCrax : 5 000 / 15 000 / 30 000 / 50 000 Coins ou 30 / 80 / 150 / 250 Gems |
| Casino | poids Rare total inchangé ; partage égal entre les membres Rare, dont Lucky ; poids des autres raretés conservés |
| MAX | proposition « LE GROS LOT », neuf secondes ; identifiant `LuckyGrandPrize` stable même si le titre change |

La Triche vise une racine ennemie principale. Elle annule les objets/états de sa famille, puis pose un blocage par source ; elle ne change pas l’identité, les achats, les PV ou le modèle de la cible. Le SILENCE d’Inverted conserve son propre état. Les adaptateurs historiques dont l’API de nettoyage est globale refusent plusieurs propriétaires vivants de la même famille : un adaptateur individuel est nécessaire pour ces compositions, plutôt que de nettoyer aussi leurs alliés.

Le trèfle conserve les identifiants d’activation à travers les callbacks asynchrones : pièces et dés Lucky, tours de dash et laser Super, langue/parasite Sym, main élastique Fantastic, saignement Ghosty, brûlure et poison Spidey. Un effet continu identifié compte une fois ; ses microticks suivants ne rechargent pas le trèfle. Les impacts historiques discrets reçoivent un identifiant de paquet, les contacts ordinaires une garde contre les doublons. Une capture Sym ou Fantastic est esquivée avant de poser sa pause ; une esquive de coupe Ghosty interdit son saignement lié. L’intégration d’une nouvelle famille doit fournir les mêmes identifiants pour ses effets continus, en plus de son adaptateur d’annulation.

Les reliefs, gravures et matériaux sont modélisés ; aucune texture photographique n’a été inventée. L’import Roblox et son éclairage peuvent différer des rendus Blender. Les PNG du livre sont transparents ; les secours textuels ne remplacent pas l’import final des images. Les WAV sont originaux et vérifiés numériquement, sans écoute humaine effectuée ici.
