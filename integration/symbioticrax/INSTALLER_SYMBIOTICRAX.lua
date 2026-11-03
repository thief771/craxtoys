-- SYMBIOTICRAX. STOP. Sélectionner le modèle accessoires FBX importé et publié.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play avant installation')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local p=game;for n in path:gmatch('[^.]+')do p=p and p:FindFirstChild(n)end;return p end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)
 SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end)
 assert(read(o)==after,'Vérification éditeur échouée : '..o:GetFullName())
end
local ops={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Symbioti,'SymbiotiCrax déjà défini')
local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local base=assert(data.Crax_Monster);local epic=assert(data.Crax_Ghosty)
data.Crax_Symbioti={DisplayName='SymbiotiCrax',Rarity=epic.Rarity,RarityColor=epic.RarityColor,TemplateName=C.Id,MaxHealth=C.Health,CollisionDamage=C.Melee,Speed=base.Speed,
 Description='Le vrai Crax Sourire transformé : langue recourbée, crocs et filaments noirs.',PowerDescription='Langue prédatrice : capture et traction progressive, puis morsure à 16 dégâts. Délai de 8 à 12 secondes actives après rétraction. Les contacts ordinaires ne s’ajoutent pas à la capture.',Effects={'SymMarks','SymArmour','SymParasite'},Ability={Id=C.AbilityId,DisplayName='LANGUE PRÉDATRICE',Damage=C.Damage,Cooldown=C.Wait[1]}}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Symbioti)
local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local prices=assert(data.Crax_Ghosty).Upgrades
local list={
 {Id='SymMarks',Name='CONTAMINATION',Description='Trois mêlées ayant réellement retiré des PV sur la même victime font éclater les marques : 15 dégâts supplémentaires, puis 5 PV soignés seulement si l’explosion retire des PV. Marques : 15 s, rafraîchies ; langue et parasite exclus.'},
 {Id='SymArmour',Name='ARMURE VIVANTE',Description='Après 30 PV réellement perdus : réduction de 35 % pendant 4 s sur les coups suivants. Dépassement perdu, recharge suspendue pendant la protection. Aucun sauvetage mortel.'},
 {Id='SymParasite',Name='NOUS SOMMES DEUX',Description='Un parasite poursuit une cible pendant au plus 4 s, s’accroche 3 s : vitesse ×0,75 et 3 dégâts/s, puis revient. 5 PV de soin au retour uniquement après dégâts effectifs. Un seul parasite par héros ; délai 12–16 s après retour.'},
 {Id='SymFinale',Name=C.TrophyTitle,Status=C.TrophyTitle,TrophyId=C.TrophyId,Description='À chaque victoire MAX : déploiement d’une énorme mâchoire, capture du vrai vaincu, traction et morsure, rétraction puis pose et titre doré. Présentation uniquement, aucun gain supplémentaire.'}}
for i,u in ipairs(list)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Symbioti={Order=order+1,AbilityId=C.AbilityId,DisplayName='SymbiotiCrax',Enabled=C.PricesEnabled,Upgrades=list,Finale=list[4]}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[data.SymMarks={DisplayName='CONTAMINATION',Description='Trois marques du même SymbiotiCrax déclenchent 15 dégâts supplémentaires. Expiration après 15 s sans nouvelle marque.',Icon='SymMarks',Image='',Color=Color3.fromRGB(110,115,130)}
data.SymArmour={DisplayName='ARMURE VIVANTE',Description='35 % de dégâts reçus en moins pendant 4 s. Aucun soin ou sauvetage automatique.',Icon='SymArmour',Image='',Duration=4,Color=Color3.fromRGB(80,86,100)}
data.SymParasite={DisplayName='PARASITE',Description='Vitesse ×0,75 pendant l’accrochage ; 3 dégâts/s durant au plus 3 s.',Icon='SymParasite',Image='',Duration=3,Color=Color3.fromRGB(178,73,100)}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxRouletteConfig]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local catalog=require(game:GetService('ReplicatedStorage').CraxCatalog);local epic={};local total=0
for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Symbioti');if catalog[e.Id].Rarity==catalog.Crax_Symbioti.Rarity then epic[#epic+1]=e;total+=e.Weight end end
assert(#epic>0 and total>0);local share=total/(#epic+1);for _,e in ipairs(epic)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Symbioti',Weight=total-share*#epic} -- provisional equal redistribution within unchanged Epic mass
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVictoryCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxSymConfig)
data.Crax_Symbioti={Id='SymFinale',DisplayName=C.TrophyTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(255,211,87),MinimumLevel=4,IntroDuration=0,Duration=C.Finale.ReturnEnd,ZoomDuration=0,HoldDuration=0,Description='Victoire MAX : mâchoire, capture, morsure et retour. Aucun dégât ni récompense supplémentaire.'}]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSkinServer]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local appearance=require(game:GetService('ReplicatedStorage').CraxSymAppearance);local apply=data.Apply
function data.Apply(model,id,config)appearance.Restore(model);apply(model,id,config);if id=='Crax_Symbioti'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSymImportedAssets')))end end]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxPositionLock]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[return M]====],[ [====[after]====] ]=[====[-- A controlled pull may move ONLY its own exclusive lock. Other statuses keep priority.
function M.Move(f,reason,position)
 local r=records[f.model];if not r or not r.reasons[reason]then return false end
 for key in pairs(r.reasons)do if key~=reason then return false end end
 r.position=position;r.pivot=CFrame.new(position.X,position.Y,r.depth)*r.rotation;f.position=position
 f.model:SetAttribute('FantasticAnchorPosition',Vector3.new(position.X,position.Y,r.depth));M.Enforce(f);return true
end
return M]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.ArenaMovement]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local SymV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ SuperCraxV1.Begin(fighters)]====],[ [====[after]====] ]=[====[ SuperCraxV1.Begin(fighters)
 SymV1.Begin(fighters)]====]},{[ [====[before]====] ]=[====[  alive=alive and state:GetAttribute('Phase')=='Fighting']====],[ [====[after]====] ]=[====[  SymV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  alive=alive and state:GetAttribute('Phase')=='Fighting']====]},{[ [====[before]====] ]=[====[not SuperCraxV1.Held(f.model)and]====],[ [====[after]====] ]=[====[not SymV1.Held(f.model)and not SuperCraxV1.Held(f.model)and]====]},{[ [====[before]====] ]=[====[f.velocity * SuperCraxV1.Speed(f.model)]====],[ [====[after]====] ]=[====[f.velocity * SymV1.Speed(f.model) * SuperCraxV1.Speed(f.model)]====]},{[ [====[before]====] ]=[====[f.velocity.Magnitude*SuperCraxV1.Speed(f.model)]====],[ [====[after]====] ]=[====[f.velocity.Magnitude*SymV1.Speed(f.model)*SuperCraxV1.Speed(f.model)]====]},{[ [====[before]====] ]=[====[not SuperCraxV1.SuppressNormalContact(a.model,b.model)]====],[ [====[after]====] ]=[====[not SymV1.SuppressContact(a.model,b.model)and not SuperCraxV1.SuppressNormalContact(a.model,b.model)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxDeadlyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function SymBridgeV1()return require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[speed=speed*SuperCraxBridgeV1().Speed(n.model)]====],[ [====[after]====] ]=[====[speed=speed*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)]====]},{[ [====[before]====] ]=[====[*100*SuperCraxBridgeV1().Speed(n.model)]====],[ [====[after]====] ]=[====[*100*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)]====]},{[ [====[before]====] ]=[====[+dt*2.8*SuperCraxBridgeV1().Speed(n.model)]====],[ [====[after]====] ]=[====[+dt*2.8*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.FleauRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function SymBridgeV1()return require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[speed=speed*SuperCraxBridgeV1().Speed(m)]====],[ [====[after]====] ]=[====[speed=speed*SymBridgeV1().Speed(m)*SuperCraxBridgeV1().Speed(m)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CombatHealth]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local SymV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function report(a,b,lost,kind)]====],[ [====[after]====] ]=[====[local function report(a,b,lost,kind)
 SymV1.PowerResult(a,b,lost,kind)]====]},{[ [====[before]====] ]=[====[amount=kind=='SuperLaser'and]====],[ [====[after]====] ]=[====[amount=(kind=='SuperLaser'or kind=='SymParasite')and]====]},{[ [====[before]====] ]=[====[amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)]====],[ [====[after]====] ]=[====[amount=SymV1.Reduce(defender,amount);incoming=SymV1.Reduce(attacker,incoming)
 amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)]====]},{[ [====[before]====] ]=[====[SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);]====],[ [====[after]====] ]=[====[SymV1.Confirm(attacker,defender,lost,attackerLost,collision);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);]====]},{[ [====[before]====] ]=[====[if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end]====],[ [====[after]====] ]=[====[SymV1.Healed(model,r.health-before)
 if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.RoundManager]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[state:SetAttribute("RoundVictoryStartedAt",start)]====],[ [====[after]====] ]=[====[if model and model:GetAttribute('CraxId')=='Crax_Symbioti'then
 state:SetAttribute('SymVictoryCrax','Crax_Symbioti');state:SetAttribute('SymVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0);state:SetAttribute('SymVictoryMatch',state:GetAttribute('CraxMatchToken'))
 end
 state:SetAttribute("RoundVictoryStartedAt",start)]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function symIconV1(parent,id,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local key=({SymMarks='Marks',SymArmour='Armour',SymParasite='Parasite',SymFinale='Max'})[id]
 local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundColor3=Color3.fromRGB(16,18,26);f.BorderSizePixel=0;f.Parent=parent
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.2,0);corner.Parent=f
 if key and C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f
 else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.Text=({Marks='3',Armour='35%',Parasite='DUO',Max='MAX'})[key]or'S';t.Font=Enum.Font.FredokaOne;t.TextScaled=true;t.BackgroundTransparency=1;t.TextColor3=key=='Max'and Color3.fromRGB(255,211,87)or Color3.fromRGB(240,240,226);t.ZIndex=5;t.Parent=f end
 return f
end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function emblem(parent,kind,color,x,y,size)]====],[ [====[after]====] ]=[====[local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,3)=='Sym'then symIconV1(parent,kind,x,y,size);return end]====]},{[ [====[before]====] ]=[====[    if i==4 and currentCrax=="Crax_Super"then]====],[ [====[after]====] ]=[====[    if i==4 and currentCrax=="Crax_Symbioti"then
     if revealed then symIconV1(node,upgrade.Id,3,3,56)else local t=text(node,"?",0,0,62,62,35,C.muted);t.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 and currentCrax=="Crax_Super"then]====]}}},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxBookCinema]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[self.trophyArt:ClearAllChildren()]====],[ [====[after]====] ]=[====[self.trophyArt:ClearAllChildren()
 if self._symTitleScaled==nil then self._symTitleScaled=self.trophyIcon.TrophyTitle.TextScaled end
 self.trophyIcon.TrophyTitle.TextScaled=self._symTitleScaled
 if id=='Crax_Symbioti'then
  local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(255,211,87),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text=C.TrophyTitle;self.trophyIcon.TrophyTitle.TextScaled=true;return
 end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxTrophyServer]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[label.Text=title;label.Font=Enum.Font.GothamBlack;label.TextSize=22]====],[ [====[after]====] ]=[====[label.Text=title;label.Font=Enum.Font.GothamBlack;label.TextSize=22
  if entry.crax=="Crax_Symbioti"then label.TextScaled=true end]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.ArenaCamera]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function beginDefeat() -- FantasticExclusiveFinale_v4]====],[ [====[after]====] ]=[====[local function beginDefeat() -- FantasticExclusiveFinale_v4
 if state:GetAttribute('RoundVictoryKind')=='SymFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end]====]},{[ [====[before]====] ]=[====[function()
		local seated = player:GetAttribute("ArenaSeat") ~= nil]====],[ [====[after]====] ]=[====[function()
  if player:GetAttribute("SymCameraOwner")then if defeat then clearDefeat()end;return end
		local seated = player:GetAttribute("ArenaSeat") ~= nil]====]}}},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxDeadlyVisuals]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local fit=data.Fit
