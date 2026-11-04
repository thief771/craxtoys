-- LUCKYCRAX. STOP. ServerStorage.LuckyCrax_Import doit contenir la bibliothèque FBX publiée.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local ops={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[assert(not data.Crax_Lucky,'LuckyCrax existe déjà');local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local base=assert(data.Crax_Monster);local rare=assert(data.Crax_Spidey)
data.Crax_Lucky={DisplayName='LuckyCrax',Rarity=rare.Rarity,RarityColor=rare.RarityColor,TemplateName='Crax_Lucky',MaxHealth=105,CollisionDamage=8,Speed=base.Speed,Description='Tête de vinyle blanche, grand sourire et dents dorées du vrai CraxSourire.',PowerDescription='PILE OU FACE : tir direct 12 dégâts ou tir à deux rebonds 16 dégâts. Tirage serveur toutes les 6 à 9 secondes actives ; les pièces ne donnent pas de monnaie.',Effects={'LuckyCheat'},Ability={Id='LuckyCoin',DisplayName='PILE OU FACE',Damage=8,Cooldown=6}}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local price=assert(data.Crax_Spidey).Upgrades
local list={{Id='LuckyDice',Name='DÉS PIPÉS',Description='Prototype : toutes les 12–16 s, deux dés indépendants de 1 à 6. Zone de rayon 5 ; 2 × somme, +8 sur un double. Une seule application par ennemi.'},{Id='LuckyClover',Name='PORTE-BONHEUR',Description='Prototype : après trois attaques distinctes ayant retiré des PV, prépare une esquive pour le prochain coup admissible. Une charge, durée 4 s. Le troisième coup est subi.'},{Id='LuckyJackpot',Name='JACKPOT',Description='Trois colonnes, exactement trois signes et toujours un triplet gagnant : soin nominal 25 plafonné à 105, six pièces à 5 dégâts vivant 4 s, ou Triche 7 s. Prototype : 45/45/10 %, délai 18–24 s.'},{Id='LuckyFinale',Name=C.MaxTitle,TrophyId=C.TrophyId,Description='Proposition MAX : LE GROS LOT. Scène de casino, vraie victime, combinaison gagnante et pluie de pièces purement cosmétiques. Aucun gain réel.'}}
for i,u in ipairs(list)do u.Coins=assert(price[i].Coins);u.Gems=assert(price[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Lucky={Order=order+1,AbilityId='LuckyCoin',DisplayName='LuckyCrax',Enabled=true,Upgrades=list,Finale=list[4]}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[data.LuckyCheat={DisplayName='TRICHE',Description='Compétences interrompues et bloquées pendant 7 secondes actives ; déplacement et mêlée ordinaires conservés.',Duration=7,Icon='LuckyCheat',Image='',Color=Color3.fromRGB(168,90,225)}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxVictoryCatalog]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);data.Crax_Lucky={Id='LuckyFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(255,211,87),MinimumLevel=4,IntroDuration=0,Duration=C.Finale.End,ZoomDuration=0,HoldDuration=0}]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxRouletteConfig]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local entries,total={},0
for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Lucky');if cat[e.Id].Rarity==cat.Crax_Lucky.Rarity then entries[#entries+1]=e;total+=e.Weight end end
assert(#entries>0 and total>0);local weight=total/(#entries+1);for _,e in ipairs(entries)do e.Weight=weight end;data.Pool[#data.Pool+1]={Id='Crax_Lucky',Weight=total-weight*#entries} -- prototype: equal redistribution of unchanged Rare mass
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxSkinServer]====],[ [====[kind]====] ]=[====[wrap]====],[ [====[addition]====] ]=[====[local appearance=require(game:GetService('ReplicatedStorage').CraxLuckyAppearance);local apply=data.Apply
function data.Apply(model,id,c)appearance.Restore(model);apply(model,id,c);if id=='Crax_Lucky'then appearance.Apply(model)end end]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSilenceGate]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[model:GetAttribute('InvertedSilenced')~=true]====],[ [====[after]====] ]=[====[model:GetAttribute('InvertedSilenced')~=true and model:GetAttribute('LuckyTricked')~=true]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.ArenaMovement]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local LuckyV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxLuckyRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[ SymV1.Begin(fighters)]====],[ [====[after]====] ]=[====[ SymV1.Begin(fighters)
 LuckyV1.Begin(fighters)]====]},{[ [====[before]====] ]=[====[  SymV1.Step(step*Deadly.CinematicScale()]====],[ [====[after]====] ]=[====[  LuckyV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  if LuckyV1.ClearWebs then clearWebs();LuckyV1.ClearWebs=false end
  SymV1.Step(step*Deadly.CinematicScale()]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CombatHealth]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local LuckyV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxLuckyRuntime'))
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function(attacker,defender,damage,collision,kind,recoilSnapshot)]====],[ [====[after]====] ]=[====[function(attacker,defender,damage,collision,kind,recoilSnapshot,attackId)]====]},{[ [====[before]====] ]=[====[local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end]====],[ [====[after]====] ]=[====[local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end
 if attacker:GetAttribute('LuckyTricked')and not collision then return end
 attackId=LuckyV1.AttackId(attacker,kind,attackId)]====]},{[ [====[before]====] ]=[====[local function protected(model)]====],[ [====[after]====] ]=[====[local function protected(model)
 if model:GetAttribute("LuckyTricked")then return false end]====]},{[ [====[before]====] ]=[====[local function adjust(model,amount,kind)]====],[ [====[after]====] ]=[====[local function adjust(model,amount,kind)
 if model:GetAttribute("LuckyTricked")then return amount end]====]},{[ [====[before]====] ]=[====[amount=Golden.Outgoing(attacker,amount)]====],[ [====[after]====] ]=[====[amount=Golden.Outgoing(attacker,amount)
 if collision and attacker:GetAttribute("LuckyTricked")then amount=require(game:GetService("ReplicatedStorage").CraxCatalog)[attacker:GetAttribute("CraxId")].CollisionDamage end]====]},{[ [====[before]====] ]=[====[ local incoming=collision and finite(recoil)]====],[ [====[after]====] ]=[====[ if collision and defender:GetAttribute('LuckyTricked')then recoil=require(game:GetService('ReplicatedStorage').CraxCatalog)[defender:GetAttribute('CraxId')].CollisionDamage end
 local incoming=collision and finite(recoil)]====]},{[ [====[before]====] ]=[====[ if amount>0 and amount>=b.health]====],[ [====[after]====] ]=[====[ local luckyDef=LuckyV1.Dodge(defender,amount,attacker,kind,attackId);local luckyAtk=collision and LuckyV1.Dodge(attacker,incoming,defender,'Collision',nil)
 if luckyDef then amount=0 end;if luckyAtk then incoming=0 end
 if amount>0 and amount>=b.health]====]},{[ [====[before]====] ]=[====[local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)]====],[ [====[after]====] ]=[====[if luckyDef then amount=0 end;if luckyAtk then incoming=0 end
 local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)]====]},{[ [====[before]====] ]=[====[Fleau.CommitContact(attacker,defender,fleauAttackMode);Fleau.CommitContact(defender,attacker,fleauRecoilMode)]====],[ [====[after]====] ]=[====[if not luckyDef then Fleau.CommitContact(attacker,defender,fleauAttackMode)end;if not luckyAtk then Fleau.CommitContact(defender,attacker,fleauRecoilMode)end ]====]},{[ [====[before]====] ]=[====[SymV1.Confirm(attacker,defender,lost,attackerLost,collision);]====],[ [====[after]====] ]=[====[LuckyV1.Confirm(attacker,defender,lost,attackerLost,collision,kind,attackId);SymV1.Confirm(attacker,defender,lost,attackerLost,collision);]====]},{[ [====[before]====] ]=[====[SymV1.Healed(model,r.health-before)]====],[ [====[after]====] ]=[====[LuckyV1.Healed(model,r.health-before);SymV1.Healed(model,r.health-before)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.RoundManager]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[state:SetAttribute("RoundVictoryStartedAt",start)]====],[ [====[after]====] ]=[====[if model and model:GetAttribute('CraxId')=='Crax_Lucky'then state:SetAttribute('LuckyVictoryMatch',state:GetAttribute('CraxMatchToken'))end
 state:SetAttribute("RoundVictoryStartedAt",start)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxSuperRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[
return M
]====],[ [====[after]====] ]=[====[
function M.LuckyAttackId(m,kind)local r=records[m];return r and r.cast and r.cast.id end
function M.CancelLucky(m)
 local r=records[m];if r then r.lastStandSpent=r.lastStand or r.lastStandSpent;r.lastStand=false;r.mode=nil;r.age=0;r.cast=nil;r.nextDash=r.time+rand(C.DashWait[1],C.DashWait[2]);r.nextLaser=r.time+rand(C.LaserWait[1],C.LaserWait[2]);r.ready={};r.contacts=0;setMode(m,r);crystals[m]=nil
 for target,group in pairs(freezes)do if group[m]then releaseFreeze(target,m)end end;emit('OwnerClear',{Owner=m}) end
end
return M
]====]},{[ [====[before]====] ]=[====[if r.mode=='Dash'or r.lastStand then return 0 end]====],[ [====[after]====] ]=[====[if m:GetAttribute('LuckyTricked')then return amount end
 if r.mode=='Dash'or r.lastStand then return 0 end
 if r.lastStandSpent then return amount end]====]},{[ [====[before]====] ]=[====[if not r or not alive(a)or damage<=0 then return end]====],[ [====[after]====] ]=[====[if not r or a:GetAttribute("LuckyTricked")or not alive(a)or damage<=0 then return end]====]},{[ [====[before]====] ]=[====[if r and r.lastStand and C.LastStandHealing]====],[ [====[after]====] ]=[====[if r and(r.lastStand or r.lastStandSpent)and C.LastStandHealing]====]},{[ [====[before]====] ]=[====[if r then
   if not alive(f.model)]====],[ [====[after]====] ]=[====[if r then
   if f.model:GetAttribute('LuckyTricked')then continue end
   if not alive(f.model)]====]},{[ [====[before]====] ]=[====[false,'SuperDash')]====],[ [====[after]====] ]=[====[false,'SuperDash',nil,tostring(cast.id)..':'..turn)]====]},{[ [====[before]====] ]=[====[false,'SuperLaser')]====],[ [====[after]====] ]=[====[false,'SuperLaser',nil,cast.id)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxSymRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[
return M
]====],[ [====[after]====] ]=[====[
function M.LuckyAttackId(m,kind)local r=records[m];local a=r and(kind=='SymParasite'and r.parasite or r.attack);return a and a.id end
function M.CancelLucky(m)local r=records[m];if r then clear(m,r);records[m]=nil end;for i=#pending,1,-1 do if pending[i].owner==m then table.remove(pending,i)end end end
return M
]====]},{[ [====[before]====] ]=[====[if not live(owner)then return end]====],[ [====[after]====] ]=[====[if not live(owner)or owner:GetAttribute("LuckyTricked")then return end]====]},{[ [====[before]====] ]=[====[if not live(m)then return end;local r=get(m)]====],[ [====[after]====] ]=[====[if not live(m)or m:GetAttribute("LuckyTricked")then return end;local r=get(m)]====]},{[ [====[before]====] ]=[====[if r and not Gate.Paused(f.model)]====],[ [====[after]====] ]=[====[if r and not f.model:GetAttribute("LuckyTricked")and not Gate.Paused(f.model)]====]},{[ [====[before]====] ]=[====[  if first then
]====],[ [====[after]====] ]=[====[  if first and require(SSS.CraxLuckyRuntime).Dodge(first.model,C.Damage,f.model,'SymTongue',a.id)then a.mode='Return';a.age=0;emit('Miss',{Owner=f.model,Activation=a.id});return end
  if first then
]====]},{[ [====[before]====] ]=[====[if(p.position-t.position).Magnitude<=t.radius+.55 then p.mode='Attached';p.age=0;emit('ParasiteAttach',{Owner=f.model,Target=t.model,Activation=p.id})end]====],[ [====[after]====] ]=[====[if(p.position-t.position).Magnitude<=t.radius+.55 then if require(SSS.CraxLuckyRuntime).Dodge(t.model,C.ParasiteDPS,f.model,'SymParasite',p.id)then p.mode='Return';p.age=0 else p.mode='Attached';p.age=0;emit('ParasiteAttach',{Owner=f.model,Target=t.model,Activation=p.id})end end]====]},{[ [====[before]====] ]=[====[false,'SymTongue')]====],[ [====[after]====] ]=[====[false,'SymTongue',nil,a.id)]====]},{[ [====[before]====] ]=[====[false,'SymParasite')]====],[ [====[after]====] ]=[====[false,'SymParasite',nil,p.id)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxInvertedRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[
return M
]====],[ [====[after]====] ]=[====[
function M.CancelLucky(m)
 local r=records[m];if r then r.mark=nil;r.pending=nil;r.count=0;r.markAttempted=true;r.nextMute=r.time+random(5,9);publish(m,r)end
 for target,s in pairs(statuses)do if s.owner==m then attrs(target,nil);statuses[target]=nil end end
 emit('Cancel',{Owner=m})
end
return M
]====]},{[ [====[before]====] ]=[====[statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);attrs(m,statuses[m])]====],[ [====[after]====] ]=[====[statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);statuses[m].owner=f.model;attrs(m,statuses[m])]====]},{[ [====[before]====] ]=[====[local ra,rb=records[a],records[b]]====],[ [====[after]====] ]=[====[local ra,rb=records[a],records[b];if a:GetAttribute("LuckyTricked")then ra=nil end;if b:GetAttribute("LuckyTricked")then rb=nil end]====]},{[ [====[before]====] ]=[====[function M.Melee(m,normal)]====],[ [====[after]====] ]=[====[function M.Melee(m,normal)if m:GetAttribute("LuckyTricked")then return normal end ]====]},{[ [====[before]====] ]=[====[if r then
   local e=Rules.Advance]====],[ [====[after]====] ]=[====[if r and not f.model:GetAttribute("LuckyTricked")then
   local e=Rules.Advance]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.FleauRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Step(dt,fighters,enabled)]====],[ [====[after]====] ]=[====[function M.Step(dt,fighters,enabled)
 for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Fleau"and f.model:GetAttribute("LuckyTricked")then return end end]====]},{[ [====[before]====] ]=[====[local function rec(m)
 if not is(m)then return end]====],[ [====[after]====] ]=[====[local function rec(m)
 if not is(m)or m:GetAttribute("LuckyTricked")then return end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.GhostyNight]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[
return Night
]====],[ [====[after]====] ]=[====[
function Night.CancelLucky(m,fighters)local spent=escapes[m];Night.Reset(fighters);escapes[m]=spent;m:SetAttribute('GhostEscapeUsed',spent==true)end
return Night
]====]},{[ [====[before]====] ]=[====[function Night.Step(clock,dt,fighters,clearWebs)]====],[ [====[after]====] ]=[====[function Night.Step(clock,dt,fighters,clearWebs)
 for _,f in ipairs(fighters)do if ghost(f)and f.model:GetAttribute("LuckyTricked")then return false end end]====]},{[ [====[before]====] ]=[====[false,"GhostBleed")]====],[ [====[after]====] ]=[====[false,"GhostBleed",nil,tostring(bleed))]====]},{[ [====[before]====] ]=[====[false,"GhostSlash")]====],[ [====[after]====] ]=[====[false,"GhostSlash",nil,record.sequence)]====]},{[ [====[before]====] ]=[====[    if amount>0 then spent[target]]====],[ [====[after]====] ]=[====[    local luckyMiss=amount>0 and require(SSS.CraxLuckyRuntime).Dodge(target,amount,owner,"GhostSlash",record.sequence)
    if amount>0 then spent[target]]====]},{[ [====[before]====] ]=[====[if numeric(target,"Health",0)>0 and not bleeds[target]]====],[ [====[after]====] ]=[====[if not luckyMiss and numeric(target,"Health",0)>0 and not bleeds[target]]====]},{[ [====[before]====] ]=[====[bleeds[target]={source=owner,timer=0,remaining=10}]====],[ [====[after]====] ]=[====[bleeds[target]={source=owner,timer=0,remaining=10,luckyAttackId=record.sequence}]====]},{[ [====[before]====] ]=[====[nil,tostring(bleed))]====],[ [====[after]====] ]=[====[nil,bleed.luckyAttackId)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxDeadlyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Step(dt,fighters)]====],[ [====[after]====] ]=[====[function M.CancelLucky(model)cleanup();M.luckyRestart=true end
function M.Step(dt,fighters)
 if M.luckyRestart then local blocked=false;for _,f in ipairs(fighters)do if f.model:GetAttribute('LuckyTricked')then blocked=true end end;if not blocked then start();M.luckyRestart=false end end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.MonsterBiteAbilities]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"]====],[ [====[after]====] ]=[====[local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"and not f.model:GetAttribute("LuckyTricked")]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxBiteSmoothClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[if not allowed()or not f.head.Parent or f.model:GetAttribute("AbilityId")~="MonsterBite"then]====],[ [====[after]====] ]=[====[if f.model:GetAttribute("LuckyTricked")or not allowed()or not f.head.Parent or f.model:GetAttribute("AbilityId")~="MonsterBite"then]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CopEmClient]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[local function luckyIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local key=({LuckyDice='Dice',LuckyClover='Clover',LuckyJackpot='Jackpot',LuckyFinale='Max'})[kind]
 local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundTransparency=1;f.Parent=parent
 if C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f
 else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.Text=({Dice='2 DÉS',Clover='CHANCE',Jackpot='JACKPOT',Max='MAX'})[key];t.Font=Enum.Font.FredokaOne;t.TextScaled=true;t.TextColor3=Color3.fromRGB(255,211,87);t.BackgroundTransparency=1;t.ZIndex=5;t.Parent=f end
 return f
end
]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function emblem(parent,kind,color,x,y,size)]====],[ [====[after]====] ]=[====[local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,5)=='Lucky'then luckyIconV1(parent,kind,x,y,size);return end]====]},{[ [====[before]====] ]=[====[    if i==4 and currentCrax=="Crax_Symbioti"then]====],[ [====[after]====] ]=[====[    if i==4 and currentCrax=="Crax_Lucky"then
     if revealed then luckyIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 and currentCrax=="Crax_Symbioti"then]====]}}},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxBookCinema]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[self.trophyArt:ClearAllChildren()]====],[ [====[after]====] ]=[====[self.trophyArt:ClearAllChildren()
 if id=='Crax_Lucky'then local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(255,211,87),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end]====]}}},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.ArenaCamera]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[local function beginDefeat() -- FantasticExclusiveFinale_v4]====],[ [====[after]====] ]=[====[local function beginDefeat() -- FantasticExclusiveFinale_v4
 if state:GetAttribute('RoundVictoryKind')=='LuckyFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end]====]},{[ [====[before]====] ]=[====[if player:GetAttribute("SymCameraOwner")then]====],[ [====[after]====] ]=[====[if player:GetAttribute("LuckyCameraOwner")then if defeat then clearDefeat()end;return end
  if player:GetAttribute("SymCameraOwner")then]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.FantasticRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Step(dt,fighters)]====],[ [====[after]====] ]=[====[function M.Step(dt,fighters)
 for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Fantastic"and f.model:GetAttribute("LuckyTricked")then return end end]====]},{[ [====[before]====] ]=[====[false,'FantasticElastic')]====],[ [====[after]====] ]=[====[false,'FantasticElastic',nil,h.id)]====]},{[ [====[before]====] ]=[====[   if chosen then enemy=chosen end]====],[ [====[after]====] ]=[====[   if chosen and require(SSS.CraxLuckyRuntime).Dodge(chosen.model,2,r.f.model,'FantasticElastic',h.id)then h.stage='return';h.index=#h.path;return end
   if chosen then enemy=chosen end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxGoldenRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Step(dt,fighters,active)]====],[ [====[after]====] ]=[====[function M.Step(dt,fighters,active)
 for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Golden"and f.model:GetAttribute("LuckyTricked")then return end end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxPlumberRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Step(dt,enabled)]====],[ [====[after]====] ]=[====[function M.Step(dt,enabled)
 for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Plumber"and f.model:GetAttribute("LuckyTricked")then return end end]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxBurning]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[function M.Apply(attacker,target)]====],[ [====[after]====] ]=[====[function M.CancelLuckyOwner(owner)
 local Deadly=require(SSS.CraxDeadlyRuntime);local targets={};for target,r in pairs(records)do if r.attacker==owner or Deadly.Root(r.attacker)==owner then targets[#targets+1]=target end end;for _,target in ipairs(targets)do M.Clear(target)end
end
function M.Apply(attacker,target)
 if attacker and attacker:GetAttribute('LuckyTricked')then return false end]====]},{[ [====[before]====] ]=[====[false,"Burning")]====],[ [====[after]====] ]=[====[false,"Burning",nil,tostring(r))]====]},{[ [====[before]====] ]=[====[local M={};local records={}]====],[ [====[after]====] ]=[====[local M={};local records={};local luckySerial=0]====]},{[ [====[before]====] ]=[====[else record={attacker=attacker,remaining=3,tick=0,round=state:GetAttribute("RoundId")};records[target]=record end]====],[ [====[after]====] ]=[====[else luckySerial+=1;record={attacker=attacker,remaining=3,tick=0,round=state:GetAttribute("RoundId"),luckyAttackId=luckySerial};records[target]=record end]====]},{[ [====[before]====] ]=[====[nil,tostring(r))]====],[ [====[after]====] ]=[====[nil,r.luckyAttackId)]====]}}},{[ [====[path]====] ]=[====[ServerScriptService.CraxSpideyRuntime]====],[ [====[kind]====] ]=[====[patch]====],[ [====[prepend]====] ]=[====[]====],[ [====[replacements]====] ]={{[ [====[before]====] ]=[====[false,"SpideyPoison")]====],[ [====[after]====] ]=[====[false,"SpideyPoison",nil,tostring(p))]====]},{[ [====[before]====] ]=[====[ poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4}]====],[ [====[after]====] ]=[====[ serial+=1;poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4,luckyAttackId=serial}]====]},{[ [====[before]====] ]=[====[nil,tostring(p))]====],[ [====[after]====] ]=[====[nil,p.luckyAttackId)]====]}}}}
