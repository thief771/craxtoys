-- PolariCraxIntegrationV1
local PolariV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxPolariRuntime'))
local SonGo=require(game:GetService('ServerScriptService'):WaitForChild('CraxSonGoRuntime'))
local Lucky=(function()
 local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService');local kit=RS:FindFirstChild('LuckyCraxKit');local source=SS:FindFirstChild('CraxLuckyRuntime')
 if kit and kit:GetAttribute('IntegrationReady')and source then local ok,value=pcall(require,source);if ok and type(value)=='table'and type(value.Bind)=='function'and type(value.Absorb)=='function'then return value end;warn('LuckyCrax : '..tostring(value))end
 local function noop()end;local function no()return false end
 return{Bind=noop,BeginStep=noop,Step=noop,Enforce=noop,Hold=no,Unavailable=no,Shield=function()return 0 end,Absorb=function(_,n)return n end,Incoming=function(_,_,n)return n end,Melee=function()return 0 end,CommitMelee=noop,Receive=noop,CaptureFinale=noop,ContactAllowed=function()return true end}
end)()
-- CraxCombatReconnectAuditV1
local Hangover=require(game:GetService('ServerScriptService'):WaitForChild('CraxHangoverRuntime'))
-- BlackSpidaBaseReconnectV1
local BlackSpidey=require(game:GetService('ServerScriptService'):WaitForChild('CraxBlackSpideyRuntime'))
local Bat=(function()
 local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService');local root=RS:FindFirstChild('BatCraxKit');local module=SSS:FindFirstChild('CraxBatRuntime')
 if root and module and RS:FindFirstChild('BatCraxEvent')and root:FindFirstChild('BatRules')and root:FindFirstChild('BatGeometry')and root:FindFirstChild('BatProjectile')then
  local ok,value=pcall(require,module);if ok and type(value)=='table'and type(value.Bind)=='function'and type(value.Step)=='function'and type(value.Incoming)=='function'then return value end;warn('BatCrax serveur : '..tostring(value))
 else warn('BatCrax serveur : kit incomplet ; les autres Crax restent actifs')end
 local function noop()end;local function no()return false end
 return{Bind=noop,BeginStep=noop,Step=noop,Hold=no,Unavailable=no,SuppressContact=no,Enforce=noop,CaptureFinale=noop,LampDamageAllowed=no,ContactAllowed=function()return true end,AdjustSet=function(_,hp)return hp end,Incoming=function(_,_,amount)return amount end}
end)()
-- SymbiotiCraxIntegrationV1
local SymV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))
-- CraxDisconnectRecoveryV1
local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))
local Killa=require(game:GetService('ServerScriptService'):WaitForChild('CraxKillaRuntimeV73'))
local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))
-- FleauImpactGuard_v4
-- GoldenStatueContactFix_v1
-- GoldenCombatBase_v1
-- PlumberLevels_v1
-- PlumberIntegration_v1
local Golden=require(game:GetService('ServerScriptService'):WaitForChild('CraxGoldenRuntime'))
local Plumber=require(game:GetService('ServerScriptService'):WaitForChild('CraxPlumberRuntime'))
-- VICE_PORTAL_HAZARD_v1
-- DEMO_DUMMY_HEALTH_v1
-- CombatHealth : mêmes événements, santé des principaux et des Sit'N Smile.
local Fleau=require(game:GetService('ServerScriptService'):WaitForChild('FleauRuntime'))
local FleauBridge=require(game:GetService('ServerScriptService'):WaitForChild('FleauFinaleBridge'))
local SSS=game:GetService('ServerScriptService');local state=workspace:WaitForChild('CombatState')
local event=SSS:WaitForChild('BiteHit');local heal=SSS:WaitForChild('CraxHeal')
local Night=require(SSS:WaitForChild('GhostyNight'));local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Mod=require(SSS:WaitForChild('CraxDamageModifiers'));local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local confirmed=SSS:FindFirstChild('CraxSpideyDamageConfirmed')
if not confirmed then confirmed=Instance.new('BindableEvent');confirmed.Name='CraxSpideyDamageConfirmed';confirmed.Parent=SSS end
local fantastic=SSS:WaitForChild('FantasticDamageConfirmed');local states={};local finished=false
state:SetAttribute('HealthReady',false)
local colors={{0,Color3.fromRGB(145,20,35)},{.2,Color3.fromRGB(245,65,65)},{.45,Color3.fromRGB(255,155,65)},{.7,Color3.fromRGB(255,235,120)},{1,Color3.fromRGB(160,255,170)}}
local function healthColor(ratio)
 for i=2,#colors do local a,b=colors[i-1],colors[i];if ratio<=b[1]then return a[2]:Lerp(b[2],(ratio-a[1])/(b[1]-a[1]))end end
 return colors[#colors][2]
end
local fighters={workspace:WaitForChild('Fighter1'),workspace:WaitForChild('Fighter2')}
local function finite(x)return type(x)=='number'and x==x and math.abs(x)<math.huge end
local function update(model)
 local r=states[model];if not r then return end
 model:SetAttribute('Health',r.health);model:SetAttribute('MaxHealth',r.maxHealth)
 if r.label.Parent then
  r.label.Text=(model:GetAttribute('KillaTracker')==true or r.health==math.huge)and '∞'or tostring(math.ceil(r.health))
  local ratio=r.maxHealth==math.huge and 1 or math.clamp(r.health/r.maxHealth,0,1)
  r.label.TextColor3=model:GetAttribute('KillaTracker')==true and Color3.fromRGB(255,55,38)or(model:GetAttribute('CraxId')=='Crax_Bat'and r.health>100 and Color3.fromRGB(65,165,255)or healthColor(ratio))
 end
end
local trackerWatch=setmetatable({},{__mode='k'})
local function register(model)
 local h=model:FindFirstChild('Head',true);if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 assert(h,'Tête absente : '..model.Name)
 local old=h:FindFirstChild('HealthBar');if old then old:Destroy()end
 local gui=Instance.new('BillboardGui');gui.Name='HealthBar';gui.Adornee=h;gui.Size=UDim2.fromOffset(150,60)
 gui.StudsOffsetWorldSpace=Vector3.new(0,h.Size.Y/2+1.3,0);gui.MaxDistance=250;gui.Parent=h
 local label=Instance.new('TextLabel');label.Name='HealthNumber';label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamBold;label.TextSize=36;label.TextStrokeColor3=Color3.fromRGB(25,25,30);label.TextStrokeTransparency=.3;label.Parent=gui
 local max=model:GetAttribute('MaxHealth')or 100
 assert((finite(max)and max>0)or max==math.huge,'MaxHealth invalide : '..model.Name)
 states[model]={health=max,maxHealth=max,label=label};update(model)
 if not trackerWatch[model]then trackerWatch[model]=model:GetAttributeChangedSignal('KillaTracker'):Connect(function()update(model)end)end
end
Deadly.Health={
 Register=register,
 Unregister=function(model)states[model]=nil end,
 Set=function(model,hp,maximum)
  local r=states[model];if not r or model:GetAttribute('DeadlyHPFrozen')or model:GetAttribute('FleauFury')then return end
  if(model:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()and hp<r.health then return end
  if hp<r.health and Killa.BlockDamage(model,r.health-hp)then return end
  if maximum then r.maxHealth=maximum end;hp=Hangover.AdjustSet(model,Bat.AdjustSet(model,hp,r.health),r.health,maximum or r.maxHealth,'ExternalHealthSet');r.health=math.max(0,hp);update(model);Killa.AfterDamage(model)
 end,
}
for _,model in ipairs(fighters)do register(model)end
local function resetRound()
 finished=false
 for _,model in ipairs(fighters)do local r=states[model];r.maxHealth=model:GetAttribute('MaxHealth')or 100;r.health=r.maxHealth;update(model)end
end
state:GetAttributeChangedSignal('RoundId'):Connect(resetRound)
-- The fighter can be configured after RoundId has changed: refresh at actual combat start.
state:GetAttributeChangedSignal('Phase'):Connect(function()if state:GetAttribute('Phase')=='Fighting'then resetRound()end end)
local function protected(model)
 if model:GetAttribute('GoldenStatue')then return false end
 if(model:GetAttribute("PlumberStarUntil")or 0)>workspace:GetServerTimeNow()then return true end
 if model:GetAttribute('PlumberInTransit')then return true end
 return model:GetAttribute('FantasticInvisible')or model:GetAttribute('GhostInvulnerable')or model:GetAttribute('DeadlyInvulnerable')
  or workspace:GetServerTimeNow()<(model:GetAttribute('GhostDodgeUntil')or 0)
end
local function adjust(model,amount,kind)
 if kind=='KillaStrike'then return Inverted.Vulnerable(model,amount)end
 -- Mute15: the pulse keeps its own base damage; PIRATAGE does not boost it.
 if kind=='InvertedMute'then
  if protected(model)then return 0 end
  return Deadly.AdjustDamage(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind))
 end
 if kind=='GoldenStatue'or model:GetAttribute('GoldenStatue')then return Inverted.Vulnerable(model,Fleau.FlatProtect(model,amount))end
 if protected(model)then return 0 end
 return Deadly.AdjustDamage(model,Inverted.Vulnerable(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind)))
