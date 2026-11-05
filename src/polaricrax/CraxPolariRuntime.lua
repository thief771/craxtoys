-- Authority only: uses existing motions, pause reasons, hit event and confirmed damage.
local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local R=require(RS:WaitForChild('CraxPolariRules'));local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Skills=require(SS:WaitForChild('CraxSkillResolver'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local FX=RS:WaitForChild('CraxPolariFX');local Hit=SS:WaitForChild('BiteHit');local state=workspace:WaitForChild('CombatState');local M={};local records={};local shots={};local freeze;local round;local match;local serial=0;local rng=Random.new();local motions={};local previous={};local list={};local pendingDeflect={};local running=false
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
 running=false;release();records={};shots={};motions={};previous={};pendingDeflect={};round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')
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
 if a.kind=='Stop'and a.phase=='Dodge'and(Gate.Paused(a.target)or Deadly.Hold(a.target)or(motions[a.target]and motions[a.target].capturedBy))then a.age=0;return end
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
   if not Gate.Paused(t.model)and not Deadly.Hold(t.model)and not require(SS.CraxLuckyRuntime).Dodge(t.model,C.InvertDamage,f.model,'PolariInvert',w.id)then t.velocity=R.Repel(t.position,w.normal,bounds(),math.max(t.speed or 0,t.velocity.Magnitude)*C.RepelSpeedScale,C.RepelAngle);t.knockback=nil;Hit:Fire(f.model,t.model,C.InvertDamage,false,'PolariInvert',nil,w.id);emit('Repel',{Owner=f.model,Target=t.model,Activation=w.id,Position=xyz(t,t.position)})end
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
  elseif r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)then
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
