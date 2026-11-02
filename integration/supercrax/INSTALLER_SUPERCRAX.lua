-- SUPERCRAX : UNE COMMANDE. PLAY ARRÊTÉ. Importer puis sélectionner les accessoires FBX.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play avant installation.')
local function resolve(path)local o=game;for key in path:gmatch('[^.]+')do o=o and o:FindFirstChild(key)end;return o end
local RS=game:GetService('ReplicatedStorage');local storage=game:GetService('ServerStorage')
local backupName='SuperCrax_Integration_Backup_V1';local marker='-- SuperCraxIntegrationV1'
local operations={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Super,'SuperCrax existe déjà dans le catalogue')
local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
local base=assert(data.Crax_Monster,'CraxSourire réel absent')
data.Crax_Super={DisplayName='SuperCrax',Rarity='Commun',TemplateName='Crax_Super',MaxHealth=C.Health,Speed=assert(base.Speed),CollisionDamage=C.Melee,
 Description='Le vrai sourire Craxtoys, une boucle héroïque et une volonté d’acier.',
 PowerDescription='Dash circulaire : trois tours en 1,5 seconde, Homme d’acier durant l’activation et 16 dégâts par ennemi et par tour. Délai serveur de 8 à 12 secondes actives.',
 Effects={'SuperSteel','SuperFreeze','SuperKryptonite'},Ability={Id=C.AbilityId,DisplayName='Dash circulaire',Damage=C.Melee,Cooldown=C.DashWait[1]}}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Super,'SuperCrax existe déjà dans le livre')
local reference=assert(data.Crax_Monster).Upgrades
local upgrades={
 {Id='SuperLaser',Name='RAYON LASER',Description='Deux rayons rouges aux directions aléatoires indépendantes, pendant 2,5 s. Au maximum 15 PV/s par victime, même si les deux rayons touchent : 37,5 dégâts de base pour une exposition complète. Délai de 5 à 8 s actives après la fin.'},
 {Id='SuperFrost',Name='SOUFFLE GELÉ',Description='Après trois mêlées efficaces : canalisation mobile de 2 s, puis souffle de 3,5 s vers le coin le plus éloigné de l’arène. Gel entretenu jusqu’à 5 s après la dernière exposition. Une nouvelle mêlée de SuperCrax brise ce gel pour 35 dégâts au total, sans regel par ce même souffle.'},
 {Id='SuperInvincible',Name="L’INVINCIBLE SUPERCRAX",Description='Un dégât ordinaire mortel est intercepté avant la mort : maintien strict à 1 PV, aucun soin et protection ordinaire pour le reste du round. Les pouvoirs restent actifs. Une kryptonite liée au héros apparaît : le toucher tue le héros, même en acier. Un ennemi peut la porter pour +50 % de vitesse.'},
 {Id='SuperFinale',Name='EXÉCUTION MAX',Description='À chaque victoire de SuperCrax MAX : vol près du vaincu, congélation complète, charge rouge des yeux de 1,5 s, lasers puis éclatement de la victime et de la glace. Aucun dégât ni récompense supplémentaire.'}}
for i,u in ipairs(upgrades)do local p=assert(reference[i]);u.Coins=assert(p.Coins);u.Gems=assert(p.Gems);u.Status=u.Name end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Super={Order=order+1,AbilityId='SuperHero',DisplayName='SuperCrax',Enabled=true,Upgrades=upgrades,Finale=upgrades[4]}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[data.SuperSteel={DisplayName="HOMME D’ACIER",Description='Invulnérable aux dégâts ordinaires pendant les 1,5 s du dash. La kryptonite du héros reste mortelle.',Icon='Steel',Image='',Color=Color3.fromRGB(177,205,223),Duration=1.5}
data.SuperFreeze={DisplayName='GEL',Description='Immobilisé. Durée de 5 s rafraîchie sous le souffle. Une mêlée du SuperCrax poseur brise sa glace pour 35 dégâts au total, sans cumul de vulnérabilité générale.',Icon='Ice',Image='',Color=Color3.fromRGB(154,235,255),Duration=5}
data.SuperKryptonite={DisplayName='KRYPTONITE',Description='Cristal lié à un SuperCrax invincible. Le porteur gagne 50 % de vitesse sans cumul ; toucher le héros concerné le tue immédiatement.',Icon='Crystal',Image='',Color=Color3.fromRGB(78,239,82)}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxRouletteConfig]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local common,total={},0
for _,e in ipairs(data.Pool)do
 assert(e.Id~='Crax_Super','SuperCrax déjà présent dans le tirage')
 if catalog[e.Id]and catalog[e.Id].Rarity=='Commun'then common[#common+1]=e;total=total+e.Weight end
end
assert(#common>0 and total>0,'Groupe Commun absent')
local share=total/(#common+1);for _,e in ipairs(common)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Super',Weight=total-share*#common}
assert(data.DuplicateGems.Commun~=nil,'Compensation des doublons Commune absente')]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVictoryCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
data.Crax_Super={Id='SuperFinale',DisplayName='EXÉCUTION MAX',MinimumLevel=4,IntroDuration=0,Duration=C.Finale.ReturnEnd,ZoomDuration=0,HoldDuration=0,Description='Gel, charge laser de 1,5 s, puis éclatement du vaincu. Présentation de victoire uniquement.'}]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSkinServer]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local appearance=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperAppearance'))
local apply=data.Apply
function data.Apply(model,id,config)
 appearance.Restore(model);apply(model,id,config)
 if id=='Crax_Super'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSuperImportedAssets'),'Importer les accessoires de SuperCrax'))end