end
Inverted.SetHealth=function(model,hp,round)
 local r=states[model]
 if r and r.health>0 and model.Parent and state:GetAttribute('Phase')=='Fighting'and state:GetAttribute('RoundId')==round then hp=Hangover.AdjustSet(model,Bat.AdjustSet(model,hp,r.health),r.health,r.maxHealth,'InvertedSet');r.health=hp;update(model);return true end
 return false
end
local function report(a,b,lost,kind)
 PolariV1.PowerResult(a,b,lost,kind)
 SymV1.PowerResult(a,b,lost,kind)
 SuperCraxV1.PowerResult(a,b,lost,kind)
 fantastic:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))
 if kind=='WebCritical'or kind=='WebImpact'or kind=='SpideyInject'then confirmed:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))end
end
local function finish(batResolution)
 if Killa.Fog()and not batResolution and not Hangover.AnyAtomic()then return end
 if state:GetAttribute('DeadlyDemoActive')then return end
 local a,b=states[fighters[1]],states[fighters[2]]
 if a.health>0 and b.health>0 then return end
 SonGo.CaptureFinale(fighters,states);Hangover.CaptureFinale(fighters,states);Bat.CaptureFinale(fighters,states);Lucky.CaptureFinale(fighters,states)
 -- GoldenVictoryOrderFix_v2
 -- Dernière capture possible avant les callbacks de mort de finish().
 require(SSS:WaitForChild("CraxGoldenFinaleBridge")).CaptureFromHealth(state,fighters,states)
 FleauBridge.CaptureFromHealth(state,fighters,states)
 finished=true
 if a.health==0 and b.health==0 then state:SetAttribute('RoundWinner','Draw')
 elseif b.health==0 then state:SetAttribute('RoundWinner','Fighter1')else state:SetAttribute('RoundWinner','Fighter2')end
 for _,f in ipairs(fighters)do if states[f].health==0 then Deadly.OnDeath(f)end end
 state:SetAttribute('Phase','RoundOver')