local modules={{[ [====[path]====] ]=[====[ServerScriptService.CraxLuckyAdapters]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Inspected families only. Unknown families are refused and diagnosed, never silently treated as compatible.
local SS=game:GetService('ServerScriptService');local M={};local installed=false
function M.Install()
 if installed then return end;installed=true
 local S=require(SS.CraxLuckySuppression)
 for id,name in pairs({Crax_Super='CraxSuperRuntime',Crax_Inverted='CraxInvertedRuntime',Crax_Symbioti='CraxSymRuntime',Crax_Deadly='CraxDeadlyRuntime'})do local runtime=require(SS:WaitForChild(name));assert(runtime.CancelLucky,'Annulation manquante : '..name);S.Register(id,function(m)runtime.CancelLucky(m)end,id~="Crax_Deadly")end
 for id,name in pairs({Crax_Fantastic='FantasticRuntime',Crax_Golden='CraxGoldenRuntime',Crax_Plumber='CraxPlumberRuntime',Crax_Fleau='FleauRuntime'})do local runtime=require(SS:WaitForChild(name));S.Register(id,function()runtime.Reset()end,false)end
 local night=require(SS.GhostyNight);S.Register('Crax_Ghosty',function(m,f)night.CancelLucky(m,f)end,false)
 -- Native Bite and Spidey cancellation is completed by their patched simulation sites.
 S.Register('Crax_Monster',function()end)
 S.Register('Crax_Spidey',function()require(SS.CraxSpideyRuntime).Clear();require(SS.CraxLuckyRuntime).ClearWebs=true end,false)
end
function M.Report(catalog)
 local S=require(SS.CraxLuckySuppression);local missing={};for id in pairs(catalog)do if not S.Supported(id)then missing[#missing+1]=id end end;table.sort(missing);return missing
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyAppearance]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local M={};local saved=setmetatable({},{__mode='k'})
function M.Restore(m)
 local map=saved[m];if map then for p,v in pairs(map)do if p.Parent then p.Color=v.color;p.Material=v.material;p.Reflectance=v.reflect;p.Transparency=v.alpha;if p:IsA('MeshPart')then p.TextureID=v.texture end;for _,s in ipairs(v.surfaces)do s:Clone().Parent=p end end end end;saved[m]=nil
 local h=m:FindFirstChild('Head',true);local a=h and h:FindFirstChild('LuckyMouth');if a and a:GetAttribute('LuckyOwned')then a:Destroy()end
end
function M.Apply(m)
 M.Restore(m);local map={};saved[m]=map
 for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then
  local v={color=p.Color,material=p.Material,reflect=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}};map[p]=v
  for _,s in ipairs(p:GetChildren())do if s:IsA('SurfaceAppearance')then v.surfaces[#v.surfaces+1]=s:Clone();s:Destroy()end end
  local n=p.Name:lower();if n:find('tooth',1,true)then p.Color=Color3.fromRGB(232,170,43);p.Material=Enum.Material.Metal;p.Reflectance=.18;p.Transparency=0
  elseif n:find('gums',1,true)then p.Color=Color3.fromRGB(207,122,131);p.Transparency=0;p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.015
  elseif n=='eyeleft'or n=='eyeright'then p.Color=Color3.fromRGB(12,15,19);p.Transparency=0
  elseif n:find('shell',1,true)then p.Color=Color3.fromRGB(242,240,229);p.Transparency=0;p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025 end
  if p:IsA('MeshPart')then p.TextureID=''end
 end end
 local h=assert(m:FindFirstChild('Head',true));local upper=assert(m:FindFirstChild('UpperGums',true));local lower=assert(m:FindFirstChild('LowerGums',true));h.Transparency=1
 local a=Instance.new('Attachment');a.Name='LuckyMouth';a:SetAttribute('LuckyOwned',true);a.CFrame=h.CFrame:ToObjectSpace(CFrame.new((upper.Position+lower.Position)*.5));a.Parent=h
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyAssets]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Authored meshes are assembled at local coordinates exported from Blender.
local RS=game:GetService('ReplicatedStorage');local M={}
function M.Model(kind,parent)
 local source=assert(RS:FindFirstChild('CraxLuckyImportedAssets'),'Importer LuckyCrax_FX_IMPORT.fbx')
 local zero=assert(source:FindFirstChild('LFX_Origin',true));local up=assert(source:FindFirstChild('LFX_Up',true));local front=assert(source:FindFirstChild('LFX_Front',true));local f=(front.Position-zero.Position).Unit;local u=(up.Position-zero.Position).Unit;local basis=CFrame.fromMatrix(zero.Position,f:Cross(u).Unit,u,-f);local scale=1/(up.Position-zero.Position).Magnitude
 local o=Instance.new('Model');o.Name='Lucky'..kind
 for _,p in ipairs(source:GetDescendants())do if p:IsA('MeshPart')then
  local name=p.Name;local include=kind=='Coin'and(name=='LFX_CoinBody'or name=='LFX_CoinDetail')or kind=='Dice'and(name=='LFX_Die'or name:match('^LFX_Digit_'))or kind=='Clover'and(name:match('^LFX_Clover')or name:match('^LFX_Leaf'))or kind=='Reels'and name:match('^LFX_Reel')or kind=='Chest'and name:match('^LFX_Chest')or kind=='Lid'and name=='LFX_Lid'
  if include then local c=p:Clone();local rel=basis:ToObjectSpace(p.CFrame);c.Size=p.Size*scale;c.CFrame=rel.Rotation+rel.Position*scale;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.CastShadow=false
   local n=c.Name;local gold=n:find('Coin',1,true)or n:find('Clover',1,true)or n:find('Leaf',1,true)or n=='LFX_ReelCase';c.Material=gold and Enum.Material.Metal or Enum.Material.SmoothPlastic;c.Reflectance=gold and .16 or .02;c.Color=(n=='LFX_CoinDetail'or n:find('LeafVein',1,true))and Color3.fromRGB(111,72,18)or(gold and Color3.fromRGB(232,170,43)or(n=='LFX_Die'and Color3.fromRGB(241,234,209)or Color3.fromRGB(151,27,45)));c.Parent=o end
 end end
 o.Parent=parent;o.WorldPivot=CFrame.identity;return o
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyAudio]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxLuckyConfig'));local Map=require(RS:WaitForChild('CraxLuckyAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false
local function remove(i)local e=entries[i];e.sound:Stop();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale)
 local clip=Map.Segments[name];if not clip or C.AtlasId==''then return end
 if not preloaded then preloaded=true;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({C.AtlasId})end)end)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='LuckyAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.SoundId=C.AtlasId;s.Volume=finale and C.Volume*.95 or C.Volume;s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop
 local group=game:GetService('SoundService'):FindFirstChild('CraxMusicControl');if finale and group and group:IsA('SoundGroup')then s.SoundGroup=group end
 s.Parent=p;local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('LuckyCrax : mauvais atlas audio ; lancer DIAGNOSTIC_AUDIO_CLIENT.lua');e.born=-math.huge
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
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyAudioMap]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[return {Duration=16.24,Segments={
 ['CoinFlip']={Start=0.0,End=0.42,Loop=false},
 ['CoinRevealPile']={Start=0.54,End=0.86,Loop=false},
 ['CoinRevealFace']={Start=0.98,End=1.38,Loop=false},
 ['CoinLaunch']={Start=1.5,End=1.8,Loop=false},
 ['CoinBounce']={Start=1.92,End=2.1,Loop=false},
 ['CoinHit']={Start=2.22,End=2.5,Loop=false},
 ['DiceLaunch']={Start=2.62,End=3.12,Loop=false},
 ['DiceBounce']={Start=3.24,End=3.46,Loop=false},
 ['DiceSettle']={Start=3.58,End=3.98,Loop=false},
 ['DiceDouble']={Start=4.1,End=4.8,Loop=false},
 ['CloverReady']={Start=4.92,End=5.47,Loop=false},
 ['CloverDodge']={Start=5.59,End=5.99,Loop=false},
 ['CloverExpire']={Start=6.11,End=6.41,Loop=false},
 ['ReelsStart']={Start=6.53,End=6.93,Loop=false},
 ['ReelsLoop']={Start=7.05,End=7.65,Loop=true},
 ['ReelStop']={Start=7.77,End=7.99,Loop=false},
 ['JackpotHeal']={Start=8.11,End=8.81,Loop=false},
 ['JackpotCoins']={Start=8.93,End=9.63,Loop=false},
 ['JackpotCheat']={Start=9.75,End=10.6,Loop=false},
 ['CoinVolley']={Start=10.72,End=10.9,Loop=false},
 ['CheatEnd']={Start=11.02,End=11.44,Loop=false},
 ['MaxBuild']={Start=11.56,End=12.76,Loop=false},
 ['MaxSuspense']={Start=12.88,End=13.98,Loop=false},
 ['MaxPrize']={Start=14.1,End=15.1,Loop=false},
 ['MaxTitle']={Start=15.22,End=16.12,Loop=false},
}}
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxLuckyClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players')
local C=require(RS:WaitForChild('CraxLuckyConfig'));local Assets=require(RS:WaitForChild('CraxLuckyAssets'));local Audio=require(RS:WaitForChild('CraxLuckyAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxLuckyFX');local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local root=Instance.new('Folder');root.Name='LuckyCrax_Local';root.Parent=workspace
local GOLD=Color3.fromRGB(241,186,55);local RED=Color3.fromRGB(137,20,37);local PURPLE=Color3.fromRGB(163,80,218);local coins={};local casts={};local clovers={};local particles={};local cheats={};local poses={};local connections={};local scene;local seen
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(class,p,parent)local o=Instance.new(class);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local a=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=a and id and a:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function pos(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,m,loop,finale)return Audio.Play(name,pos(m)or Vector3.zero,loop,finale)end
local function spark(p,color,n)
 for i=1,(low and math.min(n,5)or n)do local a=i*2.4;local o=make('Part',{Size=Vector3.one*.12,Shape=Enum.PartType.Ball,Color=color,Material=Enum.Material.Neon,Transparency=.1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},root);particles[#particles+1]={part=o,start=os.clock(),p=p,v=Vector3.new(math.cos(a),math.sin(a),i%3-1)*3}end
end
local function glyph(parent,kind)
 local f=make('Frame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},parent)
 if kind=='Coin'then
  local disk=make('Frame',{Size=UDim2.fromScale(.72,.72),Position=UDim2.fromScale(.14,.14),BackgroundColor3=GOLD,BorderSizePixel=0},f);make('UICorner',{CornerRadius=UDim.new(1,0)},disk);make('UIStroke',{Color=Color3.fromRGB(122,73,12),Thickness=2},disk)
  make('TextLabel',{Size=UDim2.fromScale(1,1),Text='⌣',Font=Enum.Font.FredokaOne,TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.fromRGB(79,41,9)},disk)
 else make('TextLabel',{Size=UDim2.fromScale(1,1),Text=kind=='Heal'and'♥'or'J',TextScaled=true,Font=Enum.Font.FredokaOne,BackgroundTransparency=1,TextColor3=kind=='Heal'and Color3.fromRGB(118,225,107)or PURPLE,TextStrokeColor3=GOLD,TextStrokeTransparency=.15},f)end
 return f
end
local function reel(owner,parent,large)
 local h=head(owner);local hp=h and h:FindFirstChild('HealthBar');local hpPixels=hp and hp.Size.Y.Offset or 60
 local anchor=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false},parent)
 local gui=make('BillboardGui',{Adornee=anchor,Size=UDim2.fromOffset(200,190),AlwaysOnTop=true,LightInfluence=0},anchor)
 local panel=make('Frame',{Size=UDim2.fromOffset(186,78),AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,.5,-hpPixels*.5-10),BackgroundColor3=RED,BorderSizePixel=0},gui)
 make('UICorner',{CornerRadius=UDim.new(0,12)},panel);make('UIStroke',{Color=GOLD,Thickness=4},panel)
 local strips={}
 for i=1,3 do local window=make('Frame',{Size=UDim2.fromOffset(48,52),Position=UDim2.fromOffset(9+(i-1)*60,13),ClipsDescendants=true,BackgroundColor3=Color3.fromRGB(38,25,25),BorderSizePixel=0},panel)
  local strip=make('Frame',{Size=UDim2.fromOffset(48,52*6),BackgroundTransparency=1},window);strips[i]=strip
  for j=0,5 do local cell=make('Frame',{Size=UDim2.fromOffset(48,52),Position=UDim2.fromOffset(0,j*52),BackgroundTransparency=1},strip);glyph(cell,({'Heal','Coin','Cheat'})[j%3+1])end
 end
 return{anchor=anchor,gui=gui,strips=strips,stopped={}}
end
local function updateReel(r,owner,t,reward,total)
 local h=head(owner);if h then local hp=h:FindFirstChild('HealthBar');local off=hp and hp.StudsOffsetWorldSpace or Vector3.new(0,h.Size.Y*.5+1.3,0);r.anchor.CFrame=frame()*h.CFrame*CFrame.new(off)end
 local index=({Heal=0,Coins=1,Cheat=2})[reward]or 0
 for i,strip in ipairs(r.strips)do local stop=total-.36+(i-1)*.18;local u=math.clamp(t/stop,0,1);local travel=(12+index)*(1-(1-u)^3);strip.Position=UDim2.fromOffset(0,-(travel%3)*52)
  if u>=1 and not r.stopped[i]then r.stopped[i]=true;sound('ReelStop',owner)end
 end
end
local faceRotation={CFrame.Angles(-math.pi/2,0,0),CFrame.Angles(0,0,-math.pi/2)*CFrame.Angles(0,-math.pi/2,0),CFrame.identity,CFrame.Angles(0,0,math.pi)*CFrame.Angles(0,math.pi,0),CFrame.Angles(0,0,math.pi/2)*CFrame.Angles(0,math.pi/2,0),CFrame.Angles(math.pi/2,0,0)}
local function clearCast(m)local r=casts[m];if r then Audio.Stop(r.loop);r.folder:Destroy();casts[m]=nil end end
local function restorePose(m)
 local s=poses[m];if not s then return end;local h=head(m)
 for p,v in pairs(s)do if p.Parent and h and(m:GetAttribute('CraxId')==C.Id or p.CFrame==v.applied)then p.CFrame=h.CFrame*v.rest end end;poses[m]=nil
end
local function mouthPose(m,amount)
 local h=head(m);if not h then return end
 if not poses[m]then local list={};for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')and(p.Name:match('^Lower')or p.Name=='InnerLower'or p.Name:match('^Tooth_1_'))then list[p]={rest=h.CFrame:ToObjectSpace(p.CFrame)}end end;poses[m]=list end
 for p,v in pairs(poses[m])do if p.Parent then v.applied=h.CFrame*CFrame.new(0,-amount*.6,0)*v.rest;p.CFrame=v.applied end end
end
local function clearCombat()
 for _,p in pairs(coins)do p.model:Destroy()end;coins={}
 for m in pairs(casts)do clearCast(m)end
 for _,r in pairs(clovers)do r.model:Destroy()end;clovers={}
 for _,r in pairs(cheats)do r.folder:Destroy()end;cheats={}
 for m in pairs(poses)do restorePose(m)end
end
local function clone(m,parent)local arch=m.Archivable;m.Archivable=true;local c=m:Clone();m.Archivable=arch;for _,o in ipairs(c:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('BillboardGui')or o:IsA('Sound')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanQuery=false;o.CanTouch=false;o.LocalTransparencyModifier=0 end end;c.Parent=parent;return c end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('LuckyFinaleCamera')
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('LuckyCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='LuckyFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local token=state:GetAttribute('CraxMatchToken');local round=state:GetAttribute('RoundId')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('LuckyVictoryMatch')~=token or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local hr=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-pos(winner)).Magnitude>180 then return end end
 clearCombat();local folder=make('Folder',{Name='LuckyFinale'},root);local s={folder=folder,hidden={},saved={},camera=cam,start=state:GetAttribute('RoundVictoryStartedAt'),previous=player:GetAttribute('LuckyCameraOwner'),cues={}}
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 s.hero=clone(winner,folder);s.victim=clone(loser,folder);s.case=Assets.Model('Chest',folder);s.lid=Assets.Model('Lid',folder);s.machine=Assets.Model('Reels',folder);s.prize=Assets.Model('Coin',folder);s.reels=reel(winner,folder,true);s.money={}
 for i=1,(low and 12 or 28)do s.money[i]=Assets.Model('Coin',folder)end
 s.gui=make('ScreenGui',{IgnoreGuiInset=true,ResetOnSpawn=false,Name='LuckyFinaleTitle'},player:WaitForChild('PlayerGui'));s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.12),Position=UDim2.fromScale(.05,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=GOLD,TextStrokeTransparency=.2,Font=Enum.Font.FredokaOne,TextScaled=true,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 scene=s;seen=tostring(token)..':'..round;player:SetAttribute('LuckyCameraOwner',seen);local center=frame()*CFrame.new(loser:GetPivot().Position);local wr=winner:GetPivot().Rotation;local lr=loser:GetPivot().Rotation
 Run:BindToRenderStep('LuckyFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.End or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  s.hero:PivotTo(center*CFrame.new(-10,0,0)*wr);local vanish=math.clamp((t-F.Result)/(F.Vanish-F.Result),0,1);s.victim:PivotTo(center*CFrame.new(0,-vanish*3,0)*lr)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=vanish end end
  s.case:ScaleTo(math.max(.01,math.clamp(t/F.Build,0,1)*3.8));s.case:PivotTo(center*CFrame.new(0,-2,1));local open=math.clamp((t-(F.Result-.5))/.5,0,1);s.lid:ScaleTo(math.max(.01,math.clamp(t/F.Build,0,1)*3.8));s.lid:PivotTo(center*CFrame.new(0,-2,1)*CFrame.new(0,2.1,4)*CFrame.Angles(-open*1.7,0,0)*CFrame.new(0,-2.1,-4));s.machine:ScaleTo(math.max(.01,math.clamp((t-F.Build)/.8,0,1)*3.8));s.machine:PivotTo(center*CFrame.new(0,6.5,1));local take=math.clamp((t-F.Vanish)/(F.Pose-F.Vanish),0,1);s.prize:PivotTo(center*CFrame.new(-10+5*(1-take),-1+4*(1-take),-4)*CFrame.Angles(-math.pi/2,0,take*math.pi));updateReel(s.reels,loser,math.max(0,t-F.Build),'Coins',F.Result-F.Build)
  s.reels.anchor.CFrame=center*CFrame.new(0,7,0)
  for i,m in ipairs(s.money)do local angle=i*2.399+t*.8;local radius=t<F.Result and 5 or 5+math.max(0,t-F.Result)*1.1;local drop=t>=F.Result and(t-F.Result)^2*.7 or 0;m:PivotTo(center*CFrame.new(math.cos(angle)*radius,math.sin(angle)*3-drop,math.sin(i)*2)*CFrame.Angles(t*2+i,0,angle))end
  s.title.Visible=t>=F.Pose
  for _,cue in ipairs({{0,'MaxBuild'},{F.Build,'MaxSuspense'},{F.Result,'MaxPrize'},{F.Pose,'MaxTitle'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;sound(cue[2],winner,false,true)end end
  local focus=(center*CFrame.new(-3,2,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(29,23/(2*math.tan(math.rad(22))*math.max(.35,aspect)));local wanted=CFrame.lookAt(focus+frame():VectorToWorldSpace(Vector3.new(0,3,-distance)),focus,frame().UpVector);local back=math.clamp((t-(F.End-.8))/.8,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=44+(s.saved.FieldOfView-44)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
 end)
end
connect(FX.OnClientEvent,function(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner
 if k=='Clear'then clearCombat();return elseif k=='OwnerClear'then clearCast(m);restorePose(m);return end
 if k=='Coin'then local model=Assets.Model('Coin',root);local body=model:FindFirstChild('LFX_CoinBody');if body then local aa=make('Attachment',{Position=Vector3.new(-.13,0,0)},body);local ab=make('Attachment',{Position=Vector3.new(.13,0,0)},body);make('Trail',{Attachment0=aa,Attachment1=ab,Lifetime=low and .09 or .15,FaceCamera=true,Color=ColorSequence.new(GOLD),LightEmission=.45,MinLength=.08},body)end;coins[d.Id]={model=model,position=d.Position,owner=m,start=Clock.Time(m),volley=d.Volley};sound(d.Volley and'CoinVolley'or'CoinLaunch',m)
 elseif k=='CoinState'then if coins[d.Id]then coins[d.Id].position=d.Position end
 elseif k=='CoinEnd'then if coins[d.Id]then coins[d.Id].model:Destroy();coins[d.Id]=nil end
 elseif k=='Bounce'or k=='CoinHit'then local p=(frame()*CFrame.new(d.Position)).Position;spark(p,GOLD,k=='Bounce'and 6 or 12);Audio.Play(k=='Bounce'and'CoinBounce'or'CoinHit',p)
 elseif k=='Cast'then
  clearCast(m);local folder=make('Folder',{},root);local r={folder=folder,kind=d.Kind,start=Clock.Time(m),id=d.Activation,data=d};casts[m]=r
  if r.kind=='Coin'then r.coin=Assets.Model('Coin',folder);sound('CoinFlip',m)
  elseif r.kind=='Dice'then r.dice={Assets.Model('Dice',folder),Assets.Model('Dice',folder)};sound('DiceLaunch',m)
  else r.reels=reel(m,folder);sound('ReelsStart',m);r.loop=sound('ReelsLoop',m,true)end
 elseif k=='CastEnd'then local r=casts[m];if r and r.kind=='Volley'then sound('JackpotCoins',m);return end;if r and r.kind=='Coin'then sound(r.data.Face and'CoinRevealFace'or'CoinRevealPile',m)elseif r and r.kind=='Reels'then sound('Jackpot'..r.data.Reward,m)end;clearCast(m)
 elseif k=='DiceImpact'then sound(d.A==d.B and'DiceDouble'or'DiceSettle',m);spark((frame()*CFrame.new(d.Position)).Position,GOLD,15)
 elseif k=='Clover'then if clovers[m]then clovers[m].model:Destroy()end;clovers[m]={model=Assets.Model('Clover',root),start=Clock.Time(m),duration=d.Duration};sound('CloverReady',m)
 elseif k=='Dodge'or k=='CloverExpire'then if clovers[m]then clovers[m].model:Destroy();clovers[m]=nil end;sound(k=='Dodge'and'CloverDodge'or'CloverExpire',m);if k=='Dodge'then spark(pos(m),GOLD,10)end
 elseif k=='Volley'then poses[m]=nil;casts[m]={kind='Volley',folder=make('Folder',{},root),start=Clock.Time(m),id=d.Activation}
 elseif k=='Heal'then local p=pos(m);if p then for i=1,(low and 2 or 4)do local start=p+Vector3.new((i-2)*.65,4.5,0);local a=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CFrame=CFrame.new(start)},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(24,24),AlwaysOnTop=false,Adornee=a},a);make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='♥',Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=Color3.fromRGB(120,244,135)},g);particles[#particles+1]={part=a,start=os.clock(),p=start,v=p-start}end;spark(p,Color3.fromRGB(115,238,136),12);local a=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CFrame=CFrame.new(p)},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(110,36),AlwaysOnTop=true,Adornee=a},a);make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=d.AtMax and'PV MAX'or('+'..tostring(d.Amount)),Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=Color3.fromRGB(120,244,135)},g);particles[#particles+1]={part=a,start=os.clock(),p=p,v=Vector3.new(0,2,0)}end
 elseif k=='Cheat'then sound('JackpotCheat',m);spark(pos(d.Target),PURPLE,13)
 elseif k=='Unsupported'then warn('LuckyCrax : '..tostring(d.Reason))end
end)
local accumulated=0
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0;local now=os.clock()
 for id,p in pairs(coins)do if not p.owner.Parent then p.model:Destroy();coins[id]=nil else local t=Clock.Time(p.owner)-p.start;p.model:PivotTo(frame()*CFrame.new(p.position)*CFrame.Angles(-math.pi/2,0,t*10))end end
 for m,r in pairs(casts)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then clearCast(m);restorePose(m)
  else local t=Clock.Time(m)-r.start;local h=head(m)
   if r.kind=='Coin'then r.coin:PivotTo(frame()*h.CFrame*CFrame.new(0,1,-5)*CFrame.Angles(-math.pi/2+t*16,0,t*4))
   elseif r.kind=='Dice'then local bounce=math.min(2,math.floor(t/math.max(.1,C.DiceDuration-.3)*3));if bounce>0 and bounce~=(r.bounce or 0)then sound('DiceBounce',m);r.bounce=bounce end;for i,die in ipairs(r.dice)do local u=math.clamp(t/math.max(.1,C.DiceDuration-.3),0,1);local target=(frame()*CFrame.new(r.data.Position)).Position;local start=(frame()*h.CFrame*CFrame.new(i==1 and-4 or 4,1,-3)).Position;local p=start:Lerp(target+frame():VectorToWorldSpace(Vector3.new(i==1 and-1 or 1,0,0)),u)+frame():VectorToWorldSpace(Vector3.new(0,math.abs(math.sin(u*math.pi*3))*(1-u)*3,0));local spin=(1-u)^2*math.pi*8;die:PivotTo(CFrame.new(p)*CFrame.Angles(spin,spin*.7,spin*.5)*faceRotation[i==1 and r.data.A or r.data.B])end
   elseif r.kind=='Reels'then updateReel(r.reels,m,t,r.data.Reward,C.ReelsDuration);Audio.Pause(r.loop,Clock.Paused(m))
   elseif r.kind=='Volley'then mouthPose(m,math.sin(math.min(1,t/.15)*math.pi*.5));if t>.8 then clearCast(m);restorePose(m)end end
  end
 end
 for m,r in pairs(clovers)do if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then r.model:Destroy();clovers[m]=nil else r.model:PivotTo(frame()*head(m).CFrame*CFrame.new(5,1,-1)*CFrame.Angles(-math.pi/2,0,(Clock.Time(m)-r.start)*.7))end end
 for _,name in ipairs({'Fighter1','Fighter2'})do local m=workspace:FindFirstChild(name);if m then local remain=m:GetAttribute('LuckyCheatRemaining');if remain then
  if not cheats[m]then local folder=make('Folder',{Name='LuckyCheatLinks'},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(150,35),AlwaysOnTop=true,Adornee=head(m),StudsOffsetWorldSpace=Vector3.new(0,-head(m).Size.Y*.65,0)},folder);make('TextLabel',{Name='Countdown',Size=UDim2.fromScale(1,1),BackgroundTransparency=.2,BackgroundColor3=Color3.fromRGB(44,18,65),TextColor3=GOLD,TextScaled=true,Font=Enum.Font.FredokaOne},g);local r={folder=folder,gui=g,cards={},start=Clock.Time(m)};cheats[m]=r
   for i=1,(low and 2 or 3)do local card=make('Part',{Name='TrickedJoker',Size=Vector3.new(.65,.9,.09),Color=PURPLE,Material=Enum.Material.SmoothPlastic,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},folder);local face=make('BillboardGui',{Size=UDim2.fromOffset(22,30),AlwaysOnTop=false,Adornee=card},card);make('TextLabel',{Size=UDim2.fromScale(1,1),Text=i==1 and'⊘'or'J',Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=GOLD,BackgroundTransparency=1},face);r.cards[i]=card end
  end
  local r=cheats[m];r.gui.Countdown.Text='TRICHE '..math.ceil(remain)..' s';local h=head(m);for i,card in ipairs(r.cards)do local angle=(Clock.Time(m)-r.start)*1.5+i*math.pi*2/#r.cards;local radius=math.max(h.Size.X,h.Size.Y)*.5+.8;card.CFrame=frame()*h.CFrame*CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,-1)*CFrame.Angles(0,0,math.sin(angle)*.25)end
  elseif cheats[m]then cheats[m].folder:Destroy();cheats[m]=nil;sound('CheatEnd',m)end end end
 for i=#particles,1,-1 do local p=particles[i];local t=(now-p.start)/.65;if t>=1 then p.part:Destroy();table.remove(particles,i)else p.part.Position=p.p+p.v*t;p.part.Transparency=t end end
end)
local function clearAll()clearCombat();stopScene();Audio.Clear();for _,p in ipairs(particles)do p.part:Destroy()end;particles={}end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()clearAll();seen=nil end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local C={Id='Crax_Lucky',AbilityId='LuckyCoin',Health=105,Melee=8,
 CoinWait={6,9},PileDamage=12,FaceDamage=16,VolleyDamage=5,VolleyCount=6,VolleyLife=4,CheatDuration=7,Heal=25,
 -- Explicit prototype values, not creator-approved balancing decisions.
 CoinFaceChance=.5,CoinLife=3,CoinSpeed=32,CoinRadius=.48,FaceBounces=2,FlipDuration=.65,
 DiceWait={12,16},DiceDuration=1.2,DiceRadius=5,DiceMultiplier=2,DiceDoubleBonus=8,
 CloverHits=3,CloverDuration=4,ReelsWait={18,24},ReelsDuration=1.8,Weights={Heal=45,Coins=45,Cheat=10},VolleyInterval=.10,
 MaxTitle='LE GROS LOT',TrophyId='LuckyGrandPrize',Finale={Build=1.2,Spin=3,Result=5,Vanish=6.5,Pose=8,End=9},
 Quality='Auto',Volume=.17,AtlasId='',Icons={Dice='',Clover='',Jackpot='',Max=''},PricesReference='Crax_Spidey'}
local a=game:GetService('ReplicatedStorage'):FindFirstChild('CraxLuckyUserAssets')
if a then
 local id=a:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Icons)do local id=a:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxLuckyRules]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local R={}
function R.Dice(a,b,c)assert(a%1==0 and b%1==0 and a>=1 and a<=6 and b>=1 and b<=6);return(a+b)*c.DiceMultiplier+(a==b and c.DiceDoubleBonus or 0)end
function R.Reward(u,c)local total=c.Weights.Heal+c.Weights.Coins+c.Weights.Cheat;local v=u*total;if v<c.Weights.Heal then return'Heal'elseif v<c.Weights.Heal+c.Weights.Coins then return'Coins'else return'Cheat'end end
function R.New(level,random,c)return{level=level,time=0,due={Coin=random(c.CoinWait[1],c.CoinWait[2]),Dice=random(c.DiceWait[1],c.DiceWait[2]),Reels=random(c.ReelsWait[1],c.ReelsWait[2])},received={},count=0}end
function R.Next(r,c)
 if r.cast then return end;local best,t
 for i,kind in ipairs({'Coin','Dice','Reels'})do if r.level>=({Coin=0,Dice=1,Reels=3})[kind]and r.time>=r.due[kind]and(not t or r.due[kind]<t)then best=kind;t=r.due[kind]end end
 return best
end
function R.Received(r,key,loss,c)
 if r.level<2 or loss<=0 or r.readyUntil and r.readyUntil>r.time or r.received[key]then return false end
 r.received[key]=true;r.count+=1;if r.count>=c.CloverHits then r.count=0;r.readyUntil=r.time+c.CloverDuration;return true end;return false
end
function R.Dodge(r,c)if r and r.readyUntil and r.time<r.readyUntil then r.readyUntil=nil;r.count=0;r.received={};return true end;return false end
function R.Sweep(a,b,p,r)
 local v=b-a;local d=a-p;local cc=d:Dot(d)-r*r;if cc<=0 then return 0 end
 local aa=v:Dot(v);if aa<1e-12 then return end;local bb=2*d:Dot(v);local disc=bb*bb-4*aa*cc;if disc<0 then return end
 local t=(-bb-math.sqrt(disc))/(2*aa);if t>=0 and t<=1 then return t end
end
-- Exact first wall time within a movement interval, corners count as one bounce.
function R.Wall(p,v,b,dt)
 local t,x,y=dt,false,false
 for _,d in ipairs({{'X',b.minX,b.maxX},{'Y',b.minY,b.maxY}})do
  local axis,lo,hi=d[1],d[2],d[3];local speed=v[axis]
  if math.abs(speed)>1e-10 then local q=((speed>0 and hi or lo)-p[axis])/speed
   if q>=-1e-9 and q<=t+1e-9 then if q<t-1e-9 then x=false;y=false end;t=math.max(0,q);if axis=='X'then x=true else y=true end end
  end
 end
 return t,x,y
end
return R
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxLuckyRuntime]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxLuckyConfig'));local R=require(RS:WaitForChild('CraxLuckyRules'));local Supp=require(SS:WaitForChild('CraxLuckySuppression'))
local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Silence=require(RS:WaitForChild('CraxSilenceGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Resolver=require(SS:WaitForChild('CraxSkillResolver'))
local state=workspace:WaitForChild('CombatState');local Hit=SS:WaitForChild('BiteHit');local Heal=SS:WaitForChild('CraxHeal');local FX=RS:WaitForChild('CraxLuckyFX')
local M={};local records={};local projectiles={};local volleys={};local motions={};local previous={};local round;local match;local serial=0;local rand=Random.new();local roots={};local hitDedupe={};local running=false
local function random(a,b)return rand:NextNumber(a,b)end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m:GetAttribute('CraxId')==C.Id end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function world(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bound(radius)
 local l=workspace:FindFirstChild('Arenaleft');local rr=workspace:FindFirstChild('ArenaRight');local b=workspace:FindFirstChild('Arenabottom');local t=workspace:FindFirstChild('ArenaTop')
 return{minX=l.Position.X+l.Size.X*.5+radius,maxX=rr.Position.X-rr.Size.X*.5-radius,minY=b.Position.Y+b.Size.Y*.5+radius,maxY=t.Position.Y-t.Size.Y*.5-radius}
end
local function origin(f)
 local h=f.model:FindFirstChild('Head',true);local a=h and h:FindFirstChild('LuckyMouth');if a then local p=a.WorldPosition+world(f,f.position)-f.model:GetPivot().Position;return Vector2.new(p.X,p.Y)end
 return f.position
end
local function enemy(a,b)return alive(b)and a~=b and not Deadly.SameTeam(a,b)and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')and not b:GetAttribute('DeadlyPhantom')end
local function get(m)if not own(m)then return end;if not records[m]then records[m]=R.New(Resolver.Resolve(m),random,C)end;return records[m]end
local function nearest(f)local best,dist;for m,g in pairs(motions)do if enemy(f.model,m)then local d=(f.position-g.position).Magnitude;if not dist or d<dist then best=g;dist=d end end end;return best end
function M.Reset()running=false;records={};projectiles={};volleys={};motions={};previous={};hitDedupe={};Supp.Reset();round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')end
function M.Begin(fighters)M.Reset();running=true;local adapters=require(SS:WaitForChild('CraxLuckyAdapters'));adapters.Install();if adapters.Report then local missing=adapters.Report(require(RS.CraxCatalog));state:SetAttribute('LuckyUnsupportedFamilies',table.concat(missing,', '));if #missing>0 then warn('LuckyCrax / Triche : adaptateurs absents pour '..table.concat(missing,', '))end end;roots=fighters;Supp.Begin(fighters);for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end end
function M.CancelLucky(m)
 records[m]=nil;Supp.RemoveOwner(m);for i=#projectiles,1,-1 do if projectiles[i].owner==m then emit('CoinEnd',{Id=projectiles[i].id});table.remove(projectiles,i)end end
 for i=#volleys,1,-1 do if volleys[i].owner==m then table.remove(volleys,i)end end;emit('OwnerClear',{Owner=m})
end
function M.AttackId(attacker,kind,id)
 if id then return id end
 if kind=='SuperLaser'or kind=='SuperDash'then return require(SS.CraxSuperRuntime).LuckyAttackId(attacker,kind)end
 if kind=='SymParasite'or kind=='SymTongue'then return require(SS.CraxSymRuntime).LuckyAttackId(attacker,kind)end
 -- Non-continuous legacy impacts are distinct packets. Continuous sites supply their activation above.
 if kind and kind~='Collision'then serial+=1;return 'packet:'..serial end
end
function M.Dodge(m,damage,attacker,kind,id)
 local r=records[m];if not r or damage<=0 then return false end
 local key=id and(tostring(attacker)..':'..tostring(kind)..':'..tostring(id));r.dodged=r.dodged or{}
 if key and r.dodged[key]then return true end
 -- The ongoing third attack is fully suffered; a charge only dodges a distinct following attack.
 if key and r.attackHistory and r.attackHistory[key]then return false end
 if not m:GetAttribute('LuckyTricked')and R.Dodge(r,C)then if key then r.dodged[key]=true end;emit('Dodge',{Owner=m});return true end;return false
end
function M.Confirm(a,b,loss,recoil,collision,kind,attackId)
 local function receive(m,attacker,amount)
  local r=get(m);if not r or not alive(m)or m:GetAttribute('LuckyTricked')then return end
  -- Tagged projectiles and continuous casts retain identity; ordinary contact uses a short duplicate guard.
  local key
  if attackId then key=tostring(attacker)..':'..tostring(kind)..':'..tostring(attackId)
  elseif collision then
   local d=hitDedupe[m]or{};hitDedupe[m]=d;local prior=d[attacker];if prior and r.time-prior<.18 then return end;d[attacker]=r.time;serial+=1;key='contact:'..serial
  else key=tostring(attacker)..':'..tostring(kind)end
  r.attackHistory=r.attackHistory or{};if amount<=0 or r.attackHistory[key]then return end;r.attackHistory[key]=true
  if R.Received(r,key,amount,C)then emit('Clover',{Owner=m,Duration=C.CloverDuration})end
 end
 receive(b,a,loss);if collision then receive(a,b,recoil)end
end
function M.Healed(m,amount)if own(m)then emit('Heal',{Owner=m,Amount=amount,AtMax=amount<=0})end end
local function coin(f,r,angle,damage,life,bounces,volley)
 local target=nearest(f);if not target then return end;local start=origin(f);local d=target.position-start;if d.Magnitude<.001 then d=Vector2.new(1,0)end;d=d.Unit
 local cs,sn=math.cos(angle),math.sin(angle);d=Vector2.new(d.X*cs-d.Y*sn,d.X*sn+d.Y*cs)
 local bounds=bound(C.CoinRadius);start=Vector2.new(math.clamp(start.X,bounds.minX,bounds.maxX),math.clamp(start.Y,bounds.minY,bounds.maxY))
 serial+=1;local p={id=serial,owner=f.model,position=start,velocity=d*C.CoinSpeed,age=0,life=life,bounces=bounces,damage=damage,hits={},volley=volley,network=0};projectiles[#projectiles+1]=p;emit('Coin',{Owner=f.model,Id=p.id,Position=world(f,start),Velocity=Vector3.new(p.velocity.X,p.velocity.Y,0),Volley=volley})
end
local function projectile(p,dt)
 local f=motions[p.owner];if not f or not alive(p.owner)or p.owner:GetAttribute('LuckyTricked')then return false end
 if Gate.Paused(p.owner)then return true end
 local used=math.min(dt,p.life-p.age);p.age+=used;local left=used;local bounds=bound(C.CoinRadius)
 for _=1,8 do
  if left<=1e-9 then break end
  local t,x,y=R.Wall(p.position,p.velocity,bounds,left);local to=p.position+p.velocity*t;local hits={}
  for m,g in pairs(motions)do if enemy(p.owner,m)and not p.hits[m]then local prior=previous[m]or g.position;local fraction=R.Sweep(p.position-prior,to-g.position,Vector2.zero,g.radius+C.CoinRadius);if fraction then hits[#hits+1]={model=m,t=fraction}end end end
  table.sort(hits,function(a,b)return a.t<b.t end)
  for _,entry in ipairs(hits)do local target=entry.model;if alive(target)then p.hits[target]=true;emit('CoinHit',{Owner=p.owner,Target=target,Id=p.id,Position=world(f,p.position+(to-p.position)*entry.t)});Hit:Fire(p.owner,target,p.damage,false,'LuckyCoin',nil,p.id);if not p.volley then return false end end end
  p.position=to;left-=t
  if x or y then
   if p.bounces<=0 then return false end;p.bounces-=1;p.velocity=Vector2.new(x and-p.velocity.X or p.velocity.X,y and-p.velocity.Y or p.velocity.Y);emit('Bounce',{Owner=p.owner,Id=p.id,Position=world(f,p.position)})
  else break end
 end
 p.network+=dt;if p.network>=.05 then p.network=0;emit('CoinState',{Owner=p.owner,Id=p.id,Position=world(f,p.position)})end
 return p.age<p.life-1e-9
end
local function start(f,r,kind)
 local t=nearest(f);if not t then r.due[kind]=r.time+1;return end
 serial+=1;local a={id=serial,kind=kind,age=0,target=kind=='Reels'and Deadly.Root(t.model)or t.model,position=t.position};r.cast=a
 if kind=='Coin'then a.face=random(0,1)<C.CoinFaceChance
 elseif kind=='Dice'then a.a=rand:NextInteger(1,6);a.b=rand:NextInteger(1,6)
 else a.reward=R.Reward(random(0,1),C)end
 emit('Cast',{Owner=f.model,Activation=a.id,Kind=kind,Face=a.face,A=a.a,B=a.b,Reward=a.reward,Position=world(f,a.position)})
end
local function cast(f,r,dt)
 local a=r.cast;a.age+=dt;local duration=a.kind=='Coin'and C.FlipDuration or(a.kind=='Dice'and C.DiceDuration or C.ReelsDuration)
 if a.age<duration then return end
 if a.kind=='Coin'then coin(f,r,0,a.face and C.FaceDamage or C.PileDamage,C.CoinLife,a.face and C.FaceBounces or 0,false)
 elseif a.kind=='Dice'then
  local damage=R.Dice(a.a,a.b,C);for m,g in pairs(motions)do if enemy(f.model,m)and(g.position-a.position).Magnitude<=C.DiceRadius+g.radius then Hit:Fire(f.model,m,damage,false,'LuckyDice',nil,a.id)end end;emit('DiceImpact',{Owner=f.model,Activation=a.id,Position=world(f,a.position),A=a.a,B=a.b})
 elseif a.reward=='Heal'then
  if(f.model:GetAttribute('Health')or 0)>=(f.model:GetAttribute('MaxHealth')or C.Health)then M.Healed(f.model,0)else Heal:Fire(f.model,C.Heal,'LuckyJackpot')end
 elseif a.reward=='Coins'then r.volleyBusyUntil=r.time+C.VolleyCount*C.VolleyInterval;volleys[#volleys+1]={owner=f.model,count=0,next=r.time,id=a.id};emit('Volley',{Owner=f.model,Activation=a.id})
 elseif alive(a.target)then local ok,err=Supp.Apply(f.model,a.target,C.CheatDuration,a.id);emit(ok and'Cheat'or'Unsupported',{Owner=f.model,Target=a.target,Duration=C.CheatDuration,Reason=err})end
 emit('CastEnd',{Owner=f.model,Activation=a.id});r.cast=nil;local wait=a.kind=='Coin'and C.CoinWait or(a.kind=='Dice'and C.DiceWait or C.ReelsWait);r.due[a.kind]=r.time+random(wait[1],wait[2])
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if running then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 Supp.Step(dt,enabled);if not enabled then return end
 for m,r in pairs(records)do if not alive(m)or not own(m)then M.CancelLucky(m)end end
 for _,f in ipairs(fighters)do local r=get(f.model)
  if r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)and not f.model:GetAttribute('LuckyTricked')then
   r.time+=dt
   if r.readyUntil and r.time>=r.readyUntil then r.readyUntil=nil;r.received={};r.count=0;emit('CloverExpire',{Owner=f.model})end
   if r.cast then cast(f,r,dt)elseif r.time>=(r.volleyBusyUntil or 0)and Silence.CanStart(f.model)and not f.model:GetAttribute('PlumberInTransit')then local kind=R.Next(r,C);if kind then start(f,r,kind)end end
  end
 end
 for i=#volleys,1,-1 do local v=volleys[i];local r=records[v.owner];local f=motions[v.owner]
  if not r or not f or not alive(v.owner)or v.owner:GetAttribute('LuckyTricked')then table.remove(volleys,i)
  elseif r.time>=v.next and not Gate.Paused(v.owner)then coin(f,r,(v.count-2.5)*.055,C.VolleyDamage,C.VolleyLife,100,true);v.count+=1;v.next=r.time+C.VolleyInterval;if v.count>=C.VolleyCount then table.remove(volleys,i)end end
 end
 for i=#projectiles,1,-1 do if not projectile(projectiles[i],dt)then emit('CoinEnd',{Id=projectiles[i].id});table.remove(projectiles,i)end end
 for m,g in pairs(motions)do previous[m]=g.position end
end
Supp.Register(C.Id,function(m)M.CancelLucky(m)end)
return M
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxLuckySuppression]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Per-source suppression. No inventory/level/CraxId swapping and no delayed attribute snapshots.
local SSS=game:GetService('ServerScriptService');local state=workspace:WaitForChild('CombatState');local M={};local entries={};local adapters={};local fighters={};local clock=0
function M.Register(id,cancel,individual)assert(type(cancel)=='function');adapters[id]={cancel=cancel,individual=individual~=false}end
function M.Supported(id)return adapters[id]~=nil end
function M.Begin(list)M.Reset();fighters=list end
function M.Apply(owner,target,duration,token)
 local id=target:GetAttribute('CraxId');local adapter=adapters[id];if not adapter then return false,'Annulation non intégrée : '..tostring(id)end
 -- Global family cleanups are only safe in the inspected two-root architecture.
 for _,f in ipairs(fighters)do if not adapter.individual and f.model~=target and f.model:GetAttribute('CraxId')==id and(f.model:GetAttribute('Health')or 0)>0 then return false,'Plusieurs propriétaires de cette famille : adaptateur individuel requis'end end
 local ok,err=pcall(function()local burning=SSS:FindFirstChild('CraxBurning');if burning then require(burning).CancelLuckyOwner(target)end;adapter.cancel(target,fighters)end);if not ok then return false,tostring(err)end
 local group=entries[target]or{};entries[target]=group;group[token]={owner=owner,untilTime=clock+duration};target:SetAttribute('LuckyTricked',true);target:SetAttribute('LuckyCheatRemaining',duration);return true
end
function M.Step(dt,enabled)
 if enabled then clock+=dt end
 for target,group in pairs(entries)do
  local remaining=0
  for key,e in pairs(group)do if not target.Parent or not e.owner.Parent or(target:GetAttribute('Health')or 0)<=0 or(e.owner:GetAttribute('Health')or 0)<=0 or e.untilTime<=clock then group[key]=nil else remaining=math.max(remaining,e.untilTime-clock)end end
  if not next(group)then if target.Parent then target:SetAttribute('LuckyTricked',nil);target:SetAttribute('LuckyCheatRemaining',nil)end;entries[target]=nil else target:SetAttribute('LuckyCheatRemaining',math.ceil(remaining*10)/10)end
 end
end
function M.RemoveOwner(owner)for _,group in pairs(entries)do for key,e in pairs(group)do if e.owner==owner then group[key]=nil end end end;M.Step(0,false)end
function M.Reset()for m in pairs(entries)do if m.Parent then m:SetAttribute('LuckyTricked',nil);m:SetAttribute('LuckyCheatRemaining',nil)end end;entries={};clock=0 end
return M
]====]}}
local expected={[====[LFX_CoinBody]====],[====[LFX_CoinDetail]====],[====[LFX_Die]====],[====[LFX_Digit_1]====],[====[LFX_Digit_6]====],[====[LFX_Digit_2]====],[====[LFX_Digit_5]====],[====[LFX_Digit_3]====],[====[LFX_Digit_4]====],[====[LFX_CloverLeaf_0]====],[====[LFX_LeafVein_0]====],[====[LFX_CloverLeaf_1]====],[====[LFX_LeafVein_1]====],[====[LFX_CloverLeaf_2]====],[====[LFX_LeafVein_2]====],[====[LFX_CloverLeaf_3]====],[====[LFX_LeafVein_3]====],[====[LFX_CloverStem]====],[====[LFX_ReelCase]====],[====[LFX_ReelInset]====],[====[LFX_Heart]====],[====[LFX_Joker]====],[====[LFX_ChestFloor]====],[====[LFX_ChestFront]====],[====[LFX_ChestBack]====],[====[LFX_ChestLeft]====],[====[LFX_ChestRight]====],[====[LFX_Lid]====],[====[LFX_ChestLock]====],[====[LFX_Origin]====],[====[LFX_Up]====],[====[LFX_Front]====]}
local backupName='LuckyCrax_Backup_V1';local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('LuckyOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde incomplète ou étrangère ; inspecter avant reprise')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source éditée après installation : '..e:GetAttribute('Path'))end
 for _,path in ipairs({'ReplicatedStorage.CraxLuckyFX','ReplicatedStorage.CraxLuckyImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Lucky','ServerStorage.CraxTemplates.Crax_Lucky'})do local o=resolve(path);assert(o and o:GetAttribute('LuckyOwned'),'Élément installé supprimé ou remplacé : '..path)end
 print('LuckyCrax déjà installé, aucun doublon');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)end
