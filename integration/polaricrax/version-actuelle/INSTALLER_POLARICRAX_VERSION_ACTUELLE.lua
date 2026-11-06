-- POLARICRAX. STOP. ServerStorage.PolariCrax_Import doit contenir la bibliothèque FBX publiée.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local ops={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Polari);local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local base=assert(data.Crax_Monster);local rare=assert(data.Crax_Spidey)
data.Crax_Polari={DisplayName='PolariCrax',Rarity=rare.Rarity,RarityColor=rare.RarityColor,TemplateName=C.Id,MaxHealth=110,CollisionDamage=7,Speed=base.Speed,Description='Vinyle blanc, sourire ivoire, yeux fermés et casque rouge à protections violettes.',PowerDescription='IMPULSION MAGNÉTIQUE : toutes les 6–9 secondes actives, charge 0,4 s puis éclat vers la position actuelle de la cible. Impact 10 dégâts et légère déviation.',Effects={'PolariAttract','PolariFrozen'},Ability={Id=C.AbilityId,DisplayName='IMPULSION MAGNÉTIQUE',Damage=10,Cooldown=6}}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local prices=assert(data.Crax_Spidey).Upgrades;local levels={
{Id='PolariAttract',Name='PÔLE D’ATTRACTION',Description='Polarise pendant 2 s le mur le plus proche de la cible ; incurve progressivement sa trajectoire. Aucun dégât. Prototype : délai 10–14 s.'},
{Id='PolariInvert',Name='INVERSION DES PÔLES',Description='Au contact du mur polarisé, avertissement rouge puis répulsion diagonale vers le centre et 12 dégâts. Un seul déclenchement par polarisation. Prototype : avertissement 0,25 s.'},
{Id='PolariStop',Name='TEMPS SUSPENDU',Description='Tic-tac, arrêt du combat 1,2 s, cinq éclats et axes annoncés. Mouvement repris 0,35 s avant le tir simultané. 6 dégâts par éclat, trois impacts maximum par cible : 18. Prototype : délai 22–28 s.'},
{Id='PolariFinale',Name=C.MaxTitle,TrophyId=C.TrophyId,Description='Exécution MAX : cadran, cinq fragments, inversion des murs et trophée L’ULTIME SECONDE. Scène cosmétique après le résultat du combat.'}}
for i,u in ipairs(levels)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end;local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Polari={Order=order+1,AbilityId=C.AbilityId,DisplayName='PolariCrax',Enabled=true,Upgrades=levels,Finale=levels[4]}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[data.PolariAttract={DisplayName='POLARISATION',Description='Trajectoire attirée vers un mur pendant 2 s, sans dégât.',Duration=2,Image='',Color=Color3.fromRGB(163,75,230)};data.PolariFrozen={DisplayName='TEMPS SUSPENDU',Description='Pause imbriquée du combat pendant 1,2 s, puis fenêtre d’esquive.',Duration=1.2,Image='',Color=Color3.fromRGB(242,194,75)}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVictoryCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);data.Crax_Polari={Id='PolariFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(247,201,76),MinimumLevel=4,Duration=C.FinaleDuration,IntroDuration=0,ZoomDuration=0,HoldDuration=0}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxRouletteConfig]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local rare,total={},0;for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Polari');if cat[e.Id].Rarity==cat.Crax_Polari.Rarity then rare[#rare+1]=e;total+=e.Weight end end;assert(#rare>0);local w=total/(#rare+1);for _,e in ipairs(rare)do e.Weight=w end;data.Pool[#data.Pool+1]={Id='Crax_Polari',Weight=total-w*#rare} -- Explicit prototype: unchanged Rare mass, equal redistribution.]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSkinServer]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local A=require(game:GetService('ReplicatedStorage').CraxPolariAppearance);local apply=data.Apply;function data.Apply(m,id,c)A.Restore(m);apply(m,id,c);if id=='Crax_Polari'then A.Apply(m,game:GetService('ReplicatedStorage').CraxPolariImportedAssets)end end]====]},{[ [====[path]====] ]=[====[ServerScriptService.ArenaMovement]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local PolariV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxPolariRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ Inverted.Begin(fighters)]====],[ [====[after]====] ]=[====[ Inverted.Begin(fighters)
 PolariV1.Begin(fighters)]====]},{[ [====[before]====] ]=[====[RunService.Heartbeat:Connect(function(deltaTime)]====],[ [====[after]====] ]=[====[RunService.Heartbeat:Connect(function(deltaTime)
 if PolariV1.Pump(deltaTime,fighters)then return end]====]},{[ [====[before]====] ]=[====[  SymV1.Step(step*Deadly.CinematicScale()]====],[ [====[after]====] ]=[====[  PolariV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not Killa.Fog()and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  if PolariV1.Frozen()then break end
  SymV1.Step(step*Deadly.CinematicScale()]====]},{[ [====[before]====] ]=[====[for _,side in ipairs(plumberSides)do Plumber.Wall(f,side)end]====],[ [====[after]====] ]=[====[for _,side in ipairs(plumberSides)do PolariV1.WallContact(f.model,side);Plumber.Wall(f,side)end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CombatHealth]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local PolariV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxPolariRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ local a,b=states[attacker],states[defender]]====],[ [====[after]====] ]=[====[ if attacker:GetAttribute('PolariFrozen')or defender:GetAttribute('PolariFrozen')then return end
 local a,b=states[attacker],states[defender]]====]},{[ [====[before]====] ]=[====[ amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)]====],[ [====[after]====] ]=[====[ if kind=='PolariFan'then amount=PolariV1.MaxFanPacket(amount)end
 amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)]====]},{[ [====[before]====] ]=[====[local function report(a,b,lost,kind)]====],[ [====[after]====] ]=[====[local function report(a,b,lost,kind)
 PolariV1.PowerResult(a,b,lost,kind)]====]},{[ [====[before]====] ]=[====[ local lost=math.min(b.health,amount);]====],[ [====[after]====] ]=[====[ if kind=='PolariFan'then amount=PolariV1.MaxFanPacket(amount)end
 local lost=math.min(b.health,amount);]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.RoundManager]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[state:SetAttribute("RoundVictoryStartedAt",start)]====],[ [====[after]====] ]=[====[if model and model:GetAttribute('CraxId')=='Crax_Polari'then state:SetAttribute('PolariVictoryMatch',state:GetAttribute('CraxMatchToken'))end
 state:SetAttribute("RoundVictoryStartedAt",start)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxPlumberRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return M
]====],[ [====[after]====] ]=[====[

function M.PolariDelay(dt)for _,r in pairs(logic.records)do for _,k in ipairs({'boostUntil','impulseUntil','nextWall','nextTransit'})do if type(r[k])=='number'and r[k]>0 then r[k]+=dt end end;local t=r.transit;if t then for _,k in ipairs({'Start','ExitAt','EndAt'})do if t[k]then t[k]+=dt end end end end end
return M
]====]}},[ [====[requires]====] ]={[====[local logic=Core.new();local fighters={};local records={}]====]}},{[ [====[path]====] ]=[====[ServerScriptService.CraxSpideyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return R
]====],[ [====[after]====] ]=[====[

function R.PolariDelay(dt)if lastStep then lastStep+=dt end;for m,t in pairs(timers)do timers[m]=t+dt end;for _,p in pairs(poisons)do p.next+=dt end;for _,t in ipairs(traps)do t.expires+=dt;if t.part.Parent then t.part:SetAttribute('Expires',t.expires);local born=t.part:GetAttribute('Born');if born then t.part:SetAttribute('Born',born+dt)end end end end
return R
]====]}},[ [====[requires]====] ]={[====[local R={};local traps,poisons,timers,previous={},{},{},{};local serial=0;local lastStep=nil]====]}},{[ [====[path]====] ]=[====[ServerScriptService.FleauRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return M
]====],[ [====[after]====] ]=[====[

function M.PolariDelay(dt)for _,r in pairs(records)do for _,k in ipairs({'furyEnds','furyLast','contactSuppressedUntil'})do if type(r[k])=='number'and r[k]>0 then r[k]+=dt end end end end
return M
]====]}},[ [====[requires]====] ]={[====[local M={Health=nil};local records={}]====]}},{[ [====[path]====] ]=[====[ServerScriptService.FleauControl]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return C
]====],[ [====[after]====] ]=[====[

function C.PolariDelay(dt)for _,r in pairs(records)do for k,v in pairs(r)do r[k]=v+dt end end end
return C
]====]}},[ [====[requires]====] ]={[====[local C={};local records=setmetatable({},{__mode='k'})]====]}},{[ [====[path]====] ]=[====[ServerScriptService.FantasticRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return M
]====],[ [====[after]====] ]=[====[

function M.PolariDelay(dt)started+=dt end
return M
]====]}},[ [====[requires]====] ]={[====[local records={};local round;local started=workspace:GetServerTimeNow()]====]}},{[ [====[path]====] ]=[====[ServerScriptService.GhostyNight]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return Night
]====],[ [====[after]====] ]=[====[

function Night.PolariDelay(dt)if active and active.serverEnd then active.serverEnd+=dt end end
return Night
]====]}},[ [====[requires]====] ]={[====[local active,freezeEnd,sequence=nil,0,0]====]}},{[ [====[path]====] ]=[====[ServerScriptService.CraxDeadlyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[

return M
]====],[ [====[after]====] ]=[====[

function M.PolariDelay(dt)for _,e in pairs(M.cinematics)do e.finish+=dt end end
return M
]====]}},[ [====[requires]====] ]={[====[local M={families={},nodes={},fighters={},aimSpawns={},cinematics={},viceTransits={},Health=nil}]====]}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function polariIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local key=({PolariAttract='Attract',PolariInvert='Invert',PolariStop='Stop',PolariFinale='Max'})[kind];local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundTransparency=1;f.Parent=parent
 if C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=({Attract='PÔLE',Invert='±',Stop='1,2 s',Max='MAX'})[key];t.TextScaled=true;t.TextColor3=Color3.fromRGB(230,185,80);t.Font=Enum.Font.FredokaOne;t.ZIndex=5;t.Parent=f end;return f
