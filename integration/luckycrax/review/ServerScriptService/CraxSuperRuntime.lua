-- LuckyCraxIntegrationV1
-- Server authority. Runs inside ArenaMovement's existing fixed-step simulation.
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
  local r=records[a];if not r or a:GetAttribute("LuckyTricked")or not alive(a)or damage<=0 then return end
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
 if m:GetAttribute('LuckyTricked')then return amount end
 if r.mode=='Dash'or r.lastStand then return 0 end
 if r.lastStandSpent then return amount end
 local result,activated=R.LastStand(r,amount,hp,Silence.CanStart(m))
 if activated then setMode(m,r);emit('LastStand',{Owner=m});createCrystal(m,r)end
 return result
end
function M.AllowHeal(m,amount)
 local r=records[m];if r and(r.lastStand or r.lastStandSpent)and C.LastStandHealing=='LOCK_AT_ONE'then return 0 end;return amount
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
   hit:Fire(f.model,g.model,shatter and C.ShatterDamage or C.Melee*C.DashDamageMultiplier,false,'SuperDash',nil,tostring(cast.id)..':'..turn)
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
   if exposure>0 then hit:Fire(f.model,g.model,C.LaserDPS*e.dt*exposure,false,'SuperLaser',nil,cast.id)end
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
   if f.model:GetAttribute('LuckyTricked')then continue end
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
function M.LuckyAttackId(m,kind)local r=records[m];return r and r.cast and r.cast.id end
function M.CancelLucky(m)
 local r=records[m];if r then r.lastStandSpent=r.lastStand or r.lastStandSpent;r.lastStand=false;r.mode=nil;r.age=0;r.cast=nil;r.nextDash=r.time+rand(C.DashWait[1],C.DashWait[2]);r.nextLaser=r.time+rand(C.LaserWait[1],C.LaserWait[2]);r.ready={};r.contacts=0;setMode(m,r);crystals[m]=nil
 for target,group in pairs(freezes)do if group[m]then releaseFreeze(target,m)end end;emit('OwnerClear',{Owner=m}) end
end
return M
