-- PolariCraxIntegrationV1
-- LuckyCraxIntegrationV1
-- SymbiotiCraxIntegrationV1
local function SymBridgeV1()return require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))end
-- SuperCraxIntegrationV1
local _superBridge
local function SuperCraxBridgeV1()if not _superBridge then _superBridge=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))end;return _superBridge end
local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GoldenCombatBase_v1
-- VOID_PULSAR_PIERCING_v2
-- PARKER_VICE_RULES_v1
-- STACK_OBSIDIAN_SERVER_v1
-- VICE_WELL_RELEASE_v1
-- VICE_ENERGY_SERVER_v2
-- VICE_ROSE_PORTALS_v1
-- DODGER_CRYSTAL_PERSISTENT_v2
-- DODGER_CRYSTAL_DEMO_v1
-- PARKER_WALL20_DAMAGE12_v7
-- PARKER_ROYAL_MOTION_v2
-- PARKER_INFERNO_v1
-- DOMINO_VERDICT_v1
-- Serveur autoritaire : familles, assimilations, fusion et dégâts.
local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local V=require(RS:WaitForChild('CraxDeadlyVisuals'));local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local M={families={},nodes={},fighters={},aimSpawns={},cinematics={},viceTransits={},Health=nil};local state=workspace:WaitForChild('CombatState')
local FX=RS:WaitForChild('CraxDeadlyFX');local random=Random.new()
local stunSources=setmetatable({},{__mode='k'})
local function stun(target,owner,on)
 if on and target:GetAttribute('FleauFury')then return end
 if on and M.SameTeam(owner,target)then return end
 local sources=stunSources[target]or {};stunSources[target]=sources
 local reason='DeadlyDomino'..owner.Name
 if on then sources[owner]=true;Gate.Pause(target,reason)else sources[owner]=nil;Gate.Resume(target,reason)end
 if target.Parent then target:SetAttribute('DeadlyStunned',next(sources)~=nil)end
end
local function releaseContacts(n)
 if n.name~='Domino'then return end
 for target in pairs(n.stunTargets or{})do stun(target,n.model,false)end
 n.stunTargets={};n.contacts={}
end
local folder=Instance.new('Folder');folder.Name='DeadlyAllies';folder.Parent=workspace
local stats={OG={90,25,5},Domino={25,25,5},Parker={50,25,15},Dodger={15,12,1},Vice={25,25,0},Stack={100,25,3},Void={math.huge,17,12}}
local function now()return workspace:GetServerTimeNow()end
local function alive(n)return n and not n.dead and not n.spawning and not n.eatenPending and n.model.Parent and(n.model:GetAttribute('Health')or 0)>0 end
local function xy(p)return Vector2.new(p.X,p.Y)end
local function node(model)return M.nodes[model]end
function M.Root(model)local n=node(model);return n and n.family.og.model or model end
function M.SameTeam(a,b)return a~=nil and b~=nil and M.Root(a)==M.Root(b)end
function M.IsAlly(model)local n=node(model);return n and n.name~='OG' end
function M.Hold(model)if model:GetAttribute('FleauFury')then return false end;if model:GetAttribute('FleauStunned')then return true end;if model:GetAttribute('GoldenStatue')then return true end;if model:GetAttribute('VicePortalTransit')then return true end;if state:GetAttribute('GhostNightActive')then return model:GetAttribute('DeadlySpawning')==true end;local n=node(model);return model:GetAttribute('DeadlyTransitioning')==true or model:GetAttribute('DeadlySpawning')==true or model:GetAttribute('DeadlyStunned')==true or(n and n.family.stage and n.family.stage~='Form')or false end
function M.CinematicScale()
 if state:GetAttribute('Phase')~='Fighting'then return 1 end
 for model,entry in pairs(M.cinematics)do if model.Parent and now()<entry.finish then return .22 else M.cinematics[model]=nil end end
 return 1
end
function M.Slow(model)return(model:GetAttribute('GoldenSlowMultiplier')or 1)*(now()<(model:GetAttribute('DeadlySlowUntil')or 0)and .6 or 1)end
function M.Flash()return(state:GetAttribute('DeadlyFlashCount')or 0)>0 end
local function effect(kind,data)data=data or {};data.RoundId=state:GetAttribute('RoundId');FX:FireAllClients(kind,data)end
local function setHp(n,hp,max)if M.Health then M.Health.Set(n.model,hp,max)end end
local function headpos(n)return V.Head(n.model).Position end
local function position(n)return n.motion and n.motion.position or xy(headpos(n))end
local function put(n,p)
 if n.motion then n.motion.position=p else n.p=p end
 n.model:PivotTo(CFrame.new(p.X,p.Y,n.depth)*n.rotation)
end
local function radius(n)return math.max(V.Head(n.model).Size.X,V.Head(n.model).Size.Y)/2 end
local function clearAura(n,name)local a=V.Head(n.model):FindFirstChild(name);if a then a:Destroy()end end
local function aura(n,color,name)clearAura(n,name or'DeadlyAura');return V.Aura(n.model,color,name)end
local function size(n,scale)
 n.model:ScaleTo(n.baseScale*scale)
 if n.motion then n.motion.radius=radius(n)end
 local p=position(n);put(n,Vector2.new(math.clamp(p.X,-24+radius(n),24-radius(n)),math.clamp(p.Y,5+radius(n),45-radius(n))))
end
-- STACK_OBSIDIAN_RULES_v1 — authoritative sizes, damage snapshots and independent growth cycles.
local STACK_SIZES={.5,.75,1,1.4,1.9,2.5,3,3.5}
local STACK_DAMAGE={5,7,12,19,26,35,40,55}
local STACK_SPEED={1,1,.90,.80,.68,.56,.45,.35}
local function stackSample(age)
 local stage=math.min(8,math.floor(math.max(0,age)/1.5)+1)
 local alpha=stage==8 and 0 or math.clamp((age-(stage-1)*1.5)/1.5,0,1)
 local smooth=alpha*alpha*(3-2*alpha);local nextStage=math.min(8,stage+1)
 return stage,STACK_SIZES[stage]+(STACK_SIZES[nextStage]-STACK_SIZES[stage])*smooth,
  STACK_SPEED[stage]+(STACK_SPEED[nextStage]-STACK_SPEED[stage])*smooth
end
local function stackUpdate(n,force)
 local stage,scale,speed=stackSample(n.t-(n.stackCycleStart or n.t))
 n.growth=stage-1
 n.model:SetAttribute('CollisionDamage',STACK_DAMAGE[stage])
 n.model:SetAttribute('Speed',stats.Void[2]*speed)
 if force or n.t>=(n.stackScaleAt or 0)then
  n.stackScaleAt=n.t+1/30;size(n,scale)
  n.model:SetAttribute('StackStage',stage);n.model:SetAttribute('StackScale',scale)
  n.model:SetAttribute('StackRemaining',math.max(0,(n.assimEnd or n.t)-n.t))
 end
 if stage~=(n.stackLastStage or 1)then
  n.stackLastStage=stage;effect('StackGrowth',{Model=n.model,Member='Stack',Stage=stage,Scale=STACK_SIZES[stage],Damage=STACK_DAMAGE[stage]})
 end
end
local function stackBegin(n)
 n.stackCycleStart=n.t+1.25;n.stackLastStage=1;n.stackCycles=0;n.stackScaleAt=0
 n.model:SetAttribute('StackCycles',0);stackUpdate(n,true)
end
local function stackContact(n,target,amount)
 if n.assim~='Stack'then return end
 local cf=n.model:GetPivot();local width=V.Head(n.model).Size.X;local stage=(n.growth or 0)+1
 n.stackCycleStart=n.t;n.stackLastStage=1;n.stackCycles=(n.stackCycles or 0)+1
 n.model:SetAttribute('StackCycles',n.stackCycles);stackUpdate(n,true)
 effect('StackImpact',{Model=n.model,Target=target,Member='Stack',Stage=stage,Damage=amount,Position=cf.Position,Width=width})
end
local function stackClear(n)
 n.stackCycleStart=nil;n.stackScaleAt=nil;n.stackLastStage=nil
 for _,key in ipairs({'StackStage','StackScale','StackRemaining','StackCycles'})do n.model:SetAttribute(key,nil)end
end

