-- Play arrêté. Branche les trois images fournies, le trophée standard et le nom du MAX.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play avant cette installation')
local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage');local SES=game:GetService('ScriptEditorService')
local title='ÉCLAT DU TEMPS'
local iconIds={Attract='rbxassetid://115141704173618',Invert='rbxassetid://100547976430138',Stop='rbxassetid://121811098319527',Max=''}
local marker='-- PolariBookImagesAndTitleV1'
local labelMarker='-- PolariBookLabelsV2'
local function resolve(path)local o=game;for key in path:gmatch('[^.]+')do o=o and o:FindFirstChild(key)end;return o end
local function once(source,before,after)
 local a,b=source:find(before,1,true);assert(a and not source:find(before,b+1,true),'Structure du cahier différente : '..before:sub(1,100)..'. Aucun fichier modifié.')
 return source:sub(1,a-1)..after..source:sub(b+1)
end
local function line(source,prefix,after)
 local a,b=source:find(prefix,1,true);assert(a and not source:find(prefix,b+1,true),'Structure du cahier différente : '..prefix..'. Aucun fichier modifié.')
 local ending=source:find('\n',b+1,true)or(#source+1)
 return source:sub(1,a-1)..after..source:sub(ending)
end
local trophy=assert(RS:FindFirstChild('CraxTrophyIcons'),'Trophée standard CraxTrophyIcons absent')
assert(trophy:IsA('ModuleScript'),'CraxTrophyIcons doit être un ModuleScript')
local assets=RS:FindFirstChild('CraxPolariUserAssets');assert(not assets or assets:IsA('Folder'),'CraxPolariUserAssets doit être un Folder')
local backup=assert(SS:FindFirstChild('PolariCrax_Backup_V1'),'Installer PolariCrax avant cette commande')
assert(backup:GetAttribute('PolariOwned')and not backup:GetAttribute('Incomplete'),'Sauvegarde Polari incomplète ou étrangère')
local entries=assert(backup:FindFirstChild('Entries'));local indexed={}
for _,entry in ipairs(entries:GetChildren())do local path=entry:GetAttribute('Path');assert(not indexed[path],'Entrée dupliquée dans la sauvegarde');indexed[path]=entry end
local function imageContent(key,id)
 local number=tonumber(id:match('(%d+)$'))
 local infoOk,info=pcall(function()return game:GetService('MarketplaceService'):GetProductInfo(number)end)
 if infoOk and info.AssetTypeId==1 then print('Polari '..key..' : ID de contenu image direct '..id);return id end
 local ok,asset=pcall(function()return game:GetService('InsertService'):LoadAsset(number)end)
 if ok and asset then
  local resolved
  for _,o in ipairs(asset:GetDescendants())do
   local content=o:IsA('Decal')and o.Texture or(o:IsA('ImageLabel')and o.Image)
   if type(content)=='string'then
    local digits=content:match('^rbxassetid://(%d+)$')or content:match('[?&]id=(%d+)')
    if digits then resolved='rbxassetid://'..digits;break end
   end
  end
  asset:Destroy()
  if resolved then print('Polari '..key..' : contenu image résolu '..id..' -> '..resolved);return resolved end
 end
 warn('Polari '..key..' : contenu non résolu pour '..id..'. Vérifier le type et les permissions dans Creator Dashboard ; cette commande ne peut pas accorder des droits Roblox.')
 return id
end
for key,id in pairs(iconIds)do if id~=''then iconIds[key]=imageContent(key,id)end end
local function bookLabels(source)
 source=once(source,'local levelColor=lv<=0',[[if currentCrax=='Crax_Polari'and owned and lv>=4 then status='MAX · ÉCLAT DU TEMPS'end
  local levelColor=lv<=0]])
 source=once(source,'local track=make("Frame",{Position=UDim2.fromOffset(42,380)',[[if currentCrax=='Crax_Polari'then
   local caption=left:FindFirstChild('CraxTrophyCaption')
   if caption then caption.Text='ÉCLAT DU TEMPS';caption.Size=UDim2.fromOffset(148,38);caption.TextScaled=true;caption.TextWrapped=true;local limit=caption:FindFirstChildWhichIsA('UITextSizeConstraint');if limit then limit.MinTextSize=6;limit.MaxTextSize=16 end end
  end
  local track=make("Frame",{Position=UDim2.fromOffset(42,380)]])
 return source
end
local plan={}
local function patch(path,transform,patchMarker)
 patchMarker=patchMarker or marker
 local object=assert(resolve(path),'Source absente : '..path);assert(object:IsA('LuaSourceContainer'),'Source invalide : '..path)
 local before=SES:GetEditorSource(object)
 if before:find(patchMarker,1,true)then return end
 local after=patchMarker..'\n'..transform(before)
 local entry=indexed[path];local installed=entry and entry:FindFirstChild('Installed')
 plan[#plan+1]={path=path,object=object,before=before,after=after,installed=installed,oldInstalled=installed and installed.Value,tracked=installed and installed.Value==before}
end
patch('ReplicatedStorage.CraxPolariConfig',function(source)
 local result,count=source:gsub("MaxTitle%s*=%s*'[^']*'","MaxTitle='"..title.."'",1)
 assert(count==1,'MaxTitle introuvable : aucun fichier modifié');return result
end)
patch('StarterPlayer.StarterPlayerScripts.CopEmClient',function(source)
 -- Detail/earned trophy: use the same existing renderer as the other Crax.
 source=once(source,'local function polariIconV1(parent,kind,x,y,size)',[[local function polariIconV1(parent,kind,x,y,size)
 if kind=='PolariFinale'then
  local holder=Instance.new('Frame');holder.Size=UDim2.fromOffset(size,size);holder.Position=UDim2.fromOffset(x,y);holder.BackgroundTransparency=1;holder.ZIndex=4;holder.Parent=parent
  require(game:GetService('ReplicatedStorage'):WaitForChild('CraxTrophyIcons')).Build(holder,true);return holder
 end]])
 -- The fourth skill goes through the standard acquired/locked trophy branch.
 source=once(source,[[if i==4 and currentCrax=="Crax_Polari"then
     if revealed then polariIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 and currentCrax=="Crax_Symbioti"then]],[[if i==4 and currentCrax=="Crax_Symbioti"then]])
 return labelMarker..'\n'..bookLabels(source)
end)
-- Existing V1 installations already have their icons/trophy edits: only patch the remaining labels.
local book=assert(resolve('StarterPlayer.StarterPlayerScripts.CopEmClient'))
if SES:GetEditorSource(book):find(marker,1,true)then patch('StarterPlayer.StarterPlayerScripts.CopEmClient',bookLabels,labelMarker)end
patch('ReplicatedStorage.CraxBookCinema',function(source)
 return line(source,"if id=='Crax_Polari'then",[[if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local image=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxTrophyIcons')).Build(self.trophyArt,true);if image then image.ZIndex=113 end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end]])
end)
patch('ReplicatedStorage.CraxSkillCatalog',function(source)
 return 'local data=(function()\n'..source..[[
end)()
local spec=assert(data.Crax_Polari,'Catalogue Polari absent');local max=assert(spec.Upgrades[4],'MAX Polari absent')
max.Name='ÉCLAT DU TEMPS';max.Status='ÉCLAT DU TEMPS • MAX'
max.Description='Exécution magnétique : lévitation de l’adversaire, cinq éclats, arrêt du temps puis fragmentation. Présentation après le résultat du combat.'
spec.Finale=max
return data
]]
end)
patch('StarterPlayer.StarterPlayerScripts.CraxPolariClient',function(source)
 -- Rename the existing caption only; keep the approved shatter cinematic unchanged.
 if source:find("Text='L’ULTIME SECONDE'",1,true)then return once(source,"Text='L’ULTIME SECONDE'","Text='ÉCLAT DU TEMPS'")end
 assert(source:find("Text='ÉCLAT DU TEMPS'",1,true),'Titre de cinématique introuvable : aucun fichier modifié');return source
end)
local safetyName='PolariCrax_BookImages_Title_Safety_V2'
local safety=SS:FindFirstChild(safetyName)
if #plan>0 then
 assert(not safety,'Une sauvegarde de cette commande existe déjà : inspecter '..safetyName..' avant de modifier de nouveau les sources')
 safety=Instance.new('Folder');safety.Name=safetyName;safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true);safety.Parent=SS
 for i,item in ipairs(plan)do local e=Instance.new('Folder');e.Name=tostring(i);e:SetAttribute('Path',item.path);for key,value in pairs({Original=item.before,Installed=item.after})do local v=Instance.new('StringValue');v.Name=key;v.Value=value;v.Parent=e end;e.Parent=safety end
 local attempted={}
 local ok,err=pcall(function()
  for _,item in ipairs(plan)do
   attempted[#attempted+1]=item
   SES:UpdateSourceAsync(item.object,function(current)assert(current==item.before,'Édition concurrente : '..item.path);return item.after end)
   assert(SES:GetEditorSource(item.object)==item.after,'Écriture non vérifiée : '..item.path)
  end
  for _,item in ipairs(plan)do if item.tracked then item.installed.Value=item.after end end
 end)
 if not ok then
  local conflicts={}
  for i=#attempted,1,-1 do local item=attempted[i]
   local restored=pcall(function()local current=SES:GetEditorSource(item.object);assert(current==item.after or current==item.before,'Édition concurrente');if current==item.after then SES:UpdateSourceAsync(item.object,function(live)assert(live==item.after,'Édition concurrente');return item.before end)end end)
   if not restored then conflicts[#conflicts+1]=item.path end
  end
  for _,item in ipairs(plan)do if item.tracked then item.installed.Value=item.oldInstalled end end
  if #conflicts==0 then safety:Destroy()else backup:SetAttribute('Incomplete',true);warn('Sauvegarde de récupération conservée : '..table.concat(conflicts,', '))end
  error('Installation arrêtée : '..tostring(err))
 end
 safety:SetAttribute('Incomplete',false)
 for _,item in ipairs(plan)do if not item.tracked then warn('Modifications préexistantes préservées dans '..item.path..' ; sauvegarde principale laissée inchangée pour protéger le retour arrière.')end end
end
if not assets then assets=Instance.new('Folder');assets.Name='CraxPolariUserAssets';assets.Parent=RS end
assets:SetAttribute('PolariUserAssets',true)
for key,id in pairs(iconIds)do assets:SetAttribute('Icon_'..key,id)end
print('PolariCrax : trois images branchées, trophée standard au MAX, nom ÉCLAT DU TEMPS. Audio et cinématique conservés. ENREGISTRER puis NOUVEAU Play.')
end
