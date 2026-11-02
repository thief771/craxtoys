-- Play arrêté. Sélectionner les Sound importés et les ImageLabel configurés.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play.')
local RS=game:GetService('ReplicatedStorage');local names={}
for _,n in ipairs({'SteelStart','CircleDash','DashHit','SteelEnd','LaserStart','LaserLoop','LaserEnd','FrostCharge','FrostLoop','FreezeApply','IceShatter','LastStand','KryptoniteSpawn','KryptonitePickup','KryptoniteDeath','FinaleFly','FinaleLaserCharge','FinaleLaserShot','FinaleShatter'})do names[n]=true end
local icons={SuperLaserIcon='Laser',SuperFrostIcon='Frost',SuperInvincibleIcon='Invincible',SuperMaxIcon='Max'}
local values={}
local function inspect(o)
 if o:IsA('Sound')then local name=o.Name:gsub('%.wav$','');if names[name]then local id=o.SoundId:match('^rbxassetid://(%d+)$');assert(id and tonumber(id)>0,'Vrai ID manquant : '..name);values[name]='rbxassetid://'..id end
 elseif o:IsA('ImageLabel')and icons[o.Name]then local id=o.Image:match('^rbxassetid://(%d+)$');assert(id and tonumber(id)>0,'Vrai ID image manquant : '..o.Name);values['Icon_'..icons[o.Name]]='rbxassetid://'..id end
end
for _,o in ipairs(game:GetService('Selection'):Get())do inspect(o);for _,child in ipairs(o:GetDescendants())do inspect(child)end end
assert(next(values),'Sélectionner les Sound et/ou les ImageLabel reconnus. Aucun identifiant n’est inventé.')
local folder=RS:FindFirstChild('CraxSuperUserAssets')
if folder then assert(folder:IsA('Folder')and folder:GetAttribute('SuperUserAssets')==true,'Nom déjà utilisé par un autre objet.')else folder=Instance.new('Folder');folder.Name='CraxSuperUserAssets';folder:SetAttribute('SuperUserAssets',true);folder.Parent=RS end
local count=0;for name,id in pairs(values)do folder:SetAttribute(name,id);count+=1 end
print(count..' ID(s) enregistré(s). Vérifier les permissions des ressources, sauvegarder puis lancer un NOUVEAU Play.')
end