end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function emblem(parent,kind,color,x,y,size)]====],[ [====[after]====] ]=[====[local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end]====]},{[ [====[before]====] ]=[====[        if i==4 and currentCrax=="Crax_Symbioti"then]====],[ [====[after]====] ]=[====[    if i==4 and currentCrax=="Crax_Polari"then
     if revealed then polariIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 and currentCrax=="Crax_Symbioti"then]====]},{[ [====[before]====] ]=[====[   if currentCrax=='Crax_Killa'then name.Text='TRAQUEUR'end]====],[ [====[after]====] ]=[====[   if currentCrax=='Crax_Polari'then earned:ClearAllChildren();polariIconV1(earned,'PolariFinale',0,0,88);name.Text=require(RS.CraxPolariConfig).MaxTitle end
   if currentCrax=='Crax_Killa'then name.Text='TRAQUEUR'end]====]}}},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxBookCinema]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[self.trophyArt:ClearAllChildren()]====],[ [====[after]====] ]=[====[self.trophyArt:ClearAllChildren()
 if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(247,201,76),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.ArenaCamera]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function beginDefeat()]====],[ [====[after]====] ]=[====[local function beginDefeat()
 if state:GetAttribute('RoundVictoryKind')=='PolariFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end]====]},{[ [====[before]====] ]=[====[if player:GetAttribute("SymCameraOwner")then]====],[ [====[after]====] ]=[====[if player:GetAttribute("PolariCameraOwner")then if defeat then clearDefeat()end;return end
  if player:GetAttribute("SymCameraOwner")then]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxBatRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function stepLamp(r,dt)]====],[ [====[after]====] ]=[====[function M.PolariDelay(dt)
 for _,r in pairs(records)do if r.lamp then r.lamp.Started+=dt end end
end
local function stepLamp(r,dt)]====]}},[ [====[requires]====] ]={[====[local records={};]====],[====[local l=r.lamp;l.Age=math.max(0,workspace:GetServerTimeNow()-l.Started)]====]}}}
local modules={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariAppearance]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local M={};local saved=setmetatable({},{__mode='k'})
local function part(model,name)local p=model:FindFirstChild(name,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(model)
 local accessory=model:FindFirstChild('PolariAccessories');if accessory then accessory:Destroy()end
 for _,name in ipairs({'EyeLeft','EyeRight'})do local eye=part(model,name);local origin=eye and eye:FindFirstChild('PolariLaserOriginV1');if origin and origin:GetAttribute('PolariOwned')then origin:Destroy()end end
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
 local origin=assert(assets:FindFirstChild('P_FitOrigin',true));local front=assert(assets:FindFirstChild('P_FitFront',true));local up=assert(assets:FindFirstChild('P_FitUp',true))
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
  if n:find('cross',1,true)then p.Transparency=1 elseif n:find('tooth',1,true)or n:find('gums',1,true)or n=='eyeleft'or n=='eyeright'or n:find('shell',1,true)then p.Transparency=0 end
  if n=='eyeleft'or n=='eyeright'then p.Color=Color3.fromRGB(7,8,11)end
  if n=='head'then p.Transparency=1 end
 end end
 local accessory=Instance.new('Model');accessory.Name='PolariAccessories'
 for _,source in ipairs(assets:GetDescendants())do if source:IsA('BasePart')and source.Name:match('^P_')and not source.Name:match('^P_Fit')then
  local p=source:Clone();local rel=sourceCF:ToObjectSpace(source.CFrame)
  p.Size=source.Size*scale;p.CFrame=targetCF*(rel.Rotation+rel.Position*scale)
  p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  local name=p.Name
  if name:find('Purple',1,true)or name:find('Cheek',1,true)then p.Color=Color3.fromRGB(132,38,178)elseif name:find('Burgundy',1,true)then p.Color=Color3.fromRGB(100,14,40)else p.Color=Color3.fromRGB(216,16,42)end;p.Reflectance=.10
  if p:IsA('MeshPart')then p.TextureID=''end
  for _,c in ipairs(p:GetDescendants())do if c:IsA('LuaSourceContainer')or c:IsA('Sound')or c:IsA('SurfaceAppearance')then c:Destroy()end end
  p.Parent=accessory
 end end
 accessory.Parent=model
 if not model.PrimaryPart then model.WorldPivot=oldPivot end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariAssets]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Authored meshes are assembled at local coordinates exported from Blender.