end
Killa.ResolveHealth=finish
local fleauHitGuard={}
local fleauGuardRound
local luckyHitSerial=0
local sonGoHitSerial=0
local function processHit(attacker,defender,damage,collision,kind,recoilSnapshot,permit,attackId,hitGeometry)
 local batLamp=kind=='BatLamp'and Bat.LampDamageAllowed(attacker)
 local hangoverAtomic=kind=='HangoverAtomic'and Hangover.AtomicDamageAllowed(attacker)
 if collision and(not Lucky.ContactAllowed(attacker,defender)or not Bat.ContactAllowed(attacker,defender,kind))then return end
 if Killa.Fog()and(collision or kind~='KillaStrike')and not batLamp and not hangoverAtomic then return end
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or not attacker or not defender or Deadly.SameTeam(attacker,defender)
  or((state:GetAttribute('GhostNightActive')or Deadly.Flash())and not batLamp and not hangoverAtomic)then return end
 if(attacker:GetAttribute('FantasticInvisible')and not attacker:GetAttribute('GoldenStatue')and kind~='Burning')or(collision and defender:GetAttribute('FantasticInvisible')and not defender:GetAttribute('GoldenStatue'))then return end
 if attacker:GetAttribute('PolariFrozen')or defender:GetAttribute('PolariFrozen')then return end
 local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end
 if SuperCraxV1.TryCrystalContact(attacker,defender)then return end
 if(attacker:GetAttribute('PlumberInTransit')and not attacker:GetAttribute('GoldenStatue'))or(defender:GetAttribute('PlumberInTransit')and not defender:GetAttribute('GoldenStatue'))then return end
 if not collision and kind~='KillaStrike'and kind~='Burning'and kind~='DeadlyPortal'and kind~='FleauFury'and not batLamp and not hangoverAtomic and Gate.Paused(attacker)then report(attacker,defender,0,kind);return end
 local amount=collision and(damage~=nil and damage or(Plumber.ContactDamage(attacker)))or damage
 if collision and(attacker:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then amount=40 end
 if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end
 if collision then amount=BlackSpidey.ContactDamage(attacker,defender,SuperCraxV1.ContactDamage(attacker,defender,amount))end
 if not finite(amount)or amount<0 then return end
 if collision then amount=SonGo.Melee(attacker,amount)end
 local involvesFleau=
  attacker:GetAttribute('CraxId')=='Crax_Fleau'
  or defender:GetAttribute('CraxId')=='Crax_Fleau'
 if involvesFleau and(collision or kind=='FleauCharge' or kind=='FleauFury')then
  local round=state:GetAttribute('RoundId')
  if fleauGuardRound~=round then
   fleauGuardRound=round;fleauHitGuard={}
  end
  local now=workspace:GetServerTimeNow()
  local prior=fleauHitGuard[attacker]
  local reverse=fleauHitGuard[defender]
  local last=prior and prior[defender]
  local other=reverse and reverse[attacker]
  if collision then
   if(last and now-last.time<.2)
    or(other and now-other.time<.2)then return end
  else
   local delay=kind=='FleauCharge'and .2 or .35
   if last and last.kind==kind and now-last.time<delay then return end
  end
  prior=prior or {};fleauHitGuard[attacker]=prior
  prior[defender]={time=now,kind=collision and 'Collision'or kind}
 end
 if collision then amount=amount+Lucky.Melee(attacker)end
 local fleauAttackMode
 if collision then amount,fleauAttackMode=Fleau.Contact(attacker,amount)end
 if collision then amount=Killa.Contact(attacker,defender,amount)end
 if collision then amount=Inverted.Melee(attacker,amount)end
 amount=Golden.Outgoing(attacker,amount)
 amount=(kind=='SonGoBeam'or kind=='SuperLaser'or kind=='SymParasite')and adjust(defender,amount,kind)or Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)
 local recoil=recoilSnapshot~=nil and recoilSnapshot or(Plumber.ContactDamage(defender))
 if collision and(defender:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then recoil=40 end
 if collision then recoil=BlackSpidey.ContactDamage(defender,attacker,SuperCraxV1.ContactDamage(defender,attacker,recoil))end
 if collision then recoil=recoil+Lucky.Melee(defender)end
 if collision then recoil=SonGo.Melee(defender,recoil)end
 local fleauRecoilMode
 if collision then recoil=Inverted.Melee(defender,recoil);recoil,fleauRecoilMode=Fleau.Contact(defender,recoil);recoil=Killa.Contact(defender,attacker,recoil)end
 local incoming=collision and finite(recoil)and recoil>=0 and Inverted.Final(attacker,adjust(attacker,Golden.Outgoing(defender,Inverted.RawInput(defender,attacker,recoil)),'Collision'),defender)or 0
 amount=SonGo.Incoming(attacker,defender,amount,kind,Hangover.Melee(kind,collision,amount),hitGeometry);incoming=SonGo.Incoming(defender,attacker,incoming,'Collision',collision)
 if amount>0 and amount-Lucky.Shield(defender)>=b.health and not Deadly.IsAlly(defender)and kind~='GoldenStatue'and not defender:GetAttribute('GoldenStatue')and Night.TryEscape(defender,attacker)then report(attacker,defender,0,kind);return end
 if incoming>0 and incoming-Lucky.Shield(attacker)>=a.health and not Deadly.IsAlly(attacker)and not attacker:GetAttribute('GoldenStatue')and Night.TryEscape(attacker,defender)then return end
 if Killa.BlockDamage(defender,amount,permit)then amount=0 end
 if Killa.BlockDamage(attacker,incoming,permit)then incoming=0 end
 amount=SymV1.Reduce(defender,amount);incoming=SymV1.Reduce(attacker,incoming)
 if kind=='PolariFan'then amount=PolariV1.MaxFanPacket(amount)end
 amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)
 if collision then incoming=SuperCraxV1.Incoming(attacker,incoming,a.health,defender,'Collision')end
 amount=Bat.Incoming(attacker,defender,amount,kind,collision);incoming=Bat.Incoming(defender,attacker,incoming,'Collision',collision)
 amount=Lucky.Incoming(attacker,defender,amount,kind);incoming=Lucky.Incoming(defender,attacker,incoming,'Collision')
 if collision then if amount>0 then Lucky.CommitMelee(attacker)end;if incoming>0 then Lucky.CommitMelee(defender)end end
 amount=Lucky.Absorb(defender,amount);incoming=Lucky.Absorb(attacker,incoming)
 local hangoverHit=Hangover.NextHitId();local defenseB,defenseA
 amount,defenseB=Hangover.Incoming(attacker,defender,amount,kind,Hangover.Melee(kind,collision,amount),hangoverHit..':b',b.health,b.maxHealth)
 if collision then incoming,defenseA=Hangover.Incoming(defender,attacker,incoming,'Collision',true,hangoverHit..':a',a.health,a.maxHealth)end
 if collision then if defenseB and defenseB.ShieldTriggered then incoming=0 end;if defenseA and defenseA.ShieldTriggered then amount=0 end end
 -- Preserve shields and reductions, but never amplify Tianlong above its server budget.
 if not collision and (kind=='LuckyBreath' or kind=='LuckyZone') then amount=math.min(amount,damage) end
 if kind=='PolariFan'then amount=PolariV1.MaxFanPacket(amount)end
 local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)
 b.health=math.max(0,b.health-amount);a.health=math.max(0,a.health-incoming)
 SonGo.CaptureFinale(fighters,states);Hangover.CaptureFinale(fighters,states);Bat.CaptureFinale(fighters,states);Lucky.CaptureFinale(fighters,states)
 if b.health<=0 and not Killa.Fog()then Fleau.BeforeDeath(defender,b)end
 if a.health<=0 and not Killa.Fog()then Fleau.BeforeDeath(attacker,a)end
 BlackSpidey.AfterDamage(defender,lost);BlackSpidey.AfterDamage(attacker,attackerLost)
 Fleau.AfterDamage(defender,lost);Fleau.AfterDamage(attacker,attackerLost)
 if collision then Fleau.CommitContact(attacker,defender,fleauAttackMode);Fleau.CommitContact(defender,attacker,fleauRecoilMode)end
 FleauBridge.CaptureFromHealth(state,fighters,states)
 require(SSS:WaitForChild("CraxGoldenFinaleBridge")).CaptureFromHealth(state,fighters,states)
 update(attacker);update(defender);sonGoHitSerial=sonGoHitSerial+1;local sonGoAttackId=attackId or('Hit:'..sonGoHitSerial);SonGo.Receive(defender,attacker,lost,kind,sonGoAttackId);if collision then SonGo.Receive(attacker,defender,attackerLost,'Collision',sonGoAttackId)end;luckyHitSerial=luckyHitSerial+1;local luckyIdentity=attackId and tostring(attackId)or(tostring(kind or 'Collision')..':'..luckyHitSerial);Lucky.Receive(defender,attacker,lost,luckyIdentity);if collision then Lucky.Receive(attacker,defender,attackerLost,luckyIdentity)end;SymV1.Confirm(attacker,defender,lost,attackerLost,collision);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);Killa.AfterDamage(attacker);Killa.AfterDamage(defender);Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)
 if collision then fantastic:Fire(defender,attacker,attackerLost,'Collision',state:GetAttribute('RoundId'))end
 -- Decide the round from the two roots only; all registered allies are secondary.
 if not Killa.Fog()then if a.health==0 then Deadly.OnDeath(attacker)end;if b.health==0 then Deadly.OnDeath(defender)end end
 finish(batLamp or hangoverAtomic)
 return lost>0
