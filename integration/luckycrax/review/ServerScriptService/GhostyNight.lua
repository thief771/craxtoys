-- LuckyCraxIntegrationV1
local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GhostyGrandFrisson_v1 : niveau Argent, nuit classique plafonnée.
local SSS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Gate=require(SSS:WaitForChild("CraxAbilityGate"))
local Resolver=require(SSS:WaitForChild("CraxSkillResolver"))
local state=workspace:WaitForChild("CombatState")
local hit=SSS:WaitForChild("BiteHit")
local remote=RS:FindFirstChild("GhostyNightEvent")
if not remote then remote=Instance.new("RemoteEvent");remote.Name="GhostyNightEvent";remote.Parent=RS end
assert(remote:IsA("RemoteEvent"),"GhostyNightEvent doit être un RemoteEvent")
local Night={}
local random=Random.new()
local active,freezeEnd,sequence=nil,0,0
local deadlines,bleeds,counts={},{},{}
local nightBlockedUntil=0
local knives,knifeTimers,escapes={},{},{}
local escapeHandler
function Night.SetEscapeHandler(callback) escapeHandler=callback end
function Night.TryEscape(model,enemy)
 if not InvertedSilence.CanStart(model)then return false end
 if model:GetAttribute("AbilityId")~="GhostNightSlash" or (model:GetAttribute("CraxSkillLevel") or 0)<3
  or escapes[model] or not escapeHandler then return false end
 local ok=escapeHandler(model,enemy)
 if not ok then return false end
 escapes[model]=true;model:SetAttribute("GhostEscapeUsed",true)
 return true
end
local function delay() return random:NextNumber(7,12) end
local function numeric(model,key,fallback)
 local v=model:GetAttribute(key)
 return type(v)=="number" and v==v and math.abs(v)<math.huge and v or fallback
end
local function ghost(f) return f.model:GetAttribute("AbilityId")=="GhostNightSlash" end
local function living(f) return numeric(f.model,"Health",0)>0 end
local function send(action,data)
 for _,p in ipairs(Players:GetPlayers()) do
  local seat=p:GetAttribute("ArenaSeat")
  if seat==1 or seat==2 then remote:FireClient(p,action,data) end
 end
end
local function release(record)
 if not record then return end
 for _,model in ipairs(record.locked or {}) do
  Gate.Resume(model,record.reason)
  model:SetAttribute("GhostTerrified",false)
 end
 record.owner.model:SetAttribute("GhostGrandFrisson",false)
end
function Night.Reset(fighters)
 release(active)
 active=nil;freezeEnd=0;deadlines={};bleeds={};counts={};nightBlockedUntil=0
 knives={};knifeTimers={};escapes={}
 for _,f in ipairs(fighters) do
  Resolver.Resolve(f.model)
  if ghost(f) then deadlines[f.model]=delay();knifeTimers[f.model]=0 end
  f.model:SetAttribute("GhostEscapeUsed",false)
  f.model:SetAttribute("GhostDodgeUntil",0)
  f.model:SetAttribute("GhostTeleportUntil",0)
  f.model:SetAttribute("GhostInvulnerable",false)
  f.model:SetAttribute("GhostBleeding",false)
  f.model:SetAttribute("GhostTerrified",false)
  f.model:SetAttribute("GhostGrandFrisson",false)
 end
 state:SetAttribute("GhostNextNightAllowedAt",0)
 state:SetAttribute("GhostNightOwner",nil)
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostFreezeUntil",0)
 state:SetAttribute("GhostNightStart",0)
 state:SetAttribute("GhostNightEnd",0)
 send("Reset",{})
end
function Night.Slow(model)
 return active and active.stage=="Grand" and model~=active.owner.model and .5 or 1
end
-- Appelé uniquement au début d'un nouveau contact par ArenaMovement.
function Night.Contact(a,b)
 if not active or active.stage~="Grand" then return false end
 if Gate.Paused(active.owner.model) then return true end
 local owner=active.owner.model
 local target=a==owner and b or (b==owner and a or nil)
 if target and numeric(target,"Health",0)>0 then
  local before=numeric(target,"Health",0)
  hit:Fire(owner,target,50,false,"GhostGrandContact")
  if numeric(target,"Health",0)<before then send("GrandHit",{Target=target.Name,RoundId=state:GetAttribute("RoundId")}) end
 end
 return true
