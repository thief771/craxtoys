-- SuperCraxIntegrationV1
local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))
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
  r.label.Text=r.health==math.huge and '∞'or tostring(math.ceil(r.health))
  local ratio=r.maxHealth==math.huge and 1 or math.clamp(r.health/r.maxHealth,0,1)
  r.label.TextColor3=healthColor(ratio)
 end
end
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
end
Deadly.Health={
 Register=register,
 Unregister=function(model)states[model]=nil end,
 Set=function(model,hp,maximum)
  local r=states[model];if not r or model:GetAttribute('DeadlyHPFrozen')or model:GetAttribute('FleauFury')then return end
  if(model:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()and hp<r.health then return end
  if maximum then r.maxHealth=maximum end;r.health=math.max(0,hp);update(model)
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
 if kind=='GoldenStatue'or model:GetAttribute('GoldenStatue')then return Inverted.Vulnerable(model,Fleau.FlatProtect(model,amount))end
 if protected(model)then return 0 end
 return Deadly.AdjustDamage(model,Inverted.Vulnerable(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind)))
end
Inverted.SetHealth=function(model,hp,round)
 local r=states[model]
 if r and r.health>0 and model.Parent and state:GetAttribute('Phase')=='Fighting'and state:GetAttribute('RoundId')==round then r.health=hp;update(model);return true end
 return false
end
local function report(a,b,lost,kind)
 SuperCraxV1.PowerResult(a,b,lost,kind)
 fantastic:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))
 if kind=='WebCritical'or kind=='WebImpact'or kind=='SpideyInject'then confirmed:Fire(a,b,lost,kind,state:GetAttribute('RoundId'))end
end
local function finish()
 if state:GetAttribute('DeadlyDemoActive')then return end
 local a,b=states[fighters[1]],states[fighters[2]]
 if a.health>0 and b.health>0 then return end
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
local fleauHitGuard={}
local fleauGuardRound
event.Event:Connect(function(attacker,defender,damage,collision,kind,recoilSnapshot)
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or not attacker or not defender or Deadly.SameTeam(attacker,defender)
  or state:GetAttribute('GhostNightActive')or Deadly.Flash()then return end
 if(attacker:GetAttribute('FantasticInvisible')and not attacker:GetAttribute('GoldenStatue')and kind~='Burning')or(collision and defender:GetAttribute('FantasticInvisible')and not defender:GetAttribute('GoldenStatue'))then return end
 local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end
 if SuperCraxV1.TryCrystalContact(attacker,defender)then return end
 if(attacker:GetAttribute('PlumberInTransit')and not attacker:GetAttribute('GoldenStatue'))or(defender:GetAttribute('PlumberInTransit')and not defender:GetAttribute('GoldenStatue'))then return end
 if not collision and kind~='Burning'and kind~='DeadlyPortal'and kind~='FleauFury'and Gate.Paused(attacker)then report(attacker,defender,0,kind);return end
 local amount=collision and(damage~=nil and damage or(Plumber.ContactDamage(attacker)))or damage
 if collision and(attacker:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then amount=40 end
 if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end
 if collision then amount=SuperCraxV1.ContactDamage(attacker,defender,amount)end
 if not finite(amount)or amount<0 then return end
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
 local fleauAttackMode
 if collision then amount,fleauAttackMode=Fleau.Contact(attacker,amount)end
 if collision then amount=Inverted.Melee(attacker,amount)end
 amount=Golden.Outgoing(attacker,amount)
 amount=kind=='SuperLaser'and adjust(defender,amount,kind)or Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)
 local recoil=recoilSnapshot~=nil and recoilSnapshot or(Plumber.ContactDamage(defender))
 if collision and(defender:GetAttribute('PlumberStarUntil')or 0)>workspace:GetServerTimeNow()then recoil=40 end
 if collision then recoil=SuperCraxV1.ContactDamage(defender,attacker,recoil)end
 local fleauRecoilMode
 if collision then recoil=Inverted.Melee(defender,recoil);recoil,fleauRecoilMode=Fleau.Contact(defender,recoil)end
 local incoming=collision and finite(recoil)and recoil>=0 and Inverted.Final(attacker,adjust(attacker,Golden.Outgoing(defender,Inverted.RawInput(defender,attacker,recoil)),'Collision'),defender)or 0
 if amount>0 and amount>=b.health and not Deadly.IsAlly(defender)and kind~='GoldenStatue'and not defender:GetAttribute('GoldenStatue')and Night.TryEscape(defender,attacker)then report(attacker,defender,0,kind);return end
 if incoming>0 and incoming>=a.health and not Deadly.IsAlly(attacker)and not attacker:GetAttribute('GoldenStatue')and Night.TryEscape(attacker,defender)then return end
 amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)
 if collision then incoming=SuperCraxV1.Incoming(attacker,incoming,a.health,defender,'Collision')end
 local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)
 b.health=math.max(0,b.health-amount);a.health=math.max(0,a.health-incoming)
 if b.health<=0 then Fleau.BeforeDeath(defender,b)end
 if a.health<=0 then Fleau.BeforeDeath(attacker,a)end
 Fleau.AfterDamage(defender,lost);Fleau.AfterDamage(attacker,attackerLost)
 if collision then Fleau.CommitContact(attacker,defender,fleauAttackMode);Fleau.CommitContact(defender,attacker,fleauRecoilMode)end
 FleauBridge.CaptureFromHealth(state,fighters,states)
 require(SSS:WaitForChild("CraxGoldenFinaleBridge")).CaptureFromHealth(state,fighters,states)
 update(attacker);update(defender);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)
 if collision then fantastic:Fire(defender,attacker,attackerLost,'Collision',state:GetAttribute('RoundId'))end
 -- Decide the round from the two roots only; all registered allies are secondary.
 if a.health==0 then Deadly.OnDeath(attacker)end;if b.health==0 then Deadly.OnDeath(defender)end
 finish()
end)
heal.Event:Connect(function(model,amount,source)
 if (state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))or(finished and not state:GetAttribute('DeadlyDemoActive')) or Deadly.Flash()or state:GetAttribute('GhostNightActive')or not finite(amount)or amount<=0 or model:GetAttribute('DeadlyHPFrozen')then return end
 local r=states[model];if not r or r.health<=0 then return end
 if not Fleau.HealAllowed(model)then return end
 amount=SuperCraxV1.AllowHeal(model,amount);if amount<=0 then return end
 local before=r.health;r.health=math.min(r.maxHealth,r.health+amount);update(model)
 if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end
end)
Fleau.Health={
 Set=function(model,hp,maximum)local r=states[model];if r and not model:GetAttribute('FleauFury')then r.health=hp;r.maxHealth=maximum;update(model)end end,
 Exhaust=function(model)
  local r=states[model];if not r or finished or state:GetAttribute('Phase')~='Fighting'then return end
  -- If the opponent died, the earlier finish already committed victory.
  r.health=0;update(model);FleauBridge.CaptureFromHealth(state,fighters,states);Deadly.OnDeath(model);finish()
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
 for _,request in ipairs(requests)do local model=request.model;local r=states[model];local loss=r.health;r.health=0;update(model);if request.carrier then report(request.carrier,model,loss,'SuperKryptonite')end end
 finish();return true
end
state:SetAttribute('HealthReady',true)
