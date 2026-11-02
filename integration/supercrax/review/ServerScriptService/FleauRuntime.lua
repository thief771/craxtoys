-- SuperCraxIntegrationV1
local _superBridge
local function SuperCraxBridgeV1()if not _superBridge then _superBridge=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))end;return _superBridge end
local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- FleauChargeSolidImpact_v6
-- FleauCombatCorrection_v3
local SSS=game:GetService('ServerScriptService');local RS=game:GetService('ReplicatedStorage')
local Rules=require(RS.CraxFleau.FleauRules);local C=Rules.Config
local Gate=require(SSS.CraxAbilityGate);local Control=require(SSS.FleauControl)
local Deadly=require(SSS.CraxDeadlyRuntime);local Resolver=require(SSS.CraxSkillResolver)
local state=workspace:WaitForChild('CombatState');local hit=SSS:WaitForChild('BiteHit')
local FX=RS.CraxFleau.FX;local M={Health=nil};local records={};local motions={};local random=Random.new();local round
local function is(m)return m and m:GetAttribute('CraxId')=='Crax_Fleau'end
M.Is=is
local function fx(kind,m,extra)FX:FireAllClients(kind,m,extra or {},state:GetAttribute('RoundId'))end
local function publish(m,s)
 local stamp=math.floor(s.rage*10)/10
 if m:GetAttribute('FleauRage')~=stamp then m:SetAttribute('FleauRage',stamp)end
 m:SetAttribute('FleauMode',s.mode);m:SetAttribute('FleauGiant',s.giant==true)
 m:SetAttribute('FleauFury',s.mode=='Fury')
end
local function rec(m)
 if not is(m)then return end
 local s=records[m];if not s then
  local lv=Resolver.Resolve(m);s=Rules.New(lv);s.baseScale=m:GetScale();records[m]=s;publish(m,s)
 end;return s
end
function M.FlatProtect(m,amount)local s=rec(m);return s and Rules.Protect(s,amount)or amount end
function M.Hold(m)local s=records[m];return m:GetAttribute('FleauStunned')or(s and s.mode~='Normal')or false end
function M.Contact(m,base)
 local s=rec(m);if not s then return base,nil end
 if workspace:GetServerTimeNow()<(s.contactSuppressedUntil or 0)then return 0,'Controlled'end
 local amount,mode=Rules.Contact(s);return amount,mode
end
function M.CommitContact(m,target,mode)
 local s=records[m];if not s then return end
 if mode=='Rage'then
  Rules.Consume(s,mode);publish(m,s)
  local a,b=motions[m],motions[target]
  if a and b then local d=b.position-a.position;d=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
   b.knockback={velocity=d*95,remaining=.45}
  end
  fx('RageHit',m,{Target=target})
 end
end
function M.AfterDamage(m,lost)local s=rec(m);if s then Rules.Loss(s,lost);publish(m,s)end end
function M.HealAllowed(m)return not m:GetAttribute('FleauFury')end
function M.BeforeDeath(m,health)
 local s=rec(m);if not s then return false end
 if s.mode=='Fury'then return true end
 if not InvertedSilence.CanStart(m)or not Rules.Lethal(s)then return false end
 health.health=1;health.maxHealth=C.Health;s.savedHP=nil;s.savedMax=nil
 m:SetAttribute('FleauFury',true);m:SetAttribute('FleauGiant',false)
 Control.Clear(m);s.furyEnds=workspace:GetServerTimeNow()+C.FuryDuration;s.furyLast=workspace:GetServerTimeNow()
 s.normalVelocity=motions[m]and motions[m].velocity
 m:SetAttribute('FleauFuryEndsAt',s.furyEnds)
 -- Fury does not resume unrelated locks: movement explicitly bypasses them, timers remain owned.
 fx('Fury',m);publish(m,s);return true
end
local function restore(m,s)
 if m.Parent then
  m:ScaleTo(s.baseScale or 1)
  for _,key in ipairs({'FleauRage','FleauMode','FleauGiant','FleauFury','FleauFuryEndsAt'})do m:SetAttribute(key,nil)end
 end