end
Lucky.ApplyDamage=processHit
Lucky.SpendChannel=function(model,amount)
 local r=states[model];if not r or r.health<=0 or finished or state:GetAttribute('Phase')~='Fighting'or not model:GetAttribute('LuckyChannel')then return 0 end
 local loss=math.min(amount,math.max(0,r.health-1));r.health=r.health-loss;update(model);return loss
end
SonGo.ApplyDamage=processHit
SonGo.Drain=function(model,amount)
 local r=states[model];if not r or r.health<=0 or finished or state:GetAttribute('Phase')~='Fighting'then return 0 end
 local loss=math.min(amount,math.max(0,r.health-1));r.health=r.health-loss;update(model);return loss
end
SonGo.Heal=function(model,amount,cap)
 local r=states[model];if not r or r.health<=0 or finished or state:GetAttribute('Phase')~='Fighting'or model:GetAttribute('DeadlyHPFrozen')or not Fleau.HealAllowed(model)then return 0 end
 local gain=math.max(0,math.min(cap,r.health+amount)-r.health);gain=SuperCraxV1.AllowHeal(model,gain);r.health=r.health+gain;update(model);SymV1.Healed(model,gain);if Deadly.OnHeal then Deadly.OnHeal(model,gain,model)end;return gain
end
SonGo.ReturnHealth=function(model,hp)
 local r=states[model];if not r or r.health<=0 or finished or state:GetAttribute('Phase')~='Fighting'then return false end
 r.health=hp;update(model);return true