local RS=game:GetService('ReplicatedStorage');local M={}
function M.Model(kind,parent)
 local source=assert(RS:FindFirstChild('CraxPolariImportedAssets'),'Importer PolariCrax_ACCESSOIRES_IMPORT.fbx')
 local zero=assert(source:FindFirstChild('PFX_Origin',true));local up=assert(source:FindFirstChild('PFX_Up',true));local front=assert(source:FindFirstChild('PFX_Front',true));local f=(front.Position-zero.Position).Unit;local u=(up.Position-zero.Position).Unit;local basis=CFrame.fromMatrix(zero.Position,f:Cross(u).Unit,u,-f);local scale=1/(up.Position-zero.Position).Magnitude
 local o=Instance.new('Model');o.Name='Polari'..kind
 for _,p in ipairs(source:GetDescendants())do if p:IsA('MeshPart')then
  local name=p.Name;local include=kind=='Shard'and name=='PFX_Shard'or kind=='Dial'and name:match('^PFX_Dial')or kind=='Trophy'and(name:match('^PFX_Dial')or name=='PFX_TrophyBase')
  if include then local c=p:Clone();local rel=basis:ToObjectSpace(p.CFrame);c.Size=p.Size*scale;c.CFrame=rel.Rotation+rel.Position*scale;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.CastShadow=false
   local n=c.Name;local gold=n:find('Dial',1,true)or n=='PFX_TrophyBase';c.Material=Enum.Material.Metal;c.Reflectance=.18;c.Color=gold and Color3.fromRGB(241,192,67)or Color3.fromRGB(154,154,179);c.Parent=o end
 end end
 o.Parent=parent;o.WorldPivot=CFrame.identity;return o
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariAudio]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local Map=require(RS:WaitForChild('CraxPolariAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false
local function remove(i)local e=entries[i];e.sound:Stop();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale)
 local clip=Map.Segments[name];if not clip or C.AtlasId==''then return end
 if not preloaded then preloaded=true;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({C.AtlasId})end)end)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='PolariAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.SoundId=C.AtlasId;s.Volume=finale and C.Volume*.95 or C.Volume;s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop

 s.Parent=p;local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('PolariCrax : mauvais atlas audio ; lancer DIAGNOSTIC_AUDIO_CLIENT.lua');e.born=-math.huge
    else e.sound.TimePosition=e.clip.Start;e.sound:Play();e.started=true end
   end
   if not e.anchor.Parent or os.clock()-e.born>15 or(e.sound.IsLoaded and not e.sound.Looped and e.sound.TimePosition>=e.clip.End-.001)or(e.started and e.sound.IsLoaded and os.clock()-e.born>.2 and not e.sound.IsPlaying and not e.sound.IsPaused)then remove(i)end
  end
  if #entries==0 and connection then connection:Disconnect();connection=nil end
 end)end
 return entry
end
function M.Stop(entry)if not entry then return end;for i=#entries,1,-1 do if entries[i]==entry then remove(i)end end end
function M.Pause(entry,paused)if entry and entry.anchor.Parent then entry.paused=paused;if entry.started then if paused and entry.sound.IsPlaying then entry.sound:Pause()elseif not paused and entry.sound.IsPaused then entry.sound:Resume()end end end end
function M.Clear()for i=#entries,1,-1 do remove(i)end;if connection then connection:Disconnect();connection=nil end;if root then root:Destroy();root=nil end end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariAudioMap]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[return {Duration=12.22,Segments={
 ['Charge']={Start=0.0,End=0.4,Loop=false},
 ['Shot']={Start=0.52,End=0.8,Loop=false},
 ['Impact']={Start=0.92,End=1.24,Loop=false},
 ['Attract']={Start=1.36,End=1.86,Loop=false},
 ['AttractLoop']={Start=1.98,End=2.98,Loop=true},
 ['InvertWarning']={Start=3.1,End=3.35,Loop=false},
 ['Invert']={Start=3.47,End=4.02,Loop=false},
 ['Tick']={Start=4.14,End=4.29,Loop=false},
 ['Stop']={Start=4.41,End=4.86,Loop=false},
 ['Resume']={Start=4.98,End=5.3,Loop=false},
 ['FanFire']={Start=5.42,End=5.92,Loop=false},
 ['FanImpact']={Start=6.04,End=6.36,Loop=false},
 ['WallEnd']={Start=6.48,End=6.78,Loop=false},
 ['MaxCut']={Start=6.9,End=7.1,Loop=false},
 ['MaxOrbit']={Start=7.22,End=8.42,Loop=false},
 ['MaxFragments']={Start=8.54,End=9.64,Loop=false},
 ['MaxLastTick']={Start=9.76,End=10.06,Loop=false},
 ['MaxClap']={Start=10.18,End=10.88,Loop=false},
 ['MaxTrophy']={Start=11.0,End=12.1,Loop=false},
}}
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxPolariClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- Presentation only: all targets, axes, damage, pause and repulsion decisions are server-owned.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players');local SoundService=game:GetService('SoundService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local Assets=require(RS:WaitForChild('CraxPolariAssets'));local Audio=require(RS:WaitForChild('CraxPolariAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'));local FX=RS:WaitForChild('CraxPolariFX');local state=workspace:WaitForChild('CombatState');local player=Players.LocalPlayer
local low=C.Quality=='Low'or C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local root=Instance.new('Folder');root.Name='PolariCrax_Local';root.Parent=workspace
local PURPLE=Color3.fromRGB(161,69,233);local RED=Color3.fromRGB(241,38,70);local GOLD=Color3.fromRGB(246,200,76);local shots={};local casts={};local walls={};local sparks={};local connections={};local scene;local seen;local accumulated=0
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(c,p,parent)local o=Instance.new(c);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local f=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=f and id and f:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,m,loop,finale)return Audio.Play(name,position(m)or Vector3.zero,loop,finale)end
local function line(parent,color,width)
 return make('Part',{Name='PolariAxis',Size=Vector3.one*.05,Color=color,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Transparency=.25},parent)