end
function M.Reset()
 for m,s in pairs(records)do restore(m,s)end
 records={};motions={};M.ChargePushes={};Control.Reset()
end
local function clamp(f)
 local r=f.radius;f.position=Vector2.new(math.clamp(f.position.X,-24+r,24-r),math.clamp(f.position.Y,5+r,45-r))
end
local function wall(s,f)
 local r=f.radius;local side=random:NextInteger(1,4)
 if side==s.lastSide then side=side%4+1 end;s.lastSide=side
 if side==1 then return Vector2.new(-24+r,random:NextNumber(5+r,45-r))end
 if side==2 then return Vector2.new(24-r,random:NextNumber(5+r,45-r))end
 if side==3 then return Vector2.new(random:NextNumber(-24+r,24-r),5+r)end
 return Vector2.new(random:NextNumber(-24+r,24-r),45-r)
end
local function distance(p,a,b)
 local d=b-a;local q=d:Dot(d);local t=q>1e-8 and math.clamp((p-a):Dot(d)/q,0,1)or 0
 return(p-(a+d*t)).Magnitude
end
local function enemy(m,t)return t.model~=m and t.model.Parent and(t.model:GetAttribute('Health')or 0)>0 and not Deadly.SameTeam(m,t.model)end
function M.Step(dt,fighters,enabled)
 if round~=state:GetAttribute('RoundId')then M.Reset();round=state:GetAttribute('RoundId')end
 Control.Step()
 local targets=Deadly.MotionTargets(fighters);motions={}
 for _,f in ipairs(targets)do motions[f.model]=f end
 if state:GetAttribute('Phase')~='Fighting'then return end
 M.ChargePushes=M.ChargePushes or {}
 for target,push in pairs(M.ChargePushes)do
  local motion=motions[target]
  if not motion or not target.Parent
   or(target:GetAttribute('Health')or 0)<=0
   or target:GetAttribute('GoldenStatue')
   or target:GetAttribute('FleauFury')
   or motion.capturedBy~=nil then
   M.ChargePushes[target]=nil
  else
   local step=math.min(dt,math.max(0,push.remaining))
   local decay=math.exp(-7*step)
   motion.position=motion.position+push.velocity*((1-decay)/7)
   push.velocity=push.velocity*decay
   push.remaining=push.remaining-step
   motion.knockback=nil
   clamp(motion)
   if push.remaining<=0 then M.ChargePushes[target]=nil end
  end
 end
 for _,f in ipairs(fighters)do
  local m=f.model;local s=rec(m)
  if s and(m:GetAttribute('Health')or 0)>0 then
   local fury=s.mode=='Fury'
   local paused=not fury and(Gate.Paused(m)or m:GetAttribute('GoldenStatue')or m:GetAttribute('FantasticGrabbed')or f.capturedBy~=nil)
   if not paused and(enabled or fury)then
    if not s.normalVelocity then s.normalVelocity=f.velocity end
    local tick=dt
    if fury then local now=workspace:GetServerTimeNow();tick=math.max(0,now-s.furyLast);s.furyLast=now end
    local e=Rules.Tick(s,tick,function()return random:NextNumber()end,InvertedSilence.CanStart(m))
    if e.giant and M.Health and Rules.Giant(s,m:GetAttribute('Health'),m:GetAttribute('MaxHealth'))then
     M.Health.Set(m,300,300);fx('Giant',m)
    end
    if e.restore and M.Health then M.Health.Set(m,e.restore[1],e.restore[2]);fx('Recover',m)end
    local scale=s.baseScale*(s.giant and C.GiantScale or 1)
    local smooth=m:GetScale()+(scale-m:GetScale())*(1-math.exp(-dt*8));m:ScaleTo(smooth)
    f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2;clamp(f)
    if e.windup then s.anchor=f.position;fx('Windup',m)end
    if e.charge then
     s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2
     local near,best
     for _,t in ipairs(targets)do if enemy(m,t)then local d=(f.position-t.position).Magnitude;if not best or d<best then near=t;best=d end end end
     if near then s.destination=near.position else s.destination=wall(s,f)end
     local d=s.destination-f.position;s.direction=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
     s.chargeContact=nil;s.travel=0;fx('Charge',m)
    end
    if s.mode=='Windup'then f.position=s.anchor;f.knockback=nil
    elseif s.mode=='Charge'or s.mode=='Fury'then
     if not s.destination then
      local destination=wall(s,f)
      for attempt=1,8 do
       if(destination-f.position).Magnitude>=8 then break end
       destination=wall(s,f)
      end
      if(destination-f.position).Magnitude<8 then
       local radius=f.radius
       destination=Vector2.new(
        f.position.X>=0 and -24+radius or 24-radius,
        math.clamp(50-f.position.Y,5+radius,45-radius))
      end
      s.destination=destination;Rules.Pass(s)
     end
     local d=s.destination-f.position;local speed=s.mode=='Fury'and C.FurySpeed or C.ChargeSpeed
     speed=speed*SuperCraxBridgeV1().Speed(m)
     local from=f.position;local step=math.min(d.Magnitude,speed*dt)
     local dir=s.mode=='Charge'and s.direction or(d.Magnitude>.001 and d.Unit or Vector2.new(1,0))
     f.position=from+dir*step;f.velocity=dir*speed;clamp(f);f.knockback=nil
     for _,t in ipairs(targets)do
      if enemy(m,t)and distance(t.position,from,f.position)<f.radius+t.radius and Rules.Hit(s,t.model)then
       s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2
       hit:Fire(m,t.model,s.mode=='Fury'and C.FuryDamage or C.ChargeDamage,false,s.mode=='Fury'and 'FleauFury'or 'FleauCharge')
       if state:GetAttribute('Phase')~='Fighting'then return end
       if s.mode=='Charge'then
        -- Arrêt au bord de la cible : aucun passage au travers.
        local impactDirection=dir
        f.position=t.position-impactDirection*(f.radius+t.radius+.08)
        clamp(f)
        s.chargeContact=impactDirection
        local stunned=Control.Apply(t.model,m.Name,C.Stun)
        if stunned and not t.model:GetAttribute('GoldenStatue')
         and t.capturedBy==nil then
         M.ChargePushes=M.ChargePushes or {}
         M.ChargePushes[t.model]={velocity=dir*65,remaining=.4}
         t.position=t.position+dir*.35
         clamp(t)
        end
       end
       fx('Impact',m,{Target=t.model})
       if s.chargeContact then break end
      end
     end
     if s.chargeContact then
      local impactDirection=s.chargeContact
      s.chargeContact=nil
      s.mode='Normal'
      s.destination=nil
      s.direction=nil
      s.travel=0
      s.contactSuppressedUntil=workspace:GetServerTimeNow()+.45
      -- Fléau rebondit légèrement après le choc.
      f.velocity=-impactDirection*C.Speed
      f.knockback={velocity=-impactDirection*18,remaining=.12}
      publish(m,s)
      return
     end
     s.travel=(s.travel or 0)+step
     if(s.destination-f.position).Magnitude<.1 or step<.001 or(s.mode=='Charge'and s.travel>60)then
      if s.mode=='Fury'then s.destination=nil;s.travel=0
      else s.mode='Normal';s.destination=nil;s.contactSuppressedUntil=workspace:GetServerTimeNow()+.2;f.velocity=dir*C.Speed end
     end
    else
     if f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*C.Speed end
    end
    if e.exhaust and not s.exhausted then
     s.exhausted=true
     -- Health callback closes the round without a fake self-attack or bypassable protection.
     if M.Health then M.Health.Exhaust(m)end
     return
    end
    if state:GetAttribute('Phase')~='Fighting'then M.Reset();return end
    if s.mode=='Fury'then s.enforced=f.position end
    publish(m,s)
   end
  elseif records[m]then restore(m,records[m]);records[m]=nil end
 end
end
function M.Enforce(fighters)
 for _,f in ipairs(fighters)do local s=records[f.model]
  if s and s.mode=='Fury'and s.enforced then f.position=s.enforced;f.knockback=nil;f.capturedBy=nil end
 end
end
state:GetAttributeChangedSignal('Phase'):Connect(function()
 local p=state:GetAttribute('Phase');if p~='Fighting'then M.Reset()end
end)
return M
