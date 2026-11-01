-- INVERTEDCRAX V1 : UNE commande, Play ARRÊTÉ. Aucun reset de profil.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play avant installation.')
local function resolve(path)
 local current=game;for token in path:gmatch('[^.]+')do current=current and current:FindFirstChild(token)end;return current
end
local function hash(source)local n=5381;for i=1,#source do n=(n*33+source:byte(i))%4294967296 end;return n end
local storage=game:GetService('ServerStorage');local RS=game:GetService('ReplicatedStorage')
local backupName='InvertedCrax_Integration_Backup_V1'
local patches={
{path=[====[ReplicatedStorage.CraxCatalog]====],bytes=8499,hash=2768530650,source=[====[local data=(function()
-- ConfusionInventory_v1
local data=(function()
-- CraxFleau v1
local data=(function()
-- GoldenCatalogIntegration_v1
local data = (function()
-- PlumberIntegration_v1
local data=(function()
local data=(function()
-- CraxSimpleDescriptions_v1
local data=(function()
-- FantasticIntegration_v1
local data=(function()
local catalog = (function()
return {
 Crax_Monster = {
  DisplayName="Crax Sourire",Rarity="Commun",TemplateName="Crax_Monster",
  MaxHealth=100,Speed=25,CollisionDamage=10,
  Description="Un sourire adorable, des intentions discutables. Ne mets pas tes doigts dedans : il confond les caresses avec l'apéro.",
  PowerDescription="TRIPLE MORSURE\n\nSes yeux deviennent rouges, puis il claque des dents trois fois à toute vitesse ! Chaque morsure peut blesser un adversaire à proximité.\n\nLe cercle rouge annonce la zone dangereuse. Personne dedans ? Trois bouchées d'air. Le régime commence mal.",
  Ability={Id="MonsterBite",DisplayName="Triple morsure",Damage=25,Cooldown=3,ExtraRange=3.25},
 },
 Crax_Spidey = {
  DisplayName="SpideyCrax",Rarity="Rare",TemplateName="Crax_MasqueAraignee",
  MaxHealth=120,Speed=25,CollisionDamage=0,
  Description="Un grand sourire, une toile express et aucun respect pour les limitations de vitesse.",
  PowerDescription="TOILE EXPRESS\n\nToutes les 2,5 secondes, une toile très rapide part vers le bord opposé de l'arène. Elle propulse SpideyCrax et ses dégâts d'impact augmentent exponentiellement avec sa vitesse.\n\nSi la toile attrape l'adversaire, il est immobilisé pendant la charge : l'impact inflige un critique fixe de 28 dégâts. Les contacts ordinaires ne font aucun dégât.",
  Ability={Id="SpideyWeb",DisplayName="Toile express",Cooldown=2.5,WebSpeed=400,Acceleration=220,MaxSpeed=110,
   CriticalDamage=28,MaxDamage=24,MinDamage=4,DamageScale=35,MaxChargeTime=1,CoastTime=.65},
 },
 Crax_Ghosty = {
  DisplayName="GhostyCrax",Rarity="Épique",TemplateName="GhostyCrax",RarityColor=Color3.fromRGB(180,100,255),
  MaxHealth=100,Speed=25,CollisionDamage=5,
  Description="Un sourire sous la capuche. Quand la lumière s'éteint, il vaut mieux ne pas croiser sa ligne.",
  PowerDescription="NUIT SANGLANTE\n\nToutes les 12 secondes, la nuit tombe pendant 4 secondes. Les Crax disparaissent dans l'obscurité et les capacités, contacts et effets ne causent plus de dégâts.\n\nUn slash blanc et rouge traverse une ligne aléatoire de l'arène : 50 dégâts si l'adversaire est touché et 25 % de chance d'infliger 10 dégâts de saignement sur 10 secondes. Le slash rétablit la lumière. Ghosty est invincible pendant la nuit.",
  Ability={Id="GhostNightSlash",DisplayName="Nuit sanglante",Cooldown=12,Duration=4,Damage=50,BleedChance=.25},
 },
}

end)()
local ghost = assert(catalog.Crax_Ghosty,"Crax_Ghosty introuvable")
ghost.PowerDescription = "TOMBÉE DE LA NUIT\n\nTombée de la nuit paralyse les Crax.. puis... 5 Slash tranchants... et du saignement hehe"
ghost.Effects = table.clone(ghost.Effects or {})
if not table.find(ghost.Effects,"Bleeding") then table.insert(ghost.Effects,"Bleeding") end
return catalog

end)()
data.Crax_Fantastic={DisplayName="FantastiCrax",Rarity="LEGENDAIRE",RarityColor=Color3.fromRGB(255,204,51),TemplateName="FantastiCrax",
 MaxHealth=160,Speed=17,CollisionDamage=8,
 Description="Un sourire de pierre, quatre pouvoirs et une confiance absolument fantastique.",
 PowerDescription="RENFORCEMENT\n\nSe renforce pendant 4 secondes et divise tous les dégâts reçus par deux. Première activation après 7 à 11 secondes de combat, puis 7 à 11 secondes après la fin de chaque renforcement.",
 Effects={"Burning"},Ability={Id="FantasticRock",DisplayName="Renforcement",Duration=4,DamageMultiplier=.5,MinCooldown=7,MaxCooldown=11}}


return data
end)()
local powers = {
	Crax_Monster =
		"TRIPLE MORSURE\n\nToutes les 3 secondes, mord 3 fois les ennemis proches. Chaque morsure inflige 25 dégâts.",
	Crax_Spidey =
		"TOILE EXPRESS\n\nToutes les 2,5 secondes, une toile le propulse. Plus il va vite, plus son impact fait mal.\nSi la toile attrape un ennemi : 28 dégâts critiques. Les contacts ordinaires ne font aucun dégât.",
	Crax_Ghosty =
		"TOMBÉE DE LA NUIT\n\nToutes les 12 secondes, plonge l’arène dans le noir pendant 4 secondes. Les Crax sont paralysés et les dégâts sont suspendus.\nÀ la sortie : 5 entailles, 50 dégâts par touche et 25 % de chance de provoquer un saignement.",
	Crax_Fantastic =
		"RENFORCEMENT\n\nDivise tous les dégâts reçus par 2 pendant 4 secondes.\nS’active après 7 à 11 secondes de combat, puis 7 à 11 secondes après chaque fin de renforcement.",
}
for id, description in pairs(powers) do
	assert(data[id], id .. " absent").PowerDescription = description
end

return data
end)()
data.Crax_Deadly={DisplayName="7 Deadly'Crax",Rarity="SECRET",RarityColor=Color3.fromRGB(22,238,151),TemplateName="Crax_Deadly",
 MaxHealth=90,Speed=25,CollisionDamage=5,Description="Sept sourires, une seule famille. OG est leur cœur : sa mort emporte toute l'équipe.",
 PowerDescription="SIT'N SMILE\n\nOG : 90 PV et 5 dégâts. Un allié arrive toutes les 8 secondes ; VOID arrive à 48 secondes. Tous font la moitié d'un Crax.\nDOMINO rebondit et étourdit 1,5 seconde au contact. PARKER gagne +3 dégâts et vitesse par tranche de 10 PV perdus par OG. DODGER : 15 PV, vitesse 12 ; protège OG à 1 PV. VICE soigne OG de 5 PV toutes les 2,5 secondes. STACK gagne 20 PV par allié mort en sa présence. VOID est immortel, inflige 12 dégâts au contact et tire 3 grandes vagues destructrices de 15 dégâts, avec fumée violette et recul à l’impact, vers la position de l’ennemi enregistrée au début de la salve : première salve après 3 secondes, puis toutes les 15 secondes.",
 Effects={"Burning"},Ability={Id="DeadlyFamily",DisplayName="Sit'N Smile"}}
return data

end)()
data.Crax_Plumber={DisplayName='CraxPlumber',Rarity='Commun',TemplateName='Crax_Plumber',MaxHealth=100,Speed=data.Crax_Monster.Speed,CollisionDamage=6,
 Description='Un sourire, une casquette et six raccourcis dans la plomberie.',
 PowerDescription='TUYAU\n\nAu contact d’un mur, crée un tuyau : 6 maximum. Les tuyaux fonctionnent par paires : 1-2 verts, 3-4 oranges, 5-6 rouges.\nRetoucher un tuyau relié permet de ressortir par son partenaire. Pendant 5 secondes après la sortie : casquette blanche, C rouge, 15 dégâts au contact et vitesse augmentée.\nAucune création de tuyau sous casquette blanche. Les traversées peuvent s’enchaîner et renouvellent les 5 secondes.',
 Ability={Id='PlumberPipe',DisplayName='Tuyau'}}
return data

end)()
local base = assert(data.Crax_Monster, "Crax Sourire absent")
data.Crax_Golden = {
	DisplayName = "GoldenCrax",
	Rarity = "LEGENDAIRE",
	RarityColor = Color3.fromRGB(225, 185, 85),
	TemplateName = "Crax_Golden",

	MaxHealth = base.MaxHealth,
	Speed = base.Speed,
	CollisionDamage = base.CollisionDamage,

	Description = "Un sourire en or massif. Sa véritable richesse ? Transformer ses adversaires en pièces de collection.",

	PowerDescription = "OR LIQUIDE\n\nCrée une flaque toutes les 4 secondes : 2 maximum, pendant 9 secondes chacune.\n\nUn ennemi qui la traverse est ralenti de 60 % pendant 3,5 secondes. Dans l’or, sa dorure augmente progressivement de 10 % par seconde.\n\nÀ 100 % : il devient une statue pendant 5 secondes, reste immobilisé et ses pouvoirs sont suspendus. Il subit 1 dégât toutes les 0,2 seconde.\n\nLa dorure revient à zéro après la statue. Sans nouvelle application pendant 7 secondes, elle diminue progressivement de 1 % toutes les 0,5 seconde.",

	Ability = {
		Id = "GoldenMidas",
		DisplayName = "Or liquide",
	},
}
return data

end)()
data.Crax_Fleau={DisplayName="Crax Fléau",Rarity="Épique",RarityColor=Color3.fromRGB(180,100,255),TemplateName="Crax_Fleau",MaxHealth=145,Speed=30,CollisionDamage=8,
 Description="Une carapace massive, un grand sourire et beaucoup trop de colère.",
 PowerDescription="RAGE DU FLÉAU\nChaque PV perdu donne 2 points de rage. À 100 : le prochain contact inflige 40 dégâts au total, projette l'ennemi et vide la rage.",Ability={Id="FleauRage",DisplayName="Rage du Fléau"}}
return data

end)()
for _, id in ipairs({"Crax_Fleau", "Crax_Deadly"}) do
	local spec = assert(data[id], "Crax absent du catalogue : "..id)
	spec = table.clone(spec)
	data[id] = spec
	spec.Effects = table.clone(spec.Effects or {})
	if not table.find(spec.Effects, "Confusion") then
		table.insert(spec.Effects, "Confusion")
	end
end

return data

end)()
assert(not data.Crax_Inverted,'Crax_Inverted existe déjà')
local base=assert(data.Crax_Monster,'Base Crax Sourire absente')
data.Crax_Inverted={DisplayName='InvertedCrax',Rarity='Épique',RarityColor=Color3.fromRGB(192,116,255),TemplateName='Crax_Inverted',MaxHealth=120,Speed=assert(base.Speed),CollisionDamage=8,
Description='Un sourire noir, un silence blanc. Il pirate les directions, copie un impact et restaure un instant enregistré.',
PowerDescription='MUTE : toutes les 5 à 9 secondes actives, une onde de rayon égal à la moitié de la largeur de l’arène applique SILENCE pendant 5 secondes. Aucun dégât direct.',
Effects={'Silence'},Ability={Id='InvertedMute',DisplayName='MUTE',Damage=8,Cooldown=5}}
return data
]====]},
{path=[====[ReplicatedStorage.CraxSkillCatalog]====],bytes=27878,hash=4041584108,source=[=====[local data=(function()
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
]=====]},
{path=[====[ReplicatedStorage.CraxEffectsCatalog]====],bytes=1993,hash=158614282,source=[====[local data=(function()
-- ConfusionInventory_v1
local data=(function()
-- CraxSimpleDescriptions_v1
local data=(function()
-- FantasticIntegration_v1
local data=(function()
local effects=(function()
local effects = (function()
return {}
end)()
-- Pour créer un effet : ajoute une définition ici et son identifiant dans les Effects d'un Crax.
effects.Bleeding = {
 DisplayName = "Saignement",
 Description = "Retire 10 PV total, 1 chaque secondes",
 Icon = "BloodDrop",
 Color = Color3.fromRGB(255,108,126),
}
return effects

end)()
assert(type(effects)=="table" and type(effects.Bleeding)=="table","Définition Bleeding introuvable.")
effects.Bleeding=table.clone(effects.Bleeding)
effects.Bleeding.DisplayName="Saignement"
effects.Bleeding.Description=[=[25% de chance d'appliquer SAIGNEMENT après l'utilisation du pouvoir, SAIGNEMENT Inflige 10 Points de dégats maximum à hauteur de 1 PV par seconde pendant 10 Secondes.]=]
return effects

end)()
data.Burning={DisplayName="Brûlure",Description="BRÛLURE inflige 15 PV au total : 5 PV par seconde pendant 3 secondes. Des flammes entourent la cible. Une nouvelle application rafraîchit la durée sans cumuler plusieurs brûlures.",Icon="Flame",Color=Color3.fromRGB(255,145,35)}

return data
end)()
local burning = data.Burning or {}
data.Burning = burning
burning.DisplayName = "Brûlure"
burning.Description = "Inflige 5 dégâts par seconde pendant 3 secondes : 15 au total. Une nouvelle brûlure renouvelle la durée, sans cumul."
burning.Image = "rbxassetid://102250698602530"
burning.Icon = "Flame"
burning.Color = Color3.fromRGB(255, 145, 35)

if data.Bleeding then
	data.Bleeding.Description =
		"Inflige 1 dégât par seconde pendant 10 secondes : 10 au total. Ne se cumule pas."
end

return data
end)()
data.Confusion = {
	DisplayName = "CONFUSION",
	Description = "Immobilise l’adversaire pendant 2,5 secondes.",
	Image = "rbxassetid://106983799966926",
	Icon = "Confusion",
	Color = Color3.fromRGB(255, 215, 75),
	Duration = 2.5,
}

return data

end)()
local config=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedConfig'))
data.Silence={DisplayName='SILENCE',Description='Bloque les nouveaux déclenchements pendant 5 secondes. Ne bloque ni mêlée ni déplacement ; les capacités déjà lancées continuent.',Image=config.SilenceIcon,Icon='Silence',Color=Color3.fromRGB(244,242,232),Duration=5}
return data
]====]},
{path=[====[ReplicatedStorage.CraxRouletteConfig]====],bytes=3586,hash=3392980361,source=[====[local data=(function()
-- CraxFleau v1
local data=(function()
-- PlumberIntegration_v1
local data=(function()
-- CasinoOdds60201505_v10
local config=(function()
-- FantasticIntegration_v1
local data=(function()
local settings=(function()
-- Prix et chances modifiables. Les poids ci-dessous totalisent 100.
return {
 Price = 1000,
 Cooldown = 8,
 Pool = {
  {Id="Crax_Monster",Weight=70},
  {Id="Crax_Spidey",Weight=25},
  {Id="Crax_Ghosty",Weight=5},
 },
 DuplicateGems = {
  ["Commun"]=5,["Rare"]=7,["Épique"]=10,["Epique"]=10,
  ["LEGENDAIRE"]=20,["LEGENDAIRE"]=20,["Secret"]=50,
  ["Édition limitée"]=50,["Edition limitée"]=50,
  ["Édition Limitée"]=50,["Edition Limitée"]=50,
 },
}

end)()
settings.Price=1000
return settings

end)()
data.Pool={{Id="Crax_Monster",Weight=69},{Id="Crax_Spidey",Weight=25},{Id="Crax_Ghosty",Weight=5},{Id="Crax_Fantastic",Weight=1}}
data.DuplicateGems["LEGENDAIRE"]=20

return data
end)()
local copy={};for k,v in pairs(config)do copy[k]=v end;config=copy
local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local desired={Commun=6400000,Rare=2000000,['Épique']=1500000,['LEGENDAIRE']=100000}
local aliases={Epique='Épique',LEGENDAIRE='LEGENDAIRE'}
local groups={};for key in pairs(desired)do groups[key]={sum=0,entries={}}end
for _,entry in ipairs(config.Pool)do
 local d=catalog[entry.Id];local key=d and(aliases[d.Rarity]or d.Rarity);local g=key and groups[key]
 if g and type(entry.Weight)=='number'and entry.Weight>0 and entry.Weight<math.huge then
  g.sum=g.sum+entry.Weight;g.entries[#g.entries+1]=entry
 end
end
local pool={}
for _,key in ipairs({'Commun','Rare','Épique','LEGENDAIRE'})do
 local group=groups[key];local target=desired[key];assert(#group.entries>0,'Aucun Crax disponible pour '..key)
 assert(#group.entries<target,'Trop de Crax dans '..key)
 local remaining=target-#group.entries;local assigned=0;local allocations={}
 for i,e in ipairs(group.entries)do
  local exact=e.Weight/group.sum*remaining;local floor=math.floor(exact)
  allocations[i]={entry=e,weight=1+floor,remainder=exact-floor,index=i};assigned=assigned+1+floor
 end
 table.sort(allocations,function(a,b)if a.remainder==b.remainder then return a.index<b.index end;return a.remainder>b.remainder end)
 for i=1,target-assigned do allocations[i].weight=allocations[i].weight+1 end
 table.sort(allocations,function(a,b)return a.index<b.index end)
 for _,a in ipairs(allocations)do local e={};for k,v in pairs(a.entry)do e[k]=v end;e.Weight=a.weight;pool[#pool+1]=e end
end
config.Pool=pool

return config
end)()
local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local pool={};local common=0
for _,e in ipairs(data.Pool)do if e.Id=='Crax_Plumber'then return data end end
for _,e in ipairs(data.Pool)do
 local copy={};for k,v in pairs(e)do copy[k]=v end
 if catalog[e.Id]and catalog[e.Id].Rarity=='Commun'then common=common+e.Weight;copy.Weight=e.Weight*.5 end
 pool[#pool+1]=copy
end
assert(common>0,'Aucun COMMUN dans le casino.')
pool[#pool+1]={Id='Crax_Plumber',Weight=common*.5};data.Pool=pool
return data

end)()
local catalog=require(game:GetService('ReplicatedStorage').CraxCatalog)
local epic={};local sum=0
for _,e in ipairs(data.Pool)do if catalog[e.Id]and(catalog[e.Id].Rarity=='Épique'or catalog[e.Id].Rarity=='Epique')then epic[#epic+1]=e;sum=sum+e.Weight end end
assert(#epic>0,'Aucun poids Épique existant')
local share=math.floor(sum/(#epic+1));local used=0
for _,e in ipairs(epic)do e.Weight=share;used=used+share end
data.Pool[#data.Pool+1]={Id='Crax_Fleau',Weight=sum-used}
return data

end)()
local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local epic={};local total=0
for _,entry in ipairs(data.Pool)do
 assert(entry.Id~='Crax_Inverted','Entrée casino déjà installée')
 local d=catalog[entry.Id]
 if d and(d.Rarity=='Épique'or d.Rarity=='Epique')then epic[#epic+1]=entry;total=total+entry.Weight end
end
assert(#epic>0 and total>0,'Masse épique absente')
local share=total/(#epic+1)
for _,entry in ipairs(epic)do entry.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Inverted',Weight=total-share*#epic}
assert(data.DuplicateGems['Épique']~=nil,'Compensation épique absente')
return data
]====]},
{path=[====[ReplicatedStorage.CraxVictoryCatalog]====],bytes=6404,hash=1677452964,source=[====[local data=(function()
-- CraxFleau v1
local data=(function()
local data = (function()
local catalog=(function()
-- PlumberLevels_v1
local data=(function()
local catalog=(function()
local catalog=(function()
local catalog=(function()
local catalog=(function()
local catalog=(function()
local catalog=(function()
local data=(function()
local definitions=(function()
-- FantasticIntegration_v1
local data=(function()
-- GhostyVictoryCatalog_v2
local definitions=(function()
-- SpideyPolishCatalog_v2
local catalog=(function()
-- SpideyCatalog_v1
local catalog=(function()
-- CraxFinaleSequence_v3
local catalog=(function()
-- CraxVictoryPolish_v2
local catalog=(function()
-- Un registre commun pour les prochaines animations MAX et leurs Trophées.
return {
 Crax_Monster={Id="Devourer",DisplayName="Dévoreur",MinimumLevel=4,
  Duration=5.8,ZoomDuration=.65,HoldDuration=1.1,
  TrophyId="Devourer",TrophyColor=Color3.fromRGB(255,211,87),
  Description="Le Crax Sourire dévore le vaincu à chaque victoire de round."},
}

end)()
local smile=assert(catalog.Crax_Monster)
smile.ZoomDuration=0
smile.Description="Il ne collectionne pas les victoires. Il collectionne les restes. Service compris, digestion douteuse."
return catalog
end)()
local smile=assert(catalog.Crax_Monster)
smile.IntroDuration=.9
smile.ZoomDuration=.65
return catalog
end)()
catalog.Crax_Spidey={Id="Weaver",DisplayName="Tisseur",MinimumLevel=4,IntroDuration=.15,Duration=5.1,ZoomDuration=0,HoldDuration=1.1,TrophyId="Weaver",TrophyColor=Color3.fromRGB(255,221,121),Description="Cinq déplacements fulgurants : le vaincu disparaît dans un cocon de soie."}
return catalog
end)()
catalog.Crax_Spidey.Duration=6.1;return catalog
end)()
 local base=definitions.Crax_Spidey or definitions.Crax_Monster or {}
 local spec={};for key,value in pairs(base)do spec[key]=value end
 spec.Id="GhostExecution";spec.TrophyId="GhostExecution";spec.MinimumLevel=4
 spec.Name="EXÉCUTION FANTÔME";spec.DisplayName="EXÉCUTION FANTÔME";spec.IntroDuration=.5
 spec.Duration=9;spec.TotalDuration=9.5;spec.SceneDuration=9;spec.FinaleDuration=9
 definitions.Crax_Ghosty=spec;return definitions

end)()
data.Crax_Fantastic={Id="FantasticFinale",DisplayName="FANTASTIC",MinimumLevel=4,IntroDuration=.2,Duration=9.5,TotalDuration=9.7,SceneDuration=9.5,FinaleDuration=9.5,ZoomDuration=0,HoldDuration=1.1,TrophyId="Fantastic",TrophyColor=Color3.fromRGB(255,204,51),Description="Les quatre pouvoirs réunis : le vaincu disparaît en poussière."}

return data
end)()
-- FantasticFinaleScene_v3
local spec=assert(definitions.Crax_Fantastic,'Crax_Fantastic absent du catalogue de victoire')
spec.Id='FantasticFinale';spec.DisplayName='FANTASTIC';spec.MinimumLevel=4
spec.IntroDuration=0;spec.Duration=10.2;spec.SceneDuration=10.2;spec.FinaleDuration=10.2
spec.ZoomDuration=0;spec.HoldDuration=.4;spec.TotalDuration=10.6
return definitions

end)()
data.Crax_Deadly={Id="DeadlyFather",DisplayName="Père de Famille",MinimumLevel=4,IntroDuration=0,Duration=9.7,TotalDuration=10.2,ZoomDuration=0,HoldDuration=.5,TrophyId="DeadlyFather",TrophyColor=Color3.fromRGB(22,238,151),Description="La famille fait disparaître le perdant dans son portail, à coups de boule."}
return data

end)()
-- DeadlyMaxV2Duration_14
local s=assert(catalog.Crax_Deadly,"Crax_Deadly absent")
s.IntroDuration=0;s.Duration=14;s.SceneDuration=14;s.FinaleDuration=14
s.HoldDuration=.5;s.TotalDuration=14.5;s.ZoomDuration=0
s.Description="Chaque membre signe la victoire : étourdissement, bouclier, soin, charge, croissance, trois vagues et frappe finale dans un portail d'étincelles."
return catalog

end)()
local s=assert(catalog.Crax_Deadly,'Crax_Deadly absent')
s.IntroDuration=0;s.Duration=30.8;s.SceneDuration=30.8;s.FinaleDuration=30.8;s.HoldDuration=.5;s.TotalDuration=31.3;s.ZoomDuration=0
return catalog
end)()
local s=assert(catalog.Crax_Deadly,'Crax_Deadly absent')
s.IntroDuration=0;s.Duration=30.8;s.SceneDuration=30.8;s.FinaleDuration=30.8;s.HoldDuration=.5;s.TotalDuration=31.3;s.ZoomDuration=0
return catalog
end)()
local s=assert(catalog.Crax_Deadly,'Crax_Deadly absent')
s.IntroDuration=0;s.Duration=20;s.SceneDuration=20;s.FinaleDuration=20;s.HoldDuration=.25;s.TotalDuration=20.25;s.ZoomDuration=0
s.Description='OG, STACK, PARKER, DODGER, VICE, DOMINO et VOID : victoire de famille et selfie.'
return catalog
end)()
local s=assert(catalog.Crax_Deadly,'Crax_Deadly absent')
s.IntroDuration=0;s.Duration=20;s.SceneDuration=20;s.FinaleDuration=20;s.HoldDuration=.25;s.TotalDuration=20.25;s.ZoomDuration=0
s.Description='OG, STACK, PARKER, DODGER, VICE, DOMINO et VOID : victoire de famille et selfie.'
return catalog
end)()
local s=assert(catalog.Crax_Deadly,'Crax_Deadly absent')
s.IntroDuration=0;s.Duration=25;s.SceneDuration=25;s.FinaleDuration=25;s.HoldDuration=.25;s.TotalDuration=25.25;s.ZoomDuration=0
s.Description='OG, STACK, PARKER, DODGER, VICE, DOMINO et VOID : victoire de famille et selfie.'
return catalog
end)()
data.Crax_Plumber={Id='Mamamia',DisplayName='MAMAMIA',MinimumLevel=4,IntroDuration=0,Duration=10,SceneDuration=10,FinaleDuration=10,ZoomDuration=0,HoldDuration=.25,TotalDuration=10.25,TrophyId='Mamamia',TrophyColor=Color3.fromRGB(255,212,65),Description="Une étoile au menu, un rival dans le tuyau et une victoire haute en couleur."}
return data

end)()
-- GoldenTrueWealthIntegration-1
local spec=catalog.Crax_Golden or {};catalog.Crax_Golden=spec
spec.Id='GoldenTrueWealth';spec.DisplayName='VRAIE RICHESSE';spec.MinimumLevel=4
spec.IntroDuration=1;spec.Duration=15.6;spec.ZoomDuration=0;spec.HoldDuration=.35;spec.TotalDuration=16.95
spec.TrophyId=spec.TrophyId or 'GoldenTrueWealth'
spec.TrophyColor=Color3.fromRGB(230,183,88)
spec.Description="L'or est une tombe pour les autres. Pour lui, c'est une piscine."
return catalog

end)()
-- GoldenTitreVraieRichesse_v1
local golden = assert(data.Crax_Golden, "Victoire Golden absente du catalogue")
golden.DisplayName = "VRAIE RICHESSE"
golden.Name = "VRAIE RICHESSE"
return data

end)()
local duration=require(game:GetService('ReplicatedStorage').CraxFleau.FleauRules).Config.FinaleDuration
data.Crax_Fleau={Id="Buldozer",DisplayName="BULDOZER",Name="BULDOZER",MinimumLevel=4,IntroDuration=.4,Duration=duration,ZoomDuration=0,HoldDuration=.25,TotalDuration=duration+.65,TrophyId="Buldozer",TrophyColor=Color3.fromRGB(255,204,51),Description="Le Fléau géant roule sur le vaincu, puis revient danser."}
return data

end)()
data.Crax_Inverted={Id='Inverted404',DisplayName='ERREUR 404',MinimumLevel=4,IntroDuration=0,Duration=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedConfig')).FinaleDuration,ZoomDuration=0,HoldDuration=0,Description='404 — CRAX NOT FOUND. Cinématique de victoire uniquement.'}
return data
]====]},
{path=[====[ServerScriptService.CraxSkinServer]====],bytes=11390,hash=1098656612,source=[====[local data=(function()
-- CraxFleau v1
local data=(function()
-- GoldenCombatSkin_v1
local data = (function()
local data=(function()
-- ModuleScript : ServerScriptService > CraxSkinServer
local ServerStorage=game:GetService("ServerStorage")
local RS=game:GetService("ReplicatedStorage")
local Skin={}
local originals=setmetatable({},{__mode="k"})
local function headOf(model)
 local head=model:FindFirstChild("Head",true)
 if head and not head:IsA("BasePart") then head=head:FindFirstChildWhichIsA("BasePart",true) end
 assert(head and head:IsA("BasePart"),"Head introuvable : "..model.Name)
 return head
end
local function matchingToothPart(part,model,donor)
 local tooth=part
 while tooth and tooth~=model and not tooth.Name:match("^Tooth_%d+_%d+$") do tooth=tooth.Parent end
 if not tooth or tooth==model then return nil end
 local source=donor:FindFirstChild(tooth.Name,true)
 if not source then return nil end
 if tooth==part then return source:IsA("BasePart") and source or nil end
 local path={}; local current=part
 while current~=tooth do table.insert(path,1,current.Name); current=current.Parent end
 for _,name in ipairs(path) do source=source and source:FindFirstChild(name) end
 return source and source:IsA("BasePart") and source or nil
end
function Skin.Apply(model,id,config)
 local head=headOf(model)
 originals[model]=originals[model] or {}; local saved=originals[model]
 for _,name in ipairs({"SpiderMask","GhostVisual","FantasticVisual"}) do
  local prior=model:FindFirstChild(name); if prior then prior:Destroy() end
 end
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") then
   saved[p]=saved[p] or {color=p.Color,transparency=p.Transparency,size=p.Size,relative=head.CFrame:ToObjectSpace(p.CFrame)}
   local s=saved[p]; p.Color=s.color; p.Transparency=s.transparency; p.Size=s.size
   if p~=head then p.CFrame=head.CFrame*s.relative end
  end
 end
 local upper=model:FindFirstChild("UpperShell",true)
 local lower=model:FindFirstChild("LowerShell",true)
 if upper and lower then head.Transparency=1; upper.Transparency=0; lower.Transparency=0 end
 if id~="Crax_Spidey" and id~="Crax_Ghosty" and id~="Crax_Fantastic" then return end
 local folder=ServerStorage:FindFirstChild("CraxTemplates")
 local donor=folder and folder:FindFirstChild(config.TemplateName)
 assert(donor,"Modèle absent : ServerStorage.CraxTemplates."..tostring(config.TemplateName))
 local donorHead=headOf(donor)
 local scale=math.max(head.Size.X,head.Size.Y,head.Size.Z)/math.max(donorHead.Size.X,donorHead.Size.Y,donorHead.Size.Z)
 local function remap(cf)
  local r=donorHead.CFrame:ToObjectSpace(cf)
  -- FantasticFacingFix_v1
  if id == "Crax_Fantastic" then
   r = CFrame.Angles(0, math.pi, 0) * r
  end
  return head.CFrame*(r.Rotation+r.Position*scale)

 end
 if id=="Crax_Ghosty" or id=="Crax_Fantastic" then
  if id=="Crax_Fantastic" then
   for _,p in ipairs(model:GetDescendants())do if p:IsA("BasePart")then p.Transparency=1 end end
  end
  -- Copie visuelle complète, sans remplacer le Head de physique ni les références des systèmes.
  local visual=donor:Clone(); visual.Name=id=="Crax_Fantastic" and "FantasticVisual"or "GhostVisual"
  for _,p in ipairs(visual:GetDescendants()) do
   if p:IsA("Script") or p:IsA("LocalScript") or p:IsA("BillboardGui") or p:IsA("Sound") then p:Destroy()
   elseif p:IsA("BasePart") then
    p.CFrame=remap(p.CFrame); p.Size=p.Size*scale
    p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false
   end
  end
  visual.PrimaryPart=nil
  visual.Parent=model
 else
  local donorMask=donor:FindFirstChild("SpiderMask")
  assert(donorMask,"SpiderMask manque dans le modèle Spidey")
  head.Transparency=0
  if upper then upper.Transparency=1 end
  if lower then lower.Transparency=1 end
  for _,p in ipairs(model:GetDescendants()) do
   if p:IsA("BasePart") then
    if p.Name=="EyeLeft" or p.Name=="EyeRight" or p.Name=="AngryEyeLeft" or p.Name=="AngryEyeRight" then p.Transparency=1
    else
     local original=matchingToothPart(p,model,donor)
     if original then p.Size=original.Size*scale; p.CFrame=remap(original.CFrame); p.Color=original.Color end
    end
   end
  end
  local mask=donorMask:Clone()
  if mask:IsA("BasePart") then
   mask.CFrame=remap(mask.CFrame); mask.Size=mask.Size*scale; mask.Anchored=true; mask.CanCollide=false; mask.CanTouch=false
  end
  for _,p in ipairs(mask:GetDescendants()) do
   if p:IsA("BasePart") then p.CFrame=remap(p.CFrame); p.Size=p.Size*scale; p.Anchored=true; p.CanCollide=false; p.CanTouch=false end
  end
  mask.Parent=model
 end
 local previews=RS:FindFirstChild("CraxPreviews")
 if previews and not previews:FindFirstChild(config.TemplateName) then donor:Clone().Parent=previews end
end
return Skin

end)()
local V=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxDeadlyVisuals'))
local baseScales=setmetatable({},{__mode='k'});local apply=data.Apply
function data.Apply(model,id,config)
 baseScales[model]=baseScales[model]or model:GetScale()
 local old=model:FindFirstChild('DeadlyVisual');if old then old:Destroy()end
 model:ScaleTo(baseScales[model]);model:SetAttribute('DeadlyMember',nil);model:SetAttribute('DeadlyFamilyBoost',false);model:SetAttribute('DeadlyShield',false)
 apply(model,id,config)
 if id~='Crax_Deadly'then return end
 local h=V.Head(model);model:ScaleTo(baseScales[model]*.5)
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 end end
 local visual=V.Make(game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase'),'OG',1)
 local vh=V.Head(visual);local ratio=math.max(h.Size.X,h.Size.Y,h.Size.Z)/math.max(vh.Size.X,vh.Size.Y,vh.Size.Z)
 visual:ScaleTo(visual:GetScale()*ratio);visual:PivotTo(h.CFrame);visual.Name='DeadlyVisual';visual.Parent=model
 for _,part in ipairs(visual:GetDescendants())do if part:IsA('BasePart')then part:SetAttribute('DeadlyIntendedAlpha',part.Transparency)end end
 model:SetAttribute('DeadlyMember','OG')
end
-- PlumberCapSkinFix_v1
local previousApplyPlumber = data.Apply

local function plumberHead(model)
	local head = model:FindFirstChild("Head", true)
	if head and not head:IsA("BasePart") then
		head = head:FindFirstChildWhichIsA("BasePart", true)
	end
	assert(head and head:IsA("BasePart"), "Head absent : " .. model.Name)
	return head
end

local function plumberCapPart(part, root)
	local current = part
	while current and current ~= root do
		if current.Name:lower():sub(1, 3) == "cap" then
			return true
		end
		current = current.Parent
	end
	return false
end

function data.Apply(model, id, config)
	-- Retirer la casquette avant la restauration du skin précédent.
	local old = model:FindFirstChild("PlumberVisual")
	if old then
		old:Destroy()
	end

	previousApplyPlumber(model, id, config)

	if id ~= "Crax_Plumber" then
		return
	end

	local RS = game:GetService("ReplicatedStorage")
	local previews = assert(RS:FindFirstChild("CraxPreviews"))
	local donor = assert(previews:FindFirstChild("Crax_Plumber"))
	local head = plumberHead(model)
	local donorHead = plumberHead(donor)

	local scale = math.max(head.Size.X, head.Size.Y, head.Size.Z)
		/ math.max(donorHead.Size.X, donorHead.Size.Y, donorHead.Size.Z)

	local visual = Instance.new("Model")
	visual.Name = "PlumberVisual"

	local ok, err = pcall(function()
		for _, original in ipairs(donor:GetDescendants()) do
			if original:IsA("BasePart") and plumberCapPart(original, donor) then
				local part = assert(original:Clone(), "Pièce non clonable : " .. original.Name)

				-- Chaque pièce est copiée séparément, sans doublons imbriqués.
				for _, child in ipairs(part:GetDescendants()) do
					if child:IsA("BasePart")
						or child:IsA("LuaSourceContainer")
						or child:IsA("JointInstance")
						or child:IsA("Constraint")
						or child:IsA("Sound")
					then
						child:Destroy()
					end
				end

				local relative = donorHead.CFrame:ToObjectSpace(original.CFrame)
				part.Size = original.Size * scale
				part.CFrame = head.CFrame
					* (relative.Rotation + relative.Position * scale)

				part.Anchored = true
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part.CastShadow = true
				part.LocalTransparencyModifier = 0
				part.Parent = visual
			end
		end

		assert(#visual:GetChildren() > 0, "Aucune pièce de casquette trouvée.")
	end)

	if not ok then
		visual:Destroy()
		error(err)
	end

	visual.Parent = model
end

return data

end)()
local RS = game:GetService("ReplicatedStorage")
local V = require(RS:WaitForChild("GoldenCraxVisuals")
	:WaitForChild("GoldenVisual"))

assert(type(V.ApplyGoldPBR) == "function",
	"ApplyGoldPBR absent du module GoldenVisual.")

local previousApply = data.Apply
local saved = setmetatable({}, {__mode = "k"})

local function restore(model)
	local record = saved[model]
	if not record then return end

	for part, info in pairs(record) do
		if part:IsDescendantOf(model) then
			part.Color = info.Color
			part.Material = info.Material
			part.MaterialVariant = info.MaterialVariant
			part.Reflectance = info.Reflectance

			if part:IsA("MeshPart") then
				part.TextureID = info.TextureID
			end

			-- GoldenSolidRestore-6.0: remove the current gold surface before restoring originals.
			for _, current in ipairs(part:GetChildren()) do
				if current:IsA("SurfaceAppearance") then current:Destroy() end
			end
			for _, appearance in ipairs(info.Appearances) do
				appearance:Clone().Parent = part
			end
		end

		for _, appearance in ipairs(info.Appearances) do
			appearance:Destroy()
		end
	end

	saved[model] = nil
end

function data.Apply(model, id, config)
	-- Restaurer avant que le système existant applique le prochain skin.
	restore(model)
	previousApply(model, id, config)

	if id ~= "Crax_Golden" then return end

	local record = {}
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local appearances = {}

			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("SurfaceAppearance") then
					appearances[#appearances + 1] = child:Clone()
				end
			end

			record[part] = {
				Color = part.Color,
				Material = part.Material,
				MaterialVariant = part.MaterialVariant,
				Reflectance = part.Reflectance,
				TextureID = part:IsA("MeshPart")
					and part.TextureID or "",
				Appearances = appearances,
			}
		end
	end

	saved[model] = record

	local ok, err = pcall(V.ApplyGoldPBR, model)
	if not ok then
		restore(model)
		error("Application du rendu Golden : " .. tostring(err))
	end
end

return data

end)()
local old=data.Apply
local FleauAppearance=require(game:GetService('ReplicatedStorage').CraxFleau.FleauAppearance)
function data.Apply(model,id,config)
 FleauAppearance.Restore(model)
 old(model,id,config)
 if id=='Crax_Fleau'then FleauAppearance.Apply(model,game:GetService('ServerStorage').CraxTemplates.Crax_Fleau)end
end
-- V68: the back cross is a preview ornament, never a combat collider or visual.
local applyBeforeCrossV68=data.Apply
function data.Apply(model,id,config)
 applyBeforeCrossV68(model,id,config)
 if model.Name~="Fighter1"and model.Name~="Fighter2"then return end
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA("BasePart")then
   local ancestor=o
   while ancestor and ancestor~=model do
    if ancestor.Name=="_CraxBackCrossV1"then
     o.Transparency=1;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;break
    end
    ancestor=ancestor.Parent
   end
  end
 end
end
return data

end)()
local palette=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedPalette'))
local apply=data.Apply
function data.Apply(model,id,config)
 palette.Restore(model)
 apply(model,id,config)
 if id=='Crax_Inverted'then palette.Apply(model)end
end
return data
]====]},
{path=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],bytes=80452,hash=3536119428,source=[====[-- GoldenBookTitleFix_v2
-- PlumberFix_v2
-- CraxBookBulk_v1
-- FantasticBook_v1
-- GhostyBookNames_v3
-- CopEmSkillBookChurch_v15 — grimoire 3D + HUD de lecture
-- CraxPrestige_v1
-- CopEmLogoCorrection_v2
-- CopEmShopPro_v1 — interface seule; toutes les transactions restent validées par CraxSkillServer.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local SoundService=game:GetService("SoundService")
local UserInputService=game:GetService("UserInputService")
local ContentProvider=game:GetService("ContentProvider")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local config=require(RS:WaitForChild("CraxSkillCatalog"))
local catalog=require(RS:WaitForChild("CraxCatalog"))
local style=require(RS:WaitForChild("CopEmShopStyle"))
local ShopLogos=require(RS:WaitForChild("CopEmShopLogos"))
local Prestige=require(RS:WaitForChild("CraxPrestigeVisuals"))
local smileAtlas=RS:WaitForChild("CopEmBranding"):WaitForChild("SmileLevelsAtlas")
local remote=RS:WaitForChild("CraxSkillEvent")
local levels=player:WaitForChild("CraxSkillLevels")
local trophyModule=RS:FindFirstChild("CraxTrophyIcons")
local TrophyIcons=trophyModule and require(trophyModule)
local old=pg:FindFirstChild("CopEmGui");if old then old:Destroy()end
local C={bg=Color3.fromRGB(8,11,17),card=Color3.fromRGB(22,28,40),gold=Color3.fromRGB(255,205,91),blue=Color3.fromRGB(76,209,242),white=Color3.fromRGB(251,248,237),muted=Color3.fromRGB(174,184,202),red=Color3.fromRGB(245,63,72)}
local metals={Color3.fromRGB(214,147,89),Color3.fromRGB(215,232,246),C.gold,Color3.fromRGB(151,237,255)}
local rarity={Commun=Color3.fromRGB(126,214,255),Rare=Color3.fromRGB(255,158,52),["Épique"]=Color3.fromRGB(192,116,255),Epique=Color3.fromRGB(192,116,255),["LEGENDAIRE"]=C.gold,Secret=Color3.fromRGB(234,144,255),["Édition limitée"]=Color3.fromRGB(112,255,78)}
local gui
local shineEntries={};local previews={};local particles={};local actionButtons={};local tabs={}
local currentTab="News";local currentCrax="Crax_Monster";local pending;local rebuild;local buildScheduled=false
local skillPopupOpen=false
local bookOpened=false;local gaugeFill;local gaugeCaption;local bookPrompt;local switching=false
local hold;local transaction;local celebration;local cancelHold
local nodes={};local links={};local neonEntries={};local bookStrip
local HOLD_SECONDS=1.8
local paymentPopup;local suppressSealClickUntil=0
local bookNav={};local bookDust={};local bookDustStarted=0;local chapterSnapshot;local chapterShadow;local bookScale;local dustLast=0
local selectedSkill;local book;local turnPage;local heroView;local cinema
local confirmedLevels={}
local pulseEntries={};local viewEpoch=0;local pageTurningUntil=0
local sharedConnections={}
local function connect(signal,callback)
 local connection=signal:Connect(callback);sharedConnections[#sharedConnections+1]=connection
 return connection
end
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function round(o,r)make("UICorner",{CornerRadius=UDim.new(0,r)},o)end
local function text(parent,value,x,y,w,h,size,color)
 return make("TextLabel",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,Text=value,
 Font=Enum.Font.GothamBold,TextSize=size,TextColor3=color or C.white,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},parent)
end
local function gradient(parent,a,b,rotation)return make("UIGradient",{Rotation=rotation or 90,Color=ColorSequence.new(a,b)},parent)end
local function rim(parent,color)
 local stroke=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=Color3.new(1,1,1),Thickness=2.2,Transparency=.12},parent)
 local g=make("UIGradient",{Rotation=35,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color:Lerp(Color3.new(0,0,0),.5)),
  ColorSequenceKeypoint.new(.4,color),ColorSequenceKeypoint.new(.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.6,color),ColorSequenceKeypoint.new(1,color:Lerp(Color3.new(0,0,0),.5))})},stroke)
 shineEntries[#shineEntries+1]={gradient=g,parent=parent};return stroke
end
local function card(parent,x,y,w,h,color)
 local f=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=C.card,BorderSizePixel=0,ClipsDescendants=true},parent)
 round(f,15);gradient(f,color:Lerp(C.bg,.87),C.bg,115);rim(f,color);return f
end
local sounds={}
for name,pitch in pairs({Hover=1.25,Click=1,Success=.9,Open=.75})do
 sounds[name]=make("Sound",{Name="CopEm"..name,SoundId="rbxassetid://113397864512278",Volume=name=="Hover"and .045 or .13,PlaybackSpeed=pitch},pg)
end
for name,pitch in pairs({Page=.72,Reveal=1.4,Max=.5})do
 sounds[name]=make("Sound",{Name="CopEm"..name,SoundId=(name=="Page"and style.SkillPageSoundId or name=="Reveal"and style.SkillRevealSoundId or style.SkillMaxSoundId)or sounds.Click.SoundId,Volume=name=="Max"and .23 or .12,PlaybackSpeed=pitch},pg)
end
if type(style.SkillSuccessSoundId)=="string"and style.SkillSuccessSoundId~=""then sounds.Success.SoundId=style.SkillSuccessSoundId end
sounds.Charge=make("Sound",{Name="CopEmCharge",SoundId=style.SkillChargeSoundId or sounds.Click.SoundId,Volume=.075,PlaybackSpeed=.65,Looped=true},pg)
-- SoundService effect playback does not mute existing music or replace combat sounds.
local lastHover=0
local function play(name)
 if name=="Hover"then if os.clock()-lastHover<.08 then return end;lastHover=os.clock()end
 local sound=sounds[name];sound:Stop();SoundService:PlayLocalSound(sound)
end
task.spawn(function()pcall(function()ContentProvider:PreloadAsync({sounds.Hover,sounds.Click,sounds.Success,sounds.Open})end)end)
local function button(parent,value,x,y,w,h,color,callback)
 local b=make("TextButton",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=color,
  BorderSizePixel=0,AutoButtonColor=false,Text=value,TextColor3=C.white,Font=Enum.Font.GothamBlack,TextSize=16},parent)
 round(b,9);gradient(b,color:Lerp(Color3.new(1,1,1),.15),color:Lerp(C.bg,.35));local edge=rim(b,color)
 local scale=make("UIScale",{Scale=1},b);local tween
 local function animate(v)if tween then tween:Cancel()end;tween=TweenService:Create(scale,TweenInfo.new(.13,Enum.EasingStyle.Quad),{Scale=v});tween:Play()end
 b.MouseEnter:Connect(function()if b.Active then play("Hover");animate(1.035);edge.Transparency=0 end end)
 b.MouseLeave:Connect(function()animate(1);edge.Transparency=.12 end)
 b.MouseButton1Down:Connect(function()if b.Active then animate(.97)end end)
 b.MouseButton1Up:Connect(function()animate(1)end)
 b.Activated:Connect(function()if b.Active then play("Click");callback()end end);return b
end
local function circleCharge(parent,color)
 local frame=make("Frame",{Name="ContinuousChargeRing",Position=UDim2.fromOffset(-8,-8),Size=UDim2.fromOffset(78,78),BackgroundTransparency=1,ZIndex=5},parent)
 local base=make("Frame",{Position=UDim2.fromOffset(2,2),Size=UDim2.fromOffset(74,74),BackgroundTransparency=1},frame);round(base,100)
 make("UIStroke",{Thickness=3,Color=Color3.fromRGB(100,73,35),Transparency=.6},base)
 local masks={}
 for i=1,2 do
  local clip=make("Frame",{Position=UDim2.fromOffset(i==1 and 39 or 0,0),Size=UDim2.fromOffset(39,78),ClipsDescendants=true,BackgroundTransparency=1,ZIndex=6},frame)
  local circle=make("Frame",{Position=UDim2.fromOffset(i==1 and -37 or 2,2),Size=UDim2.fromOffset(74,74),BackgroundTransparency=1},clip);round(circle,100)
  local edge=make("UIStroke",{Thickness=3,Color=color,Transparency=0},circle)
  local mask=make("UIGradient",{Rotation=0,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.499,0),NumberSequenceKeypoint.new(.501,1),NumberSequenceKeypoint.new(1,1)})},edge)
  masks[i]={clip=clip,mask=mask,edge=edge}
 end
 local ring={}
 function ring:Set(value,newColor)
  value=math.clamp(value,0,1)
  masks[1].clip.Visible=value>0;masks[2].clip.Visible=value>.5
  masks[1].mask.Rotation=math.min(value*2,1)*180
  masks[2].mask.Rotation=180+math.max(value*2-1,0)*180
  if newColor then for _,e in ipairs(masks)do e.edge.Color=newColor end end
 end
 ring:Set(0);return ring
end
-- SpideyBook_v1
local SpideyIcons=require(RS:WaitForChild("CraxSpideyIcons"))
local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,8)=='Inverted'then
  local symbols={InvertedHack='HACK',InvertedCopy='COPY',InvertedRewind='CTRL-Z',Inverted404='404'}
  local f=make('Frame',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(size,size),BackgroundColor3=Color3.fromRGB(13,15,20),BorderSizePixel=0},parent);round(f,math.max(8,size*.2))
  make('UIStroke',{Color=Color3.fromRGB(240,238,228),Thickness=2},f)
  make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=symbols[kind]or'×',Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.fromRGB(245,242,232)},f)
  return
 end
 local f=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Active=false},parent)
 -- FleauSkillImages_v1
 do
  local catalog=require(game:GetService("ReplicatedStorage"):WaitForChild("CraxSkillCatalog"))
  local spec=catalog.Crax_Fleau
  local images={
   "rbxassetid://96136223791989",
   "rbxassetid://135838189195225",
   "rbxassetid://94632742584795",
  }
  if spec and spec.Upgrades then
   for level=1,3 do
    local upgrade=spec.Upgrades[level]
    if upgrade and upgrade.Id~=nil and kind==upgrade.Id then
     local image=Instance.new("ImageLabel")
     image.Name="FleauSkillIcon"..level
     image.BackgroundTransparency=1
     image.Size=UDim2.fromScale(1,1)
     image.Image=images[level]
     image.ScaleType=Enum.ScaleType.Fit
     image.ZIndex=4
     image.Parent=f
     return
    end
   end
  end
 end

 -- PlumberSkillImages_v1
 local plumber=require(RS:WaitForChild("CraxSkillCatalog")).Crax_Plumber
 local images={
  "rbxassetid://86593576514423",
  "rbxassetid://75663879647026",
  "rbxassetid://121269049718514",
 }

 if plumber and plumber.Upgrades then
  for level=1,3 do
   local upgrade=plumber.Upgrades[level]

   if upgrade and upgrade.Id~=nil and upgrade.Id==kind then
    make("ImageLabel",{
     Name="PlumberSkillIcon_Level"..level,
     BackgroundTransparency=1,
     Size=UDim2.fromScale(1,1),
     Image=images[level],
     ScaleType=Enum.ScaleType.Fit,
     Active=false,
     ZIndex=4,
    },f)
    return
   end
  end
 end

 -- GoldenPlumberTrophyPopup_v1
 local skills=require(RS:WaitForChild("CraxSkillCatalog"))
 local victories=require(RS:WaitForChild("CraxVictoryCatalog"))
 local isTrophy=false

 for _,craxId in ipairs({"Crax_Plumber","Crax_Golden"})do
  local spec=skills[craxId]
  local maximum=spec and spec.Upgrades and spec.Upgrades[4]
  local victory=victories[craxId]

  if kind~=nil and (
   maximum and maximum.Id~=nil and kind==maximum.Id
   or victory and victory.Id~=nil and kind==victory.Id
   or victory and victory.TrophyId~=nil and kind==victory.TrophyId
  )then
   isTrophy=true
   break
  end
 end

 if isTrophy then
  local image=require(RS:WaitForChild("CraxTrophyIcons")).Build(f,true)

  if image then
   image.Visible=true
   image.ImageTransparency=0
   image.ScaleType=Enum.ScaleType.Fit
   image.ZIndex=4
  else
   warn("Image du trophée absente : vérifier CraxTrophyImages.Acquired.")
  end

  return
 end

 -- GoldenSkillImages_v1
 local golden=require(RS:WaitForChild("CraxSkillCatalog")).Crax_Golden
 local images={
  "rbxassetid://126529258520474",
  "rbxassetid://71440977110481",
  "rbxassetid://133977363317754",
 }

 if golden and golden.Upgrades then
  for level=1,3 do
   local upgrade=golden.Upgrades[level]

   if upgrade and upgrade.Id==kind then
    make("ImageLabel",{
     Name="GoldenSkillIcon_Level"..level,
     BackgroundTransparency=1,
     Size=UDim2.fromScale(1,1),
     Image=images[level],
     ScaleType=Enum.ScaleType.Fit,
     Active=false,
     ZIndex=4,
    },f)
    return
   end
  end
 end

 if require(RS:WaitForChild("CraxDeadlyIcons")).Build(f,kind)then return end
 if kind=="Weaver"or kind=="DoubleSilk"or kind=="SilkTrap"or kind=="Venom"then SpideyIcons.Build(f,kind);return end
 if kind=="GhostExecution"then require(RS:WaitForChild("CraxGhostyTrophyIcons")).Build(f);return end
 if kind=="Devourer"and TrophyIcons then TrophyIcons.Build(f);return end
 if require(RS:WaitForChild("CraxGhostySkillLogos")).Build(f,kind)then return end
 if require(RS:WaitForChild("CraxFantasticIcons")).Build(f,kind)then return end
 if kind=="Coins"then Prestige.Coin(f);return end
 if kind=="Gems"then
  local image=make("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=4,Active=false,ScaleType=Enum.ScaleType.Fit},f)
  image.Name="CraxGemIcon";ShopLogos.BindGem(image,true);image.ScaleType=Enum.ScaleType.Fit;return
 end
 if ShopLogos.Power(f,kind)then return end
 local imageId=style.PowerLogos and style.PowerLogos[kind]
 if type(imageId)=="string"and imageId~=""then make("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=imageId,ScaleType=Enum.ScaleType.Fit},f);return end
 if kind=="Gems"then
  local d=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.48,.48),Rotation=45,BackgroundColor3=color,BorderSizePixel=0},f)
  gradient(d,Color3.fromRGB(250,255,255),Color3.fromRGB(60,161,225),25);rim(d,color);return
 elseif kind=="Coins"then
  local coin=make("Frame",{Position=UDim2.fromScale(.18,.18),Size=UDim2.fromScale(.64,.64),BackgroundColor3=C.gold,BorderSizePixel=0},f)
  round(coin,100);gradient(coin,Color3.fromRGB(255,248,169),Color3.fromRGB(171,97,7),25);rim(coin,C.gold)
  make("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="C",Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.fromRGB(122,63,9)},coin);return
 end
 local disk=make("Frame",{Position=UDim2.fromScale(.1,.1),Size=UDim2.fromScale(.8,.8),BackgroundColor3=color:Lerp(C.bg,.7),BorderSizePixel=0},f);round(disk,100);rim(disk,color)
 if kind=="TongueSweep"then
  local tongue=make("Frame",{Position=UDim2.fromScale(.15,.4),Size=UDim2.fromScale(.72,.28),Rotation=-25,BackgroundColor3=Color3.fromRGB(255,103,145),BorderSizePixel=0},disk);round(tongue,30);gradient(tongue,Color3.fromRGB(255,172,190),Color3.fromRGB(186,26,74))
 else
  local mouth=make("Frame",{Position=UDim2.fromScale(.13,.35),Size=UDim2.fromScale(.74,.36),BackgroundColor3=Color3.fromRGB(66,4,16),BorderSizePixel=0},disk);round(mouth,10)
  for i=1,(kind=="LifeSteal"and 2 or 5)do
   local n=kind=="LifeSteal"and(i==1 and .1 or .68)or(i-1)*.18+.05
   local tooth=make("Frame",{Position=UDim2.fromScale(n,0),Size=UDim2.fromScale(.15,kind=="LifeSteal"and .9 or .6),BackgroundColor3=Color3.fromRGB(255,244,213),BorderSizePixel=0},mouth);round(tooth,4)
  end
 end
end
local function glitter(parent,color,count)
 for i=1,count do
  local p=make("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromOffset(14,14),Text=i%3==0 and "✦"or "·",Font=Enum.Font.GothamBlack,TextSize=i%3==0 and 17 or 22,TextColor3=color,ZIndex=2,Active=false},parent)
  particles[#particles+1]={object=p,seed=i*.618,color=color}
 end
end
local function preview(parent,id,x,y,w,h)
 local view=make("ViewportFrame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,Ambient=Color3.fromRGB(205,217,236),LightColor=Color3.fromRGB(255,242,217),LightDirection=Vector3.new(-1,-1,-2),ZIndex=3},parent)
 local data=catalog[id];local folder=RS:FindFirstChild("CraxPreviews");local donor=data and folder and folder:FindFirstChild(data.TemplateName)
 if not donor or not donor:IsA("Model")then text(view,"Aperçu en préparation",4,0,w-8,h,17,C.muted);return end
 local world=make("WorldModel",{},view);local model=donor:GetAttribute('DeadlySpiral')and require(RS:WaitForChild('CraxDeadlyVisuals')).PreviewClone(donor)or donor:Clone();model.Parent=world
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA("BasePart")then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false
  elseif o:IsA("Script")or o:IsA("LocalScript")or o:IsA("Sound")or o:IsA("BillboardGui")or o:IsA("Highlight")then o:Destroy()end
 end
 local head=model:FindFirstChild("Head",true);if head and not head:IsA("BasePart")then head=head:FindFirstChildWhichIsA("BasePart",true)end
 local box,size=model:GetBoundingBox();local center=head and head.Position or box.Position
 local diameter=head and math.max(head.Size.X,head.Size.Y,head.Size.Z,size.Y*.85)or math.max(size.X,size.Y,size.Z)
 local sum=Vector3.zero;local count=0
 for _,o in ipairs(model:GetDescendants())do if o:IsA("BasePart")then
  local n=o;while n and n~=model do if n.Name=="EyeLeft"or n.Name=="EyeRight"or n.Name=="AngryEyeLeft"or n.Name=="AngryEyeRight"then sum=sum+o.Position;count=count+1;break end;n=n.Parent end
 end end
 local front=Vector3.new(0,0,-1);if count>0 then local d=sum/count-center;local horizontal=Vector3.new(d.X,0,d.Z);if horizontal.Magnitude>.001 then front=horizontal.Unit end end
 local camera=make("Camera",{FieldOfView=35,CFrame=CFrame.lookAt(center+front*diameter*1.95,center)},view);view.CurrentCamera=camera;require(RS:WaitForChild("CraxDeadlyVisuals")).Fit(view,model)
 previews[#previews+1]={view=view,camera=camera,center=center,front=front,diameter=diameter,locked=model:GetAttribute("DeadlySpiral")==true};return view
end
gui=make("ScreenGui",{Name="CopEmGui",ResetOnSpawn=false,DisplayOrder=80,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
local logoFolder=RS:FindFirstChild("CopEmBranding");local logoValue=logoFolder and logoFolder:FindFirstChild("LogoImage")
local open=button(gui,"Cop'Em",12,0,136,146,C.bg,function()end);open.Name="CopEmButton";open.AnchorPoint=Vector2.new(0,.5);open.Position=UDim2.new(0,-4,style.ButtonY or .62,0);open.BackgroundTransparency=1;open.Text="";open.Visible=false
for _,o in ipairs(open:GetChildren())do if o:IsA("UIStroke")then o.Enabled=false end end
local openLogo=make("ImageLabel",{Position=UDim2.fromOffset(7,0),Size=UDim2.fromOffset(122,115),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},open)
local caption=text(open,"Cop'Em",0,111,136,32,27,C.white);caption.TextXAlignment=Enum.TextXAlignment.Center;caption.Font=Enum.Font.GothamBlack;caption.ZIndex=5
local captionGradient=gradient(caption,Color3.fromRGB(255,253,196),C.gold);shineEntries[#shineEntries+1]={gradient=captionGradient,parent=caption}
local shade=make("Frame",{Name="ShopOverlay",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.32,Visible=false,Active=true},gui)
local panel=make("Frame",{Name="ShopPanel",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(1080,720),BackgroundColor3=C.bg,BorderSizePixel=0},shade);round(panel,20);rim(panel,C.gold)
gradient(panel,Color3.fromRGB(18,25,38),C.bg,110)
local panelScale=make("UIScale",{Scale=1},panel)
local entrance=make("NumberValue",{Value=1},panel);local openingTween
local logoHeader=make("ImageLabel",{Position=UDim2.fromOffset(21,7),Size=UDim2.fromOffset(73,73),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},panel)
for i=1,3 do
 local depth=text(panel,"Cop'Em",104,12+(4-i),285,54,40,Color3.fromRGB(65+i*25,31+i*12,4))
 depth.Font=Enum.Font.GothamBlack;depth.ZIndex=i+1
end
local title=text(panel,"Cop'Em",104,12,285,54,40,C.white);title.ZIndex=5;title.Font=Enum.Font.GothamBlack;title.TextStrokeColor3=Color3.fromRGB(110,54,6);title.TextStrokeTransparency=.2
local titleGold=gradient(title,Color3.fromRGB(255,252,207),Color3.fromRGB(226,155,32));shineEntries[#shineEntries+1]={gradient=titleGold,parent=title}
text(panel,"COLLECTION • COMPÉTENCES • TROPHÉES",105,63,430,20,12,C.muted)
local function logoRefresh()
 local id=ShopLogos.Normalize(logoValue and logoValue.Value or "")
 openLogo.Image=id;logoHeader.Image=id;openLogo.Visible=id~="";logoHeader.Visible=id~=""
 caption.Position=id~=""and UDim2.fromOffset(0,111)or UDim2.fromOffset(0,52)
end
if logoValue then connect(logoValue.Changed,logoRefresh)end;logoRefresh()
local wallet=player:WaitForChild("Wallet")
local coins=wallet:WaitForChild("Coins");local gems=wallet:WaitForChild("CraxGems")
local function number(value)local s=tostring(math.max(0,math.floor(value)));return(s:reverse():gsub("(%d%d%d)","%1 "):reverse():gsub("^ ",""))end
local coinPill=card(panel,582,20,181,45,C.gold);emblem(coinPill,"Coins",C.gold,3,4,37)
local coinText=text(coinPill,"",47,3,129,39,19,C.gold)
local gemPill=card(panel,776,20,180,45,C.blue);emblem(gemPill,"Gems",C.blue,3,4,37)
local gemText=text(gemPill,"",47,3,128,39,19,C.blue)
local function balance()coinText.Text=number(coins.Value);gemText.Text=number(gems.Value)end
connect(coins.Changed,balance);connect(gems.Changed,balance);balance()
local content=make("Frame",{Position=UDim2.fromOffset(24,153),Size=UDim2.fromOffset(1032,502),BackgroundTransparency=1},panel)
local message=text(panel,"",28,667,1020,34,17,C.gold)
local burstPool={}
for i=1,28 do burstPool[i]=make("TextLabel",{Size=UDim2.fromOffset(8,8),BackgroundTransparency=1,Text="·",Font=Enum.Font.GothamBlack,TextSize=21,TextColor3=C.gold,ZIndex=20,Visible=false},panel)end
local effectLayer=make("Frame",{Name="BookCeremony",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=30,Active=false},panel)
local flash=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=C.gold,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Active=false},effectLayer);round(flash,20)
local vignette=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(15,1,3),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Active=false},effectLayer);round(vignette,20)
local shock=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(100,100),BackgroundTransparency=1,Visible=false,ZIndex=2,Active=false},effectLayer);round(shock,1000)
local shockEdge=make("UIStroke",{Color=C.gold,Thickness=3,Transparency=1},shock)
local spark=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(10,10),BackgroundColor3=C.gold,BorderSizePixel=0,Visible=false,ZIndex=3,Active=false},effectLayer);round(spark,20)
local awardPlate=card(effectLayer,175,553,730,89,C.gold);awardPlate.ZIndex=3;awardPlate.Visible=false
local orbit={}
for i=1,24 do
 orbit[i]=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(i%3==0 and 5 or 3,i%3==0 and 5 or 3),BackgroundColor3=C.gold,BorderSizePixel=0,Visible=false,ZIndex=2,Active=false},effectLayer);round(orbit[i],20)
end
local ceremonyText=text(effectLayer,"",180,563,720,42,28,C.gold);ceremonyText.TextXAlignment=Enum.TextXAlignment.Center;ceremonyText.Font=Enum.Font.Antique;ceremonyText.Visible=false;ceremonyText.ZIndex=4
local ceremonySub=text(effectLayer,"",180,606,720,24,14,C.muted);ceremonySub.TextXAlignment=Enum.TextXAlignment.Center;ceremonySub.Visible=false;ceremonySub.ZIndex=4
local function effectReset()
 flash.BackgroundTransparency=1;vignette.BackgroundTransparency=1;shock.Visible=false
 ceremonyText.Visible=false;ceremonySub.Visible=false;awardPlate.Visible=false;spark.Visible=false
 for _,o in ipairs(orbit)do o.Visible=false end
end
local burstStart=-100
local function schedule()
 if hold or pending or celebration or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 if buildScheduled then return end;buildScheduled=true
 task.defer(function()buildScheduled=false;if shade.Visible and rebuild and not hold and not pending and not celebration and(not cinema or cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter")then rebuild()end end)
end
local function own(id)local inv=player:FindFirstChild("Inventory");local v=inv and inv:FindFirstChild(id);return v and v:IsA("BoolValue")and v.Value==true end
local function level(id)local v=levels:FindFirstChild(id);return math.max(v and v.Value or 0,confirmedLevels[id]or 0)end
local function available(id,step)
 local spec=config[id];return not pending and not celebration and os.clock()>=pageTurningUntil and(not cinema or cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter")and player:GetAttribute("InventoryReady")==true and player:GetAttribute("ArenaSeat")==nil and own(id)and bookOpened
  and spec and spec.Enabled and step==level(id)+1 and spec.Upgrades[step]~=nil
end
local function buy(id,step,currency)
 if not available(id,step)then return end
 local spec=config[id];local cost=spec.Upgrades[step][currency];local balanceValue=currency=="Coins"and coins.Value or gems.Value
 if type(cost)~="number"or cost<=0 then return end
 if balanceValue<cost then message.Text="Il te faut "..number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems")..".";return end
 pending=HttpService:GenerateGUID(false);local request=pending
 transaction={id=id,step=step,currency=currency,epoch=viewEpoch}
 for _,b in ipairs(actionButtons)do if b.Parent then b.Active=false;local label=b:FindFirstChild("PriceLabel");if label then label.Text="VALIDATION…"end end end
 message.Text="Validation de l'achat…";remote:FireServer("Buy",request,id,step,currency)
 task.delay(12,function()if pending==request then message.Text="La réponse tarde. Attends la confirmation avant un autre achat."end end)
end
-- A hold never pays locally. Only buy() can submit a request to the server.
cancelHold=function()
 if not hold then return end
 local h=hold;hold=nil;sounds.Charge:Stop();if cinema then cinema:CancelCharge()end
 if h.fill.Parent then h.fill.Size=UDim2.fromScale(0,1)end
 if h.label.Parent then h.label.Text=h.caption end
 if h.cardScale.Parent then h.cardScale.Scale=1 end
 local n=nodes[h.step];if n then n.ring:Set(0) end
 if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
 if gaugeCaption then gaugeCaption.Text="ÉVEIL • 0 %"end
 for _,o in ipairs(orbit)do o.Visible=false end
end
local function neon(parent)
 local edge=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=3,Transparency=.05,Color=Color3.new(1,1,1)},parent)
 local g=gradient(edge,Color3.fromRGB(255,51,39),Color3.fromRGB(255,184,48),0)
 neonEntries[#neonEntries+1]={edge=edge,g=g}
end
local function holdButton(parent,caption,x,y,w,h,color,id,step,currency,cardScale)
 local b=button(parent,"",x,y,w,h,color,function()end)
 b.ClipsDescendants=true
 local fill=make("Frame",{Name="HoldFill",Size=UDim2.fromScale(0,1),BackgroundColor3=color:Lerp(C.white,.4),BackgroundTransparency=.15,BorderSizePixel=0,ZIndex=2,Active=false},b);round(fill,9)
 local label=text(b,caption,32,0,w-38,h,17,C.white);label.Name="PriceLabel";label.TextXAlignment=Enum.TextXAlignment.Right;label.ZIndex=5
 emblem(b,currency,currency=="Coins"and C.gold or C.blue,2,2,28)
 local cost=config[id].Upgrades[step][currency]
 b.Active=available(id,step)and type(cost)=="number"and cost>0
 b.InputBegan:Connect(function(input)
  local kind=input.UserInputType
  if kind~=Enum.UserInputType.MouseButton1 and kind~=Enum.UserInputType.Touch then return end
  if not available(id,step)or not b.Active then return end
  cancelHold()
  if (currency=="Coins"and coins.Value or gems.Value)<cost then
   message.Text="Il te faut "..number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems")..".";return
  end
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
  if gaugeCaption then gaugeCaption.Text="ÉVEIL • 0 %"end
  fill.Size=UDim2.fromScale(0,1)
  hold={button=b,fill=fill,label=label,caption=caption,input=input,start=os.clock(),id=id,step=step,currency=currency,cardScale=cardScale}
  message.Text="Maintiens pour débloquer • relâche pour annuler."
  if cinema then cinema:Charge(.001)end
 end)
 b.MouseLeave:Connect(function()if hold and hold.button==b and hold.input.UserInputType==Enum.UserInputType.MouseButton1 then cancelHold()end end)
 b.InputEnded:Connect(function(input)if hold and hold.button==b and input==hold.input then cancelHold()end end)
 actionButtons[#actionButtons+1]=b
 return b
end
local function choosePayment(id,step,all)
 if pending or celebration or not available(id,step)then return end
 skillPopupOpen=false
 local old=panel:FindFirstChild("BurntParchmentDescription");if old then old:Destroy()end
 if paymentPopup then paymentPopup:Destroy()end
 local epoch=viewEpoch
 local popup=make("Frame",{Name="SkillPaymentChoice",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.25,Active=true,ZIndex=110},panel);paymentPopup=popup
 local box=card(popup,215,205,650,285,C.gold);box.ZIndex=111
 text(box,all and "TOUT ACHETER"or "DÉBLOQUER CE NIVEAU",25,15,600,42,29,C.gold).ZIndex=112
 text(box,"Choisis une seule monnaie pour le paiement.",25,59,600,30,19,C.white).ZIndex=112
 local from=level(id)
 for n,currency in ipairs({"Coins","Gems"})do
  local balanceValue=currency=="Coins"and coins.Value or gems.Value
  local spent=0;local target=from
  local last=all and #config[id].Upgrades or step
  for k=from+1,last do local cost=config[id].Upgrades[k][currency]
   if type(cost)~="number"or cost<=0 or cost%1~=0 or spent+cost>balanceValue then break end
   spent=spent+cost;target=k
  end
  local count=target-from
  local caption=(currency=="Coins"and "CRAXCOINS"or "CRAXGEMS").." • "..count.." niveau(x) • "..number(spent)
  local pay=button(box,caption,25,102+(n-1)*58,600,49,currency=="Coins"and C.gold or C.blue,function()
   if viewEpoch~=epoch or currentCrax~=id or not available(id,step)then popup:Destroy();return end
   popup:Destroy();paymentPopup=nil
   if not all then buy(id,step,currency);return end
   pending=HttpService:GenerateGUID(false);transaction={id=id,step=target,from=from,currency=currency,epoch=epoch,all=true}
   message.Text="Validation de l’achat groupé…"
   remote:FireServer("BuyAll",pending,id,0,currency)
  end);pay.ZIndex=112;pay.Active=count>0
 end
 local close=button(box,"ANNULER",225,226,200,40,C.red,function()popup:Destroy();paymentPopup=nil end);close.ZIndex=112
 local connection;connection=RunService.RenderStepped:Connect(function()
  if not popup.Parent then connection:Disconnect();return end
  if not shade.Visible or not bookOpened or currentTab~="Skills"or epoch~=viewEpoch then popup:Destroy();paymentPopup=nil;connection:Disconnect()end
 end)
end
local inputEnded=UserInputService.InputEnded:Connect(function(input)
 if hold and (input==hold.input or input.UserInputType==Enum.UserInputType.MouseButton1 and hold.input.UserInputType==Enum.UserInputType.MouseButton1)then cancelHold()end
end)
local focusLost=UserInputService.WindowFocusReleased:Connect(function()cancelHold()end)
local function tab(tabId)
 if switching or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 local previousTab=currentTab
 local function finish()
  switching=false;cancelHold();celebration=nil;effectReset();viewEpoch=viewEpoch+1;selectedSkill=nil
  if cinema then cinema:Hide()end
  currentTab=tabId;bookOpened=false;message.Text=pending and "Validation de l'achat…"or ""
  if shade.Visible and rebuild then rebuild();if tabId=="Skills"and cinema then cinema:Closed()end end
 end
 if previousTab=="Skills"and tabId~="Skills"and bookOpened and cinema then
  switching=true;cancelHold();celebration=nil;effectReset();cinema:Close(finish)
 else finish()end
end
local function select(id)
 if switching or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 if currentTab~="Skills"then currentCrax=id;tab("Skills");return end
 if id==currentCrax then return end
 if not bookOpened then currentCrax=id;selectedSkill=nil;viewEpoch=viewEpoch+1;rebuild();cinema:Closed();return end
 -- Atomic replacement: no cloned folio, rotating texture, fade or chapter animation.
 cancelHold();skillPopupOpen=false;viewEpoch=viewEpoch+1
 currentCrax=id;selectedSkill=nil;rebuild()

end
local function list(parent) return make("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,ScrollBarImageColor3=C.gold,CanvasSize=UDim2.fromOffset(0,0)},parent)end
rebuild=function()
 local oldPopup=panel:FindFirstChild("BurntParchmentDescription");if oldPopup then oldPopup:Destroy()end
 cancelHold()
 if cinema then cinema:DetachHome()end
 for _,o in ipairs(content:GetChildren())do o:Destroy()end;previews={};actionButtons={};nodes={};links={};neonEntries={};bookStrip=nil;book=nil;heroView=nil;pulseEntries={};gaugeFill=nil;gaugeCaption=nil;bookPrompt=nil;bookDust={};bookNav={}
 for id,b in pairs(tabs)do b.BackgroundColor3=id==currentTab and Color3.fromRGB(48,104,122)or C.card end
 panel.BackgroundColor3=currentTab=="Skills"and Color3.fromRGB(25,17,12)or C.bg
 local sc=list(content)
 if currentTab=="News"then
  -- CraxFeaturedReveal_v1: presentation confined to the News page.
  local data=catalog.Crax_Monster
  local accent=data and (data.RarityColor or rarity[data.Rarity]) or C.gold
  local dark=Color3.fromRGB(22,24,32)
  local ink=Color3.fromRGB(9,11,17)
  local alive=true
  local connections={}
  local saved={}
  local tweens={}
  local heartbeat
  local function bind(signal,fn)
   local c=signal:Connect(fn);connections[#connections+1]=c;return c
  end
  local function set(o,props)
   saved[o]=saved[o] or {}
   for key,value in pairs(props)do
    if saved[o][key]==nil then saved[o][key]=o[key]end
    o[key]=value
   end
  end
  local function tween(o,seconds,props,style)
   local t=TweenService:Create(o,TweenInfo.new(seconds,style or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props)
   tweens[#tweens+1]=t;t:Play();return t
  end
  local function cancelTweens()
   for _,t in ipairs(tweens)do t:Cancel()end;table.clear(tweens)
  end
  local function box(parent,name,color,z)
   local f=make("Frame",{Name=name,BackgroundColor3=color,BorderSizePixel=0,ZIndex=z or 1,ClipsDescendants=true},parent)
   round(f,22);make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=3,Color=ink},f)
   return f
  end
  local featured=make("CanvasGroup",{Name="FeaturedReveal",BackgroundColor3=dark,BorderSizePixel=0,ClipsDescendants=true,GroupTransparency=1},sc)
  round(featured,24)
  local edge=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=4,Color=accent,Transparency=.12},featured)
  local shine=make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,accent),ColorSequenceKeypoint.new(.46,accent),ColorSequenceKeypoint.new(.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.54,accent),ColorSequenceKeypoint.new(1,accent)}),Rotation=25,Offset=Vector2.new(-1,0)},edge)
  local revealScale=make("UIScale",{Scale=.965},featured)
  local heading=text(featured,"À LA UNE",24,16,520,44,32,accent);heading.Font=Enum.Font.FredokaOne
  heading.TextStrokeColor3=ink;heading.TextStrokeTransparency=.15
  local stage=make("Frame",{Name="CraxStage",BackgroundTransparency=1,ClipsDescendants=true,ZIndex=2},featured)
  local halo={}
  for i=1,4 do
   local h=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.90-i*.11,.90-i*.11),BackgroundColor3=accent,BackgroundTransparency=.96-i*.015,BorderSizePixel=0,ZIndex=1,Active=false},stage)
   round(h,1000);make("UIAspectRatioConstraint",{AspectRatio=1},h);halo[i]=h
  end
  local rays=make("Frame",{Name="SoftRays",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.84,.84),BackgroundTransparency=1,ZIndex=1,Active=false},stage)
  make("UIAspectRatioConstraint",{AspectRatio=1},rays)
  for i=1,8 do
   local ray=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.91,.055),Rotation=(i-1)*22.5,BackgroundColor3=accent,BackgroundTransparency=.94,BorderSizePixel=0,ZIndex=1,Active=false},rays)
   round(ray,100);make("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.3,.5),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.7,.5),NumberSequenceKeypoint.new(1,1)})},ray)
  end
  local view=preview(stage,"Crax_Monster",0,0,360,360)
  if view then view.Name="FeaturedCraxViewport";view.Position=UDim2.fromScale(.04,.04);view.Size=UDim2.fromScale(.92,.92)end
  -- Use the existing clone, sanitization and camera orbit, never a replacement character.
  local sparks={}
  for i=1,6 do
   sparks[i]=make("TextLabel",{Name="RevealSpark"..i,BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(24,24),Text="✦",Font=Enum.Font.GothamBold,TextSize=22,TextColor3=accent,TextTransparency=1,ZIndex=4,Active=false},stage)
  end
  local name=text(featured,data and data.DisplayName or "CRAX SOURIRE",24,0,450,54,36,C.white);name.Font=Enum.Font.FredokaOne
  local badge=box(featured,"ExistingRarity",accent,2)
  local rarityLabel=text(badge,data and string.upper(data.Rarity) or "",12,2,230,28,17,ink)
  local slogan=text(featured,"UN SOURIRE.\nQUATRE ÉVOLUTIONS.",24,0,430,82,27,accent);slogan.Font=Enum.Font.FredokaOne
  local body=text(featured,"Morsures, langue fouettante, vol de vie… puis Dévoreur MAX.",24,0,410,65,20,C.muted)
  local discover=button(featured,"DÉCOUVRIR SON ARBRE  ›",24,0,420,54,accent,function()select("Crax_Monster")end)
  discover.Name="DiscoverExistingCraxTree";discover.TextColor3=ink;discover.Font=Enum.Font.FredokaOne;discover.TextSize=20
  local secondary={}
  for _,id in ipairs({"Crax_Spidey","Crax_Ghosty"})do
   local d=catalog[id]
   if d then
    local col=d.RarityColor or rarity[d.Rarity] or C.gold
    local f=box(sc,"ExistingCrax_"..id,dark)
    local r=text(f,string.upper(d.Rarity),18,12,230,24,16,col)
    local n=text(f,d.DisplayName,18,43,230,34,25,C.white);n.Font=Enum.Font.FredokaOne
    local b=text(f,"Dans Casin'O Crax",18,88,230,26,17,C.muted)
    local v=preview(f,id,250,8,150,140)
    secondary[#secondary+1]={f=f,r=r,n=n,b=b,v=v}
   end
  end
  local articles={}
  for _,news in ipairs(style.News or {})do
   local f=box(sc,"ExistingNews",dark)
   local v=preview(f,news.Crax or "Crax_Monster",12,12,140,140)
   local title=text(f,news.Title or "ACTUALITÉ",173,16,700,36,25,accent);title.Font=Enum.Font.FredokaOne
   local bodyLabel=text(f,news.Body or "",173,60,700,85,20,C.muted)
   articles[#articles+1]={f=f,v=v,title=title,body=bodyLabel}
  end
  local compact=false
  local lastW,lastH
  local function layout()
   local size=gui.AbsoluteSize
   if size.X<=0 or size.Y<=0 then return end
   if size.X==lastW and size.Y==lastH then return end
   lastW,lastH=size.X,size.Y
   compact=size.X<800 or size.X/size.Y<1.1
   -- Restore the shared shell first; only News overrides it, and teardown restores it.
   for o,props in pairs(saved)do if o.Parent then for key,value in pairs(props)do o[key]=value end end end
   local width=compact and 720 or 1080
   local height=compact and math.clamp(720*size.Y/size.X*.95,650,1320) or 720
   set(panel,{Size=UDim2.fromOffset(width,height)})
   set(content,{Position=UDim2.fromOffset(24,153),Size=UDim2.fromOffset(width-48,height-218)})
   set(message,{Position=UDim2.fromOffset(28,height-53),Size=UDim2.fromOffset(width-56,34)})
   if compact then
    set(coinPill,{Position=UDim2.fromOffset(350,14),Size=UDim2.fromOffset(181,40)})
    set(gemPill,{Position=UDim2.fromOffset(350,60),Size=UDim2.fromOffset(181,40)})
    for _,child in ipairs(panel:GetChildren())do
     if child:IsA("TextLabel")and child.Text=="COLLECTION • COMPÉTENCES • TROPHÉES"then set(child,{Size=UDim2.fromOffset(235,28),TextSize=11})end
    end
   end
   local close=panel:FindFirstChild("CloseCopEm")
   if close then set(close,{Position=UDim2.fromOffset(width-70,22),Size=UDim2.fromOffset(47,43)})end
   for i,id in ipairs({"News","Skills","Support"})do
    set(tabs[id],{Position=UDim2.fromOffset(26+(i-1)*(width-48)/3,105),Size=UDim2.fromOffset((width-48)/3-10,35),TextSize=compact and 13 or 16})
   end
   local w=width-56
   local fh=compact and 780 or 446
   featured.Position=UDim2.fromOffset(4,5);featured.Size=UDim2.fromOffset(w,fh)
   heading.Size=UDim2.fromOffset(w-48,44)
   stage.Position=compact and UDim2.fromOffset(65,66) or UDim2.fromOffset(498,60)
   stage.Size=compact and UDim2.fromOffset(w-130,350) or UDim2.fromOffset(500,360)
   name.Position=UDim2.fromOffset(24,compact and 432 or 85);name.Size=UDim2.fromOffset(compact and w-48 or 460,54)
   badge.Position=UDim2.fromOffset(24,compact and 494 or 150);badge.Size=UDim2.fromOffset(250,34)
   slogan.Position=UDim2.fromOffset(24,compact and 544 or 202);slogan.Size=UDim2.fromOffset(compact and w-48 or 450,76)
   body.Position=UDim2.fromOffset(24,compact and 628 or 287);body.Size=UDim2.fromOffset(compact and w-48 or 440,62)
   discover.Position=UDim2.fromOffset(24,compact and 706 or 365);discover.Size=UDim2.fromOffset(compact and w-48 or 440,54)
   local y=fh+25
   for i,e in ipairs(secondary)do
    local sw=compact and w or (w-16)/2
    e.f.Position=UDim2.fromOffset(4+(compact and 0 or (i-1)*(sw+16)),y+(compact and (i-1)*166 or 0));e.f.Size=UDim2.fromOffset(sw,150)
    if e.v then e.v.Position=UDim2.fromOffset(sw-154,5);e.v.Size=UDim2.fromOffset(145,140)end
    e.n.Size=UDim2.fromOffset(sw-180,34)
   end
   y=y+(compact and #secondary*166 or (#secondary>0 and 166 or 0))
   for _,e in ipairs(articles)do
    local h=compact and 196 or 170
    e.f.Position=UDim2.fromOffset(4,y);e.f.Size=UDim2.fromOffset(w,h)
    e.title.Size=UDim2.fromOffset(w-195,42);e.body.Size=UDim2.fromOffset(w-195,h-70)
    y=y+h+16
   end
   sc.CanvasSize=UDim2.fromOffset(0,y+12)
  end
  local elapsed=0
  local accumulator=0
  local function active()
   return alive and shade.Visible and gui.Enabled and sc.Parent~=nil
  end
  local function stop()
   if heartbeat then heartbeat:Disconnect();heartbeat=nil end
   cancelTweens()
  end
  local function start()
   stop()
   if not active()then return end
   layout();elapsed=0;accumulator=0;featured.GroupTransparency=1;revealScale.Scale=.965
   tween(featured,.28,{GroupTransparency=0})
   tween(revealScale,.4,{Scale=1},Enum.EasingStyle.Back)
   heartbeat=RunService.Heartbeat:Connect(function(dt)
    accumulator=accumulator+dt
    if accumulator<(UserInputService.TouchEnabled and 1/20 or 1/30)then return end
    elapsed=elapsed+accumulator;accumulator=0
    rays.Rotation=(elapsed*5)%360
    for i,h in ipairs(halo)do h.BackgroundTransparency=.96-i*.015+math.sin(elapsed*1.4)*.012 end
    local count=UserInputService.TouchEnabled and 4 or 6
    for i,p in ipairs(sparks)do
     local phase=(elapsed*.32+i*.173)%1
     local a=i*2.39996
     p.Visible=i<=count
     p.Position=UDim2.fromScale(.5+math.cos(a)*(.33+phase*.05),.5+math.sin(a)*.34-phase*.035)
     p.TextTransparency=1-math.sin(phase*math.pi)^4*.72;p.Rotation=phase*30
    end
    local phase=elapsed%7
    shine.Offset=Vector2.new(phase<1.2 and (-1+phase/1.2*2) or 1,0)
   end)
  end
  bind(shade:GetPropertyChangedSignal("Visible"),start)
  bind(gui:GetPropertyChangedSignal("Enabled"),start)
  bind(gui:GetPropertyChangedSignal("AbsoluteSize"),layout)
  sc.Destroying:Connect(function()
   alive=false;stop()
   for _,c in ipairs(connections)do c:Disconnect()end
   for o,props in pairs(saved)do if o.Parent then for key,value in pairs(props)do o[key]=value end end end
   table.clear(saved)
  end)
  layout();start()
 elseif currentTab=="Support"then
  sc.CanvasSize=UDim2.fromOffset(0,510)
  local titles={"CRAXGEMS","PASS'CRAX","SOUTIEN"}
  local bodies={"Les doublons de Casin'O Crax rapportent des CraxGems. Les packs Robux seront disponibles après configuration.","Le contenu du Pass'Crax et ses modalités seront présentés ici après configuration.","Les dons de soutien seront activés après configuration des produits Roblox."}
  for i=1,3 do
   local f=card(sc,4+(i-1)*342,8,327,465,i==1 and C.blue or C.gold);glitter(f,i==1 and C.blue or C.gold,7)
   emblem(f,i==1 and "Gems"or "Devourer",i==1 and C.blue or C.gold,96,43,135)
   text(f,titles[i],19,199,290,42,27,C.white)
   text(f,bodies[i],19,264,290,117,18,C.muted)
   local b=button(f,"BIENTÔT DISPONIBLE",20,405,287,39,C.card,function()end);b.Active=false
  end
 else
  local ids={};for id in pairs(config)do if catalog[id]then ids[#ids+1]=id end end
  table.sort(ids,function(a,b)local oa,ob=config[a].Order or 100,config[b].Order or 100;return oa==ob and a<b or oa<ob end)
  if not config[currentCrax]or not catalog[currentCrax]then currentCrax=ids[1]end
  if not currentCrax then text(sc,"Aucun arbre configuré",20,20,800,60,26,C.gold);return end
  -- Navigation only through owned Crax; locked collection entries remain in the picker.
  local ownedIds={};for _,id in ipairs(ids)do if own(id)then ownedIds[#ownedIds+1]=id end end
  local currentIndex;for n,id in ipairs(ownedIds)do if id==currentCrax then currentIndex=n end end
  local function navigate(id)skillPopupOpen=false;select(id)end
  if currentIndex and currentIndex>1 then local back=button(sc,"‹",7,220,46,65,Color3.fromRGB(90,57,27),function()navigate(ownedIds[currentIndex-1])end);back.Name="PreviousOwnedCrax";back.TextSize=44;back.ZIndex=20;back.Visible=bookOpened;bookNav[#bookNav+1]=back end
  if currentIndex and currentIndex<#ownedIds then local next=button(sc,"›",979,220,46,65,Color3.fromRGB(90,57,27),function()navigate(ownedIds[currentIndex+1])end);next.Name="NextOwnedCrax";next.TextSize=44;next.ZIndex=20;next.Visible=bookOpened;bookNav[#bookNav+1]=next end
  local picker=make("Frame",{Name="CraxBookPicker",Position=UDim2.fromOffset(605,40),Size=UDim2.fromOffset(360,math.min(340,65+#ids*52)),BackgroundColor3=Color3.fromRGB(244,226,184),BorderSizePixel=0,Visible=false,ZIndex=95},sc);round(picker,12);rim(picker,Color3.fromRGB(106,65,29))
  local pickerTitle=text(picker,"CHOISIR UN CRAX",16,10,278,35,25,Color3.fromRGB(46,28,16));pickerTitle.ZIndex=96
  local dismiss=button(picker,"×",309,9,35,35,Color3.fromRGB(102,58,27),function()picker.Visible=false end);dismiss.ZIndex=96
  local choices=make("ScrollingFrame",{Position=UDim2.fromOffset(12,53),Size=UDim2.new(1,-24,1,-63),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.fromOffset(0,#ids*52),ZIndex=96},picker)
  for n,id in ipairs(ids)do
   local choice=button(choices,catalog[id].DisplayName,0,(n-1)*52,329,46,Color3.fromRGB(104,67,32),function()picker.Visible=false;navigate(id)end)
   choice.Name="Choose_"..id;choice.TextSize=24;choice.ZIndex=97
   if not own(id)then choice.Text=choice.Text.." • VERROUILLÉ";choice.Active=false end
  end
  local spec=config[currentCrax];local data=catalog[currentCrax];local lv=level(currentCrax);local owned=own(currentCrax)
  local total=#(spec.Upgrades or {});local color=Color3.fromRGB(88,58,27)
  if not selectedSkill or selectedSkill>total then selectedSkill=math.min(lv+1,math.max(1,total))end
  -- Thick leather cover, stepped paper edges, two independent pages, central binding.
  local shadow=make("Frame",{Position=UDim2.fromOffset(13,81),Size=UDim2.fromOffset(1008,414),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0},sc);round(shadow,18)
  if cinema then cinema:SetHome(sc,UDim2.fromOffset(5,48),UDim2.fromOffset(1016,452));cinema:SetProgress(lv);cinema:SetCrax(currentCrax,data.TemplateName)end
  local cover=make("Frame",{Name="NewIllustratedGrimoire",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(513,274),Size=UDim2.fromOffset(1016,452),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=false,ZIndex=5},sc);book=cover
  bookScale=make("UIScale",{Scale=1},cover)
  for _,o in ipairs(cover:GetChildren())do if o:IsA("UIStroke")then o.Enabled=false end end
  -- No parent gradient: preserve ivory pages and untinted text/character.
  local function page(x,w)
   local f=make("Frame",{Position=UDim2.fromOffset(x,9),Size=UDim2.fromOffset(w,416),BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(241,226,184),BorderSizePixel=0,ClipsDescendants=true},cover);round(f,9)
   gradient(f,Color3.fromRGB(248,235,201),Color3.fromRGB(225,205,158),115)
   for y=30,370,24 do make("Frame",{Position=UDim2.fromOffset(14,y),Size=UDim2.new(1,-28,0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BackgroundTransparency=.975,BorderSizePixel=0},f)end
   for _,v in ipairs({{12,12,0},{w-29,12,90},{12,364,270},{w-29,364,180}})do
    local flourish=text(f,"⌜",v[1],v[2],18,18,21,Color3.fromRGB(171,123,65));flourish.Rotation=v[3]
   end
   local visuals=RS:FindFirstChild("CraxBookVisuals");local parchment=visuals and visuals:FindFirstChild("Parchment")
   if parchment and parchment.Value~=""then make("ImageLabel",{Name="ParchmentGrain",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=parchment.Value,ImageTransparency=.92,ZIndex=1},f)end
   return f
  end
  local left=page(95,458);local right=page(520,460)
  right.Size=UDim2.fromOffset(460,465)
  left.Position=UDim2.fromOffset(95,20);right.Position=UDim2.fromOffset(520,20)
  make("UIScale",{Scale=.85},left);make("UIScale",{Scale=.85},right)
  local artFolder=RS:FindFirstChild("CraxBookVisuals");local art=artFolder and artFolder:FindFirstChild("OpenArt")
  if art and art.Value~=""then
   local background=make("ImageLabel",{Name="IllustratedOpenGrimoire",Size=UDim2.fromScale(1,1),Image=art.Value,BackgroundTransparency=1,ZIndex=1},cover)
   left.ZIndex=2;right.ZIndex=2;left.BackgroundTransparency=1;right.BackgroundTransparency=1
  end
  -- Separate 3D character window sits above the painted page; no brown cover occlusion.
  heroView=preview(left,currentCrax,85,116,288,181)
  text(left,"BESTIAIRE : CRAXTOYS",58,10,378,34,24,Color3.fromRGB(91,57,24))
  local title=text(left,data.DisplayName,22,46,412,43,34,Color3.fromRGB(61,36,19));title.TextXAlignment=Enum.TextXAlignment.Center
  local rarityColor=rarity[data.Rarity]or C.gold
  local rare=text(left,tostring(data.Rarity):upper(),22,91,412,30,24,rarityColor);rare.TextXAlignment=Enum.TextXAlignment.Center
  -- The Crax is a model in the book WorldModel. This area has no separate viewport.
  if currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then
   local earned=make("Frame",{Name="EarnedTrophy",Position=UDim2.fromOffset(359,228),Size=UDim2.fromOffset(88,88),BackgroundTransparency=1,ZIndex=4},left)
   if currentCrax=="Crax_Deadly"then require(RS:WaitForChild("CraxDeadlyIcons")).Build(earned,"DeadlyFather")elseif currentCrax=="Crax_Ghosty"then require(RS:WaitForChild("CraxGhostyTrophyIcons")).Build(earned)elseif currentCrax=="Crax_Spidey"then SpideyIcons.Build(earned,"Weaver")else TrophyIcons.Build(earned)end
   local name=text(left,currentCrax=="Crax_Golden"and "VRAIE RICHESSE"or currentCrax=="Crax_Plumber"and "MAMAMIA"or currentCrax=="Crax_Ghosty"and "EXÉCUTION FANTÔME"or currentCrax=="Crax_Spidey"and "TISSEUR"or "DEVOREUR",316,300,130,29,currentCrax=="Crax_Ghosty"and 13 or 21,Color3.fromRGB(103,67,34));name.TextXAlignment=Enum.TextXAlignment.Center
   if currentCrax=="Crax_Fantastic"then name.Text="FANTASTIC"elseif currentCrax=="Crax_Deadly"then name.Text="PÈRE DE FAMILLE"end
   -- CraxTrophyCaptionCentered_v2
   name.Name="CraxTrophyCaption"
   name.AnchorPoint=Vector2.new(.5,0)
   name.Position=UDim2.new(earned.Position.X.Scale,earned.Position.X.Offset+earned.Size.X.Offset/2,earned.Position.Y.Scale,earned.Position.Y.Offset+earned.Size.Y.Offset+6)
   name.Size=UDim2.fromOffset(126,32)
   name.TextXAlignment=Enum.TextXAlignment.Center
   name.TextYAlignment=Enum.TextYAlignment.Center
   name.TextScaled=true;name.TextWrapped=false;name.ZIndex=8
   local captionLimit=Instance.new("UITextSizeConstraint")
   captionLimit.MinTextSize=10;captionLimit.MaxTextSize=20;captionLimit.Parent=name

  end
  local status=not owned and "À DÉBLOQUER"or lv==4 and(currentCrax=="Crax_Golden"and "MAX · VRAIE RICHESSE"or currentCrax=="Crax_Deadly"and "MAX · PÈRE DE FAMILLE"or currentCrax=="Crax_Fantastic"and "MAX · FANTASTIC"or currentCrax=="Crax_Ghosty"and "MAX · EXÉCUTION FANTÔME"or currentCrax=="Crax_Spidey"and "MAX · TISSEUR"or currentCrax=="Crax_Plumber"and "MAX · MAMAMIA"or "MAX · DEVOREUR")or lv>0 and("NIVEAU "..lv)or "CRAX DE BASE"
  local levelColor=lv<=0 and Color3.fromRGB(0,0,0)or metals[math.min(lv,4)]
  local statusText=text(left,status,26,316,430,42,28,levelColor);statusText.Name="CraxLevelTitle";statusText.Font=Enum.Font.GothamBold;statusText.TextXAlignment=Enum.TextXAlignment.Center
  if lv>=4 then statusText.Size=UDim2.fromOffset(292,42);if currentCrax=="Crax_Ghosty"then statusText.TextScaled=true end end
  if lv>0 then
   -- Embossed lettering: lower shadow and upper bevel, both behind the face.
   local shadow=text(left,status,27,318,statusText.Size.X.Offset,42,28,Color3.fromRGB(49,31,18));shadow.Name="LevelTitleRelief";if currentCrax=="Crax_Ghosty"and lv>=4 then shadow.TextScaled=true end;shadow.Font=Enum.Font.GothamBold;shadow.TextXAlignment=Enum.TextXAlignment.Center;shadow.TextTransparency=.22;shadow.ZIndex=3
   local bevel=text(left,status,25,315,statusText.Size.X.Offset,42,28,Color3.fromRGB(255,247,218));bevel.Name="LevelTitleBevel";if currentCrax=="Crax_Ghosty"and lv>=4 then bevel.TextScaled=true end;bevel.Font=Enum.Font.GothamBold;bevel.TextXAlignment=Enum.TextXAlignment.Center;bevel.TextTransparency=.3;bevel.ZIndex=3
   statusText.ZIndex=4;statusText.TextColor3=Color3.new(1,1,1);statusText.TextStrokeColor3=Color3.fromRGB(68,43,22);statusText.TextStrokeTransparency=.3
   local tones={
    {Color3.fromRGB(127,65,29),Color3.fromRGB(255,198,137),Color3.fromRGB(176,104,53)},
    {Color3.fromRGB(92,110,130),Color3.fromRGB(255,255,255),Color3.fromRGB(164,188,213)},
    {Color3.fromRGB(157,94,13),Color3.fromRGB(255,241,157),Color3.fromRGB(234,174,31)},
    {Color3.fromRGB(234,174,31),Color3.fromRGB(255,241,173),Color3.fromRGB(49,137,199)},
   }
   local tonesForLevel=tones[math.min(lv,4)]
   local gilded=make("UIGradient",{Name="LevelMetalShimmer",Rotation=15,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,tonesForLevel[1]),ColorSequenceKeypoint.new(.45,tonesForLevel[2]),ColorSequenceKeypoint.new(1,tonesForLevel[3])})},statusText)
   shineEntries[#shineEntries+1]={gradient=gilded,parent=statusText}
  end
  -- CraxMaxLayoutFix_v1
  if lv >= 4 then
   local caption = left:FindFirstChild("CraxTrophyCaption")
   local trophy = left:FindFirstChild("EarnedTrophy")
   if caption and trophy then
    caption.Size = UDim2.fromOffset(104, 28)
    caption.Position = UDim2.fromOffset(
     trophy.Position.X.Offset + trophy.Size.X.Offset / 2,
     trophy.Position.Y.Offset + trophy.Size.Y.Offset + 4
    )
    caption.TextScaled = true
    caption.TextWrapped = true
    local limit = caption:FindFirstChildWhichIsA("UITextSizeConstraint")
    if limit then limit.MinTextSize = 8; limit.MaxTextSize = 18 end
   end

   for _, item in ipairs(left:GetChildren()) do
    if item.Name == "CraxLevelTitle"
     or item.Name == "LevelTitleRelief"
     or item.Name == "LevelTitleBevel" then
     local dx = item.Name == "LevelTitleRelief" and 1
      or item.Name == "LevelTitleBevel" and -1 or 0
     local dy = item.Name == "LevelTitleRelief" and 2
      or item.Name == "LevelTitleBevel" and -1 or 0
     item.Position = UDim2.fromOffset(22 + dx, 350 + dy)
     item.Size = UDim2.fromOffset(414, 28)
     item.TextScaled = true
     item.TextWrapped = false
     item.TextXAlignment = Enum.TextXAlignment.Center
     item.TextYAlignment = Enum.TextYAlignment.Center
    end
   end
  end

  local track=make("Frame",{Position=UDim2.fromOffset(42,380),Size=UDim2.fromOffset(373,7),BackgroundColor3=C.card,BorderSizePixel=0},left);round(track,4)
  local progress=make("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BorderSizePixel=0},track);gaugeFill=progress;round(progress,4);gradient(progress,C.red,Color3.fromRGB(91,57,24),0)
  text(right,"LES ÉVOLUTIONS",22,9,320,36,29,Color3.fromRGB(91,57,24))
  local search=button(right,"",366,8,65,47,Color3.fromRGB(126,82,39),function()picker.Visible=not picker.Visible end);search.Name="SearchCrax";search.ZIndex=8
  local lens=make("Frame",{Position=UDim2.fromOffset(19,9),Size=UDim2.fromOffset(22,22),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=9},search);round(lens,100)
  make("UIStroke",{Color=Color3.fromRGB(255,237,195),Thickness=3},lens)
  make("Frame",{Position=UDim2.fromOffset(39,29),Size=UDim2.fromOffset(13,4),Rotation=45,BackgroundColor3=Color3.fromRGB(255,237,195),BorderSizePixel=0,ZIndex=9},search)
  if not spec.Enabled or total==0 then
   local seal=text(right,"?",150,88,190,160,110,Color3.fromRGB(105,105,122));seal.TextXAlignment=Enum.TextXAlignment.Center
   text(right,"CHAPITRE SCELLÉ",35,260,424,37,27,Color3.fromRGB(91,57,24)).TextXAlignment=Enum.TextXAlignment.Center
   text(right,"Les compétences de ce Crax seront révélées ici lorsqu'elles seront disponibles.",45,306,404,57,17,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
  else
   local positions={Vector2.new(58,103),Vector2.new(398,155),Vector2.new(58,207),Vector2.new(398,259)}
   local stepWidth=218
   -- All four medallions fit on the right page. No horizontal card carousel.
   for i,upgrade in ipairs(spec.Upgrades)do
    local revealed=Prestige.CanReveal(lv,i);local acquired=lv>=i;local nextAvailable=owned and i==lv+1
    local metal=revealed and Color3.fromRGB(145,102,35)or Color3.fromRGB(91,78,55)
    local center=positions[i]or Vector2.new(130,110);local cx,cy=center.X,center.Y
    if i<total then
     local nextPosition=positions[i+1]
     if nextPosition then
      local delta=nextPosition-center;local length=delta.Magnitude
      local direction=delta/length;local start=center
      local rail=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset((center.X+nextPosition.X)/2,(center.Y+nextPosition.Y)/2),Size=UDim2.fromOffset(length,3),Rotation=math.deg(math.atan2(delta.Y,delta.X)),BackgroundColor3=Color3.fromRGB(108,79,43),BackgroundTransparency=1,BorderSizePixel=0},right);round(rail,5)
      local beam=make("Frame",{Name="LevelThread_"..i,Size=UDim2.fromScale(lv>=i and 1 or 0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BorderSizePixel=0},rail);round(beam,5);gradient(beam,C.red,Color3.fromRGB(91,57,24),0);links[i]=beam
     end
    end
    local pedestal=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(cx,cy),Size=UDim2.fromOffset(74,74),BackgroundColor3=Color3.fromRGB(128,83,39),BackgroundTransparency=.12,BorderSizePixel=0},right);round(pedestal,100)
    local node=make("TextButton",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(cx,cy),Size=UDim2.fromOffset(62,62),BackgroundColor3=Color3.fromRGB(216,181,112),BorderSizePixel=0,AutoButtonColor=false,Text="",ZIndex=3},right);round(node,100);rim(node,metal);gradient(node,Color3.fromRGB(229,204,150),Color3.fromRGB(162,113,59),120)
    local cs=make("UIScale",{Scale=1},node)
    -- CraxTrophyStates_v1
    if i==4 and currentCrax=="Crax_Inverted"then
     if revealed then emblem(node,upgrade.Id,metal,3,3,56)else local hidden=text(node,"?",0,0,62,62,35,C.muted);hidden.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 then
     local holder=make("Frame",{Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(56,56),BackgroundTransparency=1,ZIndex=4},node)
     if currentCrax=="Crax_Deadly"then require(RS:WaitForChild("CraxDeadlyIcons")).Build(holder,"DeadlyFather",not acquired)else require(RS:WaitForChild("CraxTrophyIcons")).Build(holder,acquired)end
    elseif revealed then emblem(node,upgrade.Id or "FiveBites",metal,3,3,56)
    else
     local mystery=text(node,"?",0,0,62,45,39,Color3.fromRGB(118,122,139));mystery.TextXAlignment=Enum.TextXAlignment.Center
     text(node,"SCELLÉ",0,44,62,18,12,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
    end
    if nextAvailable or selectedSkill==i and revealed then rim(node,Color3.fromRGB(139,85,25))end
    local ring=circleCharge(node,Color3.fromRGB(255,133,30));ring:Set(acquired and 1 or 0)
    if acquired then local edge=make("UIStroke",{Color=Color3.fromRGB(255,135,25),Thickness=2,Transparency=.2},node);local g=gradient(edge,Color3.fromRGB(255,87,15),Color3.fromRGB(255,207,74),0);neonEntries[#neonEntries+1]={edge=edge,g=g}end
    local top=text(node,i==total and i==4 and "MAX"or string.format("%02d",i),-7,-9,36,24,16,metal);top.ZIndex=5;top.TextXAlignment=Enum.TextXAlignment.Center
    local name=text(right,i==4 and ""or(revealed and upgrade.Name or "ÉVOLUTION MYSTÈRE"),106,cy-23,243,46,24,revealed and Color3.fromRGB(61,36,19) or Color3.fromRGB(71,49,29));name.TextXAlignment=Enum.TextXAlignment.Center;name.BorderSizePixel=0;name.BackgroundTransparency=.1;name.BackgroundColor3=Color3.fromRGB(243,227,187);name.ZIndex=4;name.Visible=i~=4
    local badge=text(node,acquired and "✓"or nextAvailable and "✦"or "",42,43,22,19,14,metal);badge.ZIndex=5;badge.TextXAlignment=Enum.TextXAlignment.Center
    node.Name="SkillSeal_"..i;nodes[i]={node=node,card=node,scale=cs,top=badge,ring=ring}
    if nextAvailable then pulseEntries[#pulseEntries+1]={scale=cs}end
    local sealFill=make("Frame",{Size=UDim2.fromScale(0,1),BackgroundTransparency=1,Visible=false},node)
    local sealLabel=make("TextLabel",{Text="",Visible=false},node)
    node.InputBegan:Connect(function(input)
     if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
     if not nextAvailable or paymentPopup and paymentPopup.Parent or not available(currentCrax,i)then return end
     cancelHold();selectedSkill=i;skillPopupOpen=false
     local old=panel:FindFirstChild("BurntParchmentDescription");if old then old:Destroy()end
     hold={button=node,fill=sealFill,label=sealLabel,caption="",input=input,start=os.clock(),id=currentCrax,step=i,currency="Coins",cardScale=cs,seal=true}
     message.Text="Maintiens pour remplir le sceau • paiement à confirmer ensuite."
    end)
    node.MouseLeave:Connect(function()if hold and hold.button==node and hold.input.UserInputType==Enum.UserInputType.MouseButton1 then cancelHold()end end)
    node.MouseEnter:Connect(function()if revealed and not hold and not celebration then play("Hover");TweenService:Create(cs,TweenInfo.new(.15),{Scale=1.06}):Play()end end)
    node.MouseLeave:Connect(function()if not hold and not celebration then TweenService:Create(cs,TweenInfo.new(.2),{Scale=1}):Play()end end)
    node.Activated:Connect(function()
     if switching or hold or pending or celebration or paymentPopup and paymentPopup.Parent or os.clock()<suppressSealClickUntil or cinema and cinema.mode=="chapter"or os.clock()<pageTurningUntil then return end
     if not revealed then message.Text="Achète le niveau précédent pour briser ce sceau.";return end
     selectedSkill=i;skillPopupOpen=true;play("Click");rebuild()
    end)
   end
   if owned and lv<total then
    local all=button(right,"TOUT ACHETER",218,416,232,42,Color3.fromRGB(196,116,25),function()choosePayment(currentCrax,level(currentCrax)+1,true)end)
    all.Name="BuyAllSkills";all.TextSize=25;all.ZIndex=8;all.Active=not pending and not celebration
   end
   local i=selectedSkill;local upgrade=spec.Upgrades[i];local reveal=Prestige.CanReveal(lv,i);local metal=Color3.fromRGB(59,36,18)
   make("Frame",{Position=UDim2.fromOffset(22,304),Size=UDim2.fromOffset(418,1),BackgroundColor3=Color3.fromRGB(91,57,24),BackgroundTransparency=.68,BorderSizePixel=0},right)
   -- Skill names are already attached to their seals; no repeated footer title.
   local help=text(right,"Clique sur un sceau pour lire ses effets",22,286,418,43,28,Color3.fromRGB(48,29,17));help.TextXAlignment=Enum.TextXAlignment.Center
   if skillPopupOpen and bookOpened then
    local popup=make("Frame",{Name="BurntParchmentDescription",Position=UDim2.fromOffset(183,178),Size=UDim2.fromOffset(714,326),BackgroundColor3=Color3.fromRGB(66,32,15),BorderSizePixel=0,ZIndex=100},panel);round(popup,16)
    local paper=make("Frame",{Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,1,-16),BackgroundColor3=Color3.fromRGB(249,235,198),BorderSizePixel=0,ZIndex=101},popup);round(paper,12)
    gradient(paper,Color3.fromRGB(254,245,219),Color3.fromRGB(215,176,111),105)
    rim(paper,Color3.fromRGB(133,74,31))
    emblem(paper,upgrade.Id,C.gold,24,89,112)
    for _,art in ipairs(paper:GetDescendants())do if art:IsA("GuiObject")then art.ZIndex=102 end end
    local heading=text(paper,upgrade.Name,158,18,460,57,32,Color3.fromRGB(42,25,14));heading.Font=Enum.Font.Antique;heading.ZIndex=102
    local scroll=make("ScrollingFrame",{Position=UDim2.fromOffset(158,86),Size=UDim2.new(1,-186,1,-108),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=102},paper)
    local description=make("TextLabel",{Size=UDim2.new(1,-15,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=upgrade.Description,Font=Enum.Font.Gotham,TextSize=28,TextColor3=Color3.fromRGB(42,25,14),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ZIndex=103},scroll)
    local x=button(paper,"×",636,14,40,40,Color3.fromRGB(111,65,30),function()skillPopupOpen=false;popup:Destroy()end);x.TextSize=29;x.ZIndex=104
    -- Destroy on category/book close without intercepting the purchase controls below.
    local connection;connection=RunService.RenderStepped:Connect(function()if not popup.Parent then connection:Disconnect();return end;if not bookOpened or currentTab~="Skills"or cinema and cinema.mode=="closing"then popup:Destroy();skillPopupOpen=false;connection:Disconnect()end end)
   end
   if lv>=i then
   elseif owned and i==lv+1 then
    for n,currency in ipairs({"Coins","Gems"})do
     local cost=upgrade[currency];local caption=type(cost)=="number"and(number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems"))or "Non configuré"
     local b=holdButton(right,caption,250,334+(n-1)*35,200,33,currency=="Coins"and Color3.fromRGB(147,92,28)or Color3.fromRGB(30,102,143),currentCrax,i,currency,nodes[i].scale)
     if pending then b.Active=false;local label=b:FindFirstChild("PriceLabel");label.Text="VALIDATION…"end
    end
   else
    text(right,not owned and "CRAX À DÉBLOQUER"or "SCEAU VERROUILLÉ",250,369,200,34,18,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
    text(right,not owned and "Dans Casin'O Crax"or "Niveau précédent requis",22,372,214,40,16,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
   end
  end


  for _,o in ipairs(cover:GetDescendants())do if o:IsA("TextLabel")or o:IsA("TextButton")then if o.Name~="CraxLevelTitle"and o.Name~="LevelTitleRelief"and o.Name~="LevelTitleBevel"then o.Font=Enum.Font.Antique end;if o.Size.Y.Offset>=25 then o.TextSize=math.max(o.TextSize,24) end end end
  cover.Visible=bookOpened and cinema:ReadingVisible()
  bookPrompt=button(sc,"OUVRIR ?",371,451,290,45,Color3.fromRGB(70,43,24),function()
   if switching or not cinema or cinema.mode~="closed"then return end
   bookOpened=true;bookPrompt.Visible=false;cover.Visible=false
   cinema:Open(currentCrax,level(currentCrax),false,data.DisplayName)
  end)
  if total>0 and lv>=total then
   bookDustStarted=os.clock()
   for i=1,96 do
    local dust=make("Frame",{Name="CompletedBookGoldDust",Size=UDim2.fromOffset(i%3==0 and 4 or 2,i%3==0 and 4 or 2),BackgroundColor3=Color3.fromRGB(232,185,82),BorderSizePixel=0,ZIndex=12,Active=false},sc);round(dust,4)
    bookDust[#bookDust+1]={o=dust,seed=i*.618,life=1.5+(i%17)*.06}
   end
  end
  bookPrompt.Name="OpenBookPrompt";bookPrompt.Font=Enum.Font.Antique;bookPrompt.TextSize=25
  bookPrompt.Visible=not bookOpened
  if not bookOpened and cinema and cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter"then cinema:Closed()end
  sc.CanvasSize=UDim2.fromOffset(0,496)
 end
end
for i,item in ipairs({{"News","À LA UNE",C.gold},{"Skills","LIVRE DE COMPÉTENCES",C.blue},{"Support","GEMS & SOUTIEN",Color3.fromRGB(144,215,122)}})do
 local b=button(panel,item[2],26+(i-1)*344,105,333,35,item[3],function()tab(item[1])end);tabs[item[1]]=b
end
local ambient
if type(style.AmbientMusicId)=="string"and style.AmbientMusicId~=""then ambient=make("Sound",{Name="CopEmShopMusic",SoundId=style.AmbientMusicId,Volume=.12,Looped=true},gui)end
if ambient then
 local group=SoundService:FindFirstChild("CraxMusicControl");if group and group:IsA("SoundGroup")then ambient.SoundGroup=group end
end
connect(player:GetAttributeChangedSignal("CraxMusicMuted"),function()
 if ambient then if player:GetAttribute("CraxMusicMuted")then ambient:Pause()elseif shade.Visible then ambient:Resume()end end
end)
local function finishClose()
 shade.Visible=false;bookOpened=false;switching=false;if chapterSnapshot then chapterSnapshot:Destroy();chapterSnapshot=nil end;if ambient then ambient:Stop()end;if cinema then cinema:Hide()end
end
local function closeShop(instant)
 if cinema and cinema.mode=="chapter"then cinema:Skip()end
 cancelHold();celebration=nil;viewEpoch=viewEpoch+1;effectReset();for _,p in ipairs(burstPool)do p.Visible=false end
 if not instant and shade.Visible and currentTab=="Skills"and bookOpened and cinema then cinema:Close(finishClose)else finishClose()end
end
local function openShop()
 if player:GetAttribute("ArenaSeat")~=nil or player:GetAttribute("InventoryReady")~=true then return end
 viewEpoch=viewEpoch+1;bookOpened=false;shade.Visible=true;message.Text=pending and "Un achat attend encore sa confirmation."or "";rebuild();play("Open");if currentTab=="Skills"and cinema then cinema:Closed()end
 if openingTween then openingTween:Cancel()end;entrance.Value=.96
 openingTween=TweenService:Create(entrance,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Value=1});openingTween:Play()
 if ambient and not player:GetAttribute("CraxMusicMuted")then ambient:Play()end
end
open.Activated:Connect(openShop)
local shopClose=button(panel,"×",997,22,47,43,C.red,closeShop);shopClose.Name="CloseCopEm";shopClose.TextSize=29
local function visibility()
 local ready=player:GetAttribute("ArenaSeat")==nil and player:GetAttribute("InventoryReady")==true
 open.Visible=ready;if not ready then closeShop(true)end
end
connect(player:GetAttributeChangedSignal("ArenaSeat"),visibility);connect(player:GetAttributeChangedSignal("InventoryReady"),visibility)
local burstOrigin=Vector2.new(540,335)
local function originFor(node)
 local scale=math.max(panelScale.Scale,.001)
 return (node.AbsolutePosition+node.AbsoluteSize*.5-panel.AbsolutePosition)/scale
end
local function burst(node,color)
 burstOrigin=originFor(node);burstStart=os.clock()
 for _,p in ipairs(burstPool)do p.TextColor3=color end
end
cinema=require(RS:WaitForChild("CraxBookCinema")).new(gui,function()
 -- Skip never changes balances and never cancels an outstanding server request.
 cancelHold();celebration=nil;effectReset();selectedSkill=math.min(level(currentCrax)+1,#(config[currentCrax].Upgrades or {}))
 if shade.Visible and currentTab=="Skills"then rebuild()end
end,sounds.Click.SoundId,function()if shade.Visible and currentTab=="Skills"then rebuild()end end)
local replyConnection=remote.OnClientEvent:Connect(function(data)
 if type(data)~="table"or data.RequestId~=pending then return end
 local purchase=transaction;pending=nil;transaction=nil;message.Text=data.Message or ""
 if data.Success and purchase then
  local replicated=levels:FindFirstChild(purchase.id)
  if not replicated or replicated.Value<purchase.step then confirmedLevels[purchase.id]=purchase.step else confirmedLevels[purchase.id]=nil end
 end
 if data.Success and purchase and purchase.all then
  local target=data.Level or purchase.step
  confirmedLevels[purchase.id]=target
  if shade.Visible and currentTab=="Skills"and bookOpened and currentCrax==purchase.id and purchase.epoch==viewEpoch then
   selectedSkill=math.min(target+1,#config[purchase.id].Upgrades);rebuild();play("Success")
   for k=(data.FromLevel or purchase.from)+1,target do local n=nodes[k];if n then
    n.ring:Set(1,Color3.fromRGB(255,133,30));n.scale.Scale=.65;n.top.Text="✓"
    TweenService:Create(n.scale,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
   end end
   flash.BackgroundTransparency=.78;TweenService:Create(flash,TweenInfo.new(.45),{BackgroundTransparency=1}):Play()
  else schedule()end
  return
 end
 if data.Success and purchase and shade.Visible and currentTab=="Skills"and bookOpened and not switching and cinema.mode~="closing"and currentCrax==purchase.id and purchase.epoch==viewEpoch and nodes[purchase.step]then
  cancelHold()
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
  local n=nodes[purchase.step];local metal=metals[math.min(purchase.step,4)]
  n.top.Text="ÉVEIL EN COURS"
  celebration={start=os.clock(),step=purchase.step,id=purchase.id,phase=0,max=purchase.step==4}
  cinema:Celebrate(purchase.step,purchase.step==4)
  -- Brief anticipation precedes the confirmed impact.
  ceremonyText.Visible=true;ceremonySub.Visible=true;awardPlate.Visible=true
  ceremonyText.Text=purchase.step==4 and "CONSÉCRATION MAX"or "ÉVOLUTION ÉVEILLÉE"
  ceremonyText.TextColor3=purchase.step==4 and C.red or metal
  ceremonySub.Text=config[purchase.id].Upgrades[purchase.step].Name
  sounds.Charge:Stop()
  TweenService:Create(n.scale,TweenInfo.new(.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1.025}):Play()
 else if data.Success then selectedSkill=nil end;schedule()end
end)
local function bindLevel(v)if v:IsA("IntValue")then connect(v.Changed,function()if v.Value>=(confirmedLevels[v.Name]or 0)then confirmedLevels[v.Name]=nil end;schedule()end)end end
for _,v in ipairs(levels:GetChildren())do bindLevel(v)end;connect(levels.ChildAdded,bindLevel)
connect(smileAtlas.Changed,schedule)
local render=RunService.RenderStepped:Connect(function()
 if not gui.Parent then return end
 local time=os.clock();local camera=workspace.CurrentCamera
 if time-dustLast>=1/30 then dustLast=time
 for _,e in ipairs(bookDust)do if shade.Visible and e.o.Parent then
  local phase=((time-bookDustStarted)/e.life+e.seed)%1
  e.o.Position=UDim2.fromOffset(80+(e.seed%1)*860+math.sin(time*.4+e.seed)*12,475-phase*350)
  e.o.BackgroundTransparency=1-math.sin(phase*math.pi)*.7
 end end
 end
 if book and book.Parent then
  book.Visible=bookOpened and cinema:ReadingVisible()
  if bookScale then bookScale.Scale=cinema:ReadingScale()end
 end
 if book and book.Parent then
  book.Rotation=0
 end
 for _,nav in ipairs(bookNav)do if nav.Parent then nav.Visible=bookOpened and(cinema.mode=="idle"or cinema.mode=="ceremony")end end
 if bookPrompt and bookPrompt.Parent then bookPrompt.Visible=not bookOpened and cinema and cinema.mode=="closed"end
 if hold then
  local h=hold
  local touchOutside=false
  if h.input.UserInputType==Enum.UserInputType.Touch then
   local p=h.input.Position;local a=h.button.AbsolutePosition;local z=h.button.AbsoluteSize
   touchOutside=p.X<a.X or p.Y<a.Y or p.X>a.X+z.X or p.Y>a.Y+z.Y
  end
  if touchOutside or not shade.Visible or currentTab~="Skills"or currentCrax~=h.id or not h.button.Parent or not available(h.id,h.step)then cancelHold()
  else
   local progress=math.clamp((time-h.start)/HOLD_SECONDS,0,1)
   if gaugeFill then gaugeFill.Size=UDim2.fromScale(progress,1)end
   if gaugeCaption then gaugeCaption.Text="ÉVEIL • "..math.floor(progress*100).." %"end
   h.fill.Size=UDim2.fromScale(progress,1);h.label.Text="MAINTIENS • "..math.floor(progress*100).." %"
   h.cardScale.Scale=1+progress*.07+math.sin(time*28)*progress*.003
   local n=nodes[h.step]
   if n then
    n.ring:Set(progress,Color3.fromRGB(255,133,30))
    local center=originFor(n.node)
    for k,o in ipairs(orbit)do
     o.Visible=true
     local t=(time*.8+k/24)%1;local angle=k*2.39996+time*.8
     local radius=65+(1-t)*(90+progress*45)
     o.Position=UDim2.fromOffset(center.X+math.cos(angle)*radius,center.Y+math.sin(angle)*radius)
     o.BackgroundTransparency=1-math.sin(t*math.pi)*progress;o.BackgroundColor3=C.gold
    end
   end
   if cinema then cinema:Charge(progress)end
   if progress>=1 then local id,step,currency=h.id,h.step,h.currency;local seal=h.seal;cancelHold();if seal then suppressSealClickUntil=os.clock()+.5;choosePayment(id,step,false)else buy(id,step,currency)end end
  end
 end
 if celebration then
  local c=celebration;local age=time-c.start;
  local charge=math.clamp(age/2.05,0,1)
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(charge,1)end
  if gaugeCaption then gaugeCaption.Text="ÉVEIL • "..math.floor(charge*100).." %"end;local n=nodes[c.step]
  local metal=c.max and Color3.fromRGB(255,98,45)or metals[math.min(c.step,4)]
  local anticipation=.28;local impactEnd=.95;local arrival=2.05;local finish=c.max and 5.2 or 2.7
  if c.max then vignette.BackgroundTransparency=1-math.sin(math.clamp(age/finish,0,1)*math.pi)*.38 end
  if age<anticipation and n then n.scale.Scale=1-age*.25 end
  if age>=anticipation and c.phase==0 then
   c.phase=1
   if n then
    n.top.Text="ACQUIS ✓";burst(n.node,metal)
    TweenService:Create(n.scale,TweenInfo.new(.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1.1}):Play()
    shock.Position=UDim2.fromOffset(burstOrigin.X,burstOrigin.Y);shock.Visible=true;shockEdge.Color=metal
    n.ring:Set(1,Color3.fromRGB(255,133,30))
   end
   if cinema then cinema:Impact()end
  end
  if c.phase>0 then
   local impact=age-anticipation
   flash.BackgroundColor3=metal;flash.BackgroundTransparency=1-math.max(0,1-impact/.35)*.23
   shock.Size=UDim2.fromOffset(100+impact*180,100+impact*180);shockEdge.Transparency=math.clamp(impact/.8,0,1)
  end
  local link=links[c.step]
  if age>=impactEnd and not c.conductorStarted then c.conductorStarted=true;if cinema and not c.max then cinema:Conductor()end end
  if age>=impactEnd and link and link.Parent then
   local travel=math.clamp((age-impactEnd)/(arrival-impactEnd),0,1)
   link.Size=UDim2.fromScale(travel,1)
   local rail=link.Parent;local fit=math.max(panelScale.Scale,.001)
   local from=nodes[c.step]and originFor(nodes[c.step].node)
   local to=nodes[c.step+1]and originFor(nodes[c.step+1].node)
   local tip=from and to and from:Lerp(to,travel)or Vector2.new(0,0)
   spark.Visible=travel<1;spark.Position=UDim2.fromOffset(tip.X,tip.Y);spark.BackgroundColor3=metal
  end
  if age>=arrival and c.phase==1 and level(c.id)>=c.step then
   c.phase=2;selectedSkill=math.min(c.step+1,#config[c.id].Upgrades);rebuild()
   local nextNode=nodes[c.step+1]
   if nextNode then
    if cinema then cinema:Reveal()end;burst(nextNode.node,metals[math.min(c.step+1,4)])
    nextNode.scale.Scale=.78
    TweenService:Create(nextNode.scale,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    message.Text="Sceau brisé • prochaine évolution révélée."
   elseif c.max then
    ceremonyText.Text=config[c.id].Upgrades[c.step].Name.." • MAX"
    ceremonySub.Text="Trophée débloqué • animation de victoire activée"
    burst(nodes[c.step].node,metal)
    flash.BackgroundTransparency=.78
   end
  end
  if age>=finish and c.phase==2 then celebration=nil;effectReset();if cinema then cinema:EndCelebration()end;rebuild()end
 end
 if shade.Visible and camera then
  local fit=math.min(1,camera.ViewportSize.X*.95/(currentTab=="News" and panel.Size.X.Offset or 1080),camera.ViewportSize.Y*.9/(currentTab=="News" and panel.Size.Y.Offset or 720))
  panelScale.Scale=fit*entrance.Value
  for _,e in ipairs(previews)do if e.view.Parent and not e.locked then
   local yaw=math.sin(time*.6)*.10;local direction=CFrame.Angles(0,yaw,0):VectorToWorldSpace(e.front)
   local zoom=e.view==heroView and(hold and .08*math.clamp((time-hold.start)/HOLD_SECONDS,0,1)or celebration and .1 or 0)or 0
   e.camera.CFrame=CFrame.lookAt(e.center+direction*e.diameter*(1.95-zoom)+Vector3.new(0,math.sin(time*.9)*.05,0),e.center)
  end end
  for i=#particles,1,-1 do local e=particles[i]
   if not e.object.Parent then table.remove(particles,i)else
    local t=(time*.10+e.seed)%1;e.object.Position=UDim2.fromScale((e.seed*.73)%1,1-t)
    e.object.TextTransparency=.3+math.abs(.5-t)*1.1;e.object.Rotation=time*12
   end
  end
  local age=time-burstStart
  for i,p in ipairs(burstPool)do
   p.Visible=age>=0 and age<.8
   if p.Visible then local angle=i*2.39996;local radius=10+age*170
    p.Position=UDim2.fromOffset(burstOrigin.X+math.cos(angle)*radius,burstOrigin.Y+math.sin(angle)*radius*.6)
    p.TextTransparency=age/.8;p.Rotation=age*130
   end
  end
 end
 for _,e in ipairs(pulseEntries)do
  if e.scale.Parent and shade.Visible and not hold and not celebration then e.scale.Scale=1+math.sin(time*2.1)*.018 end
 end
 for _,e in ipairs(neonEntries)do
  if e.edge.Parent and shade.Visible then e.g.Rotation=(time*85)%360;e.edge.Transparency=.08+(.5+.5*math.sin(time*3))*.18 end
 end
 for i=#shineEntries,1,-1 do local e=shineEntries[i]
  if not e.parent.Parent then table.remove(shineEntries,i)
  elseif shade.Visible or e.parent:IsDescendantOf(open)then e.gradient.Offset=Vector2.new(math.sin(time*.7)*.23,0);e.gradient.Rotation=35+math.sin(time*.45)*35 end
 end
end)
-- Disconnect shared signals and dispose pooled sounds if the UI is replaced.
gui.Destroying:Connect(function()cancelHold();if cinema then cinema:Destroy()end;render:Disconnect();inputEnded:Disconnect();focusLost:Disconnect();replyConnection:Disconnect();for _,connection in ipairs(sharedConnections)do connection:Disconnect()end;for _,sound in pairs(sounds)do sound:Destroy()end end)
visibility()
]====]},
{path=[====[ReplicatedStorage.CraxBookCinema]====],bytes=11453,hash=2561612631,source=[====[-- GoldenBookTitleFix_v2
-- v8: one closed cover only; illustrated folios for opening/reading/transitions.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local CP=game:GetService("ContentProvider")
local Cinema={};Cinema.__index=Cinema
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function ease(t,a,b)local x=math.clamp((t-a)/(b-a),0,1);return x*x*(3-2*x)end
local specs={Room=.07,Seal=.15,Clasp=.2,Leather=.19,Page1=.18,Page2=.19,Page3=.18,Ink=.13,Charge=.16,Unlock=.27,Conductor=.17,Reveal=.22,Max=.32,Close=.21}
function Cinema.new(gui,onSkip,unused,onOpened)
 local self=setmetatable({gui=gui,onSkip=onSkip,onOpened=onOpened,alive=true,mode="hidden",audio={},connections={},charge=0},Cinema)
 self.short=Players.LocalPlayer:GetAttribute("CraxBookShortAnimations")==true
 self.overlay=make("Frame",{Name="GrimoireParking",Visible=false,BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},gui)
 self.scene=make("Frame",{Name="ChurchLecternScene",BackgroundColor3=Color3.fromRGB(10,9,8),BorderSizePixel=0,Size=UDim2.fromScale(1,1),Visible=false,ZIndex=1},self.overlay)
 local visuals=RS:WaitForChild("CraxBookVisuals")
 local room=visuals:FindFirstChild("RoomArt")
 self.roomArt=make("ImageLabel",{Name="DarkChurch",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=room and room.Value or "",ScaleType=Enum.ScaleType.Crop,ZIndex=1},self.scene)
 if room then self.connections[#self.connections+1]=room.Changed:Connect(function()self.roomArt.Image=room.Value end)end
 self.view=make("ViewportFrame",{Name="AncientBook3D",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Ambient=Color3.fromRGB(185,171,150),LightColor=Color3.fromRGB(255,243,216),LightDirection=Vector3.new(-.4,-1,-.7),ZIndex=2},self.overlay)
 self.world=make("WorldModel",{},self.view)
 self.camera=make("Camera",{FieldOfView=27},self.view);self.view.CurrentCamera=self.camera
 local meshes=RS:FindFirstChild("CraxBookMeshes");local donor=meshes and meshes:FindFirstChild("Cover")
 assert(donor and donor:IsA("MeshPart"),"Le MeshPart Cover manque dans CraxBookMeshes.")
 self.cover=donor:Clone()
 self.cover.Name="NewGrimoireCoverOnly";self.cover.Size=Vector3.new(5.2,.3,4.1);self.cover.Color=Color3.fromRGB(97,32,24)
 self.cover.Anchored=true;self.cover.CanCollide=false;self.cover.CanTouch=false;self.cover.CanQuery=false;self.cover.Parent=self.world
 -- No folio, page block, old seal, clasp or old grimoire geometry is created.
 for _,o in ipairs(self.cover:GetChildren())do if o:IsA("Decal")or o:IsA("SurfaceAppearance")then o:Destroy()end end
 self.cover.TextureID=""
 make("Decal",{Name="CorrectFacingCoverArt",Face=Enum.NormalId.Top,Texture=visuals:WaitForChild("CoverArt").Value},self.cover)
 self.cover.Color=Color3.fromRGB(54,17,14)
 self.base=CFrame.new(0,0,0)*CFrame.Angles(math.rad(28),math.pi,0)
 self.camera.CFrame=CFrame.lookAt(Vector3.new(0,6.8,13),Vector3.new(0,0,0),Vector3.new(0,1,0))
 self.skip=make("TextButton",{Name="SkipBookAnimation",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-23,0,12),Size=UDim2.fromOffset(100,34),BackgroundColor3=Color3.fromRGB(27,21,15),BackgroundTransparency=.2,Text="Passer ›",TextSize=14,Font=Enum.Font.Antique,TextColor3=Color3.fromRGB(235,219,183),Visible=false,ZIndex=110},gui)
 self.connections[#self.connections+1]=self.skip.Activated:Connect(function()self:Skip()end)
 self.trophyIcon=make("Frame",{Name="OriginalDevourerTrophy",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.48),Size=UDim2.fromOffset(176,176),BackgroundTransparency=1,Visible=false,ZIndex=112},gui)
 self.trophyArt=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},self.trophyIcon)
 local icons=RS:FindFirstChild("CraxTrophyIcons");if icons then require(icons).Build(self.trophyArt)end
 self.trophyScale=make("UIScale",{Scale=1},self.trophyIcon)
 make("TextLabel",{Name="TrophyTitle",Position=UDim2.fromOffset(-52,182),Size=UDim2.fromOffset(280,42),Text="DEVOREUR",TextSize=31,Font=Enum.Font.Antique,TextColor3=Color3.fromRGB(230,185,77),BackgroundTransparency=1,ZIndex=120},self.trophyIcon)
 local audioFolder=RS:FindFirstChild("CraxBookAudio");local pg=Players.LocalPlayer:WaitForChild("PlayerGui");local preload={self.roomArt}
 for name,volume in pairs(specs)do
  local value=audioFolder and audioFolder:FindFirstChild(name)
  local sound=make("Sound",{Name="Book"..name,SoundId=value and value.Value or "",Volume=volume,Looped=name=="Room"or name=="Charge"},pg)
  self.audio[name]=sound;preload[#preload+1]=sound
 end
 task.spawn(function()pcall(function()CP:PreloadAsync(preload)end)end)
 self.connections[#self.connections+1]=RunService.RenderStepped:Connect(function()self:_update()end)
 return self
end
function Cinema:_sound(name)local s=self.audio[name];if s and s.SoundId~=""then s:Stop();s.TimePosition=0;s:Play()end end
function Cinema:_stopLoops()for _,sound in pairs(self.audio)do if sound.Looped then sound:Stop()end end end
function Cinema:_stopSounds()for _,s in pairs(self.audio)do s:Stop()end end
function Cinema:SetProgress(level)self.level=level end
-- SpideyBookCinema_v1
function Cinema:SetCrax(id)
 if self.crax==id then return end;self.crax=id
 self.trophyArt:ClearAllChildren()
 if id=='Crax_Inverted'then
  make('TextLabel',{Size=UDim2.fromScale(1,1),Text='404',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(244,242,232),BackgroundTransparency=1,ZIndex=113},self.trophyArt)
  self.trophyIcon.TrophyTitle.Text='ERREUR 404';return
 end
 if id=="Crax_Spidey"then require(RS:WaitForChild("CraxSpideyIcons")).Build(self.trophyArt,"Weaver")
 else local icons=RS:FindFirstChild("CraxTrophyIcons");if icons then require(icons).Build(self.trophyArt)end end
 self.trophyIcon.TrophyTitle.Text=id=="Crax_Golden"and "VRAIE RICHESSE"or id=="Crax_Spidey"and "TISSEUR"or "DEVOREUR"
end -- The client already draws the Crax on its illustrated page.
function Cinema:SetHome(parent,pos,size)
 self.home={parent=parent,pos=pos,size=size}
 self.scene.Parent=parent;self.scene.Position=pos;self.scene.Size=size
 self.view.Parent=parent
 -- Cover sits on the central reading plane of the generated stone lectern.
 self.view.Position=UDim2.new(pos.X.Scale,pos.X.Offset+size.X.Offset*.18,pos.Y.Scale,pos.Y.Offset+size.Y.Offset*.17)
 self.view.Size=UDim2.fromOffset(size.X.Offset*.64,size.Y.Offset*.69)
 self.scene.Visible=self.mode~="hidden";self.view.Visible=self.mode=="closed"or self.mode=="opening"or self.mode=="closing"
 self.cover.CFrame=self.base
end
function Cinema:DetachHome()
 self.home=nil;self.scene.Parent=self.overlay;self.view.Parent=self.overlay
end
function Cinema:Closed()
 self.mode="closed";self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopSounds()
 self.scene.Visible=true;self.view.Visible=true;self.view.ImageTransparency=0;self.cover.CFrame=self.base
end
function Cinema:Open(id,level,chapterOnly,displayName)
 self:_stopSounds();self.mode="opening";self.start=os.clock();self.skip.Visible=true;self.scene.Visible=true;self.view.Visible=true;self.view.ImageTransparency=0
 self.fired={};self:_sound("Clasp")
end
function Cinema:ReadingVisible()
 return self.mode=="idle"or self.mode=="ceremony"or self.mode=="chapter"or self.mode=="opening"and(os.clock()-self.start)>.18 or self.mode=="closing"and(os.clock()-self.start)<.45
end
function Cinema:ReadingFade()
 if self.mode=="opening"then return 1-ease((os.clock()-self.start)/(self.short and .4 or .9),.2,.85)end
 if self.mode=="closing"then return ease((os.clock()-self.start)/.7,0,.6)end
 return 0
end
function Cinema:ReadingScale()
 if self.mode=="opening"then return .84+.16*ease((os.clock()-self.start)/(self.short and .4 or .9),.2,1)end
 if self.mode=="closing"then return 1-.1*ease((os.clock()-self.start)/.7,0,1)end
 return 1
end
function Cinema:_finishOpen()
 self.mode="idle";self.view.Visible=false;self.skip.Visible=false;self:_stopSounds();if self.onOpened then self.onOpened()end
end
function Cinema:TurnChapter(commit,finished)
 self.mode="chapter";self.start=os.clock();self.chapterCommit=commit;self.chapterFinished=finished;self.committed=false;self.skip.Visible=true;self.view.Visible=false;self:_sound("Page2")
end
function Cinema:ChapterProgress()return self.mode=="chapter"and math.clamp((os.clock()-self.start)/.68,0,1)or 0 end
function Cinema:_finishChapter()
 if not self.committed then self.committed=true;if self.chapterCommit then self.chapterCommit()end end
 local done=self.chapterFinished;self.chapterCommit=nil;self.chapterFinished=nil;self.mode="idle";self.skip.Visible=false;self.view.Visible=false
 if done then done()end
end
function Cinema:Close(callback)
 if self.mode=="closed"or not self.alive then if callback then callback()end;return end
 self:_stopSounds();self.mode="closing";self.start=os.clock();self.closeCallback=callback;self.skip.Visible=true;self.trophyIcon.Visible=false;self.view.Visible=true;self.view.ImageTransparency=1;self:_sound("Close")
end
function Cinema:_finishClose()local done=self.closeCallback;self.closeCallback=nil;self:Hide();if done then done()end end
function Cinema:Charge(value)self.charge=value;if value>0 and not self.audio.Charge.IsPlaying then self:_sound("Charge")end end
function Cinema:CancelCharge()self.charge=0;self.audio.Charge:Stop()end
function Cinema:Celebrate(step,isMax)self.mode="ceremony";self.start=os.clock();self.isMax=isMax;self.level=step;self.skip.Visible=true;self:CancelCharge()end
function Cinema:Impact()self:_sound(self.isMax and "Max"or "Unlock")end
function Cinema:Conductor()self:_sound("Conductor")end
function Cinema:Reveal()self:_sound("Reveal")end
function Cinema:EndCelebration()self.mode="idle";self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopLoops();self.view.Visible=false end
function Cinema:Skip()
 if self.mode=="opening"then self:_finishOpen()
 elseif self.mode=="chapter"then self:_finishChapter()
 elseif self.mode=="closing"then self:_finishClose()
 elseif self.mode=="ceremony"then self:EndCelebration();if self.onSkip then self.onSkip()end end
end
function Cinema:Hide()self.mode="hidden";self.scene.Visible=false;self.view.Visible=false;self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopSounds()end
function Cinema:_update()
 if not self.alive or self.mode=="hidden"then return end
 local now=os.clock()
 if self.mode=="opening"then
  local t=(now-self.start)/(self.short and .4 or .9)
  self.cover.CFrame=self.base*CFrame.Angles(0,0,-ease(t,0,.6)*.65)
  self.view.ImageTransparency=ease(t,.17,.55)
  if t>.2 and not self.fired.leather then self.fired.leather=true;self:_sound("Leather")end
  if t>.43 and not self.fired.page then self.fired.page=true;self:_sound("Page1")end
  if t>=1 then self:_finishOpen()end
 elseif self.mode=="closing"then
  local t=(now-self.start)/.7
  self.view.ImageTransparency=1-ease(t,.35,.85);self.cover.CFrame=self.base*CFrame.Angles(0,0,-.4*(1-ease(t,.35,1)))
  if t>=1 then self:_finishClose()end
 elseif self.mode=="chapter"then
  local t=self:ChapterProgress()
  if t>=.55 and not self.committed then self.committed=true;if self.chapterCommit then self.chapterCommit()end end
  if t>=1 then self:_finishChapter()end
 elseif self.mode=="ceremony"and self.isMax then
  local t=now-self.start;self.trophyIcon.Visible=t>.25 and t<5.2;self.trophyScale.Scale=.8+.2*ease(t,.25,1)
 end
end
function Cinema:Destroy()
 if not self.alive then return end;self:Hide();self.alive=false
 for _,c in ipairs(self.connections)do c:Disconnect()end
 for _,s in pairs(self.audio)do s:Destroy()end
 self.scene:Destroy();self.view:Destroy();self.overlay:Destroy();self.skip:Destroy();self.trophyIcon:Destroy()
end
return Cinema
]====]},
{path=[====[ServerScriptService.ArenaMovement]====],bytes=33935,hash=2630459306,source=[====[local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))
local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxCombinedFix_v7
-- GoldenCombatBase_v1
-- PlumberFix_v2
-- PlumberIntegration_v1
local Fleau=require(game:GetService('ServerScriptService'):WaitForChild('FleauRuntime'))
local Golden=require(game:GetService('ServerScriptService'):WaitForChild('CraxGoldenRuntime'))
local Plumber=require(game:GetService('ServerScriptService'):WaitForChild('CraxPlumberRuntime'))
local Deadly=require(game:GetService('ServerScriptService'):WaitForChild('CraxDeadlyRuntime'))
-- FantasticAbsolutePosition_v1
local PositionLock=require(game:GetService("ServerScriptService"):WaitForChild("CraxPositionLock"))
-- FantasticMovement_v1
local Fantastic=require(game:GetService("ServerScriptService"):WaitForChild("FantasticRuntime"))
-- GhostyGrandFrisson_v1
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxSpideySkills_v1
-- CopEmPremium_v3
local RunService = game:GetService("RunService")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local state = workspace:WaitForChild("CombatState")
state:SetAttribute("MovementReady", false)
local biteHit = SSS:WaitForChild("BiteHit", 10)
assert(biteHit and biteHit:IsA("BindableEvent"), "ArenaMovement : BiteHit manque.")
local fx = RS:FindFirstChild("CraxCombatFX")
if not fx then fx = Instance.new("RemoteEvent"); fx.Name = "CraxCombatFX"; fx.Parent = RS end
assert(fx:IsA("RemoteEvent"), "CraxCombatFX doit être un RemoteEvent.")
local old = workspace:FindFirstChild("SpideyWebVisuals")
if old then old:Destroy() end
local visuals = Instance.new("Folder"); visuals.Name = "SpideyWebVisuals"; visuals.Parent = workspace
local Night = require(SSS:WaitForChild("GhostyNight"))
local Skills=require(SSS:WaitForChild("CraxSpideyRuntime"))
local fighters = {}
local touching = false
local clock = 0
local function attr(f, key, fallback)
	local v = f.model:GetAttribute(key)
	return type(v) == "number" and v == v and math.abs(v) < math.huge and v or fallback
end
local function isSpider(f) return f.model:GetAttribute("AbilityId") == "SpideyWeb" end
local function speedOf(model)
	local s = model:GetAttribute("Speed")
	assert(type(s) == "number" and s > 0, "Speed invalide : " .. model.Name)
	return s
end
local function sound(head, name, id, volume)
	local oldSound = head:FindFirstChild(name); if oldSound then oldSound:Destroy() end
	local s = Instance.new("Sound"); s.Name = name; s.SoundId = id; s.Volume = volume
	s.RollOffMode = Enum.RollOffMode.InverseTapered; s.RollOffMinDistance = 60; s.RollOffMaxDistance = 180
	s.Parent = head; return s
end
local function anchor(name)
	local p = Instance.new("Part"); p.Name = name; p.Size = Vector3.one * 0.1; p.Transparency = 1
	p.Anchored = true; p.CanCollide = false; p.CanTouch = false; p.CanQuery = false; p.Parent = visuals
	local a = Instance.new("Attachment"); a.Parent = p; return p, a
end
for i, name in ipairs({ "Fighter1", "Fighter2" }) do
	local model = workspace:WaitForChild(name)
	local head = model:FindFirstChild("Head", true)
	if head and not head:IsA("BasePart") then head = head:FindFirstChildWhichIsA("BasePart", true) end
	assert(head and head:IsA("BasePart"), "Head introuvable : " .. name)
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") then p.Anchored = true; p.CanCollide = false end
	end
	model.PrimaryPart = head; head.PivotOffset = CFrame.identity
	local previous = model:FindFirstChild("ImpactFlash"); if previous then previous:Destroy() end
	local flash = Instance.new("Highlight"); flash.Name = "ImpactFlash"; flash.Adornee = model
	flash.FillTransparency = 1; flash.OutlineTransparency = 1; flash.Parent = model
	local p0, a0 = anchor(name .. "WebOrigin"); local p1, a1 = anchor(name .. "WebTip")
	local beam = Instance.new("Beam"); beam.Name = "SpideySilk"; beam.Attachment0 = a0; beam.Attachment1 = a1
	beam.Width0 = 0.075; beam.Width1 = 0.035; beam.FaceCamera = true; beam.LightEmission = 0.12
	beam.Color = ColorSequence.new(Color3.fromRGB(240, 245, 248)); beam.Transparency = NumberSequence.new(0.08)
	beam.Segments = 12; beam.Enabled = false; beam.Parent = visuals
	for _, key in ipairs({ "SpideyTrail", "SpideyTrailTop", "SpideyTrailBottom" }) do
		local obj = head:FindFirstChild(key); if obj then obj:Destroy() end
	end
	local top = Instance.new("Attachment"); top.Name = "SpideyTrailTop"; top.Position = Vector3.new(0, head.Size.Y * .35, 0); top.Parent = head
	local bottom = Instance.new("Attachment"); bottom.Name = "SpideyTrailBottom"; bottom.Position = Vector3.new(0, -head.Size.Y * .35, 0); bottom.Parent = head
	local second=beam:Clone();second.Name="SpideyVolleySilk";second.CurveSize0=.65;second.CurveSize1=.65;second.Parent=visuals
 local third=beam:Clone();third.Name="SpideyVolleySilk";third.CurveSize0=-.65;third.CurveSize1=-.65;third.Parent=visuals
 local trail = Instance.new("Trail"); trail.Name = "SpideyTrail"; trail.Attachment0 = top; trail.Attachment1 = bottom
	trail.Lifetime = .17; trail.MinLength = .2; trail.FaceCamera = true; trail.LightEmission = .5
	trail.Color = ColorSequence.new(Color3.fromRGB(230, 250, 255)); trail.Transparency = NumberSequence.new(.45, 1)
	trail.Enabled = false; trail.Parent = head
	local s = speedOf(model)
	fighters[i] = { model = model, head = head, start = Vector2.new(head.Position.X, head.Position.Y),
		position = Vector2.new(head.Position.X, head.Position.Y), depth = head.Position.Z, rotation = head.CFrame.Rotation,
		radius = math.max(head.Size.X, head.Size.Y) / 2, speed = s, velocity = Vector2.new(1, 0) * s,
		flash = flash, flashTime = 0, priority = 0, lastWallSound = -math.huge,
		wallSound = sound(head, "WallBounceSound", "rbxassetid://1885641628", .28),
		hitSound = sound(head, "CollisionHitSound", "rbxassetid://110024396934410", .45),
		originPart = p0, tipPart = p1, beam = beam, extraBeams={second,third}, trail = trail,
		nextWeb = 2.5, strike = false, coastUntil = 0,
	}
end
local function world(f, p) return Vector3.new(p.X, p.Y, f.depth - f.head.Size.Z * .5 - .1) end
local function flash(f, enemy)
	local priority = enemy and 2 or 1
	if f.flashTime <= 0 or priority >= f.priority then
		local c = enemy and Color3.fromRGB(255, 150, 55) or Color3.new(1, 1, 1)
		f.flash.FillColor = c; f.flash.OutlineColor = c; f.priority = priority
	end
	f.flashTime = .18
end
local function cancelCharge(f)
	local sting=f.sting
 if sting then
  local target=sting.target
  AbilityGate.Resume(target.model,"SpideyInjection")
  if target.capturedBy==f then target.capturedBy=nil;target.velocity=sting.savedVelocity;target.model:SetAttribute("WebImmobilized",false)end
  f.velocity=sting.ownVelocity;f.sting=nil;f.model:SetAttribute("SpideyStingingUntil",nil)
 end
 local charge = f.charge
	if charge and charge.target and charge.target.capturedBy == f then
		local target = charge.target
		target.capturedBy = nil
		target.velocity = charge.savedVelocity
		target.model:SetAttribute("WebImmobilized", false)
	end
	f.charge = nil; f.shot = nil; f.volley=nil; f.beam.Enabled = false
 for _,beam in ipairs(f.extraBeams)do beam.Enabled=false end
end
local pushEvent=SSS:WaitForChild("CraxTonguePush")
local function acceptTonguePush(attacker,target)
 if AbilityGate.Paused(attacker)then return end
 if state:GetAttribute("Phase")~="Fighting"or state:GetAttribute("GhostNightActive")
  or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then return end
 local a,b
 for _,f in ipairs(fighters)do if f.model==attacker then a=f elseif f.model==target then b=f end end
 if not a or not b or (b.model:GetAttribute("Health")or 0)<=0
  or b.model:GetAttribute("GhostInvulnerable")then return end
 if b.capturedBy then cancelCharge(b.capturedBy)end
 cancelCharge(b);b.strike=false;b.model:SetAttribute("WebCharging",false)
 local delta=b.position-a.position
 local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
 b.knockback={velocity=direction*72,remaining=.24}
end
pushEvent.Event:Connect(acceptTonguePush)
local function pushStep(f,dt)
 local push=f.knockback
 if not push then return Vector2.zero end
 if state:GetAttribute("GhostNightActive")or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then
  f.knockback=nil;return Vector2.zero
 end
 local time=math.min(dt,push.remaining)
 local offset=push.velocity*((1-math.exp(-8*time))/8)
 push.velocity=push.velocity*math.exp(-8*time);push.remaining=push.remaining-time
 if push.remaining<=.00001 then f.knockback=nil end
 return offset
end
local function clearWebs()
 Skills.Clear()
	for _, f in ipairs(fighters) do cancelCharge(f);AbilityGate.Reset(f.model) end
	for _, f in ipairs(fighters) do
		f.attackRed=false;f.pendingSting=nil;f.followupEligible=false;f.capturedBy = nil; f.strike = false; f.coastUntil = 0; f.knockback=nil
		f.model:SetAttribute("WebImmobilized", false); f.model:SetAttribute("WebCharging", false)
		f.trail.Enabled = false; f.trail:Clear()
	end
end
local function wallEndpoint(position, direction)
	local distance = math.huge
	if direction.X > .00001 then distance = math.min(distance, (24 - position.X) / direction.X)
	elseif direction.X < -.00001 then distance = math.min(distance, (-24 - position.X) / direction.X) end
	if direction.Y > .00001 then distance = math.min(distance, (45 - position.Y) / direction.Y)
	elseif direction.Y < -.00001 then distance = math.min(distance, (5 - position.Y) / direction.Y) end
	return position + direction * math.max(0, distance)
end
local function shoot(f, enemy,red)
 if not InvertedSilence.CanStart(f.model)then return end
 if f.sting or f.capturedBy or workspace:GetServerTimeNow()<(f.model:GetAttribute("SpideyStingingUntil")or 0)then return end
	local opposite = Vector2.new(-f.position.X, 50 - f.position.Y)
	local delta = opposite - f.position
	local direction = delta.Magnitude > .001 and delta.Unit or f.velocity.Unit
	if direction.Magnitude < .001 then direction = Vector2.new(1, 0) end
	if not f.sting then cancelCharge(f)end
	f.strike = false
 f.attackRed=red==true
 f.volley=red and 2 or 1
 f.followupEligible=false;f.followupWait=not red
 if f.volley==2 then
  local speed=math.max(f.speed,f.velocity.Magnitude)
  local direction=f.velocity.Magnitude>.001 and f.velocity.Unit or Vector2.new(1,0)
  f.volleyBoostSpeed=speed+math.max(12,f.speed*.65)
  f.velocity=direction*f.volleyBoostSpeed
 end
 if f.volley==2 then fx:FireAllClients("SpideyDoubleShot",world(f,f.position),0,f.model)end
	f.shot = { position = f.position, direction = direction, anchor = wallEndpoint(f.position, direction), enemy = enemy }
	f.beam.Enabled = true
	if not red then fx:FireAllClients("WebLaunch",world(f,f.position))end
end
local function beginCharge(f, target, point)
 if f.volley==1 and f.followupWait then f.followupEligible=true;f.followupWait=false end
	if target then
		-- Être attrapé interrompt la propre charge de la cible et libère sa victime.
		cancelCharge(target); target.strike = false
	end
	local saved = target and target.velocity or nil
	f.shot = nil; f.strike = true; f.coastUntil = 0
	f.charge = { target = target, anchor = point, savedVelocity = saved,
		expires = clock + math.clamp(attr(f, "WebMaxChargeTime", 1), .1, 1) }
	if target then
		target.capturedBy = f; target.velocity = Vector2.zero; target.model:SetAttribute("WebImmobilized", true)
		fx:FireAllClients("WebCapture", world(target, target.position), 0, target.model)
	end
	f.model:SetAttribute("WebCharging", true)
end
local function segmentHits(a, b, center, radius)
	local d = b - a
	local t = d:Dot(d) > 1e-9 and math.clamp((center - a):Dot(d) / d:Dot(d), 0, 1) or 0
	return (a + d * t - center).Magnitude <= radius
end
local function webStep(f, enemy, dt)
 if f.sting or AbilityGate.Paused(f.model)or f.capturedBy and f.capturedBy.sting then
  f.nextWeb=f.nextWeb+dt;f.coastUntil=f.coastUntil+dt
  if not f.sting then return end
 end
	if state:GetAttribute("GhostNightActive") or workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) then return end
	if f.pendingSting and attr(f,"CraxSkillLevel",0)>=3 then
  if workspace:GetServerTimeNow()<(f.pendingSting.deadline or 0)then return else f.pendingSting=nil end
 end
 if f.sting and(not f.sting.target.model.Parent or(f.sting.target.model:GetAttribute('Health')or 0)<=0 or f.sting.target.model:GetAttribute('DeadlyPhantom'))then cancelCharge(f);return end
 if f.sting then
  local sting=f.sting;local target=sting.target
  local squeeze=math.clamp((workspace:GetServerTimeNow()-sting.started)/.24,0,1);squeeze=squeeze*squeeze*(3-2*squeeze)
  f.position=target.position+sting.offset:Lerp(sting.tightOffset,squeeze)
  if workspace:GetServerTimeNow()>=sting.expires then
   local lost=sting.lost;local defender=target.model
   local shot=f.shot;local red=f.volley==2;local boost=f.volleyBoostSpeed
   cancelCharge(f);f.coastUntil=clock+.65
   if red and shot then f.shot=shot;f.shot.position=f.position;f.volley=2;f.volleyBoostSpeed=boost;f.beam.Enabled=true end
   if lost>0 and state:GetAttribute("Phase")=="Fighting"then SSS.CraxSpideyDamageConfirmed:Fire(f.model,defender,lost,"SpideyInject",state:GetAttribute("RoundId"))end
  end
  return
 end
 if not isSpider(f) or f.capturedBy then return end
	if clock >= f.nextWeb and InvertedSilence.CanStart(f.model)then
		f.nextWeb = clock + math.max(.1, attr(f, "WebCooldown", 2.5))
		shoot(f, enemy)
	end
	if f.shot then
		local shot = f.shot
		local before = shot.position
		local remaining = (shot.anchor - before).Magnitude
		local distance = math.min(remaining, math.max(1, attr(f, "WebSpeed", 400)) * dt)
		local after = before + shot.direction * distance
		local target,best=nil,math.huge
  for _,candidate in ipairs(Deadly.MotionTargets(fighters))do
   if not Deadly.SameTeam(f.model,candidate.model)and not candidate.model:GetAttribute('DeadlyPhantom')and not candidate.model:GetAttribute('FantasticInvisible')and(candidate.model:GetAttribute('Health')or 0)>0
    and segmentHits(before,after,candidate.position,candidate.radius+.12)then
    local along=(candidate.position-before):Dot(shot.direction)
    if along<best then best=along;target=candidate end
   end
  end
  if target then
			beginCharge(f, target, target.position)
		elseif remaining <= distance + .001 then
			fx:FireAllClients("WebWall", world(f, shot.anchor), 0, nil, Vector3.new(-shot.direction.X, -shot.direction.Y, 0))
			beginCharge(f, nil, shot.anchor)
		else shot.position = after end
	end
	if f.charge and f.charge.target and(not f.charge.target.model.Parent or(f.charge.target.model:GetAttribute('Health')or 0)<=0 or f.charge.target.model:GetAttribute('DeadlyPhantom'))then cancelCharge(f)end
 if f.charge then
		local charge = f.charge
		local point = charge.target and charge.target.position or charge.anchor
		local delta = point - f.position
		if clock >= charge.expires or (not charge.target and delta.Magnitude <= f.radius + .2) then
			cancelCharge(f); f.coastUntil = clock + attr(f, "WebCoastTime", .65)
		elseif delta.Magnitude > .001 then
			local maximum = math.max(f.speed, attr(f, "WebMaxSpeed", 110)*(f.volley==2 and 1.65 or 1),f.volley==2 and(f.volleyBoostSpeed or 0)or 0)
			local speed = math.min(maximum, f.velocity.Magnitude + math.max(1, attr(f, "WebAcceleration", 220))*(f.volley==2 and 2.5 or 1) * dt)
			f.velocity = delta.Unit * speed
		end
	end
	if not f.charge and not f.shot and clock >= f.coastUntil then
		f.strike = false
		local speed = f.speed + (f.velocity.Magnitude - f.speed) * math.exp(-6 * dt)
		if f.velocity.Magnitude > .001 then f.velocity = f.velocity.Unit * math.max(f.speed, speed) end
	end
end
local function damageAtSpeed(f, speed)
	local minimum = math.max(0, attr(f, "WebMinDamage", 4))
	local maximum = math.max(minimum, attr(f, "WebMaxDamage", 24))
	local scale = math.max(1, attr(f, "WebDamageScale", 35))
	return math.floor(math.clamp(minimum * math.exp(math.max(0, speed - f.speed) / scale), minimum, maximum) + .5)
end
local function followup(f)
 if not InvertedSilence.CanStart(f.model)then return false end
 if not f.followupEligible then return false end
 f.followupEligible=false
 if Skills.Volley(f.model)==2 then
  local enemy=fighters[f==fighters[1]and 2 or 1]
  shoot(f,enemy,true);return true
 end
 return false
end
local function webImpact(f,target)
 if state:GetAttribute("GhostNightActive")or not isSpider(f)or not f.strike or f.capturedBy then return false end
 local critical=f.charge and f.charge.target==target
 local speed=f.velocity.Magnitude*Skills.Slow(f.model)*Night.Slow(f.model)
 local maximum=f.attackRed and 40 or 25
 local minimum=math.min(maximum,math.max(0,attr(f,"WebMinDamage",4)))
 local ceiling=math.max(f.speed+1,attr(f,"WebMaxSpeed",110)*(f.attackRed and 1.65 or 1),f.attackRed and(f.volleyBoostSpeed or 0)or 0)
 local ratio=math.clamp((speed-f.speed)/(ceiling-f.speed),0,1)
 local amount=math.floor(minimum+(maximum-minimum)*ratio^1.5+.5)
 local velocity=f.velocity;f.strike=false;cancelCharge(f);f.coastUntil=clock+.65
 if critical then f.pendingSting={deadline=workspace:GetServerTimeNow()+.925,target=target,velocity=velocity,round=state:GetAttribute("RoundId")}end
 biteHit:Fire(f.model,target.model,amount,false,critical and "WebCritical"or "WebImpact")
 followup(f)
 return true
end
-- BindableEvent callbacks sont asynchrones : utiliser la confirmation réelle de CombatHealth.
SSS:WaitForChild("CraxSpideyDamageConfirmed").Event:Connect(function(attacker,defender,lost,kind,round)
 if round~=state:GetAttribute("RoundId")or(kind~="WebCritical"and kind~="WebImpact")then return end
 local a,b;for _,f in ipairs(fighters)do if f.model==attacker then a=f elseif f.model==defender then b=f end end
 b=b or Deadly.GetMotion(defender)
 if not a or not b then return end
 if AbilityGate.Paused(attacker)or state:GetAttribute("GhostNightActive")or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then a.pendingSting=nil;return end
 fx:FireAllClients(kind,world(b,b.position),lost)
 if kind~="WebCritical"then return end
 local pending=a.pendingSting;a.pendingSting=nil
 if not InvertedSilence.CanStart(attacker)or not pending or pending.target~=b or pending.round~=round or lost<=0 or state:GetAttribute("Phase")~="Fighting"or attr(a,"CraxSkillLevel",0)<3 or Skills.Poisoned(defender)then return end
 if b.capturedBy then cancelCharge(b.capturedBy)end
 cancelCharge(b);b.strike=false
 local delta=a.position-b.position;local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(-1,0)
 -- Garde le second fil rouge lancé après l'impact, mais suspend sa traction pendant la piqûre.
 local velocity=a.velocity.Magnitude>.001 and a.velocity or pending.velocity
 a.sting={target=b,started=workspace:GetServerTimeNow(),expires=workspace:GetServerTimeNow()+1.4,lost=lost,savedVelocity=b.velocity,ownVelocity=velocity,offset=direction*(a.radius+b.radius-.15),tightOffset=direction*(a.radius+b.radius)*.80}
 AbilityGate.Pause(b.model,"SpideyInjection")
 b.capturedBy=a;b.velocity=Vector2.zero;b.model:SetAttribute("WebImmobilized",true)
 a.beam.Enabled=false;a.model:SetAttribute("WebCharging",false)
 a.velocity=Vector2.zero;a.model:SetAttribute("SpideyStingingUntil",workspace:GetServerTimeNow()+1.4)
 fx:FireAllClients("SpideySting",world(b,b.position),1.4,b.model,a.model)
end)
local function walls(f)
 f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2
	local x, y = f.position.X, f.position.Y; local vx, vy = f.velocity.X, f.velocity.Y
	local hit = false;local plumberSides={}
	if x < -24 + f.radius then x = -24 + f.radius; vx = math.abs(vx); hit = true;plumberSides[#plumberSides+1]='Left'
	elseif x > 24 - f.radius then x = 24 - f.radius; vx = -math.abs(vx); hit = true;plumberSides[#plumberSides+1]='Right' end
	if y < 5 + f.radius then y = 5 + f.radius; vy = math.abs(vy); hit = true;plumberSides[#plumberSides+1]='Bottom'
	elseif y > 45 - f.radius then y = 45 - f.radius; vy = -math.abs(vy); hit = true;plumberSides[#plumberSides+1]='Top' end
	f.position = Vector2.new(x, y); f.velocity = Vector2.new(vx, vy)
	if hit then
  for _,side in ipairs(plumberSides)do Plumber.Wall(f,side)end
        if isSpider(f)and not f.sting then followup(f)end
        f.knockback=nil
		if not state:GetAttribute("GhostNightActive") then flash(f, false) end
		if f.charge and not f.charge.target and f.volley~=2 then cancelCharge(f); f.coastUntil = clock + attr(f, "WebCoastTime", .65) end
		if not state:GetAttribute("GhostNightActive") and clock - f.lastWallSound >= .08 then
			f.lastWallSound = clock; f.wallSound:Stop(); f.wallSound:Play()
		end
	end
end
local function move(f)
 PositionLock.Enforce(f)
	local offset = Vector3.zero
 if workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) then
  local t=os.clock()*75
  offset=Vector3.new(math.sin(t)*.075,math.cos(t*1.13)*.055,0)
 end
 if f.model:GetAttribute("FleauFury")or state:GetAttribute("GhostNightActive")or not f.model:GetAttribute("FantasticPinned")then f.model:PivotTo(CFrame.new(f.position.X, f.position.Y, f.depth) * CFrame.new(offset) * f.rotation)end
	f.model:SetAttribute("CurrentSpeed", f.velocity.Magnitude*Plumber.Speed(f)*Skills.Slow(f.model)*Night.Slow(f.model))
	f.model:SetAttribute("WebCharging", not f.sting and not f.capturedBy and f.charge ~= nil)
	local endpoint = f.shot and f.shot.position or (f.charge and (f.charge.target and f.charge.target.position or f.charge.anchor))
	f.beam.Enabled = not f.sting and not f.capturedBy and endpoint ~= nil and state:GetAttribute("Phase") == "Fighting"
	for _,beam in ipairs(f.extraBeams)do beam.Enabled=false;beam.Width0=.065;beam.Width1=.035 end
 if endpoint then
		f.originPart.Position = world(f, f.position); f.tipPart.Position = world(f, endpoint)
		f.beam.Width0 = f.charge and .19 or .10
  local color=f.volley==2 and Color3.fromRGB(255,35,55)or Color3.fromRGB(240,245,248)
  f.beam.Color=ColorSequence.new(color)
  for _,beam in ipairs(f.extraBeams)do beam.Color=ColorSequence.new(Color3.fromRGB(255,25,45))end
  f.trail.Color=ColorSequence.new(f.volley==2 and Color3.fromRGB(255,40,55)or Color3.fromRGB(230,250,255))
	end
	f.trail.Enabled = isSpider(f) and not f.sting and not f.capturedBy and f.velocity.Magnitude > f.speed * 1.25
		and state:GetAttribute("Phase") == "Fighting"
end
Night.SetEscapeHandler(function(model,enemy)
 local defender,attacker
 for _,f in ipairs(fighters) do
  if f.model==model then defender=f elseif f.model==enemy then attacker=f end
 end
 if not defender or not attacker or state:GetAttribute("Phase")~="Fighting" then return false end
 local originalVelocity=defender.velocity
 if defender.capturedBy and defender.capturedBy.sting then originalVelocity=defender.capturedBy.sting.savedVelocity end
 if defender.capturedBy then cancelCharge(defender.capturedBy) end
 cancelCharge(defender);defender.strike=false;defender.knockback=nil
 local direction=attacker.velocity.Magnitude>.001 and attacker.velocity.Unit or Vector2.new(1,0)
 local distance=defender.radius+attacker.radius+.8
 local position=attacker.position-direction*distance
 local function fits(p)
  return p.X>=-24+defender.radius and p.X<=24-defender.radius
   and p.Y>=5+defender.radius and p.Y<=45-defender.radius
 end
 if not fits(position) then
  local best,score=nil,-math.huge
  for i=0,31 do
   local angle=i*math.pi*2/32;local offset=Vector2.new(math.cos(angle),math.sin(angle))
   local candidate=attacker.position+offset*distance
   local behind=-offset:Dot(direction)
   if fits(candidate) and behind>score then best=candidate;score=behind end
  end
  if not best then return false end
  position=best
 end
 local from=Vector3.new(defender.position.X,defender.position.Y,defender.depth)
 defender.position=position
 if originalVelocity.Magnitude>.001 then defender.velocity=originalVelocity
 else
  local x,y=model:GetAttribute("LaunchDirectionX"),model:GetAttribute("LaunchDirectionY")
  local original=type(x)=="number"and type(y)=="number"and Vector2.new(x,y)or Vector2.new(1,0)
  defender.velocity=(original.Magnitude>.001 and original.Unit or Vector2.new(1,0))*defender.speed
 end
 defender.model:SetAttribute("GhostDodgeUntil",workspace:GetServerTimeNow()+.92)
 defender.model:SetAttribute("GhostTeleportUntil",workspace:GetServerTimeNow()+.9)
 touching=false;move(defender)
 local event=RS:FindFirstChild("GhostyNightEvent")
 if event then
  for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
   local seat=p:GetAttribute("ArenaSeat")
   if seat==1 or seat==2 then event:FireClient(p,"Escape",{Owner=model.Name,From=from,
    To=Vector3.new(position.X,position.Y,defender.depth),Start=workspace:GetServerTimeNow(),Duration=.9,RoundId=state:GetAttribute("RoundId")}) end
  end
 end
 return true
end)
local function resetRound()
 Plumber.Reset()
 Fantastic.Reset()
	clearWebs(); Night.Reset(fighters); touching = false; clock = 0
	for i, f in ipairs(fighters) do
		f.position = f.start; f.speed = speedOf(f.model)
		f.velocity = Vector2.new(i == 1 and 1 or -1, .25).Unit * f.speed
		f.nextWeb = attr(f, "WebCooldown", 2.5)
		f.model:SetAttribute("LaunchDirectionX", nil); f.model:SetAttribute("LaunchDirectionY", nil)
		f.flashTime = 0; f.priority = 0; f.lastWallSound = -math.huge
		f.wallSound:Stop(); f.hitSound:Stop(); move(f)
	end
end
local function finite(v) return type(v) == "number" and v == v and math.abs(v) < math.huge end
local function launch()
 Inverted.Begin(fighters)
 Plumber.Reset()
 Fantastic.Reset()
	clearWebs(); Night.Reset(fighters); clock = 0
	for i, f in ipairs(fighters) do
		f.speed = speedOf(f.model)
		local x, y = f.model:GetAttribute("LaunchDirectionX"), f.model:GetAttribute("LaunchDirectionY")
		local direction = Vector2.new(i == 1 and 1 or -1, .25)
		if finite(x) and finite(y) and Vector2.new(x, y).Magnitude > .001 then direction = Vector2.new(x, y) end
		f.velocity = direction.Unit * f.speed; f.nextWeb = attr(f, "WebCooldown", 2.5)
	end
end
state:GetAttributeChangedSignal("RoundId"):Connect(resetRound)
state:GetAttributeChangedSignal("Phase"):Connect(function()
	if state:GetAttribute("Phase") == "Fighting" then launch() else Plumber.Reset();clearWebs(); Night.Reset(fighters) end
end)
resetRound()
Deadly.Bind(fighters)
Deadly.ContactHandler=function(a,b)
 local first,second=Deadly.GetMotion(a),Deadly.GetMotion(b)
 if not first or not second then return false end
 if isSpider(first)then return webImpact(first,second)elseif isSpider(second)then return webImpact(second,first)end
 return false
end
Plumber.Bind(fighters)
-- GoldenStatueContactFix_v1
local statueContact={Round=nil,Active=false,Last=-math.huge,Fixed=nil}
RunService.Heartbeat:Connect(function(deltaTime)

 if state:GetAttribute('DeadlyDemoActive')then Plumber.Reset();return end
	local alive = state:GetAttribute("Phase") == "Fighting"
	for _, f in ipairs(fighters) do if (f.model:GetAttribute("Health") or 1) <= 0 then alive = false end end
	if not alive then clearWebs();Fantastic.Reset()end
	if alive and not state:GetAttribute('GhostNightActive')then Skills.Step(fighters)end
 local dt = math.min(deltaTime, .1); local steps = math.max(1, math.ceil(dt * 120)); local step = dt / steps
	for _ = 1, steps do
		alive = alive and state:GetAttribute("Phase") == "Fighting"
		Deadly.Step(step,fighters)
		local frozen = Deadly.Flash()
  Inverted.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  if alive then
   clock = clock + step
   frozen = frozen or Night.Step(clock,step,fighters,clearWebs)
   if not frozen then Fantastic.Step(step*Deadly.CinematicScale(),fighters)end
   alive = state:GetAttribute("Phase") == "Fighting"
  end
		Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)
		Plumber.Step(step,alive and not frozen)
  Fleau.Step(step,fighters,alive and not frozen)
		for i, f in ipairs(fighters) do
			f.flashTime = math.max(0, f.flashTime - step)
			if alive and not frozen and not Fantastic.Hold(f)and not Deadly.Hold(f.model)then webStep(f, fighters[3-i], step*Deadly.CinematicScale()) end
		end
		for _, f in ipairs(fighters) do
			if alive and not frozen and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))and not Deadly.Hold(f.model)and not f.capturedBy and not Plumber.Hold(f.model)and not Golden.Hold(f.model)and not Fleau.Hold(f.model)and workspace:GetServerTimeNow()>=(f.model:GetAttribute("GhostTeleportUntil")or 0)then f.position = f.position + f.velocity * Plumber.Speed(f) * Skills.Slow(f.model) * Night.Slow(f.model) * Deadly.Slow(f.model) * Deadly.CinematicScale() * step + pushStep(f,step); walls(f) end
		end
		if alive and not frozen then
			PositionLock.Enforce(fighters[1]);PositionLock.Enforce(fighters[2]);Golden.Enforce(fighters)
 local a, b = fighters[1], fighters[2]
			local delta = b.position - a.position; local distance = delta.Magnitude; local radius = a.radius + b.radius
			local statueA=a.model:GetAttribute('GoldenStatue')==true
    or a.model:GetAttribute('FleauStunned')==true
    or a.model:GetAttribute('DeadlyStunned')==true
   local statueB=b.model:GetAttribute('GoldenStatue')==true
    or b.model:GetAttribute('FleauStunned')==true
    or b.model:GetAttribute('DeadlyStunned')==true
   local roundId=state:GetAttribute('RoundId')
   if statueContact.Round~=roundId then
    statueContact.Round=roundId;statueContact.Active=false
    statueContact.Last=-math.huge;statueContact.Fixed=nil
   end

   if statueA or statueB then
    -- Une statue n'a pas de vitesse physique, meme si sa direction
    -- sauvegardee doit etre conservee pour la fin de l'effet.
    touching=false
    if statueA and statueB then
     statueContact.Active=false;statueContact.Fixed=nil
    else
     local fixed=statueA and a or b
     local moving=statueA and b or a
     local offset=moving.position-fixed.position
     local gap=offset.Magnitude
     local blocked=Golden.Hold(moving.model)or Plumber.Hold(moving.model)
      or Deadly.Hold(moving.model)or Fantastic.Hold(moving)
      or moving.capturedBy~=nil
      or moving.model:GetAttribute('FantasticInvisible')
      or moving.model:GetAttribute('PlumberInTransit')
      or moving.model:GetAttribute('VicePortalTransit')
      or workspace:GetServerTimeNow()<(moving.model:GetAttribute('GhostTeleportUntil')or 0)

     if statueContact.Fixed~=fixed.model then
      statueContact.Active=false;statueContact.Last=-math.huge
      statueContact.Fixed=fixed.model
     end

     if not blocked and gap<radius then
      local velocity=moving.velocity
      local normal=gap>.0001 and offset/gap
       or(velocity.Magnitude>.001 and -velocity.Unit or Vector2.new(1,0))

      -- La separation deplace uniquement le Crax mobile.
      moving.position=fixed.position+normal*(radius+.003)
      moving.knockback=nil

      -- Reflexion sur obstacle immobile : v' = v - 2(v.n)n.
      local closing=velocity:Dot(normal)
      if closing<0 then
       local bounced=velocity-normal*(2*closing)
       local speed=math.max(moving.speed or 0,velocity.Magnitude)
       moving.velocity=(bounced.Magnitude>.001 and bounced.Unit or normal)*speed
      end

      local now=os.clock()
      if not state:GetAttribute('GhostNightActive')
       and not state:GetAttribute('GhostGrandFrissonActive')
       and not statueContact.Active and now-statueContact.Last>=.18 then
       statueContact.Last=now
       flash(moving,true);flash(fixed,true)
       moving.hitSound:Stop();moving.hitSound:Play()
       -- Le circuit serveur existant applique les degats normaux et
       -- Golden.Outgoing annule ceux provenant de la statue.
       biteHit:Fire(moving.model,fixed.model,nil,true)
      end
      statueContact.Active=true
     elseif blocked or gap>radius+.015 then
      statueContact.Active=false
     end
    end
   elseif distance < radius and not Plumber.Hold(a.model)and not Plumber.Hold(b.model)and not Deadly.Hold(a.model)and not Deadly.Hold(b.model)and not Fantastic.BlockContact(a,b)then

				local normal = distance > .0001 and delta / distance or Vector2.new(1, 0)
				local separation = normal * (radius - distance + .002)
                if a.sting or b.sting then separation=Vector2.zero end
				if Golden.Hold(a.model)then b.position=b.position+separation
 elseif Golden.Hold(b.model)then a.position=a.position-separation
 elseif a.model:GetAttribute("FantasticPinned") then b.position=b.position+separation
 elseif b.model:GetAttribute("FantasticPinned") then a.position=a.position-separation
 elseif a.capturedBy then b.position = b.position + separation
				elseif b.capturedBy then a.position = a.position - separation
				else a.position = a.position - separation / 2; b.position = b.position + separation / 2 end
				local hitA = webImpact(a, b)
				local hitB = state:GetAttribute("Phase") == "Fighting" and webImpact(b, a)
				if state:GetAttribute("GhostGrandFrissonActive") and not touching then
     Night.Contact(a.model,b.model)
    end
    if not state:GetAttribute("GhostNightActive") and not state:GetAttribute("GhostGrandFrissonActive") and (not touching or hitA or hitB) then
					flash(a, true); flash(b, true); a.hitSound:Stop(); a.hitSound:Play()
					-- Une toile peut capturer une cible déjà au contact, sans dégât doublé.
					if not hitA and not hitB then biteHit:Fire(a.model, b.model, nil, true) end
				end
				local approach = (a.velocity - b.velocity):Dot(normal)
				if approach > 0 and not a.sting and not b.sting then
					local sa = isSpider(a) and math.max(a.speed, a.velocity.Magnitude) or a.speed
					local sb = isSpider(b) and math.max(b.speed, b.velocity.Magnitude) or b.speed
					if not a.capturedBy then
						a.velocity = a.velocity - normal * approach
						a.velocity = (a.velocity.Magnitude > .001 and a.velocity.Unit or -normal) * sa
					end
					if not b.capturedBy then
						b.velocity = b.velocity + normal * approach
						b.velocity = (b.velocity.Magnitude > .001 and b.velocity.Unit or normal) * sb
					end
				end
				touching = true
			elseif distance > radius + .15 then touching = false end
		end
		if alive and not frozen then Plumber.EnforceBarriers();Golden.Enforce(fighters)end
	end
	Golden.Enforce(fighters)
	Fleau.Enforce(fighters)
	for _, f in ipairs(fighters) do
		local fade = 1 - f.flashTime / .18
		f.flash.FillTransparency = .55 + .45 * fade; f.flash.OutlineTransparency = fade; move(f)
	end
end)
state:SetAttribute("MovementReady", true)
print("ArenaMovement prêt : SpideyCrax et directions de départ.")
]====]},
{path=[====[ServerScriptService.CombatHealth]====],bytes=11488,hash=2363038626,source=[====[local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))
-- FleauImpactGuard_v4
-- GoldenStatueContactFix_v1
-- GoldenCombatBase_v1
-- PlumberLevels_v1
-- PlumberIntegration_v1
local Golden=require(game:GetService('ServerScriptService'):WaitForChild('CraxGoldenRuntime'))
local Plumber=require(game:GetService('ServerScriptService'):WaitForChild('CraxPlumberRuntime'))
-- VICE_PORTAL_HAZARD_v1
-- DEMO_DUMMY_HEALTH_v1
-- CombatHealth : mêmes événements, santé des principaux et des Sit'N Smile.
local Fleau=require(game:GetService('ServerScriptService'):WaitForChild('FleauRuntime'))
local FleauBridge=require(game:GetService('ServerScriptService'):WaitForChild('FleauFinaleBridge'))
local SSS=game:GetService('ServerScriptService');local state=workspace:WaitForChild('CombatState')
local event=SSS:WaitForChild('BiteHit');local heal=SSS:WaitForChild('CraxHeal')
local Night=require(SSS:WaitForChild('GhostyNight'));local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Mod=require(SSS:WaitForChild('CraxDamageModifiers'));local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local confirmed=SSS:FindFirstChild('CraxSpideyDamageConfirmed')
if not confirmed then confirmed=Instance.new('BindableEvent');confirmed.Name='CraxSpideyDamageConfirmed';confirmed.Parent=SSS end
local fantastic=SSS:WaitForChild('FantasticDamageConfirmed');local states={};local finished=false
state:SetAttribute('HealthReady',false)
local colors={{0,Color3.fromRGB(145,20,35)},{.2,Color3.fromRGB(245,65,65)},{.45,Color3.fromRGB(255,155,65)},{.7,Color3.fromRGB(255,235,120)},{1,Color3.fromRGB(160,255,170)}}
local function healthColor(ratio)
 for i=2,#colors do local a,b=colors[i-1],colors[i];if ratio<=b[1]then return a[2]:Lerp(b[2],(ratio-a[1])/(b[1]-a[1]))end end
 return colors[#colors][2]
end
local fighters={workspace:WaitForChild('Fighter1'),workspace:WaitForChild('Fighter2')}
local function finite(x)return type(x)=='number'and x==x and math.abs(x)<math.huge end
local function update(model)
 local r=states[model];if not r then return end
 model:SetAttribute('Health',r.health);model:SetAttribute('MaxHealth',r.maxHealth)
 if r.label.Parent then
  r.label.Text=r.health==math.huge and '∞'or tostring(math.ceil(r.health))
  local ratio=r.maxHealth==math.huge and 1 or math.clamp(r.health/r.maxHealth,0,1)
  r.label.TextColor3=healthColor(ratio)
 end
end
local function register(model)
 local h=model:FindFirstChild('Head',true);if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 assert(h,'Tête absente : '..model.Name)
 local old=h:FindFirstChild('HealthBar');if old then old:Destroy()end
 local gui=Instance.new('BillboardGui');gui.Name='HealthBar';gui.Adornee=h;gui.Size=UDim2.fromOffset(150,60)
 gui.StudsOffsetWorldSpace=Vector3.new(0,h.Size.Y/2+1.3,0);gui.MaxDistance=250;gui.Parent=h
 local label=Instance.new('TextLabel');label.Name='HealthNumber';label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamBold;label.TextSize=36;label.TextStrokeColor3=Color3.fromRGB(25,25,30);label.TextStrokeTransparency=.3;label.Parent=gui
 local max=model:GetAttribute('MaxHealth')or 100
 assert((finite(max)and max>0)or max==math.huge,'MaxHealth invalide : '..model.Name)
 states[model]={health=max,maxHealth=max,label=label};update(model)
end
Deadly.Health={
 Register=register,
 Unregister=function(model)states[model]=nil end,
 Set=function(model,hp,maximum)
  local r=states[model];if not r or model:GetAttribute('DeadlyHPFrozen')or model:GetAttribute('FleauFury')then return end
  if(model:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()and hp<r.health then return end
  if maximum then r.maxHealth=maximum end;r.health=math.max(0,hp);update(model)
 end,
}
for _,model in ipairs(fighters)do register(model)end
local function resetRound()
 finished=false
 for _,model in ipairs(fighters)do local r=states[model];r.maxHealth=model:GetAttribute('MaxHealth')or 100;r.health=r.maxHealth;update(model)end
end
state:GetAttributeChangedSignal('RoundId'):Connect(resetRound)
-- The fighter can be configured after RoundId has changed: refresh at actual combat start.
state:GetAttributeChangedSignal('Phase'):Connect(function()if state:GetAttribute('Phase')=='Fighting'then resetRound()end end)
local function protected(model)
 if model:GetAttribute('GoldenStatue')then return false end
 if(model:GetAttribute("PlumberStarUntil")or 0)>workspace:GetServerTimeNow()then return true end
 if model:GetAttribute('PlumberInTransit')then return true end
 return model:GetAttribute('FantasticInvisible')or model:GetAttribute('GhostInvulnerable')or model:GetAttribute('DeadlyInvulnerable')
  or workspace:GetServerTimeNow()<(model:GetAttribute('GhostDodgeUntil')or 0)
end
local function adjust(model,amount,kind)
 if kind=='GoldenStatue'or model:GetAttribute('GoldenStatue')then return Inverted.Vulnerable(model,Fleau.FlatProtect(model,amount))end
 if protected(model)then return 0 end
 return Deadly.AdjustDamage(model,Inverted.Vulnerable(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind)))
end
Inverted.SetHealth=function(model,hp,round)
 local r=states[model]
 if r and r.health>0 and model.Parent and state:GetAttribute('Phase')=='Fighting'and state:GetAttribute('RoundId')==round then r.health=hp;update(model);return true end
 return false
end
local function report(a,b,lost,kind)
 fantastic:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))
 if kind=='WebCritical'or kind=='WebImpact'or kind=='SpideyInject'then confirmed:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))end
end
local function finish()
 if state:GetAttribute('DeadlyDemoActive')then return end
 local a,b=states[fighters[1]],states[fighters[2]]
 if a.health>0 and b.health>0 then return end
 -- GoldenVictoryOrderFix_v2
 -- Dernière capture possible avant les callbacks de mort de finish().
 require(SSS:WaitForChild("CraxGoldenFinaleBridge")).CaptureFromHealth(state,fighters,states)
 FleauBridge.CaptureFromHealth(state,fighters,states)
 finished=true
 if a.health==0 and b.health==0 then state:SetAttribute('RoundWinner','Draw')
 elseif b.health==0 then state:SetAttribute('RoundWinner','Fighter1')else state:SetAttribute('RoundWinner','Fighter2')end
 for _,f in ipairs(fighters)do if states[f].health==0 then Deadly.OnDeath(f)end end
 state:SetAttribute('Phase','RoundOver')
end
local fleauHitGuard={}
local fleauGuardRound
event.Event:Connect(function(attacker,defender,damage,collision,kind,recoilSnapshot)
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or not attacker or not defender or Deadly.SameTeam(attacker,defender)
  or state:GetAttribute('GhostNightActive')or Deadly.Flash()then return end
 if(attacker:GetAttribute('FantasticInvisible')and not attacker:GetAttribute('GoldenStatue')and kind~='Burning')or(collision and defender:GetAttribute('FantasticInvisible')and not defender:GetAttribute('GoldenStatue'))then return end
 local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end
 if(attacker:GetAttribute('PlumberInTransit')and not attacker:GetAttribute('GoldenStatue'))or(defender:GetAttribute('PlumberInTransit')and not defender:GetAttribute('GoldenStatue'))then return end
 if not collision and kind~='Burning'and kind~='DeadlyPortal'and kind~='FleauFury'and Gate.Paused(attacker)then report(attacker,defender,0,kind);return end
 local amount=collision and(damage~=nil and damage or(Plumber.ContactDamage(attacker)))or damage
 if collision and(attacker:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then amount=40 end
 if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end
 if not finite(amount)or amount<0 then return end
 local involvesFleau=
  attacker:GetAttribute('CraxId')=='Crax_Fleau'
  or defender:GetAttribute('CraxId')=='Crax_Fleau'
 if involvesFleau and(collision or kind=='FleauCharge' or kind=='FleauFury')then
  local round=state:GetAttribute('RoundId')
  if fleauGuardRound~=round then
   fleauGuardRound=round;fleauHitGuard={}
  end
  local now=workspace:GetServerTimeNow()
  local prior=fleauHitGuard[attacker]
  local reverse=fleauHitGuard[defender]
  local last=prior and prior[defender]
  local other=reverse and reverse[attacker]
  if collision then
   if(last and now-last.time<.2)
    or(other and now-other.time<.2)then return end
  else
   local delay=kind=='FleauCharge'and .2 or .35
   if last and last.kind==kind and now-last.time<delay then return end
  end
  prior=prior or {};fleauHitGuard[attacker]=prior
  prior[defender]={time=now,kind=collision and 'Collision'or kind}
 end
 local fleauAttackMode
 if collision then amount,fleauAttackMode=Fleau.Contact(attacker,amount)end
 if collision then amount=Inverted.Melee(attacker,amount)end
 amount=Golden.Outgoing(attacker,amount)
 amount=Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)
 local recoil=recoilSnapshot~=nil and recoilSnapshot or(Plumber.ContactDamage(defender))
 if collision and(defender:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then recoil=40 end
 local fleauRecoilMode
 if collision then recoil=Inverted.Melee(defender,recoil);recoil,fleauRecoilMode=Fleau.Contact(defender,recoil)end
 local incoming=collision and finite(recoil)and recoil>=0 and Inverted.Final(attacker,adjust(attacker,Golden.Outgoing(defender,Inverted.RawInput(defender,attacker,recoil)),'Collision'),defender)or 0
 if amount>0 and amount>=b.health and not Deadly.IsAlly(defender)and kind~='GoldenStatue'and not defender:GetAttribute('GoldenStatue')and Night.TryEscape(defender,attacker)then report(attacker,defender,0,kind);return end
 if incoming>0 and incoming>=a.health and not Deadly.IsAlly(attacker)and not attacker:GetAttribute('GoldenStatue')and Night.TryEscape(attacker,defender)then return end
 local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)
 b.health=math.max(0,b.health-amount);a.health=math.max(0,a.health-incoming)
 if b.health<=0 then Fleau.BeforeDeath(defender,b)end
 if a.health<=0 then Fleau.BeforeDeath(attacker,a)end
 Fleau.AfterDamage(defender,lost);Fleau.AfterDamage(attacker,attackerLost)
 if collision then Fleau.CommitContact(attacker,defender,fleauAttackMode);Fleau.CommitContact(defender,attacker,fleauRecoilMode)end
 FleauBridge.CaptureFromHealth(state,fighters,states)
 require(SSS:WaitForChild("CraxGoldenFinaleBridge")).CaptureFromHealth(state,fighters,states)
 update(attacker);update(defender);Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)
 if collision then fantastic:Fire(defender,attacker,attackerLost,'Collision',state:GetAttribute('RoundId'))end
 -- Decide the round from the two roots only; all registered allies are secondary.
 if a.health==0 then Deadly.OnDeath(attacker)end;if b.health==0 then Deadly.OnDeath(defender)end
 finish()
end)
heal.Event:Connect(function(model,amount,source)
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or Deadly.Flash()or state:GetAttribute('GhostNightActive')or not finite(amount)or amount<=0 or model:GetAttribute('DeadlyHPFrozen')then return end
 local r=states[model];if not r or r.health<=0 then return end
 if not Fleau.HealAllowed(model)then return end
 local before=r.health;r.health=math.min(r.maxHealth,r.health+amount);update(model)
 if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end
end)
Fleau.Health={
 Set=function(model,hp,maximum)local r=states[model];if r and not model:GetAttribute('FleauFury')then r.health=hp;r.maxHealth=maximum;update(model)end end,
 Exhaust=function(model)
  local r=states[model];if not r or finished or state:GetAttribute('Phase')~='Fighting'then return end
  -- If the opponent died, the earlier finish already committed victory.
  r.health=0;update(model);FleauBridge.CaptureFromHealth(state,fighters,states);Deadly.OnDeath(model);finish()
 end,
}
state:SetAttribute('HealthReady',true)
]====]},
{path=[====[ServerScriptService.MonsterBiteAbilities]====],bytes=25997,hash=1229180526,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxBiteAuraDuration_v3
-- CopEmRefine_v4
-- CopEmPremium_v3
-- CopEmRepair_v2
-- CopEmSourire_v1
-- CraxBiteSmooth_v1
local BiteSmoothRS=game:GetService("ReplicatedStorage")
local BiteSmoothEvent=BiteSmoothRS:WaitForChild("CraxBiteSmoothEvent")
local BiteActionEvent=BiteSmoothRS:WaitForChild("CraxBiteActionEvent")
local SkillResolver=require(game:GetService("ServerScriptService"):WaitForChild("CraxSkillResolver"))
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")

local state = workspace:WaitForChild("CombatState")
state:SetAttribute("AbilitiesReady", false)

local biteHit = ServerScriptService:WaitForChild("BiteHit")
assert(biteHit:IsA("BindableEvent"), "BiteHit doit être un BindableEvent.")

-- Trois claquements rapides.
local BITE_COUNT = 3
local CHARGE = 0.30
local OPEN = 0.16
local HOLD = 0.04
local CLOSE = 0.10
local GAP = 0.08
local RECOVER = 0.25

local BITE_DURATION = OPEN + HOLD + CLOSE
local STEP_DURATION = BITE_DURATION + GAP
local ACTIVE_END =
	CHARGE + BITE_COUNT * BITE_DURATION + (BITE_COUNT - 1) * GAP
local TOTAL = ACTIVE_END + RECOVER

local RANGE_SEGMENTS = 80
local RANGE_THICKNESS = 0.14

local fighters = {}

local function createRange(model)
	local name = "BiteRange_" .. model.Name
	local old = workspace:FindFirstChild(name)

	if old then
		old:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = workspace

	local function makePart(partName)
		local part = Instance.new("Part")
		part.Name = partName
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(255, 45, 60)
		part.Transparency = 1
		part.Parent = folder
		return part
	end

	local range = {
		segments = {},
		icons = {},
	}

	for i = 1, RANGE_SEGMENTS do
		range.segments[i] = makePart("Contour")
	end

	for i = 1, 4 do
		local anchor = makePart("Danger")

		local gui = Instance.new("SurfaceGui")
		gui.Name = "Warning"
		gui.Face = Enum.NormalId.Front
		gui.CanvasSize = Vector2.new(128, 128)
		gui.LightInfluence = 0
		gui.AlwaysOnTop = false
		gui.Enabled = false
		gui.Parent = anchor

		local triangle = Instance.new("TextLabel")
		triangle.Size = UDim2.fromScale(1, 1)
		triangle.BackgroundTransparency = 1
		triangle.Font = Enum.Font.GothamBold
		triangle.Text = "▲"
		triangle.TextScaled = true
		triangle.TextColor3 = Color3.fromRGB(255, 110, 70)
		triangle.TextStrokeColor3 = Color3.fromRGB(255, 40, 55)
		triangle.TextStrokeTransparency = 0.25
		triangle.Parent = gui

		local mark = Instance.new("TextLabel")
		mark.Position = UDim2.fromScale(0.2, 0.25)
		mark.Size = UDim2.fromScale(0.6, 0.6)
		mark.BackgroundTransparency = 1
		mark.Font = Enum.Font.GothamBlack
		mark.Text = "!"
		mark.TextScaled = true
		mark.TextColor3 = Color3.fromRGB(45, 8, 12)
		mark.ZIndex = 2
		mark.Parent = gui

		range.icons[i] = {
			part = anchor,
			gui = gui,
			triangle = triangle,
			mark = mark,
		}
	end

	return range
end

local function updateRange(f, visible)
	local radius =
		f.head.Size.X / 2 + (f.model:GetAttribute("BiteExtraRange") or 0)

	local arc = 2 * math.pi / RANGE_SEGMENTS
	local length = 2 * radius * math.sin(arc / 2) + 0.005
	local center = f.head.Position
	local depth = -0.58

	local backdrop =
		workspace:FindFirstChild("ArenaBackdrop")
		or workspace:FindFirstChild("ArenaFloor")

	if backdrop and backdrop:IsA("BasePart") and backdrop.Size.Y > 20 then
		depth = backdrop.Position.Z - backdrop.Size.Z / 2 - 0.08
	end

	local age = f.elapsed or 0
	local opacity = 0

	if visible then
		opacity = math.clamp(
			math.min(age / 0.10, ((f.activeEnd or ACTIVE_END) + 0.15 - age) / 0.15),
			0,
			1
		)
	end

	local pulse = (math.sin(age * math.pi * 2 * 4) + 1) / 2
	local alpha = 1 - (0.60 + 0.18 * pulse) * opacity

	for i, part in ipairs(f.range.segments) do
		part.Transparency = alpha

		if opacity > 0 then
			local angle = (i - 0.5) * arc
			local midpoint = radius * math.cos(arc / 2)

			part.Size = Vector3.new(length, RANGE_THICKNESS, 0.025)
			part.CFrame = CFrame.new(
				center.X + midpoint * math.cos(angle),
				center.Y + midpoint * math.sin(angle),
				depth
			) * CFrame.Angles(0, 0, angle + math.pi / 2)
		end
	end

	for i, icon in ipairs(f.range.icons) do
		icon.gui.Enabled = opacity > 0

		if opacity > 0 then
			local angle = math.pi / 4 + (i - 1) * math.pi / 2
			local size = 1.25 * (1 + 0.05 * pulse)

			icon.part.Size = Vector3.new(size, size, 0.015)
			icon.part.CFrame = CFrame.new(
				center.X + radius * 0.82 * math.cos(angle),
				center.Y + radius * 0.82 * math.sin(angle),
				depth - 0.035
			)

			icon.triangle.TextTransparency =
				1 - (0.70 + 0.15 * pulse) * opacity
			icon.triangle.TextStrokeTransparency = 1 - 0.65 * opacity
			icon.mark.TextTransparency = 1 - 0.9 * opacity
		end
	end
end

local known = {
	"Throat",
	"UpperShell",
	"LowerShell",
	"UpperGums",
	"LowerGums",
	"InnerUpper",
	"InnerLower",
	"UpperFangs",
	"LowerFangs",
	"AngryEyeLeft",
	"AngryEyeRight",
	"AngrySocketLeft",
	"AngrySocketRight",
	"AngryPupilLeft",
	"AngryPupilRight",
	"AngryGlintLeft",
	"AngryGlintRight",
	"UpperFangGums",
	"LowerFangGums",
	"EyeLeft",
	"EyeRight",
}

local function classify(part, model)
	local current = part

	while current and current ~= model do
		for _, key in ipairs(known) do
			if current.Name == key or current.Name == key .. "_Node" then
				return key
			end
		end

		if current.Name:match("^Tooth_0_") then
			return "UpperTeeth"
		end

		if current.Name:match("^Tooth_1_") then
			return "LowerTeeth"
		end

		current = current.Parent
	end
end

local function prepare(name, index)
	local model = workspace:FindFirstChild(name)
	assert(model, "Introuvable : " .. name)

	local head = model:FindFirstChild("Head", true)

	if head and not head:IsA("BasePart") then
		head = head:FindFirstChildWhichIsA("BasePart", true)
	end

	assert(head, "Head introuvable dans " .. name)

	local visual = {}
	local counts = {}

	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false

			local kind = classify(part, model)

			if part == head then
				part.Transparency = 1
			elseif kind then
				table.insert(visual, {
					part = part,
					kind = kind,
					rest = head.CFrame:ToObjectSpace(part.CFrame),
				})

				counts[kind] = (counts[kind] or 0) + 1

				if kind == "AngryEyeLeft"
					or kind == "AngryEyeRight"
					or kind:match("^AngryGlint") then
					part.Material = Enum.Material.Neon
				end
			end
		end
	end

	assert(
		counts.UpperShell and counts.LowerShell,
		"Modèle MonsterHead requis : " .. name
	)

	assert(
		counts.AngryEyeLeft and counts.AngryEyeRight,
		"Les yeux rouges sont introuvables dans " .. name
	)

	local centers = {}
	local totals = {}

	for _, v in ipairs(visual) do
		centers[v.kind] =
			(centers[v.kind] or Vector3.zero) + v.rest.Position
		totals[v.kind] = (totals[v.kind] or 0) + 1
	end

	local function center(kind)
		return centers[kind] / totals[kind]
	end

	local up = (center("UpperShell") - center("LowerShell")).Unit
	local eyeCenter = (center("AngryEyeLeft") + center("AngryEyeRight")) / 2
	local front = eyeCenter - up * eyeCenter:Dot(up)

	assert(front.Magnitude > 0.001, "Orientation introuvable : " .. name)

	front = front.Unit

	local right = front:Cross(up).Unit
	up = right:Cross(front).Unit

	local anatomy = CFrame.fromMatrix(Vector3.zero, right, up, -front)
	local radius = math.max(head.Size.X, head.Size.Y, head.Size.Z) / 2

	for _, child in ipairs(head:GetChildren()) do
		if child.Name == "MonsterBiteSound"
			or child.Name == "BiteOrigin"
			or child.Name == "BiteSnapSound" then
			child:Destroy()
		end
	end

	local sound = Instance.new("Sound")
	sound.Name = "MonsterBiteSound"
	sound.Volume = 0.8
	sound.PlaybackSpeed = 1
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = 60
	sound.RollOffMaxDistance = 180
	sound.Parent = head

	local attachment = Instance.new("Attachment")
	attachment.Name = "BiteOrigin"
	attachment.Position = anatomy:PointToWorldSpace(
		Vector3.new(0, -radius * 0.15, -radius - 0.1)
	)
	attachment.Parent = head

	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Rate = 0
	emitter.Lifetime = NumberRange.new(0.2, 0.45)
	emitter.Speed = NumberRange.new(8, 16)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Color = ColorSequence.new(
		Color3.fromRGB(255, 220, 120),
		Color3.fromRGB(255, 65, 20)
	)
	emitter.LightEmission = 0.9
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	emitter.Parent = attachment

	table.insert(fighters, {
		model = model,
		head = head,
		visual = visual,
		anatomy = anatomy,
		radius = radius,
		sound = sound,
		emitter = emitter,
		range = createRange(model),
		clock = -(index - 1) * 1.25,
		elapsed = nil,
		nextBite = 1,
	})
end

prepare("Fighter1", 1)
prepare("Fighter2", 2)

local function apply(f, amount, threat)
 -- FantasticSkinGuard_v1
 if f.model:GetAttribute("CraxId") == "Crax_Fantastic"or f.model:GetAttribute("CraxId")=="Crax_Deadly"then
  return
 end

	local r = f.radius
	local hinge = Vector3.new(
		0,
		-r * 0.29,
		r * math.sqrt(1 - 0.29 * 0.29)
	)

 local function jaw(angle)
  return f.anatomy * CFrame.new(hinge) * CFrame.Angles(math.rad(angle)*amount,0,0)
   * CFrame.new(-hinge) * f.anatomy:Inverse()
 end
 local upperTransform,lowerTransform=jaw(8),jaw(-24)
 for _,v in ipairs(f.visual)do
  local lower=v.kind:match("^Lower") or v.kind=="InnerLower"
  local transform=lower and lowerTransform or upperTransform

		if v.kind == "Throat" then
			transform = CFrame.identity
		end

		v.part.CFrame = f.head.CFrame * transform * v.rest

		if v.kind == "Throat" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperGums" or v.kind == "LowerGums" then
			v.part.Transparency = math.clamp(amount * 2, 0, 1)
		elseif v.kind == "UpperTeeth" or v.kind == "LowerTeeth" then
			v.part.Transparency = math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperFangs"
			or v.kind == "LowerFangs"
			or v.kind == "UpperFangGums"
			or v.kind == "LowerFangGums" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "EyeLeft" or v.kind == "EyeRight" then
			v.part.Transparency = threat and 1 or 0
		elseif v.kind:match("^Angry") then
			v.part.Transparency = threat and 0 or 1
		else
			v.part.Transparency = 0
		end
	end
end

local function playBiteSound(f)
 -- Les trois claquements sont préchargés et synchronisés côté client.
 -- Le serveur reste responsable des trois vérifications de portée et des dégâts.
end

-- Effets de morsure réussie, indépendants des modèles des combattants.
local HIT_SOUND_ID = "9119055732"
local HIT_EFFECT_DURATION = 0.46
local hitEffects = {}

local oldEffects = workspace:FindFirstChild("CraxBiteImpactEffects")
if oldEffects then oldEffects:Destroy() end
local effectsFolder = Instance.new("Folder")
effectsFolder.Name = "CraxBiteImpactEffects"
effectsFolder.Parent = workspace

local function clearHitEffects()
	for _, effect in pairs(hitEffects) do
		effect.model:Destroy()
	end
	hitEffects = {}
end

local function playHitSound(other)
 BiteSmoothEvent:FireAllClients(other.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow())
end

local function updateHitEffects(dt)
	local phase = state:GetAttribute("Phase")
	if state:GetAttribute("GhostNightActive") or (phase ~= "Fighting" and phase ~= "RoundOver") then
		clearHitEffects()
		return
	end

	for target, effect in pairs(hitEffects) do
		effect.age += dt
		if effect.age >= HIT_EFFECT_DURATION or not target.Parent then
			effect.model:Destroy()
			hitEffects[target] = nil
		else
			local t = effect.age
			-- Les deux mâchoires se referment très vite sur la victime.
			local closing = math.clamp(t / 0.09, 0, 1)
			closing = 1 - (1 - closing) ^ 3
			local reopening = math.clamp((t - 0.20) / 0.26, 0, 1)
			local gap = effect.radius * (0.95 * (1 - closing) + 0.12 * reopening)
			local fade = math.clamp((t - 0.24) / 0.22, 0, 1)
			local position = target.Position
			-- Devant le visage, côté caméra de l'arène.
			local center = Vector3.new(
				position.X, position.Y,
				position.Z - target.Size.Z / 2 - 0.5
			)
			for _, item in ipairs(effect.parts) do
				item.part.CFrame = CFrame.new(center)
					* CFrame.new(0, item.side * gap, 0)
					* item.rest
				item.part.Transparency = item.alpha + (1 - item.alpha) * fade
			end
			effect.flash.FillTransparency = 0.60 + 0.40 * fade
			effect.flash.OutlineTransparency = fade
		end
	end
end

local function showHitJaw(other)
	local previous = hitEffects[other.head]
	if previous then previous.model:Destroy() end

	local model = Instance.new("Model")
	model.Name = "BiteOn_" .. other.model.Name
	local radius = math.max(other.head.Size.X, other.head.Size.Y) * 0.58
	local effect = {
		model = model,
		radius = radius,
		age = 0,
		parts = {},
	}

	local function addPart(name, size, rest, side, color, alpha)
		local part = Instance.new("Part")
		part.Name = name
		part.Size = size
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = color
		part.Transparency = 1
		part.Parent = model
		table.insert(effect.parts, {
			part = part, rest = rest, side = side, alpha = alpha,
		})
	end

	-- Deux arcs de gencives rouges et deux rangées de dents ivoire.
	for _, side in ipairs({ 1, -1 }) do
		local segments = 12
		for i = 1, segments do
			local a = (i - 1) * math.pi / segments
			local b = i * math.pi / segments
			local from = Vector3.new(
				math.cos(a) * radius,
				side * (0.12 * radius + math.sin(a) * radius * 0.45), 0
			)
			local to = Vector3.new(
				math.cos(b) * radius,
				side * (0.12 * radius + math.sin(b) * radius * 0.45), 0
			)
			local delta = to - from
			addPart("Gum", Vector3.new(delta.Magnitude + 0.04, radius * 0.13, 0.16),
				CFrame.new((from + to) / 2)
					* CFrame.Angles(0, 0, math.atan2(delta.Y, delta.X)),
				side, Color3.fromRGB(255, 65, 85), 0.12)
		end

		for i = 1, 7 do
			local x = (i - 4) * radius * 0.25
			local y = 0.12 * radius
				+ math.sqrt(math.max(0, 1 - (x / radius) ^ 2)) * radius * 0.45
			local length = radius * ((i == 2 or i == 6) and 0.48 or 0.34)
			addPart("Tooth", Vector3.new(radius * 0.18, length, 0.20),
				CFrame.new(x, side * (y - length / 2), -0.04),
				side, Color3.fromRGB(255, 250, 210), 0)
		end
	end

	local flash = Instance.new("Highlight")
	flash.Name = "BiteHitFlash"
	flash.Adornee = other.model
	flash.FillColor = Color3.fromRGB(255, 85, 65)
	flash.OutlineColor = Color3.fromRGB(255, 245, 170)
	flash.FillTransparency = 0.6
	flash.OutlineTransparency = 0
	flash.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	flash.Parent = model
	effect.flash = flash
	hitEffects[other.head] = effect

	-- Positionne les pièces avant de les publier dans Workspace.
	local center = other.head.Position
	- Vector3.new(0, 0, other.head.Size.Z / 2 + 0.5)
	for _, item in ipairs(effect.parts) do
		item.part.CFrame = CFrame.new(center)
			* CFrame.new(0, item.side * radius * 0.95, 0) * item.rest
		item.part.Transparency = item.alpha
	end
	model.Parent = effectsFolder
end

local TongueGeometry=require(BiteSmoothRS:WaitForChild("CraxTongueGeometry"))
local SkillConfig=require(BiteSmoothRS:WaitForChild("CraxSkillCatalog"))
local tongueEvent=BiteSmoothRS:WaitForChild("CraxTongueEvent")
local tongueRandom=Random.new()
local tonguePush=game:GetService("ServerScriptService"):WaitForChild("CraxTonguePush")
local function setupTongue(f,other)
 f.tongue=nil
 if f.attackLevel<2 then return end
 local spec=SkillConfig.Crax_Monster
 local enemyRadius=other.head.Size.X/2
 local biteReach=f.head.Size.X/2+enemyRadius+(f.model:GetAttribute("BiteExtraRange")or 0)
 local length=math.max(1,biteReach*(spec.TongueReachMultiplier or 2)-enemyRadius-f.radius*.5)
 local width=spec.TongueWidthPremium or 4.2
 local snapIndex=tongueRandom:NextInteger(1,f.biteCount)
 local start=CHARGE+(snapIndex-1)*STEP_DURATION+OPEN*.15
 f.tongue={start=start,angle=tongueRandom:NextNumber(0,math.pi*2),sign=tongueRandom:NextInteger(0,1)==0 and -1 or 1,hit=false,previous=0,previousEnemy=nil,notified=false,length=length,width=width}
 f.model:SetAttribute("TongueFXLength",length)
 f.model:SetAttribute("TongueFXWidth",width)
 f.model:SetAttribute("TongueFXAngle",f.tongue.angle)
 f.model:SetAttribute("TongueFXSign",f.tongue.sign)
 f.model:SetAttribute("TongueFXRound",state:GetAttribute("RoundId"))
 f.model:SetAttribute("TongueFXStartedAt",f.model:GetAttribute("BiteFXStartedAt")+start)
end
local function updateTongue(f,other,t)
 if AbilityGate.Paused(f.model)then return end
 local tongue=f.tongue
 if not tongue or t<tongue.start then return end
 local spec=SkillConfig.Crax_Monster
 local current=math.min(TongueGeometry.Duration,t-tongue.start)
 local origin=f.head.Position+f.head.CFrame:VectorToWorldSpace(f.anatomy:VectorToWorldSpace(Vector3.new(0,-f.radius*.17,-f.radius*.82)))
 local enemy=Vector3.new(other.head.Position.X,other.head.Position.Y,0)
 local oldEnemy=tongue.previousEnemy or enemy
 local prev=tongue.previous
 local steps=math.max(1,math.ceil((current-prev)/.008))
 if not tongue.hit and current>=TongueGeometry.SweepStart then
  for j=1,steps do
   local time=prev+(current-prev)*j/steps
   if time>=TongueGeometry.SweepStart and time<=TongueGeometry.SweepEnd then
    local target=oldEnemy:Lerp(enemy,j/steps)
    local previous=TongueGeometry.Point(origin,f.radius,tongue.length,tongue.angle,tongue.sign,time,0)
    for n=1,TongueGeometry.Segments do
     local point=TongueGeometry.Point(origin,f.radius,tongue.length,tongue.angle,tongue.sign,time,n/TongueGeometry.Segments)
     local a=Vector3.new(previous.X,previous.Y,0);local b=Vector3.new(point.X,point.Y,0)
     if TongueGeometry.DistanceSegment(target,a,b)<=math.max(other.head.Size.X,other.head.Size.Y)/2+tongue.width*.5
      and (other.model:GetAttribute("Health")or 0)>0 and not other.model:GetAttribute("GhostInvulnerable")then
      tongue.hit=true
      biteHit:Fire(f.model,other.model,spec.TongueDamage,false,"MonsterTongue")
      tonguePush:Fire(f.model,other.model)
      tongueEvent:FireAllClients(f.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow(),true,other.head.Position,other.model.Name)
      tongue.notified=true
      break
     end
     previous=point
    end
   end
   if tongue.hit then break end
  end
 end
 tongue.previous=current;tongue.previousEnemy=enemy
 if current>=TongueGeometry.SweepEnd and not tongue.notified then
  tongue.notified=true
  tongueEvent:FireAllClients(f.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow(),false,origin)
 end
end

local function snap(f, other)
 local Deadly=require(ServerScriptService:WaitForChild('CraxDeadlyRuntime'))
 if not AbilityGate.Paused(f.model)and not Deadly.Flash()and state:GetAttribute('Phase')=='Fighting'and not state:GetAttribute('GhostNightActive')then
  for _,target in ipairs(Deadly.Targets(other.model))do
   if target~=other.model then local h=target:FindFirstChild('Head',true);if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
    if h and(Vector2.new(h.Position.X,h.Position.Y)-Vector2.new(f.head.Position.X,f.head.Position.Y)).Magnitude<=f.head.Size.X/2+h.Size.X/2+(f.model:GetAttribute('BiteExtraRange')or 0)then biteHit:Fire(f.model,target,nil,false,'MonsterBite')end
   end
  end
 end
 if AbilityGate.Paused(f.model)then return end
	if state:GetAttribute("GhostNightActive") or workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) or state:GetAttribute("Phase") ~= "Fighting" then
		return
	end

	playBiteSound(f)

	-- La portée est vérifiée à chaque morsure.
	local delta = other.head.Position - f.head.Position
	local distance = Vector2.new(delta.X, delta.Y).Magnitude
	local reach =
		f.head.Size.X / 2
		+ other.head.Size.X / 2
		+ (f.model:GetAttribute("BiteExtraRange") or 0)

	local attackerHealth = f.model:GetAttribute("Health") or 0
	local targetHealth = other.model:GetAttribute("Health") or 0
	local damage = f.model:GetAttribute("BiteDamage") or 0

	if distance <= reach and attackerHealth > 0 and targetHealth > 0 and damage > 0 then
		showHitJaw(other)
		playHitSound(other)
		f.emitter:Emit(35)
		other.emitter:Emit(15)

		-- CombatHealth utilise les dégâts habituels de morsure.
		biteHit:Fire(f.model, other.model, nil, false, "MonsterBite")
	else
		f.emitter:Emit(5)
	end
end

local function smooth(t)
	t = math.clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

local function mouthAmount(t, activeEnd)
	if t < CHARGE or t >= activeEnd then
		return 0
	end

	local within = (t - CHARGE) % STEP_DURATION

	if within < OPEN then
		return smooth(within / OPEN)
	elseif within < OPEN + HOLD then
		return 1
	elseif within < BITE_DURATION then
		return 1 - smooth((within - OPEN - HOLD) / CLOSE)
	end

	return 0
end

local function resetRound()
	clearHitEffects()
	for index, f in ipairs(fighters) do
		f.clock = -(index - 1) * 1.25
		f.elapsed = nil
		f.nextBite = 1

		for _, child in ipairs(f.head:GetChildren()) do
			if child.Name == "BiteSnapSound" or child.Name == "BiteImpactSound" then
				child:Destroy()
			end
		end

		f.emitter:Clear()
		apply(f, 0, false)
		updateRange(f, false)
	end
end

resetRound()
state:GetAttributeChangedSignal("RoundId"):Connect(resetRound)

RunService.Heartbeat:Connect(function(dt)
	updateHitEffects(dt)
	for index, f in ipairs(fighters) do
		local fighting = state:GetAttribute("Phase") == "Fighting" and not state:GetAttribute("GhostNightActive") and workspace:GetServerTimeNow() >= (state:GetAttribute("GhostFreezeUntil") or 0)
		local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"

		if fighting and enabled and AbilityGate.Paused(f.model)then
            -- Conserve f.clock, f.elapsed, nextBite et progression de langue.
            -- Les clients utilisent la même horloge pour figer leur rendu.
            updateRange(f,f.elapsed~=nil and f.elapsed<(f.activeEnd or ACTIVE_END)+.15)
        elseif fighting and enabled then
            local liveLevel=SkillResolver.Resolve(f.model,index)
            if f.elapsed==nil or (f.attackLevel or liveLevel)<1 then f.clock+=dt end
            local cooldown=liveLevel>=1 and 4 or (f.model:GetAttribute("BiteCooldown")or 3)

			if f.elapsed == nil
				and f.clock >= cooldown and InvertedSilence.CanStart(f.model)then
				f.clock = 0
				f.elapsed = 0
				f.nextBite = 1
				f.attackLevel=math.clamp(tonumber(f.model:GetAttribute("CraxSkillLevel"))or 0,0,3)
                f.biteCount=f.attackLevel>=1 and 5 or 3
                f.activeEnd=CHARGE+f.biteCount*BITE_DURATION+(f.biteCount-1)*GAP
                f.total=f.activeEnd+RECOVER+(f.attackLevel>=2 and .20 or 0)
                f.model:SetAttribute("BiteFXCount",f.biteCount)
                f.model:SetAttribute("BiteFXDuration",f.total)
                f.model:SetAttribute("BiteFXRound",state:GetAttribute("RoundId"))
				f.model:SetAttribute("BiteFXStartedAt",AbilityGate.Time(f.model)-dt)
                setupTongue(f,fighters[3-index])
                BiteActionEvent:FireAllClients({Name=f.model.Name,Round=state:GetAttribute("RoundId"),Started=f.model:GetAttribute("BiteFXStartedAt"),Count=f.biteCount,Duration=f.total,Level=f.attackLevel,Anatomy=f.anatomy,Tongue=f.tongue and {Started=f.model:GetAttribute("TongueFXStartedAt"),Angle=f.tongue.angle,Sign=f.tongue.sign,Length=f.tongue.length,Width=f.tongue.width}or nil})
			end

			local amount = 0
			local threat = false
			local showRange = false

			if f.elapsed ~= nil then
				f.elapsed += dt

				local t = f.elapsed
				local other = fighters[index == 1 and 2 or 1]

				updateTongue(f,other,t)
                if state:GetAttribute("Phase")=="Fighting" then
                while f.nextBite <= f.biteCount do
					local snapTime =
						CHARGE
						+ (f.nextBite - 1) * STEP_DURATION
						+ BITE_DURATION

					if t < snapTime then
						break
					end

					f.nextBite += 1
					snap(f, other)

					if state:GetAttribute("Phase") ~= "Fighting" then
						break
					end
				end

                end
				if state:GetAttribute("Phase") ~= "Fighting" then
					f.elapsed = nil
				elseif t >= f.total then
                    if f.attackLevel>=1 then f.clock=0 end
					f.elapsed = nil
				else
					amount = mouthAmount(t,f.activeEnd)
					threat = true
					showRange = t < f.activeEnd + 0.15
				end
			end

			apply(f, amount, threat)
			updateRange(f, showRange)
		else
			f.elapsed = nil
			apply(f, 0, false)
			updateRange(f, false)
		end
	end
end)

state:SetAttribute("AbilitiesReady", true)
state:GetAttributeChangedSignal("Phase"):Connect(function()
	local phase = state:GetAttribute("Phase")
	if state:GetAttribute("GhostNightActive") or (phase ~= "Fighting" and phase ~= "RoundOver") then
		clearHitEffects()
		for _, f in ipairs(fighters) do
			for _, child in ipairs(f.head:GetChildren()) do
				if child.Name == "BiteImpactSound" then child:Destroy() end
			end
		end
	end
end)

print("MonsterBiteAbilities prêt : triple morsure et impacts visuels.")
state:GetAttributeChangedSignal("GhostNightActive"):Connect(function()
 if not state:GetAttribute("GhostNightActive") then return end
 clearHitEffects()
 for _, f in ipairs(fighters) do
  f.elapsed=nil; f.emitter:Clear(); apply(f,0,false); updateRange(f,false)
  for _, child in ipairs(f.head:GetChildren()) do
   if child.Name=="BiteSnapSound" or child.Name=="BiteImpactSound" then child:Destroy() end
  end
 end
end)
]====]},
{path=[====[ServerScriptService.GhostyNight]====],bytes=14301,hash=108944490,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GhostyGrandFrisson_v1 : niveau Argent, nuit classique plafonnée.
local SSS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Gate=require(SSS:WaitForChild("CraxAbilityGate"))
local Resolver=require(SSS:WaitForChild("CraxSkillResolver"))
local state=workspace:WaitForChild("CombatState")
local hit=SSS:WaitForChild("BiteHit")
local remote=RS:FindFirstChild("GhostyNightEvent")
if not remote then remote=Instance.new("RemoteEvent");remote.Name="GhostyNightEvent";remote.Parent=RS end
assert(remote:IsA("RemoteEvent"),"GhostyNightEvent doit être un RemoteEvent")
local Night={}
local random=Random.new()
local active,freezeEnd,sequence=nil,0,0
local deadlines,bleeds,counts={},{},{}
local nightBlockedUntil=0
local knives,knifeTimers,escapes={},{},{}
local escapeHandler
function Night.SetEscapeHandler(callback) escapeHandler=callback end
function Night.TryEscape(model,enemy)
 if not InvertedSilence.CanStart(model)then return false end
 if model:GetAttribute("AbilityId")~="GhostNightSlash" or (model:GetAttribute("CraxSkillLevel") or 0)<3
  or escapes[model] or not escapeHandler then return false end
 local ok=escapeHandler(model,enemy)
 if not ok then return false end
 escapes[model]=true;model:SetAttribute("GhostEscapeUsed",true)
 return true
end
local function delay() return random:NextNumber(7,12) end
local function numeric(model,key,fallback)
 local v=model:GetAttribute(key)
 return type(v)=="number" and v==v and math.abs(v)<math.huge and v or fallback
end
local function ghost(f) return f.model:GetAttribute("AbilityId")=="GhostNightSlash" end
local function living(f) return numeric(f.model,"Health",0)>0 end
local function send(action,data)
 for _,p in ipairs(Players:GetPlayers()) do
  local seat=p:GetAttribute("ArenaSeat")
  if seat==1 or seat==2 then remote:FireClient(p,action,data) end
 end
end
local function release(record)
 if not record then return end
 for _,model in ipairs(record.locked or {}) do
  Gate.Resume(model,record.reason)
  model:SetAttribute("GhostTerrified",false)
 end
 record.owner.model:SetAttribute("GhostGrandFrisson",false)
end
function Night.Reset(fighters)
 release(active)
 active=nil;freezeEnd=0;deadlines={};bleeds={};counts={};nightBlockedUntil=0
 knives={};knifeTimers={};escapes={}
 for _,f in ipairs(fighters) do
  Resolver.Resolve(f.model)
  if ghost(f) then deadlines[f.model]=delay();knifeTimers[f.model]=0 end
  f.model:SetAttribute("GhostEscapeUsed",false)
  f.model:SetAttribute("GhostDodgeUntil",0)
  f.model:SetAttribute("GhostTeleportUntil",0)
  f.model:SetAttribute("GhostInvulnerable",false)
  f.model:SetAttribute("GhostBleeding",false)
  f.model:SetAttribute("GhostTerrified",false)
  f.model:SetAttribute("GhostGrandFrisson",false)
 end
 state:SetAttribute("GhostNextNightAllowedAt",0)
 state:SetAttribute("GhostNightOwner",nil)
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostFreezeUntil",0)
 state:SetAttribute("GhostNightStart",0)
 state:SetAttribute("GhostNightEnd",0)
 send("Reset",{})
end
function Night.Slow(model)
 return active and active.stage=="Grand" and model~=active.owner.model and .5 or 1
end
-- Appelé uniquement au début d'un nouveau contact par ArenaMovement.
function Night.Contact(a,b)
 if not active or active.stage~="Grand" then return false end
 if Gate.Paused(active.owner.model) then return true end
 local owner=active.owner.model
 local target=a==owner and b or (b==owner and a or nil)
 if target and numeric(target,"Health",0)>0 then
  local before=numeric(target,"Health",0)
  hit:Fire(owner,target,50,false,"GhostGrandContact")
  if numeric(target,"Health",0)<before then send("GrandHit",{Target=target.Name,RoundId=state:GetAttribute("RoundId")}) end
 end
 return true
end
local function line()
 local center=Vector2.new(random:NextNumber(-19,19),random:NextNumber(10,40))
 local angle=random:NextNumber(0,math.pi)
 local d=Vector2.new(math.cos(angle),math.sin(angle))
 local lower,upper=-math.huge,math.huge
 local function clip(p,v,minimum,maximum)
  if math.abs(v)<1e-7 then return end
  local a,b=(minimum-p)/v,(maximum-p)/v
  lower=math.max(lower,math.min(a,b));upper=math.min(upper,math.max(a,b))
 end
 clip(center.X,d.X,-24,24);clip(center.Y,d.Y,5,45)
 return center+d*lower,center+d*upper
end
local function intersects(a,b,p,radius,width)
 local d=b-a
 local t=d:Dot(d)>1e-9 and math.clamp((p-a):Dot(d)/d:Dot(d),0,1) or 0
 return (p-(a+d*t)).Magnitude<=radius+width/2
end
local function knifeStep(dt,fighters)
 -- Bronze : délai de 3 s hors nuit, suspendu pendant les pauses de pouvoir.
 for _,f in ipairs(fighters) do
  if ghost(f) and living(f) and numeric(f.model,"CraxSkillLevel",0)>=1 and not Gate.Paused(f.model) and workspace:GetServerTimeNow()>=(f.model:GetAttribute("GhostTeleportUntil")or 0)then
   knifeTimers[f.model]=(knifeTimers[f.model] or 0)+dt
   if knifeTimers[f.model]>=3 and InvertedSilence.CanStart(f.model)then
    knifeTimers[f.model]=knifeTimers[f.model]-3
    local velocity=f.velocity
    local direction
     local p=f.position
     local center=Vector2.new(0,25)
     local away=p-center
     local directionToFarSide

     if away.Magnitude>0.01 then
      directionToFarSide=-away.Unit
     else
      local angle=random:NextNumber(0,math.pi*2)
      directionToFarSide=Vector2.new(
       math.cos(angle),
       math.sin(angle)
      )
     end

     direction=directionToFarSide
    sequence=sequence+1
    local knife={owner=f.model,position=f.position,direction=direction,id=sequence,age=0,depth=f.depth}
    table.insert(knives,knife)
    send("Knife",{Id=knife.id,Owner=f.model.Name,Position=Vector3.new(f.position.X,f.position.Y,f.depth-.5),
     Direction=Vector3.new(direction.X,direction.Y,0),Speed=70,RoundId=state:GetAttribute("RoundId")})
   end
  end
 end
 for i=#knives,1,-1 do
  local k=knives[i]
  if not k.owner.Parent or numeric(k.owner,"Health",0)<=0 then
   send("KnifeEnd",{Id=k.id,RoundId=state:GetAttribute("RoundId")});table.remove(knives,i)
  elseif not Gate.Paused(k.owner) then
   local before=k.position;local after=before+k.direction*70*dt
   k.age=k.age+dt;k.position=after
   local target
   for _,f in ipairs(require(SSS:WaitForChild('CraxDeadlyRuntime')).MotionTargets(fighters))do
    if f.model~=k.owner and living(f) and intersects(before,after,f.position,f.radius,.55) then target=f.model;break end
   end
   if target or after.X< -25 or after.X>25 or after.Y<4 or after.Y>46 or k.age>2 then
    table.remove(knives,i)
    local actualHit=false
    if target and not target:GetAttribute("GhostInvulnerable") then
     local hp=numeric(target,"Health",0)
     hit:Fire(k.owner,target,30,false,"GhostKnife")
     actualHit=numeric(target,"Health",0)<hp
     if actualHit and numeric(target,"Health",0)>0 and not bleeds[target] and random:NextNumber()<.25 then
      bleeds[target]={source=k.owner,timer=0,remaining=10};target:SetAttribute("GhostBleeding",true)
     end
    end
    send("KnifeEnd",{Id=k.id,Target=actualHit and target.Name or nil,ImpactDuration=1,
     Direction=Vector3.new(k.direction.X,k.direction.Y,0),Position=Vector3.new(after.X,after.Y,k.depth-.7),RoundId=state:GetAttribute("RoundId")})
    if state:GetAttribute("Phase")~="Fighting" then return end
   end
  end
 end
end
local function startNight(clock,fighters,clearWebs)
 if active or clock<freezeEnd or clock<nightBlockedUntil then return end
 local ready,earliest={},math.huge
 for _,f in ipairs(fighters) do
  if ghost(f) and living(f) then
   if not deadlines[f.model] then deadlines[f.model]=clock+delay() end
   local due=deadlines[f.model]
   if not Gate.Paused(f.model) and InvertedSilence.CanStart(f.model)and due<=clock then
    if due<earliest-1e-7 then ready={f};earliest=due
    elseif math.abs(due-earliest)<=1e-7 then table.insert(ready,f) end
   end
  else deadlines[f.model]=nil end
 end
 if #ready==0 then return end
 local owner=ready[random:NextInteger(1,#ready)]
 counts[owner.model]=(counts[owner.model] or 0)+1
 local grand=numeric(owner.model,"CraxSkillLevel",0)>=2 and counts[owner.model]%2==0
 local duration=math.clamp(numeric(owner.model,"NightDuration",4),1,8)
 sequence=sequence+1
 local now=workspace:GetServerTimeNow()
 local record={owner=owner,ending=clock+duration,sequence=sequence,grand=grand,stage="Night",
  reason="GhostGrandFrisson_"..sequence,locked={},round=state:GetAttribute("RoundId"),serverEnd=now+duration}
 active=record
 for _,k in ipairs(knives) do send("KnifeEnd",{Id=k.id,RoundId=record.round}) end
 knives={}
 state:SetAttribute("GhostNightOwner",owner.model.Name)
 state:SetAttribute("GhostNightActive",true)
 -- clearWebs réinitialise les verrous : poser le verrou de terreur APRÈS.
 clearWebs()
 for _,f in ipairs(fighters) do
  f.model:SetAttribute("GhostInvulnerable",f==owner)
  if f.velocity and f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*f.speed end
  if ghost(f) then deadlines[f.model]=clock+math.max(duration+.5,delay()) end
  if false then
   table.insert(record.locked,f.model);Gate.Pause(f.model,record.reason)
   f.model:SetAttribute("GhostTerrified",true)
  end
 end
 owner.model:SetAttribute("GhostGrandFrisson",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightStart",now)
 state:SetAttribute("GhostNightEnd",now+duration)
 send("Night",{Start=now,Duration=duration,Sequence=sequence,RoundId=record.round,
  Owner=owner.model.Name,GrandFrisson=grand})
end
local function beginGrand(clock,fighters)
 local record=active
 local now=workspace:GetServerTimeNow()
 record.stage="Grand";record.ending=clock+5;record.serverEnd=now+5
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",true)
 state:SetAttribute("GhostGrandFrissonStart",now)
 state:SetAttribute("GhostGrandFrissonEnd",now+5)
 record.owner.model:SetAttribute("GhostGrandFrisson",true)
 for _,f in ipairs(fighters) do
  if f~=record.owner then
   table.insert(record.locked,f.model);Gate.Pause(f.model,record.reason)
   f.model:SetAttribute("GhostTerrified",true)
  end
 end
 send("GrandStart",{Owner=record.owner.model.Name,Start=now,Duration=5,
  Sequence=record.sequence,RoundId=record.round})
end
local function finishGrand(clock,fighters)
 local record=active
 release(record);active=nil
 nightBlockedUntil=clock+10
 state:SetAttribute("GhostNextNightAllowedAt",workspace:GetServerTimeNow()+10)
 for _,f in ipairs(fighters)do if ghost(f)then deadlines[f.model]=math.max(deadlines[f.model]or 0,nightBlockedUntil)end end
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightOwner",nil)
 record.owner.model:SetAttribute("GhostInvulnerable",false)
 send("GrandEnd",{Sequence=record.sequence,RoundId=record.round})
end
local function slash(clock,fighters)
 local record=active
 local owner=record.owner.model
 local cuts={}
 for index=1,5 do
  local a,b=line();local victims={}
  for _,f in ipairs(require(SSS:WaitForChild('CraxDeadlyRuntime')).MotionTargets(fighters))do
   if f.model~=owner and living(f) and intersects(a,b,f.position,f.radius,2.8) then
    table.insert(victims,f.model.Name)
   end
  end
  table.insert(cuts,{A=Vector3.new(a.X,a.Y,-5.2),B=Vector3.new(b.X,b.Y,-5.2),
   Width=2.8,Victims=victims,Sequence=record.sequence*10+index,Duration=.35})
 end
 active=nil
 local now=workspace:GetServerTimeNow()
 freezeEnd=clock+.35
 state:SetAttribute("GhostFreezeUntil",now+.35)
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightOwner",nil)
 for _,f in ipairs(fighters) do f.model:SetAttribute("GhostInvulnerable",false) end
 send("SlashBurst",{Cuts=cuts,Sequence=record.sequence,Start=now,Duration=.35,RoundId=record.round})
 local spent={}
 local perCut=math.max(0,numeric(owner,"NightSlashDamage",50))
 for _,cut in ipairs(cuts) do
  for _,name in ipairs(cut.Victims) do
   local target=require(SSS:WaitForChild('CraxDeadlyRuntime')).Find(name)
   if target and numeric(target,"Health",0)>0 then
    local amount=math.min(perCut,math.max(0,50-(spent[target] or 0)))
    if amount>0 then spent[target]=(spent[target] or 0)+amount;hit:Fire(owner,target,amount,false,"GhostSlash") end
    if state:GetAttribute("Phase")~="Fighting" then return end
    if numeric(target,"Health",0)>0 and not bleeds[target]
     and random:NextNumber()<math.clamp(numeric(owner,"NightBleedChance",.25),0,1) then
     bleeds[target]={source=owner,timer=0,remaining=10}
     target:SetAttribute("GhostBleeding",true)
    end
   end
  end
 end
end
function Night.Step(clock,dt,fighters,clearWebs)
 if state:GetAttribute("Phase")~="Fighting" then return false end
 for _,f in ipairs(fighters) do
  if Gate.Paused(f.model) and deadlines[f.model] then deadlines[f.model]=deadlines[f.model]+dt end
 end
 if active and not living(active.owner) then Night.Reset(fighters);return false end
 if active and Gate.Paused(active.owner.model) then
  active.ending=active.ending+dt;active.serverEnd=active.serverEnd+dt
  state:SetAttribute(active.stage=="Grand" and "GhostGrandFrissonEnd" or "GhostNightEnd",active.serverEnd)
  return false
 end
 if active and clock>=active.ending then
  if active.stage=="Grand" then finishGrand(clock,fighters) elseif active.grand then beginGrand(clock,fighters) else slash(clock,fighters) end
 elseif not active and clock>=freezeEnd then startNight(clock,fighters,clearWebs) end
 if state:GetAttribute("Phase")~="Fighting" then return true end
 local frozen=clock<freezeEnd
 if (not active or active.stage=="Grand") and not frozen then
  knifeStep(dt,fighters)
  if state:GetAttribute("Phase")~="Fighting" then return true end
  for target,bleed in pairs(bleeds) do
   if not target.Parent or numeric(target,"Health",0)<=0 then
    bleeds[target]=nil;target:SetAttribute("GhostBleeding",false)
   else
    bleed.timer=bleed.timer+(Gate.Paused(bleed.source) and 0 or dt)
    if bleed.timer>=1 then
     bleed.timer=bleed.timer-1;bleed.remaining=bleed.remaining-1
     send("Bleed",{Target=target.Name,RoundId=state:GetAttribute("RoundId")})
     hit:Fire(bleed.source,target,1,false,"GhostBleed")
     if bleed.remaining<=0 then bleeds[target]=nil;target:SetAttribute("GhostBleeding",false) end
     if state:GetAttribute("Phase")~="Fighting" then break end
    end
   end
  end
 end
 return frozen
end
return Night
]====]},
{path=[====[ServerScriptService.CraxSpideyRuntime]====],bytes=7169,hash=1675742918,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxSpideySkills_v1 : état de combat exclusivement serveur.
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local state=workspace:WaitForChild("CombatState")
local hits=SSS:WaitForChild("BiteHit")
local fx=RS:WaitForChild("CraxCombatFX")
local random=Random.new()
local confirmed=SSS:FindFirstChild("CraxSpideyDamageConfirmed")
if not confirmed then confirmed=Instance.new("BindableEvent");confirmed.Name="CraxSpideyDamageConfirmed";confirmed.Parent=SSS end
assert(confirmed:IsA("BindableEvent"))
local old=workspace:FindFirstChild("SpideySilkTraps");if old then old:Destroy()end
local folder=Instance.new("Folder");folder.Name="SpideySilkTraps";folder.Parent=workspace
local R={};local traps,poisons,timers,previous={},{},{},{};local serial=0;local lastStep=nil
local function head(model)local p=model and model:FindFirstChild("Head",true);if p and not p:IsA("BasePart")then p=p:FindFirstChildWhichIsA("BasePart",true)end;return p end
local function alive(model)return model and model.Parent and(model:GetAttribute("Health")or 0)>0 end
local function active()return state:GetAttribute("Phase")=="Fighting"end
function R.Clear()
 for model in pairs(poisons)do if model.Parent then model:SetAttribute("SpideyPoisonUntil",nil)end end
 for _,trap in ipairs(traps)do if trap.part.Parent then trap.part:Destroy()end end
 for model in pairs(previous)do if model.Parent then model:SetAttribute("SilkSlowUntil",nil);model:SetAttribute("SpideyPoisonUntil",nil)end end
 traps={};poisons={};timers={};previous={};lastStep=nil
end
function R.Volley(model)
 return(model:GetAttribute("CraxSkillLevel")or 0)>=1 and random:NextNumber()<.5 and 2 or 1
end
function R.Poisoned(model)return poisons[model]~=nil or workspace:GetServerTimeNow()<(model:GetAttribute("SpideyPoisonUntil")or 0)end
function R.Slow(model)
 return workspace:GetServerTimeNow()<(model:GetAttribute("SilkSlowUntil")or 0)and .6 or 1
end
confirmed.Event:Connect(function(attacker,defender,lost,kind,round)
 if round and round~=state:GetAttribute("RoundId")then return end
 if kind=="SpideyPoison"and lost>0 then local h=head(defender);if h then fx:FireAllClients("SpideyPoisonTick",h.Position,lost,defender)end;return end
 if not active()or kind~="SpideyInject"or lost<=0 or not alive(attacker)or not alive(defender)
  or attacker:GetAttribute("AbilityId")~="SpideyWeb"or(attacker:GetAttribute("CraxSkillLevel")or 0)<3 then return end
 -- Une nouvelle critique ne renouvelle ni n'empile un venin actif.
 if poisons[defender]then return end
 local now=workspace:GetServerTimeNow()
 poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4}
 defender:SetAttribute("SpideyPoisonUntil",now+4)
 local h=head(defender);if h then fx:FireAllClients("SpideyVenom",h.Position,0,defender)end
end)
local function crosses(a,b,c,r)
 local d=b-a;local t=d:Dot(d)>1e-9 and math.clamp((c-a):Dot(d)/d:Dot(d),0,1)or 0
 return(a+d*t-c).Magnitude<=r
end
local function spawn(f,now)
 if not InvertedSilence.CanStart(f.model)then return end
 local count=0;for _,t in ipairs(traps)do if t.owner==f.model then count=count+1 end end
 if count>=3 then return end
 serial=serial+1
 local p=Instance.new("Part");p.Name="SilkTrap_"..serial;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Transparency=1
 -- Diamètre égal à celui du Crax.
 local radius=f.radius;p.Size=Vector3.new(radius*2,radius*2,.05);p.Position=Vector3.new(f.position.X,f.position.Y,f.depth)
 p:SetAttribute("Born",now);p:SetAttribute("Expires",now+7);p:SetAttribute("Radius",radius);p:SetAttribute("RoundId",state:GetAttribute("RoundId"));p:SetAttribute("Owner",f.model.Name);p.Parent=folder
 traps[#traps+1]={part=p,owner=f.model,position=f.position,radius=radius,expires=now+7,inside={},armed={}}
 fx:FireAllClients("SpideyTrapWeave",p.Position,0,f.model)
end
function R.Step(fighters)
 if not active()then R.Clear();return end
 local now=workspace:GetServerTimeNow()
 local dt=lastStep and math.max(0,now-lastStep)or 0;lastStep=now
 for _,f in ipairs(fighters)do
  if AbilityGate.Paused(f.model)or f.sting or f.capturedBy and f.capturedBy.sting then
   if timers[f.model]then timers[f.model]=timers[f.model]+dt end
  end
 end
 for model,p in pairs(poisons)do
  if AbilityGate.Paused(p.attacker)or now<(p.attacker:GetAttribute("SpideyStingingUntil")or 0)then
   p.next=p.next+dt;model:SetAttribute("SpideyPoisonUntil",p.next+p.remaining-1)
  end
 end
 for i=#traps,1,-1 do local t=traps[i];if now>=t.expires then t.part:Destroy();table.remove(traps,i)end end
 local blocked=state:GetAttribute("GhostNightActive")or now<(state:GetAttribute("GhostFreezeUntil")or 0)
 for model,p in pairs(poisons)do
  if p.round~=state:GetAttribute("RoundId")or not alive(model)or not alive(p.attacker)then poisons[model]=nil;model:SetAttribute("SpideyPoisonUntil",nil)
  elseif not AbilityGate.Paused(p.attacker)and now>=p.next and now>=(p.attacker:GetAttribute("SpideyStingingUntil")or 0)then
   if not blocked then
    -- Une porte CombatHealth unique valide chaque tick et toutes les protections.
    hits:Fire(p.attacker,model,5,false,"SpideyPoison")
    if not active()then R.Clear();return end
   end
   p.remaining=p.remaining-1;p.next=now+1
   if p.remaining==0 then poisons[model]=nil;model:SetAttribute("SpideyPoisonUntil",nil)end
  end
 end
 for _,f in ipairs(fighters)do
  if f.model:GetAttribute("AbilityId")=="SpideyWeb"and(f.model:GetAttribute("CraxSkillLevel")or 0)>=2 then
   timers[f.model]=timers[f.model]or(now+random:NextNumber(5,10))
   if not blocked and not AbilityGate.Paused(f.model)and now>=(f.model:GetAttribute("SpideyStingingUntil")or 0)and not f.model:GetAttribute("WebImmobilized")and now>=timers[f.model]then spawn(f,now);timers[f.model]=now+random:NextNumber(5,10)end
  end
 end
 for _,f in ipairs(fighters)do
  local position=f.position;local last=previous[f.model]or position
  if not blocked and alive(f.model)and not f.model:GetAttribute("GhostInvulnerable")then
   for i=#traps,1,-1 do
    local t=traps[i]
    local radius=t.radius+f.radius
    local inside=(position-t.position).Magnitude<=radius
    -- Seul le propriétaire est immunisé ; un Spidey adverse déclenche le piège.
    local armed=t.owner~=f.model
    if t.owner~=f.model or not inside then t.armed[f.model]=true end
    if armed and not t.inside[f.model]and crosses(last,position,t.position,radius)then
     if now>=(f.model:GetAttribute("SilkSlowUntil")or 0)then
      f.model:SetAttribute("SilkSlowUntil",now+4)
      fx:FireAllClients("SpideyTrapSnare",Vector3.new(position.X,position.Y,f.depth),0,f.model)
     end
    end
    if armed and not t.inside[f.model]and crosses(last,position,t.position,radius)then
     -- Consommée une seule fois, même si la cible est déjà ralentie.
     t.part:Destroy();table.remove(traps,i)
    else t.inside[f.model]=inside end
   end
  end
  previous[f.model]=position
 end
end
state:GetAttributeChangedSignal("RoundId"):Connect(R.Clear)
state:GetAttributeChangedSignal("Phase"):Connect(function()if not active()then R.Clear()end end)
return R
]====]},
{path=[====[ServerScriptService.FantasticSchedule]====],bytes=2180,hash=472560005,source=[====[-- Horloges et priorité indépendantes de la géométrie et de l'affichage.
local M={}
function M.New(level,random)
 return {level=level,random=random,time=0,reinforce=0,reinforceWait=random(7,11),torch=0,
  torchPending=0,damageLost=0,nextThreshold=40,elastic=false,elasticWait=random(5,10),
  invisible=0,invisibleUsed=false,invisiblePending=false,healed=0}
end
function M.Lost(r,amount)
 if r.level<1 or amount<=0 then return end
 r.damageLost=r.damageLost+amount
 while r.damageLost>=r.nextThreshold do
  r.nextThreshold=r.nextThreshold+40;r.torchPending=r.torchPending+1
 end
end
function M.ElasticFinished(r)
 r.elastic=false;r.elasticWait=r.random(5,10)
end
function M.Step(r,dt,externalBusy,roundElapsed,canStart)
 canStart=canStart~=false
 local out={}
 r.time=roundElapsed or(r.time+dt)
 if r.level>=2 and not r.invisibleUsed and r.time>=15 then r.invisiblePending=true end
 if r.invisible>0 then
  local active=math.min(dt,r.invisible)
  r.invisible=math.max(0,r.invisible-dt)
  local healing=math.min(20-r.healed,active*20/3)
  r.healed=r.healed+healing;out.heal=healing
  if r.invisible<=1e-8 then r.invisible=0;out.invisibleEnd=true end
  return out
 end
 if canStart and r.invisiblePending and r.reinforce==0 and r.torch==0 and not r.elastic and not externalBusy then
  r.invisiblePending=false;r.invisibleUsed=true;r.invisible=3;r.healed=0
  out.invisibleStart=true;return out
 end
 if r.reinforce>0 then
  r.reinforce=math.max(0,r.reinforce-dt)
  if r.reinforce==0 then r.reinforceWait=r.random(7,11);out.reinforceEnd=true end
 else r.reinforceWait=math.max(0,r.reinforceWait-dt)end
 if r.torch>0 then r.torch=math.max(0,r.torch-dt);if r.torch==0 then out.torchEnd=true end end
 if not r.elastic then r.elasticWait=math.max(0,r.elasticWait-dt)end
 -- Une invisibilité en attente bloque seulement les nouvelles activations.
 if r.invisiblePending then return out end
 if canStart and r.reinforce==0 and r.reinforceWait==0 then r.reinforce=4;out.reinforceStart=true end
 if canStart and r.torch==0 and r.torchPending>0 then r.torchPending=r.torchPending-1;r.torch=7;out.torchStart=true end
 if canStart and r.level>=3 and not r.elastic and r.elasticWait==0 and not externalBusy then r.elastic=true;out.elasticStart=true end
 return out
end
return M
]====]},
{path=[====[ServerScriptService.FantasticRuntime]====],bytes=12307,hash=4063111269,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GoldenCombatBase_v1
-- FantasticRuntime_v9
local SSS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local Rig=require(RS:WaitForChild("FantasticHandRig"))
local PositionLock=require(SSS:WaitForChild('CraxPositionLock'))
local Schedule=require(SSS:WaitForChild("FantasticSchedule"))
local Burning=require(SSS:WaitForChild("CraxBurning"))
local Gate=require(SSS:WaitForChild("CraxAbilityGate"))
local state=workspace:WaitForChild("CombatState")
local Deadly=require(SSS:WaitForChild("CraxDeadlyRuntime"))
local hit=SSS:WaitForChild("BiteHit")
local heal=SSS:WaitForChild("CraxHeal")
local confirmed=SSS:WaitForChild("FantasticDamageConfirmed")
local FX=RS:WaitForChild("FantasticHandFX")
local nextId=0
local random=Random.new();local M={};local records={};local round;local started=workspace:GetServerTimeNow()
local folder=Instance.new("Folder");folder.Name="FantasticHandVisuals";folder.Parent=workspace
local function isFantastic(model)return model:GetAttribute("AbilityId")=="FantasticRock"end
local function part(name,size,color,parent)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Color=color;p.Material=Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent;return p
end
local function rope(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.01,d.Magnitude));p.CFrame=CFrame.lookAt((a+b)/2,b)
end
local function release(r)
 local h=r.hand;if not h then return end
 r.lastHandId=h.id;FX:FireAllClients("Release",{Id=h.id,Owner=r.f.model.Name})
 if h.target then
  h.target.model:SetAttribute("FantasticGrabbed",false)
  Gate.Resume(h.target.model,"FantasticHand")
 end
 PositionLock.Unlock(r.f)
 r.f.model:SetAttribute("FantasticPinned",false);r.f.model:SetAttribute("FantasticElastic",false)
 if h.visual then h.visual:Destroy()end;r.hand=nil;Schedule.ElasticFinished(r.schedule)
end
function M.Reset()
 for model,r in pairs(records)do
  release(r);Gate.Resume(model,"FantasticInvisible")
  for _,key in ipairs({"FantasticInvisible","FantasticReinforced","FantasticTorch","FantasticPinned","FantasticElastic","FantasticGrabbed"})do model:SetAttribute(key,false)end
 end
 records={};Burning.Reset();folder:ClearAllChildren();round=state:GetAttribute("RoundId");started=workspace:GetServerTimeNow()
end
local function launch(r)
 local f=r.f;local angle=random:NextNumber(0,math.pi*2)
 local group=Instance.new("Model");group.Name="ElasticHand";group.Parent=folder
 nextId=nextId+1
 r.hand={position=f.position,direction=Vector2.new(math.cos(angle),math.sin(angle)),elapsed=0,
  path={f.position},visual=group,grip=0,stage="windup",windup=0,tick=0,turnWait=random:NextNumber(.55,1.1),id=nextId,angle=angle-math.pi/2}
 FX:FireAllClients("Launch",{Id=nextId,Owner=f.model.Name})
 PositionLock.Lock(f)
 f.model:SetAttribute("FantasticPinned",true);f.model:SetAttribute("FantasticElastic",true)
end
local function firstHit(a,b,center,radius)
 local d=b-a;local offset=a-center;local length2=d:Dot(d)
 if offset:Dot(offset)<=radius*radius then return 0 end
 if length2<1e-9 then return nil end
 local v=offset:Dot(d);local disc=v*v-length2*(offset:Dot(offset)-radius*radius)
 if disc<0 then return nil end
 local u=(-v-math.sqrt(disc))/length2
 if u>=0 and u<=1 then return u end
end
local function pose(r,force)
 local h=r.hand;if not h then return end
 local now=workspace:GetServerTimeNow()
 if not force and now-(h.sent or 0)<1/30 then return end
 h.sent=now
 local depth=h.target and h.target.depth+h.target.radius*.95 or r.f.depth+r.f.head.Size.Z*.48+.2
 local points={Vector3.new(r.f.position.X,r.f.position.Y,depth)}
 local last=h.stage=='out'and #h.path or math.max(1,h.index or #h.path)
 for i=2,last do points[#points+1]=Vector3.new(h.path[i].X,h.path[i].Y,depth)end
 points[#points+1]=Vector3.new(h.position.X,h.position.Y,depth)
 FX:FireAllClients('Pose',{Id=h.id,Round=round,Owner=r.f.model.Name,Target=h.target and h.target.model.Name,
  CF=CFrame.new(h.position.X,h.position.Y,depth)*CFrame.Angles(0,0,h.angle or 0)*CFrame.Angles(0,math.pi,0),
  Grip=h.grip,Scale=h.target and math.clamp(h.target.radius*.68,1.9,3.06)or 1.9,
  Radius=h.target and h.target.radius or 0,Depth=h.target and h.target.depth-depth or 0,
  Points=points,Stage=h.stage,GrabAge=h.grabTime or 0})
end
local function handStep(r,enemy,dt)
 local h=r.hand;if not h then return end
 if h.target and (not h.target.model.Parent or(h.target.model:GetAttribute('Health')or 0)<=0
  or h.target.model:GetAttribute('DeadlyPhantom')or workspace:GetServerTimeNow()<(h.target.model:GetAttribute('GhostTeleportUntil')or 0))then release(r);return end
 if h.stage=='windup'then
  h.windup=h.windup+dt;local u=math.clamp(h.windup/.18,0,1)
  h.position=r.f.position+h.direction*(r.f.radius*.55*u*u*(3-2*u))
  if u==1 then h.path[#h.path+1]=h.position;h.stage='out' end
 elseif h.stage=='grab'then
  h.grabTime=h.grabTime+dt;local u=math.clamp(h.grabTime/.28,0,1);local smooth=u*u*(3-2*u)
  h.position=h.grabFrom+(h.grabGoal-h.grabFrom)*smooth;h.grip=math.clamp((h.grabTime-.08)/.48,0,1)
  if h.grabTime>=1.5 then h.stage='return';h.index=#h.path;h.position=h.grabGoal end
 elseif h.stage=='out'then
  local remaining=math.min(dt,math.max(0,4-h.elapsed));h.elapsed=h.elapsed+remaining
  local canGrab=not enemy.model:GetAttribute('FantasticInvisible')and not enemy.capturedBy and not enemy.model:GetAttribute('FantasticGrabbed')
  local safety=0
  while remaining>1e-7 and h.stage=='out'and safety<16 do
   safety=safety+1;local a=h.position;local dir=h.direction
   local tx=dir.X>1e-8 and (22.6-a.X)/(dir.X*48)or dir.X< -1e-8 and (-22.6-a.X)/(dir.X*48)or math.huge
   local ty=dir.Y>1e-8 and (43.6-a.Y)/(dir.Y*48)or dir.Y< -1e-8 and (6.4-a.Y)/(dir.Y*48)or math.huge
   local step=math.max(0,math.min(remaining,tx,ty,h.turnWait));local b=a+dir*48*step
   local u,chosen=nil,nil
   for _,candidate in ipairs(Deadly.MotionTargets({r.f,enemy}))do
    if not Deadly.SameTeam(r.f.model,candidate.model)and(candidate.model:GetAttribute('Health')or 0)>0
     and not candidate.model:GetAttribute('FantasticInvisible')and not candidate.model:GetAttribute('DeadlyPhantom')and not candidate.capturedBy and not candidate.model:GetAttribute('FantasticGrabbed')then
     local entry=firstHit(a,b,candidate.position,candidate.radius+1.3)
     if entry and(not u or entry<u)then u=entry;chosen=candidate end
    end
   end
   if chosen then enemy=chosen end
   if u then
    h.position=a+(b-a)*u;h.path[#h.path+1]=h.position;h.target=enemy;h.stage='grab';h.grabTime=0;h.grabFrom=h.position;h.grabGoal=enemy.position
    enemy.model:SetAttribute('FantasticGrabbed',true);Gate.Pause(enemy.model,'FantasticHand')
    FX:FireAllClients('Grab',{Id=h.id,Owner=r.f.model.Name,Target=enemy.model.Name});break
   end
   h.position=b;remaining=remaining-step;h.turnWait=h.turnWait-step
   if step>=tx-1e-7 or step>=ty-1e-7 then
    h.path[#h.path+1]=b
    h.direction=Vector2.new(step>=tx-1e-7 and -dir.X or dir.X,step>=ty-1e-7 and -dir.Y or dir.Y)
    FX:FireAllClients('Bounce',{Id=h.id,Owner=r.f.model.Name})
   elseif h.turnWait>1e-7 then break end
   if h.turnWait<=1e-7 then
    if (h.path[#h.path]-b).Magnitude>.01 then h.path[#h.path+1]=b end
    local angle=math.atan2(h.direction.Y,h.direction.X)+random:NextNumber(-2.15,2.15)
    h.direction=Vector2.new(math.cos(angle),math.sin(angle));h.turnWait=random:NextNumber(.55,1.1)
   end
  end
  h.angle=math.atan2(h.direction.Y,h.direction.X)-math.pi/2
  if h.stage=='out'and h.elapsed>=4-1e-7 then h.stage='return';h.index=#h.path end
 else
  local distance=48*dt;local moving=dt
  while distance>1e-7 and h.index>=1 do
   local goal=h.path[h.index];local delta=goal-h.position;local length=delta.Magnitude
   local nextPosition=length<=distance and goal or h.position+delta.Unit*distance
   if length>.001 then h.angle=math.atan2(-delta.Y,-delta.X)-math.pi/2 end
   -- Les doigts pointent à l’opposé de la traction ; le poignet accompagne le trajet.
   if h.target and h.index<=2 then
    local u=firstHit(h.position,nextPosition,r.f.position,r.f.radius+h.target.radius-.02)
    if u then nextPosition=h.position+(nextPosition-h.position)*u;moving=math.max(0,dt-(distance-(nextPosition-h.position).Magnitude)/48);h.index=0 end
   end
   local used=(nextPosition-h.position).Magnitude;h.position=nextPosition;distance=math.max(0,distance-used)
   if h.index==0 then break end
   if length<=used+1e-7 then h.index=h.index-1 else break end
  end
  if h.target then
   h.target.position=h.position;h.tick=h.tick+moving
   while h.tick>=.2-1e-8 do h.tick=h.tick-.2;hit:Fire(r.f.model,h.target.model,2,false,'FantasticElastic')end
  end
  if h.index<1 then
   if h.target and (h.target.position-r.f.position).Magnitude<r.f.radius+h.target.radius-.05 then
    local d=h.target.position-r.f.position;local direction=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
    h.target.position=r.f.position+direction*(r.f.radius+h.target.radius-.02);h.position=h.target.position
   end
   pose(r,true);release(r);return
  end
 end
 pose(r,false)
end

confirmed.Event:Connect(function(attacker,defender,lost,kind,roundId)
 if roundId~=round or state:GetAttribute("Phase")~="Fighting"then return end
 if kind=="FantasticElastic"and lost>0 then
  local owner=records[attacker];local h=owner and owner.hand
  local id=h and h.id or owner and owner.lastHandId
  if id then owner.damageSequence=(owner.damageSequence or 0)+1;FX:FireAllClients("Tick",{Id=id,Owner=attacker.Name,Target=defender.Name,Damage=lost,Sequence=owner.damageSequence,At=workspace:GetServerTimeNow()})end
 end
 local r=records[defender];if r then Schedule.Lost(r.schedule,lost)end
 if kind=="FantasticTorch"and lost>0 then Burning.Apply(attacker,defender)end
end)
function M.BlockContact(a,b)
 return a.model:GetAttribute("FantasticInvisible")or b.model:GetAttribute("FantasticInvisible")
  or a.model:GetAttribute("FantasticGrabbed")or b.model:GetAttribute("FantasticGrabbed")
end
function M.Hold(f)return f.model:GetAttribute("FantasticPinned")or f.model:GetAttribute("FantasticGrabbed")end
function M.Step(dt,fighters)
 if round~=state:GetAttribute("RoundId")then M.Reset()end
 if state:GetAttribute("Phase")~="Fighting"or state:GetAttribute('GhostNightActive')then return end
 Burning.Step(dt)
 for index,f in ipairs(fighters)do
  PositionLock.Enforce(f)
  if isFantastic(f.model)then
   local r=records[f.model]
   if not r then
    r={f=f,schedule=Schedule.New(f.model:GetAttribute("CraxSkillLevel")or 0,function(a,b)return random:NextNumber(a,b)end),contact=-1}
    records[f.model]=r
   end
   local s=r.schedule;local enemy=fighters[3-index]
   if not f.model:GetAttribute("GoldenStatue")and (f.model:GetAttribute("Health")or 0)>0 and (s.invisible>0 or not Gate.Paused(f.model))then
    local actions=Schedule.Step(s,dt,f.sting~=nil or f.capturedBy~=nil or f.model:GetAttribute("FantasticGrabbed"),workspace:GetServerTimeNow()-started,InvertedSilence.CanStart(f.model))
    if actions.invisibleStart then f.model:SetAttribute("FantasticInvisible",true);Gate.Pause(f.model,"FantasticInvisible")end
    if actions.heal and actions.heal>0 then heal:Fire(f.model,actions.heal)end
    if actions.invisibleEnd then f.model:SetAttribute("FantasticInvisible",false);Gate.Resume(f.model,"FantasticInvisible")end
    if actions.reinforceStart then f.model:SetAttribute("FantasticReinforced",true)end
    if actions.reinforceEnd then f.model:SetAttribute("FantasticReinforced",false)end
    if actions.torchStart then f.model:SetAttribute("FantasticTorch",true)end
    if actions.torchEnd then f.model:SetAttribute("FantasticTorch",false)end
    if actions.elasticStart then launch(r)end
    if s.invisible==0 then
     if r.hand then handStep(r,enemy,dt)end
     if s.torch>0 and s.time-r.contact>=1-1e-8 then
      local touched=false
      for _,candidate in ipairs(Deadly.MotionTargets(fighters))do
       if not Deadly.SameTeam(f.model,candidate.model)and not candidate.model:GetAttribute('FantasticInvisible')and not candidate.model:GetAttribute('DeadlyPhantom')and(candidate.position-f.position).Magnitude<=f.radius+candidate.radius+.18 then
        touched=true;hit:Fire(f.model,candidate.model,20,false,'FantasticTorch')
       end
      end
      if touched then r.contact=s.time end
     end
    end
   end
  end
 end
end
return M
]====]},
{path=[====[ServerScriptService.CraxPlumberRuntime]====],bytes=8620,hash=1436226123,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- PlumberBugFix_v5
-- PlumberFix_v2
-- PlumberLevels_v1
-- PlumberIntegration_v1: authoritative integration for the supplied ArenaMovement.
local SSS=game:GetService('ServerScriptService')
local RS=game:GetService('ReplicatedStorage')
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Core=require(SSS:WaitForChild('CraxPlumberCore'))
local state=workspace:WaitForChild('CombatState')
local assets=RS:WaitForChild('CraxPlumberAssets')
local event=RS:WaitForChild('CraxPlumberEvent')
local logic=Core.new();local fighters={};local records={}
local Levels=require(SSS:WaitForChild('CraxPlumberLevels'))
local Spatial=require(SSS:WaitForChild('PlumberSpatialRules'))
local exitRandom=Random.new()
local M={};local Z=Vector3.new(0,0,1)
local normal={Left=Vector2.new(1,0),Right=Vector2.new(-1,0),Bottom=Vector2.new(0,1),Top=Vector2.new(0,-1)}
local function now()return workspace:GetServerTimeNow()end
local function isPlumber(model)
 return model:GetAttribute('CraxId')=='Crax_Plumber'and model:GetAttribute('AbilityId')=='PlumberPipe'
end
local function vec(p,depth)return Vector3.new(p.X,p.Y,depth)end
local function frame(p,n,depth)
 local up=Vector3.new(n.X,n.Y,0);return CFrame.fromMatrix(vec(p,depth),up:Cross(Z),up,Z)
end
local function cap(model,white)
 local saved=records[model];if not saved then saved={colours={}};records[model]=saved end
 for _,part in ipairs(model:GetDescendants())do
  if part:IsA('BasePart')and part.Name:sub(1,3)=='Cap'then
   if not saved.colours[part]then saved.colours[part]=part.Color end
   if white then
    local name=part.Name:lower();part.Color=(name:find('large_c',1,true)or name:find('raised_c',1,true))and Color3.fromRGB(196,13,22)or Color3.fromRGB(248,248,242)
   else part.Color=saved.colours[part]end
  end
 end
 model:SetAttribute('PlumberWhiteCap',white)
end
local function allowed(f)
 return isPlumber(f.model)and state:GetAttribute('Phase')=='Fighting'and(f.model:GetAttribute('Health')or 0)>0
  and not Gate.Paused(f.model)and not state:GetAttribute('GhostNightActive')and not state:GetAttribute('DeadlyDemoActive')
  and not f.capturedBy and not f.model:GetAttribute('FantasticPinned')
end
function M.ContactDamage(model)
 if isPlumber(model)then if(model:GetAttribute('PlumberStarUntil')or 0)>now()then return 40 end;return logic:Damage(model,now())end
 return model:GetAttribute('CollisionDamage')or 0
end
function M.Hold(model)
 local r=logic.records[model];return r~=nil and r.transit~=nil
end
function M.Speed(f)
 if not isPlumber(f.model)or not allowed(f)then return 1 end
 if(f.model:GetAttribute('PlumberStarUntil')or 0)>now()then return 1.6 end
 local r=logic:Get(f.model);local t=now()
 return r.boostUntil>t and 1.20*((r.impulseUntil or 0)>t and 1.12 or 1)or 1
end
local function destroy(model)
 Levels.Clear(model)
 local r=logic:Clear(model)
 if r then for _,pipe in ipairs(r.pipes)do if pipe.Model then pipe.Model:Destroy()end end end
 if model.Parent then
  cap(model,false);model:SetAttribute('PlumberInTransit',nil);model:SetAttribute('PlumberPipeCount',nil);model:SetAttribute('PlumberBoostUntil',nil)
 end
 event:FireAllClients('Cancel',model);records[model]=nil
end
function M.Reset()
 Levels.Reset()
 local list={};for model in pairs(logic.records)do list[#list+1]=model end
 for _,model in ipairs(list)do destroy(model)end
end
function M.Bind(list)M.Reset();fighters=list end
local function pose(f,p)return CFrame.new(p.X,p.Y,f.depth)*f.rotation end
function M.Wall(f,side)
 if not InvertedSilence.CanStart(f.model)then return end
 if not allowed(f)or M.Hold(f.model)then return end
 -- Only the bound fighter which physically touched this wall may create a pipe.
 local registered=false
 for _,fighter in ipairs(fighters)do if fighter==f then registered=true;break end end
 if not registered then return end
 local contact=side=='Left'and math.abs(f.position.X-(-24+f.radius))
  or side=='Right'and math.abs(f.position.X-(24-f.radius))
  or side=='Bottom'and math.abs(f.position.Y-(5+f.radius))
  or side=='Top'and math.abs(f.position.Y-(45-f.radius))
 if not contact or contact>.2 then return end
 local n=normal[side];if not n then return end
 local model=f.model;local r=logic:Get(model);local t=now()
 if r.boostUntil>t or #r.pipes>=6 or t<r.nextWall then return end
 local point=f.position-n*(f.radius-.12)
 -- Snap the normal coordinate to the real arena wall, never a fighter's centre.
 if side=='Left'then point=Vector2.new(-23.88,point.Y)
 elseif side=='Right'then point=Vector2.new(23.88,point.Y)
 elseif side=='Bottom'then point=Vector2.new(point.X,5.12)
 else point=Vector2.new(point.X,44.88)end
 local occupied={}
 for _,network in pairs(logic.records)do for _,pipe in ipairs(network.pipes)do occupied[#occupied+1]=pipe end end
 point=Spatial.WallSlot(point,side,f.radius,occupied)
 if not point then return end
 local tangent=(side=='Left'or side=='Right')and point.Y or point.X
 local key=side..':'..tostring(math.floor(tangent/math.max(1,f.radius*1.2)))
 local index=#r.pipes+1;local colour=({'Vert','Vert','Orange','Orange','Rouge','Rouge'})[index]
 local template=assets:FindFirstChild('Pipe'..colour)
 if not template then warn('Plumber : modèle de tuyau absent : '..colour);return end
 local pipeModel=template:Clone();local mouth=frame(point,n,f.depth)
 local size=template:GetAttribute('MouthInnerDiameter');if type(size)~='number'or size<=0 then pipeModel:Destroy();return end
 pipeModel:ScaleTo(pipeModel:GetScale()*(f.radius*2.04/size));pipeModel:PivotTo(mouth)
 local pipe={Owner=model,RoundId=state:GetAttribute('RoundId'),Key=key,Side=side,Point=point,Normal=n,Frame=mouth,Model=pipeModel,Radius=f.radius}
 local ok=logic:Add(model,pipe,t)
 if not ok then pipeModel:Destroy();return end
 local folder=workspace:FindFirstChild('CraxPlumberPipes')
 if not folder then folder=Instance.new('Folder');folder.Name='CraxPlumberPipes';folder.Parent=workspace end
 pipeModel.Name=model.Name..'_Pipe_'..pipe.Index;pipeModel:SetAttribute('PlumberOwner',model.Name);pipeModel:SetAttribute('PlumberOwnerCraxId','Crax_Plumber');pipeModel:SetAttribute('PlumberRoundId',state:GetAttribute('RoundId'));pipeModel:SetAttribute('PipeIndex',pipe.Index);pipeModel.Parent=folder
 model:SetAttribute('PlumberPipeCount',#r.pipes)
 event:FireAllClients('PipeCreated',model,mouth,nil,{Pipe=pipeModel})
end
local function cancel(f,t)
 if t then
  f.position=t.Exited and t.EndPosition or t.StartPosition;f.velocity=t.SavedVelocity
  event:FireAllClients('Cancel',f.model)
 end
 logic:Cancel(f.model);f.model:SetAttribute('PlumberInTransit',nil)
end
function M.Step(dt,enabled)
 local t=now()
 for _,f in ipairs(fighters)do
  local model=f.model
  if not model.Parent or not isPlumber(model)or(model:GetAttribute('Health')or 0)<=0 or state:GetAttribute('Phase')~='Fighting'then
   if logic.records[model]then destroy(model)end
  else
   local r=logic:Get(model)
   if not enabled or not allowed(f)then if r.transit then cancel(f,r.transit)end end
   local events,transit=logic:Advance(model,t)
   for _,kind in ipairs(events)do
    if kind=='Exit'then
     f.position=transit.EndPosition
     local n=transit.Exit.Normal;local tangent=Vector2.new(-n.Y,n.X)
     local angle=exitRandom:NextNumber(-math.pi*.42,math.pi*.42)
     f.velocity=(n*math.cos(angle)+tangent*math.sin(angle)).Unit*f.speed
     transit.SavedVelocity=f.velocity
     r.white=true;cap(model,true);model:SetAttribute('PlumberBoostUntil',r.boostUntil)
     Levels.Exit(f,transit.Exit,r)
    elseif kind=='End'then model:SetAttribute('PlumberInTransit',nil)
    elseif kind=='Red'then cap(model,false);model:SetAttribute('PlumberBoostUntil',nil)end
   end
   if enabled and allowed(f)and InvertedSilence.CanStart(model)and not r.transit then
    local contacts={}
    for _,pipe in ipairs(r.pipes)do
     local centre=pipe.Point+pipe.Normal*(f.radius*.50)
     if(f.position-centre).Magnitude<=f.radius*.82+.14 then contacts[pipe.Index]=true end
    end
    local transit=logic:Contact(model,contacts,t)
    if transit then
     Levels.Enter(f,transit)
     transit.StartPosition=f.position;transit.SavedVelocity=f.velocity
     local p=transit.Exit.Point+transit.Exit.Normal*(f.radius+.80)
     p=Vector2.new(math.clamp(p.X,-24+f.radius,24-f.radius),math.clamp(p.Y,5+f.radius,45-f.radius))
     transit.EndPosition=p;model:SetAttribute('PlumberInTransit',true);f.knockback=nil
     local packet={StartPivot=pose(f,f.position),EndPivot=pose(f,p),StartedAt=t,WaterScale=math.max(.6,f.radius*.8),RoundId=state:GetAttribute('RoundId')}
     event:FireAllClients('Transit',model,transit.Entry.Frame,transit.Exit.Frame,packet)
    end
   end
  end
 end
 Levels.Step(fighters,logic,dt,enabled)
end
function M.EnforceBarriers()Levels.EnforceBarriers()end
return M
]====]},
{path=[====[ServerScriptService.CraxPlumberLevels]====],bytes=10306,hash=1055463276,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- PlumberFinale_v3
-- PlumberFix_v2
-- PlumberLevels_v1: all damage, pickups and movement are server-authoritative.
local SSS=game:GetService('ServerScriptService')
local RS=game:GetService('ReplicatedStorage')
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState')
local event=RS:WaitForChild('CraxPlumberLevelEvent')
local hit=SSS:WaitForChild('BiteHit')
local Spatial=require(SSS:WaitForChild('PlumberSpatialRules'))
local M={};local records={};local serial=0;local rng=Random.new()
local function now()return workspace:GetServerTimeNow()end
local function level(m)return m:GetAttribute('CraxSkillLevel')or 0 end
local function vec(p,z)return Vector3.new(p.X,p.Y,z)end
local function send(kind,payload)payload.RoundId=state:GetAttribute('RoundId');event:FireAllClients(kind,payload)end
-- CombatHealth emits this only after resolving protection and the real health loss.
SSS:WaitForChild('FantasticDamageConfirmed').Event:Connect(function(attacker,target,lost,kind,round)
 if kind~='PlumberPiranha' or type(lost)~='number' or lost<=0 or round~=state:GetAttribute('RoundId') then return end
 if not attacker or attacker:GetAttribute('CraxId')~='Crax_Plumber' or not target or not target.Parent then return end
 local h=target:FindFirstChild('Head',true)
 if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 if h then send('PlantBiteHit',{Owner=attacker,Target=target,Damage=lost,Position=h.Position,Radius=math.max(h.Size.X,h.Size.Y)*.5})end
end)
local function uid()serial=serial+1;return serial end
local function active(f)
 return f.model.Parent and f.model:GetAttribute('CraxId')=='Crax_Plumber'and(f.model:GetAttribute('Health')or 0)>0 and state:GetAttribute('Phase')=='Fighting'and not state:GetAttribute('DeadlyDemoActive')
end
local function available(f)
 return active(f)and not Gate.Paused(f.model)and not state:GetAttribute('GhostNightActive')and not f.capturedBy and not f.model:GetAttribute('FantasticPinned')
end
local function record(f)
 local r=records[f.model]
 if not r then r={clock=0,jets={},plants={},nextStar=10,owner=f};records[f.model]=r end
 return r
end
local function targetAllowed(owner,g)
 return g.model~=owner.model and g.model.Parent and(g.model:GetAttribute('Health')or 0)>0 and not Deadly.SameTeam(owner.model,g.model)
  and not g.model:GetAttribute('PlumberInTransit')and not g.model:GetAttribute('FantasticInvisible')and not g.model:GetAttribute('DeadlyPhantom')
end
local function damage(f,g,amount,kind)
 if targetAllowed(f,g)then hit:Fire(f.model,g.model,amount,false,kind)end
end
local function push(g,n)
 -- Use the same scripted knockback channel as ArenaMovement, never physics velocity.
 g.knockback={velocity=n*76,remaining=.18}
end
local function removeItem(item)
 send('Remove',{Id=item.id})
end
function M.Clear(model)
 local r=records[model];if not r then return end
 for _,j in ipairs(r.jets)do removeItem(j)end
 for _,p in pairs(r.plants)do removeItem(p)end
 if r.star then removeItem(r.star)end
 records[model]=nil
 if model.Parent then model:SetAttribute('PlumberStarUntil',nil)end
end
function M.Reset()
 local list={};for model in pairs(records)do list[#list+1]=model end
 for _,model in ipairs(list)do M.Clear(model)end
 send('Reset',{})
end
function M.Enter(f,transit)
 local r=records[f.model];if not r then return end
 for index,p in pairs(r.plants)do
  if p.pipe==transit.Entry or p.pipe==transit.Exit then removeItem(p);r.plants[index]=nil end
 end
end
function M.Exit(f,pipe,network)
 if level(f.model)<1 or #network.pipes<4 then return end
 local r=record(f);local p=pipe.Point;local n=pipe.Normal
 local length
 if n.X>0 then length=24-p.X elseif n.X<0 then length=p.X+24 elseif n.Y>0 then length=45-p.Y else length=p.Y-5 end
 local j={id=uid(),pipe=pipe,point=p,normal=n,length=math.max(.1,length),untilTime=r.clock+2,nextHit={},previous={}}
 for index,plant in pairs(r.plants)do if plant.pipe==pipe then removeItem(plant);r.plants[index]=nil end end
 r.jets[#r.jets+1]=j
 send('Jet',{Id=j.id,Owner=f.model,Start=vec(p,f.depth),Finish=vec(p+n*j.length,f.depth),Radius=f.radius*.43,StartedAt=now(),Duration=2})
end
local function busy(f,r,network,pipe)
 if network.transit and(network.transit.Entry==pipe or network.transit.Exit==pipe)then return true end
 if(f.position-pipe.Point).Magnitude<f.radius*1.65 then return true end
 for _,j in ipairs(r.jets)do if j.pipe==pipe and j.untilTime>r.clock then return true end end
 return r.plants[pipe.Index]~=nil
end
local function spawnPlant(f,r,network)
 if not InvertedSilence.CanStart(f.model)then return false end
 local free={};for _,pipe in ipairs(network.pipes)do if not busy(f,r,network,pipe)then free[#free+1]=pipe end end
 if #free==0 then return false end
 local pipe=free[rng:NextInteger(1,#free)]
 local p={id=uid(),pipe=pipe,start=r.clock,activeAt=r.clock+.35,untilTime=r.clock+3.7,bite=0}
 r.plants[pipe.Index]=p
 send('Plant',{Id=p.id,Owner=f.model,Frame=pipe.Frame,Radius=f.radius,StartedAt=now(),Duration=3.7})
 return true
end
local function spawnStar(f,r,network)
 if not InvertedSilence.CanStart(f.model)then return end
 if #network.pipes==0 or r.star or rng:NextNumber()>=.5 then return end
 local pipe=network.pipes[rng:NextInteger(1,#network.pipes)]
 local p=pipe.Point+pipe.Normal*(f.radius*.8)
 local a=rng:NextNumber(0,math.pi*2);local direction=Vector2.new(math.cos(a),math.sin(a))
 local star={id=uid(),position=Vector2.new(math.clamp(p.X,-23,23),math.clamp(p.Y,6,44)),velocity=direction*62,radius=math.max(.3,f.radius*.25),untilTime=r.clock+5,nextTurn=r.clock+.32,net=0}
 r.star=star
 send('Star',{Id=star.id,Owner=f.model,Position=vec(star.position,f.depth),Radius=star.radius,StartedAt=now(),Duration=5})
end
local function segmentDistance(p,a,b)
 local d=b-a;local dd=d:Dot(d);local t=dd>0 and math.clamp((p-a):Dot(d)/dd,0,1)or 0
 return(p-(a+d*t)).Magnitude
end
local function starStep(f,r,dt)
 local star=r.star;if not star then return end
 if r.clock>=star.untilTime then removeItem(star);r.star=nil;return end
 local old=star.position
 if r.clock>=star.nextTurn then
  local a=rng:NextNumber(-.62,.62);local v=star.velocity
  star.velocity=Vector2.new(v.X*math.cos(a)-v.Y*math.sin(a),v.X*math.sin(a)+v.Y*math.cos(a)).Unit*62
  star.nextTurn=r.clock+rng:NextNumber(.22,.58)
 end
 local p=star.position+star.velocity*dt;local v=star.velocity;local bounce=false
 local minX,maxX=-24+star.radius,24-star.radius;local minY,maxY=5+star.radius,45-star.radius
 if p.X<minX or p.X>maxX then p=Vector2.new(math.clamp(p.X,minX,maxX),p.Y);v=Vector2.new(-v.X,v.Y);bounce=true end
 if p.Y<minY or p.Y>maxY then p=Vector2.new(p.X,math.clamp(p.Y,minY,maxY));v=Vector2.new(v.X,-v.Y);bounce=true end
 star.position=p;star.velocity=v;star.net=star.net+dt
 if not f.model:GetAttribute('PlumberInTransit')and segmentDistance(f.position,old,p)<=f.radius+star.radius then
  f.model:SetAttribute('PlumberStarUntil',now()+7)
  send('Collect',{Id=star.id,Owner=f.model,Position=vec(p,f.depth),Until=now()+7});r.star=nil;return
 end
 if star.net>=.05 or bounce then
  star.net=0;send('StarMove',{Id=star.id,Position=vec(p,f.depth),Bounce=bounce})
 end
end
local currentTargets={}
function M.Step(fighters,logic,dt,enabled)
 local targets=Deadly.MotionTargets(fighters);currentTargets=targets
 for _,f in ipairs(fighters)do
  if not active(f)then M.Clear(f.model)
  else
   local r=record(f);local network=logic:Get(f.model)
   local can=enabled and available(f)
   if not can then
    -- End short effects cleanly when another cinematic suspends combat.
    for _,j in ipairs(r.jets)do removeItem(j)end;r.jets={}
    for _,p in pairs(r.plants)do removeItem(p)end;r.plants={}
    if r.star then removeItem(r.star);r.star=nil end
   else
    r.clock=r.clock+dt
    for i=#r.jets,1,-1 do
     local j=r.jets[i]
     if r.clock>=j.untilTime then removeItem(j);table.remove(r.jets,i)
     else
      for _,g in ipairs(targets)do
       j.previous[g.model]=g.position
      end
     end
    end
    if level(f.model)>=2 and #network.pipes>=6 then
     r.nextPlant=r.nextPlant or(r.clock+5)
     if r.clock>=r.nextPlant and spawnPlant(f,r,network)then r.nextPlant=r.clock+5 end
    end
    for index,p in pairs(r.plants)do
     local occupied=network.transit and(network.transit.Entry==p.pipe or network.transit.Exit==p.pipe)
     if occupied or r.clock>=p.untilTime then removeItem(p);r.plants[index]=nil
     else
      local elapsed=r.clock-p.activeAt
      -- Six closures at .5, 1, 1.5, 2, 2.5 and 3 seconds.
      local wanted=math.min(6,math.max(0,math.floor((elapsed+1e-7)/.5)))
      while p.bite<wanted do
       p.bite=p.bite+1
       send('PlantSnap',{Id=p.id,Index=p.bite,Position=p.pipe.Frame:PointToWorldSpace(Vector3.new(0,f.radius*2.15,0))})
       local mouth3=p.pipe.Frame:PointToWorldSpace(Vector3.new(0,f.radius*2.15,0))
       local mouth=Vector2.new(mouth3.X,mouth3.Y)
       for _,g in ipairs(targets)do
        if targetAllowed(f,g)and(g.position-mouth).Magnitude<=g.radius+f.radius*.7 then
         damage(f,g,10,'PlumberPiranha')
        end
       end
      end
     end
    end
    if level(f.model)>=3 and r.clock>=r.nextStar then
     r.nextStar=r.clock+10;spawnStar(f,r,network)
    end
    starStep(f,r,dt)
   end
  end
 end
end
function M.EnforceBarriers()
 if state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('GhostNightActive')then return end
 for _,r in pairs(records)do
  local f=r.owner
  if available(f)then
   for _,j in ipairs(r.jets)do
    if r.clock<j.untilTime then
     for _,g in ipairs(currentTargets)do
      if targetAllowed(f,g)and not g.capturedBy and not g.model:GetAttribute('FantasticPinned')and not Deadly.Hold(g.model)then
       local p,v,out=Spatial.WaterWall(g.position,j.previous[g.model]or g.position,g.velocity,j.point,j.normal,j.length,f.radius*.43,g.radius)
       if p then
        g.position=p;g.velocity=v
        if g.knockback then
         local into=g.knockback.velocity:Dot(out)
         if into<0 then g.knockback.velocity=g.knockback.velocity-out*(2*into)end
        end
        if r.clock>=(j.nextHit[g.model]or 0)then
         j.nextHit[g.model]=r.clock+.4;damage(f,g,5,'PlumberPressure')
         send('Contact',{Position=vec(p,g.depth or f.depth),Water=true})
        end
       end
       j.previous[g.model]=g.position
      end
     end
    end
   end
  end
 end
end
return M
]====]},
{path=[====[ServerScriptService.CraxGoldenRuntime]====],bytes=13105,hash=1066574375,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxCombinedFix_v7
-- GoldenUnified-3.0: authoritative combat. No client damage requests.
local SSS=game:GetService('ServerScriptService')
local Rules=require(SSS:WaitForChild('CraxGoldenRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState')
local hit=SSS:WaitForChild('BiteHit')
local M={Version='GoldenUnified-3.0'}
local owners,statuses={},{}
local round,serial=nil,0
local visual=Instance.new('Folder');visual.Name='GoldenCombatState';visual.Parent=workspace
local rng=Random.new()
local function golden(m)return m:GetAttribute('CraxId')=='Crax_Golden'or m:GetAttribute('AbilityId')=='GoldenMidas'end
M.IsGolden=golden
local function living(m)return m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function pos(f)return Vector3.new(f.position.X,f.position.Y,f.depth)end
local function level(m)return math.clamp(m:GetAttribute('CraxSkillLevel')or 0,0,4)end
local function canAct(m)return living(m)and not Gate.Paused(m)and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('PlumberInTransit')and not m:GetAttribute('VicePortalTransit')end
local function newFX(kind,owner,attrs)
 serial=serial+1
 local n=Instance.new('Folder');n.Name=kind..'_'..serial;n:SetAttribute('Kind',kind)
 for k,v in pairs(attrs or{})do n:SetAttribute(k,v)end
 n:SetAttribute('Age',0);n:SetAttribute('Paused',false);n:SetAttribute('RoundId',state:GetAttribute('RoundId'))
 local ref=Instance.new('ObjectValue');ref.Name='Owner';ref.Value=owner;ref.Parent=n
 n.Parent=visual;return n
end
local function publish(n,age,paused)
 n:SetAttribute('Paused',paused)
 if math.floor(age*20)~=n:GetAttribute('Frame')then n:SetAttribute('Frame',math.floor(age*20));n:SetAttribute('Age',age)end
end
local transients={}
local function impact(owner,where,size)
 local n=newFX('Impact',owner,{Center=where,Width=size or 2,Duration=.45})
 transients[#transients+1]={Node=n,Age=0}
end
local function release(m,s)
 Gate.Resume(m,'GoldenStatue')
 if m.Parent then m:SetAttribute('GoldenStatue',false);m:SetAttribute('GoldenGilding',0);m:SetAttribute('GoldenSlowMultiplier',1);m:SetAttribute('GoldenPoolContact',0);m:SetAttribute('GoldenWaterContact',0)end
 s.Anchor=nil
end
function M.Reset()
 for m,s in pairs(statuses)do release(m,s)end
 for m in pairs(owners)do if m.Parent then m:SetAttribute('GoldenCharging',false)end end
 owners={};statuses={};transients={};visual:ClearAllChildren()
end
local function record(m)local s=statuses[m];if not s then s=Rules.New();s.Publish=0;statuses[m]=s end;return s end
local function statue(m,s,f)
 if not s.Anchor then s.Anchor=f.position end
 m:SetAttribute('GoldenStatue',true);Gate.Pause(m,'GoldenStatue');impact(s.Owner,pos(f),f.radius*2)
end
local function addGold(owner,f,points)
 local s=record(f.model)
 if s.Statue>0 then return end
 s.Owner=owner
 if Rules.AddGold(s,points)then statue(f.model,s,f)end
 f.model:SetAttribute('GoldenGilding',s.Gold)
end
function M.Slow(m)return m:GetAttribute('GoldenSlowMultiplier')or 1 end
function M.Hold(m)return m:GetAttribute('GoldenStatue')==true or m:GetAttribute('GoldenCharging')==true end
function M.Outgoing(m,amount)
 local root=Deadly.Root(m)
 if m:GetAttribute('GoldenStatue')or(root and root:GetAttribute('GoldenStatue'))then return 0 end
 return amount
end
function M.Enforce(fighters)
 for _,f in ipairs(Deadly.MotionTargets(fighters))do local s=statuses[f.model];if s and s.Statue>0 and s.Anchor then f.position=s.Anchor end end
end
local function enemy(owner,f)return living(f.model)and not Deadly.SameTeam(owner,f.model)and not f.model:GetAttribute('PlumberInTransit')and not f.model:GetAttribute('VicePortalTransit')end
local function nearest(owner,motions)
 local best,distance
 for _,f in ipairs(motions)do if enemy(owner.model,f)then local d=(f.position-owner.position).Magnitude;if not distance or d<distance then best,distance=f,d end end end
 return best
end
local function damage(owner,f,amount,kind)
 if not enemy(owner,f)then return end
 hit:Fire(owner,f.model,amount,false,kind or 'GoldenHit')
end
local function spawnPool(owner,r,f)
 -- Fixed at the actual owner head center on this simulation frame. Width follows
 -- character size; rendering uses the same ellipse as the authoritative footprint.
 local width=math.clamp(f.radius*3,6,9)*1.3
 local rx,ry=width*.5,width*.4
 local xy=Vector2.new(math.clamp(f.position.X,-24+rx+.12,24-rx-.12),math.clamp(f.position.Y,5+ry+.12,45-ry-.12))
 local center=Vector3.new(xy.X,xy.Y,f.depth)
 local node=newFX('Pool',owner,{Center=center,Width=width,Duration=9})
 r.Pools[#r.Pools+1]={Center=xy,Radius=width*.5,Age=0,Visual=node}
end
local function segmentDistance(p,a,b)
 local d=b-a;local length=d:Dot(d)
 if length<1e-8 then return(p-a).Magnitude end
 local t=math.clamp((p-a):Dot(d)/length,0,1)
 return(p-(a+d*t)).Magnitude
end
local function stepUpgrades(f,r,dt,motions,enabled)
 local lv=level(f.model)
 if lv<1 and r.Charge then r.Charge.Node:Destroy();r.Charge=nil;f.model:SetAttribute('GoldenCharging',false)end
 if enabled and lv>=1 then
  if InvertedSilence.CanStart(f.model)and not r.Charge and r.Time>=r.NextPunch then
   local target=nearest(f,motions)
   if target then
    r.Charge={Age=0,Node=newFX('Charge',f.model,{Center=pos(f),Width=f.radius*2,Duration=1})}
    f.model:SetAttribute('GoldenCharging',true)
   end
  end
  if r.Charge then
   local c=r.Charge;c.Age=c.Age+dt;c.Node:SetAttribute('Center',pos(f));publish(c.Node,c.Age,false)
   if c.Age>=1 then
    c.Node:Destroy();r.Charge=nil;f.model:SetAttribute('GoldenCharging',false);r.NextPunch=r.Time+8
    local target=nearest(f,motions)
    if target then
     local delta=target.position-f.position
     local dir=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
     local start=f.position+dir*(f.radius*.6)
     local width=f.radius*.8
     local node=newFX('Punch',f.model,{Center=Vector3.new(start.X,start.Y,f.depth),Direction=Vector3.new(dir.X,dir.Y,0),Width=width,Speed=48,Duration=1.65})
     r.Shots[#r.Shots+1]={Position=start,Direction=dir,Age=0,Node=node,Radius=width*.5,Hit={}}
     f.knockback={velocity=-dir*26,remaining=.18}
    end
   end
  end
 end
 if r.Charge then publish(r.Charge.Node,r.Charge.Age,not enabled)end
 for i=#r.Shots,1,-1 do
  local shot=r.Shots[i]
  if enabled then
   local before=shot.Position;shot.Position=before+shot.Direction*(48*dt);shot.Age=shot.Age+dt
   for _,target in ipairs(motions)do
    if enemy(f.model,target)and not shot.Hit[target.model]and segmentDistance(target.position,before,shot.Position)<=shot.Radius+(target.radius or 0)then
     shot.Hit[target.model]=true;damage(f.model,target,25,'GoldenPunch');addGold(f.model,target,30);impact(f.model,pos(target),target.radius*1.5)
     shot.Age=2;break
    end
   end
  end
  if shot.Age>=1.65 then shot.Node:Destroy();table.remove(r.Shots,i)else publish(shot.Node,shot.Age,not enabled)end
 end
 if InvertedSilence.CanStart(f.model)and enabled and lv>=2 and r.Time>=r.NextIngot and #r.Ingots<3 then
  r.Ingots[#r.Ingots+1]={Node=newFX('Ingot',f.model,{Center=pos(f),Width=f.radius*.9,Duration=100000}),Phase=rng:NextNumber(0,math.pi*2)}
  r.NextIngot=r.Time+10
 end
 for i=#r.Ingots,1,-1 do
  local ingot=r.Ingots[i]
  local angle=r.Time*1.45+ingot.Phase
  local p=f.position+Vector2.new(math.cos(angle),math.sin(angle))*(f.radius*1.8)
  ingot.Node:SetAttribute('Center',Vector3.new(p.X,p.Y,f.depth));publish(ingot.Node,r.Time,not enabled)
  local consumed=lv<2
  if enabled and not consumed then
   for _,target in ipairs(motions)do if enemy(f.model,target)and(target.position-p).Magnitude<=(target.radius or 0)+f.radius*.4 then
    damage(f.model,target,10,'GoldenIngot');impact(f.model,pos(target),target.radius)
    if not target.model:GetAttribute('GoldenStatue')then
     local d=target.position-f.position;d=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
     target.knockback={velocity=d*48,remaining=.25};target.velocity=d*math.max(target.speed or 25,30)
    end
    consumed=true;break
   end end
  end
  if consumed then ingot.Node:Destroy();table.remove(r.Ingots,i)end
 end
 local cascadeAllowed=lv>=3 and(f.model:GetAttribute('Health')or math.huge)<=60
 if not cascadeAllowed and r.Cascade then r.Cascade.Node:Destroy();r.Cascade=nil end
 if InvertedSilence.CanStart(f.model)and cascadeAllowed and enabled and not r.Cascade then
  local x=rng:NextNumber(-19,19)
  r.Cascade={Age=0,Hit={},Node=newFX('Cascade',f.model,{Top=Vector3.new(x,45,f.depth),Bottom=Vector3.new(x,5,f.depth),Width=2.2,Duration=10}),X=x}
 end
 if r.Cascade then
  local c=r.Cascade;if enabled then c.Age=c.Age+dt end
  publish(c.Node,c.Age,not enabled)
  if c.Age>=.9 and enabled then
   for _,target in ipairs(motions)do
    if enemy(f.model,target)and math.abs(target.position.X-c.X)<=2.31+(target.radius or 0)then
     local clock=c.Hit[target.model]
     if not clock then
      clock={Damage=0,Gold=0}
      target.model:SetAttribute('GoldenWaterContact',(target.model:GetAttribute('GoldenWaterContact')or 0)+1)
     end
     c.Hit[target.model]=clock
     clock.Damage=clock.Damage+dt;clock.Gold=clock.Gold+dt
     if clock.Damage>=.2 then local ticks=math.floor((clock.Damage+1e-8)/.2);clock.Damage=clock.Damage-ticks*.2;damage(f.model,target,ticks,'GoldenCascade')end
     if clock.Gold>=.5 then local ticks=math.floor((clock.Gold+1e-8)/.5);clock.Gold=clock.Gold-ticks*.5;addGold(f.model,target,ticks)end
    else c.Hit[target.model]=nil end
   end
  end
  if c.Age>=10 then c.Node:Destroy();r.Cascade=nil end
 end
end
function M.Step(dt,fighters,active)
 local current=state:GetAttribute('RoundId');if current~=round then M.Reset();round=current end
 if state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('DeadlyDemoActive')then if next(owners)or next(statuses)then M.Reset()end;return end
 if not active then
  for _,node in ipairs(visual:GetChildren())do node:SetAttribute('Paused',true)end
  return
 end
 for i=#transients,1,-1 do local t=transients[i];t.Age=t.Age+dt;if t.Age>=.45 then t.Node:Destroy();table.remove(transients,i)else publish(t.Node,t.Age,false)end end
 local motions=Deadly.MotionTargets(fighters);local byModel={}
 for _,f in ipairs(motions)do byModel[f.model]=f end
 for m,r in pairs(owners)do
  if not byModel[m]or not golden(m)or not living(m)then
   m:SetAttribute('GoldenCharging',false)
   for _,node in ipairs(visual:GetChildren())do local ref=node:FindFirstChild('Owner');if ref and ref.Value==m then node:Destroy()end end
   owners[m]=nil
  end
 end
 for _,f in ipairs(fighters)do
  if golden(f.model)and living(f.model)then
   local r=owners[f.model]
   if not r then r={Time=0,Next=4,NextPunch=8,NextIngot=10,Pools={},Shots={},Ingots={}};owners[f.model]=r end
   local enabled=canAct(f.model);if enabled then r.Time=r.Time+dt end
   for i=#r.Pools,1,-1 do local p=r.Pools[i]
    if enabled then p.Age=p.Age+dt end
    publish(p.Visual,p.Age,not enabled)
    if p.Age>=9 then p.Visual:Destroy();table.remove(r.Pools,i)end
   end
   if InvertedSilence.CanStart(f.model)and enabled and r.Time>=r.Next and #r.Pools<2 then spawnPool(f.model,r,f);r.Next=r.Time+4 end
   stepUpgrades(f,r,dt,motions,enabled)
  end
 end
 local present={}
 for _,f in ipairs(motions)do
  local target=f.model;present[target]=true
  if living(target)then
   local s=statuses[target];local inside=false
   if not target:GetAttribute('PlumberInTransit')and not target:GetAttribute('VicePortalTransit')then
    for owner,r in pairs(owners)do
     if canAct(owner)and not Deadly.SameTeam(owner,target)then
      for _,p in ipairs(r.Pools)do
       local d=f.position-p.Center
       -- Ellipse matches authored 5 x 4 mesh. Include the target's own radius.
       local rx=p.Radius+(f.radius or 0);local ry=p.Radius*.8+(f.radius or 0)
       if(d.X/rx)^2+(d.Y/ry)^2<=1 then inside=true;s=s or record(target);if s.Statue<=0 then s.Owner=owner end;break end
      end
     end
     if inside then break end
    end
   end
   if s then
    if inside and not s.InPool then target:SetAttribute('GoldenPoolContact',(target:GetAttribute('GoldenPoolContact')or 0)+1)end
    s.InPool=inside
    local was=s.Statue>0
    if not Gate.PausedExcept(target,'GoldenStatue')then
     local e=Rules.Step(s,dt,inside)
     if e.StatueStarted then statue(target,s,f)end
     if e.Damage>0 and s.Owner and living(s.Owner)then hit:Fire(s.Owner,target,e.Damage,false,'GoldenStatue')end
     if e.StatueEnded then s.Anchor=nil;Gate.Resume(target,'GoldenStatue');target:SetAttribute('GoldenStatue',false);impact(s.Owner,pos(f),f.radius*2)end
    end
    target:SetAttribute('GoldenSlowMultiplier',Rules.SpeedMultiplier(s))
    s.Publish=s.Publish+dt
    if s.Publish>=.05 or was~=(s.Statue>0)then s.Publish=0;target:SetAttribute('GoldenGilding',s.Gold)end
   end
  end
 end
 for m,s in pairs(statuses)do if not present[m]or not living(m)then release(m,s);statuses[m]=nil end end
 M.Enforce(fighters)
end
-- Cleanup must not depend on ArenaMovement still advancing after the round.
state:GetAttributeChangedSignal('Phase'):Connect(function()
 if state:GetAttribute('Phase')~='Fighting'then M.Reset()end
end)
state:GetAttributeChangedSignal('RoundId'):Connect(function()M.Reset();round=state:GetAttribute('RoundId')end)
return M
]====]},
{path=[====[ReplicatedStorage.CraxFleau.FleauRules]====],bytes=3268,hash=3386548031,source=[====[-- CraxCombinedFix_v7
-- Pure deterministic rules. No Roblox services; tested independently.
local R={}
R.Config={Health=145,Speed=30,Contact=8,RagePerHP=(2/1.2),MaxRage=100,
 RageHit=15,Thresholds={30,60},Windup=2,ChargeDamage=20,Stun=2.5,
 WindupMultiplier=.2,RollInterval=10,RollChance=.5,GiantDuration=10,
 GiantHP=300,GiantContact=10,GiantFlatReduction=50,GiantScale=1.55,
 RageLock=3,FuryDuration=5,FuryDamage=30,ChargeSpeed=80,FurySpeed=105,
 FinaleDuration=12,ReductionOrder='FLAT_THEN_PERCENT',
 FuryHealing='REJECT',FuryControls='IGNORE',Prices={5000,15000,30000,50000},Gems={30,80,150,250}}
local C=R.Config
function R.New(level)
 return {level=level or 0,rage=0,used={},queue={},mode='Normal',time=0,
  rollAt=C.RollInterval,giantUsed=false,furyUsed=false,lock=0,pass=0,hits={}}
end
function R.ResetCycle(s) s.rage=0;s.used={};s.queue={} end
function R.Loss(s,hp)
 assert(type(hp)=='number'and hp>=0 and hp<math.huge,'invalid loss')
 if s.mode=='Fury'or s.lock>0 or hp==0 then return end
 local old=s.rage;s.rage=math.min(C.MaxRage,old+hp*C.RagePerHP)
 if s.level>=1 then for _,threshold in ipairs(C.Thresholds)do
  if old<threshold and s.rage>=threshold and not s.used[threshold]then
   s.used[threshold]=true;s.queue[#s.queue+1]=threshold
  end
 end end
end
function R.Protect(s,amount)
 assert(type(amount)=='number'and amount>=0 and amount<math.huge,'invalid damage')
 if s.mode=='Fury'then return 0 end
 if s.giant then amount=amount*.5 end
 if s.mode=='Windup'then amount=amount*C.WindupMultiplier end
 return amount
end
function R.Contact(s)
 if s.mode=='Fury'or s.mode=='Charge'or s.mode=='Windup'then return 0,'Controlled'end
 if s.rage>=100 then return C.RageHit,'Rage'end
 return s.giant and C.GiantContact or C.Contact,'Normal'
end
function R.Consume(s,kind) if kind=='Rage'then R.ResetCycle(s)end end
function R.Lethal(s)
 if s.level<3 or s.furyUsed then return false end
 s.furyUsed=true;s.mode='Fury';s.time=0;s.rage=300;s.queue={};s.giant=false;s.savedHP=nil;s.pass=s.pass+1;s.hits={}
 return true
end
function R.Giant(s,hp,max)
 if s.giantUsed or s.mode=='Fury'then return false end
 s.giantUsed=true;s.giant=true;s.giantAge=0;s.savedHP=hp;s.savedMax=max
 return true
end
function R.Pass(s) s.pass=s.pass+1;s.hits={} end
function R.Hit(s,id) if s.hits[id]then return false end;s.hits[id]=true;return true end
function R.Tick(s,dt,roll,canStart)
 canStart=canStart~=false
 assert(dt>=0 and dt<math.huge,'invalid dt')
 local e={};s.lock=math.max(0,s.lock-dt)
 if s.mode=='Fury'then
  s.time=s.time+dt;s.rage=300*math.min(1,math.max(0,C.FuryDuration-s.time))
  if s.time>=C.FuryDuration then e.exhaust=true end
  return e
 end
 s.elapsed=(s.elapsed or 0)+dt
 if canStart and s.level>=2 and not s.giantUsed then
  while s.elapsed>=s.rollAt do s.rollAt=s.rollAt+C.RollInterval
   if roll()<C.RollChance then e.giant=true;break end
  end
 end
 if s.giant then
  s.giantAge=s.giantAge+dt
  if s.giantAge>=C.GiantDuration then
   e.restore={s.savedHP,s.savedMax};s.giant=false;s.savedHP=nil;R.ResetCycle(s);s.lock=C.RageLock
  end
 end
 if canStart and s.mode=='Normal'and #s.queue>0 then
  table.remove(s.queue,1);s.mode='Windup';s.time=0;e.windup=true
 elseif s.mode=='Windup'then
  s.time=s.time+dt;if s.time>=C.Windup then s.mode='Charge';s.time=0;R.Pass(s);e.charge=true end
 end
 return e
end
return R
]====]},
{path=[====[ServerScriptService.FleauRuntime]====],bytes=10344,hash=3062763416,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- FleauChargeSolidImpact_v6
-- FleauCombatCorrection_v3
local SSS=game:GetService('ServerScriptService');local RS=game:GetService('ReplicatedStorage')
local Rules=require(RS.CraxFleau.FleauRules);local C=Rules.Config
local Gate=require(SSS.CraxAbilityGate);local Control=require(SSS.FleauControl)
local Deadly=require(SSS.CraxDeadlyRuntime);local Resolver=require(SSS.CraxSkillResolver)
local state=workspace:WaitForChild('CombatState');local hit=SSS:WaitForChild('BiteHit')
local FX=RS.CraxFleau.FX;local M={Health=nil};local records={};local motions={};local random=Random.new();local round
local function is(m)return m and m:GetAttribute('CraxId')=='Crax_Fleau'end
M.Is=is
local function fx(kind,m,extra)FX:FireAllClients(kind,m,extra or {},state:GetAttribute('RoundId'))end
local function publish(m,s)
 local stamp=math.floor(s.rage*10)/10
 if m:GetAttribute('FleauRage')~=stamp then m:SetAttribute('FleauRage',stamp)end
 m:SetAttribute('FleauMode',s.mode);m:SetAttribute('FleauGiant',s.giant==true)
 m:SetAttribute('FleauFury',s.mode=='Fury')
end
local function rec(m)
 if not is(m)then return end
 local s=records[m];if not s then
  local lv=Resolver.Resolve(m);s=Rules.New(lv);s.baseScale=m:GetScale();records[m]=s;publish(m,s)
 end;return s
end
function M.FlatProtect(m,amount)local s=rec(m);return s and Rules.Protect(s,amount)or amount end
function M.Hold(m)local s=records[m];return m:GetAttribute('FleauStunned')or(s and s.mode~='Normal')or false end
function M.Contact(m,base)
 local s=rec(m);if not s then return base,nil end
 if workspace:GetServerTimeNow()<(s.contactSuppressedUntil or 0)then return 0,'Controlled'end
 local amount,mode=Rules.Contact(s);return amount,mode
end
function M.CommitContact(m,target,mode)
 local s=records[m];if not s then return end
 if mode=='Rage'then
  Rules.Consume(s,mode);publish(m,s)
  local a,b=motions[m],motions[target]
  if a and b then local d=b.position-a.position;d=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
   b.knockback={velocity=d*95,remaining=.45}
  end
  fx('RageHit',m,{Target=target})
 end
end
function M.AfterDamage(m,lost)local s=rec(m);if s then Rules.Loss(s,lost);publish(m,s)end end
function M.HealAllowed(m)return not m:GetAttribute('FleauFury')end
function M.BeforeDeath(m,health)
 local s=rec(m);if not s then return false end
 if s.mode=='Fury'then return true end
 if not InvertedSilence.CanStart(m)or not Rules.Lethal(s)then return false end
 health.health=1;health.maxHealth=C.Health;s.savedHP=nil;s.savedMax=nil
 m:SetAttribute('FleauFury',true);m:SetAttribute('FleauGiant',false)
 Control.Clear(m);s.furyEnds=workspace:GetServerTimeNow()+C.FuryDuration;s.furyLast=workspace:GetServerTimeNow()
 s.normalVelocity=motions[m]and motions[m].velocity
 m:SetAttribute('FleauFuryEndsAt',s.furyEnds)
 -- Fury does not resume unrelated locks: movement explicitly bypasses them, timers remain owned.
 fx('Fury',m);publish(m,s);return true
end
local function restore(m,s)
 if m.Parent then
  m:ScaleTo(s.baseScale or 1)
  for _,key in ipairs({'FleauRage','FleauMode','FleauGiant','FleauFury','FleauFuryEndsAt'})do m:SetAttribute(key,nil)end
 end
end
function M.Reset()
 for m,s in pairs(records)do restore(m,s)end
 records={};motions={};M.ChargePushes={};Control.Reset()
end
local function clamp(f)
 local r=f.radius;f.position=Vector2.new(math.clamp(f.position.X,-24+r,24-r),math.clamp(f.position.Y,5+r,45-r))
end
local function wall(s,f)
 local r=f.radius;local side=random:NextInteger(1,4)
 if side==s.lastSide then side=side%4+1 end;s.lastSide=side
 if side==1 then return Vector2.new(-24+r,random:NextNumber(5+r,45-r))end
 if side==2 then return Vector2.new(24-r,random:NextNumber(5+r,45-r))end
 if side==3 then return Vector2.new(random:NextNumber(-24+r,24-r),5+r)end
 return Vector2.new(random:NextNumber(-24+r,24-r),45-r)
end
local function distance(p,a,b)
 local d=b-a;local q=d:Dot(d);local t=q>1e-8 and math.clamp((p-a):Dot(d)/q,0,1)or 0
 return(p-(a+d*t)).Magnitude
end
local function enemy(m,t)return t.model~=m and t.model.Parent and(t.model:GetAttribute('Health')or 0)>0 and not Deadly.SameTeam(m,t.model)end
function M.Step(dt,fighters,enabled)
 if round~=state:GetAttribute('RoundId')then M.Reset();round=state:GetAttribute('RoundId')end
 Control.Step()
 local targets=Deadly.MotionTargets(fighters);motions={}
 for _,f in ipairs(targets)do motions[f.model]=f end
 if state:GetAttribute('Phase')~='Fighting'then return end
 M.ChargePushes=M.ChargePushes or {}
 for target,push in pairs(M.ChargePushes)do
  local motion=motions[target]
  if not motion or not target.Parent
   or(target:GetAttribute('Health')or 0)<=0
   or target:GetAttribute('GoldenStatue')
   or target:GetAttribute('FleauFury')
   or motion.capturedBy~=nil then
   M.ChargePushes[target]=nil
  else
   local step=math.min(dt,math.max(0,push.remaining))
   local decay=math.exp(-7*step)
   motion.position=motion.position+push.velocity*((1-decay)/7)
   push.velocity=push.velocity*decay
   push.remaining=push.remaining-step
   motion.knockback=nil
   clamp(motion)
   if push.remaining<=0 then M.ChargePushes[target]=nil end
  end
 end
 for _,f in ipairs(fighters)do
  local m=f.model;local s=rec(m)
  if s and(m:GetAttribute('Health')or 0)>0 then
   local fury=s.mode=='Fury'
   local paused=not fury and(Gate.Paused(m)or m:GetAttribute('GoldenStatue')or m:GetAttribute('FantasticGrabbed')or f.capturedBy~=nil)
   if not paused and(enabled or fury)then
    if not s.normalVelocity then s.normalVelocity=f.velocity end
    local tick=dt
    if fury then local now=workspace:GetServerTimeNow();tick=math.max(0,now-s.furyLast);s.furyLast=now end
    local e=Rules.Tick(s,tick,function()return random:NextNumber()end,InvertedSilence.CanStart(m))
    if e.giant and M.Health and Rules.Giant(s,m:GetAttribute('Health'),m:GetAttribute('MaxHealth'))then
     M.Health.Set(m,300,300);fx('Giant',m)
    end
    if e.restore and M.Health then M.Health.Set(m,e.restore[1],e.restore[2]);fx('Recover',m)end
    local scale=s.baseScale*(s.giant and C.GiantScale or 1)
    local smooth=m:GetScale()+(scale-m:GetScale())*(1-math.exp(-dt*8));m:ScaleTo(smooth)
    f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2;clamp(f)
    if e.windup then s.anchor=f.position;fx('Windup',m)end
    if e.charge then
     s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2
     local near,best
     for _,t in ipairs(targets)do if enemy(m,t)then local d=(f.position-t.position).Magnitude;if not best or d<best then near=t;best=d end end end
     if near then s.destination=near.position else s.destination=wall(s,f)end
     local d=s.destination-f.position;s.direction=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
     s.chargeContact=nil;s.travel=0;fx('Charge',m)
    end
    if s.mode=='Windup'then f.position=s.anchor;f.knockback=nil
    elseif s.mode=='Charge'or s.mode=='Fury'then
     if not s.destination then
      local destination=wall(s,f)
      for attempt=1,8 do
       if(destination-f.position).Magnitude>=8 then break end
       destination=wall(s,f)
      end
      if(destination-f.position).Magnitude<8 then
       local radius=f.radius
       destination=Vector2.new(
        f.position.X>=0 and -24+radius or 24-radius,
        math.clamp(50-f.position.Y,5+radius,45-radius))
      end
      s.destination=destination;Rules.Pass(s)
     end
     local d=s.destination-f.position;local speed=s.mode=='Fury'and C.FurySpeed or C.ChargeSpeed
     local from=f.position;local step=math.min(d.Magnitude,speed*dt)
     local dir=s.mode=='Charge'and s.direction or(d.Magnitude>.001 and d.Unit or Vector2.new(1,0))
     f.position=from+dir*step;f.velocity=dir*speed;clamp(f);f.knockback=nil
     for _,t in ipairs(targets)do
      if enemy(m,t)and distance(t.position,from,f.position)<f.radius+t.radius and Rules.Hit(s,t.model)then
       s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2
       hit:Fire(m,t.model,s.mode=='Fury'and C.FuryDamage or C.ChargeDamage,false,s.mode=='Fury'and 'FleauFury'or 'FleauCharge')
       if state:GetAttribute('Phase')~='Fighting'then return end
       if s.mode=='Charge'then
        -- Arrêt au bord de la cible : aucun passage au travers.
        local impactDirection=dir
        f.position=t.position-impactDirection*(f.radius+t.radius+.08)
        clamp(f)
        s.chargeContact=impactDirection
        local stunned=Control.Apply(t.model,m.Name,C.Stun)
        if stunned and not t.model:GetAttribute('GoldenStatue')
         and t.capturedBy==nil then
         M.ChargePushes=M.ChargePushes or {}
         M.ChargePushes[t.model]={velocity=dir*65,remaining=.4}
         t.position=t.position+dir*.35
         clamp(t)
        end
       end
       fx('Impact',m,{Target=t.model})
       if s.chargeContact then break end
      end
     end
     if s.chargeContact then
      local impactDirection=s.chargeContact
      s.chargeContact=nil
      s.mode='Normal'
      s.destination=nil
      s.direction=nil
      s.travel=0
      s.contactSuppressedUntil=workspace:GetServerTimeNow()+.45
      -- Fléau rebondit légèrement après le choc.
      f.velocity=-impactDirection*C.Speed
      f.knockback={velocity=-impactDirection*18,remaining=.12}
      publish(m,s)
      return
     end
     s.travel=(s.travel or 0)+step
     if(s.destination-f.position).Magnitude<.1 or step<.001 or(s.mode=='Charge'and s.travel>60)then
      if s.mode=='Fury'then s.destination=nil;s.travel=0
      else s.mode='Normal';s.destination=nil;s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2;f.velocity=dir*C.Speed end
     end
    else
     if f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*C.Speed end
    end
    if e.exhaust and not s.exhausted then
     s.exhausted=true
     -- Health callback closes the round without a fake self-attack or bypassable protection.
     if M.Health then M.Health.Exhaust(m)end
     return
    end
    if state:GetAttribute('Phase')~='Fighting'then M.Reset();return end
    if s.mode=='Fury'then s.enforced=f.position end
    publish(m,s)
   end
  elseif records[m]then restore(m,records[m]);records[m]=nil end
 end
end
function M.Enforce(fighters)
 for _,f in ipairs(fighters)do local s=records[f.model]
  if s and s.mode=='Fury'and s.enforced then f.position=s.enforced;f.knockback=nil;f.capturedBy=nil end
 end
end
state:GetAttributeChangedSignal('Phase'):Connect(function()
 local p=state:GetAttribute('Phase');if p~='Fighting'then M.Reset()end
end)
return M
]====]},
{path=[====[ServerScriptService.CraxDeadlyRuntime]====],bytes=78341,hash=457837360,source=[====[local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GoldenCombatBase_v1
-- VOID_PULSAR_PIERCING_v2
-- PARKER_VICE_RULES_v1
-- STACK_OBSIDIAN_SERVER_v1
-- VICE_WELL_RELEASE_v1
-- VICE_ENERGY_SERVER_v2
-- VICE_ROSE_PORTALS_v1
-- DODGER_CRYSTAL_PERSISTENT_v2
-- DODGER_CRYSTAL_DEMO_v1
-- PARKER_WALL20_DAMAGE12_v7
-- PARKER_ROYAL_MOTION_v2
-- PARKER_INFERNO_v1
-- DOMINO_VERDICT_v1
-- Serveur autoritaire : familles, assimilations, fusion et dégâts.
local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local V=require(RS:WaitForChild('CraxDeadlyVisuals'));local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local M={families={},nodes={},fighters={},aimSpawns={},cinematics={},viceTransits={},Health=nil};local state=workspace:WaitForChild('CombatState')
local FX=RS:WaitForChild('CraxDeadlyFX');local random=Random.new()
local stunSources=setmetatable({},{__mode='k'})
local function stun(target,owner,on)
 if on and target:GetAttribute('FleauFury')then return end
 if on and M.SameTeam(owner,target)then return end
 local sources=stunSources[target]or {};stunSources[target]=sources
 local reason='DeadlyDomino'..owner.Name
 if on then sources[owner]=true;Gate.Pause(target,reason)else sources[owner]=nil;Gate.Resume(target,reason)end
 if target.Parent then target:SetAttribute('DeadlyStunned',next(sources)~=nil)end
end
local function releaseContacts(n)
 if n.name~='Domino'then return end
 for target in pairs(n.stunTargets or{})do stun(target,n.model,false)end
 n.stunTargets={};n.contacts={}
end
local folder=Instance.new('Folder');folder.Name='DeadlyAllies';folder.Parent=workspace
local stats={OG={90,25,5},Domino={25,25,5},Parker={50,25,15},Dodger={15,12,1},Vice={25,25,0},Stack={100,25,3},Void={math.huge,17,12}}
local function now()return workspace:GetServerTimeNow()end
local function alive(n)return n and not n.dead and not n.spawning and not n.eatenPending and n.model.Parent and(n.model:GetAttribute('Health')or 0)>0 end
local function xy(p)return Vector2.new(p.X,p.Y)end
local function node(model)return M.nodes[model]end
function M.Root(model)local n=node(model);return n and n.family.og.model or model end
function M.SameTeam(a,b)return a~=nil and b~=nil and M.Root(a)==M.Root(b)end
function M.IsAlly(model)local n=node(model);return n and n.name~='OG' end
function M.Hold(model)if model:GetAttribute('FleauFury')then return false end;if model:GetAttribute('FleauStunned')then return true end;if model:GetAttribute('GoldenStatue')then return true end;if model:GetAttribute('VicePortalTransit')then return true end;if state:GetAttribute('GhostNightActive')then return model:GetAttribute('DeadlySpawning')==true end;local n=node(model);return model:GetAttribute('DeadlyTransitioning')==true or model:GetAttribute('DeadlySpawning')==true or model:GetAttribute('DeadlyStunned')==true or(n and n.family.stage and n.family.stage~='Form')or false end
function M.CinematicScale()
 if state:GetAttribute('Phase')~='Fighting'then return 1 end
 for model,entry in pairs(M.cinematics)do if model.Parent and now()<entry.finish then return .22 else M.cinematics[model]=nil end end
 return 1
end
function M.Slow(model)return(model:GetAttribute('GoldenSlowMultiplier')or 1)*(now()<(model:GetAttribute('DeadlySlowUntil')or 0)and .6 or 1)end
function M.Flash()return(state:GetAttribute('DeadlyFlashCount')or 0)>0 end
local function effect(kind,data)data=data or {};data.RoundId=state:GetAttribute('RoundId');FX:FireAllClients(kind,data)end
local function setHp(n,hp,max)if M.Health then M.Health.Set(n.model,hp,max)end end
local function headpos(n)return V.Head(n.model).Position end
local function position(n)return n.motion and n.motion.position or xy(headpos(n))end
local function put(n,p)
 if n.motion then n.motion.position=p else n.p=p end
 n.model:PivotTo(CFrame.new(p.X,p.Y,n.depth)*n.rotation)
end
local function radius(n)return math.max(V.Head(n.model).Size.X,V.Head(n.model).Size.Y)/2 end
local function clearAura(n,name)local a=V.Head(n.model):FindFirstChild(name);if a then a:Destroy()end end
local function aura(n,color,name)clearAura(n,name or'DeadlyAura');return V.Aura(n.model,color,name)end
local function size(n,scale)
 n.model:ScaleTo(n.baseScale*scale)
 if n.motion then n.motion.radius=radius(n)end
 local p=position(n);put(n,Vector2.new(math.clamp(p.X,-24+radius(n),24-radius(n)),math.clamp(p.Y,5+radius(n),45-radius(n))))
end
-- STACK_OBSIDIAN_RULES_v1 — authoritative sizes, damage snapshots and independent growth cycles.
local STACK_SIZES={.5,.75,1,1.4,1.9,2.5,3,3.5}
local STACK_DAMAGE={5,7,12,19,26,35,40,55}
local STACK_SPEED={1,1,.90,.80,.68,.56,.45,.35}
local function stackSample(age)
 local stage=math.min(8,math.floor(math.max(0,age)/1.5)+1)
 local alpha=stage==8 and 0 or math.clamp((age-(stage-1)*1.5)/1.5,0,1)
 local smooth=alpha*alpha*(3-2*alpha);local nextStage=math.min(8,stage+1)
 return stage,STACK_SIZES[stage]+(STACK_SIZES[nextStage]-STACK_SIZES[stage])*smooth,
  STACK_SPEED[stage]+(STACK_SPEED[nextStage]-STACK_SPEED[stage])*smooth
end
local function stackUpdate(n,force)
 local stage,scale,speed=stackSample(n.t-(n.stackCycleStart or n.t))
 n.growth=stage-1
 n.model:SetAttribute('CollisionDamage',STACK_DAMAGE[stage])
 n.model:SetAttribute('Speed',stats.Void[2]*speed)
 if force or n.t>=(n.stackScaleAt or 0)then
  n.stackScaleAt=n.t+1/30;size(n,scale)
  n.model:SetAttribute('StackStage',stage);n.model:SetAttribute('StackScale',scale)
  n.model:SetAttribute('StackRemaining',math.max(0,(n.assimEnd or n.t)-n.t))
 end
 if stage~=(n.stackLastStage or 1)then
  n.stackLastStage=stage;effect('StackGrowth',{Model=n.model,Member='Stack',Stage=stage,Scale=STACK_SIZES[stage],Damage=STACK_DAMAGE[stage]})
 end
end
local function stackBegin(n)
 n.stackCycleStart=n.t+1.25;n.stackLastStage=1;n.stackCycles=0;n.stackScaleAt=0
 n.model:SetAttribute('StackCycles',0);stackUpdate(n,true)
end
local function stackContact(n,target,amount)
 if n.assim~='Stack'then return end
 local cf=n.model:GetPivot();local width=V.Head(n.model).Size.X;local stage=(n.growth or 0)+1
 n.stackCycleStart=n.t;n.stackLastStage=1;n.stackCycles=(n.stackCycles or 0)+1
 n.model:SetAttribute('StackCycles',n.stackCycles);stackUpdate(n,true)
 effect('StackImpact',{Model=n.model,Target=target,Member='Stack',Stage=stage,Damage=amount,Position=cf.Position,Width=width})
end
local function stackClear(n)
 n.stackCycleStart=nil;n.stackScaleAt=nil;n.stackLastStage=nil
 for _,key in ipairs({'StackStage','StackScale','StackRemaining','StackCycles'})do n.model:SetAttribute(key,nil)end
end

local function level(f)return f.og.model:GetAttribute('CraxSkillLevel')or 0 end
local function living(f)local out={};for _,n in ipairs(f.members)do if alive(n)then out[#out+1]=n end end;return out end
local function damage(a,b,amount,kind)
 if not alive(a)or not b or M.SameTeam(a.model,b)then return end
 SSS.BiteHit:Fire(a.model,b,amount,false,kind or'DeadlyPower')
end
local function enemyModels(f)
 local out={};if not M.SameTeam(f.og.model,f.enemy.model)and f.enemy.model.Parent and(f.enemy.model:GetAttribute('Health')or 0)>0 then out[1]=f.enemy.model end;local other=M.families[f.enemy.model]
 if other then for _,n in ipairs(other.members)do if n.name~='OG'and alive(n)and not M.SameTeam(f.og.model,n.model)then out[#out+1]=n.model end end end
 return out
end
function M.GetMotion(model)
 for _,motion in ipairs(M.fighters)do if motion.model==model then return motion end end
 local n=node(model);if not n or not alive(n)then return nil end
 if not n.proxy then
  local values={model=n.model,head=V.Head(n.model),depth=n.depth,rotation=n.rotation,beam={Enabled=false},extraBeams={}}
  n.proxy=setmetatable(values,{
   __index=function(_,k)
    if k=='position'then return n.p elseif k=='velocity'then return n.velocity*(n.model:GetAttribute('Speed')or 25)
    elseif k=='radius'then return radius(n)elseif k=='speed'then return n.model:GetAttribute('Speed')or 25 end
   end,
   __newindex=function(t,k,v)
    if k=='position'then n.p=v;put(n,v)
    elseif k=='velocity'then n.velocity=v.Magnitude>.001 and v.Unit or Vector2.zero
    else rawset(t,k,v)end
   end,
  })
 end
 return n.proxy
end
function M.MotionTargets(fighters)
 local out={};for _,f in ipairs(fighters)do out[#out+1]=f end
 for _,n in pairs(M.nodes)do if n.name~='OG'and alive(n)and not n.model:GetAttribute('DeadlyPhantom')then out[#out+1]=M.GetMotion(n.model)end end
 return out
end
local function contactHit(n,model)
 if M.SameTeam(n.model,model)then return end
 local opposing=node(model);if opposing then opposing.contacts=opposing.contacts or {};opposing.contacts[n.model]=true end
 if M.ContactHandler and M.ContactHandler(n.model,model)then return end
 -- BindableEvent handlers can run after the growth reset: snapshot both damage values now.
 if n.assim=='Stack'then stackUpdate(n,false)end;if opposing and opposing.assim=='Stack'then stackUpdate(opposing,false)end
 local dealt=n.model:GetAttribute('CollisionDamage')or 0;local recoil=model:GetAttribute('CollisionDamage')or 0
 SSS.BiteHit:Fire(n.model,model,dealt,true,'Collision',recoil)
 stackContact(n,model,dealt);if opposing then stackContact(opposing,n.model,recoil)end
end
function M.Find(name)
 local result=workspace:FindFirstChild(name);return result or folder:FindFirstChild(name)
end
function M.Targets(model)
 local out={model};local f=M.families[model]
 if f then for _,n in ipairs(f.members)do if n.name~='OG'and alive(n)then out[#out+1]=n.model end end end
 return out
end
local function blocked(a,b,ignore)
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.RespectCanCollide=true
 rp.FilterDescendantsInstances={folder,workspace:FindFirstChild('Fighter1'),workspace:FindFirstChild('Fighter2')}
 if ignore then rp.FilterDescendantsInstances[#rp.FilterDescendantsInstances+1]=ignore end
 local delta=b-a;if delta.Magnitude<.001 then return false end
 return workspace:Raycast(a,delta,rp)~=nil
end
local function free(p,r,depth,omit)
 if p.X<-24+r or p.X>24-r or p.Y<5+r or p.Y>45-r then return false end
 for _,f in ipairs(M.fighters)do if f.model~=omit and(f.position-p).Magnitude<r+f.radius+.5 then return false end end
 for _,n in pairs(M.nodes)do if n.model~=omit and(alive(n)or(n.spawning and not n.dead and n.model.Parent))and(position(n)-p).Magnitude<r+radius(n)+.5 then return false end end
 local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={folder,workspace.Fighter1,workspace.Fighter2}
 for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(p.X,p.Y,depth),Vector3.new(r*2,r*2,1),params))do
  if part.CanCollide and part.Name~='ArenaBackdrop'and part.Name~='ArenaFloor'then return false end
 end
 return true
end
local function spot(r,depth,omit)
 if M.demo or state:GetAttribute('DeadlyDemoActive') then
  -- Placement de test indépendant des obstacles du décor.
  local margin=math.clamp(r,1,18)
  return Vector2.new(
   random:NextNumber(-24+margin,24-margin),
   random:NextNumber(5+margin,45-margin)
  )
 end
 for i=1,120 do
  local p=Vector2.new(random:NextNumber(-24+r,24-r),
   random:NextNumber(5+r,45-r))
  if free(p,r,depth,omit) then return p end
 end
 return nil
end
function M.OnDeath(model)
 local n=node(model);if not n or n.dead then return end;n.dead=true
 local f=n.family
 if n.name=='OG'then
  for _,a in ipairs(f.members)do releaseContacts(a);if a~=n then
   a.dead=true;a.model:SetAttribute('DeadlyHPFrozen',false);setHp(a,0)
   if M.Health then M.Health.Unregister(a.model)end
   Gate.Reset(a.model);a.model:Destroy()
  end end
  return
 end
 releaseContacts(n)
 local stack=f.byName.Stack;if alive(stack)then
  stack.deathBonus=(stack.deathBonus or 0)+20
  effect('PowerNotice',{Model=stack.model,Member='Stack',Text='STACK : STACK EST AFFAME..',Duration=1.8})
  setHp(stack,(stack.model:GetAttribute('Health')or 0)+20,(stack.model:GetAttribute('MaxHealth')or 100)+20)
 end
 -- Dark blades always fire exactly three shots, regardless of ally deaths.
 effect('Dust',{Position=headpos(n),Color=V.Colors[n.name]})
 if M.Health then M.Health.Unregister(n.model)end
 Gate.Reset(n.model);n.model:Destroy()
end
function M.AdjustDamage(model,amount)
 if model:GetAttribute('DeadlySpawning')then return 0 end
 local n=node(model);if not n then return amount end
 local f=n.family
 if model:GetAttribute('DeadlySpawning')or model:GetAttribute('DeadlyInvulnerable')or model:GetAttribute('DeadlyHPFrozen')then return 0 end
 if n.name=='Void'then
  if n.assim=='Dodger'and amount>0 then n.breakProtection=true end
  return 0
 end
 if n.name=='OG'and not f.stage and alive(f.byName.Dodger)then
  local result=math.min(amount,math.max(0,(model:GetAttribute('Health')or 0)-1))
  local dodger=f.byName.Dodger
  if result<amount and f.t>=(dodger.noticeAt or 0)then dodger.noticeAt=f.t+1;effect('PowerNotice',{Model=dodger.model,Member='Dodger',Text='DODGER : BOUCLIER ANTI-CRAX',Duration=1.5})end
  return result
 end
 return amount
end
local function boost(f)
 if f.stage then return end
 f.og.model:SetAttribute('DeadlyShield',alive(f.byName.Dodger)and true or false)
 local active=level(f)>=1 and #living(f)>=4
 for _,n in ipairs(f.members)do if alive(n)then
  local st=stats[n.name];local rage=n.name=='Parker'and math.clamp(math.floor(((f.og.model:GetAttribute('MaxHealth')or 90)-(f.og.model:GetAttribute('Health')or 90))/10),0,6)or 0
  n.model:SetAttribute('CollisionDamage',st[3]+rage*3+(active and 2 or 0))
  n.model:SetAttribute('Speed',st[2]+rage*3+(active and 2 or 0))
  local ogHealth=f.og.model:GetAttribute('Health')or 90
  if n.name=='Parker'and rage>(n.lastRage or 0)and n.lastOGHealth and ogHealth<n.lastOGHealth and f.t>=(n.rageNoticeAt or 0)then
   n.rageNoticeAt=f.t+2.5;effect('PowerNotice',{Model=n.model,Member='Parker',Text='PARKER : COLERIQUE AUGMENTE...',Duration=1.5})
  end
  n.lastOGHealth=ogHealth
  n.lastRage=rage;n.model:SetAttribute('DeadlyRage',rage)
  if n.assim=='Stack'then stackUpdate(n,false)end
  if n.assim=='Parker'and n.frenzyStarted then n.model:SetAttribute('CollisionDamage',15);n.model:SetAttribute('Speed',100)end
  if not n.model:GetAttribute('DeadlyHPFrozen')then
   n.boost=active;n.model:SetAttribute('DeadlyFamilyBoost',active)
   if st[1]<math.huge then
    local maximum=st[1]+(n.deathBonus or 0)+(active and 5 or 0)
    local hp=n.model:GetAttribute('Health')or 0
    if active and not n.boostHealed then hp=hp+5;n.boostHealed=true end
    if maximum~=(n.model:GetAttribute('MaxHealth')or st[1])or hp~=(n.model:GetAttribute('Health')or 0)then
     setHp(n,math.min(hp,maximum),maximum)
    end
   end
  end
 end end
end
function M.OnHeal(target,gained,source)
 local vice=source and node(source)
 if gained<=0 or not alive(vice)or vice.name~='Vice'or target~=vice.family.og.model or state:GetAttribute('Phase')~='Fighting'then return end
 effect('ViceHeal',{Model=target,Duration=1.2,Amount=gained})
 effect('PowerNotice',{Model=source,Member='Vice',Text='VICE : SOINS PRODIGUEES..',Duration=1.2})
end
local function spawn(f,name)
 if not InvertedSilence.CanStart(f.og.model)then return false end
 local base=game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase')
 local m=V.Make(base,name,.5);local h=V.Head(m);local r=math.max(h.Size.X,h.Size.Y)/2
 local p
 -- Calibrate the imported base against OG's actual half-size hitbox.
 local target=V.Head(f.og.model).Size.X
 m:ScaleTo(m:GetScale()*target/h.Size.X);r=math.max(h.Size.X,h.Size.Y)/2
 p=spot(r,f.og.depth);if not p then m:Destroy();return false end
 m.Name=f.og.model.Name..'_'..name;m:SetAttribute('DeadlyRoot',f.og.model.Name)
 local st=stats[name];m:SetAttribute('MaxHealth',st[1]);m:SetAttribute('Health',st[1]);m:SetAttribute('Speed',st[2]);m:SetAttribute('CollisionDamage',st[3])
 m:SetAttribute('AbilityId','DeadlyAlly');m:SetAttribute('DeadlySpawning',true);m:SetAttribute('DeadlySpawnDuration',1.5);m.Parent=folder
 local n={model=m,name=name,family=f,p=p,depth=f.og.depth,rotation=f.og.rotation,velocity=Vector2.zero,baseScale=m:GetScale(),waves=3,contacts={},nextPulsar=f.t,nextHeal=f.t+2.5,boost=false,t=f.t,spawning=true,spawnRemaining=1.5,spawnAlpha={},spawnEnabled={}}
 f.members[#f.members+1]=n;f.byName[name]=n;M.nodes[m]=n;f.pendingSpawn=n
 for _,part in ipairs(m:GetDescendants())do
  if part:IsA('BasePart')then n.spawnAlpha[part]=part.Transparency;part:SetAttribute('DeadlyIntendedAlpha',part.Transparency);part.Transparency=1
  elseif part:IsA('ParticleEmitter')or part:IsA('Trail')or part:IsA('Beam')then n.spawnEnabled[part]=part.Enabled;part.Enabled=false end
 end
 put(n,p)
 effect('SpawnChannel',{Position=headpos(n),Color=V.Colors[name],Radius=r,Duration=1.5,Model=m,ModelName=m.Name,Member=name})
 return true
end
local function spawnStep(f,dt)
 local n=f.pendingSpawn;if not n then return end
 if n.dead or not n.model.Parent then f.pendingSpawn=nil;return end
 n.spawnRemaining=math.max(0,n.spawnRemaining-dt)
 if n.spawnRemaining>1e-6 then return end -- The safe initial position is reserved; do not keep a member invisible forever.
 -- No registered health, collision, passive or ability exists during the cloud.
 n.spawning=false;n.model:SetAttribute('DeadlySpawning',false)
 for part,alpha in pairs(n.spawnAlpha)do if part.Parent then part.Transparency=part:GetAttribute('DeadlyIntendedAlpha')or alpha;part.LocalTransparencyModifier=0 end end
 n.spawnAlpha=nil
 for emitter,enabled in pairs(n.spawnEnabled)do if emitter.Parent then emitter.Enabled=enabled end end;n.spawnEnabled=nil
 local direction=Vector2.new(random:NextNumber(-1,1),random:NextNumber(-1,1))
 n.velocity=direction.Magnitude>.001 and direction.Unit or Vector2.new(1,0)
 n.t=f.t;n.nextHeal=n.t+2.5;n.nextPulsar=n.t+(n.name=='Void'and 3 or 0)
 if n.name=='Void'then n.firstPulsarAt=n.nextPulsar end
 M.Health.Register(n.model);f.pendingSpawn=nil
 effect('SpawnReveal',{Position=headpos(n),Color=V.Colors[n.name],Radius=radius(n),Model=n.model,ModelName=n.model.Name,Member=n.name})
end
local function finishAim(model,entry,reveal)
 for part,alpha in pairs(entry.alpha)do if part.Parent then part.Transparency=alpha end end
 for gui,enabled in pairs(entry.enabled)do if gui.Parent then gui.Enabled=enabled end end
 if model.Parent then model:SetAttribute('DeadlySpawning',false);Gate.Resume(model,'DeadlyAppearance')end
 M.aimSpawns[model]=nil
 if reveal and model.Parent then effect('SpawnReveal',{Position=V.Head(model).Position,Color=V.Colors.OG,Radius=entry.radius,Model=model,ModelName=model.Name,Member='OG'})end
end
local function beginAim(motion)
 local model=motion.model;local h=V.Head(model);local entry={remaining=1.5,alpha={},enabled={},radius=math.max(h.Size.X,h.Size.Y)/2}
 model:SetAttribute('DeadlySpawning',true);model:SetAttribute('DeadlySpawnDuration',1.5);Gate.Pause(model,'DeadlyAppearance')
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA('BasePart')then entry.alpha[o]=o.Transparency;o.Transparency=1
  elseif o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then entry.enabled[o]=o.Enabled;o.Enabled=false end
 end
 M.aimSpawns[model]=entry
 effect('OGPortalEntry',{StartedAt=now(),Position=h.Position,Color=V.Colors.OG,Radius=entry.radius,Duration=1.5,Model=model,ModelName=model.Name,Member='OG'})
end
local function aimStep(dt)
 for model,entry in pairs(M.aimSpawns)do
  if not model.Parent then M.aimSpawns[model]=nil
  else entry.remaining=entry.remaining-dt;if entry.remaining<=1e-6 then finishAim(model,entry,true)end end
 end
end
local function flash(f,on)
 if f.flashing==on then return end;f.flashing=on
 local count=math.max(0,(state:GetAttribute('DeadlyFlashCount')or 0)+(on and 1 or-1));state:SetAttribute('DeadlyFlashCount',count)
 local models={workspace.Fighter1,workspace.Fighter2};for model,n in pairs(M.nodes)do if n.name~='OG'and model.Parent then models[#models+1]=model end end
 for _,model in ipairs(models)do if on then Gate.Pause(model,'DeadlyFlash'..f.og.model.Name)else Gate.Resume(model,'DeadlyFlash'..f.og.model.Name)end end
 if on then effect('Flash',{Duration=2.5})end
end
local function portalsClose(n)
 if M.demo and M.demo.viceApproach and M.demo.viceApproach.owner==n then M.demo.viceApproach=nil end
 if n.portalId then M.RequestVicePortalClose(n.portalId);n.portalId=nil end
 n.portals=nil
end
local function restoreVoidImmediate(n)
 portalsClose(n);stackClear(n);clearAura(n,'DeadlyAssimilation');n.assim=nil;n.model:SetAttribute('DeadlyAssimilation','');n.model:SetAttribute('DeadlyInvulnerable',false)
 n.model:SetAttribute('DeadlyInvulnerableChannel',false)
 for _,a in ipairs(n.family.members)do if a.model.Parent then a.model:SetAttribute('DeadlyHPFrozen',false)end end
 size(n,1);setHp(n,math.huge,math.huge);n.nextPulsar=n.t+15;n.pulse=nil;n.grid=nil;n.frenzyStarted=nil;n.parkerTouches=nil;n.breakProtection=nil;n.model:SetAttribute('Speed',17);n.model:SetAttribute('CollisionDamage',12+(n.boost and 2 or 0));n.contacts={}
end
local function restoreVoid(n)
 local member=n.assim
 restoreVoidImmediate(n)
 if member then
  n.returningUntil=n.t+1.15;n.nextPulsar=n.returningUntil+15;n.model:SetAttribute('DeadlyTransitioning',true)
  effect('AssimilationReturn',{Model=n.model,Member=member,Duration=1.15})
 end
end
local function assimilate(n,a)
 n.eating=nil;n.returningUntil=nil;n.used=true;n.assim=a.name;n.assimStart=n.t;n.assimEnd=n.assim=='Domino'and n.t+20 or n.assim=='Vice'and n.t+30 or n.assim=='Stack'and n.t+30 or math.huge
 n.model:SetAttribute('DeadlyAssimilation',a.name);if a.name~='Domino'and a.name~='Parker'and a.name~='Dodger'and a.name~='Vice'and a.name~='Stack'then aura(n,V.Colors[a.name],'DeadlyAssimilation')end
 -- DOMINO visuals are owned by CraxDominoVerdict.
 n.pulse=nil
 for i=#n.family.waves,1,-1 do if n.family.waves[i].owner==n then table.remove(n.family.waves,i)end end
 M.OnDeath(a.model)
 if n.assim=='Dodger'then setHp(n,1,1);for _,ally in ipairs(n.family.members)do if alive(ally)and ally~=n then ally.model:SetAttribute('DeadlyHPFrozen',true)end end
 elseif n.assim=='Parker'then n.chargeEnd=n.t+2.5;n.remaining=20;n.legHits={};n.model:SetAttribute('DeadlyInvulnerableChannel',false)
 elseif n.assim=='Domino'then n.nextGrid=n.t+8
 elseif n.assim=='Vice'then n.nextPortal=n.t+3
 elseif n.assim=='Stack'then stackBegin(n)
 end
 n.transformUntil=n.t+1.25;n.model:SetAttribute('DeadlyTransitioning',true)
 if n.assimEnd<math.huge then n.assimEnd=n.assimEnd+1.25 end
 for _,key in ipairs({'chargeEnd','nextGrid','nextPortal','nextGrow'})do if n[key]then n[key]=n[key]+1.25 end end
 effect('AssimilationPower',{Model=n.model,Member=n.assim,Duration=1.25})
end
local function jaw(n,opening)
 local lower=n.model:FindFirstChild('LowerJaw',true)
 if not lower or not lower:IsA('Model')then return end
 n.jawRelative=n.jawRelative or n.model:GetPivot():ToObjectSpace(lower:GetPivot())
 lower:PivotTo(n.model:GetPivot()*n.jawRelative*CFrame.new(0,-V.Head(n.model).Size.Y*.23*opening,0))
end
local function beginAssimilation(n,a)
 if not InvertedSilence.CanStart(n.model)then return end
 M.cinematics[n.model]={finish=now()+3.65}
 effect('AssimilationCinematic',{Model=n.model,Target=a.model,Member=a.name,Duration=3.65})
 n.used=true;n.eating={target=a,start=n.t,finish=n.t+2.4,position=position(a),scale=a.model:GetScale()}
 a.eatenPending=true;a.model:SetAttribute('DeadlyBeingEaten',true);a.model:SetAttribute('DeadlyInvulnerable',true)
 Gate.Pause(a.model,'DeadlySwallow');releaseContacts(a)
 for _,o in ipairs(a.model:GetDescendants())do if o:IsA('BillboardGui')then o.Enabled=false end end
 n.model:SetAttribute('DeadlyTransitioning',true)
 effect('AssimilationEat',{Model=n.model,Target=a.model,Member=a.name,Duration=2.4})
end
local function eatStep(n)
 local e=n.eating;if not e then return end
 local a=e.target
 if not a.model.Parent or a.dead then n.eating=nil;n.model:SetAttribute('DeadlyTransitioning',false);jaw(n,0);return end
 local progress=math.clamp((n.t-e.start)/2.4,0,1)
 jaw(n,math.sin(progress*math.pi))
 local ingest=math.clamp((progress-.2)/.65,0,1);ingest=ingest*ingest*(3-2*ingest)
 a.model:ScaleTo(e.scale*math.max(.025,1-ingest*.975))
 put(a,e.position:Lerp(position(n)+Vector2.new(0,-radius(n)*.18),ingest))
 if n.t>=e.finish then jaw(n,0);assimilate(n,a)end
end
local function familyContact(f)
 -- VOID_DIRECTION_FIX_v1: the demo's hidden OG is a support, not a collision obstacle.
 if M.demo and M.demo.family==f then return end
 if f.stage or not alive(f.og)or M.Hold(f.og.model)then return end
 -- The only ordinary friendly barrier is OG. Other allies overlap freely.
 for _,n in ipairs(f.members)do if n~=f.og and alive(n)and not(n.assim=='Parker'and n.frenzyStarted)and not n.eating and not n.returningUntil and not n.transformUntil then
  local delta=position(n)-position(f.og);local distance=delta.Magnitude;local limit=radius(n)+radius(f.og)
  if distance<limit then
   local direction=distance>.001 and delta.Unit or Vector2.new(1,0)
   put(n,position(f.og)+direction*(limit+.025))
   local inward=n.velocity:Dot(direction);if inward<0 then n.velocity=n.velocity-direction*(2*inward)end
  end
 end end
end
local function fusionWarning(f)
 if not InvertedSilence.CanStart(f.og.model)then return end
 if f.warningEnd then return end
 f.warningEnd=f.t+4
 effect('FusionWarning',{Model=f.og.model,Duration=4,Text='Un danger imminent approche...'})
end
local function beginFusion(f)
 f.warningEnd=nil
 effect('FusionWarningEnd',{Model=f.og.model})
 f.fusionUsed=true;f.stage='Gather';f.stageEnd=f.t+5;f.saved={}
 f.waves={};f.blades={};f.fires={}
 for _,n in ipairs(f.members)do
  releaseContacts(n)
  f.saved[n]={hp=n.model:GetAttribute('Health'),max=n.model:GetAttribute('MaxHealth'),speed=n.model:GetAttribute('Speed'),damage=n.model:GetAttribute('CollisionDamage'),position=position(n),scale=n.model:GetScale(),velocity=n.motion and n.motion.velocity or n.velocity}
  n.model:SetAttribute('DeadlyInvulnerable',true);n.model:SetAttribute('DeadlyPhantom',n~=f.og)
 end
 f.savedVelocity=f.og.motion.velocity
 f.og.model:SetAttribute('DeadlyStage','Gather')
 effect('Charge',{Model=f.og.model,Duration=5,Color=V.Emerald})
end
local function stage(f)
 if not f.stage then return end
 if f.t>=f.stageEnd then
  if f.stage=='Gather'then f.stage='FlashIn';f.stageEnd=f.t+2.5;flash(f,true)
  elseif f.stage=='FlashIn'then
   flash(f,false);f.stage='Form';f.stageEnd=f.t+15
   f.og.model:SetAttribute('DeadlyShield',false);setHp(f.og,130,130);f.og.model:SetAttribute('Speed',40);f.og.model:SetAttribute('CollisionDamage',40);f.og.model:SetAttribute('DeadlyInvulnerable',false)
   put(f.og,Vector2.new(0,25));local angle=random:NextNumber(0,math.pi*2);f.og.motion.velocity=Vector2.new(math.cos(angle),math.sin(angle))*40;aura(f.og,V.Emerald,'DeadlyFusion');f.trailNext=f.t
  elseif f.stage=='Form'then
   f.stage='LaserCharge';f.stageEnd=f.t+4;f.laserOrigin=position(f.og);local d=f.enemy.position-f.laserOrigin
   f.laserDirection=d.Magnitude>.01 and d.Unit or Vector2.new(1,0);f.og.model:SetAttribute('DeadlyInvulnerable',true)
   effect('LaserWarning',{StartTime=now(),Model=f.og.model,Origin=Vector3.new(f.laserOrigin.X,f.laserOrigin.Y,f.og.depth),Direction=f.laserDirection,Width=36,Duration=4})
  elseif f.stage=='LaserCharge'then
   f.stage='Laser';f.stageEnd=f.t+4;f.laserTick=f.t;f.og.model:SetAttribute('DeadlyInvulnerable',false)
   effect('Laser',{StartTime=now(),Model=f.og.model,Origin=Vector3.new(f.laserOrigin.X,f.laserOrigin.Y,f.og.depth),Direction=f.laserDirection,Width=36,Duration=4})
  elseif f.stage=='Laser'then f.stage='FlashOut';f.stageEnd=f.t+2.5;f.og.model:SetAttribute('DeadlyInvulnerable',true);flash(f,true)
  elseif f.stage=='FlashOut'then
   flash(f,false)
   for _,n in ipairs(f.members)do local s=f.saved[n];if alive(n)then
    setHp(n,s.hp,s.max);n.model:SetAttribute('Speed',s.speed);n.model:SetAttribute('CollisionDamage',s.damage)
    n.model:SetAttribute('DeadlyInvulnerable',false);n.model:SetAttribute('DeadlyPhantom',false);n.model:SetAttribute('DeadlyMerged',false);n.model:ScaleTo(s.scale)
    if n.motion then n.motion.velocity=s.velocity;n.motion.radius=radius(n) else n.velocity=s.velocity end
    local p=n==f.og and position(n)or spot(radius(n),n.depth,n.model)or s.position;put(n,p)
   end end
   clearAura(f.og,'DeadlyFusion');f.og.model:SetAttribute('DeadlyStage',nil);f.stage=nil;return
  end
  f.og.model:SetAttribute('DeadlyStage',f.stage)
 end
 if f.stage=='Form'and f.t>=f.trailNext then
  f.trailNext=f.t+.12;local p=position(f.og);f.trails[#f.trails+1]={p=p,expires=f.t+5,r=radius(f.og),ticks={}}
  effect('Slime',{Position=Vector3.new(p.X,p.Y,f.og.depth+.8),Radius=radius(f.og),Duration=5})
 end
 if f.stage=='Laser'and f.t>=f.laserTick then
  f.laserTick=f.laserTick+.3
  for _,model in ipairs(enemyModels(f))do local p=xy(V.Head(model).Position);local d=p-f.laserOrigin;local forward=d:Dot(f.laserDirection);local side=math.abs(d.X*f.laserDirection.Y-d.Y*f.laserDirection.X)
   if forward>=0 and forward<=100 and side<=18 then damage(f.og,model,50,'DeadlyLaser')end
  end
 end
 local k=0
 for _,n in ipairs(f.members)do if n~=f.og and alive(n)then
  k=k+1;local a=f.t*9+k*math.pi/3;local dist=radius(f.og)*2.5
  if f.stage=='Gather'then local s=f.saved[n];local target=position(f.og)+Vector2.new(math.cos(a),math.sin(a))*dist;put(n,s.position:Lerp(target,math.clamp(1-(f.stageEnd-f.t)/5,0,1)))
  elseif f.stage=='Form'or f.stage=='FlashIn'then n.model:SetAttribute('DeadlyMerged',false);put(n,position(f.og)+Vector2.new(math.cos(a),math.sin(a))*dist)
  else n.model:SetAttribute('DeadlyMerged',true);put(n,position(f.og));end
 end end
end
-- PARKER_CONTACT_ONLY_v1 — wall hits never target an enemy.
local function rebound(n,wall)
 if wall and n.t>=(n.wallImpactAt or 0)then n.wallImpactAt=n.t+.1;effect('WallImpact',{Position=headpos(n),Model=n.model,Target=n.model})end
 if wall and n.assim=='Parker'and n.frenzyStarted and not state:GetAttribute('GhostNightActive')then n.remaining=n.remaining-1;n.legHits={};local p=position(n);local r=radius(n);local x,y=0,0;if p.X<=-24+r+.01 then x=1 elseif p.X>=24-r-.01 then x=-1 end;if p.Y<=5+r+.01 then y=1 elseif p.Y>=45-r-.01 then y=-1 end;local normal=Vector2.new(x,y);if normal.Magnitude<.001 then normal=-n.velocity end;effect('VoidDashBounce',{Model=n.model,Member='Parker',Remaining=n.remaining,Position=headpos(n),Normal=normal.Unit,Direction=n.velocity});if n.remaining<=0 then restoreVoid(n)end end
end
local function sweepEntry(a,b,center,r)
 local delta=b-a;local offset=a-center;local length2=delta:Dot(delta)
 if offset:Dot(offset)<=r*r then return 0 end
 if length2<1e-9 then return nil end
 local projection=offset:Dot(delta);local disc=projection*projection-length2*(offset:Dot(offset)-r*r)
 if disc<0 then return nil end
 local t=(-projection-math.sqrt(disc))/length2;return t>=0 and t<=1 and t or nil
end
local function dashHits(n,a,b)
 n.parkerTouches=n.parkerTouches or{}
 for model in pairs(n.parkerTouches)do if not model.Parent then n.parkerTouches[model]=nil end end
 for _,target in ipairs(enemyModels(n.family))do
  local blocked=M.SameTeam(n.model,target)or target:GetAttribute('DeadlyPhantom')or target:GetAttribute('DeadlyHPFrozen')or target:GetAttribute('FantasticInvisible')or target:GetAttribute('DeadlySpawning')or target:GetAttribute('VicePortalTransit')or target:GetAttribute('DeadlyInvulnerable')or target:GetAttribute('GhostInvulnerable')
  if not blocked and target.Parent and(target:GetAttribute('Health')or 0)>0 then
   local h=V.Head(target);local motion=M.GetMotion(target);local center=motion and motion.position or xy(h.Position)
   local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2
   local hit=sweepEntry(a,b,center,limit)
   if hit and not n.parkerTouches[target]then
    damage(n,target,15,'DeadlyParkerContact')
    require(SSS.CraxBurning).Apply(n.model,target)
    if state:GetAttribute('DeadlyDemoActive')then target:SetAttribute('BurningActive',true);target:SetAttribute('DeadlyDemoBurnUntil',now()+3)end
    effect('VoidDashHit',{Model=target,Owner=n.model,Member='Parker',Position=h.Position,Damage=15,OnWall=false})
   end
   n.parkerTouches[target]=(b-center).Magnitude<=limit+.05 and true or nil
  else n.parkerTouches[target]=nil end
 end
end

function M.Knockback(model,direction)
 local n=node(model);local impulse={velocity=direction*45,remaining=.28}
 if n and n.name~='OG'then n.knockback=impulse else local motion=M.GetMotion(model);if motion then motion.knockback=impulse end end
 effect('PulsarKnockback',{Model=model,Direction=direction,Duration=.28})
end
local function voidMovementObstacle(n,from,to)
 local delta=to-from
 if delta.Magnitude<.00001 then return nil end
 local filter={folder,n.model}
 for _,motion in ipairs(M.fighters)do if motion.model.Parent then filter[#filter+1]=motion.model end end
 local demoFolder=workspace:FindFirstChild('DeadlyDemonstration')
 if demoFolder then filter[#filter+1]=demoFolder end
 for _,name in ipairs({'ArenaBackdrop','ArenaFloor'})do
  local object=workspace:FindFirstChild(name,true)
  if object then filter[#filter+1]=object end
 end
 for _,player in ipairs(game:GetService('Players'):GetPlayers())do
  if player.Character then filter[#filter+1]=player.Character end
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 for attempt=1,8 do
  params.FilterDescendantsInstances=filter
  local hit=workspace:Raycast(from,delta,params)
  if not hit then return nil end
  local normal=Vector2.new(hit.Normal.X,hit.Normal.Y)
  local part=hit.Instance
  -- The XY simulation cannot bounce on front/back planes, or on invisible scenery.
  if (part:IsA('BasePart')and part.Transparency>=.98)or normal.Magnitude<.001 then
   filter[#filter+1]=part
  else
   normal=normal.Unit
   if n.velocity:Dot(normal)<-.0001 then return hit,normal end
   filter[#filter+1]=part
  end
 end
 return nil
end
-- Inserts before moveAlly. Every uninterrupted leg lasts 8/12 seconds.
-- PARKER_SPECULAR_100_v3. Arena [-24,24] x [5,45], reduced by actor radius.
local function parkerTimedMove(n,dt)
 if not n.frenzyStarted then
  if n.t<n.chargeEnd then return end
  n.frenzyStarted=true;size(n,1);n.parkerLeg=nil;n.parkerSpeed=100;n.parkerTouches={}
  n.velocity=n.velocity.Magnitude>.001 and n.velocity.Unit or Vector2.new(1,.63).Unit
  n.model:SetAttribute('CollisionDamage',15);n.model:SetAttribute('Speed',100)
  effect('Frenzy',{Model=n.model})
  effect('VoidDashStart',{Model=n.model,Member='Parker',Count=n.remaining or 20,Direction=n.velocity,Speed=100})
 end
 local slow=M.Slow(n.model)*(now()<(n.model:GetAttribute('SilkSlowUntil')or 0)and .6 or 1)
 local budget=math.max(0,dt)*100*math.max(0,slow)
 local r=radius(n);local minX,maxX=-24+r,24-r;local minY,maxY=5+r,45-r
 assert(minX<maxX and minY<maxY,'PARKER : acteur trop grand pour l’arène.')
 n.p=Vector2.new(math.clamp(n.p.X,minX,maxX),math.clamp(n.p.Y,minY,maxY))
 local iterations=0
 while budget>1e-7 and n.assim=='Parker'and n.frenzyStarted do
  iterations=iterations+1
  if iterations>128 then break end
  local d=n.velocity.Unit
  local tx,ty=math.huge,math.huge
  if d.X>1e-9 then tx=(maxX-n.p.X)/d.X elseif d.X< -1e-9 then tx=(minX-n.p.X)/d.X end
  if d.Y>1e-9 then ty=(maxY-n.p.Y)/d.Y elseif d.Y< -1e-9 then ty=(minY-n.p.Y)/d.Y end
  tx=math.max(0,tx);ty=math.max(0,ty)
  local distance=math.min(tx,ty);local travel=math.min(budget,distance)
  local previous=n.p;n.p=n.p+d*travel
  n.p=Vector2.new(math.clamp(n.p.X,minX,maxX),math.clamp(n.p.Y,minY,maxY))
  dashHits(n,previous,n.p);budget=math.max(0,budget-travel)
  if travel>=distance-1e-7 then
   -- A corner is one physical contact: reflect both components, report once.
   local hitX=math.abs(tx-distance)<1e-7;local hitY=math.abs(ty-distance)<1e-7
   -- Choose a new inward direction only at an actual arena-wall contact.
   local x=hitX and(d.X>0 and -1 or 1)*random:NextNumber(.3,1)or random:NextNumber(-1,1)
   local y=hitY and(d.Y>0 and -1 or 1)*random:NextNumber(.3,1)or random:NextNumber(-1,1)
   n.velocity=Vector2.new(x,y).Unit
   put(n,n.p);rebound(n,true)
  else break end
 end
end

local function moveAlly(n,dt)
 if n.model:GetAttribute('VicePortalTransit')then return end
 if n.name=='OG'or n.eating or n.returningUntil or n.transformUntil or not alive(n)or Gate.Paused(n.model)or n.model:GetAttribute('DeadlyStunned')or n.model:GetAttribute('FantasticGrabbed')or(n.proxy and n.proxy.capturedBy)then return end
 if n.name=='Vice'and not n.model:GetAttribute('InvertedHacked')then
  local og=n.family.og;local orbit=radius(og)+radius(n)+.12
  n.orbitAngle=(n.orbitAngle or math.atan2((n.p-position(og)).Y,(n.p-position(og)).X))+dt*2.8
  local center=position(og)
  center=Vector2.new(math.clamp(center.X,-24+orbit+radius(n),24-orbit-radius(n)),math.clamp(center.Y,5+orbit+radius(n),45-orbit-radius(n)))
  n.orbitCenter=n.orbitCenter and n.orbitCenter:Lerp(center,1-math.exp(-dt*35))or center
  n.orbitOffset=(n.orbitOffset or Vector2.zero)*math.exp(-dt*12)
  local wanted=n.orbitCenter+Vector2.new(math.cos(n.orbitAngle),math.sin(n.orbitAngle))*orbit+n.orbitOffset
  local previous=n.p;local delta=wanted-n.p
  n.p=n.p+delta*(1-math.exp(-dt*45))
  local displacement=n.p-previous;n.velocity=displacement.Magnitude>.001 and displacement.Unit or n.velocity
 elseif n.assim=='Parker'then parkerTimedMove(n,dt)
 else
  local speed=n.assim=='Parker'and(110+(n.boost and 2 or 0))or(n.model:GetAttribute('Speed')or 25)
  speed=speed*M.Slow(n.model)*(now()<(n.model:GetAttribute('SilkSlowUntil')or 0)and .6 or 1)
  local previous=n.p;local r=radius(n);n.p=n.p+n.velocity*speed*dt
  local hit=false
  if n.p.X<-24+r or n.p.X>24-r then hit=true end
  if n.p.Y<5+r or n.p.Y>45-r then hit=true end
  if hit then
   if n.assim=='Parker'and n.frenzyStarted then
    local x=random:NextNumber(-1,1);local y=random:NextNumber(-1,1)
    if n.p.X<-24+r then x=math.max(.25,math.abs(x))elseif n.p.X>24-r then x=-math.max(.25,math.abs(x))end
    if n.p.Y<5+r then y=math.max(.25,math.abs(y))elseif n.p.Y>45-r then y=-math.max(.25,math.abs(y))end
    n.velocity=Vector2.new(x,y).Unit
   else
    n.velocity=Vector2.new((n.p.X<-24+r or n.p.X>24-r)and-n.velocity.X or n.velocity.X,(n.p.Y<5+r or n.p.Y>45-r)and-n.velocity.Y or n.velocity.Y)
   end
   n.p=Vector2.new(math.clamp(n.p.X,-24+r,24-r),math.clamp(n.p.Y,5+r,45-r));if n.assim=='Parker'and n.frenzyStarted then dashHits(n,previous,n.p)end;rebound(n,true)
  elseif n.name=='Void'and not(state:GetAttribute('DeadlyDemoActive')and n.assim=='Vice')then
   local hit,normal=voidMovementObstacle(n,Vector3.new(previous.X,previous.Y,n.depth),Vector3.new(n.p.X,n.p.Y,n.depth))
   if hit then
    n.p=previous
    n.velocity=n.velocity-normal*(2*n.velocity:Dot(normal))
    effect('WallImpact',{Position=headpos(n),Model=n.model,Target=n.model})
   elseif n.assim=='Parker'and n.frenzyStarted then dashHits(n,previous,n.p)end
  elseif blocked(Vector3.new(previous.X,previous.Y,n.depth),Vector3.new(n.p.X,n.p.Y,n.depth))then n.p=previous;n.velocity=-n.velocity
  end
 end
 if n.knockback then local k=n.knockback;n.p=n.p+k.velocity*dt;k.velocity=k.velocity*math.exp(-8*dt);k.remaining=k.remaining-dt;if k.remaining<=0 then n.knockback=nil end end
 local r=radius(n);n.p=Vector2.new(math.clamp(n.p.X,-24+r,24-r),math.clamp(n.p.Y,5+r,45-r))
 put(n,n.p)
end
local function pulse(n,dt)
 local f=n.family;f.blades=f.blades or {}
 if n.pulse then
  local q=n.pulse
  if n.t+1e-6>=q.next and q.remaining>0 then
   local origin=xy(headpos(n));local delta=q.aim-origin;local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
   n.bladeSequence=(n.bladeSequence or 0)+1
   local id=n.model.Name..'_blade_'..n.bladeSequence
   local blade={id=id,p=origin,direction=direction,speed=42,width=2*math.max(1.15,radius(n)*.8),remaining=2,owner=n}
   f.blades[#f.blades+1]=blade
   effect('VoidPulsarWave',{Index=4-q.remaining,Id=id,Position=Vector3.new(origin.X,origin.Y,headpos(n).Z),Direction=direction,Speed=42,Width=blade.width,Duration=2,Model=n.model})
   q.remaining=q.remaining-1;q.next=q.next+.35;n.pulsarUntil=n.t+.4
   if q.remaining==0 then n.pulse=nil end
  end
 elseif InvertedSilence.CanStart(n.model)and n.t>=n.nextPulsar then
  local target=M.GetMotion(f.enemy.model);local aim=target and target.position or xy(V.Head(f.enemy.model).Position)
  n.nextPulsar=n.t+15;n.pulse={remaining=3,next=n.t+.7,aim=aim};n.pulsarUntil=n.t+3.4
  effect('PowerNotice',{Model=n.model,Member='Void',Text='VOID : PULSAR !!',Duration=2})
  effect('PulsarCinematic',{Model=n.model,Duration=1.1})
  effect('VoidBladeCharge',{Model=n.model,Position=headpos(n),Radius=radius(n),Duration=.7})
 end
end
local function bladeStep(f,dt)
 for i=#(f.blades or {}),1,-1 do
  local blade=f.blades[i];local owner=blade.owner
  local finish=blade.p+blade.direction*blade.speed*math.min(dt,math.max(0,blade.remaining));local delta=finish-blade.p
  local length2=delta:Dot(delta);local hits={}
  blade.hitTargets=blade.hitTargets or {}
  if alive(owner)and not owner.assim and not f.stage then
   for _,target in ipairs(enemyModels(f))do
    if not blade.hitTargets[target]and not target:GetAttribute('DeadlyPhantom')and not target:GetAttribute('DeadlyMerged')and not target:GetAttribute('FantasticInvisible')and not target:GetAttribute('DeadlySpawning')then
     local motion=M.GetMotion(target);local center=motion and motion.position or xy(V.Head(target).Position)
     local h=V.Head(target);local radius=math.max(h.Size.X,h.Size.Y)/2+blade.width*1.9
     local offset=blade.p-center;local projection=offset:Dot(delta);local discriminant=projection*projection-length2*(offset:Dot(offset)-radius*radius)
     local hit=offset:Dot(offset)<=radius*radius and 0 or nil
     if not hit and length2>1e-9 and discriminant>=0 then local t=(-projection-math.sqrt(discriminant))/length2;if t>=0 and t<=1 then hit=t end end
     if hit then hits[#hits+1]={target=target,t=hit}end
    end
   end
  else blade.remaining=0 end
  table.sort(hits,function(a,b)return a.t<b.t end)
  for _,hit in ipairs(hits)do
   local target=hit.target;blade.hitTargets[target]=true
   local impact=blade.p+delta*hit.t
   damage(owner,target,15,'DeadlyDarkBlade')
   -- Knockback is retained only when it was present in the installed version.
   M.Knockback(target,blade.direction)
   effect('VoidBladeEnd',{Id=blade.id,Position=Vector3.new(impact.X,impact.Y,owner.depth),Hit=true,Continue=true})
  end
  blade.remaining=blade.remaining-dt;blade.p=finish
  if blade.remaining<=0 or finish.X< -30 or finish.X>30 or finish.Y<0 or finish.Y>50 then
   effect('VoidBladeEnd',{Id=blade.id});table.remove(f.blades,i)
  end
 end
end

local function activePulsar(n)
 if n.pulse then return true end
 for _,wave in ipairs(n.family.blades or {})do if wave.owner==n then return true end end
 return n.t<(n.pulsarUntil or 0)
end
-- VICE_CONCURRENT_TRANSIT_v2
M.vicePortalPairs={}
local function finishPair(pair)
 if pair.closing and not next(pair.active)then
  M.vicePortalPairs[pair.id]=nil;effect('ClosePortals',{Id=pair.id})
 end
end
function M.RequestVicePortalClose(id)
 local pair=M.vicePortalPairs[id]
 if pair then pair.closing=true;finishPair(pair)else effect('ClosePortals',{Id=id})end
end
local function releaseTransit(model,tr)
 M.viceTransits[model]=nil
 local pair=M.vicePortalPairs[tr.pairId]
 if pair then pair.active[model]=nil;finishPair(pair)end
end
local function cancelViceTransits()
 for model in pairs(M.viceTransits or{})do Gate.Resume(model,'VicePortalTransit');if model.Parent then model:SetAttribute('VicePortalTransit',false)end end
 M.viceTransits={}
 for _,pair in pairs(M.vicePortalPairs)do pair.active={};pair.closing=true;finishPair(pair)end
end
local function beginViceTransit(n,entry,portal,dest,exit,dir)
 local model=entry.model;if M.viceTransits[model]or not n.portalId then return end
 local pair=M.vicePortalPairs[n.portalId]
 if not pair then pair={id=n.portalId,active={}};M.vicePortalPairs[n.portalId]=pair end
 if pair.closing then return end
 -- Reserve exits globally: two portal owners cannot allocate the same landing area.
 local r=entry.motion and entry.motion.radius or (entry.ally and radius(entry.ally))or 1.5
 r=math.max(.25,r or 1.5)
 local function vacant(p)
  if p.X-r < -24 or p.X+r > 24 or p.Y-r < 5 or p.Y+r > 45 then return false end
  for _,other in pairs(M.viceTransits)do
   if (other.exit-p).Magnitude < r+other.radius+.15 then return false end
  end
  return true
 end
 if not vacant(exit)then
  local found
  for ring=1,5 do
   for i=0,23 do
    local angle=i*math.pi/12
    local candidate=dest+Vector2.new(math.cos(angle),math.sin(angle))*((n.portalRadius or 2)+r+.75+ring*r*2.2)
    if vacant(candidate)then found=candidate;break end
   end
   if found then break end
  end
  if not found then return end -- Full exits: actor keeps moving; no pause and no queued lock.
  exit=found;dir=(exit-dest).Unit
 end
 if M.demo and model==M.demo.target.model then M.demo.viceApproach=nil end
 local velocity=entry.motion and entry.motion.velocity or entry.ally.velocity
 local incoming=velocity.Magnitude>.001 and velocity.Unit or Vector2.new(1,0)
 dir=dir.Magnitude>.001 and dir.Unit or incoming
 local from=model:GetPivot();local depth=entry.motion and entry.motion.depth or entry.ally.depth
 local tr={pairId=pair.id,radius=r,allied=M.SameTeam(n.model,model),entry=entry,owner=n,exit=exit,direction=dir,age=0,duration=1.1,committed=false,from=from,to=CFrame.new(exit.X,exit.Y,depth)*from.Rotation}
 M.viceTransits[model]=tr;pair.active[model]=true;n.teleports[model]=n.t+4
 Gate.Resume(model,'VicePortalTransit');model:SetAttribute('VicePortalTransit',true)
 effect('VicePortalTransit',{Model=model,Owner=n.model,Id=n.portalId,Entry=Vector3.new(portal.X,portal.Y,depth),Exit=Vector3.new(dest.X,dest.Y,depth),FromCF=from,ToCF=tr.to,Direction=dir,EntryDirection=incoming,EntryIndex=(n.portals and portal==n.portals[1])and 1 or 2,StartTime=now(),Duration=tr.duration})
end
local function placeViceExit(model,tr)
 local entry=tr.entry;local direction=tr.direction
 if entry.motion then
  local motion=entry.motion;motion.position=tr.exit;motion.velocity=direction*math.max(1,model:GetAttribute('Speed')or motion.speed or 14)
 else entry.ally.p=tr.exit;entry.ally.velocity=direction end
 model:PivotTo(tr.to)
end
local function stepViceTransits(dt)
 if state:GetAttribute('GhostNightActive')or M.Flash()or now()<(state:GetAttribute('GhostFreezeUntil')or 0)then return end
 for model,tr in pairs(M.viceTransits)do
  if not model.Parent then
   Gate.Resume(model,'VicePortalTransit');if model.Parent then model:SetAttribute('VicePortalTransit',false)end;releaseTransit(model,tr)
  else
   tr.age=tr.age+dt
   if not tr.committed and tr.age>=.5 then
    tr.committed=true;placeViceExit(model,tr)
    local allied=tr.allied;local before=model:GetAttribute('Health')or 0
    if allied then SSS.CraxHeal:Fire(model,5,tr.owner.model)elseif tr.owner.model.Parent then damage(tr.owner,model,15,'DeadlyPortal')end
    task.defer(function()
     if model.Parent then
      local after=model:GetAttribute('Health')or 0;local amount=(before==math.huge or after==math.huge)and 0 or math.max(0,allied and after-before or before-after)
      effect('VicePortalResult',{Model=model,Owner=tr.owner.model,Allied=allied,Amount=amount})
     end
    end)
   end
   if tr.age>=tr.duration then
    placeViceExit(model,tr);Gate.Resume(model,'VicePortalTransit');model:SetAttribute('VicePortalTransit',false)
    tr.owner.teleports[model]=tr.owner.t+4
    effect('VicePortalExit',{Model=model,ToCF=tr.to});releaseTransit(model,tr)
   end
  end
 end
end
local viceTransitClock=game:GetService('RunService').Heartbeat:Connect(function(dt)
 if not state:GetAttribute('DeadlyDemoActive')and state:GetAttribute('Phase')~='Fighting'then if next(M.viceTransits)then cancelViceTransits()end;return end
 stepViceTransits(math.min(dt,.1))
end)

local function voidStep(n,dt)
 local f=n.family
 if n.eating then eatStep(n);return end
 if n.returningUntil then
  if n.t<n.returningUntil then return end
  n.returningUntil=nil;n.model:SetAttribute('DeadlyTransitioning',false)
 end
 if n.transformUntil then
  if n.t<n.transformUntil then return end
  n.transformUntil=nil;n.model:SetAttribute('DeadlyTransitioning',false)
  if n.assim=='Parker'then effect('Charge',{Model=n.model,Member='Parker',Duration=2.5,Color=V.Colors.Parker,Direction=n.velocity})end
 end
 if not n.assim then
  pulse(n,dt)
  if not f.warningEnd and level(f)>=2 and not n.used and not activePulsar(n)and n.t>=(n.firstPulsarAt or 0)and n.t>=(n.pulsarUntil or 0)then
   for _,a in ipairs(f.members)do if a~=n and a.name~='OG'and alive(a)and(position(a)-position(n)).Magnitude<=radius(a)+radius(n)then beginAssimilation(n,a);break end end
  end
  return
 end
 if n.t>=n.assimEnd or n.breakProtection then
 if n.assim=='Dodger'and n.breakProtection then effect('DodgerShieldBreak',{Model=n.model,Member='Dodger'})end
 n.breakProtection=nil;restoreVoid(n);return end
 if n.assim=='Domino'then
  if n.grid and n.t>=n.grid.resolve then
   local g=n.grid;n.grid=nil
   for _,model in ipairs(enemyModels(f))do local p=xy(V.Head(model).Position);local col=math.clamp(math.floor((p.X+24)/16),0,2);local row=math.clamp(math.floor((p.Y-5)/(40/3)),0,2)
    local value=g.values[row*3+col+1]
    damage(n,model,value*10,'DeadlyDice')
    effect('DominoVerdictImpact',{Model=n.model,Target=model,Value=value,Amount=value*10,Position=V.Head(model).Position})
   end
   effect('DiceHit',{Values=g.values,Model=n.model,Depth=n.depth})
  end
  if InvertedSilence.CanStart(n.model)and n.t>=n.nextGrid then
   local values={0,1,2,3,4,5,6,7,8};for i=9,2,-1 do local j=random:NextInteger(1,i);values[i],values[j]=values[j],values[i]end
   n.grid={values=values,resolve=n.t+3};n.nextGrid=n.nextGrid+8;effect('Grid',{Values=values,Duration=3,Depth=n.depth,Model=n.model})
  end
 elseif n.assim=='Vice'then
  if n.portals and f.t>=n.portalEnd then portalsClose(n);n.nextPortal=n.t+random:NextNumber(3,8)end
  if InvertedSilence.CanStart(n.model)and not n.portals and n.t>=n.nextPortal then
   local reference=workspace:FindFirstChild('Fighter1');local normalHead=reference and V.Head(reference);local r=(normalHead and normalHead.Size.X or V.Head(n.model).Size.X)*.75;n.portalRadius=r;local a=spot(r,n.depth);local b=spot(r,n.depth)
   if a and b and(a-b).Magnitude>r*3 then n.portals={a,b};n.portalReadyAt=f.t+.4;n.portalEnd=f.t+5;n.portalId=n.model.Name..'_'..tostring(n.t);n.teleports={}
    if M.demo and M.demo.waitMember=='Vice'then
     M.demo.viceApproach={owner=n,p=a}
    end
    effect('Portals',{Id=n.portalId,Model=n.model,Member='Vice',A=Vector3.new(a.X,a.Y,n.depth),B=Vector3.new(b.X,b.Y,n.depth),Radius=r,Duration=5})
   else n.nextPortal=n.t+.25 end
  end
  if n.portals and f.t>=(n.portalReadyAt or 0)then
   local list={};for _,main in ipairs(M.fighters)do list[#list+1]={model=main.model,motion=main}end
   for _,a in pairs(M.nodes)do if a.name~='OG'and alive(a)then list[#list+1]={model=a.model,ally=a}end end
   for _,entry in ipairs(list)do
    local p=entry.motion and entry.motion.position or position(entry.ally);local h=V.Head(entry.model);local r=h.Size.X/2
    if not entry.model:GetAttribute('VicePortalTransit')and not entry.model:GetAttribute('DeadlyDemoRespawning')and not entry.model:GetAttribute('DemoRespawning')and not entry.model:GetAttribute('DeadlyPhantom')and not entry.model:GetAttribute('DeadlyMerged')and n.t>=(n.teleports[entry.model]or 0)then
     for i,portal in ipairs(n.portals)do if(p-portal).Magnitude<=(n.portalRadius or radius(n)*1.5)then
      local dest=n.portals[3-i];local vel=entry.motion and entry.motion.velocity or entry.ally.velocity
      local dir=vel.Magnitude>.001 and vel.Unit or Vector2.new(1,0);local exit=dest+dir*((n.portalRadius or radius(n)*1.5)+r+.5)
      if not free(exit,r,n.depth,entry.model)then
       exit=nil
       for attempt=0,11 do
        local angle=math.atan2(dir.Y,dir.X)+attempt*math.pi/6
        local candidate=dest+Vector2.new(math.cos(angle),math.sin(angle))*((n.portalRadius or radius(n)*1.5)+r+.75)
        if candidate.X>=-24+r and candidate.X<=24-r and candidate.Y>=5+r and candidate.Y<=45-r then exit=candidate;break end
       end
      end
      if exit then
       local travel=exit-dest;local exitDir=travel.Magnitude>.001 and travel.Unit or dir
       beginViceTransit(n,entry,portal,dest,exit,exitDir)
      end
      break
     end end
    end
   end
  end
 elseif n.assim=='Stack'then
  stackUpdate(n,false)
 elseif n.assim=='Parker'and n.frenzyStarted and n.t>=(n.fireNext or 0)then
  n.fireNext=n.t+.12;f.fires[#f.fires+1]={p=position(n),expires=f.t+3,r=radius(n),owner=n};effect('FirePatch',{Position=headpos(n),Radius=radius(n),Duration=3,Model=n.model,Member='Parker'})
 end
end
local function separateContact(n,model)
 local other=M.GetMotion(model);local h=V.Head(model);if not h then return end
 local p=other and other.position or xy(h.Position);local delta=p-position(n);local dist=delta.Magnitude
 local normal=dist>.001 and delta.Unit or(n.velocity.Magnitude>.001 and n.velocity.Unit or Vector2.new(1,0))
 local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2
 local separation=normal*math.max(0,limit-dist+.035)
 local pinned=M.Hold(model)or model:GetAttribute('FantasticPinned')or(other and other.capturedBy)
 local before=position(n);put(n,before-separation*(pinned and 1 or .5))
 if n.name=='Vice'then n.orbitOffset=(n.orbitOffset or Vector2.zero)+(position(n)-before)end
 if other and not pinned then other.position=other.position+separation*.5;other.model:PivotTo(CFrame.new(other.position.X,other.position.Y,other.depth)*other.rotation)end
 local vn=n.velocity:Dot(normal);if vn>0 then n.velocity=n.velocity-normal*(2*vn)end
 if other and not pinned then local v=other.velocity;local inward=v:Dot(normal);if inward<0 then other.velocity=v-normal*(2*inward)end end
end
local function contact(n,dt)
 if n.model:GetAttribute('VicePortalTransit')then return end
 if n.model:GetAttribute('DeadlyDemoSupport')then return end
 if n.eating or n.returningUntil or n.transformUntil or(n.assim=='Parker'and n.frenzyStarted)or not alive(n)or n.model:GetAttribute('DeadlyPhantom')or Gate.Paused(n.model)then return end
 for _,model in ipairs(enemyModels(n.family))do
  local h=V.Head(model);local motion=M.GetMotion(model);local p=motion and motion.position or xy(h.Position)
  local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2;local distance=(p-position(n)).Magnitude
  local enemyNode=node(model);local blocked=model:GetAttribute('VicePortalTransit')or(enemyNode and enemyNode.assim=='Parker'and enemyNode.frenzyStarted)or model:GetAttribute('DeadlyPhantom')or model:GetAttribute('DeadlyMerged')or model:GetAttribute('DeadlySpawning')or model:GetAttribute('FantasticInvisible')or model:GetAttribute('FantasticGrabbed')or n.model:GetAttribute('FantasticGrabbed')
  if not blocked and distance<=limit then
   local fresh=not n.contacts[model];n.contacts[model]=true
   if fresh then
    contactHit(n,model)
    if not alive(n)or(state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))then return end
    if n.name=='Domino'and InvertedSilence.CanStart(n.model)then
     n.stunTargets=n.stunTargets or {};n.stunTargets[model]=n.family.t+2.5;stun(model,n.model,true)
     effect('StunImpact',{Model=model,Duration=2.5});effect('PowerNotice',{Model=n.model,Member='Domino',Text='DOMINO : CONFUSION',Duration=2.5})
    end
    local opposing=node(model)
    if opposing and opposing.name=='Domino'and InvertedSilence.CanStart(opposing.model)then opposing.stunTargets=opposing.stunTargets or {};opposing.stunTargets[n.model]=opposing.family.t+2.5;stun(n.model,opposing.model,true);effect('PowerNotice',{Model=opposing.model,Member='Domino',Text='DOMINO : CONFUSION',Duration=2.5});effect('StunImpact',{Model=n.model,Duration=2.5})end
    if not state:GetAttribute('GhostNightActive')then effect('ContactImpact',{Position=h.Position,Model=n.model,Target=model})end
    -- STACK reset is performed after the collision snapshot, for either participant.
    rebound(n)
   end
   separateContact(n,model)
  elseif blocked or distance>limit+.15 then n.contacts[model]=nil end
 end
end
local function stunStep(f)
 for _,n in ipairs(f.members)do if n.stunTargets then for model,expires in pairs(n.stunTargets)do
  if f.t>=expires or not alive(n)or not model.Parent or(model:GetAttribute('Health')or 0)<=0 then stun(model,n.model,false);n.stunTargets[model]=nil end
 end end end
end
local function nightMove(f,dt)
 for _,n in ipairs(f.members)do releaseContacts(n)
  if n~=f.og and alive(n)then
   local previous=position(n)
   if f.stage then local angle=now()*2.2;local i=table.find(f.members,n)or 1;put(n,position(f.og)+Vector2.new(math.cos(angle+i),math.sin(angle+i))*radius(f.og)*2.5)
   else
    local r=radius(n);local speed=stats[n.name][2];local p=previous+n.velocity*speed*dt
    n.velocity=Vector2.new((p.X<-24+r or p.X>24-r)and-n.velocity.X or n.velocity.X,(p.Y<5+r or p.Y>45-r)and-n.velocity.Y or n.velocity.Y)
    put(n,Vector2.new(math.clamp(p.X,-24+r,24-r),math.clamp(p.Y,5+r,45-r)))
   end
   if n.eating and n.eating.target.model.Parent then local delta=position(n)-previous;n.eating.position=n.eating.position+delta;put(n.eating.target,position(n.eating.target)+delta)end
  end
 end
end
function M.Bind(fighters)M.fighters=fighters end
local function cleanup(keepAim)
 cancelViceTransits()
 if not keepAim then for model,entry in pairs(M.aimSpawns)do finishAim(model,entry,false)end end
 for _,f in pairs(M.families)do
  flash(f,false)
  for _,n in ipairs(f.members)do
   releaseContacts(n)
   if n.name~='OG'then if M.Health then M.Health.Unregister(n.model)end;Gate.Reset(n.model);if n.model.Parent then n.model:Destroy()end end
  end
  if f.og.model.Parent then for _,key in ipairs({'DeadlyInvulnerable','DeadlyHPFrozen','DeadlyPhantom','DeadlyStage','DeadlyMerged','DeadlyShield','DeadlyFamilyBoost','DeadlyRage','DeadlyAssimilation','DeadlyTransitioning','DeadlyBeingEaten'})do f.og.model:SetAttribute(key,nil)end end
 end
 for _,main in ipairs(M.fighters)do clearAura({model=main.model},'DeadlyFusion')end
 M.families={};M.nodes={};M.cinematics={};stunSources=setmetatable({},{__mode='k'});state:SetAttribute('DeadlyFlashCount',0)
 for _,f in ipairs(M.fighters)do f.model:SetAttribute('DeadlyStunned',false);f.model:SetAttribute('DeadlySlowUntil',nil);f.model:SetAttribute('DeadlySlimeTick',nil)end
 if not keepAim then effect('Clear')end
end
local function start()
 cleanup(true)
 for i,motion in ipairs(M.fighters)do
  if motion.model:GetAttribute('CraxId')=='Crax_Deadly'and M.Health then
   local f={members={},byName={},og=nil,enemy=M.fighters[3-i],t=0,elapsed=0,nextSpawn=8,spawnIndex=1,order={'Domino','Parker','Dodger','Vice','Stack','Void'},trails={},fires={},waves={},blades={}}
   for j=5,2,-1 do local k=random:NextInteger(1,j);f.order[j],f.order[k]=f.order[k],f.order[j]end
   local n={model=motion.model,name='OG',family=f,motion=motion,depth=motion.depth,rotation=motion.rotation,baseScale=motion.model:GetScale(),contacts={},boost=false,t=0}
   f.og=n;f.members={n};f.byName.OG=n;M.families[motion.model]=f;M.nodes[motion.model]=n
  end
 end
end
function M.Step(dt,fighters)
 if M.demo and fighters~=M.demo.motions then return end
 -- VOID_DemoFix_v1
 -- Seule la boucle de démonstration peut avancer ses acteurs.
 if M.demo and fighters~=M.demo.motions then return end
 M.fighters=fighters
 local phase=state:GetAttribute('DeadlyDemoActive')and 'Fighting'or state:GetAttribute('Phase')
 if phase~=M.lastPhase then
  M.lastPhase=phase
  if phase=='Fighting'then start()
  elseif phase~='RoundOver'then cleanup()end
  if phase=='RoundOver'then M.cinematics={}
   for _,family in pairs(M.families)do flash(family,false);local vn=family.byName.Void;if vn then portalsClose(vn)end
    for _,n in ipairs(family.members)do releaseContacts(n);if n.model.Parent then n.model:SetAttribute('DeadlyMerged',false);n.model:SetAttribute('DeadlyPhantom',false);n.model:SetAttribute('DeadlyHPFrozen',false)end end
    if alive(family.og)then size(family.og,1);clearAura(family.og,'DeadlyFusion')end
   end
   for _,main in ipairs(M.fighters)do main.model:SetAttribute('DeadlyInvulnerable',false);main.model:SetAttribute('DeadlyHPFrozen',false);main.model:SetAttribute('DeadlyPhantom',false)end
   effect('Clear')
  end
  if phase=='Aiming'then for _,f in ipairs(fighters)do if f.model:GetAttribute('CraxId')=='Crax_Deadly'then beginAim(f)end end end
 end
 if phase=='Aiming'or phase=='Fighting'then aimStep(dt)end
 if phase~='Fighting'then cancelViceTransits();return end
 for _,f in pairs(M.families)do
  if not alive(f.og)then M.OnDeath(f.og.model)
  else
   f.elapsed=f.elapsed+dt
   if not f.stage and not f.pendingSpawn and not state:GetAttribute('GhostNightActive')and not M.Flash()and f.spawnIndex<=6 and f.elapsed>=f.nextSpawn-1.5 then
    if spawn(f,f.order[f.spawnIndex])then f.spawnIndex=f.spawnIndex+1;f.nextSpawn=f.spawnIndex*8 end
   end
   if state:GetAttribute('GhostNightActive')and not M.Flash()and now()>=(state:GetAttribute('GhostFreezeUntil')or 0)then nightMove(f,dt)end
   local paused=state:GetAttribute('GhostNightActive')or(state:GetAttribute('GhostFreezeUntil')or 0)>now()
   -- Own flash advances its sequence, while every other simulation is paused.
   if f.flashing or(not paused and not M.Flash())then
    f.t=f.t+dt;stunStep(f)
    if not f.stage then spawnStep(f,dt)end
    if f.t>=(f.boostAt or 0)then f.boostAt=f.t+.05;boost(f)end
    if f.warningEnd then
     if #living(f)<7 then f.warningEnd=nil;effect('FusionWarningEnd',{Model=f.og.model})
     elseif f.t>=f.warningEnd then beginFusion(f)end
    elseif not f.stage and level(f)>=3 and not f.fusionUsed and #living(f)==7 then fusionWarning(f)end
    if f.stage then if f.flashing or not Gate.Paused(f.og.model)then stage(f)else f.stageEnd=f.stageEnd+dt end
    elseif not M.Flash()then
     local vice=f.byName.Vice
     -- Node clocks advance independently from OG's stun.
     for _,n in ipairs(f.members)do if alive(n)and not Gate.Paused(n.model)then n.t=(n.t or f.t-dt)+dt end end
     if alive(vice)and InvertedSilence.CanStart(vice.model)and not Gate.Paused(vice.model)and vice.t>=vice.nextHeal then vice.nextHeal=vice.t+2.5;local before=f.og.model:GetAttribute('Health')or 0;if before>0 and before<(f.og.model:GetAttribute('MaxHealth')or 90)and not f.og.model:GetAttribute('DeadlyHPFrozen')then SSS.CraxHeal:Fire(f.og.model,5,vice.model)end end
     for _,n in ipairs(f.members)do if n.name~='OG'and alive(n)then
      if n.name=='Void'and not Gate.Paused(n.model)then voidStep(n,dt)end
      moveAlly(n,dt*M.CinematicScale());contact(n,dt)
      if state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive')then return end
     end end
    end
    familyContact(f);bladeStep(f,dt)
    for j=#f.waves,1,-1 do local w=f.waves[j];local age=f.t-w.start;local r=w.radius*math.clamp(age/w.duration,0,1)
     for _,target in ipairs(enemyModels(f))do if target.Parent and not w.hit[target]then local h=V.Head(target);local d=(xy(h.Position)-xy(w.origin)).Magnitude
      if d<=r+h.Size.X/2 and not blocked(w.origin,h.Position)then w.hit[target]=true;damage(w.owner,target,15,'DeadlyPulsar')end
     end end
     if age>=w.duration then table.remove(f.waves,j)end
    end
    -- LEVEL3_CONTACT_FIX_v2: fusion trails are visual only, never damage or slow targets.
    for j=#f.trails,1,-1 do if f.t>=f.trails[j].expires then table.remove(f.trails,j)end end
    for j=#f.fires,1,-1 do local fire=f.fires[j]
     if f.t>=fire.expires then table.remove(f.fires,j)
     end -- PARKER fire trails are visual only; BRULURE starts exclusively on enemy contact.
    end
   end
  end
 end
 for _,f in ipairs(fighters)do
  f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2
  if f.model:GetAttribute('CraxId')=='Crax_Deadly'and not M.Hold(f.model)then local speed=f.model:GetAttribute('Speed')or f.speed;if f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*speed end;f.speed=speed end
 end
end
-- Studio-only isolated showcase. Never changes player inventory or skill unlocks.
function M.StopDemo()
 local d=M.demo;if not d then return end;M.demo=nil
 if d.connection then d.connection:Disconnect()end
 cleanup()
 for _,motion in ipairs(d.motions)do if M.Health then M.Health.Unregister(motion.model)end end
 if d.detachedTarget then d.detachedTarget:Destroy()end
 if d.folder.Parent then d.folder:Destroy()end
 M.fighters=d.originalFighters;M.lastPhase=nil
 state:SetAttribute('StackDemoPart',nil);state:SetAttribute('StackDemoFinished',nil)
 state:SetAttribute('DeadlyDemoActive',false);state:SetAttribute('Phase','Waiting')
 effect('DemoSceneEnd')
end
-- Sub-stepped swept circles: Studio showcase roots use their actual visible head radii.
local function level3DemoMove(root,og,target,dt)
 local steps=math.max(1,math.ceil(dt/.0125));local sub=dt/steps
 local r=math.max(V.Head(og.model).Size.X,V.Head(og.model).Size.Y)/2
 local h=V.Head(target.model);local tr=math.max(h.Size.X,h.Size.Y)/2;local limit=r+tr
 root.contacts=root.contacts or{}
 for _=1,steps do
  local previous=og.position;local desired=previous+og.velocity*sub
  if desired.X<-24+r or desired.X>24-r then og.velocity=Vector2.new(-og.velocity.X,og.velocity.Y)end
  if desired.Y<5+r or desired.Y>45-r then og.velocity=Vector2.new(og.velocity.X,-og.velocity.Y)end
  desired=Vector2.new(math.clamp(desired.X,-24+r,24-r),math.clamp(desired.Y,5+r,45-r))
  local enabled=target.model.Parent and(target.model:GetAttribute('Health')or 0)>0 and not target.model:GetAttribute('DemoRespawning')and not target.model:GetAttribute('DeadlyDemoRespawning')and not target.model:GetAttribute('DeadlyPhantom')and not target.model:GetAttribute('VicePortalTransit')
  local entry=enabled and sweepEntry(previous,desired,target.position,limit)
  if entry then
   local impact=previous+(desired-previous)*entry;local delta=target.position-impact
   local normal=delta.Magnitude>.0001 and delta.Unit or(og.velocity.Magnitude>.0001 and og.velocity.Unit or Vector2.new(1,0))
   desired=target.position-normal*(limit+.04)
   -- At a wall choose the nearest valid separating point, never leave bodies interpenetrating.
   if desired.X<-24+r or desired.X>24-r or desired.Y<5+r or desired.Y>45-r then
    local best,distance=nil,math.huge
    for i=0,31 do
     local a=i*math.pi/16;local p=target.position+Vector2.new(math.cos(a),math.sin(a))*(limit+.04)
     if p.X>=-24+r and p.X<=24-r and p.Y>=5+r and p.Y<=45-r then local d=(p-impact).Magnitude;if d<distance then best=p;distance=d end end
    end
    if best then desired=best;normal=(target.position-best).Unit end
   end
   local toward=og.velocity:Dot(normal);if toward>0 then og.velocity=og.velocity-normal*(2*toward)end
   local incoming=target.velocity:Dot(normal);if incoming<0 then target.velocity=target.velocity-normal*(2*incoming)end
   put(root,desired)
   if not root.contacts[target.model]then
    root.contacts[target.model]=true
    contactHit(root,target.model)
    effect('ContactImpact',{Position=h.Position,Model=root.model,Target=target.model})
   end
  elseif not enabled or(desired-target.position).Magnitude>limit+.15 then root.contacts[target.model]=nil end
  put(root,desired)
 end
end

function M.StartDemo(mode)
 assert(game:GetService('RunService'):IsServer(),
  'Lance la démonstration côté Serveur.')
 local Run=game:GetService('RunService')
 assert(Run:IsStudio()and Run:IsRunning(),'La démonstration est réservée à Play dans Roblox Studio.')
 assert(M.Health,'Attends le chargement du pack.')
 if M.demo then M.StopDemo()end
 assert(state:GetAttribute('Phase')~='Fighting','Arrête le duel puis lance Play sans démarrer de combat.')
 mode=string.upper(mode or 'ASSIMILATIONS')
 local choices={ASSIMILATIONS=true,NIVEAU3=true,APPARITION=true,TOUT=true,PARKER=true,DOMINO=true,DODGER=true,VICE=true,STACK=true}
 assert(choices[mode],'Modes : ASSIMILATIONS, NIVEAU3, APPARITION, TOUT ou un nom d’allié.')
 local originals=M.fighters;cleanup()
 local group=Instance.new('Folder');group.Name='DeadlyDemonstration';group.Parent=workspace
 local base=game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase')
 local function actor(member,name,p,hp)
  local model=V.Make(base,member,.5);model.Name=name
  local h=V.Head(model);local reference=workspace:FindFirstChild('Fighter1')
local referenceHead=reference and V.Head(reference)
local width=referenceHead and referenceHead.Size.X or 6
model:ScaleTo(model:GetScale()*width/h.Size.X)
for _,part in ipairs(model:GetDescendants()) do
 if part:IsA('BasePart') then
  part.Anchored=true
  part.CanCollide=false
 end
end

  model.Parent=group;model:SetAttribute('CraxId',member=='OG'and 'Crax_Deadly'or 'DemoTarget');model:SetAttribute('AbilityId','DemoOnly')
  model:SetAttribute('MaxHealth',hp);model:SetAttribute('Health',hp);model:SetAttribute('CollisionDamage',0);model:SetAttribute('Speed',14)
  model:SetAttribute('DeadlyInvulnerable',true);model:SetAttribute('DeadlyDemoActor',true)
  local motion={model=model,head=h,position=p,depth=0,rotation=h.CFrame.Rotation,radius=math.max(h.Size.X,h.Size.Y)/2,velocity=Vector2.new(1,.4).Unit*14,speed=14,beam={Enabled=false},extraBeams={}}
  model:PivotTo(CFrame.new(p.X,p.Y,0)*motion.rotation);M.Health.Register(model);return motion
 end
 local og=actor('OG','DeadlyDemoOG',Vector2.new(-15,25),90)
 local target=actor('Dodger','Cible_Demonstration_1000_PV',Vector2.new(9,25),1000)
 target.model:SetAttribute('DeadlyDemoTarget',true)
 local f={og=nil,enemy=target,members={},byName={},t=0,elapsed=0,nextSpawn=math.huge,spawnIndex=7,order={},trails={},fires={},waves={},blades={}}
 local root={model=og.model,name='OG',family=f,motion=og,depth=og.depth,rotation=og.rotation,baseScale=og.model:GetScale(),contacts={},t=0,boost=false}
 f.og=root;f.members={root};f.byName.OG=root;og.model:SetAttribute('CraxSkillLevel',2)
 M.families={[og.model]=f};M.nodes={[og.model]=root};M.fighters={og,target};M.lastPhase='Fighting'
 state:SetAttribute('GhostNightActive',false);state:SetAttribute('GhostFreezeUntil',0);state:SetAttribute('DeadlyDemoActive',true);state:SetAttribute('Phase','Showcase')
 local queue={}
 if mode=='ASSIMILATIONS'or mode=='TOUT'then queue={'Domino','Parker','Dodger','Vice','Stack'}
 elseif mode~='NIVEAU3'and mode~='APPARITION'then queue={mode:sub(1,1)..mode:sub(2):lower()}end
 if mode=='STACK'then queue={'Stack','Stack'}end
 local d={folder=group,motions={og,target},originalFighters=originals,family=f,target=target,queue=queue,index=0,mode=mode,phase='VoidArrival',time=0}
 M.demo=d
 if mode~='NIVEAU3'and mode~='TOUT'then for _,p in ipairs(og.model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 elseif p:IsA('BillboardGui')then p.Enabled=false end end end
 assert(spawn(f,'Void'),'Impossible de placer VOID; relance la scène.')
 f.byName.Void.used=true
 effect('DemoSceneBegin',{Root=og.model,Target=target.model,Mode=mode,Void=f.byName.Void.model,Duration=0,Models={og.model,target.model}})
 local function label(text)effect('DemoSceneTitle',{Text=text})end
 label('APPARITION DE VOID • CIBLE IMMORTELLE / 1000 PV')
 local function nextScene()
  d.index=d.index+1;local name=d.queue[d.index];local void=f.byName.Void
  if name and name~='Dodger'and d.supportNodes then
   for _,n in ipairs(d.supportNodes)do
    M.Health.Unregister(n.model);Gate.Reset(n.model);M.nodes[n.model]=nil
    if f.byName[n.name]==n then f.byName[n.name]=nil end
    for i=#f.members,1,-1 do if f.members[i]==n then table.remove(f.members,i)end end
    if n.model.Parent then n.model:Destroy()end
   end
   d.supportNodes=nil;d.dodgerTestStarted=nil
  end
  if name then
   void.used=true;void.nextPulsar=math.huge;void.pulse=nil;f.blades={};void.pulsarUntil=0
   d.waitMember=name
   if name=='Dodger'then
    local pool={'Domino','Parker','Vice','Stack'}
    for i=#pool,2,-1 do local j=random:NextInteger(1,i);pool[i],pool[j]=pool[j],pool[i]end
    d.dodgerSupports={pool[1],pool[2]};d.supportIndex=1;d.supportNodes={};d.phase='DodgerSupportArrival'
    label('DODGER • DEUX ALLIÉS ALÉATOIRES')
   else
    assert(spawn(f,name),'Place insuffisante pour l’allié de démonstration.')
    if d.mode=='STACK'then f.byName[name].model:SetAttribute('DeadlyDemoSupport',true)end
    d.phase='MemberArrival';label(d.stackSolo and 'VOID × STACK • SEUL / CROISSANCE COMPLÈTE' or 'VOID × '..string.upper(name)..' • ASSIMILATION')
   end
  elseif d.mode=='NIVEAU3'or d.mode=='TOUT'then
   for i=#f.members,1,-1 do local n=f.members[i];if n.dead or not n.model.Parent then M.nodes[n.model]=nil;table.remove(f.members,i)end end
   d.phase='BuildSeven';d.buildIndex=1;d.buildOrder={'Domino','Parker','Dodger','Vice','Stack'};og.model:SetAttribute('CraxSkillLevel',2)
   label('LES 7 PÉCHÉS CAPITAUX • NIVEAU 3')
  else d.phase='Finished';label('DÉMONSTRATION TERMINÉE • ARRÊTER OU CHANGER DE MODE')end
 end
 d.connection=Run.Heartbeat:Connect(function(delta)
  if M.demo~=d then return end
  local dt=math.min(delta,.1);d.time=d.time+dt
  local t=target
  local step=dt*M.CinematicScale()
  if not d.stackSolo and not M.Flash()and not M.Hold(t.model)then
   if d.viceApproach then local delta=d.viceApproach.p-t.position;if delta.Magnitude>.05 then t.velocity=delta.Unit*14 end end
   t.position=t.position+t.velocity*step
   if t.knockback then local k=t.knockback;t.position=t.position+k.velocity*step;k.velocity=k.velocity*math.exp(-8*step);k.remaining=k.remaining-step;if k.remaining<=0 then t.knockback=nil end end
   local r=t.radius;local x,y=t.position.X,t.position.Y
   if x<-24+r or x>24-r then t.velocity=Vector2.new(-t.velocity.X,t.velocity.Y)end
   if y<5+r or y>45-r then t.velocity=Vector2.new(t.velocity.X,-t.velocity.Y)end
   t.position=Vector2.new(math.clamp(x,-24+r,24-r),math.clamp(y,5+r,45-r));t.model:PivotTo(CFrame.new(t.position.X,t.position.Y,t.depth)*t.rotation)
  end
  if now()>(target.model:GetAttribute('DeadlyDemoBurnUntil')or 0)then target.model:SetAttribute('BurningActive',false)end
  M.Step(dt,d.motions)
  if f.stage=='Form'and not M.Flash()and not state:GetAttribute('GhostNightActive')and now()>=(state:GetAttribute('GhostFreezeUntil')or 0)and not Gate.Paused(root.model)then
   level3DemoMove(root,og,target,step)
  end
  local void=f.byName.Void
  if d.mode=='STACK'then
   state:SetAttribute('StackDemoPart',d.stackSolo and 2 or 1)
   state:SetAttribute('StackDemoFinished',d.phase=='Finished')
  end
  if d.phase=='VoidArrival'and alive(void)then
   void.used=true;void.nextPulsar=math.huge
   if d.mode=='TOUT'then void.nextPulsar=void.t;d.phase='Pulsar';d.finish=d.time+7;label('VOID • PULSAR : 3 VAGUES / CIBLE MOBILE PASSIVE')
   elseif d.mode=='APPARITION'then d.phase='Pulsar';d.finish=d.time+7;label('APPARITION DE VOID • IL EST REVEILLE...')
   else nextScene()end
  elseif d.phase=='Pulsar'and d.time>=d.finish then
   void.nextPulsar=math.huge
   if d.mode=='APPARITION'then d.phase='Finished';label('APPARITION DE VOID TERMINÉE • CIBLE IMMORTELLE')else nextScene()end
  elseif d.phase=='DodgerSupportArrival'and not f.pendingSpawn then
   local name=d.dodgerSupports[d.supportIndex]
   if name then
    assert(spawn(f,name),'Impossible de placer les alliés DODGER.')
    local n=f.byName[name];n.model.Parent=d.folder;n.model:SetAttribute('DeadlyDemoSupport',true);n.model:SetAttribute('DeadlyInvulnerable',false)
    n.model:SetAttribute('DodgerTestStatus','EN ATTENTE');d.supportNodes[#d.supportNodes+1]=n;d.supportIndex=d.supportIndex+1
   else
    assert(spawn(f,'Dodger'),'Impossible de placer DODGER.')
    d.phase='MemberArrival';label('VOID × DODGER • PROTECTION DES DEUX ALLIÉS')
   end
  elseif d.phase=='MemberArrival'then
   local ally=f.byName[d.waitMember]
   if alive(ally)then
    void.used=false;void.nextPulsar=math.huge;void.pulsarUntil=0;put(ally,position(void)+Vector2.new(radius(void)+radius(ally)*.5,0))
    beginAssimilation(void,ally);d.phase='Assimilation';d.finish=d.time+(d.waitMember=='Parker'and 22 or d.waitMember=='Dodger'and 12 or d.waitMember=='Stack'and 30 or 26)
   end
  elseif d.phase=='Assimilation'then
   if d.waitMember=='Dodger'and void.assim=='Dodger'and not void.transformUntil and not d.dodgerTestStarted then
    d.dodgerTestStarted=f.t;d.dodgerTestPhase=1
   end
   if d.waitMember=='Dodger'and d.dodgerTestStarted then
    local age=f.t-d.dodgerTestStarted
    if d.dodgerTestPhase==2 and not void.assim then d.dodgerTestPhase=3 end
    if d.dodgerTestPhase==1 and age>=2 then
     for _,n in ipairs(d.supportNodes or{})do
      local before=n.model:GetAttribute('Health');SSS.BiteHit:Fire(target.model,n.model,3,false,'DodgerProtectionTest')
      task.defer(function()if n.model.Parent then
       local protected=n.model:GetAttribute('DeadlyHPFrozen')and n.model:GetAttribute('Health')==before
       n.model:SetAttribute('DodgerTestStatus',protected and 'PROTÉGÉ : PV INCHANGÉS'or 'ÉCHEC DE PROTECTION')
       print('DODGER protection',n.name,before,'->',n.model:GetAttribute('Health'),protected)
      end end)
     end
     d.dodgerTestPhase=2
    elseif d.dodgerTestPhase==2 and age>=5 and state:GetAttribute('DodgerDemoAutoImpact')==true then
     SSS.BiteHit:Fire(target.model,void.model,1,false,'DodgerShieldTest');d.dodgerTestPhase=3
    elseif d.dodgerTestPhase==3 and age>=7 and not void.assim then
     for _,n in ipairs(d.supportNodes or{})do
      local before=n.model:GetAttribute('Health');SSS.BiteHit:Fire(target.model,n.model,3,false,'DodgerReleaseTest')
      task.defer(function()if n.model.Parent then
       local released=not n.model:GetAttribute('DeadlyHPFrozen')and n.model:GetAttribute('Health')==before-3
       n.model:SetAttribute('DodgerTestStatus',released and 'LIBÉRÉ : −3 PV CONFIRMÉS'or 'ÉCHEC DE LIBÉRATION')
       print('DODGER libération',n.name,before,'->',n.model:GetAttribute('Health'),released)
      end end)
     end
     d.dodgerTestPhase=4
    end
   end
   -- DODGER remains active until an actual damaging hit requests protection break.
   if d.time>=d.finish and not void.eating and not void.assim and not void.transformUntil and not void.returningUntil then
    if d.mode=='STACK'and d.index==1 then
     d.stackSolo=true;d.detachedTarget=target.model;target.model.Parent=nil;M.Health.Unregister(target.model)
     put(void,Vector2.new(0,25));void.velocity=Vector2.new(1,.37).Unit
    end
    nextScene()
   end
  elseif d.phase=='BuildSeven'and not f.pendingSpawn then
   local name=d.buildOrder[d.buildIndex]
   if name then
    local existing=f.byName[name]
    if not alive(existing)then spawn(f,name)end
    d.buildIndex=d.buildIndex+1
   elseif #living(f)==7 then f.fusionUsed=false;og.model:SetAttribute('CraxSkillLevel',3);d.phase='Fusion' end
  elseif d.phase=='Fusion'and f.fusionUsed and not f.stage then d.phase='Finished';label('NIVEAU 3 TERMINÉ • CIBLE IMMORTELLE / 1000 PV')end
 end)
 return 'Scène '..mode..' lancée. StopDemo() pour revenir au lobby.'
end

return M
]====]}
}
local modules={
{path=[====[StarterPlayer.StarterPlayerScripts.CraxInvertedClient]====],class=[====[LocalScript]====],source=[====[-- Local presentation only. No FireServer; victims, time and health come from the server.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage')
local Run=game:GetService('RunService');local SoundService=game:GetService('SoundService')
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState')
local FX=RS:WaitForChild('CraxInvertedFX');local C=require(RS:WaitForChild('CraxInvertedConfig'))
local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local mobile=game:GetService('UserInputService').TouchEnabled
local low=C.Quality=='Low'or(C.Quality=='Auto'and mobile)
local folder=Instance.new('Folder');folder.Name='InvertedCrax_LocalFX';folder.Parent=workspace
local connections={};local effects={};local statuses={};local marks={};local sounds={};local scene;local alive=true
local random=Random.new();local elapsed=0;local poll=0;local nextSceneRound
local WHITE=Color3.fromRGB(244,242,232);local BLACK=Color3.fromRGB(12,13,18)
local function connect(signal,fn)local c=signal:Connect(fn);connections[#connections+1]=c;return c end
local function make(kind,props,parent)local o=Instance.new(kind);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local config=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37')
 local f=config and id and config:FindFirstChild('Frame_'..id)
 return f and f.Value or CFrame.identity
end
local function head(m)
 local p=m and m:FindFirstChild('Head',true)
 if p and not p:IsA('BasePart')then p=p:FindFirstChildWhichIsA('BasePart',true)end
 return p
end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function part(parent,size,color,cf)
 return make('Part',{Size=size,Color=color,CFrame=cf or CFrame.identity,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic},parent)
end
local function sound(name,at,cinematic)
 local id=C.Sounds[name]
 if type(id)~='string'or not id:match('^rbxassetid://%d+$')then return end
 local anchor=part(folder,Vector3.one*.05,BLACK,CFrame.new(at));anchor.Transparency=1
 local s=make('Sound',{SoundId=id,Volume=cinematic and C.CinematicVolume or C.CombatVolume,RollOffMinDistance=C.RollOffMinDistance,RollOffMaxDistance=C.RollOffMaxDistance},anchor)
 local group=SoundService:FindFirstChild('CraxMusicControl');if cinematic and group and group:IsA('SoundGroup')then s.SoundGroup=group end
 s:Play();sounds[#sounds+1]={object=s,anchor=anchor,born=os.clock(),cinematic=cinematic}
end
local function cross(parent,where,size)
 local m=make('Model',{},parent)
 for _,angle in ipairs({45,-45})do local p=part(m,Vector3.new(size*.15,size,.055),WHITE,where*CFrame.Angles(0,0,math.rad(angle)));p.Name='CrossStroke'end
 return m
end
local function add(duration,update,cleanup)
 effects[#effects+1]={born=os.clock(),duration=duration,update=update,cleanup=cleanup}
end
local function ring(at,radius,duration)
 local count=low and 24 or 48;local pieces={};local origin=frame()*CFrame.new(at)
 for i=1,count do
  pieces[i]=part(folder,Vector3.new(.12,.12,.07),i%5==0 and BLACK or WHITE,origin)
 end
 add(duration,function(t)
  local r=radius*math.min(1,t/duration)
  for i,p in ipairs(pieces)do
   local a=i/count*math.pi*2
   p.Size=Vector3.new(.12,math.max(.12,2*math.pi*r/count*.72),.07)
   p.CFrame=origin*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)*CFrame.Angles(0,0,a)
   p.Transparency=math.clamp((t/duration-.7)/.3,0,1)
  end
 end,function()for _,p in ipairs(pieces)do p:Destroy()end end)
end
local function bits(at,count,duration,inward)
 local origin=frame()*CFrame.new(at);local pieces={};local offsets={}
 for i=1,(low and math.min(count,16)or count)do
  local a=random:NextNumber(0,math.pi*2);local r=random:NextNumber(.5,3)
  offsets[i]=Vector3.new(math.cos(a)*r,math.sin(a)*r,random:NextNumber(-.4,.4))
  pieces[i]=part(folder,Vector3.one*random:NextNumber(.08,.23),i%2==0 and WHITE or BLACK,origin)
 end
 add(duration,function(t)
  local u=math.clamp(t/duration,0,1)
  for i,p in ipairs(pieces)do p.CFrame=origin*CFrame.new(offsets[i]*(inward and(1-u)or(.2+u)))*CFrame.Angles(u*i,u,0);p.Transparency=u*u end
 end,function()for _,p in ipairs(pieces)do p:Destroy()end end)
end
local function clone(model,cf)
 local archivable=model.Archivable;model.Archivable=true;local ok,m=pcall(function()return model:Clone()end);model.Archivable=archivable
 if not ok or not m then return end
 for _,o in ipairs(m:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 m.Parent=folder;m:PivotTo(cf);return m
end
local function ghost(model,cf,duration)
 local m=clone(model,cf);if not m then return end
 local p={};for _,o in ipairs(m:GetDescendants())do if o:IsA('BasePart')then p[o]=o.Transparency;o.Color=WHITE end end
 add(duration,function(t)for o,base in pairs(p)do o.Transparency=base+(1-base)*(.65+.35*t/duration)end end,function()m:Destroy()end)
end
local function clearMark(m)
 local r=marks[m];if r then r.object:Destroy();marks[m]=nil end
end
local function stopScene()
 if not scene then return end
 local s=scene;scene=nil
 Run:UnbindFromRenderStep('Inverted404Camera')
 for p,value in pairs(s.hidden)do if p.Parent then p.LocalTransparencyModifier=value end end
 for gui,value in pairs(s.hiddenguis)do if gui.Parent then gui.Enabled=value end end
 if s.camera and s.camera==workspace.CurrentCamera then
  s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus
 end
 s.folder:Destroy();s.gui:Destroy();if s.color then s.color:Destroy()end
 for i=#sounds,1,-1 do if sounds[i].cinematic then sounds[i].anchor:Destroy();table.remove(sounds,i)end end
end
local function clear()
 stopScene()
 for _,e in ipairs(effects)do e.cleanup()end;table.clear(effects)
 for m in pairs(marks)do clearMark(m)end
 for m,r in pairs(statuses)do r.gui:Destroy();r.anchor:Destroy();statuses[m]=nil end
 for _,s in ipairs(sounds)do s.anchor:Destroy()end;table.clear(sounds)
end
local function status(m)
 local h=head(m);if not h then return end
 local anchor=part(folder,Vector3.one*.05,BLACK,frame()*h.CFrame);anchor.Transparency=1
 local billboard=make('BillboardGui',{Name='InvertedStatus',AlwaysOnTop=false,Size=UDim2.fromOffset(180,54),StudsOffsetWorldSpace=Vector3.new(0,h.Size.Y*.5+2,0),MaxDistance=160,Adornee=anchor},folder)
 local text=make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=17,TextColor3=WHITE,TextStrokeTransparency=.15,TextWrapped=true},billboard)
 local x=cross(anchor,frame()*CFrame.new(h.Position+Vector3.new(h.Size.X*.4,h.Size.Y*.25,-h.Size.Z*.5-.2)),.9)
 local icon=make('ImageLabel',{Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(-26,12),BackgroundTransparency=1,Image=C.SilenceIcon,Visible=C.SilenceIcon~=''},billboard)
 statuses[m]={gui=billboard,text=text,icon=icon,anchor=anchor,cross=x}
end
local function beginScene()
 if state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='Inverted404'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local round=state:GetAttribute('RoundId');if nextSceneRound==round or scene then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or '')
 if not winner or winner:GetAttribute('CraxId')~='Crax_Inverted'or(winner:GetAttribute('CraxSkillLevel')or 0)<4 then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1')
 if not loser or not head(loser)or not head(winner)then return end
 local cam=workspace.CurrentCamera;if not cam then return end
 -- Avoid taking the camera of a distant player who is not watching this arena.
 if player:GetAttribute('ArenaSeat')==nil then local ch=player.Character;local hr=ch and ch:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-position(winner)).Magnitude>180 then return end end
 nextSceneRound=round
 local s={folder=make('Folder',{Name='Inverted404'},folder),hidden={},camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,round=round,played={},winner=winner,loser=loser,hiddenguis={}}
 s.gui=make('ScreenGui',{Name='Inverted404Gui',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=180},player:WaitForChild('PlayerGui'))
 s.caption=make('TextLabel',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.8),Size=UDim2.fromScale(.9,.13),BackgroundTransparency=1,Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=WHITE,TextStrokeTransparency=.05,Text='404 — CRAX NOT FOUND',Visible=false},s.gui)
 s.color=make('ColorCorrectionEffect',{Name='Inverted404_LocalMonochrome',Saturation=-1,Contrast=.08,Brightness=0},cam)
 s.start=state:GetAttribute('RoundVictoryStartedAt')or workspace:GetServerTimeNow()
 local f=frame();s.winCF=f*winner:GetPivot();s.loseCF=f*loser:GetPivot();s.center=(f*head(loser).CFrame).Position
 s.actor=clone(winner,s.winCF);s.victim=clone(loser,s.loseCF)
 if not s.actor or not s.victim then s.folder:Destroy();s.gui:Destroy();s.color:Destroy();if s.actor then s.actor:Destroy()end;if s.victim then s.victim:Destroy()end;return end
 s.actor.Parent=s.folder;s.victim.Parent=s.folder
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hiddenguis[p]=p.Enabled;p.Enabled=false end end end
 s.x=cross(s.folder,CFrame.new(s.center+Vector3.new(0,0,3)),18)
 s.cubes={}
 for i=1,(low and 24 or 56)do
  local off=Vector3.new(random:NextNumber(-3,3),random:NextNumber(-3,3),random:NextNumber(-2,2))
  local p=part(s.folder,Vector3.one*random:NextNumber(.18,.58),i%2==0 and BLACK or WHITE,CFrame.new(s.center+off));p.Transparency=1
  s.cubes[i]={p=p,offset=off,seed=random:NextNumber()}
 end
 scene=s
 Run:BindToRenderStep('Inverted404Camera',Enum.RenderPriority.Last.Value+1000,function()
  if scene~=s then return end
  if state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=s.round or not winner.Parent or not loser.Parent or workspace.CurrentCamera~=cam then stopScene();return end
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration then stopScene();return end
  local steps={{0,'MaxRise'},{2,'MaxLoop'},{4,'MaxFragment'},{6,'MaxSuction'},{8,'MaxClose'}}
  for _,entry in ipairs(steps)do if t>=entry[1]and not s.played[entry[2]]then s.played[entry[2]]=true;sound(entry[2],s.center,true)end end
  local xScale=t<1 and math.max(.02,t)or(t>8 and math.max(.001,1-(t-8)*2)or 1)
  for _,p in ipairs(s.x:GetChildren())do if p:IsA('BasePart')then p.Size=Vector3.new(2.7*xScale,18*xScale,.055);p.Transparency=math.clamp((t-8.3)*2,0,1)end end
  s.victim:PivotTo(s.loseCF*CFrame.new(math.sin(t*7)*.23,0,0))
  -- Head-only character: a restrained head inclination replaces the obsolete hand gesture.
  s.actor:PivotTo(s.winCF*CFrame.Angles(0,0,math.sin(math.clamp((t-3.3)*2,0,math.pi))*.09))
  local dissolve=math.clamp((t-4)/2,0,1)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=dissolve end end
  for _,c in ipairs(s.cubes)do
   local u=math.clamp((t-4-c.seed*.6)/3.8,0,1)
   c.p.Transparency=(t<4 or t>8.4)and 1 or math.clamp((u-.85)/.15,0,1)
   c.p.CFrame=CFrame.new(s.center+c.offset*(1-u)^2+Vector3.new(0,0,3*u))*CFrame.Angles(t*c.seed,t,0)
  end
  if t>1.6 and t<4 and not low then
   local interval=math.floor(t*3)
   if s.lastGhost~=interval then s.lastGhost=interval;ghost(loser,s.loseCF*CFrame.new(math.sin(t*8)*.6,0,0),.45)end
  end
  s.caption.Visible=t>=8.25
  local target=t<8 and s.center or(s.winCF*winner:GetPivot():ToObjectSpace(head(winner).CFrame)).Position
  local distance=t<8 and 23 or 14
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=40
  cam.CFrame=CFrame.lookAt(target+Vector3.new(math.sin(t*.15)*3,1,-distance),target);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.RoundId~=state:GetAttribute('RoundId')then return end
 local at=d.Position or(d.Owner and head(d.Owner)and head(d.Owner).Position)
 if kind=='Mute'and at then ring(at,d.Radius,.55);sound('MuteTrigger',(frame()*CFrame.new(at)).Position)
 elseif kind=='Silence'and at then if d.Owner and not statuses[d.Owner]then status(d.Owner)end;sound('SilenceApply',(frame()*CFrame.new(at)).Position);if d.Hack then sound('HackActivate',(frame()*CFrame.new(at)).Position)end
 elseif kind=='SilenceEnd'and at then sound('SilenceEnd',(frame()*CFrame.new(at)).Position)
 elseif kind=='HackTurn'and at then bits(at,4,.18,false);sound('HackDirection0'..tostring(d.Variant),(frame()*CFrame.new(at)).Position)
 elseif kind=='Capture'and at then bits(at,14,.4,true);sound('CopyCapture',(frame()*CFrame.new(at)).Position)
 elseif kind=='CopyImpact'and at then bits(at,16,.35,false);sound('CopyImpact',(frame()*CFrame.new(at)).Position)
 elseif kind=='Mark'and at then
  if not d.Owner or not d.Owner.Parent then return end
  clearMark(d.Owner);local object=cross(folder,frame()*CFrame.new(at),1.2)
  local frozen={}
  for i=1,(low and 4 or 8)do local a=i*math.pi/4;frozen[i]=part(object,Vector3.one*.13,i%2==0 and WHITE or BLACK,frame()*CFrame.new(at+Vector3.new(math.cos(a),math.sin(a),0)*1.15))end
  marks[d.Owner]={object=object,position=at,born=Clock.Time(d.Owner),frozen=frozen};sound('RewindMark',(frame()*CFrame.new(at)).Position);bits(at,10,.5,false)
 elseif kind=='Cancel'then clearMark(d.Owner);if at then sound('MarkCancel',(frame()*CFrame.new(at)).Position)end
 elseif kind=='Restore'and at then
  clearMark(d.Owner);sound('TeleportDepart',(frame()*CFrame.new(d.From)).Position);sound('TeleportArrive',(frame()*CFrame.new(at)).Position)
  ring(at,5,.4);bits(at,18,.55,true)
  local strips={};local start=frame()*CFrame.new(d.From)
  for i=1,6 do strips[i]=part(folder,Vector3.new(7,.38,.045),i%2==0 and WHITE or BLACK,start*CFrame.new(0,(i-3.5)*.9,-4.05))end
  add(.28,function(t)for i,p in ipairs(strips)do local u=t/.28;p.Size=Vector3.new(math.max(.03,7*(1-u)),.38,.045);p.CFrame=start*CFrame.new(0,(i-3.5)*.9*(1-u),-4.05);p.Transparency=u end end,function()for _,p in ipairs(strips)do p:Destroy()end end)
  if d.Owner and not low then
   local rotation=d.Owner:GetPivot().Rotation
   ghost(d.Owner,frame()*CFrame.new(d.From:Lerp(at,.33))*rotation,.33)
   ghost(d.Owner,frame()*CFrame.new(d.From:Lerp(at,.66))*rotation,.25)
  end
  if d.Owner and not low then ghost(d.Owner,frame()*CFrame.new(d.From)*d.Owner:GetPivot().Rotation,.45)end
 end
end)
connect(state:GetAttributeChangedSignal('RoundId'),function()clear();nextSceneRound=nil end)
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then
 for m in pairs(marks)do clearMark(m)end
 for m,r in pairs(statuses)do r.gui:Destroy();r.anchor:Destroy();statuses[m]=nil end
 if state:GetAttribute('Phase')~='RoundOver'then clear()end
 end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryKind','RoundVictoryRound','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(Run.Heartbeat,function(dt)
 elapsed=elapsed+dt;poll=poll+dt;if elapsed<(low and 1/20 or 1/30)then return end;elapsed=0
 local now=os.clock()
 for m,r in pairs(statuses)do local h=head(m);if h and m.Parent then
 r.anchor.CFrame=frame()*h.CFrame
 local cf=frame()*CFrame.new(h.Position+Vector3.new(h.Size.X*.4,h.Size.Y*.25,-h.Size.Z*.5-.2))
 for i,p in ipairs(r.cross:GetChildren())do if p:IsA('BasePart')then p.CFrame=cf*CFrame.Angles(0,0,math.rad(i==1 and 45 or -45));p.Transparency=m:GetAttribute('InvertedSilenced')and .08 or 1 end end
 end end
 for i=#effects,1,-1 do local e=effects[i];local age=now-e.born;if age>=e.duration then e.cleanup();table.remove(effects,i)else e.update(age)end end
 for i=#sounds,1,-1 do local s=sounds[i];if now-s.born>20 or(now-s.born>1 and not s.object.IsPlaying)then s.anchor:Destroy();table.remove(sounds,i)end end
 for m,r in pairs(marks)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 then clearMark(m)
  else
   local remaining=m:GetAttribute('InvertedCtrlRemaining')
   local age=type(remaining)=='number'and(10-remaining)or(Clock.Time(m)-r.born)
   for _,p in ipairs(r.object:GetChildren())do if p:IsA('BasePart')and p.Name=='CrossStroke'then p.Transparency=.16+.10*math.sin(age*2);p.Size=Vector3.new(.18,1.2*math.min(1,age*4),.055)end end
   if age>=8 and not r.sound then r.sound=true;sound('RewindBuild',(frame()*CFrame.new(r.position)).Position);bits(r.position,10,.6,true)end
  end
 end
 if poll>=.15 then poll=0
  local targets={};for i=1,2 do local m=workspace:FindFirstChild('Fighter'..i);if m then targets[#targets+1]=m end end
  -- Events also register summoned victims; scans are limited to tracked models plus the two roots.
  for m in pairs(statuses)do if not table.find(targets,m)then targets[#targets+1]=m end end
  for _,m in ipairs(targets)do
   local silence=m:GetAttribute('InvertedSilenced');local count=m:GetAttribute('InvertedCopyCount')
   local visible=m.Parent~=nil and state:GetAttribute('Phase')=='Fighting'and(m:GetAttribute('Health')or 0)>0 and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('DeadlyPhantom')
   if visible and(silence or count~=nil)then
    if not statuses[m]then status(m)end
    local r=statuses[m]
    if r then
     local ready=m:GetAttribute('InvertedCopyReady');local amount=m:GetAttribute('InvertedCopyAmount')or 8
     r.text.Text=(silence and '× SILENCE'or'')..(m:GetAttribute('InvertedHacked')and'  ▦ PIRATÉ'or'')..(count~=nil and('\n'..(ready and(amount>8 and('COPIE : '..amount)or'COPIE PRÊTE : 8')or('COPIE '..count..'/3')))or'')
     r.icon.Visible=silence==true and C.SilenceIcon~=''
    end
   elseif statuses[m]then statuses[m].gui:Destroy();statuses[m].anchor:Destroy();statuses[m]=nil end
  end
 end
end)
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()alive=false;clear();for _,c in ipairs(connections)do c:Disconnect()end;folder:Destroy()end)
task.defer(beginScene)
]====]},
{path=[====[ReplicatedStorage.CraxInvertedConfig]====],class=[====[ModuleScript]====],source=[====[local C={Id='Crax_Inverted',AbilityId='InvertedMute',SilenceIcon='',Quality='Auto',FinaleDuration=10.5,
 -- The reference speed and upgrade prices are read from existing catalogs, never hardcoded.
 RefreshPolicy='REFRESH_WITHOUT_STACKING',SilencedAtCtrlMark='SKIP_THIS_ROUND',
 Sounds={},CombatVolume=.16,CinematicVolume=.22,RollOffMinDistance=8,RollOffMaxDistance=110}
for _,name in ipairs({'MuteTrigger','SilenceApply','SilenceEnd','HackActivate','HackDirection01','HackDirection02','HackDirection03','CopyCapture','CopyImpact','RewindMark','RewindBuild','TeleportDepart','TeleportArrive','MarkCancel','MaxRise','MaxLoop','MaxFragment','MaxSuction','MaxClose'})do C.Sounds[name]=''end
local assets=game:GetService('ReplicatedStorage'):FindFirstChild('CraxInvertedUserAssets')
if assets then
 for name in pairs(C.Sounds)do local id=assets:GetAttribute(name);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Sounds[name]=id end end
 local icon=assets:GetAttribute('SilenceIcon');if type(icon)=='string'and icon:match('^rbxassetid://%d+$')then C.SilenceIcon=icon end
end
return C
]====]},
{path=[====[ReplicatedStorage.CraxInvertedPalette]====],class=[====[ModuleScript]====],source=[====[-- Apply only to a cloned template or the existing live rig. Preserve all node/pivot names.
local P={};local snapshots=setmetatable({},{__mode='k'})
function P.Restore(model)
 local saved=snapshots[model];if not saved then return end
 for part,s in pairs(saved)do if part.Parent then
  part.Color=s.color;part.Material=s.material;part.Reflectance=s.reflectance
  if part:IsA('MeshPart')then part.TextureID=s.texture end
  for _,child in ipairs(part:GetChildren())do if child:IsA('SurfaceAppearance')then child:Destroy()end end
  for _,appearance in ipairs(s.appearances)do appearance:Clone().Parent=part end
 end end
 snapshots[model]=nil
end
function P.Apply(model)
 P.Restore(model);local saved={};snapshots[model]=saved
 for _,part in ipairs(model:GetDescendants())do if part:IsA('BasePart')then
  local s={color=part.Color,material=part.Material,reflectance=part.Reflectance,texture=part:IsA('MeshPart')and part.TextureID or '',appearances={}}
  for _,child in ipairs(part:GetChildren())do if child:IsA('SurfaceAppearance')then s.appearances[#s.appearances+1]=child:Clone();child:Destroy()end end
  saved[part]=s
  local n=part.Name:lower();local ivory=n=='eyeleft'or n=='eyeright'or n:find('gums',1,true)or n:find('cross',1,true)
  part.Color=ivory and Color3.fromRGB(242,239,226)or Color3.fromRGB(9,11,14)
  part.Material=Enum.Material.SmoothPlastic;part.Reflectance=.035
  if part:IsA('MeshPart')then part.TextureID=''end
 end end
end
return P
]====]},
{path=[====[ReplicatedStorage.CraxInvertedRules]====],class=[====[ModuleScript]====],source=[====[-- Deterministic server rules; no Roblox services or client-supplied decisions.
local R={}
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<math.huge end
function R.Round(v)assert(finite(v)and v>=0);return math.floor(v+.5)end
function R.New(round,identity,level,random)
 assert(type(random)=='function')
 local wait=random(5,9);assert(wait>=5 and wait<=9)
 return {round=round,identity=identity,level=math.clamp(level,0,4),time=0,nextMute=wait,count=0,pending=nil,mark=nil,markAttempted=false,returned=false,alive=true}
end
function R.Received(r,amount,melee)
 if not r.alive or r.level<2 or not melee or not finite(amount)or amount<=0 or r.pending~=nil then return false end
 r.count=r.count+1
 if r.count==3 then r.pending=amount;return true end
 return false
end
function R.Base(r)return r and r.alive and r.pending~=nil and math.max(8,r.pending)or 8 end
function R.Consume(r,lost,melee)
 if r and r.alive and melee and lost>0 and r.pending~=nil then r.pending=nil;r.count=0;return true end
 return false
end
function R.Damage(amount,vulnerable)
 assert(finite(amount)and amount>=0)
 if amount==0 then return 0 end
 return R.Round(amount*(vulnerable and 1.10 or 1))
end
function R.Cancel(r)r.alive=false;r.mark=nil;r.pending=nil;r.count=0 end
-- Silenced at t=10 => the single marking opportunity is lost, never delayed.
-- A mark already placed always returns even if subsequently silenced.
function R.Advance(r,dt,context,random)
 assert(finite(dt)and dt>=0)
 local e={}
 if not r.alive then return e end
 if context.round~=r.round or context.identity~=r.identity or not context.alive then
  e.cancel=r.mark~=nil;R.Cancel(r);return e
 end
 if not context.active or context.paused then return e end
 local before=r.time;r.time=r.time+dt
 if r.level>=3 and not r.markAttempted and r.time>=10-1e-8 then
  r.markAttempted=true
  if not context.silenced then
   r.mark={position=context.position,health=context.health};e.mark=r.mark
  else e.markSkipped=true end
 end
 if r.mark and not r.returned and r.time>=20-1e-8 then
  r.returned=true;e.restore=r.mark;r.mark=nil
 end
 if r.time>=r.nextMute and not context.silenced then
  e.mute=true
  local wait=random(5,9);assert(wait>=5 and wait<=9)
  r.nextMute=r.time+wait
 end
 return e
end
function R.ApplyStatus(s,time,hack)
 s=s or {};s.silence=math.max(s.silence or 0,time+5)
 if hack then
  s.vulnerable=math.max(s.vulnerable or 0,time+5)
  s.hack=math.max(s.hack or 0,time+4)
  s.nextDirection=time
 end
 return s
end
return R
]====]},
{path=[====[ServerScriptService.CraxInvertedRuntime]====],class=[====[ModuleScript]====],source=[====[local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local Rules=require(RS:WaitForChild('CraxInvertedRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxInvertedFX')
local rng=Random.new();local M={};local records={};local statuses={};local time=0;local round;local serial=0
local function random(a,b)return rng:NextNumber(a,b)end
local function emit(kind,data)data=data or {};data.RoundId=state:GetAttribute('RoundId');FX:FireAllClients(kind,data)end
local function attrs(model,s)
 model:SetAttribute('InvertedSilenced',s and s.silence>time or nil)
 model:SetAttribute('InvertedVulnerable',s and(s.vulnerable or 0)>time or nil)
 model:SetAttribute('InvertedHacked',s and(s.hack or 0)>time or nil)
end
local function live(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function publish(m,r)
 m:SetAttribute('InvertedCopyCount',r and r.count or nil)
 m:SetAttribute('InvertedCopyReady',r and r.pending~=nil or nil)
 m:SetAttribute('InvertedCopyAmount',r and r.pending and math.max(8,r.pending)or nil)
end
function M.Reset()
 for m,r in pairs(records)do if r.mark then emit('Cancel',{Owner=m})end;Rules.Cancel(r);publish(m,nil);m:SetAttribute('InvertedCtrlRemaining',nil)end
 for m in pairs(statuses)do if m.Parent then attrs(m,nil)end end
 records={};statuses={};time=0;round=state:GetAttribute('RoundId')
end
function M.Begin(fighters)
 M.Reset()
 for _,f in ipairs(fighters)do if f.model:GetAttribute('CraxId')=='Crax_Inverted'then
  require(SSS:WaitForChild('CraxSkillResolver')).Resolve(f.model)
  serial=serial+1;records[f.model]=Rules.New(round,f.model,f.model:GetAttribute('CraxSkillLevel')or 0,random)
  publish(f.model,records[f.model])
 end end
end
function M.Melee(m,normal)if normal==0 then return 0 end;local r=records[m];return r and Rules.Base(r)or normal end
function M.RawInput(attacker,target,amount)
 local s=statuses[target]
 if records[attacker]or records[target]or(s and(s.vulnerable or 0)>time)then return amount end
 return math.floor(amount+.5)
end
function M.Vulnerable(target,amount)
 local s=statuses[target]
 return amount*((s and(s.vulnerable or 0)>time)and 1.10 or 1)
end
function M.Final(target,amount,attacker)
 local s=statuses[target];local vulnerable=s and(s.vulnerable or 0)>time
 if vulnerable or records[attacker]or records[target]then return Rules.Round(amount)end
 return amount
end
function M.Confirm(a,b,lost,recoil,collision)
 if not collision then return end
 local ra,rb=records[a],records[b]
 -- Both outgoing copies are consumed before either simultaneous received-hit counter advances.
 if ra and Rules.Consume(ra,lost,true)then emit('CopyImpact',{Owner=a,Target=b,Amount=lost})end
 if rb and Rules.Consume(rb,recoil,true)then emit('CopyImpact',{Owner=b,Target=a,Amount=recoil})end
 if rb and live(b)and Rules.Received(rb,lost,true)then emit('Capture',{Owner=b,Amount=rb.pending,Boosted=rb.pending>8})end
 if ra and live(a)and Rules.Received(ra,recoil,true)then emit('Capture',{Owner=a,Amount=ra.pending,Boosted=ra.pending>8})end
 if ra then publish(a,ra)end;if rb then publish(b,rb)end
end
local function eligible(m)
 return live(m)and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('DeadlyPhantom')and not m:GetAttribute('DeadlyInvulnerable')and not m:GetAttribute('GhostInvulnerable')and not m:GetAttribute('PlumberInTransit')and not m:GetAttribute('VicePortalTransit')and not m:GetAttribute('GoldenStatue')and not m:GetAttribute('FleauFury')and workspace:GetServerTimeNow()>=(m:GetAttribute('GhostDodgeUntil')or 0)and workspace:GetServerTimeNow()>=(m:GetAttribute('PlumberStarUntil')or 0)
end
local function width()
 local l=workspace:FindFirstChild('Arenaleft');local r=workspace:FindFirstChild('ArenaRight')
 assert(l and r and l:IsA('BasePart')and r:IsA('BasePart'),'MUTE : limites canoniques introuvables')
 return math.abs((r.Position.X-r.Size.X/2)-(l.Position.X+l.Size.X/2))
end
local function blocked(f)
 local m=f.model
 return (m:GetAttribute('FleauMode')~=nil and m:GetAttribute('FleauMode')~='Normal')or Gate.Paused(m)or Deadly.Hold(m)or f.capturedBy~=nil or m:GetAttribute('GoldenStatue')or m:GetAttribute('GoldenCharging')or m:GetAttribute('FantasticPinned')or m:GetAttribute('FantasticGrabbed')or m:GetAttribute('FleauStunned')or m:GetAttribute('DeadlyStunned')or m:GetAttribute('PlumberInTransit')or m:GetAttribute('VicePortalTransit')or workspace:GetServerTimeNow()<(m:GetAttribute('GhostTeleportUntil')or 0)
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if next(records)or next(statuses)then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')then M.Begin(fighters)end
 if not enabled then return end
 time=time+dt
 local motions=Deadly.MotionTargets(fighters)
 for m,s in pairs(statuses)do
  if not live(m)then attrs(m,nil);statuses[m]=nil
  else
   local was=m:GetAttribute('InvertedSilenced');attrs(m,s)
   if was and not m:GetAttribute('InvertedSilenced')then emit('SilenceEnd',{Owner=m})end
   if(s.hack or 0)>time and time>=s.nextDirection then
    s.nextDirection=s.nextDirection+1
    for _,f in ipairs(motions)do if f.model==m and not blocked(f)then
     local speed=f.velocity.Magnitude
     if speed>1e-6 then local a=rng:NextNumber(0,2*math.pi);f.velocity=Vector2.new(math.cos(a),math.sin(a))*speed;emit('HackTurn',{Owner=m,Variant=rng:NextInteger(1,3)})end
     break
    end end
   end
   if s.silence<=time and(s.hack or 0)<=time and(s.vulnerable or 0)<=time then statuses[m]=nil end
  end
 end
 for _,f in ipairs(fighters)do
  local r=records[f.model]
  if r then
   local e=Rules.Advance(r,dt,{round=round,identity=f.model,alive=live(f.model),active=true,paused=Gate.Paused(f.model),silenced=not Silence.CanStart(f.model),position=f.position,health=f.model:GetAttribute('Health')},random)
   local remaining=r.mark and math.ceil(math.max(0,20-r.time)*10)/10 or nil
   if r.lastRemaining~=remaining then r.lastRemaining=remaining;f.model:SetAttribute('InvertedCtrlRemaining',remaining)end
   if e.cancel then emit('Cancel',{Owner=f.model})end
   if not r.alive then publish(f.model,nil);records[f.model]=nil
   else
    if e.mark then emit('Mark',{Owner=f.model,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Duration=10})end
    if e.restore and M.SetHealth then
     local from=Vector3.new(f.position.X,f.position.Y,f.depth)
     f.position=e.restore.position
     f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth)*f.rotation)
     M.SetHealth(f.model,e.restore.health,round)
     emit('Restore',{Owner=f.model,From=from,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Health=e.restore.health})
    end
    if e.mute then
     local radius=width()/2
     emit('Mute',{Owner=f.model,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Radius=radius})
     for _,target in ipairs(motions)do local m=target.model
      if m~=f.model and eligible(m)and not Deadly.SameTeam(f.model,m)and(target.position-f.position).Magnitude<=radius then
       statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);attrs(m,statuses[m])
       emit('Silence',{Owner=m,Hack=r.level>=1,Duration=5})
      end
     end
    end
   end
  end
 end
end
return M
]====]},
{path=[====[ReplicatedStorage.CraxSilenceGate]====],class=[====[ModuleScript]====],source=[====[-- Check only at NEW activation sites, never in simulation/damage continuation.
local G={}
function G.CanStart(model)
 return model~=nil and model.Parent~=nil and model:GetAttribute('InvertedSilenced')~=true
end
return G
]====]}
}

local previous=storage:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('InvertedOwned')==true,'Sauvegarde de même nom non reconnue.')
 for _,r in ipairs(patches)do local o=resolve(r.path);assert(o and o.Source==r.source,'Installation existante modifiée : aucune mise à jour automatique.')end
 for _,r in ipairs(modules)do local o=resolve(r.path);assert(o and o.Source==r.source,'Module existant modifié : aucune mise à jour automatique.')end
 print('InvertedCrax déjà installé, aucun doublon.');return
end
for _,r in ipairs(patches)do
 local o=resolve(r.path);assert(o and o:IsA('LuaSourceContainer'),'Source absente : '..r.path)
 local s=o.Source;assert(#s==r.bytes and hash(s)==r.hash,'Source différente de l’export analysé : '..r.path..'. Aucun fichier modifié ; fournir le script actuel.')
end
for _,r in ipairs(modules)do assert(not resolve(r.path),'Nom déjà utilisé : '..r.path)end
assert(not RS:FindFirstChild('CraxInvertedFX'),'Remote déjà présent et non reconnu.')
local templates=assert(storage:FindFirstChild('CraxTemplates'),'CraxTemplates absent')
local base=assert(templates:FindFirstChild('Crax_Monster'),'Base Crax Sourire absente')
assert(not templates:FindFirstChild('Crax_Inverted'),'Template Inverted déjà présent')
local previews=assert(RS:FindFirstChild('CraxPreviews'),'CraxPreviews absent')
assert(not previews:FindFirstChild('Crax_Inverted'),'Aperçu Inverted déjà présent')
assert(resolve('Workspace.Arenaleft')and resolve('Workspace.ArenaRight'),'Murs canoniques absents')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('InvertedOwned',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(object)created[#created+1]=object;return object end
local function entry(path,original,installed)
 local item=Instance.new('Folder');item.Name=tostring(#entries:GetChildren()+1);item:SetAttribute('Path',path)
 local a=Instance.new('StringValue');a.Name='Original';a.Value=original;a.Parent=item
 local b=Instance.new('StringValue');b.Name='Installed';b.Value=installed;b.Parent=item;item.Parent=entries
end
local ok,err=pcall(function()
 for _,r in ipairs(modules)do
  local parentPath,name=r.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(r.class));o.Name=name;o.Source=r.source;o:SetAttribute('InvertedOwned',true);o.Parent=assert(resolve(parentPath))
  entry(r.path,'',r.source)
 end
 local fx=register(Instance.new('RemoteEvent'));fx.Name='CraxInvertedFX';fx:SetAttribute('InvertedOwned',true);fx.Parent=RS
 local palette=require(RS.CraxInvertedPalette)
 local model=register(assert(base:Clone()));model.Name='Crax_Inverted';palette.Apply(model);model:SetAttribute('InvertedOwned',true);model:SetAttribute('AbilityId','InvertedMute');model.Parent=templates
 local preview=register(assert(model:Clone()));preview:SetAttribute('InvertedOwned',true);preview.Parent=previews
 -- The native curved X is retained. No invented MeshId or mandatory import is needed.
 for _,r in ipairs(patches)do
  local o=resolve(r.path);entry(r.path,o.Source,r.source);changed[#changed+1]={o=o,source=o.Source};o.Source=r.source
 end
 backup.Parent=storage
end)
if not ok then
 for i=#changed,1,-1 do pcall(function()changed[i].o.Source=changed[i].source end)end
 for i=#created,1,-1 do pcall(function()created[i]:Destroy()end)end
 backup:Destroy();error('Installation annulée, sources restaurées : '..tostring(err))
end
print('InvertedCrax installé : tête native préservée, livre, casino, serveur et client ajoutés.')
warn('Les sons et l’icône sont configurables dans ReplicatedStorage.CraxInvertedConfig. Les IDs vides ne bloquent pas le gameplay. TESTER À DEUX CLIENTS AVANT PUBLICATION.')
end