end
local function segment(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.001,d.Magnitude));p.CFrame=d.Magnitude>1e-7 and CFrame.lookAt((a+b)*.5,b)or CFrame.new(a)
end
local function burst(p,color,count)
 if not p then return end
 for i=1,(low and math.min(5,count)or count)do local a=i*2.399;local m=Assets.Model('Shard',root);m:ScaleTo(.13+(i%3)*.04);for _,part in ipairs(m:GetDescendants())do if part:IsA('BasePart')then part.Color=color end end;sparks[#sparks+1]={model=m,p=p,v=Vector3.new(math.cos(a),math.sin(a),math.sin(i))*(2+i%3),start=os.clock(),color=color}end
end
local function clearCast(m)local c=casts[m];if c then Audio.Stop(c.loop);c.folder:Destroy();casts[m]=nil end end
local function clearWall(id)local r=walls[id];if r then Audio.Stop(r.loop);r.folder:Destroy();walls[id]=nil end end
local function clearCombat()
 for _,s in pairs(shots)do s.model:Destroy()end;shots={};for m in pairs(casts)do clearCast(m)end;for id in pairs(walls)do clearWall(id)end
 for _,s in ipairs(sparks)do s.model:Destroy()end;sparks={}
end
-- Duck only this arena's fighters/effects and the existing music group; preserve live user volume edits.
local function duck(s,winner,loser)
 s.ducked={};local group=SoundService:FindFirstChild('CraxMusicControl')
 if group and group:IsA('SoundGroup')then s.equalizer=make('EqualizerSoundEffect',{Name='PolariFinaleDuck',HighGain=-80,MidGain=-80,LowGain=-80},group)end
 local function candidate(o)
  if not o:IsA('Sound')then return end;local parent=o.Parent;local scoped=false
  while parent and parent~=workspace do if parent==winner or parent==loser or parent.Name=='SuperAudio'or parent.Name=='SymAudio'or parent.Name=='LuckyAudio'then scoped=true;break end;parent=parent.Parent end
  if not scoped or s.ducked[o]then return end
  local e={volume=o.Volume,guard=true};s.ducked[o]=e;o.Volume=0;e.guard=false
  e.connection=o:GetPropertyChangedSignal('Volume'):Connect(function()if not e.guard then e.volume=o.Volume;e.guard=true;o.Volume=0;e.guard=false end end)
 end
 for _,o in ipairs(workspace:GetDescendants())do candidate(o)end
 s.soundAdded=workspace.DescendantAdded:Connect(candidate)
end
local function unduck(s)
 if s.soundAdded then s.soundAdded:Disconnect()end
 for o,e in pairs(s.ducked or{})do e.connection:Disconnect();if o.Parent then o.Volume=e.volume end end
 if s.equalizer then s.equalizer:Destroy()end
end
local function clone(m,parent)
 local a=m.Archivable;m.Archivable=true;local copy=m:Clone();m.Archivable=a
 for _,o in ipairs(copy:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end end;copy.Parent=parent;return copy
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('PolariFinaleCamera');unduck(s)
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('PolariCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='PolariFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('PolariVictoryMatch')~=token or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local h=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not h or(h.Position-position(winner)).Magnitude>180 then return end end
 clearCombat();Audio.Clear();local s={folder=make('Folder',{Name='PolariFinale'},root),hidden={},saved={},camera=cam,start=state:GetAttribute('RoundVictoryStartedAt'),previous=player:GetAttribute('PolariCameraOwner'),cues={}};seen=tostring(token)..':'..round
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder);s.shards={};for i=1,5 do s.shards[i]=Assets.Model('Shard',s.folder);s.shards[i]:ScaleTo(1.7)end;s.dial=Assets.Model('Trophy',s.folder);s.dial:ScaleTo(5)
 s.rays={};for i=1,5 do s.rays[i]=line(s.folder,PURPLE,.08)end
 s.gui=make('ScreenGui',{Name='PolariFinaleTrophy',IgnoreGuiInset=true,ResetOnSpawn=false},player:WaitForChild('PlayerGui'));s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.13),Position=UDim2.fromScale(.05,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=GOLD,TextStrokeTransparency=.15,Font=Enum.Font.FredokaOne,TextScaled=true,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 duck(s,winner,loser);scene=s;player:SetAttribute('PolariCameraOwner',seen)
 local logical=loser:GetPivot().Position;local center=frame()*CFrame.new(logical);local wr=winner:GetPivot().Rotation;local lr=loser:GetPivot().Rotation
 local left=workspace:FindFirstChild('Arenaleft');local right=workspace:FindFirstChild('ArenaRight');local top=workspace:FindFirstChild('ArenaTop');local bottom=workspace:FindFirstChild('Arenabottom');local starts={Vector3.new(left.Position.X,logical.Y,logical.Z),Vector3.new(right.Position.X,logical.Y,logical.Z),Vector3.new(logical.X,top.Position.Y,logical.Z),Vector3.new(logical.X,bottom.Position.Y,logical.Z),Vector3.new(left.Position.X,math.min(top.Position.Y,logical.Y+7),logical.Z)}
 Run:BindToRenderStep('PolariFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  s.hero:PivotTo(center*CFrame.new(-10,0,0)*wr);s.victim:PivotTo(center*lr);local vanish=math.clamp((t-5.2)/.45,0,1)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=vanish end end
  for i,m in ipairs(s.shards)do
   local angle=(i-1)*math.pi*2/5+math.pi/2;local arranged=(center*CFrame.new(math.cos(angle)*7,math.sin(angle)*7,0)).Position
   local from=(frame()*CFrame.new(starts[i])).Position;local assemble=math.clamp((t-1.2)/2,0,1);assemble=assemble*assemble*(3-2*assemble);local p=from:Lerp(arranged,assemble);local collapse=math.clamp((t-4.85)/.35,0,1);p=p:Lerp(center.Position,collapse)
   if t>5.6 then p=(center*CFrame.new(math.cos(angle)*5,math.sin(angle)*5,0)).Position end
   m:PivotTo(CFrame.lookAt(p,center.Position)*CFrame.Angles(-math.pi/2,0,0));s.rays[i].Color=t>=4.8 and RED or PURPLE;segment(s.rays[i],p,center.Position,.04);s.rays[i].Transparency=t>=5.6 and .85 or .35
  end
  s.dial:PivotTo(center*CFrame.new(0,t>=5.6 and 0 or 3,-1)*CFrame.Angles(math.pi/2,0,math.floor(math.min(t,4.2)*6)*math.pi/3));s.title.Visible=t>=5.6
  for _,cue in ipairs({{0,'MaxCut'},{.4,'MaxOrbit'},{1.2,'MaxFragments'},{4.2,'MaxLastTick'},{5.2,'MaxClap'},{5.6,'MaxTrophy'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;sound(cue[2],winner,false,true)end end
  local focus=(center*CFrame.new(-3,1,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(32,25/(2*math.tan(math.rad(23))*math.max(.35,aspect)));local angle=t<1.2 and(.75-t*.62)or 0;local offset=Vector3.new(math.sin(angle)*distance,3,-math.cos(angle)*distance);local wanted=CFrame.lookAt(focus+frame():VectorToWorldSpace(offset),focus,frame().UpVector);local back=math.clamp((t-(C.FinaleDuration-.8))/.8,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=46+(s.saved.FieldOfView-46)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
 end)
end
connect(FX.OnClientEvent,function(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end;local m=d.Owner
 if(k=='Charge'or k=='Wall'or k=='Suspend'or k=='Shot')and(not m or not m.Parent)then return end
 if k=='Clear'then clearCombat();return elseif k=='OwnerClear'then clearCast(m);for id,w in pairs(walls)do if w.owner==m then clearWall(id)end end;return end
 if k=='Charge'then clearCast(m);local r={folder=make('Folder',{},root),kind=d.Kind,start=Clock.Time(m),tick=0};casts[m]=r
  if d.Kind=='Stop'then r.dial=Assets.Model('Dial',r.folder);sound('Tick',m)else r.shard=Assets.Model('Shard',r.folder);r.shard:ScaleTo(.65);r.spark=make('Part',{Name='PolariChargeSpark',Shape=Enum.PartType.Ball,Size=Vector3.one*.15,Color=PURPLE,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},r.folder);r.rays={};for i=1,3 do r.rays[i]=line(r.folder,PURPLE,.04)end;if not low then make('PointLight',{Color=PURPLE,Brightness=.6,Range=4,Shadows=false},r.spark)end;sound('Charge',m)end
 elseif k=='CastEnd'then clearCast(m)
 elseif k=='Wall'then
  local folder=make('Folder',{Name='PolariWall'},root);local w={folder=folder,owner=m,target=d.Target,side=d.Side,start=Clock.Time(m),parts={},lines={}};walls[d.Activation]=w
  local names={Left='Arenaleft',Right='ArenaRight',Bottom='Arenabottom',Top='ArenaTop'};local wall=workspace:FindFirstChild(names[d.Side]);if wall then
   w.position=(frame()*wall.CFrame).Position;w.panel=make('Part',{Name='PolarizedWall',Size=wall.Size+Vector3.one*.035,CFrame=frame()*wall.CFrame,Color=PURPLE,Material=Enum.Material.Neon,Transparency=.72,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},folder)
   for i=1,(low and 3 or 6)do w.lines[i]=line(folder,PURPLE,.035)end
  end;w.loop=sound('AttractLoop',m,true);sound('Attract',m)
 elseif k=='InvertWarning'then local w=walls[d.Activation];if w then w.warning=true;if w.panel then w.panel.Color=RED end;for _,p in ipairs(w.lines)do p.Color=RED end end;sound('InvertWarning',d.Target)
 elseif k=='Repel'then burst((frame()*CFrame.new(d.Position)).Position,RED,12);sound('Invert',m)
 elseif k=='WallEnd'then clearWall(d.Activation);sound('WallEnd',m)
 elseif k=='Suspend'then
  local r=casts[m];if not r then r={folder=make('Folder',{},root),kind='Stop',start=Clock.Time(m)};casts[m]=r;r.dial=Assets.Model('Dial',r.folder)end;r.fan={};r.frozen=true
  for i,p in ipairs(d.Fan)do local part=Assets.Model('Shard',r.folder);local start=(frame()*CFrame.new(p.Position)).Position;local direction=frame():VectorToWorldSpace(p.Direction);part:PivotTo(CFrame.lookAt(start,start+direction)*CFrame.Angles(-math.pi/2,0,0));local axis=line(r.folder,PURPLE,.045);segment(axis,(frame()*CFrame.new(p.Position)).Position,(frame()*CFrame.new(p.Position+p.Direction*(C.FanRadius+5))).Position,.045);r.fan[i]={model=part,axis=axis}end;sound('Stop',m)
 elseif k=='Resume'then local r=casts[m];if r then r.frozen=false;r.released=true end;sound('Resume',m)
 elseif k=='FanFire'then clearCast(m);sound('FanFire',m)
 elseif k=='Shot'then local model=Assets.Model('Shard',root);shots[d.Id]={model=model,position=d.Position,from=d.Position,at=os.clock(),direction=d.Direction,owner=m};local p=model:FindFirstChild('PFX_Shard');if p then local a=make('Attachment',{Position=Vector3.new(-.08,0,0)},p);local b=make('Attachment',{Position=Vector3.new(.08,0,0)},p);make('Trail',{Attachment0=a,Attachment1=b,Color=ColorSequence.new(PURPLE),Lifetime=low and .08 or .14,FaceCamera=true,LightEmission=.5,MinLength=.06},p)end;if not d.Fan then sound('Shot',m)end
 elseif k=='ShotState'then if shots[d.Id]then local s=shots[d.Id];s.from=s.display or s.position;s.position=d.Position;s.at=os.clock()end
 elseif k=='ShotEnd'then if shots[d.Id]then shots[d.Id].model:Destroy();shots[d.Id]=nil end
 elseif k=='Impact'then burst((frame()*CFrame.new(d.Position)).Position,d.Fan and GOLD or PURPLE,10);sound(d.Fan and'FanImpact'or'Impact',m)end
end)
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0
 for id,s in pairs(shots)do if not s.owner.Parent then s.model:Destroy();shots[id]=nil else s.display=s.from:Lerp(s.position,math.clamp((os.clock()-s.at)/.05,0,1));local p=(frame()*CFrame.new(s.display)).Position;local v=frame():VectorToWorldSpace(s.direction);s.model:PivotTo(CFrame.lookAt(p,p+v)*CFrame.Angles(-math.pi/2,0,0))end end
 for m,r in pairs(casts)do
  local h=head(m);if not m.Parent or not h or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then clearCast(m)
  else local t=Clock.Time(m)-r.start;if r.dial then r.dial:PivotTo(frame()*h.CFrame*CFrame.new(0,2.7,-3.35)*CFrame.Angles(math.pi/2,0,math.floor(t*6)*math.pi/3))elseif r.shard then local p=(frame()*h.CFrame*CFrame.new(0,1,-4.5)).Position;r.shard:PivotTo(CFrame.new(p)*CFrame.Angles(math.pi/2,t*4,0));local u=math.clamp(t/C.Charge,0,1);r.spark.CFrame=CFrame.new(p);r.spark.Size=Vector3.one*(.12+.2*u*u);r.spark.Transparency=.15+.1*math.sin(t*35);for i,ray in ipairs(r.rays)do local angle=i*math.pi/3+t*2;local d=frame():VectorToWorldSpace(Vector3.new(math.cos(angle),math.sin(angle),0))*(.18+.35*u);segment(ray,p-d,p+d,.04)end end
   if r.kind=='Stop'and not r.released and not r.frozen then local tick=math.floor(t/.2);if tick>(r.tick or 0)then r.tick=tick;sound('Tick',m)end end
  end
 end
 for id,w in pairs(walls)do
  local p=position(w.target);if not p or not w.owner.Parent then clearWall(id)elseif w.position then local t=Clock.Time(w.owner)-w.start;for i,ray in ipairs(w.lines)do local u=(t*.8+i/#w.lines)%1;local endpoint=w.position+frame():VectorToWorldSpace(Vector3.new((w.side=='Top'or w.side=='Bottom')and(i-2)*2 or 0,(w.side=='Left'or w.side=='Right')and(i-2)*2 or 0,0));local a=p:Lerp(endpoint,math.max(0,u-.18));segment(ray,a,p:Lerp(endpoint,u),.035)end;Audio.Pause(w.loop,Clock.Paused(w.owner))end
 end
 for i=#sparks,1,-1 do local p=sparks[i];local t=(os.clock()-p.start)/.5;if t>=1 then p.model:Destroy();table.remove(sparks,i)else p.model:PivotTo(CFrame.new(p.p+p.v*t)*CFrame.Angles(t*6,t*4,t*3))end end
end)
local function clearAll()clearCombat();stopScene();Audio.Clear()end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()clearAll();seen=nil end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Values explicitly requested by the creator. Remaining controls are documented prototypes.
local C={Id='Crax_Polari',AbilityId='PolariImpulse',Health=110,Melee=7,
 ImpulseWait={6,9},Charge=.4,ImpulseDamage=10,AttractDuration=2,InvertDamage=12,StopDuration=1.2,ShardDamage=6,MaxHits=3,ShardCount=5,
 -- Prototype balancing/visual timings, not implicit creator approval.
 AttractWait={10,14},StopWait={22,28},InvertWarning=.25,DodgeWindow=.35,TickWarning=.6,
 ProjectileSpeed=38,ProjectileLife=2.5,ProjectileRadius=.28,DeflectAngle=math.rad(13),AttractTurnRate=1.2,RepelAngle=math.rad(28),RepelSpeedScale=1,
 FanRadius=10,Volume=.18,Quality='Auto',FinaleDuration=9,MaxTitle='L’ULTIME SECONDE',TrophyId='PolariFinalSecond',AtlasId='',Icons={Attract='',Invert='',Stop='',Max=''}}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxPolariUserAssets')
if user then
 local id=user:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Icons)do local id=user:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxPolariPause]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Advance only absolute deadlines by the time deliberately omitted from arena simulation.
-- Relative timers, trajectories, velocities, captures and other lock reasons are left intact.
local SS=game:GetService('ServerScriptService');local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local state=workspace:WaitForChild('CombatState');local M={}
local keys={'PlumberStarUntil','PlumberBoostUntil','GhostDodgeUntil','GhostTeleportUntil','SpideyPoisonUntil','SpideyStingingUntil','SilkSlowUntil','FleauStunUntil','DeadlySlowUntil'}
function M.Shift(dt,fighters)
 if dt<=0 then return end
 for _,f in ipairs(Deadly.MotionTargets(fighters))do
  local m=f.model;for _,key in ipairs(keys)do local value=m:GetAttribute(key);if type(value)=='number'and value>0 then m:SetAttribute(key,value+dt)end end
  if f.sting then for _,k in ipairs({'started','expires'})do if f.sting[k]then f.sting[k]+=dt end end end
  if f.pendingSting and f.pendingSting.deadline then f.pendingSting.deadline+=dt end
 end
 for _,key in ipairs({'GhostFreezeUntil','GhostNightEnd','GhostGrandFrissonEnd'})do local value=state:GetAttribute(key);if type(value)=='number'and value>0 then state:SetAttribute(key,value+dt)end end
 for _,name in ipairs({'CraxSpideyRuntime','CraxPlumberRuntime','FleauRuntime','FleauControl','FantasticRuntime','GhostyNight','CraxDeadlyRuntime','CraxBatRuntime'})do
  local module=SS:FindFirstChild(name);if module then local runtime=require(module);assert(runtime.PolariDelay,'Adaptateur de pause manquant : '..name);runtime.PolariDelay(dt)end
 end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariRules]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local R={}
function R.NearestWall(p,b)
 local sides={{id='Left',d=p.X-b.minX,n=Vector2.new(1,0)},{id='Right',d=b.maxX-p.X,n=Vector2.new(-1,0)},{id='Bottom',d=p.Y-b.minY,n=Vector2.new(0,1)},{id='Top',d=b.maxY-p.Y,n=Vector2.new(0,-1)}}
 local best=sides[1];for i=2,4 do if sides[i].d<best.d then best=sides[i]end end;return best.id,best.n
end
function R.Turn(v,to,rate,dt)
 if v.Magnitude<1e-8 then return v end;local d=v.Unit:Lerp(to.Unit,1-math.exp(-rate*dt));return(d.Magnitude>1e-8 and d.Unit or to.Unit)*v.Magnitude
end
function R.Repel(p,n,b,speed,angle)
 local center=Vector2.new((b.minX+b.maxX)*.5,(b.minY+b.maxY)*.5);local tangent=Vector2.new(-n.Y,n.X);local sign=(center-p):Dot(tangent)>=0 and 1 or-1;return(n*math.cos(angle)+tangent*math.sin(angle)*sign).Unit*speed
end
function R.Sweep(a,b,p,r)
 local v=b-a;local d=a-p;local cc=d:Dot(d)-r*r;if cc<=0 then return 0 end;local aa=v:Dot(v);if aa<1e-12 then return end;local bb=2*d:Dot(v);local disc=bb*bb-4*aa*cc;if disc<0 then return end;local t=(-bb-math.sqrt(disc))/(2*aa);if t>=0 and t<=1 then return t end
end
function R.Fan(center,forward,radius,count)
 local axis=forward.Magnitude>1e-8 and forward.Unit or Vector2.new(1,0);local out={}
 for i=1,count do local angle=(i-(count+1)*.5)*.22;local d=Vector2.new(axis.X*math.cos(angle)-axis.Y*math.sin(angle),axis.X*math.sin(angle)+axis.Y*math.cos(angle));out[i]={position=center-d*radius,direction=d}end;return out
end
function R.TouchWall(side,p,r,b)
 return side=='Left'and p.X-r<=b.minX+.025 or side=='Right'and p.X+r>=b.maxX-.025 or side=='Bottom'and p.Y-r<=b.minY+.025 or side=='Top'and p.Y+r>=b.maxY-.025
end
return R
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxPolariRuntime]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Authority only: uses existing motions, pause reasons, hit event and confirmed damage.
local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local R=require(RS:WaitForChild('CraxPolariRules'));local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Skills=require(SS:WaitForChild('CraxSkillResolver'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local FX=RS:WaitForChild('CraxPolariFX');local Hit=SS:WaitForChild('BiteHit');local state=workspace:WaitForChild('CombatState');local M={};local records={};local shots={};local freeze;local round;local match;local serial=0;local rng=Random.new();local motions={};local previous={};local list={};local pendingRepel={};local pendingDeflect={};local running=false
local function rand(v)return rng:NextNumber(v[1],v[2])end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m:GetAttribute('CraxId')==C.Id end
local function enabled(m)return alive(m)and own(m)and not m:GetAttribute('LuckyTricked')end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function xyz(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bounds()
 local a=workspace:FindFirstChild('Arenaleft');local b=workspace:FindFirstChild('ArenaRight');local c=workspace:FindFirstChild('Arenabottom');local d=workspace:FindFirstChild('ArenaTop');return{minX=a.Position.X+a.Size.X*.5,maxX=b.Position.X-b.Size.X*.5,minY=c.Position.Y+c.Size.Y*.5,maxY=d.Position.Y-d.Size.Y*.5}
end
local function enemy(a,b)return alive(b)and not Deadly.SameTeam(a,b)and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('DeadlyPhantom')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')end
local function target(f)local best,dist;for m,g in pairs(motions)do if enemy(f.model,m)then local d=(g.position-f.position).Magnitude;if not dist or d<dist then best=g;dist=d end end end;return best end
local function externallyHeld(m)
 for _,spec in ipairs({{'CraxBatRuntime','Hold'},{'CraxHangoverRuntime','Hold'},{'CraxBlackSpideyRuntime','Hold'},{'CraxSonGoRuntime','Hold'},{'CraxLuckyRuntime','Hold'},{'CraxSymRuntime','Held'},{'CraxSuperRuntime','Held'}})do
  local source=SS:FindFirstChild(spec[1]);if source then local runtime=require(source);if runtime[spec[2]]and runtime[spec[2]](m)then return true end end
 end
 return false
end
local function get(m)
 if not own(m)then return end;if not records[m]then records[m]={time=0,level=Skills.Resolve(m),due={Impulse=rand(C.ImpulseWait),Attract=rand(C.AttractWait),Stop=rand(C.StopWait)}}end;return records[m]
end
local function release()
 local s=freeze;if not s then return end;freeze=nil
 for m in pairs(s.models)do Gate.Resume(m,s.reason);m:SetAttribute('PolariFrozen',nil)end
 state:SetAttribute('PolariTimeFrozen',nil);state:SetAttribute('PolariTimeOwner',nil);state:SetAttribute('PolariTimeRemaining',nil)
 local r=records[s.owner];if r and r.cast and r.cast.id==s.id then r.cast.phase='Dodge';r.cast.age=0 end;emit('Resume',{Owner=s.owner,Activation=s.id,Window=C.DodgeWindow})
end
function M.Frozen()return freeze~=nil end
function M.Cancel(m)
 if freeze and freeze.owner==m then release()end;records[m]=nil
 for i=#shots,1,-1 do if shots[i].owner==m then emit('ShotEnd',{Id=shots[i].id});table.remove(shots,i)end end;emit('OwnerClear',{Owner=m})
end
function M.Reset()
 running=false;release();records={};shots={};motions={};previous={};pendingRepel={};pendingDeflect={};round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')
end
function M.Begin(fighters)M.Reset();running=true;list=fighters;for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end end
-- Called before every other arena simulation. It never overwrites velocities, captures or lock snapshots.
function M.Pump(dt,fighters)
 list=fighters
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')or state:GetAttribute('Phase')~='Fighting'then if running or round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Reset()end;return false end
 for m in pairs(records)do if not enabled(m)then M.Cancel(m)end end
 if not freeze then return false end;local s=freeze
 for _,f in ipairs(fighters)do if not alive(f.model)then release();return false end end
 if not enabled(s.owner)or not alive(s.target)then M.Cancel(s.owner);return false end
 local used=math.min(math.max(0,dt),s.remaining);require(SS:WaitForChild('CraxPolariPause')).Shift(used,fighters)
 s.remaining-=used;state:SetAttribute('PolariTimeRemaining',math.max(0,s.remaining))
 if s.remaining<=1e-8 then release()end
 -- Skip this whole heartbeat, including the final fraction: movement starts before the dodge window can elapse.
 return true
end
local function stop(f,r,a)
 local t=motions[a.target];if not t then r.cast=nil;return end
 local dir=t.position-f.position;a.fan=R.Fan(t.position,dir,C.FanRadius,C.ShardCount);a.phase='Frozen';a.age=0
 freeze={owner=f.model,target=t.model,id=a.id,remaining=C.StopDuration,reason='PolariTime_'..a.id,models={}}
 for _,g in ipairs(Deadly.MotionTargets(list))do freeze.models[g.model]=true;Gate.Pause(g.model,freeze.reason);g.model:SetAttribute('PolariFrozen',true)end
 state:SetAttribute('PolariTimeFrozen',true);state:SetAttribute('PolariTimeOwner',f.model.Name);state:SetAttribute('PolariTimeRemaining',C.StopDuration)
 local fan={};local b=bounds();for i,p in ipairs(a.fan)do p.position=Vector2.new(math.clamp(p.position.X,b.minX+C.ProjectileRadius,b.maxX-C.ProjectileRadius),math.clamp(p.position.Y,b.minY+C.ProjectileRadius,b.maxY-C.ProjectileRadius));fan[i]={Position=xyz(f,p.position),Direction=Vector3.new(p.direction.X,p.direction.Y,0)}end
 emit('Suspend',{Owner=f.model,Target=t.model,Activation=a.id,Fan=fan,Duration=C.StopDuration})
end
local function spawn(f,a,p,d,damage,volley)
 serial+=1;local shot={id=serial,activation=a.id,owner=f.model,position=p,velocity=d*C.ProjectileSpeed,damage=damage,life=0,fan=volley,hits=a.hits or{},net=0};shots[#shots+1]=shot;emit('Shot',{Owner=f.model,Id=shot.id,Activation=a.id,Position=xyz(f,p),Direction=Vector3.new(d.X,d.Y,0),Fan=volley})
end
local function start(f,r,kind)
 local t=target(f);if not t then r.due[kind]=r.time+1;return end;serial+=1;if kind=='Impulse'then r.due.Impulse=r.time+rand(C.ImpulseWait)end;r.cast={kind=kind,id=serial,target=t.model,age=0,phase=kind=='Stop'and'Tick'or'Charge'};emit('Charge',{Owner=f.model,Target=t.model,Kind=kind,Activation=serial,Duration=kind=='Stop'and C.TickWarning or C.Charge})
end
local function cast(f,r,dt)
 local a=r.cast
 if not enemy(f.model,a.target)then r.cast=nil;r.due[a.kind]=r.time+rand(a.kind=='Stop'and C.StopWait or C.ImpulseWait);emit('CastEnd',{Owner=f.model,Activation=a.id});return end
 if a.kind=='Stop'and a.phase=='Dodge'and(externallyHeld(a.target)or Gate.Paused(a.target)or Deadly.Hold(a.target)or(motions[a.target]and motions[a.target].capturedBy))then a.age=0;return end
 a.age+=dt
 if a.kind=='Impulse'and a.age+1e-8>=C.Charge then
  local t=motions[a.target];if t and enemy(f.model,t.model)then local d=t.position-f.position;d=d.Magnitude>1e-8 and d.Unit or Vector2.new(1,0);spawn(f,a,f.position+d*(f.radius+.2),d,C.ImpulseDamage,false)end;r.cast=nil;emit('CastEnd',{Owner=f.model,Activation=a.id})
 elseif a.kind=='Stop'then
  if a.phase=='Tick'and a.age+1e-8>=C.TickWarning then stop(f,r,a)
  elseif a.phase=='Dodge'and a.age+1e-8>=C.DodgeWindow then
   a.hits={};for _,p in ipairs(a.fan)do spawn(f,a,p.position,p.direction,C.ShardDamage,true)end;r.cast=nil;r.due.Stop=r.time+rand(C.StopWait);emit('FanFire',{Owner=f.model,Activation=a.id})
  end
 end
end
local function polarize(f,r)
 local t=target(f);if not t then r.due.Attract=r.time+1;return end;local side,normal=R.NearestWall(t.position,bounds());serial+=1;r.wall={target=t.model,side=side,normal=normal,age=0,id=serial};r.due.Attract=r.time+C.AttractDuration+rand(C.AttractWait);emit('Wall',{Owner=f.model,Target=t.model,Side=side,Activation=serial,Duration=C.AttractDuration})
end
local function wall(f,r,dt)
 local w=r.wall;local t=motions[w.target];if not t or not enemy(f.model,w.target)then emit('WallEnd',{Owner=f.model,Activation=w.id});r.wall=nil;return end
 w.age+=dt
 if w.warning then
  if w.age-w.warning>=C.InvertWarning then
   if not Gate.Paused(t.model)and not Deadly.Hold(t.model)then pendingRepel[f.model]={target=t.model,normal=w.normal,id=w.id};Hit:Fire(f.model,t.model,C.InvertDamage,false,'PolariInvert',nil,w.id)end
   emit('WallEnd',{Owner=f.model,Activation=w.id});r.wall=nil
  end
 elseif w.age>=C.AttractDuration then emit('WallEnd',{Owner=f.model,Activation=w.id});r.wall=nil
 elseif not Gate.Paused(t.model)and not Deadly.Hold(t.model)and not t.capturedBy then
  t.velocity=R.Turn(t.velocity,-w.normal,C.AttractTurnRate,dt)
  if r.level>=2 and R.TouchWall(w.side,t.position,t.radius,bounds())then w.warning=w.age;emit('InvertWarning',{Owner=f.model,Target=t.model,Activation=w.id,Side=w.side,Duration=C.InvertWarning})end
 end
end
local function advanceShot(s,dt)
 local f=motions[s.owner];if not f or not enabled(s.owner)then return false end;if Gate.Paused(s.owner)then return true end
 local used=math.min(dt,C.ProjectileLife-s.life);s.life+=used;local from=s.position;local to=from+s.velocity*used;local b=bounds();local wallT=1
 for _,axis in ipairs({'X','Y'})do local lo=axis=='X'and b.minX or b.minY;local hi=axis=='X'and b.maxX or b.maxY;local v=to[axis]-from[axis];if math.abs(v)>1e-9 then local q=((v>0 and hi-C.ProjectileRadius or lo+C.ProjectileRadius)-from[axis])/v;if q>=0 then wallT=math.min(wallT,q)end end end
 local first,entry
 for m,g in pairs(motions)do if enemy(s.owner,m)and(not s.fan or(s.hits[m]or 0)<C.MaxHits)then local prior=previous[m]or g.position;local hit=R.Sweep(from-prior,to-g.position,Vector2.zero,g.radius+C.ProjectileRadius);if hit and hit<=wallT and(not entry or hit<entry)then first=g;entry=hit end end end
 if first then
  s.hits[first.model]=(s.hits[first.model]or 0)+1;if not s.fan then pendingDeflect[s.owner]={target=first.model,id=s.id}end;Hit:Fire(s.owner,first.model,s.damage,false,s.fan and'PolariFan'or'PolariImpulse',nil,s.activation);emit('Impact',{Owner=s.owner,Target=first.model,Id=s.id,Position=xyz(f,from+(to-from)*entry),Fan=s.fan})

  return false
 end
 if wallT<1 then return false end;s.position=to;s.net+=dt;if s.net>=.05 then s.net=0;emit('ShotState',{Id=s.id,Owner=s.owner,Position=xyz(f,to)})end;return s.life<C.ProjectileLife-1e-8
end
function M.MaxFanPacket(amount)return math.min(amount,C.ShardDamage)end
function M.PowerResult(owner,target,loss,kind)
 if kind=='PolariInvert'then local p=pendingRepel[owner];pendingRepel[owner]=nil;local f=motions[target];if p and p.target==target and f and loss>0 and not Gate.Paused(target)and not Deadly.Hold(target)and not f.capturedBy then f.velocity=R.Repel(f.position,p.normal,bounds(),math.max(f.speed or 0,f.velocity.Magnitude)*C.RepelSpeedScale,C.RepelAngle);f.knockback=nil;emit('Repel',{Owner=owner,Target=target,Activation=p.id,Position=xyz(f,f.position)})end;return end
 if kind~='PolariImpulse'then return end;local p=pendingDeflect[owner];pendingDeflect[owner]=nil
 local f=motions[target];if p and p.target==target and f and loss>0 and not Gate.Paused(target)and not Deadly.Hold(target)and not f.capturedBy then local v=f.velocity;local angle=C.DeflectAngle*(p.id%2==0 and 1 or-1);f.velocity=Vector2.new(v.X*math.cos(angle)-v.Y*math.sin(angle),v.X*math.sin(angle)+v.Y*math.cos(angle))end
end
function M.WallContact(model,side)
 for _,r in pairs(records)do local w=r.wall;if w and w.target==model and w.side==side and not w.warning and w.age<C.AttractDuration and r.level>=2 then w.warning=w.age;emit('InvertWarning',{Owner=nil,Target=model,Activation=w.id,Side=side,Duration=C.InvertWarning})end end
end
function M.Step(dt,fighters,active)
 if state:GetAttribute('Phase')~='Fighting'then if running then M.Reset()end;return end;if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 if not active or freeze then return end
 for _,f in ipairs(fighters)do local r=get(f.model)
  if r and not enabled(f.model)then M.Cancel(f.model)
  elseif r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)and not externallyHeld(f.model)then
   r.time+=dt;if r.wall then wall(f,r,dt)end
   if r.cast then cast(f,r,dt)elseif Silence.CanStart(f.model)then
    if r.level>=3 and r.time+1e-8>=r.due.Stop then start(f,r,'Stop')elseif r.time+1e-8>=r.due.Impulse then start(f,r,'Impulse')elseif r.level>=1 and not r.wall and r.time+1e-8>=r.due.Attract then polarize(f,r)end
   end
  end
  if freeze then break end
 end
 if not freeze then for i=#shots,1,-1 do if not advanceShot(shots[i],dt)then emit('ShotEnd',{Id=shots[i].id});table.remove(shots,i)end end end
 for m,g in pairs(motions)do previous[m]=g.position end
end
return M
]====]}}
local expected={[====[P_HelmetRedClosed]====],[====[P_HelmetBurgundyStripe]====],[====[P_PurpleBrow]====],[====[P_Cheek_-1]====],[====[P_Cheek_1]====],[====[P_FitOrigin]====],[====[P_FitUp]====],[====[P_FitFront]====],[====[PFX_Shard]====],[====[PFX_DialRing]====],[====[PFX_DialTicks]====],[====[PFX_DialHand]====],[====[PFX_TrophyBase]====],[====[PFX_Origin]====],[====[PFX_Up]====],[====[PFX_Front]====]}
local backupName='PolariCrax_Backup_V1';local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('PolariOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde incomplète ou étrangère ; inspecter avant reprise')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source éditée après installation : '..e:GetAttribute('Path'))end
 for _,path in ipairs({'ReplicatedStorage.CraxPolariFX','ReplicatedStorage.CraxPolariImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Polari','ServerStorage.CraxTemplates.Crax_Polari'})do local o=resolve(path);assert(o and o:GetAttribute('PolariOwned'),'Élément installé supprimé ou remplacé : '..path)end
 print('PolariCrax déjà installé, aucun doublon');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)end
-- CombatState is created by RoundManager at runtime and may be absent in STOP.
if not resolve('Workspace.CombatState')then
 local manager=resolve('ServerScriptService.RoundManager')
 assert(manager and manager:IsA('Script')and not manager.Disabled,'RoundManager serveur actif requis')
 local source=read(manager)
 for _,anchor in ipairs({'state = Instance.new("Folder")','state.Name = "CombatState"','state.Parent = workspace'})do
  assert(source:find(anchor,1,true),'Initialisation CombatState non reconnue dans RoundManager ; aucun fichier modifié')
 end
end
local plan={};local marker='-- PolariCraxIntegrationV1'
local function count(s,n)local total,p=0,1;while true do local a,b=s:find(n,p,true);if not a then return total end;total+=1;p=b+1 end end
for _,op in ipairs(ops)do
 local o=assert(resolve(op.path),'Source manquante : '..op.path);assert(o:IsA('LuaSourceContainer'),'Type de source incorrect');local before=read(o);for _,required in ipairs(op.requires or{})do assert(before:find(required,1,true),'Structure interne actuelle non reconnue : '..op.path..'. Exporter le diagnostic ; aucun fichier modifié.')end;assert(not before:find(marker,1,true),'Patch sans sauvegarde : '..op.path);local after=before
 if op.kind=='wrap'then after=marker..'\nlocal data=(function()\n'..before..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,r in ipairs(op.replacements)do assert(count(after,r.before)==1,'Source actuelle non reconnue : '..op.path..'. Aucun fichier modifié ; ne pas rétablir une ancienne version.');local a,b=after:find(r.before,1,true);after=after:sub(1,a-1)..r.after..after:sub(b+1)end
  after=marker..'\n'..(op.prepend or'')..after
 end
 plan[#plan+1]={path=op.path,object=o,before=before,after=after}
end
for _,m in ipairs(modules)do assert(not resolve(m.path),'Nom utilisé : '..m.path)end
for _,n in ipairs({'CraxPolariFX','CraxPolariImportedAssets'})do assert(not RS:FindFirstChild(n),'Nom utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'));local base=assert(templates:FindFirstChild('Crax_Monster'));local previews=assert(RS:FindFirstChild('CraxPreviews'))
assert(not templates:FindFirstChild('Crax_Polari')and not previews:FindFirstChild('Crax_Polari'),'Template/preview déjà présent')
local imported=assert(SS:FindFirstChild('PolariCrax_Import'),'Importer PolariCrax_ACCESSOIRES_IMPORT.fbx puis placer sa racine sous ServerStorage avec le nom PolariCrax_Import.');assert(imported:IsA('Model')or imported:IsA('Folder'),'Racine importée attendue');local found={};local countParts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans les accessoires')
 if p:IsA('BasePart')then assert(not found[p.Name],'Nom dupliqué : '..p.Name);found[p.Name]=p;countParts+=1
  if p.Name:match('^P')then assert(p:IsA('MeshPart'),'MeshPart requis : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)end
 end
end
assert(countParts==#expected,'Import incomplet ou pièces supplémentaires')
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante : '..n)end
local c,f,u=found.P_FitOrigin.Position,found.P_FitFront.Position,found.P_FitUp.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('PolariOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('PolariOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxPolariFX';event.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxPolariImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxPolariAppearance)
 local template=register(base:Clone());template.Name='Crax_Polari';appearance.Apply(template,assets);template:SetAttribute('AbilityId','PolariImpulse');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Polari';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : rollback bloqué par édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation arrêtée : '..tostring(err))
end
print('PolariCrax installé. Sources de l’éditeur préservées, sauvegarde créée. Enregistrer, fermer/rouvrir puis NOUVEAU Play. Importer et brancher l’atlas audio et les illustrations pour les activer.')
end