end
Hangover.ApplyDamage=processHit
BlackSpidey.ApplyDamage=processHit
Bat.ApplyDamage=processHit
Bat.LabHeal=function(model)
 local r=states[model];if not r or r.health<=0 or finished or state:GetAttribute('Phase')~='Fighting'or model:GetAttribute('DeadlyHPFrozen')or not Fleau.HealAllowed(model)then return 0 end
 local before=r.health;local gain=math.max(0,math.min(125,before+25)-before);gain=SuperCraxV1.AllowHeal(model,gain);r.health=before+math.max(0,gain);update(model);SymV1.Healed(model,r.health-before);if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,model)end;return r.health-before
end
event.Event:Connect(processHit)
Killa.ApplyStrike=processHit
Inverted.PulseDamage=function(attacker,target)return processHit(attacker,target,15,false,'InvertedMute')end
heal.Event:Connect(function(model,amount,source)
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or Deadly.Flash()or state:GetAttribute('GhostNightActive')or not finite(amount)or amount<=0 or model:GetAttribute('DeadlyHPFrozen')then return end
 local r=states[model];if not r or r.health<=0 or Killa.Fog()then return end
 if not Fleau.HealAllowed(model)then return end
 amount=SuperCraxV1.AllowHeal(model,amount);if amount<=0 then return end
 local before=r.health;local capped=math.min(r.maxHealth,r.health+amount);r.health=model:GetAttribute('CraxId')=='Crax_Bat'and math.max(before,capped)or capped;update(model)
 SymV1.Healed(model,r.health-before)
 if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end
end)
Fleau.Health={
 Set=function(model,hp,maximum)local r=states[model];if r and not model:GetAttribute('FleauFury')then if hp<r.health and Killa.BlockDamage(model,r.health-hp)then return end;hp=Hangover.AdjustSet(model,Bat.AdjustSet(model,hp,r.health),r.health,maximum or r.maxHealth,'ExternalHealthSet');r.health=hp;r.maxHealth=maximum;update(model);Killa.AfterDamage(model)end end,
 Exhaust=function(model)
  local r=states[model];if not r or finished or state:GetAttribute('Phase')~='Fighting'then return end
  -- If the opponent died, the earlier finish already committed victory.
  if Killa.BlockDamage(model,r.health)then return end
  r.health=Hangover.AdjustSet(model,Bat.AdjustSet(model,0,r.health),r.health,r.maxHealth,'ExternalDeath');update(model);SonGo.CaptureFinale(fighters,states);Hangover.CaptureFinale(fighters,states);Bat.CaptureFinale(fighters,states);Lucky.CaptureFinale(fighters,states);FleauBridge.CaptureFromHealth(state,fighters,states);if r.health<=0 then Deadly.OnDeath(model)end;finish()
 end,
}
SuperCraxV1.KillHealthBatch=function(requests,expectedRound,expectedMatch)
 if #requests==0 or state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('RoundId')~=expectedRound or state:GetAttribute('CraxMatchToken')~=expectedMatch then return false end
 local unique={}
 for _,request in ipairs(requests)do
  local model=request.model;local r=states[model]
  if unique[model]or not r or r.health<=0 or not SuperCraxV1.ValidateCrystalKill(model,request.carrier,expectedRound,expectedMatch,request.token)then return false end
  unique[model]=true
 end
 for _,request in ipairs(requests)do local model=request.model;local r=states[model];local before=r.health;r.health=Hangover.AdjustSet(model,Bat.AdjustSet(model,0,r.health),r.health,r.maxHealth,'ExternalDeath');local loss=before-r.health;update(model);if request.carrier then report(request.carrier,model,loss,'SuperKryptonite')end end
 finish();return true
end
Hangover.ResolveSacrifices=function(requests)
 if #requests==0 or finished or state:GetAttribute('Phase')~='Fighting'then return false end
 local unique={}
 for _,request in ipairs(requests)do
  local model=request.model;local hp=states[model]
  if unique[model]or not hp or hp.health<=0 or not Hangover.ValidSacrifice(request)then return false end;unique[model]=true
 end
 -- Validate the whole batch first. Two simultaneous failures resolve as the central normal draw.
 for _,request in ipairs(requests)do local model=request.model;states[model].health=0;Hangover.CommitSacrifice(request);update(model)end
 SonGo.CaptureFinale(fighters,states);Hangover.CaptureFinale(fighters,states);Bat.CaptureFinale(fighters,states);Lucky.CaptureFinale(fighters,states);finish(true);return true
end
state:SetAttribute('HealthReady',true)
