local data=(function()
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