end
local function line()
 local center=Vector2.new(random:NextNumber(-19,19),random:NextNumber(10,40))
 local angle=random:NextNumber(0,math.pi)
 local d=Vector2.new(math.cos(angle),math.sin(angle))
 local lower,upper=-math.huge,math.huge
 local function clip(p,v,minimum,maximum)
  if math.abs(v)<1e-7 then return end
  local a,b=(minimum-p)/v,(maximum-p)/v
  lower=math.max(lower,math.min(a,b));upper=math.min(upper,math.max(a,b))
 end
 clip(center.X,d.X,-24,24);clip(center.Y,d.Y,5,45)
 return center+d*lower,center+d*upper
end
local function intersects(a,b,p,radius,width)
 local d=b-a
 local t=d:Dot(d)>1e-9 and math.clamp((p-a):Dot(d)/d:Dot(d),0,1) or 0
 return (p-(a+d*t)).Magnitude<=radius+width/2
end
local function knifeStep(dt,fighters)
 -- Bronze : délai de 3 s hors nuit, suspendu pendant les pauses de pouvoir.
 for _,f in ipairs(fighters) do
  if ghost(f) and living(f) and numeric(f.model,"CraxSkillLevel",0)>=1 and not Gate.Paused(f.model) and workspace:GetServerTimeNow()>=(f.model:GetAttribute("GhostTeleportUntil")or 0)then
   knifeTimers[f.model]=(knifeTimers[f.model] or 0)+dt
   if knifeTimers[f.model]>=3 and InvertedSilence.CanStart(f.model)then
    knifeTimers[f.model]=knifeTimers[f.model]-3
    local velocity=f.velocity
    local direction
     local p=f.position
     local center=Vector2.new(0,25)
     local away=p-center
     local directionToFarSide

     if away.Magnitude>0.01 then
      directionToFarSide=-away.Unit
     else
      local angle=random:NextNumber(0,math.pi*2)
      directionToFarSide=Vector2.new(
       math.cos(angle),
       math.sin(angle)
      )
     end

     direction=directionToFarSide
    sequence=sequence+1
    local knife={owner=f.model,position=f.position,direction=direction,id=sequence,age=0,depth=f.depth}
    table.insert(knives,knife)
    send("Knife",{Id=knife.id,Owner=f.model.Name,Position=Vector3.new(f.position.X,f.position.Y,f.depth-.5),
     Direction=Vector3.new(direction.X,direction.Y,0),Speed=70,RoundId=state:GetAttribute("RoundId")})
   end
  end
 end
 for i=#knives,1,-1 do
  local k=knives[i]
  if not k.owner.Parent or numeric(k.owner,"Health",0)<=0 then
   send("KnifeEnd",{Id=k.id,RoundId=state:GetAttribute("RoundId")});table.remove(knives,i)
  elseif not Gate.Paused(k.owner) then
   local before=k.position;local after=before+k.direction*70*dt
   k.age=k.age+dt;k.position=after
   local target
   for _,f in ipairs(require(SSS:WaitForChild('CraxDeadlyRuntime')).MotionTargets(fighters))do
    if f.model~=k.owner and living(f) and intersects(before,after,f.position,f.radius,.55) then target=f.model;break end
   end
   if target or after.X< -25 or after.X>25 or after.Y<4 or after.Y>46 or k.age>2 then
    table.remove(knives,i)
    local actualHit=false
    if target and not target:GetAttribute("GhostInvulnerable") then
     local hp=numeric(target,"Health",0)
     hit:Fire(k.owner,target,30,false,"GhostKnife")
     actualHit=numeric(target,"Health",0)<hp
     if actualHit and numeric(target,"Health",0)>0 and not bleeds[target] and random:NextNumber()<.25 then
      bleeds[target]={source=k.owner,timer=0,remaining=10};target:SetAttribute("GhostBleeding",true)
     end
    end
    send("KnifeEnd",{Id=k.id,Target=actualHit and target.Name or nil,ImpactDuration=1,
     Direction=Vector3.new(k.direction.X,k.direction.Y,0),Position=Vector3.new(after.X,after.Y,k.depth-.7),RoundId=state:GetAttribute("RoundId")})
    if state:GetAttribute("Phase")~="Fighting" then return end
   end
  end
 end
