-- Play arrêté. Sélectionner les Sound importés, nommés comme les WAV du manifeste.
-- Pour l'icône : sélectionner un ImageLabel nommé SilenceIcon avec son vrai Image.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play pour enregistrer les IDs.')
local RS=game:GetService('ReplicatedStorage');local names={}
for _,n in ipairs({'MuteTrigger','SilenceApply','SilenceEnd','HackActivate','HackDirection01','HackDirection02','HackDirection03','CopyCapture','CopyImpact','RewindMark','RewindBuild','TeleportDepart','TeleportArrive','MarkCancel','MaxRise','MaxLoop','MaxFragment','MaxSuction','MaxClose'})do names[n]=true end
local values={}
local function read(o)
 if o:IsA('Sound')then
  local name=o.Name:gsub('%.wav$','');local id=o.SoundId:match('^rbxassetid://(%d+)$')
  if names[name]then assert(id and tonumber(id)>0,'ID audio réel absent : '..name);values[name]='rbxassetid://'..id end
 elseif o:IsA('ImageLabel')and o.Name=='SilenceIcon'then
  local id=o.Image:match('^rbxassetid://(%d+)$');assert(id and tonumber(id)>0,'ID icône réel absent');values.SilenceIcon='rbxassetid://'..id
 end
end
for _,o in ipairs(game:GetService('Selection'):Get())do read(o);for _,c in ipairs(o:GetDescendants())do read(c)end end
assert(next(values),'Aucun Sound reconnu ni ImageLabel SilenceIcon configuré dans la sélection.')
local folder=RS:FindFirstChild('CraxInvertedUserAssets')
if folder then assert(folder:IsA('Folder')and folder:GetAttribute('InvertedUserAssets')==true,'Nom déjà utilisé par un autre objet.')
else folder=Instance.new('Folder');folder.Name='CraxInvertedUserAssets';folder:SetAttribute('InvertedUserAssets',true);folder.Parent=RS end
local n=0;for key,value in pairs(values)do folder:SetAttribute(key,value);n=n+1 end
print(n..' identifiant(s) enregistré(s). Vérifier les permissions de chaque ressource dans cette expérience, puis relancer Play.')
end
