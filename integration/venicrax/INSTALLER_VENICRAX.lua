-- VENICRAX · INSTALLATION. Studio, Play ARRÊTÉ, barre de commande.
-- Prérequis : importer assets/venicrax/model/VeniCrax_ACCESSOIRES_IMPORT.fbx (Import 3D), placer le modèle importé
-- dans ServerStorage et le renommer VeniCrax_Import. Rien n'est modifié si une vérification échoue.
do

assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play (mode Édition), puis relancer cette commande')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local backupName='VeniCrax_Backup_V1'
local ops={{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxCatalog]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Veni,'VeniCrax déjà défini')
local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);local base=assert(data.Crax_Monster);local epic=assert(data.Crax_Ghosty)
data.Crax_Veni={DisplayName='VeniCrax',Rarity=epic.Rarity,RarityColor=epic.RarityColor,TemplateName=C.Id,MaxHealth=C.Health,CollisionDamage=C.Melee,Speed=base.Speed,
 Description='Le vrai Smillin\'Crax sous un casque capuche de cobra : écailles vert foncé, crête crème, veines de venin néon et quatre crocs verts.',
 PowerDescription='MORSURE LENTE : après 3 collisions de mêlée avec la même cible, l’empoisonne : 2 PV par seconde pendant 5 secondes (10 dégâts).',
 Effects={'VeniPoison'},Ability={Id=C.AbilityId,DisplayName='MORSURE LENTE',Damage=C.BiteTick*C.BiteDuration,Cooldown=0}}]====]},{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Veni)
local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);local prices=assert(data.Crax_Ghosty).Upgrades
local list={
 {Id='VeniRicochet',Name='COBRA RICOCHET',Description='Crache un cobra qui ricoche sur un mur avant de mordre : 5 dégâts à l’impact, puis 3 PV/s pendant 3 s (14 au total). Délai proposé : 7–10 s.'},
 {Id='VeniDistill',Name='DISTILLATION',Description='Après 5 pertes de PV causées par le poison, le prochain rebond contre un mur soigne VeniCrax de 8 PV. Recharge : 15 s.'},
 {Id='VeniMolt',Name='MUE TOXIQUE',Description='Laisse une mue translucide. Au contact d’un ennemi, un cercle apparaît puis, 0,7 s après, un nuage toxique applique Morsure lente. Délai proposé : 14–18 s.'},
 {Id='VeniFinale',Name=C.MaxTitle,Status=C.MaxTitle,TrophyId=C.TrophyId,Description='Exécution MAX sur une élimination par poison : un cobra vert ricoche sur un mur, s’enroule deux fois autour de la tête du vaincu, se resserre, des fissures vertes apparaissent et la figurine éclate en morceaux de vinyle.'}}
for i,u in ipairs(list)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Veni={Order=order+1,AbilityId=C.AbilityId,DisplayName='VeniCrax',Enabled=true,Upgrades=list,Finale=list[4]}]====]},{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[addition]====] ]=[====[data.VeniPoison={DisplayName='VENIN',Description='Perd des PV à chaque seconde (Morsure lente : 2 PV/s pendant 5 s ; Cobra : 3 PV/s pendant 3 s).',Duration=5,Image='',Color=Color3.fromRGB(150,255,40)}]====]},{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxVictoryCatalog]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);data.Crax_Veni={Id='VeniFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(150,255,40),MinimumLevel=4,Duration=C.FinaleDuration,IntroDuration=0,ZoomDuration=0,HoldDuration=0}]====]},{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxRouletteConfig]====],[ [====[addition]====] ]=[====[local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local same,total={},0;for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Veni');if cat[e.Id]and cat[e.Id].Rarity==cat.Crax_Veni.Rarity then same[#same+1]=e;total+=e.Weight end end;assert(#same>0,'Aucun Crax épique dans le casino');local w=total/(#same+1);for _,e in ipairs(same)do e.Weight=w end;data.Pool[#data.Pool+1]={Id='Crax_Veni',Weight=total-w*#same} -- Masse Épique inchangée, répartition égale.]====]},{[ [====[kind]====] ]=[====[wrap]====],[ [====[path]====] ]=[====[ServerScriptService.CraxSkinServer]====],[ [====[addition]====] ]=[====[local A=require(game:GetService('ReplicatedStorage').CraxVeniAppearance);local apply=data.Apply;function data.Apply(m,id,c)A.Restore(m);apply(m,id,c);if id=='Crax_Veni'then A.Apply(m,game:GetService('ReplicatedStorage').CraxVeniImportedAssets)end end]====]},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[ServerScriptService.ArenaMovement]====],[ [====[prepend]====] ]=[====[local VeniV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxVeniRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ PolariV1.Begin(fighters)]====],[ [====[after]====] ]=[====[ PolariV1.Begin(fighters)
 VeniV1.Begin(fighters)]====]},{[ [====[before]====] ]=[====[  if PolariV1.Frozen()then break end]====],[ [====[after]====] ]=[====[  if PolariV1.Frozen()then break end
  VeniV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not Killa.Fog()and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))]====]},{[ [====[before]====] ]=[====[PolariV1.WallContact(f.model,side);]====],[ [====[after]====] ]=[====[PolariV1.WallContact(f.model,side);VeniV1.WallContact(f.model,side);]====]}}},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[ServerScriptService.CombatHealth]====],[ [====[prepend]====] ]=[====[local VeniV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxVeniRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)]====],[ [====[after]====] ]=[====[Inverted.Confirm(attacker,defender,lost,attackerLost,collision);VeniV1.Confirm(attacker,defender,lost,attackerLost,collision,kind);report(attacker,defender,lost,kind)]====]}}},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[ServerScriptService.RoundManager]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ local enhanced=spec and(model:GetAttribute("CraxSkillLevel")or 0)>=spec.MinimumLevel]====],[ [====[after]====] ]=[====[ local enhanced=spec and(model:GetAttribute("CraxSkillLevel")or 0)>=spec.MinimumLevel
 -- VeniCrax : exécution MAX seulement sur une élimination par poison de cette manche.
 if enhanced and model:GetAttribute('CraxId')=='Crax_Veni'and(state:GetAttribute('VeniPoisonKillRound')~=state:GetAttribute('RoundId')or state:GetAttribute('VeniPoisonKillMatch')~=state:GetAttribute('CraxMatchToken'))then enhanced=false end]====]}}},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.ArenaCamera]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[if state:GetAttribute('RoundVictoryKind')=='PolariFinale']====],[ [====[after]====] ]=[====[if state:GetAttribute('RoundVictoryKind')=='VeniFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end
 if state:GetAttribute('RoundVictoryKind')=='PolariFinale']====]},{[ [====[before]====] ]=[====[if player:GetAttribute("PolariCameraOwner")then]====],[ [====[after]====] ]=[====[if player:GetAttribute("VeniCameraOwner")then if defeat then clearDefeat()end;return end
  if player:GetAttribute("PolariCameraOwner")then]====]}}},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],[ [====[prepend]====] ]=[====[local function veniIconV1(parent,kind,x,y,size)
 local RSv=game:GetService('ReplicatedStorage');local C=require(RSv:WaitForChild('CraxVeniConfig'))
 local holder=Instance.new('Frame');holder.Size=UDim2.fromOffset(size,size);holder.Position=UDim2.fromOffset(x,y);holder.BackgroundTransparency=1;holder.ZIndex=4;holder.Parent=parent
 local key=({VeniBite='Bite',VeniRicochet='Cobra',VeniDistill='Distill',VeniMolt='Molt',VeniFinale='Max'})[kind]
 if key and C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=holder;return holder end
 if kind=='VeniFinale'then require(RSv:WaitForChild('CraxTrophyIcons')).Build(holder,true);return holder end
 local disc=Instance.new('Frame');disc.Size=UDim2.fromScale(1,1);disc.BackgroundColor3=Color3.fromRGB(16,70,28);disc.ZIndex=5;disc.Parent=holder
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.5,0);corner.Parent=disc
 local stroke=Instance.new('UIStroke');stroke.Color=Color3.fromRGB(150,255,40);stroke.Thickness=2;stroke.Parent=disc
 local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(.8,.8);t.Position=UDim2.fromScale(.1,.1);t.BackgroundTransparency=1;t.TextScaled=true;t.Font=Enum.Font.GothamBlack;t.TextColor3=Color3.fromRGB(150,255,40);t.ZIndex=6
 t.Text=({VeniBite='§',VeniRicochet='S',VeniDistill='+',VeniMolt='◌'})[kind]or'V';t.Parent=disc;return holder
end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end]====],[ [====[after]====] ]=[====[if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end
 if type(kind)=='string'and kind:sub(1,4)=='Veni'then veniIconV1(parent,kind,x,y,size);return end]====]},{[ [====[before]====] ]=[====[if currentCrax=='Crax_Polari'then earned:ClearAllChildren()]====],[ [====[after]====] ]=[====[if currentCrax=='Crax_Veni'then earned:ClearAllChildren();veniIconV1(earned,'VeniFinale',0,0,88);name.Text=require(RS.CraxVeniConfig).MaxTitle end
   if currentCrax=='Crax_Polari'then earned:ClearAllChildren()]====]},{[ [====[before]====] ]=[====[  -- PolariNomMaxCorrige]====],[ [====[after]====] ]=[====[  if currentCrax=='Crax_Veni'then local title=require(RS.CraxVeniConfig).MaxTitle;if owned and lv>=4 then status='MAX · '..title end;local caption=left:FindFirstChild('CraxTrophyCaption');if caption then caption.Text=title end end
  -- PolariNomMaxCorrige]====]}}},{[ [====[kind]====] ]=[====[patch]====],[ [====[path]====] ]=[====[ReplicatedStorage.CraxBookCinema]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig)]====],[ [====[after]====] ]=[====[if id=='Crax_Veni'then local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(150,255,40),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end
 if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig)]====]}}}}