end]====]},{[ [====[path]====] ]=[====[ServerScriptService.ArenaMovement]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function launch()]====],[ [====[after]====] ]=[====[local function launch()
 SuperCraxV1.Begin(fighters)]====]},{[ [====[before]====] ]=[====[Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)]====],[ [====[after]====] ]=[====[SuperCraxV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  alive=alive and state:GetAttribute('Phase')=='Fighting'
  Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)]====]},{[ [====[before]====] ]=[====[if alive and not frozen and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))]====],[ [====[after]====] ]=[====[if alive and not frozen and not SuperCraxV1.Held(f.model)and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))]====]},{[ [====[before]====] ]=[====[f.velocity * Plumber.Speed(f)]====],[ [====[after]====] ]=[====[f.velocity * SuperCraxV1.Speed(f.model) * Plumber.Speed(f)]====]},{[ [====[before]====] ]=[====[f.velocity.Magnitude*Plumber.Speed(f)]====],[ [====[after]====] ]=[====[f.velocity.Magnitude*SuperCraxV1.Speed(f.model)*Plumber.Speed(f)]====]},{[ [====[before]====] ]=[====[elseif distance < radius and not Plumber.Hold(a.model)]====],[ [====[after]====] ]=[====[elseif distance < radius and not SuperCraxV1.SuppressNormalContact(a.model,b.model)and not Plumber.Hold(a.model)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxPositionLock]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Lock(f)
 if records[f.model]then return end]====],[ [====[after]====] ]=[====[function M.Lock(f,reason)
 reason=reason or 'Fantastic'
 if records[f.model]then records[f.model].reasons[reason]=true;return end]====]},{[ [====[before]====] ]=[====[restoring=false}]====],[ [====[after]====] ]=[====[restoring=false,reasons={[reason]=true}}]====]},{[ [====[before]====] ]=[====[function M.Unlock(f)
 local r=records[f.model];if not r then return end]====],[ [====[after]====] ]=[====[function M.Unlock(f,reason)
 local r=records[f.model];if not r then return end
 r.reasons[reason or 'Fantastic']=nil;if next(r.reasons)then return end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxDeadlyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local _superBridge
local function SuperCraxBridgeV1()if not _superBridge then _superBridge=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))end;return _superBridge end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[speed=speed*M.Slow(n.model)]====],[ [====[after]====] ]=[====[speed=speed*SuperCraxBridgeV1().Speed(n.model)*M.Slow(n.model)]====]},{[ [====[before]====] ]=[====[local budget=math.max(0,dt)*100*math.max(0,slow)]====],[ [====[after]====] ]=[====[local budget=math.max(0,dt)*100*SuperCraxBridgeV1().Speed(n.model)*math.max(0,slow)]====]},{[ [====[before]====] ]=[====[+dt*2.8]====],[ [====[after]====] ]=[====[+dt*2.8*SuperCraxBridgeV1().Speed(n.model)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.FleauRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local _superBridge
local function SuperCraxBridgeV1()if not _superBridge then _superBridge=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))end;return _superBridge end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local from=f.position;local step=math.min(d.Magnitude,speed*dt)]====],[ [====[after]====] ]=[====[speed=speed*SuperCraxBridgeV1().Speed(m)
     local from=f.position;local step=math.min(d.Magnitude,speed*dt)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CombatHealth]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function report(a,b,lost,kind)]====],[ [====[after]====] ]=[====[local function report(a,b,lost,kind)
 SuperCraxV1.PowerResult(a,b,lost,kind)]====]},{[ [====[before]====] ]=[====[local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end]====],[ [====[after]====] ]=[====[local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end
 if SuperCraxV1.TryCrystalContact(attacker,defender)then return end]====]},{[ [====[before]====] ]=[====[if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end]====],[ [====[after]====] ]=[====[if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end
 if collision then amount=SuperCraxV1.ContactDamage(attacker,defender,amount)end]====]},{[ [====[before]====] ]=[====[local fleauRecoilMode]====],[ [====[after]====] ]=[====[if collision then recoil=SuperCraxV1.ContactDamage(defender,attacker,recoil)end
 local fleauRecoilMode]====]},{[ [====[before]====] ]=[====[local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)]====],[ [====[after]====] ]=[====[amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)
 if collision then incoming=SuperCraxV1.Incoming(attacker,incoming,a.health,defender,'Collision')end
 local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)]====]},{[ [====[before]====] ]=[====[update(attacker);update(defender);]====],[ [====[after]====] ]=[====[update(attacker);update(defender);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);]====]},{[ [====[before]====] ]=[====[if not Fleau.HealAllowed(model)then return end]====],[ [====[after]====] ]=[====[if not Fleau.HealAllowed(model)then return end
 amount=SuperCraxV1.AllowHeal(model,amount);if amount<=0 then return end]====]},{[ [====[before]====] ]=[====[state:SetAttribute('HealthReady',true)]====],[ [====[after]====] ]=[====[SuperCraxV1.KillHealthBatch=function(requests,expectedRound,expectedMatch)
 if #requests==0 or state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('RoundId')~=expectedRound or state:GetAttribute('CraxMatchToken')~=expectedMatch then return false end
 local unique={}
 for _,request in ipairs(requests)do
  local model=request.model;local r=states[model]
  if unique[model]or not r or r.health<=0 or not SuperCraxV1.ValidateCrystalKill(model,request.carrier,expectedRound,expectedMatch,request.token)then return false end
  unique[model]=true
 end
 for _,request in ipairs(requests)do local model=request.model;local r=states[model];local loss=r.health;r.health=0;update(model);if request.carrier then report(request.carrier,model,loss,'SuperKryptonite')end end
 finish();return true
end
state:SetAttribute('HealthReady',true)]====]},{[ [====[variants]====] ]={{[ [====[before]====] ]=[====[amount=Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)]====],[ [====[after]====] ]=[====[amount=kind=='SuperLaser'and adjust(defender,amount,kind)or Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)]====]},{[ [====[before]====] ]=[====[amount=adjust(defender,math.floor(amount+.5),kind)]====],[ [====[after]====] ]=[====[amount=kind=='SuperLaser'and adjust(defender,amount,kind)or adjust(defender,math.floor(amount+.5),kind)]====]}}}}},{[ [====[path]====] ]=[====[ServerScriptService.RoundManager]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[state:SetAttribute("RoundVictoryStartedAt",start)]====],[ [====[after]====] ]=[====[if model and model:GetAttribute('CraxId')=='Crax_Super'then
  state:SetAttribute('SuperVictoryCrax','Crax_Super');state:SetAttribute('SuperVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0)
  state:SetAttribute('SuperVictoryMatch',state:GetAttribute('CraxMatchToken'));state:SetAttribute('SuperVictoryOwner',model.Name)
 end
 state:SetAttribute("RoundVictoryStartedAt",start)]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function superSkillIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
 local key=({SuperLaser='Laser',SuperFrost='Frost',SuperInvincible='Invincible',SuperFinale='Max'})[kind]
 local holder=Instance.new('Frame');holder.Position=UDim2.fromOffset(x,y);holder.Size=UDim2.fromOffset(size,size);holder.BackgroundColor3=Color3.fromRGB(14,33,63);holder.BorderSizePixel=0;holder.Parent=parent
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.2,0);corner.Parent=holder
 if key and C.Icons[key]~=''then local image=Instance.new('ImageLabel');image.Size=UDim2.fromScale(1,1);image.BackgroundTransparency=1;image.ScaleType=Enum.ScaleType.Fit;image.Image=C.Icons[key];image.ZIndex=4;image.Parent=holder
 else
  local text=Instance.new('TextLabel');text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Font=Enum.Font.FredokaOne;text.TextScaled=true;text.Text=({SuperLaser='LASER',SuperFrost='GEL',SuperInvincible='1 PV',SuperFinale='MAX'})[kind]or'S';text.TextColor3=key=='Laser'and Color3.fromRGB(255,55,55)or(key=='Invincible'and Color3.fromRGB(90,240,105)or Color3.fromRGB(200,243,255));text.ZIndex=4;text.Parent=holder
 end
 return holder
end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function emblem(parent,kind,color,x,y,size)]====],[ [====[after]====] ]=[====[local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,5)=='Super'then superSkillIconV1(parent,kind,x,y,size);return end]====]},{[ [====[variants]====] ]={{[ [====[before]====] ]=[====[if currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then]====],[ [====[after]====] ]=[====[if currentCrax~="Crax_Super"and currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then]====]},{[ [====[before]====] ]=[====[if lv>=4 and TrophyIcons then]====],[ [====[after]====] ]=[====[if currentCrax~="Crax_Super"and lv>=4 and TrophyIcons then]====]}}},{[ [====[variants]====] ]={{[ [====[before]====] ]=[====[if i==4 and currentCrax=="Crax_Inverted"then]====],[ [====[after]====] ]=[====[    if i==4 and currentCrax=="Crax_Super"then
     if revealed then superSkillIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 and currentCrax=="Crax_Inverted"then]====]},{[ [====[before]====] ]=[====[    if i==4 then
     local holder=]====],[ [====[after]====] ]=[====[    if i==4 and currentCrax=="Crax_Super"then
     if revealed then superSkillIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 then
     local holder=]====]}}}}},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxBookCinema]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[self.trophyArt:ClearAllChildren()]====],[ [====[after]====] ]=[====[self.trophyArt:ClearAllChildren()
 if id=='Crax_Super'then
  local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'));local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='SUPER MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(246,192,42),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text='EXÉCUTION MAX';return
 end]====]}}}}