assert(resolve('Workspace.CombatState'),'CombatState absent')
local plan={};local marker='-- LuckyCraxIntegrationV1'
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
for _,n in ipairs({'CraxLuckyFX','CraxLuckyImportedAssets'})do assert(not RS:FindFirstChild(n),'Nom utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'));local base=assert(templates:FindFirstChild('Crax_Monster'));local previews=assert(RS:FindFirstChild('CraxPreviews'))
assert(not templates:FindFirstChild('Crax_Lucky')and not previews:FindFirstChild('Crax_Lucky'),'Template/preview déjà présent')
local imported=assert(SS:FindFirstChild('LuckyCrax_Import'),'Importer LuckyCrax_FX_IMPORT.fbx puis placer sa racine sous ServerStorage avec le nom LuckyCrax_Import.');assert(imported:IsA('Model')or imported:IsA('Folder'),'Racine importée attendue');local found={};local countParts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans les accessoires')
 if p:IsA('BasePart')then assert(not found[p.Name],'Nom dupliqué : '..p.Name);found[p.Name]=p;countParts+=1
  if p.Name:match('^LFX_')then assert(p:IsA('MeshPart'),'MeshPart requis : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)end
 end
end
assert(countParts==#expected,'Import incomplet ou pièces supplémentaires')
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante : '..n)end
local c,f,u=found.LFX_Origin.Position,found.LFX_Front.Position,found.LFX_Up.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('LuckyOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('LuckyOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxLuckyFX';event.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxLuckyImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxLuckyAppearance)
 local template=register(base:Clone());template.Name='Crax_Lucky';appearance.Apply(template);template:SetAttribute('AbilityId','LuckyCoin');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Lucky';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : rollback bloqué par édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation arrêtée : '..tostring(err))
end
print('LuckyCrax installé. Sources de l’éditeur préservées, sauvegarde créée. Enregistrer, fermer/rouvrir puis NOUVEAU Play. Importer et brancher l’atlas audio et les illustrations pour les activer.')
end
