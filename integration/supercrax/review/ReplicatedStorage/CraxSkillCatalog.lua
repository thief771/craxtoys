-- SuperCraxIntegrationV1
local data=(function()
local data=(function()
-- CraxFleau v1
local data=(function()
local data = (function()
local definitions = (function()
local data=(function()
-- PlumberFix_v2
local data=(function()
-- PlumberLevels_v1
local data=(function()
-- PlumberIntegration_v1
local data=(function()
local data=(function()
-- CraxMaxHumour_v1
local data=(function()
-- CraxSimpleDescriptions_v1
local data=(function()
-- FantasticElasticSpeed_v2
local data=(function()
-- FantasticIntegration_v1
local data=(function()
-- GhostyCatalogFinal_v2
local catalog=(function()
-- ORIGINAL_CATALOG_START
-- GhostyFourLevels_v1
local catalog=(function()
-- CraxDescriptionsClaires_v10
local catalog=(function()
-- SpideyInjection_v8
local catalog=(function()
-- SpideyRules_v5
local catalog=(function()
-- SpideyRules_v4
local catalog=(function()
-- SpideyRules_v3
local catalog=(function()
-- SpideyPolishCatalog_v2
local catalog=(function()
-- SpideyCatalog_v1
local catalog=(function()
-- CraxDevourFinale_v1
local catalog=(function()
-- CopEmTongueWidth_v4
local catalog=(function()
-- CopEmTongueRange_v3
local catalog=(function()
-- Configuration unique : ajouter une entrée pour chaque futur Crax.
return {
 Crax_Monster = {
  Order=1, AbilityId = "MonsterBite", DisplayName = "Crax Sourire", Enabled = true,
  Upgrades = {
   {Id="FiveBites",Name="QUINTUPLE MORSURE",Description="Une attaque enchaîne désormais cinq coups de dents au lieu de trois.",Coins=5000,Gems=30},
   {Id="TongueSweep",Name="LANGUE FOUETTANTE",Description="Un seul balayage de langue par attaque complète, dans une direction aléatoire. Inflige 30 dégâts ; aucun vol de vie.",Coins=15000,Gems=80},
   {Id="LifeSteal",Name="FAIM SANS LIMITE",Description="Les dents rendent les PV réellement retirés à l'adversaire. Les soins peuvent dépasser les PV initiaux ; la langue ne soigne jamais.",Coins=30000,Gems=150},
  },
  -- MAX : quatrième achat, à configurer lors de l'étape animation de victoire.
  Finale = nil,
  TongueDamage=30, TongueExtraRange=6, TongueWidth=.65,
 },
 Crax_Spidey={Order=2,AbilityId="SpideyWeb",DisplayName="SpideyCrax",Enabled=false,Upgrades={}},
 Crax_Ghosty={Order=3,AbilityId="GhostNightSlash",DisplayName="GhostyCrax",Enabled=false,Upgrades={}},
}

end)()
local smile=assert(catalog.Crax_Monster, 'Crax_Monster manque')
smile.TongueReachMultiplier=2
smile.TongueWidthPremium=2.6
return catalog

end)()
assert(catalog.Crax_Monster).TongueWidthPremium=4.2
return catalog

end)()
local smile=assert(catalog.Crax_Monster,"Crax_Monster manque")
local finale=smile.Upgrades[4]or {Id="Devourer",Name="DÉVOREUR",Coins=50000,Gems=250}
finale.Description="À chaque round gagné, dévore le Crax vaincu dans une scène spéciale. Débloque le Trophée Dévoreur."
finale.TrophyId="Devourer"
smile.Upgrades[4]=finale
smile.Finale=finale
return catalog

end)()
local spider=assert(catalog.Crax_Spidey,"Crax_Spidey manque")
spider.Enabled=true
spider.Upgrades={
 {Id="DoubleSilk",Name="TRIPLE TRACTION",Description="50 % de chance : après le premier tir, deux toiles supplémentaires partent immédiatement. Leurs tractions se combinent pour accélérer plus fort et renforcer les impacts, avec des limites de vitesse et de dégâts.",Coins=5000,Gems=30},
 {Id="SilkTrap",Name="PIÈGE DE SOIE",Description="Toutes les 5 à 10 secondes, tisse une toile fixe à sa position, de la moitié de sa taille. Elle reste 7 secondes et ralentit de 40 % pendant 4 secondes un Crax qui y entre. Maximum 3 toiles par Spidey ; effet non cumulable. Le poseur doit sortir avant de pouvoir déclencher sa propre toile.",Coins=15000,Gems=80},
 {Id="Venom",Name="VENIN ARACHNÉEN",Description="Une critique qui retire des PV injecte un venin : 3 ticks de 4 dégâts sur 3 secondes. Les venins ne se cumulent pas. Les protections de Ghosty restent actives.",Coins=30000,Gems=150},
 {Id="Weaver",Name="TISSEUR",Description="À chaque round gagné : lance un fil, disparaît vers cinq positions de plus en plus vite, enveloppe entièrement le vaincu puis prend sa pose de victoire. Débloque le Trophée TISSEUR.",Coins=50000,Gems=250,TrophyId="Weaver"},
}
spider.Finale=spider.Upgrades[4]
return catalog
end)()
local s=assert(catalog.Crax_Spidey)
s.Upgrades[1].Description="50 % de chance de tirer deux fils rouges supplémentaires immédiatement. Le boost augmente instantanément la vitesse ; la traction accélère davantage et les dégâts sont calculés d'après la vitesse, avec un plafond."
s.Upgrades[2].Description="Une toile de la taille d'un Crax, épaisse et très visible, à sa position toutes les 5 à 10 secondes. Reste 7 secondes. Ralentit de 40 % pendant 4 secondes ; maximum 3 toiles, effets non cumulables."
s.Upgrades[3].Description="Sur une critique : s'accroche à l'adversaire pendant 1 seconde et le pique, puis injecte un venin de 3 ticks de 4 dégâts. EMPOISONNÉ, particules vertes et tic à chaque perte de PV."
s.Upgrades[4].Description="À chaque victoire de round, vingt téléportations de plus en plus rapides tissent un cocon complet avant la pose TISSEUR."
return catalog
end)()
local s=assert(catalog.Crax_Spidey)
s.Upgrades[1].Name="DOUBLE FIL"
s.Upgrades[1].Description="Le premier tir est blanc. Après avoir heurté un Crax ou un mur, 50 % de chance de tirer immédiatement une seconde toile rouge, avec une traction plus forte. Aucun troisième tir automatique."
s.Upgrades[2].Description="Pose une toile de la taille d'un Crax toutes les 5–10 secondes. Un passage la consomme. Le Crax touché est ralenti de 40 % pendant 4 secondes, entouré de soie et de flèches orange vers le bas. Maximum 3 toiles ; effet non cumulable."
s.Upgrades[3].Description="Après une critique validée, s'accroche au Crax pendant une seconde et le pique avec un dard visible. Injecte ensuite un venin de 3 ticks de 4 dégâts ; EMPOISONNÉ, particules vertes et tic à chaque tick effectif."
return catalog
end)()
local s=assert(catalog.Crax_Spidey)
s.Upgrades[1].Name="DOUBLE FIL"
s.Upgrades[1].Description="Le premier tir est blanc. Après avoir heurté un Crax ou un mur, 50 % de chance de tirer immédiatement une seconde toile rouge, avec une traction plus forte. Aucun troisième tir automatique. Dégâts calculés selon la vitesse : plafond 25 pour le blanc, 40 pour le rouge."
s.Upgrades[2].Description="Pose une toile de la taille d'un Crax toutes les 5–10 secondes. Spidey traverse les toiles sans les déclencher ni être ralenti. Un autre Crax la consomme en passant. Le Crax touché est ralenti de 40 % pendant 4 secondes, entouré de soie et de flèches orange vers le bas. Maximum 3 toiles ; effet non cumulable."
s.Upgrades[3].Description="Après une critique validée, s'accroche au Crax pendant trois secondes et le pique avec un dard articulé. Aucune nouvelle injection tant que la cible est empoisonnée. Injecte ensuite un venin de 3 ticks de 4 dégâts ; EMPOISONNÉ, particules vertes et tic à chaque tick effectif."
return catalog
end)()
local s=assert(catalog.Crax_Spidey)
s.Upgrades[1].Name="DOUBLE FIL"
s.Upgrades[1].Description="Le premier tir est blanc. Après avoir heurté un Crax ou un mur, 50 % de chance de tirer immédiatement une seconde toile rouge, avec une traction plus forte. Aucun troisième tir automatique. Dégâts calculés selon la vitesse : plafond 25 pour le blanc, 40 pour le rouge."
s.Upgrades[2].Description="Pose une toile de la taille d'un Crax toutes les 5–10 secondes. Le propriétaire traverse ses propres toiles sans les déclencher. Tout adversaire, y compris un Spidey ennemi, la consomme en passant. Le Crax touché est ralenti de 40 % pendant 4 secondes, entouré de soie et de flèches orange vers le bas. Maximum 3 toiles ; effet non cumulable."
s.Upgrades[3].Description="Après une critique validée, applique les dégâts critiques puis s'accroche au Crax avec deux pattes pendant trois secondes et le pique avec un dard en crochet. Aucun autre pouvoir ne peut se déclencher pendant l'injection. Aucune nouvelle injection tant que la cible est empoisonnée. Injecte ensuite un venin de 3 ticks de 4 dégâts ; EMPOISONNÉ, particules vertes et tic à chaque tick effectif."
return catalog
end)()
catalog.Crax_Spidey.Upgrades[3].Description="Après une critique, serre l'adversaire avec deux pattes et plante un dard en crochet. Accrochage et injection : 1,4 seconde. Les pouvoirs ennemis sont mis en pause puis reprennent leurs délais au relâchement. Poison : quatre ticks de cinq PV. Aucune nouvelle injection sur une cible encore empoisonnée."
return catalog
end)()
local descriptions={
Crax_Monster={
[====[Chaque attaque enchaîne 5 morsures au lieu de 3.
Chaque morsure peut toucher l’adversaire s’il est à portée.]====],
[====[Ajoute un seul coup de langue à chaque attaque complète, dans une direction aléatoire.
Si la langue touche l’adversaire, elle lui retire 30 PV et le repousse. Elle ne rend aucun PV.]====],
[====[Chaque morsure te rend autant de PV qu’elle en retire réellement à l’adversaire.
Exemple : une morsure qui retire 15 PV te rend 15 PV. Tes PV peuvent dépasser leur valeur de départ.
La langue et les collisions ne te soignent pas.]====],
[====[À chaque round gagné, Crax Sourire dévore le Crax vaincu dans une scène de victoire.
Débloque aussi le trophée DÉVOREUR, que tu peux équiper hors de l’arène.]====]
},
Crax_Spidey={
[====[Après la collision d’une première traction avec un mur ou un Crax : 1 chance sur 2 de tirer aussitôt un second fil rouge.
Ce fil accélère davantage Spidey. Plus il percute vite, plus il fait de dégâts : jusqu’à 25 avec le fil blanc et 40 avec le rouge.
Ce bonus ne déclenche pas de troisième fil.]====],
[====[Toutes les 5 à 10 secondes, pose une toile de la taille d’un Crax à sa position. Elle reste 7 secondes, avec au maximum 3 toiles présentes.
Le premier ennemi qui la traverse la consomme et perd 40 % de sa vitesse pendant 4 secondes. Cela fonctionne aussi sur un Spidey ennemi.
Tes propres toiles ne te ralentissent jamais. Les ralentissements ne se cumulent pas.]====],
[====[Quand Spidey percute l’ennemi attrapé par son fil, il inflige d’abord les dégâts critiques, puis le serre et le pique pendant 1,4 seconde.
Pendant l’injection, les pouvoirs de l’ennemi sont en pause ; Spidey ne peut ni tirer un fil ni poser un piège. Les délais reprennent au relâchement.
Ensuite, le poison retire 5 PV par seconde pendant 4 secondes : 20 PV au total.
Si l’ennemi est déjà empoisonné, une nouvelle critique fait ses dégâts, sans nouvelle injection ni renouvellement du poison.]====],
[====[À chaque round gagné, Spidey se téléporte 20 fois de plus en plus vite autour du vaincu, l’enveloppe entièrement dans un cocon, puis prend sa pose de victoire.
Débloque aussi le trophée TISSEUR, que tu peux équiper hors de l’arène.]====]
},
}
for id,list in pairs(descriptions)do
 local spec=assert(catalog[id],id.." manque")
 for n,text in ipairs(list)do assert(spec.Upgrades[n],id.." niveau "..n.." manque").Description=text end
 if spec.Finale then spec.Finale.Description=list[4]end
end
return catalog

end)()
local ghost=assert(catalog.Crax_Ghosty,"Crax_Ghosty manque")
ghost.Enabled=true
ghost.Upgrades={
 {Id="BackKnife",Name="LAME FANTÔME",Coins=5000,Gems=30,
  Description="Hors nuit, lance un couteau toutes les 5 secondes, toujours à l’opposé de son déplacement. Une touche retire 30 PV et provoque un saignement de 10 PV, sans cumul."},
 {Id="GrandFrisson",Name="GRAND FRISSON",Coins=15000,Gems=80,
  Description="Une nuit sur deux devient Grand frisson pendant 5 secondes : jumpscare, aura de flammes violettes, vitesse ennemie divisée par deux et pouvoir adverse en pause. Chaque nouveau contact avec Ghosty retire 50 PV."},
 {Id="DeathEscape",Name="ÉCHAPPÉE SPECTRALE",Coins=30000,Gems=150,
  Description="Une fois par round, esquive un contact qui devrait le tuer et se téléporte derrière l’adversaire. Ne protège pas des projectiles, morsures, entailles ou saignements."},
 {Id="GhostExecution",Name="EXÉCUTION FANTÔME",Coins=50000,Gems=250,
  Description="À chaque round gagné, Ghosty poignarde le Crax vaincu puis le coupe en deux dans une cinématique de victoire."},
}
ghost.Finale=ghost.Upgrades[4]
return catalog

-- ORIGINAL_CATALOG_END
end)()
local ghost=assert(catalog.Crax_Ghosty)
ghost.Enabled=true
ghost.Upgrades={
 {Id="BackKnife",Name="LAME FANTÔME",Coins=5000,Gems=30,Description="Hors nuit, lance un grand couteau à l’opposé de son déplacement toutes les 3 secondes. Une touche retire 30 PV ; le couteau reste planté 1 seconde, avec un indicateur sur la cible et a 25 % de chance d’appliquer 10 PV de saignement, sans cumul."},
 {Id="GrandFrisson",Name="GRAND FRISSON",Coins=15000,Gems=80,Description="Une nuit sur deux : au retour du jour, Ghosty déclenche un jumpscare puis Grand Frisson pendant 5 secondes. Flammes et fumée violettes, vitesse ennemie divisée par deux et pouvoirs ennemis en pause. Chaque nouveau contact retire 50 PV. Ghosty continue à lancer ses couteaux. Après le Grand Frisson, aucune nouvelle nuit pendant au moins 10 secondes."},
 {Id="DeathEscape",Name="ÉCHAPPÉE SPECTRALE",Coins=30000,Gems=150,Description="Une fois par round, esquive tout dégât mortel, même celui d’un pouvoir. Disparaît dans une fumée violette et noire, réapparaît derrière l’adversaire et reprend sa direction initiale."},
 {Id="GhostExecution",Name="EXÉCUTION FANTÔME",Coins=50000,Gems=250,TrophyId="GhostExecution",Status="EXÉCUTION FANTÔME • MAX",Description="À chaque round gagné : le vaincu terrorisé regarde à gauche puis à droite deux fois. Ghosty surgit d’une fumée noire, le surprend, le coupe diagonalement en deux puis danse. Débloque le statut MAX · EXÉCUTION FANTÔME dans l’inventaire et le livre, avec l’icône de trophée commune."},
}
ghost.Finale=ghost.Upgrades[4]
return catalog

end)()
local base=data.Crax_Ghosty or data.Crax_Monster
local function price(i,key)local upgrade=base and base.Upgrades and base.Upgrades[i];return upgrade and upgrade[key]or (key=="Coins"and ({5000,15000,30000,50000})[i]or ({30,80,150,250})[i])end
local spec={Order=4,AbilityId="FantasticRock",DisplayName="FantastiCrax",Enabled=true,Upgrades={
 {Id="FantasticTorch",Name="TORCHE HUMAINE",Description="Chaque 40 PV réellement perdus : s’enflamme pendant 7 secondes. Au contact, inflige 20 dégâts par ennemi et par seconde, avec BRÛLURE garantie : 5 dégâts par seconde pendant 3 secondes. Une nouvelle brûlure rafraîchit la durée sans cumul.",Coins=price(1,"Coins"),Gems=price(1,"Gems")},
 {Id="FantasticInvisibility",Name="INVISIBILITÉ",Description="Une fois par round, devient prioritaire à 15 secondes. Attend la fin des effets actifs puis devient fantomatique, traverse les Crax et ignore tous les dégâts pendant 3 secondes, en récupérant progressivement 20 PV. Les autres délais sont mis en pause.",Coins=price(2,"Coins"),Gems=price(2,"Gems")},
 {Id="FantasticElasticity",Name="ÉLASTICITÉ",Description="Après 5 à 10 secondes, puis après chaque utilisation : s’immobilise et déploie une main élastique pendant 4 secondes, vitesse 21, zigzags et rebonds sur les murs. Elle capture le premier ennemi et retrace exactement son chemin pour le ramener au contact, avec 2 dégâts toutes les 0,5 seconde pendant le retour. Cumulable avec Torche Humaine et Renforcement.",Coins=price(3,"Coins"),Gems=price(3,"Gems")},
 {Id="FantasticFinale",Name="FANTASTIC",TrophyId="Fantastic",Status="FANTASTIC • MAX",Description="Débloque le titre FANTASTIC et la finale : approche invisible, bras invisible qui ligote le vaincu, embrasement et désintégration en poussière, puis pose victorieuse avec une main élastique enflammée et une demi-tête translucide.",Coins=price(4,"Coins"),Gems=price(4,"Gems")}}}
spec.Finale=spec.Upgrades[4];data.Crax_Fantastic=spec

return data
end)()
local s=data.Crax_Fantastic
if s and s.Upgrades and s.Upgrades[3]then s.Upgrades[3].Description="Déploie pendant 4 secondes une main gantée blanche et un bras bleu élastique à vitesse 90. Trajectoire droite, rebonds sur les murs. Capture le premier Crax, puis revient par le chemin inverse : 2 dégâts toutes les 0,5 seconde. Les doigts se referment lors de la capture."end
return data
end)()
local descriptions = {
	Crax_Monster = {
		"Chaque attaque passe de 3 à 5 morsures.",
		"Ajoute un coup de langue à chaque attaque : 30 dégâts et repousse l’ennemi. La langue ne soigne pas.",
		"Les morsures rendent autant de PV que les dégâts réellement infligés. Peut dépasser les PV de départ. La langue et les collisions ne soignent pas.",
		"Débloque le trophée DÉVOREUR et une scène de victoire où il dévore le vaincu.",
	},
	Crax_Spidey = {
		"Après un impact contre un mur ou un Crax : 50 % de chance de tirer un second fil, plus puissant.\nDégâts selon la vitesse : maximum 25 avec le fil blanc et 40 avec le rouge.",
		"Toutes les 5 à 10 secondes, pose une toile qui reste 7 secondes. Maximum 3 toiles.\nLe premier ennemi qui la traverse la consomme : vitesse réduite de 40 % pendant 4 secondes. Tes propres toiles ne te ralentissent pas.",
		"Après un impact critique, attrape et pique l’ennemi pendant 1,4 seconde. Les pouvoirs de la cible sont en pause pendant l’injection.\nPoison : 5 dégâts par seconde pendant 4 secondes, soit 20 au total. Ne renouvelle pas un poison déjà actif.",
		"Débloque le trophée TISSEUR et une scène de victoire où il enferme le vaincu dans un cocon.",
	},
	Crax_Ghosty = {
		"Hors nuit, lance un couteau derrière lui toutes les 3 secondes : 30 dégâts.\nLe couteau reste planté 1 seconde. 25 % de chance d’infliger un saignement : 10 dégâts en 10 secondes, sans cumul.",
		"Une nuit sur deux, au retour du jour : jumpscare et Grand Frisson pendant 5 secondes.\nVitesse ennemie divisée par 2, pouvoirs ennemis en pause et 50 dégâts à chaque nouveau contact. Les couteaux restent actifs.\nLa prochaine nuit attend au moins 10 secondes après cet effet.",
		"Une fois par round, esquive n’importe quel dégât mortel, y compris un pouvoir.\nSe téléporte derrière l’ennemi et conserve sa direction de déplacement.",
		"Débloque le statut EXÉCUTION FANTÔME et une scène de victoire où Ghosty surgit de la fumée, tranche le vaincu puis danse.",
	},
	Crax_Fantastic = {
		"Tous les 40 PV perdus, s’enflamme pendant 7 secondes.\nAu contact : 20 dégâts par seconde et Brûlure garantie. La brûlure inflige 5 dégâts par seconde pendant 3 secondes.",
		"Une fois par round, après 15 secondes : attend la fin des pouvoirs actifs, puis devient intouchable pendant 3 secondes et récupère progressivement 20 PV.\nTraverse les Crax. Les autres pouvoirs et leurs délais sont en pause.",
		"Toutes les 5 à 10 secondes après le début du round ou la fin du bras, déploie une main qui cherche un ennemi pendant 4 secondes.\nLa main l’attrape et le ramène : 2 dégâts toutes les 0,2 seconde pendant le retour.\nFantastiCrax reste immobile et ne peut pas être déplacé. Cumulable avec Renforcement et Torche humaine.",
		"Débloque le titre FANTASTIC et une scène de victoire : arrive translucide, ligote le vaincu avec son bras, le brûle en cendres puis danse.",
	},
}
for id, list in pairs(descriptions) do
	local spec = assert(data[id], id .. " absent")
	for level, description in ipairs(list) do
		assert(spec.Upgrades[level], id .. " niveau absent").Description = description
	end
	if spec.Finale then spec.Finale.Description = list[4] end
end

return data
end)()
local descriptions={
 Crax_Monster="Tu as tout acheté. Il a tout mangé. Même le ticket de caisse.",
 Crax_Spidey="Toutes les compétences sont débloquées. Pour te remercier, Spidey t’a tricoté un pull. Tu es encore dedans.",
 Crax_Ghosty="Tu lui as offert tous ses pouvoirs. Ghosty te remercie avec un sourire sous sa capuche. Enfin… on espère que c’est un sourire.",
 Crax_Fantastic="Tu as financé ses quatre pouvoirs. Pour te remercier, il prépare le barbecue, tend le bras pour servir et disparaît au moment de faire la vaisselle.",
}
for id,description in pairs(descriptions)do local s=assert(data[id]);assert(s.Upgrades[4]).Description=description;if s.Finale then s.Finale.Description=description end end
return data

end)()
local prices=assert(data.Crax_Ghosty).Upgrades
local upgrades={
 {Id="DeadlyGreatFamily",Name="GRANDE FAMILLE",Description="À partir de 4 membres vivants : +2 dégâts au contact, +2 vitesse et +5 PV maximum pour tous. Soigne 5 PV une seule fois par membre et par round. Le bonus cesse sous le seuil de 4."},
 {Id="DeadlyAssimilation",Name="IL ARRIVE",Description="VOID assimile au contact un seul allié par round, hors OG et hors salve PULSAR. DOMINO : quadrillage 0 à 8 ; PARKER : 12 charges vers des directions aléatoires, un rebond par bord touché ; 25 dégâts et BRÛLURE sur chaque cible du trajet ; DODGER : PV alliés figés ; VICE : portails roses avec soin ; STACK : croissance. La mort assimilée renforce STACK. Chaque salve de VOID conserve exactement 3 grandes vagues dirigées, sans tête chercheuse, à traînée violette et recul à l’impact."},
 {Id="DeadlySevenSins",Name="LES 7 PÉCHÉS CAPITAUX",Description="Une fois par round, les 7 vivants déclenchent un avertissement rouge de 4 secondes ; une mort annule cet avertissement. Puis rassemblement de 5 secondes et flash de 2,5 secondes. OG repart du centre dans une direction aléatoire, les 6 autres tournent autour de lui. OG : 130 PV, vitesse rapide et 40 dégâts pendant 15 secondes. Traînée de 5 dégâts/s et ralentissement 40 %. Laser annoncé 4 secondes, puis 50 dégâts toutes les 0,3 seconde durant 4 secondes. Retour aux PV et stats précédents après un second flash. Prioritaire sur l'assimilation."},
 {Id="DeadlyFather",Name="PÈRE DE FAMILLE",TrophyId="DeadlyFather",Status="PÈRE DE FAMILLE • MAX",Description="À chaque round gagné, la famille encercle le perdant. PARKER le replace d'un coup de boule ; OG l'envoie dans un portail émeraude, noir et violet. Sept petites têtes, une très grande leçon de famille."},
}
for i,u in ipairs(upgrades)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end
data.Crax_Deadly={Order=5,AbilityId="DeadlyFamily",DisplayName="7 Deadly'Crax",Enabled=true,Upgrades=upgrades,Finale=upgrades[4]}
return data

end)()
data.Crax_Plumber={Order=6,AbilityId='PlumberPipe',DisplayName='CraxPlumber',Enabled=false,Upgrades={}}
return data

end)()
local upgrades={
{Id='PlumberPressure',Name='SURPRESSION',Coins=5000,Gems=30,Description="Dès quatre tuyaux posés, chaque sortie déclenche un jet traversant l'arène pendant 2 secondes. Il repousse les ennemis et inflige 15 dégâts toutes les 0,2 seconde de contact."},
{Id='PlumberPiranha',Name='PLANTE PIRANHA',Coins=15000,Gems=80,Description="Avec six tuyaux, une plante apparaît toutes les 5 secondes dans un tuyau libre. Après sa sortie, elle mord six fois en 3 secondes : 10 dégâts par morsure touchant un ennemi. Plumber reste prioritaire."},
{Id='PlumberStar',Name='STARRRRR',Coins=30000,Gems=150,Description="Toutes les 10 secondes : 50 % de chance qu'une étoile sorte d'un tuyau. Elle rebondit 5 secondes. Si Plumber l'attrape : invulnérabilité, vitesse fortement augmentée et 40 dégâts au contact pendant 7 secondes."},
{Id='Mamamia',Name='MAMAMIA',Coins=50000,Gems=250,TrophyId='Mamamia',Description="Débloque le trophée MAMAMIA. À chaque victoire de round : sortie du tuyau, étoile avalée, enlèvement du vaincu puis énorme jet d'eau arc-en-ciel. Aucun nouveau pouvoir de combat."},
}
data.Crax_Plumber={Order=6,AbilityId='PlumberPipe',DisplayName='CraxPlumber',Enabled=true,Upgrades=upgrades,Finale=upgrades[4]}
return data

end)()
local s=assert(data.Crax_Plumber,'Plumber absent du catalogue')
s.Upgrades[1].Description="Dès quatre tuyaux, chaque sortie déclenche un jet traversant l'arène pendant 2 secondes. Les ennemis rebondissent contre le jet comme sur un mur. Un contact inflige 5 dégâts, au maximum une fois toutes les 0,4 seconde par jet."
s.Upgrades[4].Name='MAMAMIA';s.Upgrades[4].Status='MAMAMIA • MAX';s.Upgrades[4].TrophyId='Mamamia';s.Finale=s.Upgrades[4]
return data

end)()
-- GoldenBook-2.0
local base=data.Crax_Plumber
local prices=base and base.Upgrades or {}
local descriptions={
 {Id='GoldenMidasPunch',Name='POING DE MIDAS',Description='Toutes les 8 secondes, Golden s’immobilise 1 seconde puis lance un poing d’or vers la dernière position de sa cible au moment du tir. 25 dégâts et +30 % de dorure. Le poing ne poursuit pas sa cible.'},
 {Id='GoldenBillionaire',Name='BILLIONNAIRE',Description='Un lingot rejoint son orbite toutes les 10 secondes, jusqu’à 3. Chaque lingot inflige 10 dégâts, repousse l’ennemi touché puis disparaît.'},
 {Id='GoldenTears',Name='DE L’OR ET DES LARMES',Description='À 60 PV ou moins, une cascade d’or tombe du toit pendant 10 secondes avant de changer de place. 1 dégât toutes les 0,2 seconde et +1 % de dorure toutes les 0,5 seconde de contact. Un soin au-dessus de 60 PV arrête immédiatement l’effet.'},
 {Id='TrueWealth',Name='VRAIE RICHESSE',TrophyId='TrueWealth',Description='MAX EN PRÉPARATION : volcan doré, chute du vaincu dans l’or en fusion puis baignade de Golden avec bouée bleue et blanche et cocktail. Achat bloqué tant que la scène n’est pas installée.'},
}
local defaults={{5000,30},{15000,80},{30000,150},{50000,250}}
for i,u in ipairs(descriptions)do
 local p=prices[i]or {};u.Coins=p.Coins or defaults[i][1];u.Gems=p.Gems or defaults[i][2];u.Status=u.Name
end
data.Crax_Golden={Order=7,AbilityId='GoldenMidas',DisplayName='GoldenCrax',Enabled=true,PurchaseLimit=3,Upgrades=descriptions,Finale=descriptions[4]}
return data

end)()
-- GoldenMaxPurchase_VraieRichesse_v1
local golden = assert(
	definitions.Crax_Golden,
	"Crax_Golden absent du catalogue de compétences."
)

assert(
	type(golden.Upgrades) == "table"
		and type(golden.Upgrades[4]) == "table",
	"Le niveau 4 de Golden manque : installation interrompue."
)

local max = golden.Upgrades[4]

assert(
	(type(max.Coins) == "number" and max.Coins > 0)
		or (type(max.Gems) == "number" and max.Gems > 0),
	"Le niveau MAX ne possède aucun prix valide."
)

golden.PurchaseLimit = 4
max.Name = "VRAIE RICHESSE"

return definitions

end)()
-- GoldenTitreVraieRichesse_v1
local golden = assert(data.Crax_Golden, "Golden absent du catalogue")
assert(golden.Upgrades and golden.Upgrades[4], "Niveau MAX Golden absent")
golden.Upgrades[4].Name = "VRAIE RICHESSE"
return data

end)()
local C=require(game:GetService('ReplicatedStorage').CraxFleau.FleauRules).Config
local list={
 {Id="FleauCharge",Name="INARRÊTABLE",Description="À 30 puis 60 de rage : prépare une charge pendant 2 s avec 80 % de dégâts en moins, puis fonce en ligne droite. Une touche : 35 dégâts et 2,5 s d'étourdissement."},
 {Id="FleauGiant",Name="INCREVABLE",Description="Toutes les 10 s : 50 % de chance, une seule activation par round. Pendant 10 s : 300 PV temporaires, contact 10 et -50 dégâts sur chaque impact. Puis retrouve ses anciens PV et bloque sa rage à zéro pendant 3 s."},
 {Id="FleauFury",Name="PERSONNE N’ARRÊTE LE FLÉAU",Description="Une fois par round, survit à un coup mortel à 1 PV. Charge les murs pendant 5 s : 30 dégâts par passage. Sans victoire avant la fin, il meurt. Les soins et contrôles sont ignorés pendant la furie."},
 {Id="Buldozer",Name="BULDOZER",Description="Débloque le trophée BULDOZER et la cinématique de victoire : Fléau géant roule sur le vaincu, puis revient danser.",TrophyId="Buldozer"}}
for i,v in ipairs(list)do v.Coins=C.Prices[i];v.Gems=C.Gems[i]end
-- Prix repris du barème existant, configurables dans FleauRules.
data.Crax_Fleau={Order=8,AbilityId="FleauRage",DisplayName="Crax Fléau",Enabled=true,Upgrades=list,Finale=list[4]}
return data

end)()
local reference=assert(data.Crax_Monster).Upgrades
local definitions={
 {Id='InvertedHack',Name='PIRATAGE',Description='MUTE conserve SILENCE (5 s). Change la direction des victimes chaque seconde pendant 4 s sans changer leur vitesse. Elles reçoivent 10 % de dégâts en plus pendant 5 s, sans cumul.'},
 {Id='InvertedCopy',Name='COPIER-COLLER',Description='Au troisième impact de mêlée ayant retiré des PV, mémorise les dégâts réellement subis sur ce troisième coup. La prochaine mêlée efficace remplace ses 8 dégâts par max(8, copie), puis consomme la copie. Les pouvoirs ne comptent pas.'},
 {Id='InvertedRewind',Name='CTRL-Z',Description='Une fois par round : enregistre position et PV à 10 s de combat actif ; à 20 s, restaure exactement ces valeurs. Mort et fin de round annulent la balise. SILENCE à la pose fait perdre cette occasion ; une balise déjà posée continue.'},
 {Id='Inverted404',Name='ERREUR 404',Description='Cinématique de victoire MAX : le vaincu se fragmente dans une immense croix. 404 — CRAX NOT FOUND. Aucun pouvoir, dégât ou trophée supplémentaire.'}}
for i,u in ipairs(definitions)do local p=assert(reference[i]);u.Coins=assert(p.Coins);u.Gems=assert(p.Gems);u.Status=u.Name end
data.Crax_Inverted={Order=9,AbilityId='InvertedMute',DisplayName='InvertedCrax',Enabled=true,Upgrades=definitions,Finale=definitions[4]}
return data

end)()
assert(not data.Crax_Super,'SuperCrax existe déjà dans le livre')
local reference=assert(data.Crax_Monster).Upgrades
local upgrades={
 {Id='SuperLaser',Name='RAYON LASER',Description='Deux rayons rouges aux directions aléatoires indépendantes, pendant 2,5 s. Au maximum 15 PV/s par victime, même si les deux rayons touchent : 37,5 dégâts de base pour une exposition complète. Délai de 5 à 8 s actives après la fin.'},
 {Id='SuperFrost',Name='SOUFFLE GELÉ',Description='Après trois mêlées efficaces : canalisation mobile de 2 s, puis souffle de 3,5 s vers le coin le plus éloigné de l’arène. Gel entretenu jusqu’à 5 s après la dernière exposition. Une nouvelle mêlée de SuperCrax brise ce gel pour 35 dégâts au total, sans regel par ce même souffle.'},
 {Id='SuperInvincible',Name="L’INVINCIBLE SUPERCRAX",Description='Un dégât ordinaire mortel est intercepté avant la mort : maintien strict à 1 PV, aucun soin et protection ordinaire pour le reste du round. Les pouvoirs restent actifs. Une kryptonite liée au héros apparaît : le toucher tue le héros, même en acier. Un ennemi peut la porter pour +50 % de vitesse.'},
 {Id='SuperFinale',Name='EXÉCUTION MAX',Description='À chaque victoire de SuperCrax MAX : vol près du vaincu, congélation complète, charge rouge des yeux de 1,5 s, lasers puis éclatement de la victime et de la glace. Aucun dégât ni récompense supplémentaire.'}}
for i,u in ipairs(upgrades)do local p=assert(reference[i]);u.Coins=assert(p.Coins);u.Gems=assert(p.Gems);u.Status=u.Name end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Super={Order=order+1,AbilityId='SuperHero',DisplayName='SuperCrax',Enabled=true,Upgrades=upgrades,Finale=upgrades[4]}
return data