local modules={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSuperAppearance]====],[ [====[class]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local M={};local saved=setmetatable({},{__mode='k'})
local function part(model,name)local p=model:FindFirstChild(name,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(model)
 local accessory=model:FindFirstChild('SuperAccessories');if accessory then accessory:Destroy()end
 for _,name in ipairs({'EyeLeft','EyeRight'})do local eye=part(model,name);local origin=eye and eye:FindFirstChild('SuperLaserOriginV1');if origin and origin:GetAttribute('SuperOwned')then origin:Destroy()end end
 local map=saved[model]
 if map then for p,s in pairs(map)do if p.Parent then
  p.Color=s.color;p.Material=s.material;p.Reflectance=s.reflectance;p.Transparency=s.alpha
  if p:IsA('MeshPart')then p.TextureID=s.texture end
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then c:Destroy()end end
  for _,c in ipairs(s.surfaces)do c:Clone().Parent=p end
 end end end;saved[model]=nil
end
function M.Apply(model,assets)
 M.Restore(model);local head=assert(part(model,'Head'),'Head natif absent');local left=assert(part(model,'EyeLeft'));local right=assert(part(model,'EyeRight'))
 local origin=assert(assets:FindFirstChild('FIT_HeadCenter',true));local front=assert(assets:FindFirstChild('FIT_Front',true));local up=assert(assets:FindFirstChild('FIT_Up',true))
 local sourceForward=(front.Position-origin.Position).Unit;local sourceUp=(up.Position-origin.Position).Unit
 local sourceRight=sourceForward:Cross(sourceUp).Unit;sourceUp=sourceRight:Cross(sourceForward).Unit
 local sourceCF=CFrame.fromMatrix(origin.Position,sourceRight,sourceUp,-sourceForward)
 local forward=((left.Position+right.Position)*.5-head.Position);forward=(forward-head.CFrame.UpVector*forward:Dot(head.CFrame.UpVector)).Unit
 local targetRight=forward:Cross(head.CFrame.UpVector).Unit
 local targetCF=CFrame.fromMatrix(head.Position,targetRight,head.CFrame.UpVector,-forward)
 local scale=(head.Size.Y*.5)/(up.Position-origin.Position).Magnitude
 local oldPivot=model:GetPivot();local snapshots={};saved[model]=snapshots
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then
  local s={color=p.Color,material=p.Material,reflectance=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then s.surfaces[#s.surfaces+1]=c:Clone();c:Destroy()end end;snapshots[p]=s
  local n=p.Name:lower()
  p.Color=n:find('tooth',1,true)and Color3.fromRGB(246,245,232)or(n:find('gums',1,true)and Color3.fromRGB(216,126,113)or((n=='eyeleft'or n=='eyeright'or n:find('inner',1,true))and Color3.fromRGB(12,17,21)or Color3.fromRGB(235,238,227)))
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  if p:IsA('MeshPart')then p.TextureID=''end
  if n:find('cross',1,true)then p.Transparency=1 end
 end end
 local accessory=Instance.new('Model');accessory.Name='SuperAccessories'
 for _,source in ipairs(assets:GetDescendants())do if source:IsA('BasePart')and not source.Name:match('^FIT_')then
  local p=source:Clone();local rel=sourceCF:ToObjectSpace(source.CFrame)
  p.Size=source.Size*scale;p.CFrame=targetCF*(rel.Rotation+rel.Position*scale)
  p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  local name=p.Name
  p.Color=(name:find('Hair',1,true)or name:find('Curl',1,true)or name:find('Temple',1,true))and Color3.fromRGB(8,22,32)or(name=='SuperChinBlue'and Color3.fromRGB(20,116,183)or(name=='SuperEmblem_YellowField'and Color3.fromRGB(255,204,40)or Color3.fromRGB(220,37,35)))
  if p:IsA('MeshPart')then p.TextureID=''end
  for _,c in ipairs(p:GetDescendants())do if c:IsA('LuaSourceContainer')or c:IsA('Sound')or c:IsA('SurfaceAppearance')then c:Destroy()end end
  p.Parent=accessory
 end end
 accessory.Parent=model
 for _,eye in ipairs({left,right})do local origin=Instance.new('Attachment');origin.Name='SuperLaserOriginV1';origin:SetAttribute('SuperOwned',true);origin.Parent=eye end
 if not model.PrimaryPart then model.WorldPivot=oldPivot end
end
return M
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxSuperClient]====],[ [====[class]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- Presentation only: no FireServer, client-selected targets, HP writes or gameplay physics.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local SoundService=game:GetService('SoundService');local Content=game:GetService('ContentProvider')
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxSuperFX')
local C=require(RS:WaitForChild('CraxSuperConfig'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local RED=Color3.fromRGB(244,38,41);local BLUE=Color3.fromRGB(40,156,255);local ICE=Color3.fromRGB(154,235,255);local GREEN=Color3.fromRGB(78,239,82);local WHITE=Color3.fromRGB(247,250,240)
local root=Instance.new('Folder');root.Name='SuperCrax_LocalPresentation';root.Parent=workspace
local actors={};local frozen={};local crystals={};local bursts={};local deaths={};local audio={};local connections={};local scene;local seenFinale;local now=0;local accumulator=0
local random=Random.new()
local function connect(signal,fn)local c=signal:Connect(fn);connections[#connections+1]=c;return c end
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function head(m)local p=m and m:FindFirstChild('Head',true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local config=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local f=config and id and config:FindFirstChild('Frame_'..id)
 return f and f.Value or CFrame.identity
end
local function part(parent,size,color,cf,alpha)
 return make('Part',{Size=size,Color=color,CFrame=cf or CFrame.identity,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic},parent)
end
local function location(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,pos,loop,group,offset)
 local id=C.Audio[name];if type(id)~='string'or not id:match('^rbxassetid://%d+$')then return end
 local anchor=part(root,Vector3.one*.05,WHITE,CFrame.new(pos),1)
 local s=make('Sound',{SoundId=id,Volume=group=='Finale'and C.FinaleVolume or C.CombatVolume,Looped=loop==true,RollOffMinDistance=C.RollOffMin,RollOffMaxDistance=C.RollOffMax},anchor)
 local mix=SoundService:FindFirstChild('CraxMusicControl');if group=='Finale'and mix and mix:IsA('SoundGroup')then s.SoundGroup=mix end
 if offset then s.TimePosition=offset end;s:Play()
 local entry={sound=s,anchor=anchor,born=os.clock(),group=group,loop=loop};audio[#audio+1]=entry
 return entry
end
local function stopAudio(entry)if entry then entry.sound:Stop();entry.anchor:Destroy();entry.dead=true end end
local function beam(parent,width,color)
 local a=part(parent,Vector3.one*.05,WHITE,nil,1);local b=part(parent,Vector3.one*.05,WHITE,nil,1)
 local at0=make('Attachment',{},a);local at1=make('Attachment',{},b)
 local layers={}
 for i,factor in ipairs({3.1,1,.28})do
  layers[i]=make('Beam',{Attachment0=at0,Attachment1=at1,Width0=width*factor,Width1=width*factor,FaceCamera=true,Color=ColorSequence.new(i==3 and WHITE or color),Transparency=NumberSequence.new(i==1 and .82 or(i==2 and .18 or .03)),LightEmission=.9,LightInfluence=0,Segments=1},a)
 end
 return {a=a,b=b,layers=layers}
end
local function setBeam(line,a,b,visible)
 line.a.Position=a;line.b.Position=b;for _,v in ipairs(line.layers)do v.Enabled=visible~=false end
end
local function destroyBeam(line)line.a:Destroy();line.b:Destroy()end
local function burst(pos,color,count,lifetime,inward)
 local items={};count=low and math.min(count,12)or count
 for i=1,count do local p=part(root,Vector3.one*random:NextNumber(.10,.30),i%3==0 and WHITE or color,CFrame.new(pos));items[i]={part=p,offset=Vector3.new(random:NextNumber(-1,1),random:NextNumber(-1,1),random:NextNumber(-.5,.5)).Unit*random:NextNumber(1,3)}end
 bursts[#bursts+1]={born=os.clock(),duration=lifetime,items=items,origin=pos,inward=inward}
end
local function crystal(parent,scale)
 local model=make('Model',{},parent)
 local core=part(model,Vector3.new(scale*.80,scale*1.60,scale*.85),GREEN,CFrame.identity,.15);core.Material=Enum.Material.Glass
 for i=1,6 do local a=i*math.pi/3;local p=make('WedgePart',{Size=Vector3.new(scale*.66,scale,scale*.75),Color=i%2==0 and GREEN or Color3.fromRGB(139,255,157),Material=Enum.Material.Glass,Transparency=.23,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,CFrame=CFrame.new(math.cos(a)*scale*.35,0,math.sin(a)*scale*.35)*CFrame.Angles(0,-a,math.rad(14))},model)end
 if not low then make('PointLight',{Color=GREEN,Brightness=.65,Range=scale*8,Shadows=false},core)end
 return model
end
local function shell(m,parent)
 local h=head(m);if not h then return end
 local model=make('Model',{},parent);local ball=part(model,h.Size*1.08,ICE,frame()*h.CFrame,.74);ball.Shape=Enum.PartType.Ball;ball.Material=Enum.Material.Ice
 local cracks={}
 for i=1,(low and 5 or 9)do
  local a=i*2.39996;local p=part(model,Vector3.new(.035,h.Size.Y*.3,.035),i%3==0 and WHITE or ICE,CFrame.identity,.3);cracks[i]={part=p,angle=a}
 end
 return {model=model,ball=ball,cracks=cracks,source=m}
end
local function updateShell(s,cf,size,alpha)
 s.ball.CFrame=cf;s.ball.Size=size*1.08;if alpha then s.ball.Transparency=alpha end
 for _,v in ipairs(s.cracks)do v.part.CFrame=cf*CFrame.new(math.cos(v.angle)*size.X*.28,math.sin(v.angle)*size.Y*.28,-size.Z*.48)*CFrame.Angles(0,0,v.angle)end
end
local function restoreSteel(a)
 if not a.materials then return end
 for p,s in pairs(a.materials)do if p.Parent then
  if p.Material==Enum.Material.Metal then p.Material=s.material end
  if p.Color==s.applied then p.Color=s.color end
  if p.Reflectance==.22 then p.Reflectance=s.reflectance end
 end end;a.materials=nil
end
local function steel(a)
 a.materials={}
 for _,p in ipairs(a.owner:GetDescendants())do if p:IsA('BasePart')then
  local hair=p.Name:find('Hair',1,true)or p.Name:find('Curl',1,true)
  local color=hair and Color3.fromRGB(45,61,72)or Color3.fromRGB(177,205,223)
  a.materials[p]={material=p.Material,color=p.Color,reflectance=p.Reflectance,applied=p.Color,target=color};p.Material=Enum.Material.Metal;p.Reflectance=.22
 end end
end
local function clearActor(m)
 local a=actors[m];if not a then return end
 restoreSteel(a);stopAudio(a.loop)
 for _,line in ipairs(a.beams or{})do destroyBeam(line)end
 for _,p in ipairs(a.trail or{})do p.part:Destroy()end
 for _,p in ipairs(a.flow or{})do p:Destroy()end
 actors[m]=nil
end
local function clearCombat()
 for m in pairs(actors)do clearActor(m)end
 for m,s in pairs(frozen)do s.model:Destroy();frozen[m]=nil end
 for m,k in pairs(crystals)do k.model:Destroy();crystals[m]=nil end
 for _,s in ipairs(audio)do if s.loop and s.group~='Finale'then stopAudio(s)end end
end
local function clone(m,cf,parent)
 local arch=m.Archivable;m.Archivable=true;local ok,copy=pcall(function()return m:Clone()end);m.Archivable=arch
 if not ok or not copy then return end
 for _,o in ipairs(copy:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')or o:IsA('BillboardGui')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 copy.Parent=parent;copy:PivotTo(cf);return copy
end
local function clearDeaths()
 for m,d in pairs(deaths)do
  for p,v in pairs(d.hidden)do if p.Parent then p.LocalTransparencyModifier=v end end
  d.copy:Destroy();deaths[m]=nil
 end
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('SuperCraxFinaleCamera')
 for p,value in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=value else p.Enabled=value end end end
 if workspace.CurrentCamera==s.camera then s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus end
 s.folder:Destroy();if s.color then s.color:Destroy()end
 for _,a in ipairs(audio)do if a.group=='Finale'then stopAudio(a)end end
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='SuperFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 then return end
 if state:GetAttribute('SuperVictoryCrax')~=C.Id or (state:GetAttribute('SuperVictoryLevel')or 0)<4 or state:GetAttribute('SuperVictoryMatch')~=state:GetAttribute('CraxMatchToken')then return end
 local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken');if seenFinale==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera
 if not loser or not head(loser)or not head(winner)or not cam then return end
 local projection=frame()
 if player:GetAttribute('ArenaSeat')==nil then local ch=player.Character;local hr=ch and ch:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-location(winner)).Magnitude>180 then return end end
 seenFinale=tostring(token)..':'..round;clearDeaths()
 local s={folder=make('Folder',{Name='SuperFinale'},root),winner=winner,loser=loser,round=round,match=token,camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,hidden={},cues={},start=state:GetAttribute('RoundVictoryStartedAt'),projection=projection}
 local center=loser:GetPivot().Position;s.center=center;s.winPosition=center+Vector3.new(-11,2.1,0);s.winRotation=winner:GetPivot().Rotation
 s.victim=clone(loser,projection*CFrame.new(center)*loser:GetPivot().Rotation,s.folder)
 s.hero=clone(winner,projection*CFrame.new(s.winPosition)*s.winRotation,s.folder)
 if not s.victim or not s.hero then s.folder:Destroy();return end
 s.ice=shell(loser,s.folder)
 s.lines={beam(s.folder,.20,RED),beam(s.folder,.20,RED)}
 for _,line in ipairs(s.lines)do for _,layer in ipairs(line.layers)do layer.Enabled=false end end
 s.fragments={};s.wind={}
 for i=1,(low and 12 or 24)do s.wind[i]=part(s.folder,Vector3.one*.16,ICE,nil,1)end
 local visible={};for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.8 then visible[#visible+1]=p end end
 if #visible==0 then s.folder:Destroy();return end
 for i=1,(low and 32 or 84)do
  local source=visible[(i-1)%#visible+1];local off=Vector3.new(random:NextNumber(-.45,.45)*source.Size.X,random:NextNumber(-.45,.45)*source.Size.Y,random:NextNumber(-.45,.45)*source.Size.Z)
  local origin=source.CFrame:PointToWorldSpace(off)
  local p=part(s.folder,Vector3.one*random:NextNumber(.18,.56),i%3==0 and ICE or source.Color,CFrame.new(origin),1)
  if i%3==0 then p.Material=Enum.Material.Ice end
  s.fragments[i]={part=p,origin=origin,velocity=(origin-(projection*CFrame.new(center)).Position+Vector3.new(random:NextNumber(-3,3),random:NextNumber(0,5),random:NextNumber(-2,2)))*1.5}
 end
 for _,m in ipairs({winner,loser})do for _,o in ipairs(m:GetDescendants())do
  if o:IsA('BasePart')then s.hidden[o]=o.LocalTransparencyModifier;o.LocalTransparencyModifier=1
  elseif o:IsA('BillboardGui')then s.hidden[o]=o.Enabled;o.Enabled=false end
 end end
 s.color=make('ColorCorrectionEffect',{Name='SuperFinaleLocalColor',Saturation=-.12,Contrast=.025},cam)
 scene=s
 Run:BindToRenderStep('SuperCraxFinaleCamera',Enum.RenderPriority.Last.Value+1100,function()
  if scene~=s then return end
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.ReturnEnd or state:GetAttribute('RoundId')~=s.round or state:GetAttribute('CraxMatchToken')~=s.match or state:GetAttribute('Phase')~='RoundOver'or workspace.CurrentCamera~=cam or not winner.Parent or winner:GetAttribute('CraxId')~=C.Id then stopScene();return end
  local fly=math.clamp(t/F.FlyEnd,0,1);fly=1-(1-fly)^3
  local heroPos=s.winPosition+Vector3.new(-4*(1-fly),2.2*(1-fly)+math.sin(t*2)*.18,0)
  s.hero:PivotTo(projection*CFrame.new(heroPos)*s.winRotation*CFrame.Angles(0,0,-.10))
  local victimHead=head(s.victim);local heroHead=head(s.hero)
  local freeze=math.clamp((t-F.FreezeStart)/(F.FreezeEnd-F.FreezeStart),0,1)
  updateShell(s.ice,victimHead.CFrame,victimHead.Size,1-freeze*.62)
  for _,v in ipairs(s.ice.cracks)do v.part.Transparency=1-freeze*.8 end
  for i,p in ipairs(s.wind)do
   if t>=F.FreezeStart and t<F.FreezeEnd then
    local u=(t*1.3+i/#s.wind)%1;local from=heroHead.Position+projection:VectorToWorldSpace(Vector3.new(0,-.8,-3.8));local finish=victimHead.Position
    p.Position=from:Lerp(finish,u)+projection:VectorToWorldSpace(Vector3.new(0,math.sin(i*2.4+t)*u*2,math.cos(i*2.4+t)*u*.6));p.Size=Vector3.one*(.15+u*.35);p.Transparency=.4+math.abs(u-.5)*.8
   else p.Transparency=1 end
  end
  local charge=t>=F.ChargeStart and t<F.ChargeEnd
  local redEyes=t>=F.ChargeStart and t<F.ShotEnd
  local chargeAmount=math.clamp((t-F.ChargeStart)/(F.ChargeEnd-F.ChargeStart),0,1)
  for _,v in ipairs(s.ice.cracks)do v.part.Color=redEyes and ICE:Lerp(RED,chargeAmount*.6)or ICE end
  for i,line in ipairs(s.lines)do
   local eye=s.hero:FindFirstChild(i==1 and'EyeLeft'or'EyeRight',true)
   if eye and not eye:IsA('BasePart')then eye=eye:FindFirstChildWhichIsA('BasePart',true)end
   local p=eye and eye.Position or heroHead.Position
   setBeam(line,p,victimHead.Position+projection:VectorToWorldSpace(Vector3.new((i==1 and-.5 or .5),0,-victimHead.Size.Z*.45)),t>=F.ChargeEnd and t<F.ShotEnd)
   if eye then eye.Color=redEyes and Color3.fromRGB(12,17,21):Lerp(RED,chargeAmount)or Color3.fromRGB(12,17,21);eye.Material=redEyes and Enum.Material.Neon or Enum.Material.SmoothPlastic end
  end
  if t>=F.ShotEnd then
   for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=1 end end
   for _,p in ipairs(s.ice.model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 end end
   local age=t-F.ShotEnd
   for _,f in ipairs(s.fragments)do f.part.Transparency=math.clamp((age-.6)/(F.ShatterEnd-F.ShotEnd-.6),0,1);f.part.CFrame=CFrame.new(f.origin+f.velocity*age+Vector3.new(0,-2.5*age*age,0))*CFrame.Angles(age,age*.6,age*.4)end
  end
  local cues={{0,'FinaleFly'},{F.FreezeStart,'FrostLoop'},{F.FreezeEnd-.4,'FreezeApply'},{F.ChargeStart,'FinaleLaserCharge'},{F.ChargeEnd,'FinaleLaserShot'},{F.ShotEnd,'FinaleShatter'}}
  for i,cue in ipairs(cues)do if t>=cue[1]and not s.cues[i]then s.cues[i]=true;sound(cue[2],heroHead.Position,false,'Finale',math.max(0,t-cue[1]))end end
  local middle=projection*CFrame.new(center+Vector3.new(-5,1,0));local target=middle.Position
  local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(23,20/(2*math.tan(math.rad(20))*math.max(.42,aspect)))
  if charge then target=target:Lerp(heroHead.Position,.5);distance*=.78 end
  local wanted=CFrame.lookAt(target+projection:VectorToWorldSpace(Vector3.new(0,3,-distance)),target,projection.UpVector)
  local ending=math.clamp((t-F.ShatterEnd)/(F.ReturnEnd-F.ShatterEnd),0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=40+(s.fov-40)*ending
  cam.CFrame=wanted:Lerp(s.cf,ending*ending);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner;local pos=m and location(m)
 if kind=='Clear'then clearCombat();return end
 if kind=='OwnerClear'then clearActor(m);if crystals[m]then crystals[m].model:Destroy();crystals[m]=nil end;return end
 if kind=='Start'and m and pos then
  clearActor(m);local a={owner=m,kind=d.Kind,id=d.Activation,beams={},trail={},flow={},age=0,born=os.clock()};actors[m]=a
  if d.Kind=='Dash'then steel(a);sound('SteelStart',pos);a.loop=sound('CircleDash',pos,true)
  elseif d.Kind=='Laser'then sound('LaserStart',pos);a.loop=sound('LaserLoop',pos,true);a.beams={beam(root,.18,RED),beam(root,.18,RED)}
   if player:GetAttribute('ArenaSeat')~=nil then for i,line in ipairs(a.beams)do local eye=m:FindFirstChild(i==1 and'EyeLeft'or'EyeRight',true);local origin=eye and eye:FindFirstChild('SuperLaserOriginV1');if origin then for _,layer in ipairs(line.layers)do layer.Attachment0=origin end end end end
  elseif d.Kind=='Frost'then a.guide=beam(root,.1,ICE);a.beams={a.guide};for _,layer in ipairs(a.guide.layers)do layer.Enabled=false end;sound('FrostCharge',pos);for i=1,(low and 9 or 18)do a.flow[i]=part(root,Vector3.one*.15,ICE,CFrame.new(pos),.55)end end
 elseif kind=='State'then local a=actors[m];if a and a.id==d.Activation then a.snapshot=d;a.age=d.Age end
 elseif kind=='Stop'then local a=actors[m];if a and a.id==d.Activation then
  if pos then sound(a.kind=='Dash'and'SteelEnd'or(a.kind=='Laser'and'LaserEnd'or'FreezeApply'),pos)end;clearActor(m)
 end
 elseif kind=='FrostFire'then local a=actors[m];if a and a.id==d.Activation and pos then stopAudio(a.loop);a.loop=sound('FrostLoop',pos,true)end
 elseif kind=='DashHit'and d.Target then local p=location(d.Target);if p then burst(p,WHITE,10,.3,false);sound('DashHit',p)end
 elseif kind=='Freeze'and m and pos then
  if not frozen[m]then frozen[m]=shell(m,root);sound('FreezeApply',pos)end
 elseif kind=='Thaw'or kind=='Shatter'then
  if frozen[m]then frozen[m].model:Destroy();frozen[m]=nil end
  if kind=='Shatter'and pos then burst(pos,ICE,low and 14 or 30,.7,false);sound('IceShatter',pos)end
 elseif kind=='LastStand'and pos then burst(pos,WHITE,18,.6,false);sound('LastStand',pos)
 elseif kind=='Crystal'then
  if crystals[m]then crystals[m].model:Destroy()end
  local k={model=crystal(root,d.Radius),position=d.Position,id=d.Activation};crystals[m]=k
  k.model:PivotTo(frame()*CFrame.new(d.Position));sound('KryptoniteSpawn',(frame()*CFrame.new(d.Position)).Position)
 elseif kind=='Pickup'then local k=crystals[m];if k and k.id==d.Activation then k.carrier=d.Carrier;if location(d.Carrier)then sound('KryptonitePickup',location(d.Carrier))end end
 elseif kind=='KryptoniteDeath'then
  if crystals[m]then crystals[m].model:Destroy();crystals[m]=nil end
  if pos then
   burst(pos,GREEN,24,.7,true);sound('KryptoniteDeath',pos)
   if not scene and m.Parent then
    local copy=clone(m,frame()*m:GetPivot(),root)
    if copy then
     local hidden={};for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 end end
     deaths[m]={copy=copy,hidden=hidden,start=os.clock(),base=frame()*m:GetPivot()}
    end
   end
  end
 end
end)
connect(Run.Heartbeat,function(dt)
 accumulator+=dt;if accumulator<(low and 1/20 or 1/30)then return end;accumulator=0;now=os.clock()
 for m,a in pairs(actors)do
  local pos=location(m)
  if not pos or not m.Parent or m:GetAttribute('CraxId')~=C.Id or(m:GetAttribute('Health')or 0)<=0 then clearActor(m)
  else
   if a.loop and not a.loop.dead then a.loop.anchor.Position=pos;local paused=Clock.Paused(m);if paused and a.loop.sound.IsPlaying then a.loop.sound:Pause();a.loop.paused=true elseif not paused and a.loop.paused then a.loop.paused=false;a.loop.sound:Resume()end end
   local snapshot=a.snapshot
   if a.kind=='Dash'then
    if a.materials then local u=math.clamp((now-a.born)/.10,0,1);for p,s in pairs(a.materials)do if p.Parent then s.applied=s.color:Lerp(s.target,u);p.Color=s.applied end end end
    if not a.last or(pos-a.last).Magnitude>.25 then
     local line=part(root,Vector3.new(.11,.11,math.max(.05,a.last and(pos-a.last).Magnitude or .05)),#a.trail%2==0 and RED or BLUE,nil,.5)
     line.CFrame=a.last and CFrame.lookAt((pos+a.last)*.5,pos,frame().LookVector)or CFrame.new(pos)
     a.trail[#a.trail+1]={part=line,born=now};a.last=pos
    end
    for i=#a.trail,1,-1 do local v=a.trail[i];local age=now-v.born;if age>.24 then v.part:Destroy();table.remove(a.trail,i)else v.part.Transparency=.5+age*.5/.24 end end
   elseif a.kind=='Laser'and snapshot and snapshot.Beams then
    for i,line in ipairs(a.beams)do local b=snapshot.Beams[i];if b then setBeam(line,(frame()*CFrame.new(b.From)).Position,(frame()*CFrame.new(b.To)).Position)end end
   elseif a.kind=='Frost'then
    if snapshot and snapshot.From and snapshot.To and a.guide then
     a.guide.a.Position=(frame()*CFrame.new(snapshot.From)).Position;a.guide.b.Position=(frame()*CFrame.new(snapshot.To)).Position
     for i,layer in ipairs(a.guide.layers)do layer.Enabled=i==1;if i==1 then layer.Width0=snapshot.Width;layer.Width1=snapshot.Width;layer.Transparency=NumberSequence.new(.90)end end
    end
    for i,p in ipairs(a.flow)do
     if snapshot and snapshot.From and snapshot.To then
      local start=(frame()*CFrame.new(snapshot.From)).Position;local finish=(frame()*CFrame.new(snapshot.To)).Position
      local u=(now*.75+i/#a.flow)%1;local axis=(finish-start).Unit;local side=axis:Cross(frame().LookVector).Unit
      p.Size=Vector3.one*(.17+u*.45);p.Position=start:Lerp(finish,u)+side*(math.sin(i*2.399+now)*(snapshot.Width or 8)*.43*u)
      p.Transparency=.4+math.abs(u-.5)*.8
     else p.Position=pos+frame():VectorToWorldSpace(Vector3.new(math.sin(now*3+i),math.cos(now*3+i),-4))*(1-(now*.4+i/#a.flow)%1);p.Transparency=.65 end
    end
   end
  end
 end
 for m,s in pairs(frozen)do local h=head(m);if not h or not m.Parent or(m:GetAttribute('Health')or 0)<=0 then s.model:Destroy();frozen[m]=nil else updateShell(s,frame()*h.CFrame,h.Size,.74)end end
 for owner,k in pairs(crystals)do
  if not owner or not owner.Parent or(owner:GetAttribute('Health')or 0)<=0 then k.model:Destroy();crystals[owner]=nil
  elseif k.carrier and location(k.carrier)then k.model:PivotTo(CFrame.new(location(k.carrier)+frame():VectorToWorldSpace(Vector3.new(4.7,1.1,-1)))*CFrame.Angles(0,now*.5,0))
  else k.model:PivotTo(frame()*CFrame.new(k.position+Vector3.new(0,math.sin(now*1.5)*.12,0))*CFrame.Angles(0,now*.35,0))end
 end
 for i=#bursts,1,-1 do local b=bursts[i];local u=(now-b.born)/b.duration
  if u>=1 then for _,v in ipairs(b.items)do v.part:Destroy()end;table.remove(bursts,i)
  else for _,v in ipairs(b.items)do v.part.Position=b.origin+v.offset*(b.inward and(1-u)or u);v.part.Transparency=u*u end end
 end
 for m,d in pairs(deaths)do local t=math.min(1,(now-d.start)/.7);d.copy:PivotTo(d.base*CFrame.new(0,-t*t*1.2,0)*CFrame.Angles(0,0,t*.7));for _,p in ipairs(d.copy:GetDescendants())do if p:IsA('BasePart')and p.Transparency<1 then p.Color=p.Color:Lerp(GREEN,.02*(1-t));p.Reflectance=.03 end end end
 for i=#audio,1,-1 do local a=audio[i];if a.dead or(not a.loop and a.sound.IsLoaded and now-a.born>1 and not a.sound.IsPlaying and not a.sound.IsPaused)or now-a.born>30 then if not a.dead then stopAudio(a)end;table.remove(audio,i)end end
end)
local function clearAll()
 clearCombat();stopScene();clearDeaths()
 for _,b in ipairs(bursts)do for _,v in ipairs(b.items)do v.part:Destroy()end end;table.clear(bursts)
 for _,a in ipairs(audio)do stopAudio(a)end;table.clear(audio)
end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seenFinale=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryKind','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.spawn(function()local list={};for _,id in pairs(C.Audio)do if id~=''then list[#list+1]=id end end;if #list>0 then pcall(function()Content:PreloadAsync(list)end)end end)
task.defer(beginScene)
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSuperConfig]====],[ [====[class]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local C={Id='Crax_Super',AbilityId='SuperHero',
 Health=100,Melee=8,DashDuration=1.5,DashTurns=3,DashDamageMultiplier=2,
 DashWait={8,12},LaserWait={5,8},LaserDuration=2.5,LaserDPS=15,
 FrostContacts=3,FrostCharge=2,FrostDuration=3.5,FreezeDuration=5,ShatterDamage=35,
 -- Creator-confirmed answers (2026-11-02):
 DashHitPolicy='PerTurn',ChannelMobile=true,LastStandHealing='LOCK_AT_ONE',
 -- Unconfirmed implementation choices, exposed rather than disguised as approved rules:
 CooldownOrigin='End',FrostContactPolicy='ConfirmedNormalMelee',DashCanShatter=false,
 LaserAim='FixedIndependent',FrostAim='FarthestCorner',LaserWidthPerRadius=.065,
 FrostWidthFraction=.28,DashRadiusPerHead=.8,DashEntryBlend=.10,
 KryptoniteRadius=1.6,KryptoniteSpeed=1.5,KryptoniteDropOnLoss=true,
 PricePolicy='ReferenceMonsterConfirmed',Quality='Auto',
 Finale={FlyEnd=1.1,FreezeStart=1.1,FreezeEnd=3.6,ChargeStart=3.6,ChargeEnd=5.1,ShotEnd=5.55,ShatterEnd=7.1,ReturnEnd=8.2},
 Audio={},Icons={Laser='',Frost='',Invincible='',Max=''},CombatVolume=.16,FinaleVolume=.22,RollOffMin=8,RollOffMax=115}
for _,n in ipairs({'SteelStart','CircleDash','DashHit','SteelEnd','LaserStart','LaserLoop','LaserEnd','FrostCharge','FrostLoop','FreezeApply','IceShatter','LastStand','KryptoniteSpawn','KryptonitePickup','KryptoniteDeath','FinaleFly','FinaleLaserCharge','FinaleLaserShot','FinaleShatter'})do C.Audio[n]=''end
local assets=game:GetService('ReplicatedStorage'):FindFirstChild('CraxSuperUserAssets')
if assets then
 for n in pairs(C.Audio)do local id=assets:GetAttribute(n);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Audio[n]=id end end
 for n in pairs(C.Icons)do local id=assets:GetAttribute('Icon_'..n);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[n]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSuperRules]====],[ [====[class]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Pure rules/geometry, no services. Directions and randomness are supplied by the server.
local R={}
function R.New(level,random,c)
 return {level=math.clamp(level,0,4),time=0,age=0,mode=nil,nextDash=random(c.DashWait[1],c.DashWait[2]),nextLaser=random(c.LaserWait[1],c.LaserWait[2]),contacts=0,ready={},serial=0,lastStand=false}
end
function R.Contact(r,normal,loss,c)
 if r.level>=2 and normal and loss>0 then r.contacts=math.min(c.FrostContacts,r.contacts+1);if r.contacts>=c.FrostContacts then r.ready.Frost=r.ready.Frost or r.time end end
end
function R.Advance(r,dt,canStart,random,c)
 assert(dt>=0 and dt<math.huge);local out={};r.time+=dt
 if r.mode then
  local duration=r.mode=='Dash'and c.DashDuration or(r.mode=='Laser'and c.LaserDuration or(c.FrostCharge+c.FrostDuration))
  local used=math.min(dt,math.max(0,duration-r.age));local before=r.age;r.age+=used
  out.active={kind=r.mode,before=before,after=r.age,dt=used}
  if r.age>=duration-1e-9 then
   out.ended=r.mode
   if c.CooldownOrigin=='End'and r.mode=='Dash'then r.nextDash=r.time+random(c.DashWait[1],c.DashWait[2])elseif c.CooldownOrigin=='End'and r.mode=='Laser'then r.nextLaser=r.time+random(c.LaserWait[1],c.LaserWait[2])end
   r.mode=nil;r.age=0
  end
  return out
 end
 if r.time>=r.nextDash then r.ready.Dash=r.ready.Dash or r.nextDash end
 if r.level>=1 and r.time>=r.nextLaser then r.ready.Laser=r.ready.Laser or r.nextLaser end
 if r.level>=2 and r.contacts>=c.FrostContacts then r.ready.Frost=r.ready.Frost or r.time end
 if not canStart then return out end
 local best,deadline
 -- Oldest ready wins; tie order is explicit. Ready skills cannot be starved by newly ready skills.
 for _,kind in ipairs({'Frost','Dash','Laser'})do local t=r.ready[kind];if t and(not deadline or t<deadline)then best=kind;deadline=t end end
 if best then
  r.mode=best;r.age=0;r.serial+=1;r.ready[best]=nil
  if best=='Frost'then r.contacts=0 end
  if c.CooldownOrigin=='Launch'then if best=='Dash'then r.nextDash=r.time+random(c.DashWait[1],c.DashWait[2])elseif best=='Laser'then r.nextLaser=r.time+random(c.LaserWait[1],c.LaserWait[2])end end
  out.started=best
 end
 return out
end
function R.LastStand(r,damage,hp,canStart)
 if r.lastStand then return 0,false end
 if r.level>=3 and damage>=hp and damage>0 and canStart then r.lastStand=true;return math.max(0,hp-1),true end
 return damage,false
end
function R.Turn(age,c)return math.min(c.DashTurns,math.floor(math.max(0,age)/c.DashDuration*c.DashTurns)+1)end
function R.MarkDashHit(hits,target,turn,c)
 local key=c.DashHitPolicy=='PerTurn'and turn or 1
 if hits[target]==key then return false end;hits[target]=key;return true
end
function R.Farthest(x,y,b)
 local best,dist
 for _,p in ipairs({{b.minX,b.minY},{b.minX,b.maxY},{b.maxX,b.minY},{b.maxX,b.maxY}})do
  local d=(p[1]-x)^2+(p[2]-y)^2
  if not dist or d>dist then best=p;dist=d end
 end
 local dx,dy=best[1]-x,best[2]-y;local length=math.sqrt(dx*dx+dy*dy)
 return dx/length,dy/length,length
end
-- Intervals of a moving point inside a finite capsule. Supports target sweep, not a point sample.
local function linear(a,d,lo,hi)
 if math.abs(d)<1e-12 then if a>=lo and a<=hi then return 0,1 end;return end
 local x,y=(lo-a)/d,(hi-a)/d;if x>y then x,y=y,x end
 x,y=math.max(0,x),math.min(1,y);if y>x then return x,y end
end
local function circle(px,py,vx,vy,cx,cy,r)
 px-=cx;py-=cy;local a=vx*vx+vy*vy;local cc=px*px+py*py-r*r
 if a<1e-18 then if cc<=0 then return 0,1 end;return end
 local b=2*(px*vx+py*vy);local discriminant=b*b-4*a*cc;if discriminant<=0 then return end
 local q=math.sqrt(discriminant);local x,y=math.max(0,(-b-q)/(2*a)),math.min(1,(-b+q)/(2*a));if y>x then return x,y end
end
function R.Exposure(px0,py0,px1,py1,beams,radius)
 local intervals={};local vx,vy=px1-px0,py1-py0
 for _,beam in ipairs(beams)do
  if beam.length>1e-9 then
  local px,py=px0-beam.x,py0-beam.y
  local dx,dy=beam.dx,beam.dy;local length=beam.length
  local a,b=linear(px*dx+py*dy,vx*dx+vy*dy,0,length)
  local c,d=linear(px*dy-py*dx,vx*dy-vy*dx,-radius,radius)
  if a and c then local lo,hi=math.max(a,c),math.min(b,d);if hi>lo then intervals[#intervals+1]={lo,hi}end end
  for _,endp in ipairs({0,length})do local lo,hi=circle(px,py,vx,vy,dx*endp,dy*endp,radius);if lo then intervals[#intervals+1]={lo,hi}end end
  end
 end
 table.sort(intervals,function(a,b)return a[1]<b[1]end)
 local total,lo,hi=0
 for _,i in ipairs(intervals)do
  if not lo then lo,hi=i[1],i[2]elseif i[1]<=hi then hi=math.max(hi,i[2])else total+=hi-lo;lo,hi=i[1],i[2]end
 end
 if lo then total+=hi-lo end
 return math.clamp(total,0,1)
end
return R
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSuperRuntime]====],[ [====[class]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Server authority. Runs inside ArenaMovement's existing fixed-step simulation.
local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxSuperConfig'));local R=require(RS:WaitForChild('CraxSuperRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local silenceModule=RS:FindFirstChild('CraxSilenceGate')
local Silence=silenceModule and require(silenceModule)or{CanStart=function(model)return model:GetAttribute('InvertedSilenced')~=true end}
local Locks=require(SSS:WaitForChild('CraxPositionLock'));local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local Resolver=require(SSS:WaitForChild('CraxSkillResolver'));local state=workspace:WaitForChild('CombatState')
local FX=RS:WaitForChild('CraxSuperFX');local hit=SSS:WaitForChild('BiteHit');local rng=Random.new()
local M={};local records={};local freezes={};local crystals={};local motions={};local previous={};local clock=0;local round;local match;local sequence=0;local obstacles={}
local function rand(a,b)return rng:NextNumber(a,b)end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m and m:GetAttribute('CraxId')==C.Id end
local function emit(kind,d)
 d=d or {};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(kind,d)
end
local function world(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bounds(radius)
 local l=assert(workspace:FindFirstChild('Arenaleft'));local rr=assert(workspace:FindFirstChild('ArenaRight'))
 local b=assert(workspace:FindFirstChild('Arenabottom'));local t=assert(workspace:FindFirstChild('ArenaTop'))
 return {minX=l.Position.X+l.Size.X/2+radius,maxX=rr.Position.X-rr.Size.X/2-radius,minY=b.Position.Y+b.Size.Y/2+radius,maxY=t.Position.Y-t.Size.Y/2-radius}
end
local function get(m)
 if not own(m)then return end
 local r=records[m]
 if not r then
  local level=Resolver.Resolve(m);r=R.New(level,rand,C);r.model=m;r.round=round;r.match=match;records[m]=r
 end
 return r
end
local function setMode(m,r)
 m:SetAttribute('SuperMode',r and r.mode or nil);m:SetAttribute('SuperSteel',r and r.mode=='Dash'or nil)
 m:SetAttribute('SuperInvincible',r and r.lastStand or nil);m:SetAttribute('SuperFrostContacts',r and r.contacts or nil)
end
local function releaseFreeze(m,owner)
 local group=freezes[m];if not group then return end
 if owner then group[owner]=nil else table.clear(group)end
 if not next(group)then
  local f=motions[m];if f then Locks.Unlock(f,'SuperFreeze')end
  Gate.Resume(m,'SuperFreeze');if m.Parent then m:SetAttribute('SuperFrozen',nil)end;freezes[m]=nil
  emit('Thaw',{Owner=m})
 end
end
function M.Reset()
 for m in pairs(freezes)do releaseFreeze(m)end
 for m,r in pairs(records)do setMode(m,nil);m:SetAttribute('SuperSerial',nil)end
 for _,k in pairs(crystals)do if k.carrier and k.carrier.Parent then k.carrier:SetAttribute('SuperKryptoniteCarrier',nil)end end
 records={};freezes={};crystals={};motions={};previous={};clock=0;round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken')
 emit('Clear')
end
function M.Begin(fighters)
 M.Reset();obstacles={}
 for _,name in ipairs({'Arenaleft','ArenaRight','Arenabottom','ArenaTop'})do local p=workspace:FindFirstChild(name);if p then obstacles[#obstacles+1]=p end end
 local config=RS:FindFirstChild('CraxArenaConfigV37');local folder=config and config:FindFirstChild('CanonicalOccluders')
 if folder then for _,v in ipairs(folder:GetChildren())do if v:IsA('ObjectValue')and v.Value then obstacles[#obstacles+1]=v.Value end end end
 for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end
 for _,f in ipairs(fighters)do local r=get(f.model);if r then setMode(f.model,r)end end
end
function M.Held(m)local r=records[m];return freezes[m]~=nil or(r and(r.mode=='Dash'or(C.ChannelMobile==false and r.mode=='Frost'and r.age<C.FrostCharge)))or false end
function M.Speed(m)
 for _,k in pairs(crystals)do if k.carrier==m and alive(m)then return C.KryptoniteSpeed end end
 return 1
end
function M.SuppressNormalContact(a,b)
 local ra,rb=records[a],records[b];return(ra and(ra.mode=='Dash'or ra.dashSuppress==clock))or(rb and(rb.mode=='Dash'or rb.dashSuppress==clock))or false
end
local function blocked(m)
 return Gate.Paused(m)or Deadly.Hold(m)or m:GetAttribute('PlumberInTransit')or m:GetAttribute('VicePortalTransit')or m:GetAttribute('GoldenStatue')or m:GetAttribute('FantasticInvisible')
end
local function targetAllowed(a,b)
 return alive(b)and a~=b and not Deadly.SameTeam(a,b)and not b:GetAttribute('DeadlyPhantom')and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')
end
local function touch(a0,a1,b0,b1,radius)
 local p=a0-b0;local v=(a1-a0)-(b1-b0);local vv=v:Dot(v);local t=vv>1e-12 and math.clamp(-p:Dot(v)/vv,0,1)or 0
 return(p+v*t).Magnitude<=radius
end
local function freeze(owner,target,cast)
 if cast.released[target]or not targetAllowed(owner,target)or target:GetAttribute('DeadlyInvulnerable')or target:GetAttribute('GhostInvulnerable')or target:GetAttribute('FleauFury')or workspace:GetServerTimeNow()<(target:GetAttribute('PlumberStarUntil')or 0)then return end
 local f=motions[target];if not f then return end
 local group=freezes[target]
 if not group then group={};freezes[target]=group;Locks.Lock(f,'SuperFreeze');Gate.Pause(target,'SuperFreeze');target:SetAttribute('SuperFrozen',true);emit('Freeze',{Owner=target,Source=owner,Activation=cast.id})end
 group[owner]={untilTime=clock+C.FreezeDuration,cast=cast}
end
function M.ContactDamage(attacker,target,base)
 if base==0 or not own(attacker)then return base end
 local r=records[attacker];if r and r.mode=='Dash'then return 0 end
 local group=freezes[target]
 if group and group[attacker]then return C.ShatterDamage end
 return base
end
function M.Confirm(attacker,target,lost,recoil,collision)
 if not collision then return end
 local function confirm(a,b,damage)
  local r=records[a];if not r or not alive(a)or damage<=0 then return end
  R.Contact(r,true,damage,C);a:SetAttribute('SuperFrostContacts',r.contacts)
  local group=freezes[b];local record=group and group[a]
  if record then record.cast.released[b]=true;releaseFreeze(b,a);emit('Shatter',{Owner=b,Source=a,Damage=damage})end
 end
 confirm(attacker,target,lost);confirm(target,attacker,recoil)
end
function M.PowerResult(attacker,target,lost,kind)
 if kind~='SuperDash'then return end
 local r=records[attacker];local queue=r and r.pendingHits and r.pendingHits[target]
 if not queue or #queue==0 then return end
 local event=table.remove(queue,1)
 if lost>0 then
  if C.FrostContactPolicy=='MeleeAndDash'then R.Contact(r,true,lost,C);attacker:SetAttribute('SuperFrostContacts',r.contacts)end
  local group=freezes[target];local ice=group and group[attacker]
  if event.shatter and ice and ice.cast==event.shatter then ice.cast.released[target]=true;releaseFreeze(target,attacker);emit('Shatter',{Owner=target,Source=attacker,Damage=lost})end
  emit('DashHit',{Owner=attacker,Target=target,Activation=event.id,Turn=event.turn})end
end
local function createCrystal(owner,r)
 local f=motions[owner]or Deadly.GetMotion(owner);if not f then return end
 local b=bounds(C.KryptoniteRadius);local choices={{b.minX,b.minY},{b.minX,b.maxY},{b.maxX,b.minY},{b.maxX,b.maxY}}
 local best,dist
 for _,p in ipairs(choices)do local pos=Vector2.new(p[1],p[2]);local d=(pos-f.position).Magnitude;if not dist or d>dist then dist=d;best=pos end end
 sequence+=1;local k={owner=owner,token=sequence,position=best,depth=f.depth};crystals[owner]=k
 emit('Crystal',{Owner=owner,Activation=k.token,Position=world(f,best),Radius=C.KryptoniteRadius})
end
function M.Incoming(m,amount,hp,attacker,kind)
 local r=get(m);if not r or amount<=0 then return amount end
 if r.mode=='Dash'or r.lastStand then return 0 end
 local result,activated=R.LastStand(r,amount,hp,Silence.CanStart(m))
 if activated then setMode(m,r);emit('LastStand',{Owner=m});createCrystal(m,r)end
 return result
end
function M.AllowHeal(m,amount)
 local r=records[m];if r and r.lastStand and C.LastStandHealing=='LOCK_AT_ONE'then return 0 end;return amount
end
function M.ValidateCrystalKill(model,killer,expectedRound,expectedMatch,token)
 local k=crystals[model];local r=records[model];local f=motions[model]
 if not k or k.token~=token or not r or not r.lastStand or not f or not alive(model)or state:GetAttribute('Phase')~='Fighting'or expectedRound~=round or expectedMatch~=match then return false end
 if killer then
  local carrier=motions[killer]
  return k.carrier==killer and carrier~=nil and alive(killer)and not killer:GetAttribute('PlumberInTransit')and touch(previous[model]or f.position,f.position,previous[killer]or carrier.position,carrier.position,f.radius+carrier.radius+.1)
 end
 return k.carrier==nil and touch(previous[model]or f.position,f.position,k.position,k.position,f.radius+C.KryptoniteRadius)
end
local function resolveKills(requests)
 if #requests==0 or not M.KillHealthBatch then return false end
 if M.KillHealthBatch(requests,round,match)then
  for _,request in ipairs(requests)do
   emit('KryptoniteDeath',{Owner=request.model,Carrier=request.carrier,Activation=request.token});crystals[request.model]=nil
  end
  return true
 end
 return false
end
function M.TryCrystalContact(a,b)
 if state:GetAttribute('Phase')~='Fighting'then return false end
 local requests={}
 for _,k in pairs(crystals)do
  if((k.owner==a and k.carrier==b)or(k.owner==b and k.carrier==a))and M.ValidateCrystalKill(k.owner,k.carrier,round,match,k.token)then requests[#requests+1]={model=k.owner,carrier=k.carrier,token=k.token}end
 end
 return resolveKills(requests)
end
local function crystalStep()
 local carrying={};local requests={}
 for owner,k in pairs(crystals)do
  local f=motions[owner]
  if not f or not alive(owner)then crystals[owner]=nil
  elseif k.carrier then
   local carrier=motions[k.carrier]
   if not carrier or not alive(k.carrier)then
    if k.carrier.Parent then k.carrier:SetAttribute('SuperKryptoniteCarrier',nil)end
    k.position=k.lastPosition or k.position;k.carrier=nil;emit('Crystal',{Owner=owner,Activation=k.token,Position=world(f,k.position),Radius=C.KryptoniteRadius})
   else
    k.lastPosition=carrier.position;carrying[k.carrier]=true
    if touch(previous[owner]or f.position,f.position,previous[k.carrier]or carrier.position,carrier.position,f.radius+carrier.radius)then requests[#requests+1]={model=owner,carrier=k.carrier,token=k.token}end
   end
  else
   -- The crystal's owner is checked FIRST and dies even if a pickup is simultaneous.
   if touch(previous[owner]or f.position,f.position,k.position,k.position,f.radius+C.KryptoniteRadius)then requests[#requests+1]={model=owner,token=k.token}
   else
    for target,g in pairs(motions)do if targetAllowed(owner,target)and not blocked(target)and touch(previous[target]or g.position,g.position,k.position,k.position,g.radius+C.KryptoniteRadius)then
     k.carrier=target;k.lastPosition=g.position;carrying[target]=true;target:SetAttribute('SuperKryptoniteCarrier',true)
     emit('Pickup',{Owner=owner,Carrier=target,Activation=k.token});break
    end end
   end
  end
 end
 resolveKills(requests)
 for m in pairs(motions)do if m.Parent then m:SetAttribute('SuperKryptoniteCarrier',state:GetAttribute('Phase')=='Fighting'and carrying[m]or nil)end end
end
local function rayLength(x,y,dx,dy,b,depth)
 local length=math.huge
 if dx>1e-9 then length=math.min(length,(b.maxX-x)/dx)elseif dx< -1e-9 then length=math.min(length,(b.minX-x)/dx)end
 if dy>1e-9 then length=math.min(length,(b.maxY-y)/dy)elseif dy< -1e-9 then length=math.min(length,(b.minY-y)/dy)end
 length=math.max(0,length)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances=obstacles
 local result=workspace:Raycast(Vector3.new(x,y,depth),Vector3.new(dx,dy,0)*length,params)
 return result and math.min(length,result.Distance)or length
end
local function eyes(f)
 local output={};local pivot=f.model:GetPivot().Position;local offset=world(f,f.position)-pivot
 for i,name in ipairs({'EyeLeft','EyeRight'})do
  local p=f.model:FindFirstChild(name,true);if p and not p:IsA('BasePart')then p=p:FindFirstChildWhichIsA('BasePart',true)end
  assert(p,'SuperCrax : œil natif absent : '..name);local origin=p:FindFirstChild('SuperLaserOriginV1');output[i]=(origin and origin.WorldPosition or p.Position)+offset
 end
 return output
end
local function mouth(f)
 local a=f.model:FindFirstChild('UpperGums',true);local b=f.model:FindFirstChild('LowerGums',true)
 local pivot=f.model:GetPivot().Position;local offset=world(f,f.position)-pivot
 if a and b and a:IsA('BasePart')and b:IsA('BasePart')then return(a.Position+b.Position)*.5+offset end
 return f.head.Position+offset+Vector3.new(0,-f.radius*.25,-f.radius*.9)
end
local function start(f,r,kind)
 sequence+=1;local cast={id=sequence,hits={},released={},previous=f.position};r.cast=cast;r.pendingHits={};cast.firstSnapshot=true
 f.model:SetAttribute('SuperSerial',sequence);setMode(f.model,r)
 if kind=='Dash'then
  local b=bounds(f.radius);local radius=math.min(f.radius*C.DashRadiusPerHead,(b.maxX-b.minX)*.23,(b.maxY-b.minY)*.23)
  cast.radius=radius;cast.start=f.position;cast.angle=rand(0,2*math.pi);cast.sign=rng:NextInteger(0,1)==0 and -1 or 1
  cast.center=Vector2.new(math.clamp(f.position.X+rand(-radius,radius),b.minX+radius,b.maxX-radius),math.clamp(f.position.Y+rand(-radius,radius),b.minY+radius,b.maxY-radius))
 elseif kind=='Laser'then
  cast.directions={};for i=1,2 do local a=rand(0,math.pi*2);cast.directions[i]=Vector2.new(math.cos(a),math.sin(a))end
 end
 emit('Start',{Owner=f.model,Kind=kind,Activation=cast.id,Duration=kind=='Dash'and C.DashDuration or(kind=='Laser'and C.LaserDuration or C.FrostCharge+C.FrostDuration)})
end
local function active(f,r,e,targets)
 local cast=r.cast;local kind=e.kind;if not cast then return end
 local snapshot={Owner=f.model,Kind=kind,Activation=cast.id,Age=e.after,Position=world(f,f.position)}
 if kind=='Dash'then
  local angle=cast.angle+cast.sign*e.after/C.DashDuration*C.DashTurns*2*math.pi
  local circle=cast.center+Vector2.new(math.cos(angle),math.sin(angle))*cast.radius
  local u=math.clamp(e.after/C.DashEntryBlend,0,1);u=u*u*(3-2*u)
  local wanted=cast.start:Lerp(circle,u);local from=f.position;f.position=wanted
  local turn=R.Turn(math.max(0,e.after-1e-9),C)
  for _,g in ipairs(targets)do if targetAllowed(f.model,g.model)and touch(from,wanted,previous[g.model]or g.position,g.position,f.radius+g.radius)and R.MarkDashHit(cast.hits,g.model,turn,C)then
   r.pendingHits[g.model]=r.pendingHits[g.model]or{};local ice=freezes[g.model]and freezes[g.model][f.model];local shatter=C.DashCanShatter and ice and ice.cast or nil
   table.insert(r.pendingHits[g.model],{id=cast.id,turn=turn,shatter=shatter})
   hit:Fire(f.model,g.model,shatter and C.ShatterDamage or C.Melee*C.DashDamageMultiplier,false,'SuperDash')
  end end
  snapshot.Turn=turn;snapshot.Center=world(f,cast.center);snapshot.Radius=cast.radius
 elseif kind=='Laser'then
  local origins=eyes(f);local beams={};snapshot.Beams={};local b=bounds(0)
  for i,dir in ipairs(cast.directions)do
   local p=origins[i];local length=rayLength(p.X,p.Y,dir.X,dir.Y,b,f.depth)
   beams[i]={x=p.X,y=p.Y,dx=dir.X,dy=dir.Y,length=length}
   snapshot.Beams[i]={From=p,To=p+Vector3.new(dir.X,dir.Y,0)*length}
  end
  local casterDelta=f.position-cast.previous
  for _,g in ipairs(targets)do if targetAllowed(f.model,g.model)then
   local before=(previous[g.model]or g.position)+casterDelta
   local exposure=R.Exposure(before.X,before.Y,g.position.X,g.position.Y,beams,g.radius+f.radius*C.LaserWidthPerRadius*.5)
   if exposure>0 then hit:Fire(f.model,g.model,C.LaserDPS*e.dt*exposure,false,'SuperLaser')end
  end end
 elseif kind=='Frost'then
  if e.after>=C.FrostCharge then
   if not cast.direction then
    local b=bounds(0);local x,y,length=R.Farthest(f.position.X,f.position.Y,b)
    cast.direction=Vector2.new(x,y);cast.length=length;cast.width=math.min(b.maxX-b.minX,b.maxY-b.minY)*C.FrostWidthFraction
    emit('FrostFire',{Owner=f.model,Activation=cast.id})
   end
   local dir=cast.direction;local origin=mouth(f);local length=rayLength(origin.X,origin.Y,dir.X,dir.Y,bounds(0),f.depth)
   snapshot.From=origin;snapshot.To=snapshot.From+Vector3.new(dir.X,dir.Y,0)*length;snapshot.Width=cast.width
   for _,g in ipairs(targets)do if targetAllowed(f.model,g.model)then
    local ratio=R.Exposure(g.position.X,g.position.Y,g.position.X,g.position.Y,{{x=origin.X,y=origin.Y,dx=dir.X,dy=dir.Y,length=length}},g.radius+cast.width*.5)
    if ratio>0 then freeze(f.model,g.model,cast)end
   end end
  end
 end
 cast.previous=f.position;r.network=(r.network or 0)+e.dt
 if cast.firstSnapshot or r.network>=.05 then cast.firstSnapshot=false;r.network=0;emit('State',snapshot)end
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if next(records)or next(freezes)or next(crystals)then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 for m,r in pairs(records)do if not own(m)then
  setMode(m,nil);records[m]=nil;crystals[m]=nil
  for target,group in pairs(freezes)do if group[m]then releaseFreeze(target,m)end end
  emit('OwnerClear',{Owner=m})
 end end
 local targets=Deadly.MotionTargets(fighters);motions={};for _,f in ipairs(targets)do motions[f.model]=f end
 if not enabled then return end;clock+=dt
 for m,group in pairs(freezes)do
  for owner,e in pairs(group)do if not alive(m)or not alive(owner)or e.untilTime<=clock then releaseFreeze(m,owner)end end
 end
 for _,f in ipairs(fighters)do
  local r=get(f.model)
  if r then
   if not alive(f.model)or r.round~=round or r.match~=match then setMode(f.model,nil);records[f.model]=nil;emit('Stop',{Owner=f.model,Activation=r.cast and r.cast.id})
   elseif not Gate.Paused(f.model)and not Deadly.Hold(f.model)then
    local e=R.Advance(r,dt,not blocked(f.model)and Silence.CanStart(f.model),rand,C)
    if e.started then start(f,r,e.started)end
    if e.active then active(f,r,e.active,targets)end
    if e.ended then if e.ended=='Dash'then r.dashSuppress=clock end;emit('Stop',{Owner=f.model,Kind=e.ended,Activation=r.cast.id});r.cast=nil;setMode(f.model,r)end
   end
  end
 end
 crystalStep()
 for _,f in ipairs(targets)do previous[f.model]=f.position end
end
return M
]====]}}

local previous=storage:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('SuperOwned')==true,'Nom de sauvegarde déjà utilisé.')
 for _,entry in ipairs(previous.Entries:GetChildren())do local object=resolve(entry:GetAttribute('Path'));assert(object and object.Source==entry.Installed.Value,'Source retouchée depuis installation : '..entry:GetAttribute('Path')..'. Aucun écrasement.')end
 print('SuperCrax déjà installé : aucun doublon.');return
end
local function count(source,needle)local n,pos=0,1;while true do local a,b=source:find(needle,pos,true);if not a then return n end;n+=1;pos=b+1 end end
local planned={}
for _,op in ipairs(operations)do
 local target=resolve(op.path);assert(target and target:IsA('LuaSourceContainer'),'Source absente : '..op.path)
 local source=target.Source;assert(not source:find(marker,1,true),'Patch SuperCrax déjà présent sans sauvegarde : '..op.path)
 local updated=source
 if op.kind=='wrap'then
  if op.path=='ReplicatedStorage.CraxCatalog'or op.path=='ReplicatedStorage.CraxSkillCatalog'then assert(not source:find('data.Crax_Super',1,true),'SuperCrax semble déjà déclaré : '..op.path)end
  updated=marker..'\nlocal data=(function()\n'..source..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,replacement in ipairs(op.replacements)do
   local chosen
   for _,v in ipairs(replacement.variants or{replacement})do if count(updated,v.before)==1 then assert(not chosen,'Ancres ambiguës : '..op.path);chosen=v end end
   assert(chosen,'Version non reconnue : '..op.path..'. Aucun fichier modifié. Fournir cette source actuelle ; ne pas restaurer une ancienne version.')
   local a,b=updated:find(chosen.before,1,true);updated=updated:sub(1,a-1)..chosen.after..updated:sub(b+1)
  end
  updated=marker..'\n'..(op.prepend or'')..updated
 end
 planned[#planned+1]={object=target,path=op.path,before=source,after=updated}
end
for _,spec in ipairs(modules)do assert(not resolve(spec.path),'Nom déjà utilisé : '..spec.path)end
for _,name in ipairs({'CraxSuperFX','CraxSuperImportedAssets'})do assert(not RS:FindFirstChild(name),'Nom déjà utilisé : '..name)end
local templates=assert(storage:FindFirstChild('CraxTemplates'),'CraxTemplates absent');local base=assert(templates:FindFirstChild('Crax_Monster'),'Vrai CraxSourire absent')
local previews=assert(RS:FindFirstChild('CraxPreviews'),'CraxPreviews absent')
assert(not templates:FindFirstChild('Crax_Super')and not previews:FindFirstChild('Crax_Super'),'Template ou aperçu SuperCrax déjà présent')
local selection=game:GetService('Selection'):Get();assert(#selection==1,'Sélectionnez UN modèle importé depuis SuperCrax_ACCESSOIRES_IMPORT.fbx.')
local imported=selection[1];assert(imported:IsA('Model')or imported:IsA('Folder'),'Sélectionner la racine du modèle importé')
local found={};local parts=0
for _,o in ipairs(imported:GetDescendants())do
 if o:IsA('LuaSourceContainer')then error('La sélection contient des scripts : sélectionner seulement les accessoires FBX.')end
 if o:IsA('BasePart')then
  assert(o.Name:match('^Super')or o.Name:match('^FIT_'),'Pièce étrangère dans la sélection : '..o.Name)
  assert(not found[o.Name],'Noms de pièces dupliqués dans l’import : '..o.Name);found[o.Name]=o;parts+=1
  if o:IsA('MeshPart')and not o.Name:match('^FIT_')then local id=o.MeshId:match('rbxassetid://(%d+)')or o.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..o.Name..'. Terminer l’import 3D sous le propriétaire de l’expérience.')end
 end
end
for _,name in ipairs({'FIT_Front','FIT_HeadCenter','FIT_Up','SuperChinBlue','SuperCurl','SuperCurl_Ridge','SuperEmblem_RedShield','SuperEmblem_S','SuperEmblem_YellowField','SuperHairCap','SuperHairLock_00','SuperHairLock_01','SuperHairLock_02','SuperHairLock_03','SuperHairLock_04','SuperHairLock_05','SuperTemple_-1','SuperTemple_1'})do assert(found[name],'Pièce manquante à l’import : '..name)end
assert(parts==18,'Import incomplet ou pièces supplémentaires : 15 meshes et 3 repères attendus')
local center,front,up=found.FIT_HeadCenter.Position,found.FIT_Front.Position,found.FIT_Up.Position
assert((front-center).Magnitude>.001 and(up-center).Magnitude>.001,'Repères importés invalides')
assert(math.abs((front-center).Unit:Dot((up-center).Unit))<.05,'Repères importés non orthogonaux : ne pas déplacer les pièces séparément')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('SuperOwned',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created,changed={},{}
local function register(o)created[#created+1]=o;o:SetAttribute('SuperOwned',true);return o end
local function record(path,before,after)
 local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path)
 for name,value in pairs({Original=before,Installed=after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=entries
end
local ok,err=pcall(function()
 for _,spec in ipairs(modules)do
  local parent,name=spec.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(spec.class));o.Name=name;o.Source=spec.source;o.Parent=assert(resolve(parent));record(spec.path,'',spec.source)
 end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxSuperFX';event.Parent=RS
 local assets=register(assert(imported:Clone()));assets.Name='CraxSuperImportedAssets';assets.Parent=RS
 for _,o in ipairs(assets:GetDescendants())do if o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false end end
 local appearance=require(RS.CraxSuperAppearance)
 local template=register(assert(base:Clone()));template.Name='Crax_Super';appearance.Apply(template,assets);template:SetAttribute('AbilityId','SuperHero');template.Parent=templates
 local preview=register(assert(template:Clone()));preview.Name='Crax_Super';preview.Parent=previews
 for _,item in ipairs(planned)do record(item.path,item.before,item.after);changed[#changed+1]=item;item.object.Source=item.after end
 backup.Parent=storage
end)
if not ok then
 for i=#changed,1,-1 do pcall(function()changed[i].object.Source=changed[i].before end)end
 for i=#created,1,-1 do pcall(function()created[i]:Destroy()end)end
 backup:Destroy();error('Installation annulée, sources restaurées : '..tostring(err))
end
print('SuperCrax installé avec les sources ACTUELLES préservées et les vrais meshes importés. Sauvegarder la place puis lancer un NOUVEAU Play.')
print('Configuration : ReplicatedStorage.CraxSuperConfig ; sons/icônes : BRANCHER_ASSETS.lua. Les ressources sans ID ne bloquent pas les pouvoirs.')
end
