-- Adapter in the existing movement/health loop. No client-selected targets or direct HP writes.
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