local modules={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVeniConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- VeniCrax : valeurs du cahier des charges (validées par le créateur) puis réglages proposés, modifiables ici.
local C={Id='Crax_Veni',AbilityId='VeniBite',Health=100,Melee=5,
 -- Base · Morsure lente (validé) : après 3 collisions de mêlée, 2 PV/s pendant 5 s = 10 dégâts.
 BiteContacts=3,BiteTick=2,BiteDuration=5,
 -- N1 · Cobra Ricochet (validé) : 5 à l'impact, puis 3 PV/s pendant 3 s = 14 au total.
 CobraDamage=5,CobraTick=3,CobraDuration=3,
 -- N2 · Distillation (proposition) : après 5 pertes de PV dues au poison, prochain rebond mural = +8 PV, recharge 15 s.
 DistillPoisonLosses=5,DistillHeal=8,DistillCooldown=15,
 -- N3 · Mue toxique (proposition) : mue au contact -> cercle, nuage 0,7 s après, applique Morsure lente.
 MoltDelay=.7,
 -- Réglages proposés (pas encore validés par le créateur).
 TickInterval=1,CobraWait={7,10},CobraFirstWait={3,5},CobraSpeed=34,CobraRadius=.55,CobraLife=3.2,CobraMaxBounces=3,
 MoltWait={14,18},MoltFirstWait={6,8},MoltLife=8,MoltTouchRadius=1.4,MoltCloudRadius=4.8,ContactWindow=.35,
 FinaleDuration=9.5,MaxTitle='ÉTREINTE DU COBRA',TrophyId='VeniCobraEmbrace',
 Volume=.2,Quality='Auto',AtlasId='',Icons={Bite='',Cobra='',Distill='',Molt='',Max=''},HelmetColor='',HelmetNormal=''}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxVeniUserAssets')
local function asset(v)return type(v)=='string'and v:match('^rbxassetid://%d+$')and v or nil end
if user then
 C.AtlasId=asset(user:GetAttribute('AudioAtlas'))or C.AtlasId
 C.HelmetColor=asset(user:GetAttribute('HelmetColor'))or C.HelmetColor
 C.HelmetNormal=asset(user:GetAttribute('HelmetNormal'))or C.HelmetNormal
 for k in pairs(C.Icons)do C.Icons[k]=asset(user:GetAttribute('Icon_'..k))or C.Icons[k]end
end
return C
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVeniRules]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Règles pures VeniCrax (sans service Roblox) : testables hors Studio.
local R={}

-- Poison : un emplacement par source ('Bite' ou 'Cobra'). Réappliquer rafraîchit la durée, sans cumuler.
function R.NewPoison(kind,perTick,duration,interval)
 return{kind=kind,perTick=perTick,ticks=math.floor(duration/interval+1e-6),interval=interval,clock=0}
end
-- Avance un poison de dt ; renvoie le nombre de ticks à infliger et si le poison est terminé.
function R.AdvancePoison(p,dt)
 p.clock+=dt;local due=0
 while p.ticks>0 and p.clock+1e-8>=p.interval do p.clock-=p.interval;p.ticks-=1;due+=1 end
 return due,p.ticks<=0
end

-- Tir du cobra : vise le reflet de la cible par le mur le plus utile, pour un ricochet puis l'impact.
local function reflect(point,side,b)
 if side=='Left'then return Vector2.new(2*b.minX-point.X,point.Y)
 elseif side=='Right'then return Vector2.new(2*b.maxX-point.X,point.Y)
 elseif side=='Bottom'then return Vector2.new(point.X,2*b.minY-point.Y)end
 return Vector2.new(point.X,2*b.maxY-point.Y)
end
function R.RicochetAim(from,target,b)
 -- Le mur dont le reflet donne le trajet le plus court (rebond lisible, pas un tir direct).
 local best,length,chosen
 for _,side in ipairs({'Left','Right','Bottom','Top'})do
  local mirrored=reflect(target,side,b);local d=(mirrored-from).Magnitude
  if d>1e-6 and(not length or d<length)then best=mirrored;length=d;chosen=side end
 end
 if not best then return Vector2.new(1,0),nil end
 return (best-from).Unit,chosen
end