function data.Fit(view,model)
 if model:GetAttribute('SymPreview')then return require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSymPreview')).Bind(view,model)end
 return fit(view,model)
end]====]},{[ [====[path]====] ]=[====[StarterGui.InventoryGui.InventoryClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[if model:GetAttribute('DeadlySpiral')then local cf,sz=model:GetBoundingBox();center=cf.Position;radius=math.max(sz.X,sz.Y)/2 end]====],[ [====[after]====] ]=[====[if model:GetAttribute('DeadlySpiral')or model:GetAttribute('SymPreview')then local cf,sz=model:GetBoundingBox();center=cf.Position;radius=math.max(sz.X,sz.Y)/2 end]====]}}}}
local modules={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymAppearance]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local M={};local snapshots=setmetatable({},{__mode='k'})
local function part(m,n)local p=m:FindFirstChild(n,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(m)
 local s=snapshots[m];if s then for p,v in pairs(s)do if p.Parent then p.Color=v.color;p.Material=v.material;p.Reflectance=v.reflect;p.Transparency=v.alpha;if p:IsA('MeshPart')then p.TextureID=v.texture end;for _,a in ipairs(v.surfaces)do a:Clone().Parent=p end end end end
 snapshots[m]=nil;m:SetAttribute('SymPreview',nil);local old=m:FindFirstChild('SymAccessories');if old then old:Destroy()end
 local h=part(m,'Head');local a=h and h:FindFirstChild('SymMouth');if a and a:GetAttribute('SymOwned')then a:Destroy()end
end
function M.Apply(m,assets)
 M.Restore(m);local h=assert(part(m,'Head'));local left=assert(part(m,'EyeLeft'));local right=assert(part(m,'EyeRight'));local oldPivot=m:GetPivot()
 local center=assets:FindFirstChild('FIT_HeadCenter',true);local front=assets:FindFirstChild('FIT_Front',true);local up=assets:FindFirstChild('FIT_Up',true)
 local sf=(front.Position-center.Position).Unit;local su=(up.Position-center.Position).Unit;local sr=sf:Cross(su).Unit
 local src=CFrame.fromMatrix(center.Position,sr,sr:Cross(sf).Unit,-sf)
 local f=(left.Position+right.Position)*.5-h.Position;f=(f-h.CFrame.UpVector*f:Dot(h.CFrame.UpVector)).Unit
 local dst=CFrame.fromMatrix(h.Position,f:Cross(h.CFrame.UpVector).Unit,h.CFrame.UpVector,-f);local scale=(h.Size.Y*.5)/(up.Position-center.Position).Magnitude
 local function fit(cf)local r=src:ToObjectSpace(cf);return dst*(r.Rotation+r.Position*scale)end
 local hidden={};for _,p in ipairs(assets:GetDescendants())do if p.Name:match('^SymFang_')then local row,index=p.Name:match('^SymFang_Tooth([01])([0-7])1$');assert(row and index,'Correspondance dent native inconnue');hidden['tooth_'..row..'_'..index]=true end end
 local s={};snapshots[m]=s
 for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then
  s[p]={color=p.Color,material=p.Material,reflect=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,a in ipairs(p:GetChildren())do if a:IsA('SurfaceAppearance')then s[p].surfaces[#s[p].surfaces+1]=a:Clone();a:Destroy()end end
  local n=p.Name:lower();p.Color=n:find('tooth',1,true)and Color3.fromRGB(239,240,226)or(n:find('gums',1,true)and Color3.fromRGB(187,89,110)or Color3.fromRGB(8,11,17));p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.04
  if p:IsA('MeshPart')then p.TextureID=''end
  if hidden[n]or n=='eyeleft'or n=='eyeright'then p.Transparency=1 end
  if n:find('cross',1,true)then p.Color=s[p].color end
 end end
 local model=Instance.new('Model');model.Name='SymAccessories'
 for _,p in ipairs(assets:GetDescendants())do if p:IsA('MeshPart')and p.Name:match('^Sym')then
  local c=p:Clone();c.Size=p.Size*scale;c.CFrame=fit(p.CFrame);c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.Massless=true;c.Material=Enum.Material.SmoothPlastic;c.Reflectance=.14;c.TextureID=''
  local n=c.Name;local row,index=n:match('^SymFang_Tooth([01])([0-7])1$');if row then c:SetAttribute('SymJawRow',row=='1'and'Lower'or'Upper')end;c.Color=(n:find('Eye',1,true)or n:find('White',1,true)or n:find('Fang',1,true))and Color3.fromRGB(239,240,226)or(n:find('Tongue',1,true)and Color3.fromRGB(196,54,79)or Color3.fromRGB(8,11,17))
  if n:find('Groove',1,true)then c.Color=Color3.fromRGB(112,22,46)end
  if n:find('Fang',1,true)or n:find('White',1,true)or n:find('Eye',1,true)then c.Reflectance=.035 end
  for _,d in ipairs(c:GetDescendants())do if d:IsA('LuaSourceContainer')or d:IsA('SurfaceAppearance')or d:IsA('Sound')then d:Destroy()end end
  local index=n:match('^SymTentacle_(%d+)$');if index then local root=assets:FindFirstChild('SYM_Root_'..index,true);assert(root,'Repère tentacule absent');c:SetAttribute('SymRootLocal',h.CFrame:ToObjectSpace(fit(root.CFrame)))end
  c.Parent=model
 end end
 model.Parent=m;m:SetAttribute('SymPreview',true);local point=assert(assets:FindFirstChild('SYM_Mouth',true));local a=Instance.new('Attachment');a.Name='SymMouth';a.CFrame=h.CFrame:ToObjectSpace(fit(point.CFrame));a:SetAttribute('SymOwned',true);a.Parent=h
 if not m.PrimaryPart then m.WorldPivot=oldPivot end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymAudio]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxSymConfig'));local Map=require(RS:WaitForChild('CraxSymAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false
local function remove(i)local e=entries[i];e.sound:Stop();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale)
 local clip=Map.Segments[name];if not clip or C.AtlasId==''then return end
 if not preloaded then preloaded=true;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({C.AtlasId})end)end)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='SymAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.SoundId=C.AtlasId;s.Volume=finale and C.Volume*.95 or C.Volume;s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop
 local group=game:GetService('SoundService'):FindFirstChild('CraxMusicControl');if finale and group and group:IsA('SoundGroup')then s.SoundGroup=group end
 s.Parent=p;local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('SymbiotiCrax : mauvais atlas audio ; lancer DIAGNOSTIC_AUDIO_CLIENT.lua');e.born=-math.huge
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
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymAudioMap]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[return {Duration=13.47,Segments={
 ['TonguePrepare']={Start=0.0,End=0.35,Loop=false},
 ['TongueLaunch']={Start=0.47,End=0.79,Loop=false},
 ['TongueMiss']={Start=0.91,End=1.31,Loop=false},
 ['Capture']={Start=1.43,End=1.68,Loop=false},
 ['Pull']={Start=1.8,End=2.4,Loop=true},
 ['Bite']={Start=2.52,End=2.86,Loop=false},
 ['Mark']={Start=2.98,End=3.16,Loop=false},
 ['Burst']={Start=3.28,End=3.93,Loop=false},
 ['Heal']={Start=4.05,End=4.5,Loop=false},
 ['ArmourStart']={Start=4.62,End=5.22,Loop=false},
 ['ArmourHit']={Start=5.34,End=5.5,Loop=false},
 ['ArmourEnd']={Start=5.62,End=6.12,Loop=false},
 ['ParasiteStart']={Start=6.24,End=6.64,Loop=false},
 ['ParasiteAttach']={Start=6.76,End=7.06,Loop=false},
 ['ParasiteReturn']={Start=7.18,End=7.58,Loop=false},
 ['ParasiteMerge']={Start=7.7,End=8.25,Loop=false},
 ['MaxDeploy']={Start=8.37,End=9.67,Loop=false},
 ['MaxCapture']={Start=9.79,End=10.49,Loop=false},
 ['MaxBite']={Start=10.61,End=11.41,Loop=false},
 ['MaxRetract']={Start=11.53,End=12.53,Loop=false},
 ['MaxTitle']={Start=12.65,End=13.35,Loop=false},
}}
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxSymClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- Presentation only. All positions, damage and control decisions come from the server.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxSymConfig'));local Audio=require(RS:WaitForChild('CraxSymAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxSymFX')
local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local BLACK=Color3.fromRGB(9,13,20);local WHITE=Color3.fromRGB(240,240,226);local RED=Color3.fromRGB(196,54,79);local GOLD=Color3.fromRGB(255,211,87)
local root=Instance.new('Folder');root.Name='SymbiotiCrax_Local';root.Parent=workspace
local connections={};local actors={};local marks={};local bursts={};local idle={};local idleNative={};local armourProgress={};local scene;local seen;local accumulator=0
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(class,props,parent)local p=Instance.new(class);for k,v in pairs(props)do p[k]=v end;p.Parent=parent;return p end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local folder=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local f=folder and id and folder:FindFirstChild('Frame_'..id);return f and f.Value or CFrame.identity
end
local function loc(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function mouth(m)local h=head(m);local a=h and h:FindFirstChild('SymMouth');return a and(frame()*a.WorldCFrame).Position or loc(m)end
local function ball(parent,size,color,alpha)
 return make('Part',{Shape=Enum.PartType.Ball,Size=size,Color=color,Material=Enum.Material.SmoothPlastic,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},parent)
end
local function path(parent,color,count)
 local chain={};for i=1,count do chain[i]=ball(parent,Vector3.one*.1,color,1);chain[i].Reflectance=.12 end
 if color==RED then
  chain.grooves={};for i=1,count do chain.grooves[i]=ball(parent,Vector3.one*.02,Color3.fromRGB(112,22,46),1)end
 end
 return chain
end
local function bezier(a,b,c,d,t)local u=1-t;return a*u^3+b*3*u*u*t+c*3*u*t*t+d*t^3 end
local function updatePath(chain,a,b,color,thickness,coil,time)
 local d=b-a;local side=frame():VectorToWorldSpace(Vector3.new(0,1,0));local last=a
 for i,p in ipairs(chain)do
  local u=i/#chain;local pos=bezier(a,a+d*.25+side*math.sin(time*2)*.6,a+d*.7+side*.3,b,u)
  if coil and u>.74 then local angle=(u-.74)/.26*math.pi*1.7;local radius=type(coil)=='number'and coil or 2;local v=(u-.74)/.26;angle=v*math.pi*2.5;local entry=b+frame():VectorToWorldSpace(Vector3.new(radius,0,-radius*.45));pos=entry:Lerp(b+frame():VectorToWorldSpace(Vector3.new(math.cos(angle)*radius,math.sin(angle)*radius,(v-.5)*radius*.9)),math.min(1,v*6)) end
  local delta=pos-last;local width=thickness*(1-.66*u^1.4)*(1+.035*math.sin(u*72-time*8))
  p.Size=Vector3.new(width*2,width*1.65,math.max(width*1.7,delta.Magnitude*1.6));p.CFrame=delta.Magnitude>.0001 and CFrame.lookAt((last+pos)*.5,pos,frame().UpVector)or CFrame.new(pos);p.Color=color;p.Transparency=0
  if chain.grooves then local g=chain.grooves[i];g.Size=Vector3.new(width*.11,width*.10,p.Size.Z*.94);g.CFrame=p.CFrame*CFrame.new(0,width*.77,0);g.Transparency=p.Transparency end
  last=pos
 end
end
local function destroyPath(p)for _,o in ipairs(p or{})do o:Destroy()end;if p and p.grooves then for _,o in ipairs(p.grooves)do o:Destroy()end end end
-- Three equal angular sectors conform to the front hemisphere of the real head.
-- Everything belongs to one local Model, so expiration/round changes remove every tendril.
local function contamination(owner,target,count,terminal)
 marks[owner]=marks[owner]or{}
 local old=marks[owner][target];if old then old:Destroy();marks[owner][target]=nil end
 if count<=0 or not head(target)then return end
 local model=make('Model',{Name='SymContamination'},root)
 model:SetAttribute('Stacks',math.clamp(count,1,3));model:SetAttribute('Born',os.clock())
 if terminal then model:SetAttribute('Terminal',true)end
 local columns=low and 9 or 15;local rows=low and 6 or 10
 for x=1,columns do for y=1,rows do
  local cell=ball(model,Vector3.one*.1,BLACK,1);cell.Name='Coat';cell.Reflectance=.16
  cell:SetAttribute('U',(x-.5)/columns);cell:SetAttribute('V',(y-.5)/rows)
 end end
 for i=1,(low and 5 or 9)do
  for j=1,5 do local cell=ball(model,Vector3.one*.1,BLACK,1);cell.Name='Tendril';cell.Reflectance=.2;cell:SetAttribute('Branch',i);cell:SetAttribute('Segment',j)end
 end
 marks[owner][target]=model
end
local function animateContamination(model,h,now)
 local count=model:GetAttribute('Stacks');local age=now-model:GetAttribute('Born');local spread=math.clamp(age/.24,0,1)
 local cf=frame()*h.CFrame;local sx,sy,sz=h.Size.X*.52,h.Size.Y*.52,h.Size.Z*.52
 for _,p in ipairs(model:GetChildren())do
  if p.Name=='Coat'then
   local u,v=p:GetAttribute('U'),p:GetAttribute('V');local active=u<=count/3
   local longitude=(u-.5)*2.85;local latitude=(v-.5)*2.65
   local pulse=1+.009*math.sin(now*4+u*19+v*11)
   local pos=Vector3.new(math.sin(longitude)*math.cos(latitude)*sx,math.sin(latitude)*sy,-math.cos(longitude)*math.cos(latitude)*sz)*pulse
   p.Size=Vector3.new(sx*(low and .40 or .24),sy*(low and .49 or .30),.13)*(.85+.15*spread)
   p.CFrame=cf*CFrame.new(pos)*CFrame.Angles(latitude,-longitude,math.sin(now*2+u*20)*.04)
   p.Transparency=active and (1-spread)*.85 or 1
  else
   local i,j=p:GetAttribute('Branch'),p:GetAttribute('Segment');local u=(i-.5)/(low and 5 or 9)*count/3
   local angle=(u-.5)*2.7;local v=j/5;local phase=now*3+i*2
   local pos=Vector3.new(math.sin(angle)*sx+math.sin(v*5+phase)*v*sx*.13,math.cos(i*2.399)*sy*.72+v*sy*.22,-math.cos(angle)*sz-.07-v*.24)
   local width=(1-v*.85)*sx*.075
   p.Size=Vector3.new(width,width,sy*.17);p.CFrame=cf*CFrame.new(pos)*CFrame.Angles(math.sin(phase+v)*.6,angle,phase*.15+v*2)
   p.Transparency=1-spread
  end
 end
 return model:GetAttribute('Terminal')and age>.65
end
local function burst(pos,color,inward)
 local list={};for i=1,(low and 8 or 17)do local a=i*2.399;list[i]={p=ball(root,Vector3.one*(i%3==0 and .25 or .13),color),offset=Vector3.new(math.cos(a),math.sin(a),(i%5-2)*.15)*(1+i%3)}end
 bursts[#bursts+1]={items=list,start=os.clock(),position=pos,inward=inward}
end
local function restTongue(m,alpha)local accessories=m and m:FindFirstChild('SymAccessories');if accessories then for _,p in ipairs(accessories:GetChildren())do if p.Name:find('Tongue',1,true)then p.LocalTransparencyModifier=alpha end end end end
local function clearActor(m)
 if marks[m]then for _,v in pairs(marks[m])do v:Destroy()end;marks[m]=nil end
 local a=actors[m];if a then destroyPath(a.tongue);if a.parasite then a.parasite.model:Destroy()end;Audio.Stop(a.loop);actors[m]=nil end
 restTongue(m,0)
end
local function restoreIdle(m)
 local i=idle[m];if not i then return end
 for p,s in pairs(i)do if p.Parent then if s.appliedColor and p.Color==s.appliedColor then p.Color=s.color end;local h=head(m);if h and(s.root or s.jaw)and(m:GetAttribute('CraxId')==C.Id or p.CFrame==s.appliedCF)then p.CFrame=h.CFrame*s.localCF end end end;idle[m]=nil;idleNative[m]=nil;armourProgress[m]=nil
end
local function clearCombat()
 for m in pairs(actors)do clearActor(m)end
 for owner,t in pairs(marks)do for _,m in pairs(t)do m:Destroy()end;marks[owner]=nil end
end
local function parasiteModel()
 local model=make('Model',{},root);local core=ball(model,Vector3.new(1.2,1,1.4),BLACK)
 local eyes={};for i=1,2 do eyes[i]=ball(model,Vector3.new(.27,.35,.1),WHITE)end
 local feet={};for i=1,3 do feet[i]=ball(model,Vector3.new(.19,.19,.8),BLACK)end
 local mouth=ball(model,Vector3.new(.65,.20,.12),RED);local teeth={};for i=1,3 do teeth[i]=ball(model,Vector3.new(.11,.13,.06),WHITE)end
 return{model=model,core=core,eyes=eyes,feet=feet,mouth=mouth,teeth=teeth}
end
local function moveParasite(p,pos,t)
 p.core.CFrame=CFrame.new(pos);p.mouth.CFrame=CFrame.new(pos+Vector3.new(0,-.20,-.69));for i,t in ipairs(p.teeth)do t.CFrame=CFrame.new(pos+Vector3.new((i-2)*.17,-.19,-.77))end;for i,e in ipairs(p.eyes)do e.CFrame=CFrame.new(pos+Vector3.new((i==1 and-.28 or .28),.1,-.68))*CFrame.Angles(0,0,i==1 and-.3 or .3)end
 for i,f in ipairs(p.feet)do f.CFrame=CFrame.new(pos+Vector3.new(math.sin(t*4+i)*.65,-.35,i*.25-.5))*CFrame.Angles(0,i,0)end
end
local function clone(m,parent)
 local arch=m.Archivable;m.Archivable=true;local copy=m:Clone();m.Archivable=arch
 for _,o in ipairs(copy:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('BillboardGui')or o:IsA('Sound')or o:IsA('Beam')or o:IsA('Trail')or o:IsA('ParticleEmitter')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end end
 copy.Parent=parent;return copy
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('SymbiotiCraxExclusiveCamera')
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus end
 player:SetAttribute('SymCameraOwner',s.previousOwner);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function makeJaw(winner,parent)
 local source=head(winner);local upper={};local lower={};local center=Vector3.new(0,-1.1,0)
 for _,p in ipairs(winner:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.8 then
  local n=p.Name:lower()
  if n:find('gums',1,true)or n:find('tooth',1,true)or n:find('fang',1,true)or n:find('inner',1,true)then
   local c=p:Clone();for _,d in ipairs(c:GetChildren())do d:Destroy()end;c.Size=p.Size*1.85;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.Parent=parent
   local rel=source.CFrame:ToObjectSpace(p.CFrame);local offset=rel.Position-center
   local row=offset.Y>0 and upper or lower;row[#row+1]={part=c,rel=CFrame.new(offset*1.85)*rel.Rotation}
  end
 end end
 local cavity=ball(parent,Vector3.new(13,10,5),BLACK);return{upper=upper,lower=lower,cavity=cavity}
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='SymFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local token=state:GetAttribute('CraxMatchToken');local round=state:GetAttribute('RoundId')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('SymVictoryMatch')~=token or state:GetAttribute('SymVictoryCrax')~=C.Id or(state:GetAttribute('SymVictoryLevel')or 0)<4 then return end
 if seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera
 if not loser or not cam or not head(loser)then return end
 if player:GetAttribute('ArenaSeat')==nil then local hr=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-loc(winner)).Magnitude>180 then return end end
 for m in pairs(idle)do restoreIdle(m)end
 local folder=make('Folder',{Name='SymFinale'},root);local s={folder=folder,winner=winner,loser=loser,round=round,match=token,start=state:GetAttribute('RoundVictoryStartedAt'),camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,hidden={},cues={},previousOwner=player:GetAttribute('SymCameraOwner')}
 if type(s.start)~='number'then folder:Destroy();return end
 s.hero=clone(winner,folder);s.victim=clone(loser,folder);s.jaw=makeJaw(winner,folder);s.tongue=path(folder,RED,low and 36 or 64);s.filaments={};s.saliva={}
 for i=1,(low and 3 or 6)do s.saliva[i]=path(folder,Color3.fromRGB(151,87,109),low and 3 or 5)end
 for i=1,(low and 4 or 8)do s.filaments[i]=path(folder,BLACK,low and 5 or 8)end
 s.gui=make('ScreenGui',{Name='SymFinaleTitle',IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=95},player:WaitForChild('PlayerGui'))
 s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.12),Position=UDim2.fromScale(.05,.80),Text=C.TrophyTitle,TextScaled=true,BackgroundTransparency=1,TextColor3=GOLD,TextStrokeColor3=BLACK,TextStrokeTransparency=.2,Font=Enum.Font.FredokaOne,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 seen=tostring(token)..':'..round;scene=s;player:SetAttribute('SymCameraOwner',seen)
 local center=frame()*CFrame.new(loser:GetPivot().Position);local rotation=winner:GetPivot().Rotation;local victimRot=loser:GetPivot().Rotation
 Run:BindToRenderStep('SymbiotiCraxExclusiveCamera',Enum.RenderPriority.Last.Value+1200,function()
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.ReturnEnd or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=s.round or state:GetAttribute('CraxMatchToken')~=s.match or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  local deploy=math.clamp(t/F.Capture,0,1);local capture=math.clamp((t-F.Capture)/(F.Close-F.Capture),0,1);local retract=math.clamp((t-F.Retract)/(F.Pose-F.Retract),0,1)
  local jawCF=center*CFrame.new(-11,1+2*(1-deploy),2)*head(winner).CFrame.Rotation;local open=(1-math.clamp((t-F.Close)/(F.Impact-F.Close),0,1))*deploy
  s.hero:PivotTo(center*CFrame.new(-8,-1,0)*rotation*CFrame.Angles(0,0,math.sin(t*1.7)*.04))
  s.victim:PivotTo(center*CFrame.new(-11*capture,1*capture,2*capture)*victimRot)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=t>=F.Impact and 1 or 0 end end
  local size=math.max(.001,deploy*(1-retract));s.jaw.cavity.Size=Vector3.new(13,10,5)*size;s.jaw.cavity.CFrame=jawCF
  for _,row in ipairs({{s.jaw.upper,1},{s.jaw.lower,-1}})do for _,v in ipairs(row[1])do v.part.CFrame=jawCF*CFrame.new(0,row[2]*open*1.8,0)*CFrame.Angles(row[2]*open*.14,0,0)*v.rel;v.part.Transparency=1-size end end
  local endPos=t<F.Capture and(center*CFrame.new(0,0,0)).Position or head(s.victim).Position
  updatePath(s.tongue,jawCF.Position+frame():VectorToWorldSpace(Vector3.new(0,0,-3)),endPos,RED,.65,t>=F.Capture and t<F.Close and head(s.victim).Size.X*.53,t)
  for i,p in ipairs(s.tongue)do p.Transparency=(t<F.Deploy or t>=F.Impact)and 1 or 0;if s.tongue.grooves then s.tongue.grooves[i].Transparency=p.Transparency end end
  for i,chain in ipairs(s.filaments)do local a=i*2.399;local start=(center*CFrame.new(math.cos(a)*7,-5,1)).Position;local finish=(center*CFrame.new(math.cos(a)*3,math.sin(a)*3,1)).Position;updatePath(chain,start,start:Lerp(finish,deploy*(1-retract)),BLACK,.18,false,t+i)end
  for i,chain in ipairs(s.saliva)do
   local x=(i/(#s.saliva+1)-.5)*8
   local upper=(jawCF*CFrame.new(x,open*2.3,-2.6)).Position
   local lower=(jawCF*CFrame.new(x+.2,-open*2.3,-2.6)).Position
   updatePath(chain,upper,lower,Color3.fromRGB(151,87,109),.025,false,t+i)
   for _,p in ipairs(chain)do p.Transparency=(t<F.Deploy or t>=F.Impact)and 1 or .45 end
  end
  if t>=F.Impact and not s.impact then s.impact=true;burst(jawCF.Position,BLACK,false);burst(jawCF.Position,WHITE,false)end
  s.title.Visible=t>=F.Pose
  for _,cue in ipairs({{0,'MaxDeploy'},{F.Capture,'MaxCapture'},{F.Close-.35,'TonguePrepare'},{F.Close,'Bite'},{F.Impact,'MaxBite'},{F.Retract,'MaxRetract'},{F.Pose,'MaxTitle'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;Audio.Play(cue[2],jawCF.Position,false,true)end end
  local target=(center*CFrame.new(-5,1,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(30,24/(2*math.tan(math.rad(22))*math.max(.35,aspect)))
  local wanted=CFrame.lookAt(target+frame():VectorToWorldSpace(Vector3.new(0,3,-distance)),target,frame().UpVector);local finish=math.clamp((t-(F.ReturnEnd-.7))/.7,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=44+(s.fov-44)*finish;cam.CFrame=(wanted*CFrame.Angles(0,0,math.sin(t*47)*.012*math.max(0,1-math.abs(t-F.Impact)/.28))):Lerp(s.cf,finish);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner;local pos=loc(m)
 if kind=='Clear'then clearCombat();return elseif kind=='OwnerClear'then clearActor(m);return end
 if not m or not m.Parent then return end
 if kind=='TongueStart'then local a=actors[m]or{};actors[m]=a;a.tongue=path(root,RED,low and 32 or 56);a.tip=mouth(m);a.mode='Prepare';a.id=d.Activation;restTongue(m,1);Audio.Play('TonguePrepare',pos)
 elseif kind=='TongueLaunch'then Audio.Play('TongueLaunch',pos)
 elseif kind=='TongueState'then local a=actors[m];if a and a.id==d.Activation then a.tip=(frame()*CFrame.new(d.Position)).Position;a.mode=d.Mode;a.target=d.Target;if d.Mode=='Return'then Audio.Stop(a.loop);a.loop=nil end end
 elseif kind=='Capture'then local a=actors[m];if a then a.loop=Audio.Play('Pull',pos,true)end;Audio.Play('Capture',pos)
 elseif kind=='Miss'then Audio.Play('TongueMiss',pos)
 elseif kind=='TongueStop'then local a=actors[m];if a and a.id==d.Activation then destroyPath(a.tongue);a.tongue=nil;Audio.Stop(a.loop);a.loop=nil;restTongue(m,0)end
 elseif kind=='Melee'then local p=loc(d.Target);if p then Audio.Play('Bite',p);burst(p,BLACK,false)end
 elseif kind=='ArmourHit'then Audio.Play('ArmourHit',pos);burst(pos,WHITE,false)
 elseif kind=='Bite'then local a=actors[m];if a then a.biteUntil=os.clock()+.18 end;local p=loc(d.Target);if p then burst(p,d.Damage>0 and RED or WHITE,false);Audio.Play('Bite',p)end
 elseif kind=='Marks'then
  contamination(m,d.Target,d.Count);if d.Count>0 then Audio.Play('Mark',loc(d.Target))end
 elseif kind=='Burst'then local p=loc(d.Target);if p then contamination(m,d.Target,3,true);burst(p,BLACK,false);Audio.Play('Burst',p)end
 elseif kind=='Heal'then burst(pos,WHITE,true);Audio.Play('Heal',pos)
 elseif kind=='Armour'then Audio.Play(d.Active and'ArmourStart'or'ArmourEnd',pos)
 elseif kind=='ParasiteStart'then local a=actors[m]or{};actors[m]=a;if a.parasite then a.parasite.model:Destroy()end;a.parasite=parasiteModel();a.parasiteId=d.Activation;a.parasitePosition=pos;Audio.Play('ParasiteStart',pos)
 elseif kind=='ParasiteState'then local a=actors[m];if a and a.parasiteId==d.Activation then a.parasitePosition=(frame()*CFrame.new(d.Position)).Position;a.parasiteMode=d.Mode end
 elseif kind=='ParasiteAttach'or kind=='ParasiteReturn'then Audio.Play(kind=='ParasiteAttach'and'ParasiteAttach'or'ParasiteReturn',pos)
 elseif kind=='ParasiteMerge'or kind=='ParasiteClear'then local a=actors[m];if a and a.parasiteId==d.Activation and a.parasite then a.parasite.model:Destroy();a.parasite=nil end;if kind=='ParasiteMerge'then Audio.Play('ParasiteMerge',pos);burst(pos,BLACK,true)end
 end
end)
connect(Run.Heartbeat,function(dt)
 accumulator+=dt;if accumulator<(low and 1/20 or 1/30)then return end;local elapsed=accumulator;accumulator=0;local now=os.clock()
 for m in pairs(idle)do if not m.Parent or m:GetAttribute('CraxId')~=C.Id then restoreIdle(m)end end
 for _,name in ipairs({'Fighter1','Fighter2'})do local m=workspace:FindFirstChild(name)
  if m and m:GetAttribute('CraxId')==C.Id and head(m)and not scene then
   armourProgress[m]=(armourProgress[m]or 0)+((m:GetAttribute('SymArmour')and 1 or 0)-(armourProgress[m]or 0))*math.min(1,elapsed*9)
   local h=head(m);local folder=m:FindFirstChild('SymAccessories');local s=idle[m]
   if not s and folder then s={};idle[m]=s;for _,p in ipairs(folder:GetChildren())do if p:IsA('BasePart')then s[p]={color=p.Color,reflect=p.Reflectance,localCF=h.CFrame:ToObjectSpace(p.CFrame),root=p:GetAttribute('SymRootLocal'),jaw=p:GetAttribute('SymJawRow')}end end end
   if s and not idleNative[m]then
    idleNative[m]=true
    for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')and(p.Name:match('^Lower')or p.Name=='InnerLower'or p.Name:match('^Tooth_1_'))then s[p]={color=p.Color,reflect=p.Reflectance,localCF=h.CFrame:ToObjectSpace(p.CFrame),jaw='Lower'}end end
   end
   local actor=actors[m];local open=actor and actor.tongue and(actor.mode=='Prepare'and .12 or .4)or 0
   if actor and actor.biteUntil and now<actor.biteUntil then open=.4*math.abs(math.sin((actor.biteUntil-now)/.18*math.pi))end
   if s then for p,v in pairs(s)do if p.Parent then
    if v.jaw=='Lower'then p.CFrame=h.CFrame*CFrame.new(0,-open*.8,0)*v.localCF;v.appliedCF=p.CFrame end
    if v.root then local phase=tonumber(p.Name:match('(%d+)$'))or 0;p.CFrame=h.CFrame*v.root*CFrame.Angles(math.sin(now*.8+phase)*.025,0,math.cos(now*.7+phase)*.025)*v.root:ToObjectSpace(v.localCF);v.appliedCF=p.CFrame end
    local white=p.Name:find('White',1,true);if white then v.appliedColor=v.color:Lerp(BLACK,(armourProgress[m]or 0)*.90);p.Color=v.appliedColor end
   end end end
  elseif m then restoreIdle(m)end
 end
 for m,a in pairs(actors)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('CraxId')~=C.Id then clearActor(m)
  else
   if a.tongue and a.tip then local radius=a.mode=='Pull'and a.target and head(a.target)and head(a.target).Size.X*.5+.2;local tip=radius and loc(a.target)or a.tip;updatePath(a.tongue,mouth(m),tip,RED,.5,radius,now)end
   if a.loop then Audio.Pause(a.loop,Clock.Paused(m))end
   if a.parasite and a.parasitePosition then moveParasite(a.parasite,a.parasitePosition+Vector3.new(0,math.sin(now*7)*.13,0),now)end
  end
 end
 for owner,targets in pairs(marks)do for target,model in pairs(targets)do
  local h=head(target);if not owner.Parent or not target.Parent or not h or(target:GetAttribute('Health')or 0)<=0 then model:Destroy();targets[target]=nil
  elseif animateContamination(model,h,now)then model:Destroy();targets[target]=nil end
 end end
 for i=#bursts,1,-1 do local b=bursts[i];local t=(now-b.start)/.65;if t>=1 then for _,v in ipairs(b.items)do v.p:Destroy()end;table.remove(bursts,i)else for _,v in ipairs(b.items)do v.p.Position=b.position+v.offset*(b.inward and 1-t or t);v.p.Transparency=t end end end
end)
local function clearAll()
 clearCombat();stopScene();Audio.Clear();for m in pairs(idle)do restoreIdle(m)end
 for _,b in ipairs(bursts)do for _,v in ipairs(b.items)do v.p:Destroy()end end;table.clear(bursts)
end
for _,k in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(k),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,k in ipairs({'RoundVictoryRound','RoundVictoryKind','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(k),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local C={Id='Crax_Symbioti',AbilityId='SymTongue',Health=125,Melee=8,
 -- Creator confirmed these first-version values on 2026-11-03 (Europe/Paris).
 Damage=16,Wait={8,12},BurstDamage=15,BurstHeal=5,ArmourThreshold=30,ArmourDuration=4,ArmourReduction=.35,
 ParasiteDuration=3,ParasiteDPS=3,ParasiteSlow=.75,ParasiteHeal=5,
 -- Prices: creator confirmed the existing Epic GhostyCrax grid.
 -- Provisional construction choices: see docs/symbioticrax/DECISIONS.md.
 Prepare=.35,Range=24,Width=.65,ExtendSpeed=42,PullSpeed=18,CaptureMax=2.2,Retract=.4,
 MarkDuration=15,TongueMarks=false,ParasiteWait={12,16},ParasiteSpeed=21,ParasitePursuitMax=4,ParasiteReturnMax=4,
 HealOnlyEffective=true,PricesEnabled=true,Quality='Auto',Volume=.16,
 TrophyId='SymbiotiTogether',TrophyTitle='NOUS SOMMES SYMBIOTICRAX',
 Finale={Deploy=1,Capture=2.3,Close=4.3,Impact=5.1,Retract=6,Pose=7.2,ReturnEnd=9},
 AtlasId='',Audio={},Icons={Marks='',Armour='',Parasite='',Max=''}}
local ids=game:GetService('ReplicatedStorage'):FindFirstChild('CraxSymUserAssets')
if ids then
 local atlas=ids:GetAttribute('AudioAtlas');if type(atlas)=='string'and atlas:match('^rbxassetid://%d+$')then C.AtlasId=atlas end
 for k in pairs(C.Icons)do local id=ids:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymPreview]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Full accessory framing for this character only, preserving each viewer's camera orbit.
local Run=game:GetService('RunService');local R=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSymRules'))
local M={};local records={};local bound=false;local accumulator=0
local function clear(view)
 local r=records[view];if r then for _,c in ipairs(r.connections)do c:Disconnect()end;records[view]=nil end
 if not next(records)and bound then Run:UnbindFromRenderStep('SymbiotiCraxPreviewFit');bound=false end
end
local function visible(view)
 local p=view
 while p do if(p:IsA('GuiObject')and not p.Visible)or(p:IsA('ScreenGui')and not p.Enabled)then return false end;p=p.Parent end
 return view.AbsoluteSize.X>0 and view.AbsoluteSize.Y>0
end
local function fit(view,model)
 local cam=view.CurrentCamera;if not cam then return end
 local cf,size=model:GetBoundingBox();local basis=cam.CFrame
 local function extent(axis)return math.abs(cf.RightVector:Dot(axis))*size.X+math.abs(cf.UpVector:Dot(axis))*size.Y+math.abs(cf.LookVector:Dot(axis))*size.Z end
 local width,height,depth=extent(basis.RightVector),extent(basis.UpVector),extent(basis.LookVector)
 local aspect=view.AbsoluteSize.X/math.max(1,view.AbsoluteSize.Y);local d=R.FitDistance(width,height,depth,aspect,cam.FieldOfView)
 cam.CFrame=CFrame.lookAt(cf.Position-basis.LookVector*d,cf.Position,basis.UpVector);cam.Focus=CFrame.new(cf.Position)
end
function M.Bind(view,model)
 if records[view]and records[view].model==model then fit(view,model);return end
 clear(view);local r={model=model,connections={}};records[view]=r
 r.connections[1]=view.Destroying:Connect(function()clear(view)end)
 r.connections[2]=model.Destroying:Connect(function()clear(view)end)
 fit(view,model)
 if not bound then bound=true;Run:BindToRenderStep('SymbiotiCraxPreviewFit',Enum.RenderPriority.Last.Value+250,function(dt)
  accumulator+=dt;if accumulator<1/20 then return end;accumulator=0
  for surface,entry in pairs(records)do if not surface.Parent or not entry.model.Parent then clear(surface)elseif visible(surface)then fit(surface,entry.model)end end
 end)end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSymRules]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local R={}
function R.New(level,random,c)return{level=math.clamp(level,0,4),time=0,nextTongue=random(c.Wait[1],c.Wait[2]),nextParasite=random(c.ParasiteWait[1],c.ParasiteWait[2]),lost=0,armourUntil=0,marks={}}end
function R.Mark(r,target,loss,c)
 if r.level<1 or loss<=0 then return 0,false end
 local mark=r.marks[target];if not mark or mark.expires<=r.time then mark={count=0};r.marks[target]=mark end
 mark.count+=1;mark.expires=r.time+c.MarkDuration
 if mark.count>=3 then r.marks[target]=nil;return 0,true end
 return mark.count,false
end
function R.Lost(r,loss,c,canStart)
 if r.level<2 or loss<=0 or r.time<r.armourUntil then return false end
 r.lost=math.min(c.ArmourThreshold,r.lost+loss)
 if r.lost>=c.ArmourThreshold and canStart then r.lost=0;r.armourUntil=r.time+c.ArmourDuration;return true end
 return false
end
function R.Reduce(r,amount,c)return r and r.time<r.armourUntil and amount*(1-c.ArmourReduction)or amount end
function R.Sweep(a,b,p,r)
 local v=b-a;local offset=a-p;local rr=r*r;local c=offset:Dot(offset)-rr
 if c<=0 then return true,0 end
 local aa=v:Dot(v);if aa<1e-12 then return false end
 local bb=2*offset:Dot(v);local d=bb*bb-4*aa*c;if d<0 then return false end
 local t=(-bb-math.sqrt(d))/(2*aa);return t>=0 and t<=1,t
end
function R.StepTowards(a,b,budget)local d=b-a;local l=d.Magnitude;if l<1e-8 then return b end;return a+d*(math.min(l,budget)/l)end
function R.FitDistance(width,height,depth,aspect,fov)return math.max(height,width/math.max(.2,aspect))/(2*math.tan(math.rad(fov*.5)))*1.10+depth*.5 end
return R
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSymRuntime]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Adapter in the existing movement/health loop. No client-selected targets or direct HP writes.
local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxSymConfig'));local R=require(RS:WaitForChild('CraxSymRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'));local Locks=require(SSS:WaitForChild('CraxPositionLock'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'));local Resolver=require(SSS:WaitForChild('CraxSkillResolver'))
local silence=RS:FindFirstChild('CraxSilenceGate');local Silence=silence and require(silence)or{CanStart=function(m)return not m:GetAttribute('InvertedSilenced')end}
local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxSymFX');local hit=SSS:WaitForChild('BiteHit');local heal=SSS:WaitForChild('CraxHeal')
local M={};local records={};local motions={};local held={};local captures={};local pending={};local serial=0;local round;local match;local random=Random.new();local occluders={}
local function rand(a,b)return random:NextNumber(a,b)end
local function live(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m and m:GetAttribute('CraxId')==C.Id end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function world(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function blocked(m)return Gate.Paused(m)or Deadly.Hold(m)or m:GetAttribute('FantasticInvisible')or m:GetAttribute('PlumberInTransit')or m:GetAttribute('VicePortalTransit')or m:GetAttribute('GoldenStatue')end
local function target(a,b)return live(b)and a~=b and not Deadly.SameTeam(a,b)and not blocked(b)and not b:GetAttribute('DeadlyPhantom')end
local function get(m)
 if not own(m)then return end
 if not records[m]then records[m]=R.New(Resolver.Resolve(m),rand,C)end
 return records[m]
end
local function origin(f)
 local h=f.model:FindFirstChild('Head',true);local a=h and h:FindFirstChild('SymMouth')
 if a then local p=a.WorldPosition+world(f,f.position)-f.model:GetPivot().Position;return Vector2.new(p.X,p.Y)end
 return f.position
end
local function clamp(p,radius)
 local l=workspace:FindFirstChild('Arenaleft');local r=workspace:FindFirstChild('ArenaRight');local b=workspace:FindFirstChild('Arenabottom');local t=workspace:FindFirstChild('ArenaTop')
 return Vector2.new(math.clamp(p.X,l.Position.X+l.Size.X*.5+radius,r.Position.X-r.Size.X*.5-radius),math.clamp(p.Y,b.Position.Y+b.Size.Y*.5+radius,t.Position.Y-t.Size.Y*.5-radius))
end
local function clip(f,from,to,radius)
 to=clamp(to,radius);local a,b=world(f,from),world(f,to);local delta=b-a
 if delta.Magnitude>1e-7 then
  local q=RaycastParams.new();q.FilterType=Enum.RaycastFilterType.Include;q.FilterDescendantsInstances=occluders
  local cast=workspace:Raycast(a,delta.Unit*(delta.Magnitude+radius),q)
  if cast then local p=a+delta.Unit*math.max(0,(cast.Position-a).Magnitude-radius);to=clamp(Vector2.new(p.X,p.Y),radius)end
 end
 return to
end
local function nearest(owner,position)
 local best,distance
 for m,f in pairs(motions)do if target(owner,m)and not captures[m]then local d=(f.position-position).Magnitude;if not distance or d<distance then best=f;distance=d end end end
 return best,distance
end
local function unlock(owner,r)
 local a=r.attack;if not a then return end
 local f=motions[owner];if f then Locks.Unlock(f,'SymCaster')end;held[owner]=nil
 if a.target then
  local t=motions[a.target]or a.targetMotion
  if t then Locks.Unlock(t,a.reason)end;Gate.Resume(a.target,a.reason)
  if captures[a.target]==owner then captures[a.target]=nil end
 end
 emit('TongueStop',{Owner=owner,Activation=a.id});r.attack=nil;r.nextTongue=r.time+rand(C.Wait[1],C.Wait[2])
end
local function clear(owner,r)
 unlock(owner,r);if owner.Parent then owner:SetAttribute('SymArmour',nil);owner:SetAttribute('SymLost',nil)end
 for victim in pairs(r.marks)do emit('Marks',{Owner=owner,Target=victim,Count=0})end
 emit('OwnerClear',{Owner=owner})
end
function M.Reset()
 for m,r in pairs(records)do clear(m,r)end
 records={};motions={};held={};captures={};pending={};round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')
end
function M.Begin(fighters)
 M.Reset();for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 occluders={};for _,n in ipairs({'Arenaleft','ArenaRight','Arenabottom','ArenaTop'})do occluders[#occluders+1]=workspace:FindFirstChild(n)end
 local ar=RS:FindFirstChild('CraxArenaConfigV37');local occ=ar and ar:FindFirstChild('CanonicalOccluders');if occ then for _,v in ipairs(occ:GetChildren())do if v:IsA('ObjectValue')and v.Value then occluders[#occluders+1]=v.Value end end end
end
function M.Held(m)return held[m]or captures[m]~=nil end
function M.Speed(m)
 for _,r in pairs(records)do local p=r.parasite;if p and p.mode=='Attached'and p.target==m then return C.ParasiteSlow end end
 return 1
end
function M.SuppressContact(a,b)return M.Held(a)or M.Held(b)end
function M.Reduce(m,amount)return R.Reduce(records[m],amount,C)end
function M.Healed(m,amount)if amount>0 and own(m)then emit('Heal',{Owner=m,Amount=amount})end end
function M.Confirm(a,b,loss,recoil,collision)
 local function apply(owner,victim,damage,melee)
  if not live(owner)then return end
  local r=get(owner);if not r then return end
  if melee and damage>0 then emit('Melee',{Owner=owner,Target=victim,Damage=damage})end
  if melee then
   local count,burst=R.Mark(r,victim,damage,C)
   if damage>0 and r.level>=1 then emit('Marks',{Owner=owner,Target=victim,Count=count})end
   if burst then pending[#pending+1]={owner=owner,target=victim,kind='SymBurst',amount=C.BurstDamage}end
  end
 end
 apply(a,b,loss,collision);apply(b,a,recoil,collision)
 local function lost(m,amount)
  if not live(m)then return end;local r=get(m);if not r then return end
  if amount>0 and r.time<r.armourUntil and r.time-(r.lastArmourHit or -100)>.15 then r.lastArmourHit=r.time;emit('ArmourHit',{Owner=m})end
  if R.Lost(r,amount,C,Silence.CanStart(m))then m:SetAttribute('SymArmour',true);emit('Armour',{Owner=m,Active=true})end
  m:SetAttribute('SymLost',r.lost)
 end
 lost(b,loss);lost(a,recoil)
end
function M.PowerResult(a,b,loss,kind)
 if kind=='SymBurst'and(loss>0 or not C.HealOnlyEffective)and live(a)then heal:Fire(a,C.BurstHeal,'SymContamination')end
 if kind=='SymParasite'and loss>0 then local r=records[a];if r and r.parasite then r.parasite.effective=true end end
 if kind=='SymTongue'then emit('Bite',{Owner=a,Target=b,Damage=loss});if C.TongueMarks and loss>0 then local r=records[a];if r then local count,burst=R.Mark(r,b,loss,C);emit('Marks',{Owner=a,Target=b,Count=count});if burst then pending[#pending+1]={owner=a,target=b,kind='SymBurst',amount=C.BurstDamage}end end end end
end
local function startTongue(f,r)
 local t=nearest(f.model,f.position);if not t then r.nextTongue=r.time+1;return end
 local start=origin(f);local d=t.position-start;if d.Magnitude<1e-6 then d=Vector2.new(1,0)end
 serial+=1;r.attack={mode='Prepare',age=0,aim=t.model,id=serial,dir=d.Unit,origin=start,tip=start,network=0};held[f.model]=true;Locks.Lock(f,'SymCaster')
 emit('TongueStart',{Owner=f.model,Activation=serial,Direction=Vector3.new(d.Unit.X,d.Unit.Y,0)})
end
local function tongue(f,r,dt)
 local a=r.attack;a.age+=dt
 if a.mode=='Prepare'and a.age>=C.Prepare then a.mode='Extend';a.age=0;a.tip=a.origin;emit('TongueLaunch',{Owner=f.model,Activation=a.id})end
 if a.mode=='Extend'then
  local from=a.tip;local to=clip(f,from,from+a.dir*C.ExtendSpeed*dt,C.Width);a.tip=to
  local first,fraction
  for m,g in pairs(motions)do if target(f.model,m)and not captures[m]then local ok,t=R.Sweep(from,to,g.position,g.radius+C.Width);if ok and(not fraction or t<fraction)then first=g;fraction=t end end end
  if first then
   a.target=first.model;a.targetMotion=first;a.reason='SymCapture_'..a.id;a.mode='Pull';a.age=0;captures[first.model]=f.model
   Locks.Lock(first,a.reason);Gate.Pause(first.model,a.reason);emit('Capture',{Owner=f.model,Target=first.model,Activation=a.id})
  elseif(a.tip-a.origin).Magnitude>=C.Range or a.age>=C.Range/C.ExtendSpeed+.2 or(to-from).Magnitude<.00001 then a.mode='Return';a.age=0;emit('Miss',{Owner=f.model,Activation=a.id})end
 elseif a.mode=='Pull'then
  local g=motions[a.target]
  if not g or not live(a.target)or a.target:GetAttribute('PlumberInTransit')or a.target:GetAttribute('VicePortalTransit')then unlock(f.model,r);return end
  local d=g.position-f.position;local stop=f.radius+g.radius+.15
  local desired=d.Magnitude>stop and f.position+d.Unit*stop or g.position
  local pos=clip(g,g.position,R.StepTowards(g.position,desired,C.PullSpeed*dt),g.radius)
  if not Locks.Move(g,a.reason,pos)then unlock(f.model,r);return end
  a.tip=g.position
  if(g.position-f.position).Magnitude<=stop+.1 then
   a.mode='Return';a.age=0;hit:Fire(f.model,g.model,C.Damage,false,'SymTongue');Locks.Unlock(g,a.reason);Gate.Resume(g.model,a.reason);captures[g.model]=nil
  elseif a.age>=C.CaptureMax then unlock(f.model,r);return end
 elseif a.mode=='Return'then
  a.tip=R.StepTowards(a.tip,origin(f),(C.Range/C.Retract)*dt)
  if a.age>=C.Retract then unlock(f.model,r);return end
 end
 a.network+=dt;if a.network>=.05 then a.network=0;emit('TongueState',{Owner=f.model,Target=a.target,Activation=a.id,Mode=a.mode,Position=world(f,a.tip)})end
end
local function parasite(f,r,dt)
 local p=r.parasite
 if not p then
  if r.level>=3 and r.time>=r.nextParasite and Silence.CanStart(f.model)and not blocked(f.model)and not r.attack then
   local t=nearest(f.model,f.position);if not t then r.nextParasite=r.time+1;return end
   serial+=1;p={id=serial,position=f.position,target=t.model,mode='Chase',age=0,network=0};r.parasite=p;emit('ParasiteStart',{Owner=f.model,Activation=p.id})
  end
  return
 end
 p.age+=dt;local t=motions[p.target]
 if p.mode=='Chase'then
  if not t or not target(f.model,p.target)or p.age>=C.ParasitePursuitMax then p.mode='Return';p.age=0
  else
   p.position=clip(f,p.position,R.StepTowards(p.position,t.position,C.ParasiteSpeed*dt),.55)
   if(p.position-t.position).Magnitude<=t.radius+.55 then p.mode='Attached';p.age=0;emit('ParasiteAttach',{Owner=f.model,Target=t.model,Activation=p.id})end
  end
 elseif p.mode=='Attached'then
  if not t or not live(p.target)or p.target:GetAttribute('PlumberInTransit')then p.mode='Return';p.age=0
  else
   p.position=t.position;local used=math.min(dt,math.max(0,C.ParasiteDuration-(p.age-dt)))
   if used>0 then hit:Fire(f.model,t.model,C.ParasiteDPS*used,false,'SymParasite')end
   if p.age>=C.ParasiteDuration-1e-9 then p.mode='Return';p.age=0;emit('ParasiteReturn',{Owner=f.model,Activation=p.id})end
  end
 elseif p.mode=='Return'then
  p.position=clip(f,p.position,R.StepTowards(p.position,f.position,C.ParasiteSpeed*dt),.55)
  if(p.position-f.position).Magnitude<=f.radius+.5 then
   if p.effective or not C.HealOnlyEffective then heal:Fire(f.model,C.ParasiteHeal,'SymParasiteReturn')end
   emit('ParasiteMerge',{Owner=f.model,Activation=p.id});r.parasite=nil;r.nextParasite=r.time+rand(C.ParasiteWait[1],C.ParasiteWait[2]);return
  elseif p.age>=C.ParasiteReturnMax then emit('ParasiteClear',{Owner=f.model,Activation=p.id});r.parasite=nil;r.nextParasite=r.time+rand(C.ParasiteWait[1],C.ParasiteWait[2]);return end
 end
 p.network+=dt;if p.network>=.05 then p.network=0;emit('ParasiteState',{Owner=f.model,Target=p.target,Activation=p.id,Mode=p.mode,Position=world(f,p.position)})end
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if next(records)then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 for m,r in pairs(records)do if not live(m)or not own(m)or not motions[m]then clear(m,r);records[m]=nil elseif r.attack and(not live(r.attack.target or r.attack.aim)or not motions[r.attack.target or r.attack.aim])then unlock(m,r)end end
 if not enabled then return end
 for _,f in ipairs(fighters)do local r=get(f.model)
  if r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)then
   r.time+=dt
   if f.model:GetAttribute('SymArmour')and r.time>=r.armourUntil then f.model:SetAttribute('SymArmour',nil);emit('Armour',{Owner=f.model,Active=false})end
   for m,mark in pairs(r.marks)do if not live(m)or mark.expires<=r.time then r.marks[m]=nil;emit('Marks',{Owner=f.model,Target=m,Count=0})end end
   if r.attack then tongue(f,r,dt)elseif r.time>=r.nextTongue and not blocked(f.model)and Silence.CanStart(f.model)then startTongue(f,r)end
   parasite(f,r,dt)
  end
 end
 local queue=pending;pending={};for _,e in ipairs(queue)do if live(e.owner)and own(e.owner)and records[e.owner]and live(e.target)then if Silence.CanStart(e.owner)and not blocked(e.owner)then emit('Burst',{Owner=e.owner,Target=e.target});hit:Fire(e.owner,e.target,e.amount,false,e.kind)else pending[#pending+1]=e end end end
end
return M
]====]}}
local expected={[====[SymFang_Tooth171]====],[====[SymFang_Tooth161]====],[====[SymFang_Tooth151]====],[====[SymFang_Tooth141]====],[====[SymFang_Tooth071]====],[====[SymFang_Tooth061]====],[====[SymFang_Tooth051]====],[====[SymFang_Tooth041]====],[====[SymLivingCoat]====],[====[SymWhite_Forehead]====],[====[SymWhite_Left]====],[====[SymWhite_BrokenCenter]====],[====[SymWhite_BrowSpot]====],[====[SymEye_Right]====],[====[SymEye_Left]====],[====[SymMaskRidge_00]====],[====[SymMaskRidge_01]====],[====[SymMaskRidge_02]====],[====[SymMaskRidge_03]====],[====[SymMaskRidge_04]====],[====[SymTentacle_00]====],[====[SymTentacle_01]====],[====[SymTentacle_02]====],[====[SymTentacle_03]====],[====[SymTentacle_04]====],[====[SymTentacle_05]====],[====[SymTentacle_06]====],[====[SymTentacle_07]====],[====[SymTentacle_08]====],[====[SymTongueRest]====],[====[SymTongueGroove]====],[====[SYM_Root_00]====],[====[SYM_Root_01]====],[====[SYM_Root_02]====],[====[SYM_Root_03]====],[====[SYM_Root_04]====],[====[SYM_Root_05]====],[====[SYM_Root_06]====],[====[SYM_Root_07]====],[====[SYM_Root_08]====],[====[FIT_HeadCenter]====],[====[FIT_Front]====],[====[FIT_Up]====],[====[SYM_Mouth]====]}

local backupName='SymbiotiCrax_Backup_V1';local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('SymOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde incomplète ou étrangère ; inspecter avant reprise')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source éditée après installation : '..e:GetAttribute('Path'))end
 for _,path in ipairs({'ReplicatedStorage.CraxSymFX','ReplicatedStorage.CraxSymImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Symbioti','ServerStorage.CraxTemplates.Crax_Symbioti'})do local o=resolve(path);assert(o and o:GetAttribute('SymOwned'),'Élément installé supprimé ou remplacé : '..path)end
 print('SymbiotiCrax déjà installé, aucun doublon');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)end
assert(resolve('Workspace.CombatState'),'CombatState absent')
local plan={};local marker='-- SymbiotiCraxIntegrationV1'
local function count(s,n)local total,p=0,1;while true do local a,b=s:find(n,p,true);if not a then return total end;total+=1;p=b+1 end end
for _,op in ipairs(ops)do
 local o=assert(resolve(op.path),'Source manquante : '..op.path);assert(o:IsA('LuaSourceContainer'),'Type de source incorrect');local before=read(o);assert(not before:find(marker,1,true),'Patch sans sauvegarde : '..op.path);local after=before
 if op.kind=='wrap'then after=marker..'\nlocal data=(function()\n'..before..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,r in ipairs(op.replacements)do assert(count(after,r.before)==1,'Source actuelle non reconnue : '..op.path..'. Aucun fichier modifié ; ne pas rétablir une ancienne version.');local a,b=after:find(r.before,1,true);after=after:sub(1,a-1)..r.after..after:sub(b+1)end
  after=marker..'\n'..(op.prepend or'')..after
 end
 plan[#plan+1]={path=op.path,object=o,before=before,after=after}
end
for _,m in ipairs(modules)do assert(not resolve(m.path),'Nom utilisé : '..m.path)end
for _,n in ipairs({'CraxSymFX','CraxSymImportedAssets'})do assert(not RS:FindFirstChild(n),'Nom utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'));local base=assert(templates:FindFirstChild('Crax_Monster'));local previews=assert(RS:FindFirstChild('CraxPreviews'))
assert(not templates:FindFirstChild('Crax_Symbioti')and not previews:FindFirstChild('Crax_Symbioti'),'Template/preview déjà présent')
local selected=game:GetService('Selection'):Get();assert(#selected==1,'Sélectionner une seule racine de SymbiotiCrax_ACCESSOIRES_IMPORT.fbx')
local imported=selected[1];assert(imported:IsA('Model')or imported:IsA('Folder'),'Racine importée attendue');local found={};local countParts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans les accessoires')
 if p:IsA('BasePart')then assert(not found[p.Name],'Nom dupliqué : '..p.Name);found[p.Name]=p;countParts+=1
  if p.Name:match('^Sym')then assert(p:IsA('MeshPart'),'MeshPart requis : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)end
 end
end
assert(countParts==#expected,'Import incomplet ou pièces supplémentaires')
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante : '..n)end
local c,f,u=found.FIT_HeadCenter.Position,found.FIT_Front.Position,found.FIT_Up.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('SymOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('SymOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxSymFX';event.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxSymImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxSymAppearance)
 local template=register(base:Clone());template.Name='Crax_Symbioti';appearance.Apply(template,assets);template:SetAttribute('AbilityId','SymTongue');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Symbioti';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : rollback bloqué par édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation arrêtée : '..tostring(err))
end
print('SymbiotiCrax installé. Sources de l’éditeur préservées, sauvegarde créée. Enregistrer, fermer/rouvrir puis NOUVEAU Play. Importer et brancher l’atlas audio et les illustrations pour les activer.')
end
