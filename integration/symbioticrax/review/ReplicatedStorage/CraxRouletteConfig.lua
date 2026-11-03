-- SymbiotiCraxIntegrationV1
local data=(function()
-- SuperCraxIntegrationV1
local data=(function()
local data=(function()
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

end)()
local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local common,total={},0
for _,e in ipairs(data.Pool)do
 assert(e.Id~='Crax_Super','SuperCrax déjà présent dans le tirage')
 if catalog[e.Id]and catalog[e.Id].Rarity=='Commun'then common[#common+1]=e;total=total+e.Weight end
end
assert(#common>0 and total>0,'Groupe Commun absent')
local share=total/(#common+1);for _,e in ipairs(common)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Super',Weight=total-share*#common}
assert(data.DuplicateGems.Commun~=nil,'Compensation des doublons Commune absente')
return data

end)()
local catalog=require(game:GetService('ReplicatedStorage').CraxCatalog);local epic={};local total=0
for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Symbioti');if catalog[e.Id].Rarity==catalog.Crax_Symbioti.Rarity then epic[#epic+1]=e;total+=e.Weight end end
assert(#epic>0 and total>0);local share=total/(#epic+1);for _,e in ipairs(epic)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Symbioti',Weight=total-share*#epic} -- provisional equal redistribution within unchanged Epic mass

return data
