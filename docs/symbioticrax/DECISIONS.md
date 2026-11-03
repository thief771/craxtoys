# Décisions et valeurs de travail

## Confirmé par le créateur

- SymbiotiCrax, Épique, vraie tête CraxSourire seule ; 125 PV, mêlée 8, vitesse normale de la base.
- Pour cette première version : langue **16** ; contamination **15** supplémentaires et soin **5** ; armure après **30 PV réellement perdus**, réduction **35 %** pendant **4 s** ; parasite **3 dégâts/s pendant 3 s**, ralentissement **25 %**, soin de retour **5**.
- Achats : reprendre le barème **GhostyCrax Épique**, 5000/15000/30000/50000 Coins ou 30/80/150/250 Gems. Les sources lisent ses quatre entrées actuelles, sans copier le Commun par défaut.

## Choix de réalisation provisoires

Ces choix rendent le lot exécutable ; ils ne sont pas présentés comme des arbitrages approuvés. Valeurs dans `ReplicatedStorage.CraxSymConfig`, règles dans `CraxSymRules` et adaptateur dans `CraxSymRuntime`.

| Sujet | Implémentation livrée |
|---|---|
| Langue | Ennemi valide le plus proche au départ ; direction fixée à ce moment, premier impact serveur sur le trajet. Préparation 0,35 s, portée 24, largeur/rayon de contact 0,65, vitesse 42, traction 18, capture maximale 2,2 s et rétraction 0,4 s. |
| Mobilité pendant langue | Lanceur maintenu par son propre verrou. Victime verrouillée et horloge de capacité suspendue pendant capture. Pas d’immunité aux dégâts donnée par la capture. |
| Collision et contrôles | Corps/hitbox natifs ; accessoires sans collision. Marges des murs et occludeurs canoniques. Une traction ne déplace que son verrou exclusif ; un second verrou interrompt la traction et reste actif. Invulnérabilité aux dégâts seule ne signifie pas immunité à la capture. |
| Récupération | 8–12 s actives pour langue, premier délai au début du round, suivants après rétraction. Un échec sans cible reporte la recherche d’une seconde. |
| Marques | Compteur par propriétaire/victime, expiration 15 secondes actives du propriétaire rafraîchie à chaque mêlée efficace. Explosion consommée une seule fois et différée sous SILENCE. Pas de dissipation volontaire ajoutée. |
| Langue et marques | `TongueMarks=false` ; seul le contact ordinaire confirmé compte. Si activé, la morsure effective peut compter, sans compter deux fois la perte pour l’armure. |
| Armure | Se déclenche après le coup faisant franchir le seuil, sur les coups suivants. Dépassement perdu ; compteur bloqué pendant protection. SILENCE garde le seuil mais exige une nouvelle perte effective pour activer ensuite. Aucun sauvetage rétroactif. |
| Parasite | Premier délai puis délai après retour : 12–16 s. Ne démarre pas pendant la langue ; un parasite déjà lancé peut continuer pendant une langue suivante. Un seul parasite par héros, ennemi valide le plus proche, vitesse 21 ; poursuite et retour bornés à 4 s chacun. |
| Ralentissement | Modificateur ×0,75, maximum une application Sym même si plusieurs parasites ciblent la victime. Multiplication avec les autres systèmes existants, sans réécrire leur vitesse de base. Retrait dès retour/annulation. |
| Soin offensif | `HealOnlyEffective=true` : aucun soin sur explosion entièrement bloquée ; parasite doit avoir retiré des PV et rejoindre son propriétaire vivant. Soin via `CraxHeal`, plafond et interdictions existants. |
| SILENCE et pauses | Nouveaux départs/armure/explosion bloqués ou différés ; actions déjà parties continuent sous SILENCE. Les pauses de capacité suspendent l’horloge concernée. Les morts et fins de round nettoient même les actions suspendues. |
| Économie casino | Politique de redistribution égale à l’intérieur du groupe Épique déjà employée par le lot Inverted. Masse totale Épique, autres raretés, prix et compensations inchangés. Poids individuel à confirmer si une autre politique est souhaitée. |
| Trophée | ID `SymbiotiTogether`, titre de travail **NOUS SOMMES SYMBIOTICRAX**, même ID au niveau 4 et registre de victoire. Le serveur existant le dérive du niveau sauvegardé, sans nouvelle récompense. |
| MAX | Durée 9 s : déploiement, capture à 2,3 s, fermeture à 4,3 s, impact à 5,1 s, rétraction à 6 s, pose/titre à 7,2 s puis restitution. Le registre et le client utilisent cette même chronologie. |
| Langue animée | Mesh continu sculpté au repos ; chaîne volumétrique de sections ellipsoïdales recouvrantes en action (10 mobile / 18 standard), attache dans la bouche, enroulement visuel. À vérifier de près dans Studio ; ce n’est pas un rig osseux importé. |
| Tentacules | Neuf meshes continus de formes variées, légère oscillation autour de racines nommées. Arrière/profondeur interprétés à partir de l’unique photo. |
| Audio | 21 sons originaux, atlas unique 13,47 s avec 120 ms entre passages ; plages natives pour lecture et boucle. Choix pratique de conditionnement, à écouter et valider. |

Les bornes, vitesses et minutages exposés peuvent être ajustés. Un autre système de ciblage, une dissipation volontaire ou un rig osseux demanderait une adaptation de code/modèle, pas seulement de changer un libellé.
