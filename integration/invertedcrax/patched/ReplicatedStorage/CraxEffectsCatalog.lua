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