-- Déplacement d'un projectile avec rebonds sur les murs de l'arène (rayon r). Renvoie position, vitesse, rebonds.
function R.Bounce(position,velocity,dt,r,b)
 local p=position+velocity*dt;local v=velocity;local walls={}
 if p.X<b.minX+r then p=Vector2.new(2*(b.minX+r)-p.X,p.Y);v=Vector2.new(-v.X,v.Y);walls[#walls+1]='Left'
 elseif p.X>b.maxX-r then p=Vector2.new(2*(b.maxX-r)-p.X,p.Y);v=Vector2.new(-v.X,v.Y);walls[#walls+1]='Right'end
 if p.Y<b.minY+r then p=Vector2.new(p.X,2*(b.minY+r)-p.Y);v=Vector2.new(v.X,-v.Y);walls[#walls+1]='Bottom'
 elseif p.Y>b.maxY-r then p=Vector2.new(p.X,2*(b.maxY-r)-p.Y);v=Vector2.new(v.X,-v.Y);walls[#walls+1]='Top'end
 return p,v,walls
end

-- Plus petite fraction 0..1 du segment relatif où deux cercles se touchent (balayage continu).
function R.Sweep(a,b,radius)
 local d=b-a;local A=d:Dot(d);local B=2*a:Dot(d);local Cc=a:Dot(a)-radius*radius
 if Cc<=0 then return 0 end;if A<1e-12 then return nil end
 local disc=B*B-4*A*Cc;if disc<0 then return nil end
 local t=(-B-math.sqrt(disc))/(2*A);if t>=0 and t<=1 then return t end;return nil
end

-- Distillation : armée après N pertes de poison, si la recharge est écoulée.
function R.DistillArmed(record,needed,now)
 return(record.poisonLosses or 0)>=needed and now>=(record.distillReadyAt or 0)
end

return R
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVeniAppearance]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Habillage VeniCrax : tête CraxSourire native + casque capuche de cobra, crête, arcade, veines, crocs et gouttes.
-- Les pièces viennent de ReplicatedStorage.CraxVeniImportedAssets (import de VeniCrax_ACCESSOIRES_IMPORT.fbx).
local RS=game:GetService('ReplicatedStorage')
local M={};local saved=setmetatable({},{__mode='k'})
local GREEN=Color3.fromRGB(14,62,26);local CREAM=Color3.fromRGB(226,203,140);local NEON=Color3.fromRGB(170,255,40);local FANG=Color3.fromRGB(128,226,18)
local STYLE={
 V_HelmetShell={GREEN,Enum.Material.SmoothPlastic,.06,0},
 V_HelmetInner={CREAM,Enum.Material.SmoothPlastic,0,0},
 V_HelmetCrest={CREAM,Enum.Material.SmoothPlastic,.08,0},
 V_HelmetBrow={GREEN,Enum.Material.SmoothPlastic,.08,0},
 V_VenomVeins={NEON,Enum.Material.Neon,0,0},
 V_Fangs={FANG,Enum.Material.Glass,.15,.22},
 V_FangsCore={NEON,Enum.Material.Neon,0,0},
 V_VenomDrops={NEON,Enum.Material.Neon,0,0},
}
M.Parts={'V_HelmetShell','V_HelmetInner','V_HelmetCrest','V_HelmetBrow','V_VenomVeins','V_Fangs','V_FangsCore','V_VenomDrops'}
M.Markers={'V_FitOrigin','V_FitUp','V_FitFront'}
local function part(model,name)local p=model:FindFirstChild(name,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(model)
 local accessory=model:FindFirstChild('VeniAccessories');if accessory then accessory:Destroy()end
 local map=saved[model]
 if map then for p,s in pairs(map)do if p.Parent then
  p.Color=s.color;p.Material=s.material;p.Reflectance=s.reflectance;p.Transparency=s.alpha
  if p:IsA('MeshPart')then p.TextureID=s.texture end
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then c:Destroy()end end
  for _,c in ipairs(s.surfaces)do c:Clone().Parent=p end
 end end end;saved[model]=nil
end
function M.Apply(model,assets)
 M.Restore(model);assets=assets or RS:FindFirstChild('CraxVeniImportedAssets')
 local head=assert(part(model,'Head'),'Head natif absent');local left=assert(part(model,'EyeLeft'));local right=assert(part(model,'EyeRight'))
 local origin=assert(assets:FindFirstChild('V_FitOrigin',true));local front=assert(assets:FindFirstChild('V_FitFront',true));local up=assert(assets:FindFirstChild('V_FitUp',true))
 local sourceForward=(front.Position-origin.Position).Unit;local sourceUp=(up.Position-origin.Position).Unit
 local sourceRight=sourceForward:Cross(sourceUp).Unit;sourceUp=sourceRight:Cross(sourceForward).Unit
 local sourceCF=CFrame.fromMatrix(origin.Position,sourceRight,sourceUp,-sourceForward)
 local forward=((left.Position+right.Position)*.5-head.Position);forward=(forward-head.CFrame.UpVector*forward:Dot(head.CFrame.UpVector)).Unit
 local targetRight=forward:Cross(head.CFrame.UpVector).Unit
 local targetCF=CFrame.fromMatrix(head.Position,targetRight,head.CFrame.UpVector,-forward)
 local scale=(head.Size.Y*.5)/(up.Position-origin.Position).Magnitude
 local oldPivot=model:GetPivot();local snapshots={};saved[model]=snapshots
 -- Tête native : vinyle blanc, sourire crème, gencives rouges, yeux fermés noirs ; la croix du dos est sous le casque.
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then
  local s={color=p.Color,material=p.Material,reflectance=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then s.surfaces[#s.surfaces+1]=c:Clone();c:Destroy()end end;snapshots[p]=s
  local n=p.Name:lower()
  p.Color=n:find('tooth',1,true)and Color3.fromRGB(243,226,190)or(n:find('gums',1,true)and Color3.fromRGB(206,36,48)or((n=='eyeleft'or n=='eyeright'or n:find('inner',1,true))and Color3.fromRGB(8,9,12)or Color3.fromRGB(236,238,230)))
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  if p:IsA('MeshPart')then p.TextureID=''end
  if n:find('cross',1,true)then p.Transparency=1 elseif n:find('tooth',1,true)or n:find('gums',1,true)or n=='eyeleft'or n=='eyeright'or n:find('shell',1,true)then p.Transparency=0 end
  if n=='head'then p.Transparency=1 end
 end end
 local accessory=Instance.new('Model');accessory.Name='VeniAccessories'
 for _,source in ipairs(assets:GetDescendants())do
  local style=source:IsA('BasePart')and STYLE[source.Name]
  if style then
   local p=source:Clone();local rel=sourceCF:ToObjectSpace(source.CFrame)
   p.Size=source.Size*scale;p.CFrame=targetCF*(rel.Rotation+rel.Position*scale)
   p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true;p.CastShadow=style[2]~=Enum.Material.Neon
   p.Color=style[1];p.Material=style[2];p.Reflectance=style[3];p.Transparency=style[4]
   for _,c in ipairs(p:GetDescendants())do if c:IsA('LuaSourceContainer')or c:IsA('Sound')then c:Destroy()end end
   if p:IsA('MeshPart')then p.TextureID=''end
   -- Écailles de cobra : le SurfaceAppearance est posé dans Studio sur la pièce importée (ColorMap non modifiable en jeu).
   if p:FindFirstChildWhichIsA('SurfaceAppearance')then p.Color=Color3.new(1,1,1)end
   p.Parent=accessory
  end
 end
 accessory.Parent=model
 if not model.PrimaryPart then model.WorldPivot=oldPivot end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVeniAudio]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxVeniConfig'));local Map=require(RS:WaitForChild('CraxVeniAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false;local missingReported=false
local mix={PoisonTick=.45,BiteStack=.6,CobraLoop=.55,MoltIdle=.4,Cloud=.9,MaxShatter=1,MaxSting=.9}
local function atlasId()
 local user=RS:FindFirstChild('CraxVeniUserAssets');local id=user and user:GetAttribute('AudioAtlas')
 if type(id)=='string'and id:match('^rbxassetid://%d+$')then return id end
 return C.AtlasId
end
local function remove(i)local e=entries[i];e.sound:Stop();e.sound:Destroy();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale,localMix)
 local clip=Map.Segments[name];if not clip then return end
 local id=atlasId()
 if id==''then if not missingReported then missingReported=true;warn('VeniCrax : importer VeniCrax_Audio_Atlas.wav et configurer CraxVeniUserAssets.AudioAtlas pour activer les sons.')end;return end
 if #entries>=28 then remove(1)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='VeniAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.Name='Veni_'..name;s.SoundId=id;local gain=C.Volume*(mix[name]or 1);s.Volume=finale and gain*.95 or math.min(1,gain*3);s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop

 -- Seated arena presentation uses a camera mix; spectators keep spatial attenuation.
 s.Parent=localMix and root or p
 if preloaded~=id then preloaded=id;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({s})end)end)end
 local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('VeniCrax : l’atlas audio configuré n’a pas la bonne durée');e.born=-math.huge
    else e.sound.TimePosition=e.clip.Start;e.sound:Play();e.started=true end
   end
   if not e.anchor.Parent or os.clock()-e.born>15 or(e.sound.IsLoaded and not e.sound.Looped and e.sound.TimePosition>=e.clip.End-.001)or(e.started and e.sound.IsLoaded and os.clock()-e.born>.2 and not e.sound.IsPlaying and not e.sound.IsPaused)then remove(i)end
  end
  if #entries==0 and connection then connection:Disconnect();connection=nil end
 end)end
 return entry
end
function M.Move(entry,position)if entry and entry.anchor.Parent then entry.anchor.Position=position end end
function M.Stop(entry)if not entry then return end;for i=#entries,1,-1 do if entries[i]==entry then remove(i)end end end
function M.Pause(entry,paused)if entry and entry.anchor.Parent then entry.paused=paused;if entry.started then if paused and entry.sound.IsPlaying then entry.sound:Pause()elseif not paused and entry.sound.IsPaused then entry.sound:Resume()end end end end
function M.Clear()for i=#entries,1,-1 do remove(i)end;if connection then connection:Disconnect();connection=nil end;if root then root:Destroy();root=nil end end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVeniAudioMap]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[return {Duration=21.9599,Segments={
 ['Bite']={Start=0.0,End=0.42,Loop=false},
 ['BiteStack']={Start=0.54,End=0.7,Loop=false},
 ['PoisonTick']={Start=0.82,End=0.94,Loop=false},
 ['Spit']={Start=1.06,End=1.56,Loop=false},
 ['CobraLoop']={Start=1.68,End=2.7,Loop=true},
 ['Bounce']={Start=2.82,End=3.27,Loop=false},
 ['CobraImpact']={Start=3.39,End=4.09,Loop=false},
 ['DistillReady']={Start=4.21,End=4.91,Loop=false},
 ['Distill']={Start=5.03,End=6.13,Loop=false},
 ['MoltShed']={Start=6.25,End=7.05,Loop=false},
 ['MoltIdle']={Start=7.17,End=8.29,Loop=true},
 ['MoltWarn']={Start=8.41,End=9.16,Loop=false},
 ['Cloud']={Start=9.28,End=10.6799,Loop=false},
 ['MaxHiss']={Start=10.7999,End=12.0999,Loop=false},
 ['MaxSpit']={Start=12.2199,End=13.2199,Loop=false},
 ['MaxBounce']={Start=13.3399,End=14.1399,Loop=false},
 ['MaxCoil']={Start=14.2599,End=16.2599,Loop=false},
 ['MaxSqueeze']={Start=16.3799,End=17.1799,Loop=false},
 ['MaxCrack']={Start=17.2999,End=18.2999,Loop=false},
 ['MaxShatter']={Start=18.4199,End=19.9199,Loop=false},
 ['MaxSting']={Start=20.0399,End=21.8399,Loop=false},
}}
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxVeniRuntime]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- VeniCrax : autorité serveur. Utilise les mouvements existants (ArenaMovement), BiteHit et CraxHeal (CombatHealth).
local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxVeniConfig'));local R=require(RS:WaitForChild('CraxVeniRules'))
local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Skills=require(SS:WaitForChild('CraxSkillResolver'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local FX=RS:WaitForChild('CraxVeniFX');local Hit=SS:WaitForChild('BiteHit');local Heal=SS:WaitForChild('CraxHeal');local state=workspace:WaitForChild('CombatState')
local M={};local records={};local poisons={};local cobras={};local molts={};local motions={};local previous={};local contacts={};local round;local match;local serial=0;local running=false;local rng=Random.new()
local function rand(v)return rng:NextNumber(v[1],v[2])end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m and m:GetAttribute('CraxId')==C.Id end
local function enabled(m)return alive(m)and own(m)and not m:GetAttribute('LuckyTricked')end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function xyz(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bounds()
 local a=workspace:FindFirstChild('Arenaleft');local b=workspace:FindFirstChild('ArenaRight');local c=workspace:FindFirstChild('Arenabottom');local d=workspace:FindFirstChild('ArenaTop');return{minX=a.Position.X+a.Size.X*.5,maxX=b.Position.X-b.Size.X*.5,minY=c.Position.Y+c.Size.Y*.5,maxY=d.Position.Y-d.Size.Y*.5}
end
local function enemy(a,b)return alive(b)and a~=b and not Deadly.SameTeam(a,b)and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('DeadlyPhantom')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')end
local function target(f)local best,dist;for m,g in pairs(motions)do if enemy(f.model,m)then local d=(g.position-f.position).Magnitude;if not dist or d<dist then best=g;dist=d end end end;return best end
local function externallyHeld(m)
 for _,spec in ipairs({{'CraxBatRuntime','Hold'},{'CraxHangoverRuntime','Hold'},{'CraxBlackSpideyRuntime','Hold'},{'CraxSonGoRuntime','Hold'},{'CraxLuckyRuntime','Hold'},{'CraxSymRuntime','Held'},{'CraxSuperRuntime','Held'}})do
  local source=SS:FindFirstChild(spec[1]);if source then local runtime=require(source);if runtime[spec[2]]and runtime[spec[2]](m)then return true end end
 end
 return false
end
local function busy(m)return Gate.Paused(m)or Deadly.Hold(m)or externallyHeld(m)end
local function get(m)
 if not own(m)then return end
 if not records[m]then records[m]={time=0,level=Skills.Resolve(m),poisonLosses=0,distillReadyAt=0,due={Cobra=rand(C.CobraFirstWait),Molt=rand(C.MoltFirstWait)}}end
 return records[m]
end

-- ---------------------------------------------------------------- poison
local function applyPoison(owner,victim,kind)
 if not enemy(owner,victim)then return end
 local perTick=kind=='Cobra'and C.CobraTick or C.BiteTick;local duration=kind=='Cobra'and C.CobraDuration or C.BiteDuration
 poisons[victim]=poisons[victim]or{};serial+=1
 local p=R.NewPoison(kind,perTick,duration,C.TickInterval);p.owner=owner;p.id=serial;poisons[victim][kind]=p
 victim:SetAttribute('VeniPoisoned',true)
 emit('Poison',{Owner=owner,Target=victim,Kind=kind,Duration=duration,Activation=serial})
end
local function endPoison(victim,kind)
 local list=poisons[victim];if not list or not list[kind]then return end;list[kind]=nil
 emit('PoisonEnd',{Target=victim,Kind=kind})
 if not next(list)then poisons[victim]=nil;if victim.Parent then victim:SetAttribute('VeniPoisoned',nil)end end
end
local function stepPoisons(dt)
 for victim,list in pairs(poisons)do
  if not alive(victim)then for kind in pairs(list)do endPoison(victim,kind)end
  else for kind,p in pairs(list)do
   if not enabled(p.owner)then endPoison(victim,kind)else
    local due,finished=R.AdvancePoison(p,dt)
    for _=1,due do
     if alive(victim)then Hit:Fire(p.owner,victim,p.perTick,false,'VeniPoison',nil,'VeniPoison:'..p.id..':'..p.ticks);emit('PoisonTick',{Owner=p.owner,Target=victim,Kind=kind,Amount=p.perTick})end
    end
    if finished then endPoison(victim,kind)end
   end
  end end
 end
end

-- ---------------------------------------------------------------- nettoyage
local function clearOwner(m)
 records[m]=nil
 for i=#cobras,1,-1 do if cobras[i].owner==m then emit('CobraEnd',{Id=cobras[i].id});table.remove(cobras,i)end end
 for i=#molts,1,-1 do if molts[i].owner==m then emit('MoltEnd',{Id=molts[i].id});table.remove(molts,i)end end
 for victim,list in pairs(poisons)do for kind,p in pairs(list)do if p.owner==m then endPoison(victim,kind)end end end
 emit('OwnerClear',{Owner=m})
end
function M.Cancel(m)clearOwner(m)end
function M.Reset()
 running=false
 for victim,list in pairs(poisons)do for kind in pairs(list)do endPoison(victim,kind)end end
 records={};poisons={};cobras={};molts={};motions={};previous={};contacts={}
 round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')
end
function M.Begin(fighters)M.Reset();running=true;for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end end
function M.Poisoned(m)return poisons[m]~=nil end

-- ---------------------------------------------------------------- Cobra Ricochet (N1)
local function spitCobra(f,r)
 local t=target(f);if not t then r.due.Cobra=r.time+1;return end
 local dir,wall=R.RicochetAim(f.position,t.position,bounds());serial+=1
 local cobra={id=serial,owner=f.model,position=f.position+dir*(f.radius+.3),velocity=dir*C.CobraSpeed,life=0,bounces=0,net=0}
 cobras[#cobras+1]=cobra;r.due.Cobra=r.time+rand(C.CobraWait)
 emit('Cobra',{Owner=f.model,Id=cobra.id,Position=xyz(f,cobra.position),Direction=Vector3.new(dir.X,dir.Y,0),Wall=wall,Target=t.model})
end
local function advanceCobra(c,dt)
 local f=motions[c.owner];if not f or not enabled(c.owner)then return false end;if Gate.Paused(c.owner)then return true end
 local from=c.position;local to,velocity,walls=R.Bounce(from,c.velocity,dt,C.CobraRadius,bounds())
 local first,entry
 for m,g in pairs(motions)do if enemy(c.owner,m)then
  local prior=previous[m]or g.position;local hit=R.Sweep(from-prior,to-g.position,g.radius+C.CobraRadius)
  if hit and(not entry or hit<entry)then first=g;entry=hit end
 end end
 if first then
  Hit:Fire(c.owner,first.model,C.CobraDamage,false,'VeniCobra',nil,'VeniCobra:'..c.id)
  emit('CobraImpact',{Owner=c.owner,Target=first.model,Id=c.id,Position=xyz(f,from+(to-from)*entry)})
  return false
 end
 for _,side in ipairs(walls)do c.bounces+=1;emit('CobraBounce',{Owner=c.owner,Id=c.id,Side=side,Position=xyz(f,to)})end
 c.position=to;c.velocity=velocity;c.life+=dt
 if c.bounces>C.CobraMaxBounces or c.life>=C.CobraLife then return false end
 c.net+=dt;if c.net>=.05 then c.net=0;emit('CobraState',{Id=c.id,Owner=c.owner,Position=xyz(f,to),Direction=Vector3.new(velocity.Unit.X,velocity.Unit.Y,0)})end
 return true
end

-- ---------------------------------------------------------------- Mue toxique (N3)
local function shedMolt(f,r)
 serial+=1;local m={id=serial,owner=f.model,position=f.position,depth=f.depth,age=0,phase='Idle'}
 molts[#molts+1]=m;r.due.Molt=r.time+rand(C.MoltWait)
 emit('Molt',{Owner=f.model,Id=m.id,Position=xyz(f,m.position),Life=C.MoltLife})
end
local function advanceMolt(m,dt)
 if not enabled(m.owner)then return false end
 m.age+=dt
 if m.phase=='Idle'then
  if m.age>=C.MoltLife then return false end
  for victim,g in pairs(motions)do if enemy(m.owner,victim)and(g.position-m.position).Magnitude<=g.radius+C.MoltTouchRadius then
   m.phase='Armed';m.timer=0;emit('MoltTrigger',{Owner=m.owner,Id=m.id,Position=Vector3.new(m.position.X,m.position.Y,m.depth),Radius=C.MoltCloudRadius,Delay=C.MoltDelay});break
  end end
  return true
 end
 m.timer+=dt
 if m.timer+1e-8>=C.MoltDelay then
  local touched={}
  for victim,g in pairs(motions)do if enemy(m.owner,victim)and(g.position-m.position).Magnitude<=C.MoltCloudRadius+g.radius then applyPoison(m.owner,victim,'Bite');touched[#touched+1]=victim end end
  emit('MoltCloud',{Owner=m.owner,Id=m.id,Position=Vector3.new(m.position.X,m.position.Y,m.depth),Radius=C.MoltCloudRadius,Targets=touched})
  return false
 end
 return true
end

-- ---------------------------------------------------------------- crochets CombatHealth / ArenaMovement
-- Appelé par CombatHealth après chaque coup confirmé (dégâts réels déjà appliqués).
function M.Confirm(attacker,defender,lost,attackerLost,collision,kind)
 if state:GetAttribute('Phase')~='Fighting'then return end
 if collision then
  for _,pair in ipairs({{attacker,defender},{defender,attacker}})do
   local veni,victim=pair[1],pair[2];local r=enabled(veni)and get(veni)
   if r and enemy(veni,victim)then
    local now=workspace:GetServerTimeNow();contacts[veni]=contacts[veni]or{};local c=contacts[veni][victim]or{count=0,last=-math.huge}
    if now-c.last>=C.ContactWindow then
     c.last=now;c.count+=1
     emit('BiteStack',{Owner=veni,Target=victim,Count=c.count,Needed=C.BiteContacts})
     if c.count>=C.BiteContacts then c.count=0;applyPoison(veni,victim,'Bite')end
    end
    contacts[veni][victim]=c
   end
  end
 end
 if kind=='VeniCobra'and(lost or 0)>0 then applyPoison(attacker,defender,'Cobra')end
 if kind=='VeniPoison'and(lost or 0)>0 then
  local r=enabled(attacker)and get(attacker)
  if r then
   r.poisonLosses+=1
   if r.level>=2 and not r.distillNotified and R.DistillArmed(r,C.DistillPoisonLosses,r.time)then r.distillNotified=true;emit('DistillReady',{Owner=attacker})end
  end
  if(defender:GetAttribute('Health')or 1)<=0 then
   state:SetAttribute('VeniPoisonKillRound',state:GetAttribute('RoundId'));state:SetAttribute('VeniPoisonKillMatch',state:GetAttribute('CraxMatchToken'));state:SetAttribute('VeniPoisonKillOwner',attacker.Name)
  end
 end
end
-- Appelé par ArenaMovement quand un combattant touche un mur : Distillation (N2).
function M.WallContact(model,side)
 local r=records[model];if not r or r.level<2 or not enabled(model)then return end
 if not R.DistillArmed(r,C.DistillPoisonLosses,r.time)then return end
 r.poisonLosses=0;r.distillReadyAt=r.time+C.DistillCooldown;r.distillNotified=false
 Heal:Fire(model,C.DistillHeal,'VeniDistill')
 local f=motions[model];emit('Distill',{Owner=model,Side=side,Amount=C.DistillHeal,Position=f and xyz(f,f.position)or nil})
end

function M.Step(dt,fighters,active)
 if state:GetAttribute('Phase')~='Fighting'then if running then M.Reset()end;return end
 if not running or round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 if not active then for m,g in pairs(motions)do previous[m]=g.position end;return end
 for m in pairs(records)do if not enabled(m)then clearOwner(m)end end
 for _,f in ipairs(fighters)do
  local r=enabled(f.model)and get(f.model)
  if r then
   r.level=Skills.Resolve(f.model);f.model:SetAttribute('VeniLevel',r.level)
   if not busy(f.model)then
    r.time+=dt
    if Silence.CanStart(f.model)then
     if r.level>=3 and r.time+1e-8>=r.due.Molt then shedMolt(f,r)
     elseif r.level>=1 and r.time+1e-8>=r.due.Cobra then spitCobra(f,r)end
    end
   end
  end
 end
 stepPoisons(dt)
 for i=#cobras,1,-1 do if not advanceCobra(cobras[i],dt)then emit('CobraEnd',{Id=cobras[i].id});table.remove(cobras,i)end end
 for i=#molts,1,-1 do if not advanceMolt(molts[i],dt)then emit('MoltEnd',{Id=molts[i].id});table.remove(molts,i)end end
 for m,g in pairs(motions)do previous[m]=g.position end
end
return M
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxVeniClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- VeniCrax : présentation seulement (effets, sons, cinématique). Toutes les décisions sont prises par le serveur.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players');local SoundService=game:GetService('SoundService')
local C=require(RS:WaitForChild('CraxVeniConfig'));local Audio=require(RS:WaitForChild('CraxVeniAudio'));local FX=RS:WaitForChild('CraxVeniFX');local state=workspace:WaitForChild('CombatState');local player=Players.LocalPlayer
local low=C.Quality=='Low'or C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local root=Instance.new('Folder');root.Name='VeniCrax_Local';root.Parent=workspace
local VENOM=Color3.fromRGB(150,255,40);local TOXIC=Color3.fromRGB(70,200,60);local DARK=Color3.fromRGB(16,70,28);local GOLD=Color3.fromRGB(246,214,90);local CREAM=Color3.fromRGB(228,206,146)
local SMOKE='rbxasset://textures/particles/smoke_main.dds';local SPARK='rbxasset://textures/particles/sparkles_main.dds'
local auras={};local cobras={};local molts={};local orbs={};local pips={};local pulses={};local scene;local seen;local accumulated=0
local function make(c,p,parent)local o=Instance.new(c);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local f=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=f and id and f:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function world(p)return(frame()*CFrame.new(p)).Position end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function radiusOf(m)local h=head(m);return h and math.max(1,h.Size.Y*.5)or 2 end
local function sound(name,m,loop,finale)return Audio.Play(name,(typeof(m)=='Vector3'and m)or position(m)or Vector3.zero,loop,finale,player:GetAttribute('ArenaSeat')~=nil)end
local function ease(t,a,b)local u=math.clamp((t-a)/(b-a),0,1);return u*u*(3-2*u)end
local function aim(a,b,up)
 local d=b-a;if d.Magnitude<1e-6 then return CFrame.new(a)end;up=up or Vector3.new(0,1,0)
 if up:Cross(d).Magnitude<1e-6 then up=Vector3.new(0,0,1)end;return CFrame.lookAt(a,b,up)
end
local function part(props,parent)
 local p={Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic}
 for k,v in pairs(props)do p[k]=v end;return make('Part',p,parent)
end
local function seq(a,b)return ColorSequence.new(a,b)end
local function nseq(points)local k={};for _,p in ipairs(points)do k[#k+1]=NumberSequenceKeypoint.new(p[1],p[2])end;return NumberSequence.new(k)end
-- Brume toxique (sans bulle qui éclate) : fumée verte douce + petites gouttelettes lumineuses.
local function mist(parent,color,rate,size)
 local a=make('Attachment',{},parent)
 local smoke=make('ParticleEmitter',{Texture=SMOKE,Color=seq(color,DARK),Rate=low and rate*.5 or rate,Lifetime=NumberRange.new(.9,1.6),Speed=NumberRange.new(.6,1.6),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,size*.5},{.5,size},{1,size*1.5}}),Transparency=nseq({{0,1},{.15,.55},{1,1}}),LightEmission=.35,RotSpeed=NumberRange.new(-30,30),Rotation=NumberRange.new(0,360),Acceleration=Vector3.new(0,1.2,0)},a)
 local drops=make('ParticleEmitter',{Texture=SPARK,Color=seq(VENOM,TOXIC),Rate=low and rate*.2 or rate*.4,Lifetime=NumberRange.new(.5,.9),Speed=NumberRange.new(.5,1.5),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,.25},{1,0}}),Transparency=nseq({{0,.1},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,-3,0)},a)
 return a,smoke,drops
end
local function burst(p,color,count,size)
 local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root)
 local a=make('Attachment',{},holder)
 local e=make('ParticleEmitter',{Texture=SPARK,Color=seq(color,TOXIC),Rate=0,Lifetime=NumberRange.new(.35,.7),Speed=NumberRange.new(6,14),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,size or .45},{1,0}}),Transparency=nseq({{0,0},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,-14,0),Drag=3},a)
 local s=make('ParticleEmitter',{Texture=SMOKE,Color=seq(color,DARK),Rate=0,Lifetime=NumberRange.new(.5,.9),Speed=NumberRange.new(1,3),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,.8},{1,2.6}}),Transparency=nseq({{0,.45},{1,1}}),LightEmission=.3},a)
 e:Emit(low and math.ceil(count*.5)or count);s:Emit(low and 3 or 6)
 local light=make('PointLight',{Color=color,Brightness=3,Range=10},holder)
 pulses[#pulses+1]={holder=holder,light=light,born=os.clock()}
end
local function ring(cf,color,radius,width)
 return part({Shape=Enum.PartType.Cylinder,Size=Vector3.new(width or .08,radius*2,radius*2),CFrame=cf*CFrame.Angles(0,math.pi/2,0),Color=color,Material=Enum.Material.Neon,Transparency=.35},root)
end
local function arenaRotation()return frame().Rotation end

-- ===================================================================== cobra (modèle procédural)
local function cobraModel(parent,scale)
 local m=make('Model',{Name='VeniCobra'},parent);local segs={}
 local headPart=part({Name='CobraHead',Shape=Enum.PartType.Ball,Size=Vector3.new(.95,.62,1.25)*scale,Color=DARK,Material=Enum.Material.SmoothPlastic,Reflectance=.08},m)
 local hood=part({Name='CobraHood',Size=Vector3.new(1.7,1.1,.12)*scale,Color=TOXIC,Material=Enum.Material.SmoothPlastic},m)
 make('SpecialMesh',{MeshType=Enum.MeshType.Sphere},hood)
 local eyes={part({Shape=Enum.PartType.Ball,Size=Vector3.one*.16*scale,Color=VENOM,Material=Enum.Material.Neon},m),part({Shape=Enum.PartType.Ball,Size=Vector3.one*.16*scale,Color=VENOM,Material=Enum.Material.Neon},m)}
 local fangs={part({Size=Vector3.new(.06,.28,.06)*scale,Color=VENOM,Material=Enum.Material.Neon},m),part({Size=Vector3.new(.06,.28,.06)*scale,Color=VENOM,Material=Enum.Material.Neon},m)}
 local n=low and 8 or 14
 for i=1,n do local k=1-(i-1)/n;segs[i]=part({Name='CobraBody',Shape=Enum.PartType.Ball,Size=Vector3.one*(.62*k+.18)*scale,Color=i%3==0 and CREAM or DARK,Material=Enum.Material.SmoothPlastic,Reflectance=.06},m)end
 local a0=make('Attachment',{Position=Vector3.new(0,.15,0)*scale},headPart);local a1=make('Attachment',{Position=Vector3.new(0,-.15,0)*scale},headPart)
 make('Trail',{Attachment0=a0,Attachment1=a1,Color=seq(VENOM,TOXIC),Lifetime=.35,LightEmission=.8,Transparency=nseq({{0,.3},{1,1}}),WidthScale=nseq({{0,1},{1,0}})},headPart)
 make('PointLight',{Color=VENOM,Brightness=1.6,Range=7},headPart)
 return{model=m,head=headPart,hood=hood,eyes=eyes,fangs=fangs,segs=segs,scale=scale,history={}}
end
-- Place la tête puis fait suivre le corps le long de l'historique des positions.
local function poseCobra(c,pos,dir,up)
 up=up or arenaRotation().ZVector;local s=c.scale
 local cf=aim(pos,pos+dir,up)
 c.head.CFrame=cf;c.hood.CFrame=cf*CFrame.new(0,0,.45*s)*CFrame.Angles(0,0,0)
 c.eyes[1].CFrame=cf*CFrame.new(-.22*s,.2*s,-.38*s);c.eyes[2].CFrame=cf*CFrame.new(.22*s,.2*s,-.38*s)
 c.fangs[1].CFrame=cf*CFrame.new(-.14*s,-.3*s,-.5*s);c.fangs[2].CFrame=cf*CFrame.new(.14*s,-.3*s,-.5*s)
 table.insert(c.history,1,pos);while #c.history>80 do table.remove(c.history)end
 local spacing=.42*s;local idx=1;local acc=0;local prev=pos
 for i,seg in ipairs(c.segs)do
  local need=spacing*i;local placed=false
  while idx<#c.history do local a,b=c.history[idx],c.history[idx+1];local d=(b-a).Magnitude
   if acc+d>=need then seg.Position=a:Lerp(b,(need-acc)/math.max(d,1e-6));placed=true;break end;acc+=d;idx+=1 end
  if not placed then seg.Position=c.history[#c.history]-dir.Unit*spacing*(i-#c.history+1)end
  prev=seg.Position
 end
end

-- ===================================================================== combat
local function clearAura(target,kind)
 local list=auras[target];if not list then return end
 local a=list[kind];if a then a.holder:Destroy();list[kind]=nil end
 if not next(list)then auras[target]=nil end
end
local function clearCombat()
 for t,list in pairs(auras)do for k in pairs(list)do clearAura(t,k)end end;auras={}
 for _,c in pairs(cobras)do Audio.Stop(c.loop);c.model:Destroy()end;cobras={}
 for _,m in pairs(molts)do Audio.Stop(m.loop);m.folder:Destroy()end;molts={}
 for _,o in pairs(orbs)do o.folder:Destroy()end;orbs={}
 for _,p in pairs(pips)do p.gui:Destroy()end;pips={}
 for _,p in ipairs(pulses)do p.holder:Destroy()end;pulses={}
end
local function clone(m,parent)
 local registry=RS:FindFirstChild('CraxRenderRegistryV82');registry=registry and require(registry)
 local snapshot=registry and registry.Snapshot and registry.Snapshot(m,parent);local copy=snapshot and snapshot.Model
 if not copy then local a=m.Archivable;m.Archivable=true;copy=m:Clone();m.Archivable=a end
 copy.Name=m.Name
 for _,o in ipairs(copy:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 copy.Parent=parent;return copy
end
local function showPips(target,count,needed)
 local h=head(target);if not h then return end
 local p=pips[target];if not p then
  local gui=make('BillboardGui',{Name='VeniBitePips',Size=UDim2.fromOffset(90,26),StudsOffsetWorldSpace=Vector3.new(0,radiusOf(target)+2.4,0),AlwaysOnTop=true,Adornee=h},root)
  p={gui=gui,label=make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=VENOM,TextStrokeColor3=DARK,TextStrokeTransparency=0},gui)};pips[target]=p
 end
 p.label.Text=string.rep('◆',count)..string.rep('◇',math.max(0,needed-count));p.born=os.clock()
end

local function onEvent(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner
 if k=='Clear'then clearCombat();return end
 if k=='OwnerClear'then for id,c in pairs(cobras)do if c.owner==m then Audio.Stop(c.loop);c.model:Destroy();cobras[id]=nil end end;if orbs[m]then orbs[m].folder:Destroy();orbs[m]=nil end;return end
 if k=='Poison'then
  local t=d.Target;local h=head(t);if not h then return end
  local list=auras[t]or{};auras[t]=list;if list[d.Kind]then list[d.Kind].holder:Destroy()end
  local holder=part({Name='VeniPoisonAura',Size=Vector3.one*.1,Transparency=1},root)
  local color=d.Kind=='Cobra'and Color3.fromRGB(205,255,60)or VENOM
  local _,smoke=mist(holder,color,22,radiusOf(t)*.9)
  local light=make('PointLight',{Color=color,Brightness=1.4,Range=radiusOf(t)*3.5},holder)
  list[d.Kind]={holder=holder,target=t,smoke=smoke,light=light,born=os.clock()}
  burst(position(t),color,18);sound(d.Kind=='Cobra'and'CobraImpact'or'Bite',t)
 elseif k=='PoisonEnd'then clearAura(d.Target,d.Kind)
 elseif k=='PoisonTick'then local p=position(d.Target);if p then burst(p+Vector3.new(0,radiusOf(d.Target)*.4,0),VENOM,low and 4 or 8,.3);sound('PoisonTick',d.Target)end
 elseif k=='BiteStack'then
  showPips(d.Target,d.Count,d.Needed)
  local a,b=position(m),position(d.Target);if a and b then local p=a:Lerp(b,.5);burst(p,VENOM,6,.3)end
  if d.Count<d.Needed then sound('BiteStack',d.Target)end
 elseif k=='Cobra'then
  if cobras[d.Id]then cobras[d.Id].model:Destroy()end
  local c=cobraModel(root,1.15);c.owner=m;c.from=world(d.Position);c.position=c.from;c.at=os.clock();c.direction=frame():VectorToWorldSpace(d.Direction)
  poseCobra(c,c.position,c.direction);cobras[d.Id]=c;sound('Spit',m);c.loop=sound('CobraLoop',m,true)
  local p=position(m);if p then burst(p+c.direction*radiusOf(m),VENOM,14,.4)end
 elseif k=='CobraState'then local c=cobras[d.Id];if c then c.from=c.display or c.position;c.position=world(d.Position);c.direction=frame():VectorToWorldSpace(d.Direction);c.at=os.clock()end
 elseif k=='CobraBounce'then local p=world(d.Position);burst(p,VENOM,16,.5);sound('Bounce',p);local c=cobras[d.Id];if c then Audio.Move(c.loop,p)end
 elseif k=='CobraImpact'then local p=world(d.Position);burst(p,Color3.fromRGB(205,255,60),26,.55);sound('CobraImpact',p)
  local c=cobras[d.Id];if c then Audio.Stop(c.loop);c.model:Destroy();cobras[d.Id]=nil end
 elseif k=='CobraEnd'then local c=cobras[d.Id];if c then Audio.Stop(c.loop);burst(c.display or c.position,TOXIC,8,.35);c.model:Destroy();cobras[d.Id]=nil end
 elseif k=='DistillReady'then
  if orbs[m]then orbs[m].folder:Destroy()end
  local folder=make('Folder',{Name='VeniDistillOrbs'},root);local list={}
  for i=1,3 do list[i]=part({Shape=Enum.PartType.Ball,Size=Vector3.one*.42,Color=VENOM,Material=Enum.Material.Neon},folder);make('PointLight',{Color=VENOM,Brightness=1,Range=4},list[i])end
  orbs[m]={folder=folder,list=list,born=os.clock()};sound('DistillReady',m)
 elseif k=='Distill'then
  if orbs[m]then orbs[m].folder:Destroy();orbs[m]=nil end
  local p=position(m);if p then
   local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root);local a=make('Attachment',{},holder)
   local e=make('ParticleEmitter',{Texture=SPARK,Color=seq(VENOM,GOLD),Rate=0,Lifetime=NumberRange.new(.8,1.3),Speed=NumberRange.new(3,6),SpreadAngle=Vector2.new(25,25),EmissionDirection=Enum.NormalId.Top,Size=nseq({{0,.5},{1,0}}),Transparency=nseq({{0,0},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,4,0)},a)
   e:Emit(low and 20 or 40);local light=make('PointLight',{Color=GOLD,Brightness=4,Range=12},holder)
   local halo=ring(CFrame.new(p)*arenaRotation(),GOLD,radiusOf(m)*1.2,.06)
   pulses[#pulses+1]={holder=holder,light=light,born=os.clock(),halo=halo,haloRadius=radiusOf(m)*1.2}
  end
  sound('Distill',m)
 elseif k=='Molt'then
  if molts[d.Id]then molts[d.Id].folder:Destroy()end
  local folder=make('Folder',{Name='VeniMolt'},root);local r={folder=folder,owner=m,born=os.clock(),life=d.Life,position=world(d.Position)}
  if m and m.Parent then
   local ghost=clone(m,folder);ghost:PivotTo(CFrame.new(r.position)*(m:GetPivot().Rotation))
   for _,o in ipairs(ghost:GetDescendants())do if o:IsA('BasePart')then o.Material=Enum.Material.Glass;o.Color=Color3.fromRGB(190,255,170);o.Transparency=math.max(o.Transparency,.55);o.Reflectance=.2 end end
   r.ghost=ghost
  end
  local a,smoke=mist(part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(r.position)},folder),TOXIC,6,1.4);r.smoke=smoke
  r.loop=sound('MoltIdle',r.position,true);sound('MoltShed',m);molts[d.Id]=r
 elseif k=='MoltTrigger'then
  local r=molts[d.Id];local p=world(d.Position)
  if r then r.trigger=os.clock();r.delay=d.Delay;r.radius=d.Radius;r.ring=ring(CFrame.new(p)*arenaRotation(),VENOM,.5,.1);r.inner=ring(CFrame.new(p)*arenaRotation(),Color3.fromRGB(230,255,120),.3,.06)end
  sound('MoltWarn',p)
 elseif k=='MoltCloud'then
  local p=world(d.Position);local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root);local a=make('Attachment',{},holder)
  local e=make('ParticleEmitter',{Texture=SMOKE,Color=seq(VENOM,DARK),Rate=0,Lifetime=NumberRange.new(1.2,2),Speed=NumberRange.new(d.Radius*1.2,d.Radius*2.2),Drag=4,SpreadAngle=Vector2.new(180,180),Size=nseq({{0,2},{.4,d.Radius*.9},{1,d.Radius*1.2}}),Transparency=nseq({{0,.35},{.6,.6},{1,1}}),LightEmission=.4,RotSpeed=NumberRange.new(-40,40),Rotation=NumberRange.new(0,360)},a)
  e:Emit(low and 18 or 36)
  local sphere=part({Shape=Enum.PartType.Ball,Size=Vector3.one*.5,CFrame=CFrame.new(p),Color=VENOM,Material=Enum.Material.ForceField,Transparency=.2},holder)
  pulses[#pulses+1]={holder=holder,light=make('PointLight',{Color=VENOM,Brightness=4,Range=d.Radius*3},holder),born=os.clock(),sphere=sphere,radius=d.Radius,life=1.6}
  local r=molts[d.Id];if r then if r.ring then r.ring:Destroy();r.inner:Destroy();r.ring=nil end;if r.ghost then r.ghost:Destroy();r.ghost=nil end end
  sound('Cloud',p)
 elseif k=='MoltEnd'then local r=molts[d.Id];if r then Audio.Stop(r.loop);r.dying=os.clock();r.smoke.Enabled=false;if r.ring then r.ring:Destroy();r.inner:Destroy();r.ring=nil end end
 end
end
FX.OnClientEvent:Connect(onEvent)

Run.Heartbeat:Connect(function(dt)
 accumulated+=dt;if accumulated<(low and 1/24 or 1/45)then return end;local step=accumulated;accumulated=0
 local now=os.clock()
 for t,list in pairs(auras)do local p=position(t);for k,a in pairs(list)do if not p or not t.Parent then clearAura(t,k)else a.holder.CFrame=CFrame.new(p);a.light.Brightness=1.1+.5*math.sin(now*6)end end end
 for id,c in pairs(cobras)do
  if not c.owner or not c.owner.Parent or now-c.at>1 then Audio.Stop(c.loop);c.model:Destroy();cobras[id]=nil
  else c.display=c.from:Lerp(c.position,math.clamp((now-c.at)/.05,0,1));local wiggle=arenaRotation().UpVector:Cross(c.direction).Unit*math.sin(now*22)*.18
   poseCobra(c,c.display+wiggle,c.direction);Audio.Move(c.loop,c.display)end
 end
 for m,o in pairs(orbs)do local p=position(m);if not p then o.folder:Destroy();orbs[m]=nil else local r=radiusOf(m)*1.35
  for i,b in ipairs(o.list)do local a=now*2.4+i*math.pi*2/3;b.CFrame=CFrame.new(p)*arenaRotation()*CFrame.new(math.cos(a)*r,math.sin(a)*r*.6+.4,0)end end end
 for t,p in pairs(pips)do if now-p.born>1.6 or not t.Parent then p.gui:Destroy();pips[t]=nil end end
 for id,r in pairs(molts)do
  local age=now-r.born
  if r.ghost then local fade=math.clamp(age/(r.life or 8),0,1);for _,o in ipairs(r.ghost:GetDescendants())do if o:IsA('BasePart')then o.LocalTransparencyModifier=fade*.6 end end end
  if r.ring then local u=math.clamp((now-r.trigger)/math.max(r.delay,.05),0,1);local rad=.5+(r.radius-.5)*u;local pulse=.25+.2*math.sin(now*30)
   r.ring.Size=Vector3.new(.1,rad*2,rad*2);r.ring.Transparency=pulse;r.inner.Size=Vector3.new(.06,rad*1.4,rad*1.4)end
  if r.dying and now-r.dying>1.2 then r.folder:Destroy();molts[id]=nil elseif age>(r.life or 8)+3 then Audio.Stop(r.loop);r.folder:Destroy();molts[id]=nil end
 end
 for i=#pulses,1,-1 do local p=pulses[i];local age=now-p.born;local life=p.life or .8
  if age>=life+.6 then p.holder:Destroy();if p.halo then p.halo:Destroy()end;table.remove(pulses,i)
  else p.b0=p.b0 or p.light.Brightness;p.light.Brightness=p.b0*(1-math.clamp(age/life,0,1))
   if p.sphere then local u=ease(age,0,.45);p.sphere.Size=Vector3.one*(p.radius*2*u+.5);p.sphere.Transparency=.2+.8*ease(age,.5,life)end
   if p.halo then local u=ease(age,0,.6);p.halo.Size=Vector3.new(.06,p.haloRadius*2*(1+u),p.haloRadius*2*(1+u));p.halo.Transparency=.3+.7*u end
  end
 end
end)

-- ===================================================================== exécution MAX : « Animation 3 »
local function duck(s,winner,loser)
 s.ducked={};local group=SoundService:FindFirstChild('CraxMusicControl')
 if group and group:IsA('SoundGroup')then s.equalizer=make('EqualizerSoundEffect',{Name='VeniFinaleDuck',HighGain=-80,MidGain=-80,LowGain=-80},group)end
 local function candidate(o)
  if not o:IsA('Sound')then return end;local parent=o.Parent;local scoped=false
  while parent and parent~=workspace do if parent==winner or parent==loser then scoped=true;break end;parent=parent.Parent end
  if not scoped or s.ducked[o]then return end;s.ducked[o]=o.Volume;o.Volume=0
 end
 for _,o in ipairs(workspace:GetDescendants())do candidate(o)end;s.soundAdded=workspace.DescendantAdded:Connect(candidate)
end
local function hideActor(s,model)
 for _,o in ipairs(model:GetDescendants())do
  if s.hidden[o]==nil then
   if o:IsA('BasePart')then s.hidden[o]=o.LocalTransparencyModifier;o.LocalTransparencyModifier=1
   elseif o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then s.hidden[o]=o.Enabled;o.Enabled=false end
  end
 end
end
local function alpha(model,value)for _,o in ipairs(model:GetDescendants())do if o:IsA('BasePart')then o.LocalTransparencyModifier=math.clamp(value,0,1)end end end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('VeniFinaleCamera')
 if s.soundAdded then s.soundAdded:Disconnect()end;for o,v in pairs(s.ducked or{})do if o.Parent then o.Volume=v end end;if s.equalizer then s.equalizer:Destroy()end
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('VeniCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='VeniFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local h=player.Character and player.Character:FindFirstChild('HumanoidRootPart');local p=position(winner);if not h or not p or(h.Position-p).Magnitude>180 then return end end
 local started=state:GetAttribute('RoundVictoryStartedAt');if type(started)~='number'or workspace:GetServerTimeNow()-started>=C.FinaleDuration then return end
 local wh,lh=head(winner),head(loser);if not wh or not lh then return end
 clearCombat();Audio.Clear();seen=tostring(token)..':'..round
 local s={folder=make('Folder',{Name='VeniFinale'},root),hidden={},saved={},camera=cam,start=started,previous=player:GetAttribute('VeniCameraOwner'),cues={}}
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 local r=math.max(1,wh.Size.Y*.5,lh.Size.Y*.5)
 local stage=lh.Position;local L,Rt,T,B=workspace:FindFirstChild('Arenaleft'),workspace:FindFirstChild('ArenaRight'),workspace:FindFirstChild('ArenaTop'),workspace:FindFirstChild('Arenabottom')
 if L and Rt and T and B then stage=Vector3.new((L.Position.X+Rt.Position.X)*.5,(T.Position.Y+B.Position.Y)*.5,lh.Position.Z)end
 local basis=frame().Rotation;local center=frame()*CFrame.new(stage)*CFrame.new(0,0,-r*6)
 s.backdrop=part({Name='VeniCinemaBackdrop',Size=Vector3.new(r*36,r*60,.1),CFrame=center*CFrame.new(0,0,r*5),Color=Color3.fromRGB(4,14,7)},s.folder)
 s.wall=part({Name='VeniRicochetWall',Size=Vector3.new(r*.35,r*7,r*2),CFrame=center*CFrame.new(r*5.2,r*1.5,0),Color=Color3.fromRGB(30,60,36),Material=Enum.Material.Slate},s.folder)
 s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder)
 local heroHead=s.hero:FindFirstChild('Head',true);local victimHead=s.victim:FindFirstChild('Head',true)
 local heroOffset=heroHead and s.hero:GetPivot():ToObjectSpace(heroHead.CFrame)or CFrame.identity
 local victimOffset=victimHead and s.victim:GetPivot():ToObjectSpace(victimHead.CFrame)or CFrame.identity
 local wr,lr=wh.CFrame.Rotation,lh.CFrame.Rotation
 s.cobra=cobraModel(s.folder,r*.62)
 -- Fissures vertes : segments néon posés sur la face visible de la victime.
 s.cracks={};local n=low and 12 or 22
 for i=1,n do
  local ang=i*2.399963;local zz=1-2*(i-.5)/n;local rad=math.sqrt(math.max(0,1-zz*zz))
  local dir=Vector3.new(math.cos(ang)*rad,zz,-math.abs(math.sin(ang*1.7))*.6-.4).Unit
  s.cracks[i]={part=part({Name='VeniCrack',Size=Vector3.new(r*.05,r*.05,r*(.35+(i%4)*.12)),Color=VENOM,Material=Enum.Material.Neon,Transparency=1},s.folder),dir=dir,tilt=(i%7)*.9,at=5.9+(i/n)*.8}
 end
 -- Éclats de vinyle façon figurine : couleurs réelles de la victime, matière lisse et brillante.
 local palette={};for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.95 then palette[#palette+1]=p.Color end end;if #palette==0 then palette[1]=Color3.new(1,1,1)end
 s.debris={};local count=low and 20 or 40
 for i=1,count do
  local ang=i*2.399963;local zz=1-2*(i-.5)/count;local rad=math.sqrt(math.max(0,1-zz*zz));local dir=Vector3.new(math.cos(ang)*rad,math.sin(ang)*rad,zz*.45)
  s.debris[i]={part=make(i%2==0 and'WedgePart'or'Part',{Name='VeniVinylShard',Size=Vector3.new(.2+(i%3)*.07,.28,.1+(i%4)*.05)*r,Color=palette[(i-1)%#palette+1],Material=Enum.Material.SmoothPlastic,Reflectance=.12,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},s.folder),dir=dir,offset=dir*r*(.4+(i%5)*.1),spin=Vector3.new(i%4+1,i%3+1,i%5+1)}
 end
 s.gui=make('ScreenGui',{Name='VeniExecutionCinema',IgnoreGuiInset=true,ResetOnSpawn=false},player:WaitForChild('PlayerGui'))
 s.top=make('Frame',{Size=UDim2.fromScale(1,.08),BackgroundColor3=Color3.fromRGB(3,10,5),BorderSizePixel=0},s.gui)
 s.bottom=make('Frame',{Size=UDim2.fromScale(1,.08),Position=UDim2.fromScale(0,.92),BackgroundColor3=Color3.fromRGB(3,10,5),BorderSizePixel=0},s.gui)
 s.title=make('TextLabel',{Size=UDim2.fromScale(.8,.07),Position=UDim2.fromScale(.1,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=VENOM,TextStrokeColor3=DARK,TextStrokeTransparency=0,Font=Enum.Font.GothamBlack,TextScaled=true,TextTransparency=1},s.gui)
 s.mist=mist(part({Size=Vector3.one*.1,Transparency=1,CFrame=center},s.folder),VENOM,0,r*.8)
 hideActor(s,winner);hideActor(s,loser);duck(s,winner,loser);scene=s;player:SetAttribute('VeniCameraOwner',seen)
 local heroPos=(center*CFrame.new(-r*3.2,0,0)).Position;local victimPos=center.Position;local wallHit=(center*CFrame.new(r*5,r*2.6,0)).Position
 local function cobraAt(t)
  -- 0,6–1,6 : crachat vers le mur ; 1,6–2,4 : ricochet vers la victime ; 2,4–4,4 : deux tours autour de la tête ;
  -- 4,4–5,2 : pause ; 5,2–5,9 : resserrement ; ensuite le cobra reste serré jusqu'à l'éclatement.
  local mouth=heroPos+basis.XVector*r*.9+basis.YVector*(-r*.3)
  if t<1.6 then local u=ease(t,.6,1.6);return mouth:Lerp(wallHit,u)+basis.YVector*math.sin(u*math.pi)*r*.6,(wallHit-mouth).Unit
  elseif t<2.4 then local u=ease(t,1.6,2.4);local target=victimPos+basis.YVector*r*1.25;return wallHit:Lerp(target,u),(target-wallHit).Unit
  end
  local coil=ease(t,2.4,4.4);local tight=ease(t,5.2,5.9);local a=coil*math.pi*4+math.pi/2
  local radius=r*(1.32-.3*tight);local y=r*(.55-1.1*coil)
  local p=victimPos+basis.XVector*math.cos(a)*radius+basis.YVector*y+basis.ZVector*(-math.sin(a)*radius)
  local tangent=basis.XVector*-math.sin(a)+basis.ZVector*-math.cos(a)-basis.YVector*.18
  return p,tangent.Unit
 end
 Run:BindToRenderStep('VeniFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  t=math.max(0,t)
  local rear=ease(t,0,.55)*(1-ease(t,.6,.8));local shattered=t>=6.8;local tight=ease(t,5.2,5.9);local closing=ease(t,7.6,8.6)
  -- Héros : se cabre avant de cracher, puis se tourne vers la caméra à la fin.
  s.hero:PivotTo(CFrame.new(heroPos+basis.YVector*r*.25*rear)*wr*CFrame.Angles(-.25*rear,0,0)*heroOffset:Inverse())
  -- Victime : immobile, comprimée au resserrement, tremble pendant les fissures.
  local shake=(t>5.9 and t<6.8)and math.sin(t*90)*r*.03 or 0
  s.victim:PivotTo(CFrame.new(victimPos+basis.XVector*shake)*lr*victimOffset:Inverse())
  alpha(s.victim,shattered and 1 or 0)
  -- Cobra.
  local cp,cd=cobraAt(t);local visible=t>=.6 and t<6.8
  alpha(s.cobra.model,visible and 0 or 1)
  if visible then poseCobra(s.cobra,cp,cd,basis.YVector)end
  if t>=4.4 and t<5.2 then s.cobra.head.CFrame=aim(cp,(s.camera.CFrame.Position),basis.YVector);s.cobra.hood.Size=Vector3.new(1.7+.8*ease(t,4.4,4.8),1.1+.4*ease(t,4.4,4.8),.12)*s.cobra.scale;s.cobra.hood.CFrame=s.cobra.head.CFrame*CFrame.new(0,0,.45*s.cobra.scale)end
  -- Fissures puis éclatement.
  for _,c in ipairs(s.cracks)do
   local u=ease(t,c.at,c.at+.25);local p=victimPos+(basis:VectorToWorldSpace(c.dir))*r*1.01
   c.part.CFrame=aim(p,p+basis:VectorToWorldSpace(c.dir),basis.YVector)*CFrame.Angles(0,0,c.tilt)*CFrame.new(0,0,0)*CFrame.Angles(0,math.pi/2,0)
   c.part.Transparency=shattered and 1 or 1-u
  end
  local flight=math.max(0,t-6.8)
  for _,d in ipairs(s.debris)do
   local off=d.offset+d.dir*(r*flight*4)+Vector3.new(0,-r*.9*flight*flight,0)
   d.part.CFrame=CFrame.new(victimPos+basis:VectorToWorldSpace(off))*CFrame.Angles(flight*d.spin.X,flight*d.spin.Y,flight*d.spin.Z)
   d.part.Transparency=shattered and ease(t,7.8,8.9)or 1
  end
  if shattered and not s.burst then s.burst=true;burst(victimPos,VENOM,low and 30 or 60,r*.25)end
  s.title.TextTransparency=1-ease(t,7.2,7.6)*(1-ease(t,9,C.FinaleDuration))
  local bars=1-ease(t,0,.45)*(1-ease(t,C.FinaleDuration-.8,C.FinaleDuration));s.top.BackgroundTransparency=bars;s.bottom.BackgroundTransparency=bars
  for _,cue in ipairs({{0,'MaxHiss'},{.6,'MaxSpit'},{1.6,'MaxBounce'},{2.4,'MaxCoil'},{4.4,'MaxHiss'},{5.2,'MaxSqueeze'},{5.9,'MaxCrack'},{6.8,'MaxShatter'},{7.4,'MaxSting'}})do
   local key=tostring(cue[1])..cue[2];if t>=cue[1]and not s.cues[key]then s.cues[key]=true;if t-cue[1]<.35 then sound(cue[2],victimPos,false,true)end end
  end
  -- Caméra : plan large (héros + mur + victime), gros plan sur l'étreinte, puis retour sur VeniCrax.
  local wide=1-ease(t,2.2,2.9);local hero=closing
  local focus=(victimPos:Lerp((heroPos+wallHit)*.5,wide*.6)):Lerp(heroPos,hero)+basis.YVector*r*.2
  local half=r*(1.9+3.6*wide)*(1-.25*hero)
  local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local fov=42
  local distance=math.max(half,half*1.3/math.max(.2,aspect))/math.tan(math.rad(fov*.5))
  local orbit=(1-wide)*(1-hero)*math.sin(t*.6)*.35
  local offset=basis:VectorToWorldSpace(Vector3.new(math.sin(orbit)*distance,r*.25,-math.cos(orbit)*distance))
  local kick=t>=6.8 and math.max(0,1-(t-6.8)/.25)*r*.05 or 0
  local wanted=aim(focus+offset,focus,basis.YVector)*CFrame.new(math.sin(t*83)*kick,math.cos(t*71)*kick,0)
  if hero>0 then s.hero:PivotTo(CFrame.new(heroPos):Lerp(aim(heroPos,wanted.Position,basis.YVector),hero)*heroOffset:Inverse())end
  local back=ease(t,C.FinaleDuration-.8,C.FinaleDuration);s.backdrop.Transparency=back;s.wall.Transparency=back
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=fov+(s.saved.FieldOfView-fov)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
 end)
end
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do state:GetAttributeChangedSignal(key):Connect(function()task.defer(beginScene)end)end
state:GetAttributeChangedSignal('Phase'):Connect(function()if state:GetAttribute('Phase')=='Fighting'then stopScene()end end)
task.defer(beginScene)
]====]}}
local expected={[====[V_HelmetShell]====],[====[V_HelmetInner]====],[====[V_HelmetCrest]====],[====[V_HelmetBrow]====],[====[V_VenomVeins]====],[====[V_Fangs]====],[====[V_FangsCore]====],[====[V_VenomDrops]====],[====[V_FitOrigin]====],[====[V_FitUp]====],[====[V_FitFront]====]}
local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('VeniOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde VeniCrax incomplète ou étrangère : lancer RETOUR_ARRIERE_VENICRAX.lua ou l’inspecter')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source modifiée après installation : '..e:GetAttribute('Path'))end
 print('VeniCrax déjà installé et vérifié : aucun doublon.');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ReplicatedStorage.CraxSilenceGate']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.CraxDeadlyRuntime']='ModuleScript',['ServerScriptService.CraxPolariRuntime']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do
 local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)
end
local plan={};local marker='-- VeniCraxIntegrationV1'
local function count(s,n)local total,p=0,1;while true do local a,b=s:find(n,p,true);if not a then return total end;total+=1;p=b+1 end end
for _,op in ipairs(ops)do
 local o=assert(resolve(op.path),'Source manquante : '..op.path);assert(o:IsA('LuaSourceContainer'),'Type de source incorrect : '..op.path)
 local before=read(o);assert(not before:find(marker,1,true),'Déjà modifié sans sauvegarde : '..op.path);local after=before
 if op.kind=='wrap'then after=marker..'\nlocal data=(function()\n'..before..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,r in ipairs(op.replacements)do assert(count(after,r.before)==1,'Source actuelle non reconnue : '..op.path..' (place différente de copie jeu mardi ?). Aucun fichier modifié.');local a,b=after:find(r.before,1,true);after=after:sub(1,a-1)..r.after..after:sub(b+1)end
  after=marker..'\n'..(op.prepend or'')..after
 end
 plan[#plan+1]={path=op.path,object=o,before=before,after=after}
end
for _,m in ipairs(modules)do assert(not resolve(m.path),'Nom déjà utilisé : '..m.path)end
for _,n in ipairs({'CraxVeniFX','CraxVeniImportedAssets','CraxVeniUserAssets'})do assert(not RS:FindFirstChild(n),'Nom déjà utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'),'ServerStorage.CraxTemplates absent');local base=assert(templates:FindFirstChild('Crax_Monster'),'Gabarit Crax_Monster absent');local previews=assert(RS:FindFirstChild('CraxPreviews'),'ReplicatedStorage.CraxPreviews absent')
assert(not templates:FindFirstChild('Crax_Veni')and not previews:FindFirstChild('Crax_Veni'),'Gabarit ou aperçu Crax_Veni déjà présent')
local imported=assert(SS:FindFirstChild('VeniCrax_Import'),'Importer VeniCrax_ACCESSOIRES_IMPORT.fbx, le placer dans ServerStorage et le renommer VeniCrax_Import.')
assert(imported:IsA('Model')or imported:IsA('Folder'),'VeniCrax_Import doit être un Model ou un Folder');local found={};local parts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans l’import')
 if p:IsA('BasePart')then assert(not found[p.Name],'Pièce en double : '..p.Name);found[p.Name]=p;parts+=1
  assert(p:IsA('MeshPart'),'MeshPart attendue : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)
 end
end
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante dans l’import : '..n)end
assert(parts==#expected,'Import avec des pièces en trop : vérifier VeniCrax_Import')
local c,f,u=found.V_FitOrigin.Position,found.V_FitFront.Position,found.V_FitUp.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères V_Fit invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('VeniOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('VeniOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxVeniFX';event.Parent=RS
 local user=register(Instance.new('Folder'));user.Name='CraxVeniUserAssets';user.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxVeniImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxVeniAppearance)
 local template=register(base:Clone());template.Name='Crax_Veni';appearance.Apply(template,assets);template:SetAttribute('AbilityId','VeniBite');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Veni';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('VeniRevision',1);backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : retour bloqué par une édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation VeniCrax arrêtée : '..tostring(err))
end
print('VeniCrax installé : 7 modules, 12 raccordements, gabarit et aperçu créés, sauvegarde ServerStorage.'..backupName..'. Enregistrer, puis lancer BRANCHER_SONS_ET_TEXTURES.lua avec tes IDs, puis un NOUVEAU Play.')
end