local function level(f)return f.og.model:GetAttribute('CraxSkillLevel')or 0 end
local function living(f)local out={};for _,n in ipairs(f.members)do if alive(n)then out[#out+1]=n end end;return out end
local function damage(a,b,amount,kind)
 if not alive(a)or not b or M.SameTeam(a.model,b)then return end
 SSS.BiteHit:Fire(a.model,b,amount,false,kind or'DeadlyPower')
end
local function enemyModels(f)
 local out={};if not M.SameTeam(f.og.model,f.enemy.model)and f.enemy.model.Parent and(f.enemy.model:GetAttribute('Health')or 0)>0 then out[1]=f.enemy.model end;local other=M.families[f.enemy.model]
 if other then for _,n in ipairs(other.members)do if n.name~='OG'and alive(n)and not M.SameTeam(f.og.model,n.model)then out[#out+1]=n.model end end end
 return out
end
function M.GetMotion(model)
 for _,motion in ipairs(M.fighters)do if motion.model==model then return motion end end
 local n=node(model);if not n or not alive(n)then return nil end
 if not n.proxy then
  local values={model=n.model,head=V.Head(n.model),depth=n.depth,rotation=n.rotation,beam={Enabled=false},extraBeams={}}
  n.proxy=setmetatable(values,{
   __index=function(_,k)
    if k=='position'then return n.p elseif k=='velocity'then return n.velocity*(n.model:GetAttribute('Speed')or 25)
    elseif k=='radius'then return radius(n)elseif k=='speed'then return n.model:GetAttribute('Speed')or 25 end
   end,
   __newindex=function(t,k,v)
    if k=='position'then n.p=v;put(n,v)
    elseif k=='velocity'then n.velocity=v.Magnitude>.001 and v.Unit or Vector2.zero
    else rawset(t,k,v)end
   end,
  })
 end
 return n.proxy
end
function M.MotionTargets(fighters)
 local out={};for _,f in ipairs(fighters)do out[#out+1]=f end
 for _,n in pairs(M.nodes)do if n.name~='OG'and alive(n)and not n.model:GetAttribute('DeadlyPhantom')then out[#out+1]=M.GetMotion(n.model)end end
 return out
end
local function contactHit(n,model)
 if M.SameTeam(n.model,model)then return end
 local opposing=node(model);if opposing then opposing.contacts=opposing.contacts or {};opposing.contacts[n.model]=true end
 if M.ContactHandler and M.ContactHandler(n.model,model)then return end
 -- BindableEvent handlers can run after the growth reset: snapshot both damage values now.
 if n.assim=='Stack'then stackUpdate(n,false)end;if opposing and opposing.assim=='Stack'then stackUpdate(opposing,false)end
 local dealt=n.model:GetAttribute('CollisionDamage')or 0;local recoil=model:GetAttribute('CollisionDamage')or 0
 SSS.BiteHit:Fire(n.model,model,dealt,true,'Collision',recoil)
 stackContact(n,model,dealt);if opposing then stackContact(opposing,n.model,recoil)end
end
function M.Find(name)
 local result=workspace:FindFirstChild(name);return result or folder:FindFirstChild(name)
end
function M.Targets(model)
 local out={model};local f=M.families[model]
 if f then for _,n in ipairs(f.members)do if n.name~='OG'and alive(n)then out[#out+1]=n.model end end end
 return out
end
local function blocked(a,b,ignore)
 local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.RespectCanCollide=true
 rp.FilterDescendantsInstances={folder,workspace:FindFirstChild('Fighter1'),workspace:FindFirstChild('Fighter2')}
 if ignore then rp.FilterDescendantsInstances[#rp.FilterDescendantsInstances+1]=ignore end
 local delta=b-a;if delta.Magnitude<.001 then return false end
 return workspace:Raycast(a,delta,rp)~=nil
end
local function free(p,r,depth,omit)
 if p.X<-24+r or p.X>24-r or p.Y<5+r or p.Y>45-r then return false end
 for _,f in ipairs(M.fighters)do if f.model~=omit and(f.position-p).Magnitude<r+f.radius+.5 then return false end end
 for _,n in pairs(M.nodes)do if n.model~=omit and(alive(n)or(n.spawning and not n.dead and n.model.Parent))and(position(n)-p).Magnitude<r+radius(n)+.5 then return false end end
 local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={folder,workspace.Fighter1,workspace.Fighter2}
 for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(p.X,p.Y,depth),Vector3.new(r*2,r*2,1),params))do
  if part.CanCollide and part.Name~='ArenaBackdrop'and part.Name~='ArenaFloor'then return false end
 end
 return true
end
local function spot(r,depth,omit)
 if M.demo or state:GetAttribute('DeadlyDemoActive') then
  -- Placement de test indépendant des obstacles du décor.
  local margin=math.clamp(r,1,18)
  return Vector2.new(
   random:NextNumber(-24+margin,24-margin),
   random:NextNumber(5+margin,45-margin)
  )
 end
 for i=1,120 do
  local p=Vector2.new(random:NextNumber(-24+r,24-r),
   random:NextNumber(5+r,45-r))
  if free(p,r,depth,omit) then return p end
 end
 return nil
end
function M.OnDeath(model)
 local n=node(model);if not n or n.dead then return end;n.dead=true
 local f=n.family
 if n.name=='OG'then
  for _,a in ipairs(f.members)do releaseContacts(a);if a~=n then
   a.dead=true;a.model:SetAttribute('DeadlyHPFrozen',false);setHp(a,0)
   if M.Health then M.Health.Unregister(a.model)end
   Gate.Reset(a.model);a.model:Destroy()
  end end
  return
 end
 releaseContacts(n)
 local stack=f.byName.Stack;if alive(stack)then
  stack.deathBonus=(stack.deathBonus or 0)+20
  effect('PowerNotice',{Model=stack.model,Member='Stack',Text='STACK : STACK EST AFFAME..',Duration=1.8})
  setHp(stack,(stack.model:GetAttribute('Health')or 0)+20,(stack.model:GetAttribute('MaxHealth')or 100)+20)
 end
 -- Dark blades always fire exactly three shots, regardless of ally deaths.
 effect('Dust',{Position=headpos(n),Color=V.Colors[n.name]})
 if M.Health then M.Health.Unregister(n.model)end
 Gate.Reset(n.model);n.model:Destroy()
end
function M.AdjustDamage(model,amount)
 if model:GetAttribute('DeadlySpawning')then return 0 end
 local n=node(model);if not n then return amount end
 local f=n.family
 if model:GetAttribute('DeadlySpawning')or model:GetAttribute('DeadlyInvulnerable')or model:GetAttribute('DeadlyHPFrozen')then return 0 end
 if n.name=='Void'then
  if n.assim=='Dodger'and amount>0 then n.breakProtection=true end
  return 0
 end
 if n.name=='OG'and not f.stage and alive(f.byName.Dodger)then
  local result=math.min(amount,math.max(0,(model:GetAttribute('Health')or 0)-1))
  local dodger=f.byName.Dodger
  if result<amount and f.t>=(dodger.noticeAt or 0)then dodger.noticeAt=f.t+1;effect('PowerNotice',{Model=dodger.model,Member='Dodger',Text='DODGER : BOUCLIER ANTI-CRAX',Duration=1.5})end
  return result
 end
 return amount
end
local function boost(f)
 if f.stage then return end
 f.og.model:SetAttribute('DeadlyShield',alive(f.byName.Dodger)and true or false)
 local active=level(f)>=1 and #living(f)>=4
 for _,n in ipairs(f.members)do if alive(n)then
  local st=stats[n.name];local rage=n.name=='Parker'and math.clamp(math.floor(((f.og.model:GetAttribute('MaxHealth')or 90)-(f.og.model:GetAttribute('Health')or 90))/10),0,6)or 0
  n.model:SetAttribute('CollisionDamage',st[3]+rage*3+(active and 2 or 0))
  n.model:SetAttribute('Speed',st[2]+rage*3+(active and 2 or 0))
  local ogHealth=f.og.model:GetAttribute('Health')or 90
  if n.name=='Parker'and rage>(n.lastRage or 0)and n.lastOGHealth and ogHealth<n.lastOGHealth and f.t>=(n.rageNoticeAt or 0)then
   n.rageNoticeAt=f.t+2.5;effect('PowerNotice',{Model=n.model,Member='Parker',Text='PARKER : COLERIQUE AUGMENTE...',Duration=1.5})
  end
  n.lastOGHealth=ogHealth
  n.lastRage=rage;n.model:SetAttribute('DeadlyRage',rage)
  if n.assim=='Stack'then stackUpdate(n,false)end
  if n.assim=='Parker'and n.frenzyStarted then n.model:SetAttribute('CollisionDamage',15);n.model:SetAttribute('Speed',100)end
  if not n.model:GetAttribute('DeadlyHPFrozen')then
   n.boost=active;n.model:SetAttribute('DeadlyFamilyBoost',active)
   if st[1]<math.huge then
    local maximum=st[1]+(n.deathBonus or 0)+(active and 5 or 0)
    local hp=n.model:GetAttribute('Health')or 0
    if active and not n.boostHealed then hp=hp+5;n.boostHealed=true end
    if maximum~=(n.model:GetAttribute('MaxHealth')or st[1])or hp~=(n.model:GetAttribute('Health')or 0)then
     setHp(n,math.min(hp,maximum),maximum)
    end
   end
  end
 end end
end
function M.OnHeal(target,gained,source)
 local vice=source and node(source)
 if gained<=0 or not alive(vice)or vice.name~='Vice'or target~=vice.family.og.model or state:GetAttribute('Phase')~='Fighting'then return end
 effect('ViceHeal',{Model=target,Duration=1.2,Amount=gained})
 effect('PowerNotice',{Model=source,Member='Vice',Text='VICE : SOINS PRODIGUEES..',Duration=1.2})
end
local function spawn(f,name)
 if not InvertedSilence.CanStart(f.og.model)then return false end
 local base=game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase')
 local m=V.Make(base,name,.5);local h=V.Head(m);local r=math.max(h.Size.X,h.Size.Y)/2
 local p
 -- Calibrate the imported base against OG's actual half-size hitbox.
 local target=V.Head(f.og.model).Size.X
 m:ScaleTo(m:GetScale()*target/h.Size.X);r=math.max(h.Size.X,h.Size.Y)/2
 p=spot(r,f.og.depth);if not p then m:Destroy();return false end
 m.Name=f.og.model.Name..'_'..name;m:SetAttribute('DeadlyRoot',f.og.model.Name)
 local st=stats[name];m:SetAttribute('MaxHealth',st[1]);m:SetAttribute('Health',st[1]);m:SetAttribute('Speed',st[2]);m:SetAttribute('CollisionDamage',st[3])
 m:SetAttribute('AbilityId','DeadlyAlly');m:SetAttribute('DeadlySpawning',true);m:SetAttribute('DeadlySpawnDuration',1.5);m.Parent=folder
 local n={model=m,name=name,family=f,p=p,depth=f.og.depth,rotation=f.og.rotation,velocity=Vector2.zero,baseScale=m:GetScale(),waves=3,contacts={},nextPulsar=f.t,nextHeal=f.t+2.5,boost=false,t=f.t,spawning=true,spawnRemaining=1.5,spawnAlpha={},spawnEnabled={}}
 f.members[#f.members+1]=n;f.byName[name]=n;M.nodes[m]=n;f.pendingSpawn=n
 for _,part in ipairs(m:GetDescendants())do
  if part:IsA('BasePart')then n.spawnAlpha[part]=part.Transparency;part:SetAttribute('DeadlyIntendedAlpha',part.Transparency);part.Transparency=1
  elseif part:IsA('ParticleEmitter')or part:IsA('Trail')or part:IsA('Beam')then n.spawnEnabled[part]=part.Enabled;part.Enabled=false end
 end
 put(n,p)
 effect('SpawnChannel',{Position=headpos(n),Color=V.Colors[name],Radius=r,Duration=1.5,Model=m,ModelName=m.Name,Member=name})
 return true
end
local function spawnStep(f,dt)
 local n=f.pendingSpawn;if not n then return end
 if n.dead or not n.model.Parent then f.pendingSpawn=nil;return end
 n.spawnRemaining=math.max(0,n.spawnRemaining-dt)
 if n.spawnRemaining>1e-6 then return end -- The safe initial position is reserved; do not keep a member invisible forever.
 -- No registered health, collision, passive or ability exists during the cloud.
 n.spawning=false;n.model:SetAttribute('DeadlySpawning',false)
 for part,alpha in pairs(n.spawnAlpha)do if part.Parent then part.Transparency=part:GetAttribute('DeadlyIntendedAlpha')or alpha;part.LocalTransparencyModifier=0 end end
 n.spawnAlpha=nil
 for emitter,enabled in pairs(n.spawnEnabled)do if emitter.Parent then emitter.Enabled=enabled end end;n.spawnEnabled=nil
 local direction=Vector2.new(random:NextNumber(-1,1),random:NextNumber(-1,1))
 n.velocity=direction.Magnitude>.001 and direction.Unit or Vector2.new(1,0)
 n.t=f.t;n.nextHeal=n.t+2.5;n.nextPulsar=n.t+(n.name=='Void'and 3 or 0)
 if n.name=='Void'then n.firstPulsarAt=n.nextPulsar end
 M.Health.Register(n.model);f.pendingSpawn=nil
 effect('SpawnReveal',{Position=headpos(n),Color=V.Colors[n.name],Radius=radius(n),Model=n.model,ModelName=n.model.Name,Member=n.name})
end
local function finishAim(model,entry,reveal)
 for part,alpha in pairs(entry.alpha)do if part.Parent then part.Transparency=alpha end end
 for gui,enabled in pairs(entry.enabled)do if gui.Parent then gui.Enabled=enabled end end
 if model.Parent then model:SetAttribute('DeadlySpawning',false);Gate.Resume(model,'DeadlyAppearance')end
 M.aimSpawns[model]=nil
 if reveal and model.Parent then effect('SpawnReveal',{Position=V.Head(model).Position,Color=V.Colors.OG,Radius=entry.radius,Model=model,ModelName=model.Name,Member='OG'})end
end
local function beginAim(motion)
 local model=motion.model;local h=V.Head(model);local entry={remaining=1.5,alpha={},enabled={},radius=math.max(h.Size.X,h.Size.Y)/2}
 model:SetAttribute('DeadlySpawning',true);model:SetAttribute('DeadlySpawnDuration',1.5);Gate.Pause(model,'DeadlyAppearance')
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA('BasePart')then entry.alpha[o]=o.Transparency;o.Transparency=1
  elseif o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then entry.enabled[o]=o.Enabled;o.Enabled=false end
 end
 M.aimSpawns[model]=entry
 effect('OGPortalEntry',{StartedAt=now(),Position=h.Position,Color=V.Colors.OG,Radius=entry.radius,Duration=1.5,Model=model,ModelName=model.Name,Member='OG'})
end
local function aimStep(dt)
 for model,entry in pairs(M.aimSpawns)do
  if not model.Parent then M.aimSpawns[model]=nil
  else entry.remaining=entry.remaining-dt;if entry.remaining<=1e-6 then finishAim(model,entry,true)end end
 end
end
local function flash(f,on)
 if f.flashing==on then return end;f.flashing=on
 local count=math.max(0,(state:GetAttribute('DeadlyFlashCount')or 0)+(on and 1 or-1));state:SetAttribute('DeadlyFlashCount',count)
 local models={workspace.Fighter1,workspace.Fighter2};for model,n in pairs(M.nodes)do if n.name~='OG'and model.Parent then models[#models+1]=model end end
 for _,model in ipairs(models)do if on then Gate.Pause(model,'DeadlyFlash'..f.og.model.Name)else Gate.Resume(model,'DeadlyFlash'..f.og.model.Name)end end
 if on then effect('Flash',{Duration=2.5})end
end
local function portalsClose(n)
 if M.demo and M.demo.viceApproach and M.demo.viceApproach.owner==n then M.demo.viceApproach=nil end
 if n.portalId then M.RequestVicePortalClose(n.portalId);n.portalId=nil end
 n.portals=nil
end
local function restoreVoidImmediate(n)
 portalsClose(n);stackClear(n);clearAura(n,'DeadlyAssimilation');n.assim=nil;n.model:SetAttribute('DeadlyAssimilation','');n.model:SetAttribute('DeadlyInvulnerable',false)
 n.model:SetAttribute('DeadlyInvulnerableChannel',false)
 for _,a in ipairs(n.family.members)do if a.model.Parent then a.model:SetAttribute('DeadlyHPFrozen',false)end end
 size(n,1);setHp(n,math.huge,math.huge);n.nextPulsar=n.t+15;n.pulse=nil;n.grid=nil;n.frenzyStarted=nil;n.parkerTouches=nil;n.breakProtection=nil;n.model:SetAttribute('Speed',17);n.model:SetAttribute('CollisionDamage',12+(n.boost and 2 or 0));n.contacts={}
end
local function restoreVoid(n)
 local member=n.assim
 restoreVoidImmediate(n)
 if member then
  n.returningUntil=n.t+1.15;n.nextPulsar=n.returningUntil+15;n.model:SetAttribute('DeadlyTransitioning',true)
  effect('AssimilationReturn',{Model=n.model,Member=member,Duration=1.15})
 end
end
local function assimilate(n,a)
 n.eating=nil;n.returningUntil=nil;n.used=true;n.assim=a.name;n.assimStart=n.t;n.assimEnd=n.assim=='Domino'and n.t+20 or n.assim=='Vice'and n.t+30 or n.assim=='Stack'and n.t+30 or math.huge
 n.model:SetAttribute('DeadlyAssimilation',a.name);if a.name~='Domino'and a.name~='Parker'and a.name~='Dodger'and a.name~='Vice'and a.name~='Stack'then aura(n,V.Colors[a.name],'DeadlyAssimilation')end
 -- DOMINO visuals are owned by CraxDominoVerdict.
 n.pulse=nil
 for i=#n.family.waves,1,-1 do if n.family.waves[i].owner==n then table.remove(n.family.waves,i)end end
 M.OnDeath(a.model)
 if n.assim=='Dodger'then setHp(n,1,1);for _,ally in ipairs(n.family.members)do if alive(ally)and ally~=n then ally.model:SetAttribute('DeadlyHPFrozen',true)end end
 elseif n.assim=='Parker'then n.chargeEnd=n.t+2.5;n.remaining=20;n.legHits={};n.model:SetAttribute('DeadlyInvulnerableChannel',false)
 elseif n.assim=='Domino'then n.nextGrid=n.t+8
 elseif n.assim=='Vice'then n.nextPortal=n.t+3
 elseif n.assim=='Stack'then stackBegin(n)
 end
 n.transformUntil=n.t+1.25;n.model:SetAttribute('DeadlyTransitioning',true)
 if n.assimEnd<math.huge then n.assimEnd=n.assimEnd+1.25 end
 for _,key in ipairs({'chargeEnd','nextGrid','nextPortal','nextGrow'})do if n[key]then n[key]=n[key]+1.25 end end
 effect('AssimilationPower',{Model=n.model,Member=n.assim,Duration=1.25})
end
local function jaw(n,opening)
 local lower=n.model:FindFirstChild('LowerJaw',true)
 if not lower or not lower:IsA('Model')then return end
 n.jawRelative=n.jawRelative or n.model:GetPivot():ToObjectSpace(lower:GetPivot())
 lower:PivotTo(n.model:GetPivot()*n.jawRelative*CFrame.new(0,-V.Head(n.model).Size.Y*.23*opening,0))
end
local function beginAssimilation(n,a)
 if not InvertedSilence.CanStart(n.model)then return end
 M.cinematics[n.model]={finish=now()+3.65}
 effect('AssimilationCinematic',{Model=n.model,Target=a.model,Member=a.name,Duration=3.65})
 n.used=true;n.eating={target=a,start=n.t,finish=n.t+2.4,position=position(a),scale=a.model:GetScale()}
 a.eatenPending=true;a.model:SetAttribute('DeadlyBeingEaten',true);a.model:SetAttribute('DeadlyInvulnerable',true)
 Gate.Pause(a.model,'DeadlySwallow');releaseContacts(a)
 for _,o in ipairs(a.model:GetDescendants())do if o:IsA('BillboardGui')then o.Enabled=false end end
 n.model:SetAttribute('DeadlyTransitioning',true)
 effect('AssimilationEat',{Model=n.model,Target=a.model,Member=a.name,Duration=2.4})
end
local function eatStep(n)
 local e=n.eating;if not e then return end
 local a=e.target
 if not a.model.Parent or a.dead then n.eating=nil;n.model:SetAttribute('DeadlyTransitioning',false);jaw(n,0);return end
 local progress=math.clamp((n.t-e.start)/2.4,0,1)
 jaw(n,math.sin(progress*math.pi))
 local ingest=math.clamp((progress-.2)/.65,0,1);ingest=ingest*ingest*(3-2*ingest)
 a.model:ScaleTo(e.scale*math.max(.025,1-ingest*.975))
 put(a,e.position:Lerp(position(n)+Vector2.new(0,-radius(n)*.18),ingest))
 if n.t>=e.finish then jaw(n,0);assimilate(n,a)end
end
local function familyContact(f)
 -- VOID_DIRECTION_FIX_v1: the demo's hidden OG is a support, not a collision obstacle.
 if M.demo and M.demo.family==f then return end
 if f.stage or not alive(f.og)or M.Hold(f.og.model)then return end
 -- The only ordinary friendly barrier is OG. Other allies overlap freely.
 for _,n in ipairs(f.members)do if n~=f.og and alive(n)and not(n.assim=='Parker'and n.frenzyStarted)and not n.eating and not n.returningUntil and not n.transformUntil then
  local delta=position(n)-position(f.og);local distance=delta.Magnitude;local limit=radius(n)+radius(f.og)
  if distance<limit then
   local direction=distance>.001 and delta.Unit or Vector2.new(1,0)
   put(n,position(f.og)+direction*(limit+.025))
   local inward=n.velocity:Dot(direction);if inward<0 then n.velocity=n.velocity-direction*(2*inward)end
  end
 end end
end
local function fusionWarning(f)
 if not InvertedSilence.CanStart(f.og.model)then return end
 if f.warningEnd then return end
 f.warningEnd=f.t+4
 effect('FusionWarning',{Model=f.og.model,Duration=4,Text='Un danger imminent approche...'})
end
local function beginFusion(f)
 f.warningEnd=nil
 effect('FusionWarningEnd',{Model=f.og.model})
 f.fusionUsed=true;f.stage='Gather';f.stageEnd=f.t+5;f.saved={}
 f.waves={};f.blades={};f.fires={}
 for _,n in ipairs(f.members)do
  releaseContacts(n)
  f.saved[n]={hp=n.model:GetAttribute('Health'),max=n.model:GetAttribute('MaxHealth'),speed=n.model:GetAttribute('Speed'),damage=n.model:GetAttribute('CollisionDamage'),position=position(n),scale=n.model:GetScale(),velocity=n.motion and n.motion.velocity or n.velocity}
  n.model:SetAttribute('DeadlyInvulnerable',true);n.model:SetAttribute('DeadlyPhantom',n~=f.og)
 end
 f.savedVelocity=f.og.motion.velocity
 f.og.model:SetAttribute('DeadlyStage','Gather')
 effect('Charge',{Model=f.og.model,Duration=5,Color=V.Emerald})
end
local function stage(f)
 if not f.stage then return end
 if f.t>=f.stageEnd then
  if f.stage=='Gather'then f.stage='FlashIn';f.stageEnd=f.t+2.5;flash(f,true)
  elseif f.stage=='FlashIn'then
   flash(f,false);f.stage='Form';f.stageEnd=f.t+15
   f.og.model:SetAttribute('DeadlyShield',false);setHp(f.og,130,130);f.og.model:SetAttribute('Speed',40);f.og.model:SetAttribute('CollisionDamage',40);f.og.model:SetAttribute('DeadlyInvulnerable',false)
   put(f.og,Vector2.new(0,25));local angle=random:NextNumber(0,math.pi*2);f.og.motion.velocity=Vector2.new(math.cos(angle),math.sin(angle))*40;aura(f.og,V.Emerald,'DeadlyFusion');f.trailNext=f.t
  elseif f.stage=='Form'then
   f.stage='LaserCharge';f.stageEnd=f.t+4;f.laserOrigin=position(f.og);local d=f.enemy.position-f.laserOrigin
   f.laserDirection=d.Magnitude>.01 and d.Unit or Vector2.new(1,0);f.og.model:SetAttribute('DeadlyInvulnerable',true)
   effect('LaserWarning',{StartTime=now(),Model=f.og.model,Origin=Vector3.new(f.laserOrigin.X,f.laserOrigin.Y,f.og.depth),Direction=f.laserDirection,Width=36,Duration=4})
  elseif f.stage=='LaserCharge'then
   f.stage='Laser';f.stageEnd=f.t+4;f.laserTick=f.t;f.og.model:SetAttribute('DeadlyInvulnerable',false)
   effect('Laser',{StartTime=now(),Model=f.og.model,Origin=Vector3.new(f.laserOrigin.X,f.laserOrigin.Y,f.og.depth),Direction=f.laserDirection,Width=36,Duration=4})
  elseif f.stage=='Laser'then f.stage='FlashOut';f.stageEnd=f.t+2.5;f.og.model:SetAttribute('DeadlyInvulnerable',true);flash(f,true)
  elseif f.stage=='FlashOut'then
   flash(f,false)
   for _,n in ipairs(f.members)do local s=f.saved[n];if alive(n)then
    setHp(n,s.hp,s.max);n.model:SetAttribute('Speed',s.speed);n.model:SetAttribute('CollisionDamage',s.damage)
    n.model:SetAttribute('DeadlyInvulnerable',false);n.model:SetAttribute('DeadlyPhantom',false);n.model:SetAttribute('DeadlyMerged',false);n.model:ScaleTo(s.scale)
    if n.motion then n.motion.velocity=s.velocity;n.motion.radius=radius(n) else n.velocity=s.velocity end
    local p=n==f.og and position(n)or spot(radius(n),n.depth,n.model)or s.position;put(n,p)
   end end
   clearAura(f.og,'DeadlyFusion');f.og.model:SetAttribute('DeadlyStage',nil);f.stage=nil;return
  end
  f.og.model:SetAttribute('DeadlyStage',f.stage)
 end
 if f.stage=='Form'and f.t>=f.trailNext then
  f.trailNext=f.t+.12;local p=position(f.og);f.trails[#f.trails+1]={p=p,expires=f.t+5,r=radius(f.og),ticks={}}
  effect('Slime',{Position=Vector3.new(p.X,p.Y,f.og.depth+.8),Radius=radius(f.og),Duration=5})
 end
 if f.stage=='Laser'and f.t>=f.laserTick then
  f.laserTick=f.laserTick+.3
  for _,model in ipairs(enemyModels(f))do local p=xy(V.Head(model).Position);local d=p-f.laserOrigin;local forward=d:Dot(f.laserDirection);local side=math.abs(d.X*f.laserDirection.Y-d.Y*f.laserDirection.X)
   if forward>=0 and forward<=100 and side<=18 then damage(f.og,model,50,'DeadlyLaser')end
  end
 end
 local k=0
 for _,n in ipairs(f.members)do if n~=f.og and alive(n)then
  k=k+1;local a=f.t*9+k*math.pi/3;local dist=radius(f.og)*2.5
  if f.stage=='Gather'then local s=f.saved[n];local target=position(f.og)+Vector2.new(math.cos(a),math.sin(a))*dist;put(n,s.position:Lerp(target,math.clamp(1-(f.stageEnd-f.t)/5,0,1)))
  elseif f.stage=='Form'or f.stage=='FlashIn'then n.model:SetAttribute('DeadlyMerged',false);put(n,position(f.og)+Vector2.new(math.cos(a),math.sin(a))*dist)
  else n.model:SetAttribute('DeadlyMerged',true);put(n,position(f.og));end
 end end
end
-- PARKER_CONTACT_ONLY_v1 — wall hits never target an enemy.
local function rebound(n,wall)
 if wall and n.t>=(n.wallImpactAt or 0)then n.wallImpactAt=n.t+.1;effect('WallImpact',{Position=headpos(n),Model=n.model,Target=n.model})end
 if wall and n.assim=='Parker'and n.frenzyStarted and not state:GetAttribute('GhostNightActive')then n.remaining=n.remaining-1;n.legHits={};local p=position(n);local r=radius(n);local x,y=0,0;if p.X<=-24+r+.01 then x=1 elseif p.X>=24-r-.01 then x=-1 end;if p.Y<=5+r+.01 then y=1 elseif p.Y>=45-r-.01 then y=-1 end;local normal=Vector2.new(x,y);if normal.Magnitude<.001 then normal=-n.velocity end;effect('VoidDashBounce',{Model=n.model,Member='Parker',Remaining=n.remaining,Position=headpos(n),Normal=normal.Unit,Direction=n.velocity});if n.remaining<=0 then restoreVoid(n)end end
end
local function sweepEntry(a,b,center,r)
 local delta=b-a;local offset=a-center;local length2=delta:Dot(delta)
 if offset:Dot(offset)<=r*r then return 0 end
 if length2<1e-9 then return nil end
 local projection=offset:Dot(delta);local disc=projection*projection-length2*(offset:Dot(offset)-r*r)
 if disc<0 then return nil end
 local t=(-projection-math.sqrt(disc))/length2;return t>=0 and t<=1 and t or nil
end
local function dashHits(n,a,b)
 n.parkerTouches=n.parkerTouches or{}
 for model in pairs(n.parkerTouches)do if not model.Parent then n.parkerTouches[model]=nil end end
 for _,target in ipairs(enemyModels(n.family))do
  local blocked=M.SameTeam(n.model,target)or target:GetAttribute('DeadlyPhantom')or target:GetAttribute('DeadlyHPFrozen')or target:GetAttribute('FantasticInvisible')or target:GetAttribute('DeadlySpawning')or target:GetAttribute('VicePortalTransit')or target:GetAttribute('DeadlyInvulnerable')or target:GetAttribute('GhostInvulnerable')
  if not blocked and target.Parent and(target:GetAttribute('Health')or 0)>0 then
   local h=V.Head(target);local motion=M.GetMotion(target);local center=motion and motion.position or xy(h.Position)
   local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2
   local hit=sweepEntry(a,b,center,limit)
   if hit and not n.parkerTouches[target]then
    damage(n,target,15,'DeadlyParkerContact')
    require(SSS.CraxBurning).Apply(n.model,target)
    if state:GetAttribute('DeadlyDemoActive')then target:SetAttribute('BurningActive',true);target:SetAttribute('DeadlyDemoBurnUntil',now()+3)end
    effect('VoidDashHit',{Model=target,Owner=n.model,Member='Parker',Position=h.Position,Damage=15,OnWall=false})
   end
   n.parkerTouches[target]=(b-center).Magnitude<=limit+.05 and true or nil
  else n.parkerTouches[target]=nil end
 end
end

function M.Knockback(model,direction)
 local n=node(model);local impulse={velocity=direction*45,remaining=.28}
 if n and n.name~='OG'then n.knockback=impulse else local motion=M.GetMotion(model);if motion then motion.knockback=impulse end end
 effect('PulsarKnockback',{Model=model,Direction=direction,Duration=.28})
end
local function voidMovementObstacle(n,from,to)
 local delta=to-from
 if delta.Magnitude<.00001 then return nil end
 local filter={folder,n.model}
 for _,motion in ipairs(M.fighters)do if motion.model.Parent then filter[#filter+1]=motion.model end end
 local demoFolder=workspace:FindFirstChild('DeadlyDemonstration')
 if demoFolder then filter[#filter+1]=demoFolder end
 for _,name in ipairs({'ArenaBackdrop','ArenaFloor'})do
  local object=workspace:FindFirstChild(name,true)
  if object then filter[#filter+1]=object end
 end
 for _,player in ipairs(game:GetService('Players'):GetPlayers())do
  if player.Character then filter[#filter+1]=player.Character end
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 for attempt=1,8 do
  params.FilterDescendantsInstances=filter
  local hit=workspace:Raycast(from,delta,params)
  if not hit then return nil end
  local normal=Vector2.new(hit.Normal.X,hit.Normal.Y)
  local part=hit.Instance
  -- The XY simulation cannot bounce on front/back planes, or on invisible scenery.
  if (part:IsA('BasePart')and part.Transparency>=.98)or normal.Magnitude<.001 then
   filter[#filter+1]=part
  else
   normal=normal.Unit
   if n.velocity:Dot(normal)<-.0001 then return hit,normal end
   filter[#filter+1]=part
  end
 end
 return nil
end
-- Inserts before moveAlly. Every uninterrupted leg lasts 8/12 seconds.
-- PARKER_SPECULAR_100_v3. Arena [-24,24] x [5,45], reduced by actor radius.
local function parkerTimedMove(n,dt)
 if not n.frenzyStarted then
  if n.t<n.chargeEnd then return end
  n.frenzyStarted=true;size(n,1);n.parkerLeg=nil;n.parkerSpeed=100;n.parkerTouches={}
  n.velocity=n.velocity.Magnitude>.001 and n.velocity.Unit or Vector2.new(1,.63).Unit
  n.model:SetAttribute('CollisionDamage',15);n.model:SetAttribute('Speed',100)
  effect('Frenzy',{Model=n.model})
  effect('VoidDashStart',{Model=n.model,Member='Parker',Count=n.remaining or 20,Direction=n.velocity,Speed=100})
 end
 local slow=M.Slow(n.model)*(now()<(n.model:GetAttribute('SilkSlowUntil')or 0)and .6 or 1)
 local budget=math.max(0,dt)*100*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)*math.max(0,slow)
 local r=radius(n);local minX,maxX=-24+r,24-r;local minY,maxY=5+r,45-r
 assert(minX<maxX and minY<maxY,'PARKER : acteur trop grand pour l’arène.')
 n.p=Vector2.new(math.clamp(n.p.X,minX,maxX),math.clamp(n.p.Y,minY,maxY))
 local iterations=0
 while budget>1e-7 and n.assim=='Parker'and n.frenzyStarted do
  iterations=iterations+1
  if iterations>128 then break end
  local d=n.velocity.Unit
  local tx,ty=math.huge,math.huge
  if d.X>1e-9 then tx=(maxX-n.p.X)/d.X elseif d.X< -1e-9 then tx=(minX-n.p.X)/d.X end
  if d.Y>1e-9 then ty=(maxY-n.p.Y)/d.Y elseif d.Y< -1e-9 then ty=(minY-n.p.Y)/d.Y end
  tx=math.max(0,tx);ty=math.max(0,ty)
  local distance=math.min(tx,ty);local travel=math.min(budget,distance)
  local previous=n.p;n.p=n.p+d*travel
  n.p=Vector2.new(math.clamp(n.p.X,minX,maxX),math.clamp(n.p.Y,minY,maxY))
  dashHits(n,previous,n.p);budget=math.max(0,budget-travel)
  if travel>=distance-1e-7 then
   -- A corner is one physical contact: reflect both components, report once.
   local hitX=math.abs(tx-distance)<1e-7;local hitY=math.abs(ty-distance)<1e-7
   -- Choose a new inward direction only at an actual arena-wall contact.
   local x=hitX and(d.X>0 and -1 or 1)*random:NextNumber(.3,1)or random:NextNumber(-1,1)
   local y=hitY and(d.Y>0 and -1 or 1)*random:NextNumber(.3,1)or random:NextNumber(-1,1)
   n.velocity=Vector2.new(x,y).Unit
   put(n,n.p);rebound(n,true)
  else break end
 end
end

local function moveAlly(n,dt)
 if n.model:GetAttribute('VicePortalTransit')then return end
 if n.name=='OG'or n.eating or n.returningUntil or n.transformUntil or not alive(n)or Gate.Paused(n.model)or n.model:GetAttribute('DeadlyStunned')or n.model:GetAttribute('FantasticGrabbed')or(n.proxy and n.proxy.capturedBy)then return end
 if n.name=='Vice'and not n.model:GetAttribute('InvertedHacked')then
  local og=n.family.og;local orbit=radius(og)+radius(n)+.12
  n.orbitAngle=(n.orbitAngle or math.atan2((n.p-position(og)).Y,(n.p-position(og)).X))+dt*2.8*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)
  local center=position(og)
  center=Vector2.new(math.clamp(center.X,-24+orbit+radius(n),24-orbit-radius(n)),math.clamp(center.Y,5+orbit+radius(n),45-orbit-radius(n)))
  n.orbitCenter=n.orbitCenter and n.orbitCenter:Lerp(center,1-math.exp(-dt*35))or center
  n.orbitOffset=(n.orbitOffset or Vector2.zero)*math.exp(-dt*12)
  local wanted=n.orbitCenter+Vector2.new(math.cos(n.orbitAngle),math.sin(n.orbitAngle))*orbit+n.orbitOffset
  local previous=n.p;local delta=wanted-n.p
  n.p=n.p+delta*(1-math.exp(-dt*45))
  local displacement=n.p-previous;n.velocity=displacement.Magnitude>.001 and displacement.Unit or n.velocity
 elseif n.assim=='Parker'then parkerTimedMove(n,dt)
 else
  local speed=n.assim=='Parker'and(110+(n.boost and 2 or 0))or(n.model:GetAttribute('Speed')or 25)
  speed=speed*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)*M.Slow(n.model)*(now()<(n.model:GetAttribute('SilkSlowUntil')or 0)and .6 or 1)
  local previous=n.p;local r=radius(n);n.p=n.p+n.velocity*speed*dt
  local hit=false
  if n.p.X<-24+r or n.p.X>24-r then hit=true end
  if n.p.Y<5+r or n.p.Y>45-r then hit=true end
  if hit then
   if n.assim=='Parker'and n.frenzyStarted then
    local x=random:NextNumber(-1,1);local y=random:NextNumber(-1,1)
    if n.p.X<-24+r then x=math.max(.25,math.abs(x))elseif n.p.X>24-r then x=-math.max(.25,math.abs(x))end
    if n.p.Y<5+r then y=math.max(.25,math.abs(y))elseif n.p.Y>45-r then y=-math.max(.25,math.abs(y))end
    n.velocity=Vector2.new(x,y).Unit
   else
    n.velocity=Vector2.new((n.p.X<-24+r or n.p.X>24-r)and-n.velocity.X or n.velocity.X,(n.p.Y<5+r or n.p.Y>45-r)and-n.velocity.Y or n.velocity.Y)
   end
   n.p=Vector2.new(math.clamp(n.p.X,-24+r,24-r),math.clamp(n.p.Y,5+r,45-r));if n.assim=='Parker'and n.frenzyStarted then dashHits(n,previous,n.p)end;rebound(n,true)
  elseif n.name=='Void'and not(state:GetAttribute('DeadlyDemoActive')and n.assim=='Vice')then
   local hit,normal=voidMovementObstacle(n,Vector3.new(previous.X,previous.Y,n.depth),Vector3.new(n.p.X,n.p.Y,n.depth))
   if hit then
    n.p=previous
    n.velocity=n.velocity-normal*(2*n.velocity:Dot(normal))
    effect('WallImpact',{Position=headpos(n),Model=n.model,Target=n.model})
   elseif n.assim=='Parker'and n.frenzyStarted then dashHits(n,previous,n.p)end
  elseif blocked(Vector3.new(previous.X,previous.Y,n.depth),Vector3.new(n.p.X,n.p.Y,n.depth))then n.p=previous;n.velocity=-n.velocity
  end
 end
 if n.knockback then local k=n.knockback;n.p=n.p+k.velocity*dt;k.velocity=k.velocity*math.exp(-8*dt);k.remaining=k.remaining-dt;if k.remaining<=0 then n.knockback=nil end end
 local r=radius(n);n.p=Vector2.new(math.clamp(n.p.X,-24+r,24-r),math.clamp(n.p.Y,5+r,45-r))
 put(n,n.p)
end
local function pulse(n,dt)
 local f=n.family;f.blades=f.blades or {}
 if n.pulse then
  local q=n.pulse
  if n.t+1e-6>=q.next and q.remaining>0 then
   local origin=xy(headpos(n));local delta=q.aim-origin;local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
   n.bladeSequence=(n.bladeSequence or 0)+1
   local id=n.model.Name..'_blade_'..n.bladeSequence
   local blade={id=id,p=origin,direction=direction,speed=42,width=2*math.max(1.15,radius(n)*.8),remaining=2,owner=n}
   f.blades[#f.blades+1]=blade
   effect('VoidPulsarWave',{Index=4-q.remaining,Id=id,Position=Vector3.new(origin.X,origin.Y,headpos(n).Z),Direction=direction,Speed=42,Width=blade.width,Duration=2,Model=n.model})
   q.remaining=q.remaining-1;q.next=q.next+.35;n.pulsarUntil=n.t+.4
   if q.remaining==0 then n.pulse=nil end
  end
 elseif InvertedSilence.CanStart(n.model)and n.t>=n.nextPulsar then
  local target=M.GetMotion(f.enemy.model);local aim=target and target.position or xy(V.Head(f.enemy.model).Position)
  n.nextPulsar=n.t+15;n.pulse={remaining=3,next=n.t+.7,aim=aim};n.pulsarUntil=n.t+3.4
  effect('PowerNotice',{Model=n.model,Member='Void',Text='VOID : PULSAR !!',Duration=2})
  effect('PulsarCinematic',{Model=n.model,Duration=1.1})
  effect('VoidBladeCharge',{Model=n.model,Position=headpos(n),Radius=radius(n),Duration=.7})
 end
end
local function bladeStep(f,dt)
 for i=#(f.blades or {}),1,-1 do
  local blade=f.blades[i];local owner=blade.owner
  local finish=blade.p+blade.direction*blade.speed*math.min(dt,math.max(0,blade.remaining));local delta=finish-blade.p
  local length2=delta:Dot(delta);local hits={}
  blade.hitTargets=blade.hitTargets or {}
  if alive(owner)and not owner.assim and not f.stage then
   for _,target in ipairs(enemyModels(f))do
    if not blade.hitTargets[target]and not target:GetAttribute('DeadlyPhantom')and not target:GetAttribute('DeadlyMerged')and not target:GetAttribute('FantasticInvisible')and not target:GetAttribute('DeadlySpawning')then
     local motion=M.GetMotion(target);local center=motion and motion.position or xy(V.Head(target).Position)
     local h=V.Head(target);local radius=math.max(h.Size.X,h.Size.Y)/2+blade.width*1.9
     local offset=blade.p-center;local projection=offset:Dot(delta);local discriminant=projection*projection-length2*(offset:Dot(offset)-radius*radius)
     local hit=offset:Dot(offset)<=radius*radius and 0 or nil
     if not hit and length2>1e-9 and discriminant>=0 then local t=(-projection-math.sqrt(discriminant))/length2;if t>=0 and t<=1 then hit=t end end
     if hit then hits[#hits+1]={target=target,t=hit}end
    end
   end
  else blade.remaining=0 end
  table.sort(hits,function(a,b)return a.t<b.t end)
  for _,hit in ipairs(hits)do
   local target=hit.target;blade.hitTargets[target]=true
   local impact=blade.p+delta*hit.t
   damage(owner,target,15,'DeadlyDarkBlade')
   -- Knockback is retained only when it was present in the installed version.
   M.Knockback(target,blade.direction)
   effect('VoidBladeEnd',{Id=blade.id,Position=Vector3.new(impact.X,impact.Y,owner.depth),Hit=true,Continue=true})
  end
  blade.remaining=blade.remaining-dt;blade.p=finish
  if blade.remaining<=0 or finish.X< -30 or finish.X>30 or finish.Y<0 or finish.Y>50 then
   effect('VoidBladeEnd',{Id=blade.id});table.remove(f.blades,i)
  end
 end
end

local function activePulsar(n)
 if n.pulse then return true end
 for _,wave in ipairs(n.family.blades or {})do if wave.owner==n then return true end end
 return n.t<(n.pulsarUntil or 0)
end
-- VICE_CONCURRENT_TRANSIT_v2
M.vicePortalPairs={}
local function finishPair(pair)
 if pair.closing and not next(pair.active)then
  M.vicePortalPairs[pair.id]=nil;effect('ClosePortals',{Id=pair.id})
 end
end
function M.RequestVicePortalClose(id)
 local pair=M.vicePortalPairs[id]
 if pair then pair.closing=true;finishPair(pair)else effect('ClosePortals',{Id=id})end
end
local function releaseTransit(model,tr)
 M.viceTransits[model]=nil
 local pair=M.vicePortalPairs[tr.pairId]
 if pair then pair.active[model]=nil;finishPair(pair)end
end
local function cancelViceTransits()
 for model in pairs(M.viceTransits or{})do Gate.Resume(model,'VicePortalTransit');if model.Parent then model:SetAttribute('VicePortalTransit',false)end end
 M.viceTransits={}
 for _,pair in pairs(M.vicePortalPairs)do pair.active={};pair.closing=true;finishPair(pair)end
end
local function beginViceTransit(n,entry,portal,dest,exit,dir)
 local model=entry.model;if M.viceTransits[model]or not n.portalId then return end
 local pair=M.vicePortalPairs[n.portalId]
 if not pair then pair={id=n.portalId,active={}};M.vicePortalPairs[n.portalId]=pair end
 if pair.closing then return end
 -- Reserve exits globally: two portal owners cannot allocate the same landing area.
 local r=entry.motion and entry.motion.radius or (entry.ally and radius(entry.ally))or 1.5
 r=math.max(.25,r or 1.5)
 local function vacant(p)
  if p.X-r < -24 or p.X+r > 24 or p.Y-r < 5 or p.Y+r > 45 then return false end
  for _,other in pairs(M.viceTransits)do
   if (other.exit-p).Magnitude < r+other.radius+.15 then return false end
  end
  return true
 end
 if not vacant(exit)then
  local found
  for ring=1,5 do
   for i=0,23 do
    local angle=i*math.pi/12
    local candidate=dest+Vector2.new(math.cos(angle),math.sin(angle))*((n.portalRadius or 2)+r+.75+ring*r*2.2)
    if vacant(candidate)then found=candidate;break end
   end
   if found then break end
  end
  if not found then return end -- Full exits: actor keeps moving; no pause and no queued lock.
  exit=found;dir=(exit-dest).Unit
 end
 if M.demo and model==M.demo.target.model then M.demo.viceApproach=nil end
 local velocity=entry.motion and entry.motion.velocity or entry.ally.velocity
 local incoming=velocity.Magnitude>.001 and velocity.Unit or Vector2.new(1,0)
 dir=dir.Magnitude>.001 and dir.Unit or incoming
 local from=model:GetPivot();local depth=entry.motion and entry.motion.depth or entry.ally.depth
 local tr={pairId=pair.id,radius=r,allied=M.SameTeam(n.model,model),entry=entry,owner=n,exit=exit,direction=dir,age=0,duration=1.1,committed=false,from=from,to=CFrame.new(exit.X,exit.Y,depth)*from.Rotation}
 M.viceTransits[model]=tr;pair.active[model]=true;n.teleports[model]=n.t+4
 Gate.Resume(model,'VicePortalTransit');model:SetAttribute('VicePortalTransit',true)
 effect('VicePortalTransit',{Model=model,Owner=n.model,Id=n.portalId,Entry=Vector3.new(portal.X,portal.Y,depth),Exit=Vector3.new(dest.X,dest.Y,depth),FromCF=from,ToCF=tr.to,Direction=dir,EntryDirection=incoming,EntryIndex=(n.portals and portal==n.portals[1])and 1 or 2,StartTime=now(),Duration=tr.duration})
end
local function placeViceExit(model,tr)
 local entry=tr.entry;local direction=tr.direction
 if entry.motion then
  local motion=entry.motion;motion.position=tr.exit;motion.velocity=direction*math.max(1,model:GetAttribute('Speed')or motion.speed or 14)
 else entry.ally.p=tr.exit;entry.ally.velocity=direction end
 model:PivotTo(tr.to)
end
local function stepViceTransits(dt)
 if state:GetAttribute('GhostNightActive')or M.Flash()or now()<(state:GetAttribute('GhostFreezeUntil')or 0)then return end
 for model,tr in pairs(M.viceTransits)do
  if not model.Parent then
   Gate.Resume(model,'VicePortalTransit');if model.Parent then model:SetAttribute('VicePortalTransit',false)end;releaseTransit(model,tr)
  else
   tr.age=tr.age+dt
   if not tr.committed and tr.age>=.5 then
    tr.committed=true;placeViceExit(model,tr)
    local allied=tr.allied;local before=model:GetAttribute('Health')or 0
    if allied then SSS.CraxHeal:Fire(model,5,tr.owner.model)elseif tr.owner.model.Parent then damage(tr.owner,model,15,'DeadlyPortal')end
    task.defer(function()
     if model.Parent then
      local after=model:GetAttribute('Health')or 0;local amount=(before==math.huge or after==math.huge)and 0 or math.max(0,allied and after-before or before-after)
      effect('VicePortalResult',{Model=model,Owner=tr.owner.model,Allied=allied,Amount=amount})
     end
    end)
   end
   if tr.age>=tr.duration then
    placeViceExit(model,tr);Gate.Resume(model,'VicePortalTransit');model:SetAttribute('VicePortalTransit',false)
    tr.owner.teleports[model]=tr.owner.t+4
    effect('VicePortalExit',{Model=model,ToCF=tr.to});releaseTransit(model,tr)
   end
  end
 end
end
local viceTransitClock=game:GetService('RunService').Heartbeat:Connect(function(dt)
 if not state:GetAttribute('DeadlyDemoActive')and state:GetAttribute('Phase')~='Fighting'then if next(M.viceTransits)then cancelViceTransits()end;return end
 stepViceTransits(math.min(dt,.1))
end)

local function voidStep(n,dt)
 local f=n.family
 if n.eating then eatStep(n);return end
 if n.returningUntil then
  if n.t<n.returningUntil then return end
  n.returningUntil=nil;n.model:SetAttribute('DeadlyTransitioning',false)
 end
 if n.transformUntil then
  if n.t<n.transformUntil then return end
  n.transformUntil=nil;n.model:SetAttribute('DeadlyTransitioning',false)
  if n.assim=='Parker'then effect('Charge',{Model=n.model,Member='Parker',Duration=2.5,Color=V.Colors.Parker,Direction=n.velocity})end
 end
 if not n.assim then
  pulse(n,dt)
  if not f.warningEnd and level(f)>=2 and not n.used and not activePulsar(n)and n.t>=(n.firstPulsarAt or 0)and n.t>=(n.pulsarUntil or 0)then
   for _,a in ipairs(f.members)do if a~=n and a.name~='OG'and alive(a)and(position(a)-position(n)).Magnitude<=radius(a)+radius(n)then beginAssimilation(n,a);break end end
  end
  return
 end
 if n.t>=n.assimEnd or n.breakProtection then
 if n.assim=='Dodger'and n.breakProtection then effect('DodgerShieldBreak',{Model=n.model,Member='Dodger'})end
 n.breakProtection=nil;restoreVoid(n);return end
 if n.assim=='Domino'then
  if n.grid and n.t>=n.grid.resolve then
   local g=n.grid;n.grid=nil
   for _,model in ipairs(enemyModels(f))do local p=xy(V.Head(model).Position);local col=math.clamp(math.floor((p.X+24)/16),0,2);local row=math.clamp(math.floor((p.Y-5)/(40/3)),0,2)
    local value=g.values[row*3+col+1]
    damage(n,model,value*10,'DeadlyDice')
    effect('DominoVerdictImpact',{Model=n.model,Target=model,Value=value,Amount=value*10,Position=V.Head(model).Position})
   end
   effect('DiceHit',{Values=g.values,Model=n.model,Depth=n.depth})
  end
  if InvertedSilence.CanStart(n.model)and n.t>=n.nextGrid then
   local values={0,1,2,3,4,5,6,7,8};for i=9,2,-1 do local j=random:NextInteger(1,i);values[i],values[j]=values[j],values[i]end
   n.grid={values=values,resolve=n.t+3};n.nextGrid=n.nextGrid+8;effect('Grid',{Values=values,Duration=3,Depth=n.depth,Model=n.model})
  end
 elseif n.assim=='Vice'then
  if n.portals and f.t>=n.portalEnd then portalsClose(n);n.nextPortal=n.t+random:NextNumber(3,8)end
  if InvertedSilence.CanStart(n.model)and not n.portals and n.t>=n.nextPortal then
   local reference=workspace:FindFirstChild('Fighter1');local normalHead=reference and V.Head(reference);local r=(normalHead and normalHead.Size.X or V.Head(n.model).Size.X)*.75;n.portalRadius=r;local a=spot(r,n.depth);local b=spot(r,n.depth)
   if a and b and(a-b).Magnitude>r*3 then n.portals={a,b};n.portalReadyAt=f.t+.4;n.portalEnd=f.t+5;n.portalId=n.model.Name..'_'..tostring(n.t);n.teleports={}
    if M.demo and M.demo.waitMember=='Vice'then
     M.demo.viceApproach={owner=n,p=a}
    end
    effect('Portals',{Id=n.portalId,Model=n.model,Member='Vice',A=Vector3.new(a.X,a.Y,n.depth),B=Vector3.new(b.X,b.Y,n.depth),Radius=r,Duration=5})
   else n.nextPortal=n.t+.25 end
  end
  if n.portals and f.t>=(n.portalReadyAt or 0)then
   local list={};for _,main in ipairs(M.fighters)do list[#list+1]={model=main.model,motion=main}end
   for _,a in pairs(M.nodes)do if a.name~='OG'and alive(a)then list[#list+1]={model=a.model,ally=a}end end
   for _,entry in ipairs(list)do
    local p=entry.motion and entry.motion.position or position(entry.ally);local h=V.Head(entry.model);local r=h.Size.X/2
    if not entry.model:GetAttribute('VicePortalTransit')and not entry.model:GetAttribute('DeadlyDemoRespawning')and not entry.model:GetAttribute('DemoRespawning')and not entry.model:GetAttribute('DeadlyPhantom')and not entry.model:GetAttribute('DeadlyMerged')and n.t>=(n.teleports[entry.model]or 0)then
     for i,portal in ipairs(n.portals)do if(p-portal).Magnitude<=(n.portalRadius or radius(n)*1.5)then
      local dest=n.portals[3-i];local vel=entry.motion and entry.motion.velocity or entry.ally.velocity
      local dir=vel.Magnitude>.001 and vel.Unit or Vector2.new(1,0);local exit=dest+dir*((n.portalRadius or radius(n)*1.5)+r+.5)
      if not free(exit,r,n.depth,entry.model)then
       exit=nil
       for attempt=0,11 do
        local angle=math.atan2(dir.Y,dir.X)+attempt*math.pi/6
        local candidate=dest+Vector2.new(math.cos(angle),math.sin(angle))*((n.portalRadius or radius(n)*1.5)+r+.75)
        if candidate.X>=-24+r and candidate.X<=24-r and candidate.Y>=5+r and candidate.Y<=45-r then exit=candidate;break end
       end
      end
      if exit then
       local travel=exit-dest;local exitDir=travel.Magnitude>.001 and travel.Unit or dir
       beginViceTransit(n,entry,portal,dest,exit,exitDir)
      end
      break
     end end
    end
   end
  end
 elseif n.assim=='Stack'then
  stackUpdate(n,false)
 elseif n.assim=='Parker'and n.frenzyStarted and n.t>=(n.fireNext or 0)then
  n.fireNext=n.t+.12;f.fires[#f.fires+1]={p=position(n),expires=f.t+3,r=radius(n),owner=n};effect('FirePatch',{Position=headpos(n),Radius=radius(n),Duration=3,Model=n.model,Member='Parker'})
 end
end
local function separateContact(n,model)
 local other=M.GetMotion(model);local h=V.Head(model);if not h then return end
 local p=other and other.position or xy(h.Position);local delta=p-position(n);local dist=delta.Magnitude
 local normal=dist>.001 and delta.Unit or(n.velocity.Magnitude>.001 and n.velocity.Unit or Vector2.new(1,0))
 local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2
 local separation=normal*math.max(0,limit-dist+.035)
 local pinned=M.Hold(model)or model:GetAttribute('FantasticPinned')or(other and other.capturedBy)
 local before=position(n);put(n,before-separation*(pinned and 1 or .5))
 if n.name=='Vice'then n.orbitOffset=(n.orbitOffset or Vector2.zero)+(position(n)-before)end
 if other and not pinned then other.position=other.position+separation*.5;other.model:PivotTo(CFrame.new(other.position.X,other.position.Y,other.depth)*other.rotation)end
 local vn=n.velocity:Dot(normal);if vn>0 then n.velocity=n.velocity-normal*(2*vn)end
 if other and not pinned then local v=other.velocity;local inward=v:Dot(normal);if inward<0 then other.velocity=v-normal*(2*inward)end end
end
local function contact(n,dt)
 if n.model:GetAttribute('VicePortalTransit')then return end
 if n.model:GetAttribute('DeadlyDemoSupport')then return end
 if n.eating or n.returningUntil or n.transformUntil or(n.assim=='Parker'and n.frenzyStarted)or not alive(n)or n.model:GetAttribute('DeadlyPhantom')or Gate.Paused(n.model)then return end
 for _,model in ipairs(enemyModels(n.family))do
  local h=V.Head(model);local motion=M.GetMotion(model);local p=motion and motion.position or xy(h.Position)
  local limit=radius(n)+math.max(h.Size.X,h.Size.Y)/2;local distance=(p-position(n)).Magnitude
  local enemyNode=node(model);local blocked=model:GetAttribute('VicePortalTransit')or(enemyNode and enemyNode.assim=='Parker'and enemyNode.frenzyStarted)or model:GetAttribute('DeadlyPhantom')or model:GetAttribute('DeadlyMerged')or model:GetAttribute('DeadlySpawning')or model:GetAttribute('FantasticInvisible')or model:GetAttribute('FantasticGrabbed')or n.model:GetAttribute('FantasticGrabbed')
  if not blocked and distance<=limit then
   local fresh=not n.contacts[model];n.contacts[model]=true
   if fresh then
    contactHit(n,model)
    if not alive(n)or(state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive'))then return end
    if n.name=='Domino'and InvertedSilence.CanStart(n.model)then
     n.stunTargets=n.stunTargets or {};n.stunTargets[model]=n.family.t+2.5;stun(model,n.model,true)
     effect('StunImpact',{Model=model,Duration=2.5});effect('PowerNotice',{Model=n.model,Member='Domino',Text='DOMINO : CONFUSION',Duration=2.5})
    end
    local opposing=node(model)
    if opposing and opposing.name=='Domino'and InvertedSilence.CanStart(opposing.model)then opposing.stunTargets=opposing.stunTargets or {};opposing.stunTargets[n.model]=opposing.family.t+2.5;stun(n.model,opposing.model,true);effect('PowerNotice',{Model=opposing.model,Member='Domino',Text='DOMINO : CONFUSION',Duration=2.5});effect('StunImpact',{Model=n.model,Duration=2.5})end
    if not state:GetAttribute('GhostNightActive')then effect('ContactImpact',{Position=h.Position,Model=n.model,Target=model})end
    -- STACK reset is performed after the collision snapshot, for either participant.
    rebound(n)
   end
   separateContact(n,model)
  elseif blocked or distance>limit+.15 then n.contacts[model]=nil end
 end
end
local function stunStep(f)
 for _,n in ipairs(f.members)do if n.stunTargets then for model,expires in pairs(n.stunTargets)do
  if f.t>=expires or not alive(n)or not model.Parent or(model:GetAttribute('Health')or 0)<=0 then stun(model,n.model,false);n.stunTargets[model]=nil end
 end end end
end
local function nightMove(f,dt)
 for _,n in ipairs(f.members)do releaseContacts(n)
  if n~=f.og and alive(n)then
   local previous=position(n)
   if f.stage then local angle=now()*2.2;local i=table.find(f.members,n)or 1;put(n,position(f.og)+Vector2.new(math.cos(angle+i),math.sin(angle+i))*radius(f.og)*2.5)
   else
    local r=radius(n);local speed=stats[n.name][2];local p=previous+n.velocity*speed*dt
    n.velocity=Vector2.new((p.X<-24+r or p.X>24-r)and-n.velocity.X or n.velocity.X,(p.Y<5+r or p.Y>45-r)and-n.velocity.Y or n.velocity.Y)
    put(n,Vector2.new(math.clamp(p.X,-24+r,24-r),math.clamp(p.Y,5+r,45-r)))
   end
   if n.eating and n.eating.target.model.Parent then local delta=position(n)-previous;n.eating.position=n.eating.position+delta;put(n.eating.target,position(n.eating.target)+delta)end
  end
 end
end
function M.Bind(fighters)M.fighters=fighters end
local function cleanup(keepAim)
 cancelViceTransits()
 if not keepAim then for model,entry in pairs(M.aimSpawns)do finishAim(model,entry,false)end end
 for _,f in pairs(M.families)do
  flash(f,false)
  for _,n in ipairs(f.members)do
   releaseContacts(n)
   if n.name~='OG'then if M.Health then M.Health.Unregister(n.model)end;Gate.Reset(n.model);if n.model.Parent then n.model:Destroy()end end
  end
  if f.og.model.Parent then for _,key in ipairs({'DeadlyInvulnerable','DeadlyHPFrozen','DeadlyPhantom','DeadlyStage','DeadlyMerged','DeadlyShield','DeadlyFamilyBoost','DeadlyRage','DeadlyAssimilation','DeadlyTransitioning','DeadlyBeingEaten'})do f.og.model:SetAttribute(key,nil)end end
 end
 for _,main in ipairs(M.fighters)do clearAura({model=main.model},'DeadlyFusion')end
 M.families={};M.nodes={};M.cinematics={};stunSources=setmetatable({},{__mode='k'});state:SetAttribute('DeadlyFlashCount',0)
 for _,f in ipairs(M.fighters)do f.model:SetAttribute('DeadlyStunned',false);f.model:SetAttribute('DeadlySlowUntil',nil);f.model:SetAttribute('DeadlySlimeTick',nil)end
 if not keepAim then effect('Clear')end
end
local function start()
 cleanup(true)
 for i,motion in ipairs(M.fighters)do
  if motion.model:GetAttribute('CraxId')=='Crax_Deadly'and M.Health then
   local f={members={},byName={},og=nil,enemy=M.fighters[3-i],t=0,elapsed=0,nextSpawn=8,spawnIndex=1,order={'Domino','Parker','Dodger','Vice','Stack','Void'},trails={},fires={},waves={},blades={}}
   for j=5,2,-1 do local k=random:NextInteger(1,j);f.order[j],f.order[k]=f.order[k],f.order[j]end
   local n={model=motion.model,name='OG',family=f,motion=motion,depth=motion.depth,rotation=motion.rotation,baseScale=motion.model:GetScale(),contacts={},boost=false,t=0}
   f.og=n;f.members={n};f.byName.OG=n;M.families[motion.model]=f;M.nodes[motion.model]=n
  end
 end
end
function M.CancelLucky(model)cleanup();M.luckyRestart=true end
function M.Step(dt,fighters)
 if M.luckyRestart then local blocked=false;for _,f in ipairs(fighters)do if f.model:GetAttribute('LuckyTricked')then blocked=true end end;if not blocked then start();M.luckyRestart=false end end
 if M.demo and fighters~=M.demo.motions then return end
 -- VOID_DemoFix_v1
 -- Seule la boucle de démonstration peut avancer ses acteurs.
 if M.demo and fighters~=M.demo.motions then return end
 M.fighters=fighters
 local phase=state:GetAttribute('DeadlyDemoActive')and 'Fighting'or state:GetAttribute('Phase')
 if phase~=M.lastPhase then
  M.lastPhase=phase
  if phase=='Fighting'then start()
  elseif phase~='RoundOver'then cleanup()end
  if phase=='RoundOver'then M.cinematics={}
   for _,family in pairs(M.families)do flash(family,false);local vn=family.byName.Void;if vn then portalsClose(vn)end
    for _,n in ipairs(family.members)do releaseContacts(n);if n.model.Parent then n.model:SetAttribute('DeadlyMerged',false);n.model:SetAttribute('DeadlyPhantom',false);n.model:SetAttribute('DeadlyHPFrozen',false)end end
    if alive(family.og)then size(family.og,1);clearAura(family.og,'DeadlyFusion')end
   end
   for _,main in ipairs(M.fighters)do main.model:SetAttribute('DeadlyInvulnerable',false);main.model:SetAttribute('DeadlyHPFrozen',false);main.model:SetAttribute('DeadlyPhantom',false)end
   effect('Clear')
  end
  if phase=='Aiming'then for _,f in ipairs(fighters)do if f.model:GetAttribute('CraxId')=='Crax_Deadly'then beginAim(f)end end end
 end
 if phase=='Aiming'or phase=='Fighting'then aimStep(dt)end
 if phase~='Fighting'then cancelViceTransits();return end
 for _,f in pairs(M.families)do
  if not alive(f.og)then M.OnDeath(f.og.model)
  else
   f.elapsed=f.elapsed+dt
   if not f.stage and not f.pendingSpawn and not state:GetAttribute('GhostNightActive')and not M.Flash()and f.spawnIndex<=6 and f.elapsed>=f.nextSpawn-1.5 then
    if spawn(f,f.order[f.spawnIndex])then f.spawnIndex=f.spawnIndex+1;f.nextSpawn=f.spawnIndex*8 end
   end
   if state:GetAttribute('GhostNightActive')and not M.Flash()and now()>=(state:GetAttribute('GhostFreezeUntil')or 0)then nightMove(f,dt)end
   local paused=state:GetAttribute('GhostNightActive')or(state:GetAttribute('GhostFreezeUntil')or 0)>now()
   -- Own flash advances its sequence, while every other simulation is paused.
   if f.flashing or(not paused and not M.Flash())then
    f.t=f.t+dt;stunStep(f)
    if not f.stage then spawnStep(f,dt)end
    if f.t>=(f.boostAt or 0)then f.boostAt=f.t+.05;boost(f)end
    if f.warningEnd then
     if #living(f)<7 then f.warningEnd=nil;effect('FusionWarningEnd',{Model=f.og.model})
     elseif f.t>=f.warningEnd then beginFusion(f)end
    elseif not f.stage and level(f)>=3 and not f.fusionUsed and #living(f)==7 then fusionWarning(f)end
    if f.stage then if f.flashing or not Gate.Paused(f.og.model)then stage(f)else f.stageEnd=f.stageEnd+dt end
    elseif not M.Flash()then
     local vice=f.byName.Vice
     -- Node clocks advance independently from OG's stun.
     for _,n in ipairs(f.members)do if alive(n)and not Gate.Paused(n.model)then n.t=(n.t or f.t-dt)+dt end end
     if alive(vice)and InvertedSilence.CanStart(vice.model)and not Gate.Paused(vice.model)and vice.t>=vice.nextHeal then vice.nextHeal=vice.t+2.5;local before=f.og.model:GetAttribute('Health')or 0;if before>0 and before<(f.og.model:GetAttribute('MaxHealth')or 90)and not f.og.model:GetAttribute('DeadlyHPFrozen')then SSS.CraxHeal:Fire(f.og.model,5,vice.model)end end
     for _,n in ipairs(f.members)do if n.name~='OG'and alive(n)then
      if n.name=='Void'and not Gate.Paused(n.model)then voidStep(n,dt)end
      moveAlly(n,dt*M.CinematicScale());contact(n,dt)
      if state:GetAttribute('Phase')~='Fighting'and not state:GetAttribute('DeadlyDemoActive')then return end
     end end
    end
    familyContact(f);bladeStep(f,dt)
    for j=#f.waves,1,-1 do local w=f.waves[j];local age=f.t-w.start;local r=w.radius*math.clamp(age/w.duration,0,1)
     for _,target in ipairs(enemyModels(f))do if target.Parent and not w.hit[target]then local h=V.Head(target);local d=(xy(h.Position)-xy(w.origin)).Magnitude
      if d<=r+h.Size.X/2 and not blocked(w.origin,h.Position)then w.hit[target]=true;damage(w.owner,target,15,'DeadlyPulsar')end
     end end
     if age>=w.duration then table.remove(f.waves,j)end
    end
    -- LEVEL3_CONTACT_FIX_v2: fusion trails are visual only, never damage or slow targets.
    for j=#f.trails,1,-1 do if f.t>=f.trails[j].expires then table.remove(f.trails,j)end end
    for j=#f.fires,1,-1 do local fire=f.fires[j]
     if f.t>=fire.expires then table.remove(f.fires,j)
     end -- PARKER fire trails are visual only; BRULURE starts exclusively on enemy contact.
    end
   end
  end
 end
 for _,f in ipairs(fighters)do
  f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2
  if f.model:GetAttribute('CraxId')=='Crax_Deadly'and not M.Hold(f.model)then local speed=f.model:GetAttribute('Speed')or f.speed;if f.velocity.Magnitude>.001 then f.velocity=f.velocity.Unit*speed end;f.speed=speed end
 end
end
-- Studio-only isolated showcase. Never changes player inventory or skill unlocks.
function M.StopDemo()
 local d=M.demo;if not d then return end;M.demo=nil
 if d.connection then d.connection:Disconnect()end
 cleanup()
 for _,motion in ipairs(d.motions)do if M.Health then M.Health.Unregister(motion.model)end end
 if d.detachedTarget then d.detachedTarget:Destroy()end
 if d.folder.Parent then d.folder:Destroy()end
 M.fighters=d.originalFighters;M.lastPhase=nil
 state:SetAttribute('StackDemoPart',nil);state:SetAttribute('StackDemoFinished',nil)
 state:SetAttribute('DeadlyDemoActive',false);state:SetAttribute('Phase','Waiting')
 effect('DemoSceneEnd')
end
-- Sub-stepped swept circles: Studio showcase roots use their actual visible head radii.
local function level3DemoMove(root,og,target,dt)
 local steps=math.max(1,math.ceil(dt/.0125));local sub=dt/steps
 local r=math.max(V.Head(og.model).Size.X,V.Head(og.model).Size.Y)/2
 local h=V.Head(target.model);local tr=math.max(h.Size.X,h.Size.Y)/2;local limit=r+tr
 root.contacts=root.contacts or{}
 for _=1,steps do
  local previous=og.position;local desired=previous+og.velocity*sub
  if desired.X<-24+r or desired.X>24-r then og.velocity=Vector2.new(-og.velocity.X,og.velocity.Y)end
  if desired.Y<5+r or desired.Y>45-r then og.velocity=Vector2.new(og.velocity.X,-og.velocity.Y)end
  desired=Vector2.new(math.clamp(desired.X,-24+r,24-r),math.clamp(desired.Y,5+r,45-r))
  local enabled=target.model.Parent and(target.model:GetAttribute('Health')or 0)>0 and not target.model:GetAttribute('DemoRespawning')and not target.model:GetAttribute('DeadlyDemoRespawning')and not target.model:GetAttribute('DeadlyPhantom')and not target.model:GetAttribute('VicePortalTransit')
  local entry=enabled and sweepEntry(previous,desired,target.position,limit)
  if entry then
   local impact=previous+(desired-previous)*entry;local delta=target.position-impact
   local normal=delta.Magnitude>.0001 and delta.Unit or(og.velocity.Magnitude>.0001 and og.velocity.Unit or Vector2.new(1,0))
   desired=target.position-normal*(limit+.04)
   -- At a wall choose the nearest valid separating point, never leave bodies interpenetrating.
   if desired.X<-24+r or desired.X>24-r or desired.Y<5+r or desired.Y>45-r then
    local best,distance=nil,math.huge
    for i=0,31 do
     local a=i*math.pi/16;local p=target.position+Vector2.new(math.cos(a),math.sin(a))*(limit+.04)
     if p.X>=-24+r and p.X<=24-r and p.Y>=5+r and p.Y<=45-r then local d=(p-impact).Magnitude;if d<distance then best=p;distance=d end end
    end
    if best then desired=best;normal=(target.position-best).Unit end
   end
   local toward=og.velocity:Dot(normal);if toward>0 then og.velocity=og.velocity-normal*(2*toward)end
   local incoming=target.velocity:Dot(normal);if incoming<0 then target.velocity=target.velocity-normal*(2*incoming)end
   put(root,desired)
   if not root.contacts[target.model]then
    root.contacts[target.model]=true
    contactHit(root,target.model)
    effect('ContactImpact',{Position=h.Position,Model=root.model,Target=target.model})
   end
  elseif not enabled or(desired-target.position).Magnitude>limit+.15 then root.contacts[target.model]=nil end
  put(root,desired)
 end
end

function M.StartDemo(mode)
 assert(game:GetService('RunService'):IsServer(),
  'Lance la démonstration côté Serveur.')
 local Run=game:GetService('RunService')
 assert(Run:IsStudio()and Run:IsRunning(),'La démonstration est réservée à Play dans Roblox Studio.')
 assert(M.Health,'Attends le chargement du pack.')
 if M.demo then M.StopDemo()end
 assert(state:GetAttribute('Phase')~='Fighting','Arrête le duel puis lance Play sans démarrer de combat.')
 mode=string.upper(mode or 'ASSIMILATIONS')
 local choices={ASSIMILATIONS=true,NIVEAU3=true,APPARITION=true,TOUT=true,PARKER=true,DOMINO=true,DODGER=true,VICE=true,STACK=true}
 assert(choices[mode],'Modes : ASSIMILATIONS, NIVEAU3, APPARITION, TOUT ou un nom d’allié.')
 local originals=M.fighters;cleanup()
 local group=Instance.new('Folder');group.Name='DeadlyDemonstration';group.Parent=workspace
 local base=game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase')
 local function actor(member,name,p,hp)
  local model=V.Make(base,member,.5);model.Name=name
  local h=V.Head(model);local reference=workspace:FindFirstChild('Fighter1')
local referenceHead=reference and V.Head(reference)
local width=referenceHead and referenceHead.Size.X or 6
model:ScaleTo(model:GetScale()*width/h.Size.X)
for _,part in ipairs(model:GetDescendants()) do
 if part:IsA('BasePart') then
  part.Anchored=true
  part.CanCollide=false
 end
end

  model.Parent=group;model:SetAttribute('CraxId',member=='OG'and 'Crax_Deadly'or 'DemoTarget');model:SetAttribute('AbilityId','DemoOnly')
  model:SetAttribute('MaxHealth',hp);model:SetAttribute('Health',hp);model:SetAttribute('CollisionDamage',0);model:SetAttribute('Speed',14)
  model:SetAttribute('DeadlyInvulnerable',true);model:SetAttribute('DeadlyDemoActor',true)
  local motion={model=model,head=h,position=p,depth=0,rotation=h.CFrame.Rotation,radius=math.max(h.Size.X,h.Size.Y)/2,velocity=Vector2.new(1,.4).Unit*14,speed=14,beam={Enabled=false},extraBeams={}}
  model:PivotTo(CFrame.new(p.X,p.Y,0)*motion.rotation);M.Health.Register(model);return motion
 end
 local og=actor('OG','DeadlyDemoOG',Vector2.new(-15,25),90)
 local target=actor('Dodger','Cible_Demonstration_1000_PV',Vector2.new(9,25),1000)
 target.model:SetAttribute('DeadlyDemoTarget',true)
 local f={og=nil,enemy=target,members={},byName={},t=0,elapsed=0,nextSpawn=math.huge,spawnIndex=7,order={},trails={},fires={},waves={},blades={}}
 local root={model=og.model,name='OG',family=f,motion=og,depth=og.depth,rotation=og.rotation,baseScale=og.model:GetScale(),contacts={},t=0,boost=false}
 f.og=root;f.members={root};f.byName.OG=root;og.model:SetAttribute('CraxSkillLevel',2)
 M.families={[og.model]=f};M.nodes={[og.model]=root};M.fighters={og,target};M.lastPhase='Fighting'
 state:SetAttribute('GhostNightActive',false);state:SetAttribute('GhostFreezeUntil',0);state:SetAttribute('DeadlyDemoActive',true);state:SetAttribute('Phase','Showcase')
 local queue={}
 if mode=='ASSIMILATIONS'or mode=='TOUT'then queue={'Domino','Parker','Dodger','Vice','Stack'}
 elseif mode~='NIVEAU3'and mode~='APPARITION'then queue={mode:sub(1,1)..mode:sub(2):lower()}end
 if mode=='STACK'then queue={'Stack','Stack'}end
 local d={folder=group,motions={og,target},originalFighters=originals,family=f,target=target,queue=queue,index=0,mode=mode,phase='VoidArrival',time=0}
 M.demo=d
 if mode~='NIVEAU3'and mode~='TOUT'then for _,p in ipairs(og.model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 elseif p:IsA('BillboardGui')then p.Enabled=false end end end
 assert(spawn(f,'Void'),'Impossible de placer VOID; relance la scène.')
 f.byName.Void.used=true
 effect('DemoSceneBegin',{Root=og.model,Target=target.model,Mode=mode,Void=f.byName.Void.model,Duration=0,Models={og.model,target.model}})
 local function label(text)effect('DemoSceneTitle',{Text=text})end
 label('APPARITION DE VOID • CIBLE IMMORTELLE / 1000 PV')
 local function nextScene()
  d.index=d.index+1;local name=d.queue[d.index];local void=f.byName.Void
  if name and name~='Dodger'and d.supportNodes then
   for _,n in ipairs(d.supportNodes)do
    M.Health.Unregister(n.model);Gate.Reset(n.model);M.nodes[n.model]=nil
    if f.byName[n.name]==n then f.byName[n.name]=nil end
    for i=#f.members,1,-1 do if f.members[i]==n then table.remove(f.members,i)end end
    if n.model.Parent then n.model:Destroy()end
   end
   d.supportNodes=nil;d.dodgerTestStarted=nil
  end
  if name then
   void.used=true;void.nextPulsar=math.huge;void.pulse=nil;f.blades={};void.pulsarUntil=0
   d.waitMember=name
   if name=='Dodger'then
    local pool={'Domino','Parker','Vice','Stack'}
    for i=#pool,2,-1 do local j=random:NextInteger(1,i);pool[i],pool[j]=pool[j],pool[i]end
    d.dodgerSupports={pool[1],pool[2]};d.supportIndex=1;d.supportNodes={};d.phase='DodgerSupportArrival'
    label('DODGER • DEUX ALLIÉS ALÉATOIRES')
   else
    assert(spawn(f,name),'Place insuffisante pour l’allié de démonstration.')
    if d.mode=='STACK'then f.byName[name].model:SetAttribute('DeadlyDemoSupport',true)end
    d.phase='MemberArrival';label(d.stackSolo and 'VOID × STACK • SEUL / CROISSANCE COMPLÈTE' or 'VOID × '..string.upper(name)..' • ASSIMILATION')
   end
  elseif d.mode=='NIVEAU3'or d.mode=='TOUT'then
   for i=#f.members,1,-1 do local n=f.members[i];if n.dead or not n.model.Parent then M.nodes[n.model]=nil;table.remove(f.members,i)end end
   d.phase='BuildSeven';d.buildIndex=1;d.buildOrder={'Domino','Parker','Dodger','Vice','Stack'};og.model:SetAttribute('CraxSkillLevel',2)
   label('LES 7 PÉCHÉS CAPITAUX • NIVEAU 3')
  else d.phase='Finished';label('DÉMONSTRATION TERMINÉE • ARRÊTER OU CHANGER DE MODE')end
 end
 d.connection=Run.Heartbeat:Connect(function(delta)
  if M.demo~=d then return end
  local dt=math.min(delta,.1);d.time=d.time+dt
  local t=target
  local step=dt*M.CinematicScale()
  if not d.stackSolo and not M.Flash()and not M.Hold(t.model)then
   if d.viceApproach then local delta=d.viceApproach.p-t.position;if delta.Magnitude>.05 then t.velocity=delta.Unit*14 end end
   t.position=t.position+t.velocity*step
   if t.knockback then local k=t.knockback;t.position=t.position+k.velocity*step;k.velocity=k.velocity*math.exp(-8*step);k.remaining=k.remaining-step;if k.remaining<=0 then t.knockback=nil end end
   local r=t.radius;local x,y=t.position.X,t.position.Y
   if x<-24+r or x>24-r then t.velocity=Vector2.new(-t.velocity.X,t.velocity.Y)end
   if y<5+r or y>45-r then t.velocity=Vector2.new(t.velocity.X,-t.velocity.Y)end
   t.position=Vector2.new(math.clamp(x,-24+r,24-r),math.clamp(y,5+r,45-r));t.model:PivotTo(CFrame.new(t.position.X,t.position.Y,t.depth)*t.rotation)
  end
  if now()>(target.model:GetAttribute('DeadlyDemoBurnUntil')or 0)then target.model:SetAttribute('BurningActive',false)end
  M.Step(dt,d.motions)
  if f.stage=='Form'and not M.Flash()and not state:GetAttribute('GhostNightActive')and now()>=(state:GetAttribute('GhostFreezeUntil')or 0)and not Gate.Paused(root.model)then
   level3DemoMove(root,og,target,step)
  end
  local void=f.byName.Void
  if d.mode=='STACK'then
   state:SetAttribute('StackDemoPart',d.stackSolo and 2 or 1)
   state:SetAttribute('StackDemoFinished',d.phase=='Finished')
  end
  if d.phase=='VoidArrival'and alive(void)then
   void.used=true;void.nextPulsar=math.huge
   if d.mode=='TOUT'then void.nextPulsar=void.t;d.phase='Pulsar';d.finish=d.time+7;label('VOID • PULSAR : 3 VAGUES / CIBLE MOBILE PASSIVE')
   elseif d.mode=='APPARITION'then d.phase='Pulsar';d.finish=d.time+7;label('APPARITION DE VOID • IL EST REVEILLE...')
   else nextScene()end
  elseif d.phase=='Pulsar'and d.time>=d.finish then
   void.nextPulsar=math.huge
   if d.mode=='APPARITION'then d.phase='Finished';label('APPARITION DE VOID TERMINÉE • CIBLE IMMORTELLE')else nextScene()end
  elseif d.phase=='DodgerSupportArrival'and not f.pendingSpawn then
   local name=d.dodgerSupports[d.supportIndex]
   if name then
    assert(spawn(f,name),'Impossible de placer les alliés DODGER.')
    local n=f.byName[name];n.model.Parent=d.folder;n.model:SetAttribute('DeadlyDemoSupport',true);n.model:SetAttribute('DeadlyInvulnerable',false)
    n.model:SetAttribute('DodgerTestStatus','EN ATTENTE');d.supportNodes[#d.supportNodes+1]=n;d.supportIndex=d.supportIndex+1
   else
    assert(spawn(f,'Dodger'),'Impossible de placer DODGER.')
    d.phase='MemberArrival';label('VOID × DODGER • PROTECTION DES DEUX ALLIÉS')
   end
  elseif d.phase=='MemberArrival'then
   local ally=f.byName[d.waitMember]
   if alive(ally)then
    void.used=false;void.nextPulsar=math.huge;void.pulsarUntil=0;put(ally,position(void)+Vector2.new(radius(void)+radius(ally)*.5,0))
    beginAssimilation(void,ally);d.phase='Assimilation';d.finish=d.time+(d.waitMember=='Parker'and 22 or d.waitMember=='Dodger'and 12 or d.waitMember=='Stack'and 30 or 26)
   end
  elseif d.phase=='Assimilation'then
   if d.waitMember=='Dodger'and void.assim=='Dodger'and not void.transformUntil and not d.dodgerTestStarted then
    d.dodgerTestStarted=f.t;d.dodgerTestPhase=1
   end
   if d.waitMember=='Dodger'and d.dodgerTestStarted then
    local age=f.t-d.dodgerTestStarted
    if d.dodgerTestPhase==2 and not void.assim then d.dodgerTestPhase=3 end
    if d.dodgerTestPhase==1 and age>=2 then
     for _,n in ipairs(d.supportNodes or{})do
      local before=n.model:GetAttribute('Health');SSS.BiteHit:Fire(target.model,n.model,3,false,'DodgerProtectionTest')
      task.defer(function()if n.model.Parent then
       local protected=n.model:GetAttribute('DeadlyHPFrozen')and n.model:GetAttribute('Health')==before
       n.model:SetAttribute('DodgerTestStatus',protected and 'PROTÉGÉ : PV INCHANGÉS'or 'ÉCHEC DE PROTECTION')
       print('DODGER protection',n.name,before,'->',n.model:GetAttribute('Health'),protected)
      end end)
     end
     d.dodgerTestPhase=2
    elseif d.dodgerTestPhase==2 and age>=5 and state:GetAttribute('DodgerDemoAutoImpact')==true then
     SSS.BiteHit:Fire(target.model,void.model,1,false,'DodgerShieldTest');d.dodgerTestPhase=3
    elseif d.dodgerTestPhase==3 and age>=7 and not void.assim then
     for _,n in ipairs(d.supportNodes or{})do
      local before=n.model:GetAttribute('Health');SSS.BiteHit:Fire(target.model,n.model,3,false,'DodgerReleaseTest')
      task.defer(function()if n.model.Parent then
       local released=not n.model:GetAttribute('DeadlyHPFrozen')and n.model:GetAttribute('Health')==before-3
       n.model:SetAttribute('DodgerTestStatus',released and 'LIBÉRÉ : −3 PV CONFIRMÉS'or 'ÉCHEC DE LIBÉRATION')
       print('DODGER libération',n.name,before,'->',n.model:GetAttribute('Health'),released)
      end end)
     end
     d.dodgerTestPhase=4
    end
   end
   -- DODGER remains active until an actual damaging hit requests protection break.
   if d.time>=d.finish and not void.eating and not void.assim and not void.transformUntil and not void.returningUntil then
    if d.mode=='STACK'and d.index==1 then
     d.stackSolo=true;d.detachedTarget=target.model;target.model.Parent=nil;M.Health.Unregister(target.model)
     put(void,Vector2.new(0,25));void.velocity=Vector2.new(1,.37).Unit
    end
    nextScene()
   end
  elseif d.phase=='BuildSeven'and not f.pendingSpawn then
   local name=d.buildOrder[d.buildIndex]
   if name then
    local existing=f.byName[name]
    if not alive(existing)then spawn(f,name)end
    d.buildIndex=d.buildIndex+1
   elseif #living(f)==7 then f.fusionUsed=false;og.model:SetAttribute('CraxSkillLevel',3);d.phase='Fusion' end
  elseif d.phase=='Fusion'and f.fusionUsed and not f.stage then d.phase='Finished';label('NIVEAU 3 TERMINÉ • CIBLE IMMORTELLE / 1000 PV')end
 end)
 return 'Scène '..mode..' lancée. StopDemo() pour revenir au lobby.'
end

function M.PolariDelay(dt)for _,e in pairs(M.cinematics)do e.finish+=dt end end
return M
