-- VeniCrax : autorité serveur. Utilise les mouvements existants (ArenaMovement), BiteHit et CraxHeal (CombatHealth).
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
