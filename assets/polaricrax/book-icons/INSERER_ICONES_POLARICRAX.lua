-- Play arrêté : sélectionner les quatre Decal/ImageLabel importés (ou leur dossier).
do
assert(not game:GetService('RunService'):IsRunning(),'Arrête Play avant de brancher les images')
local RS=game:GetService('ReplicatedStorage')
local names={PolariAttractIcon='Attract',PolariInvertIcon='Invert',PolariStopIcon='Stop',PolariMaxIcon='Max'}
local labels={Attract='PÔLE D’ATTRACTION',Invert='INVERSION DES PÔLES',Stop='TEMPS SUSPENDU',Max='MAX — L’ULTIME SECONDE'}
local ids={}
local function inspect(o)
 local name=o.Name:gsub('%.png$','')
 local key=names[name]
 if not key then return end
 local id
 if o:IsA('Decal')or o:IsA('Texture')then id=o.Texture
 elseif o:IsA('ImageLabel')or o:IsA('ImageButton')then id=o.Image
 else return end
 local number=id:match('^rbxassetid://(%d+)$')or id:match('^https?://[%w%.]*roblox%.com/asset/?%?id=(%d+)$')
 assert(number and tonumber(number)>0,'Image non importée ou ID invalide : '..name)
 id='rbxassetid://'..number
 assert(not ids[key]or ids[key]==id,'Plusieurs images différentes portent le nom '..name)
 ids[key]=id
end
for _,o in ipairs(game:GetService('Selection'):Get())do inspect(o);for _,child in ipairs(o:GetDescendants())do inspect(child)end end
for name,key in pairs(names)do assert(ids[key],'Image manquante : '..name..'. Importe-la puis sélectionne son Decal/ImageLabel avec les trois autres.')end
local folder=RS:FindFirstChild('CraxPolariUserAssets')
assert(not folder or folder:IsA('Folder'),'CraxPolariUserAssets existe mais ce n’est pas un Folder : aucun changement')
if not folder then folder=Instance.new('Folder');folder.Name='CraxPolariUserAssets';folder.Parent=RS end
folder:SetAttribute('PolariUserAssets',true)
for key,id in pairs(ids)do folder:SetAttribute('Icon_'..key,id);print(labels[key]..' : '..id)end
print('Les 4 images sont branchées. Audio conservé. Enregistre la place puis lance un NOUVEAU Play pour recharger le cahier.')
end