end
local function startNight(clock,fighters,clearWebs)
 if active or clock<freezeEnd or clock<nightBlockedUntil then return end
 local ready,earliest={},math.huge
 for _,f in ipairs(fighters) do
  if ghost(f) and living(f) then
   if not deadlines[f.model] then deadlines[f.model]=clock+delay() end
   local due=deadlines[f.model]
   if not Gate.Paused(f.model) and InvertedSilence.CanStart(f.model)and due<=clock then
    if due<earliest-1e-7 then ready={f};earliest=due
    elseif math.abs(due-earliest)<=1e-7 then table.insert(ready,f) end
   end
  else deadlines[f.model]=nil end
 end
 if #ready==0 then return end
 local owner=ready[random:NextInteger(1,#ready)]
 counts[owner.model]=(counts[owner.model] or 0)+1
 local grand=numeric(owner.model,"CraxSkillLevel",0)>=2 and counts[owner.model]%2==0
 local duration=math.clamp(numeric(owner.model,"NightDuration",4),1,8)
 sequence=sequence+1
 local now=workspace:GetServerTimeNow()
 local record={owner=owner,ending=clock+duration,sequence=sequence,grand=grand,stage="Night",
  reason="GhostGrandFrisson_"..sequence,locked={},round=state:GetAttribute("RoundId"),serverEnd=now+duration}
 active=record
 for _,k in ipairs(knives) do send("KnifeEnd",{Id=k.id,RoundId=record.round}) end
 knives={}
 state:SetAttribute("GhostNightOwner",owner.model.Name)
 state:SetAttribute("GhostNightActive",true)
 -- clearWebs réinitialise les verrous : poser le verrou de terreur APRÈS.
 clearWebs()
 for _,f in ipairs(fighters) do
  f.model:SetAttribute("GhostInvulnerable",f==owner)
  if f.velocity and f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*f.speed end
  if ghost(f) then deadlines[f.model]=clock+math.max(duration+.5,delay()) end
  if false then
   table.insert(record.locked,f.model);Gate.Pause(f.model,record.reason)
   f.model:SetAttribute("GhostTerrified",true)
  end
 end
 owner.model:SetAttribute("GhostGrandFrisson",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightStart",now)
 state:SetAttribute("GhostNightEnd",now+duration)
 send("Night",{Start=now,Duration=duration,Sequence=sequence,RoundId=record.round,
  Owner=owner.model.Name,GrandFrisson=grand})
end
local function beginGrand(clock,fighters)
 local record=active
 local now=workspace:GetServerTimeNow()
 record.stage="Grand";record.ending=clock+5;record.serverEnd=now+5
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",true)
 state:SetAttribute("GhostGrandFrissonStart",now)
 state:SetAttribute("GhostGrandFrissonEnd",now+5)
 record.owner.model:SetAttribute("GhostGrandFrisson",true)
 for _,f in ipairs(fighters) do
  if f~=record.owner then
   table.insert(record.locked,f.model);Gate.Pause(f.model,record.reason)
   f.model:SetAttribute("GhostTerrified",true)
  end
 end
 send("GrandStart",{Owner=record.owner.model.Name,Start=now,Duration=5,
  Sequence=record.sequence,RoundId=record.round})
end
local function finishGrand(clock,fighters)
 local record=active
 release(record);active=nil
 nightBlockedUntil=clock+10
 state:SetAttribute("GhostNextNightAllowedAt",workspace:GetServerTimeNow()+10)
 for _,f in ipairs(fighters)do if ghost(f)then deadlines[f.model]=math.max(deadlines[f.model]or 0,nightBlockedUntil)end end
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightOwner",nil)
 record.owner.model:SetAttribute("GhostInvulnerable",false)
 send("GrandEnd",{Sequence=record.sequence,RoundId=record.round})
end
local function slash(clock,fighters)
 local record=active
 local owner=record.owner.model
 local cuts={}
 for index=1,5 do
  local a,b=line();local victims={}
  for _,f in ipairs(require(SSS:WaitForChild('CraxDeadlyRuntime')).MotionTargets(fighters))do
   if f.model~=owner and living(f) and intersects(a,b,f.position,f.radius,2.8) then
    table.insert(victims,f.model.Name)
   end
  end
  table.insert(cuts,{A=Vector3.new(a.X,a.Y,-5.2),B=Vector3.new(b.X,b.Y,-5.2),
   Width=2.8,Victims=victims,Sequence=record.sequence*10+index,Duration=.35})
 end
 active=nil
 local now=workspace:GetServerTimeNow()
 freezeEnd=clock+.35
 state:SetAttribute("GhostFreezeUntil",now+.35)
 state:SetAttribute("GhostNightActive",false)
 state:SetAttribute("GhostGrandFrissonActive",false)
 state:SetAttribute("GhostNightOwner",nil)
 for _,f in ipairs(fighters) do f.model:SetAttribute("GhostInvulnerable",false) end
 send("SlashBurst",{Cuts=cuts,Sequence=record.sequence,Start=now,Duration=.35,RoundId=record.round})
 local spent={}
 local perCut=math.max(0,numeric(owner,"NightSlashDamage",50))
 for _,cut in ipairs(cuts) do
  for _,name in ipairs(cut.Victims) do
   local target=require(SSS:WaitForChild('CraxDeadlyRuntime')).Find(name)
   if target and numeric(target,"Health",0)>0 then
    local amount=math.min(perCut,math.max(0,50-(spent[target] or 0)))
    local luckyMiss=amount>0 and require(SSS.CraxLuckyRuntime).Dodge(target,amount,owner,"GhostSlash",record.sequence)
    if amount>0 then spent[target]=(spent[target] or 0)+amount;hit:Fire(owner,target,amount,false,"GhostSlash",nil,record.sequence) end
    if state:GetAttribute("Phase")~="Fighting" then return end
    if not luckyMiss and numeric(target,"Health",0)>0 and not bleeds[target]
     and random:NextNumber()<math.clamp(numeric(owner,"NightBleedChance",.25),0,1) then
     bleeds[target]={source=owner,timer=0,remaining=10,luckyAttackId=record.sequence}
     target:SetAttribute("GhostBleeding",true)
    end
   end
  end
 end
end
function Night.Step(clock,dt,fighters,clearWebs)
 for _,f in ipairs(fighters)do if ghost(f)and f.model:GetAttribute("LuckyTricked")then return false end end
 if state:GetAttribute("Phase")~="Fighting" then return false end
 for _,f in ipairs(fighters) do
  if Gate.Paused(f.model) and deadlines[f.model] then deadlines[f.model]=deadlines[f.model]+dt end
 end
 if active and not living(active.owner) then Night.Reset(fighters);return false end
 if active and Gate.Paused(active.owner.model) then
  active.ending=active.ending+dt;active.serverEnd=active.serverEnd+dt
  state:SetAttribute(active.stage=="Grand" and "GhostGrandFrissonEnd" or "GhostNightEnd",active.serverEnd)
  return false
 end
 if active and clock>=active.ending then
  if active.stage=="Grand" then finishGrand(clock,fighters) elseif active.grand then beginGrand(clock,fighters) else slash(clock,fighters) end
 elseif not active and clock>=freezeEnd then startNight(clock,fighters,clearWebs) end
 if state:GetAttribute("Phase")~="Fighting" then return true end
 local frozen=clock<freezeEnd
 if (not active or active.stage=="Grand") and not frozen then
  knifeStep(dt,fighters)
  if state:GetAttribute("Phase")~="Fighting" then return true end
  for target,bleed in pairs(bleeds) do
   if not target.Parent or numeric(target,"Health",0)<=0 then
    bleeds[target]=nil;target:SetAttribute("GhostBleeding",false)
   else
    bleed.timer=bleed.timer+(Gate.Paused(bleed.source) and 0 or dt)
    if bleed.timer>=1 then
     bleed.timer=bleed.timer-1;bleed.remaining=bleed.remaining-1
     send("Bleed",{Target=target.Name,RoundId=state:GetAttribute("RoundId")})
     hit:Fire(bleed.source,target,1,false,"GhostBleed",nil,bleed.luckyAttackId)
     if bleed.remaining<=0 then bleeds[target]=nil;target:SetAttribute("GhostBleeding",false) end
     if state:GetAttribute("Phase")~="Fighting" then break end
    end
   end
  end
 end
 return frozen
end
function Night.CancelLucky(m,fighters)local spent=escapes[m];Night.Reset(fighters);escapes[m]=spent;m:SetAttribute('GhostEscapeUsed',spent==true)end
return Night
