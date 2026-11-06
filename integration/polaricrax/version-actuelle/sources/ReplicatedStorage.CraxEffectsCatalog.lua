-- PolariCraxIntegrationV1
local data=(function()
-- LuckyCraxIntegrationV1
local data=(function()
-- SymbiotiCraxIntegrationV1
local data=(function()
-- CraxStableRepairV2
local data=(function()
-- SuperCraxIntegrationV1
local data=(function()
local data=(function()
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

end)()
data.SuperSteel={DisplayName="HOMME D’ACIER",Description='Invulnérable aux dégâts ordinaires pendant les 1,5 s du dash. La kryptonite du héros reste mortelle.',Icon='Steel',Image='',Color=Color3.fromRGB(177,205,223),Duration=1.5}
data.SuperFreeze={DisplayName='GEL',Description='Immobilisé. Durée de 5 s rafraîchie sous le souffle. Une mêlée du SuperCrax poseur brise sa glace pour 35 dégâts au total, sans cumul de vulnérabilité générale.',Icon='Ice',Image='',Color=Color3.fromRGB(154,235,255),Duration=5}
data.SuperKryptonite={DisplayName='KRYPTONITE',Description='Cristal lié à un SuperCrax invincible. Le porteur gagne 50 % de vitesse sans cumul ; toucher le héros concerné le tue immédiatement.',Icon='Crystal',Image='',Color=Color3.fromRGB(78,239,82)}
return data

end)()
if data.Silence and(type(data.Silence.Image)~='string'or data.Silence.Image=='')then data.Silence.Image='rbxassetid://126409145262998'end
return data

end)()
data.SymMarks={DisplayName='CONTAMINATION',Description='Trois marques du même SymbiotiCrax déclenchent 15 dégâts supplémentaires. Expiration après 15 s sans nouvelle marque.',Icon='SymMarks',Image='',Color=Color3.fromRGB(110,115,130)}
data.SymArmour={DisplayName='ARMURE VIVANTE',Description='35 % de dégâts reçus en moins pendant 4 s. Aucun soin ou sauvetage automatique.',Icon='SymArmour',Image='',Duration=4,Color=Color3.fromRGB(80,86,100)}
data.SymParasite={DisplayName='PARASITE',Description='Vitesse ×0,75 pendant l’accrochage ; 3 dégâts/s durant au plus 3 s.',Icon='SymParasite',Image='',Duration=3,Color=Color3.fromRGB(178,73,100)}
local icons=require(game:GetService('ReplicatedStorage').CraxSymConfig).Icons
for id,key in pairs({SymMarks='Marks',SymArmour='Armour',SymParasite='Parasite'})do data[id].Image=icons[key]or '' end

return data

end)()
data.LuckyCheat={DisplayName='TRICHE',Description='Compétences interrompues et bloquées pendant 7 secondes actives ; déplacement et mêlée ordinaires conservés.',Duration=7,Icon='LuckyCheat',Image='',Color=Color3.fromRGB(168,90,225)}
return data

end)()
data.PolariAttract={DisplayName='POLARISATION',Description='Trajectoire attirée vers un mur pendant 2 s, sans dégât.',Duration=2,Image='',Color=Color3.fromRGB(163,75,230)};data.PolariFrozen={DisplayName='TEMPS SUSPENDU',Description='Pause imbriquée du combat pendant 1,2 s, puis fenêtre d’esquive.',Duration=1.2,Image='',Color=Color3.fromRGB(242,194,75)}
return data
