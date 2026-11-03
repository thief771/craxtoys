-- SymbiotiCraxIntegrationV1
local data=(function()
-- SuperCraxIntegrationV1
local data=(function()
local data=(function()
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

end)()
assert(not data.Crax_Super,'SuperCrax existe déjà dans le catalogue')
local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
local base=assert(data.Crax_Monster,'CraxSourire réel absent')
data.Crax_Super={DisplayName='SuperCrax',Rarity='Commun',TemplateName='Crax_Super',MaxHealth=C.Health,Speed=assert(base.Speed),CollisionDamage=C.Melee,
 Description='Le vrai sourire Craxtoys, une boucle héroïque et une volonté d’acier.',
 PowerDescription='Dash circulaire : trois tours en 1,5 seconde, Homme d’acier durant l’activation et 16 dégâts par ennemi et par tour. Délai serveur de 8 à 12 secondes actives.',
 Effects={'SuperSteel','SuperFreeze','SuperKryptonite'},Ability={Id=C.AbilityId,DisplayName='Dash circulaire',Damage=C.Melee,Cooldown=C.DashWait[1]}}
return data

end)()
assert(not data.Crax_Symbioti,'SymbiotiCrax déjà défini')
local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local base=assert(data.Crax_Monster);local epic=assert(data.Crax_Ghosty)
data.Crax_Symbioti={DisplayName='SymbiotiCrax',Rarity=epic.Rarity,RarityColor=epic.RarityColor,TemplateName=C.Id,MaxHealth=C.Health,CollisionDamage=C.Melee,Speed=base.Speed,
 Description='Le vrai Crax Sourire transformé : langue recourbée, crocs et filaments noirs.',PowerDescription='Langue prédatrice : capture et traction progressive, puis morsure à 16 dégâts. Délai de 8 à 12 secondes actives après rétraction. Les contacts ordinaires ne s’ajoutent pas à la capture.',Effects={'SymMarks','SymArmour','SymParasite'},Ability={Id=C.AbilityId,DisplayName='LANGUE PRÉDATRICE',Damage=C.Damage,Cooldown=C.Wait[1]}}
return data
