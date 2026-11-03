-- STOP. Sélectionner le Sound de l’atlas et/ou les ImageLabel d’illustration.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local RS=game:GetService('ReplicatedStorage');local values={};local icons={SymMarksIcon='Marks',SymArmourIcon='Armour',SymParasiteIcon='Parasite',SymMaxIcon='Max'}
local function inspect(o)
 local key,id
 if o:IsA('Sound')and(o.Name=='SymbiotiCrax_AUDIO_ATLAS'or o.Name=='SymbiotiCrax_AUDIO_ATLAS.wav')then key='AudioAtlas';id=o.SoundId
 elseif o:IsA('ImageLabel')and icons[o.Name]then key='Icon_'..icons[o.Name];id=o.Image end
 if key then local n=id:match('^rbxassetid://(%d+)$');assert(n and tonumber(n)>0,'ID réel absent : '..o.Name);values[key]='rbxassetid://'..n end
end
for _,o in ipairs(game:GetService('Selection'):Get())do inspect(o);for _,p in ipairs(o:GetDescendants())do inspect(p)end end
assert(next(values),'Sélectionner le Sound atlas importé et les ImageLabel nommés SymMarksIcon, SymArmourIcon, SymParasiteIcon, SymMaxIcon')
local folder=RS:FindFirstChild('CraxSymUserAssets');if folder then assert(folder:IsA('Folder')and folder:GetAttribute('SymUserAssets'),'Nom réservé par un autre objet')else folder=Instance.new('Folder');folder.Name='CraxSymUserAssets';folder:SetAttribute('SymUserAssets',true);folder.Parent=RS end
for k,v in pairs(values)do folder:SetAttribute(k,v)end
print('IDs réels enregistrés. Vérifier les permissions de l’expérience, enregistrer, puis nouveau Play et diagnostic audio CLIENT.')
end
