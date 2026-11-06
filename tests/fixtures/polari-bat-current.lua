-- BatGadgetTelegraphV5
-- One adapter in the existing arena solver. No private Health table, no second physics heartbeat.
local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local kit=RS:WaitForChild('BatCraxKit');local R=require(kit.BatRules);local G=require(kit.BatGeometry);local Projectile=require(kit.BatProjectile)
local Gate=require(SSS:WaitForChild('CraxAbilityGate'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local Control=require(SSS:WaitForChild('FleauControl'));local Confusion=require(RS:WaitForChild('CraxFleau').FleauRules).Config.Stun
local state=workspace:WaitForChild('CombatState');local remote=RS:WaitForChild('BatCraxEvent');local rng=Random.new()
local M={};local bindings;local motions={};local previous={};local records={};local zones={};local smokeAffected={};local cuffs={};local clock=0;local serial=0;local seq=0;local currentRound;local syncLimits={};local recentContacts={};local lastScale
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m and m:GetAttribute('CraxId')==R.Id end
local function scope()return state:GetAttribute('CraxMatchToken'),state:GetAttribute('RoundId')end
local function emit(kind,data)
 seq=seq+1;data=data or{};data.kind=kind;data.match,data.round=scope();data.seq=seq;data.serverTime=workspace:GetServerTimeNow();remote:FireAllClients(data)
end
local function id(prefix)serial=serial+1;return prefix..':'..serial end
local function manager()return require(SSS.CraxInvertedRuntime)end
local function paused(m)return Gate.Paused(m)or bindings.GlobalPause()end
local function canStart(m)return alive(m)and Silence.CanStart(m)and not paused(m)and not bindings.Held(motions[m])end
local function targetable(m)return alive(m)and not m:GetAttribute('BatLampVanished')and not m:GetAttribute('LuckyVanished')and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('DeadlyPhantom')and not m:GetAttribute('PlumberInTransit')and not m:GetAttribute('VicePortalTransit')end
local function targets(owner)
 local out={};for m,f in pairs(motions)do if targetable(m)and not bindings.SameTeam(owner,m)then out[#out+1]={model=m,position=f.position,radius=f.radius,Before=previous[m]or f.position}end end
 table.sort(out,function(a,b)return a.model:GetFullName()<b.model:GetFullName()end);return out
end
local persistent={LuckyZone=true,Burning=true,SpideyPoison=true,BlackWebDOT=true,GhostBleed=true,DeadlySlime=true,Bleeding=true,GoldenStatue=true,HangoverMagma=true,SymParasite=true}
local physical={LuckyCoin=true,Collision=true,BatBatarang=true,BatGrapple=true,WebImpact=true,WebCritical=true,SpideyInject=true,MonsterBite=true,MonsterTongue=true,FleauCharge=true,FleauFury=true,KillaStrike=true,GhostKnife=true,FantasticHand=true,FantasticElastic=true,PlumberPiranha=true,DeadlyParkerContact=true,DeadlyDarkBlade=true,GoldenPunch=true,GoldenIngot=true,HangoverDCON=true,HangoverTysonFist=true,BlackWebPhysical=true,SuperDash=true,SuperMelee=true,FantasticPunch=true}
function M.Physical(kind,collision)return collision==true or physical[kind]==true end
function M.Unavailable(m)return m and m:GetAttribute('BatLampVanished')==true end
function M.LampDamageAllowed(m)local r=records[m];return r and r.lamp and r.lamp.Impactting and state:GetAttribute('Phase')=='Fighting'end
function M.Incoming(attacker,target,amount,kind,collision)
 if M.Unavailable(target)and not persistent[kind]then return 0 end
 if attacker and M.Unavailable(attacker)and not persistent[kind]and kind~='BatLamp'then return 0 end
 if attacker and cuffs[attacker]and not persistent[kind]then return 0 end
 local hitZone=smokeAffected[attacker]
 if hitZone and hitZone[target]and M.Physical(kind,collision)then return 0 end
 local r=records[target];if r and r.action and r.action.Kind=='Grapple'and r.action.Phase=='Pull'then amount=amount*R.Grapple.IncomingMultiplier end
 return amount
end
function M.AdjustSet(model,hp,old)
 if hp>=old then return hp end
 local r=records[model];if r and r.action and r.action.Kind=='Grapple'and r.action.Phase=='Pull'then return old-(old-hp)*R.Grapple.IncomingMultiplier end
 return hp
end
function M.SuppressContact(a,b)
 if M.Unavailable(a)or M.Unavailable(b)then return true end
 for _,m in ipairs({a,b})do local r=records[m];if r and r.action and r.action.Kind=='Grapple'and r.action.Phase=='Pull'then return true end end
 return false
end
function M.ContactAllowed(a,b,kind)
 if kind=='BatGrapple'then return true end
 if recentContacts[a]and recentContacts[a][b]or recentContacts[b]and recentContacts[b][a]then return false end
 return not M.SuppressContact(a,b)
end
function M.Slow(m)return smokeAffected[m]and R.Smoke.Slow or 1 end
function M.Hold(m)
 local r=records[m];return cuffs[m]~=nil or r and(r.lamp~=nil or r.action and r.action.Kind=='Grapple'and r.action.Phase=='Pull')or false
end
function M.Bind(value)assert(R.Calibrated,'BatCrax : calibration non validée');bindings=value end
function M.BeginStep()
 previous={};if not bindings then return end
 motions={};for _,f in ipairs(bindings.MotionTargets())do motions[f.model]=f;previous[f.model]=f.position end
end
local function damage(a,b,n,kind,collision)
 if not M.ApplyDamage then return false end
 return M.ApplyDamage(a,b,n,collision==true,kind)
end
local function finishAction(r)
 if not r.action then return end
 if r.action.Kind=='Grapple'then r.owner:SetAttribute('BatGrappling',nil);local f=motions[r.owner];if f then f.velocity=G.Unit(f.velocity)*(f.speed or 25)end end
 emit('ActionEnd',{owner=r.owner,id=r.action.Id,gadget=r.action.Kind});r.action=nil;r.nextGadget=r.gadgetClock+rng:NextNumber(R.Gadgets.DelayMin,R.Gadgets.DelayMax)
end
local function direction(f)return G.Unit(f.velocity.Magnitude>.001 and f.velocity or Vector2.new(1,0))end
local function publicAction(a)
 if not a then return nil end
 local p={Id=a.Id,Kind=a.Kind,Age=a.Age,Origin=a.Origin,Direction=a.Direction,Anchor=a.Anchor,Phase=a.Phase,P=a.P,Target=a.Direct,PullAge=a.PullAge,Projectiles={}}
 for _,v in ipairs(a.Projectiles or{})do p.Projectiles[#p.Projectiles+1]={Id=v.Id,P=v.P,V=v.V,Radius=v.Radius,Bounces=v.Bounces,Dead=v.Dead,Age=v.Age,Distance=v.Distance}end;return p
end
function M.StartAction(r,kind)
 local f=motions[r.owner];if not f then return end
 local a={Id=id(kind),Kind=kind,Age=0,Origin=f.position,Direction=direction(f),Projectiles={},Hits={}};r.action=a
 emit('ActionStart',{owner=r.owner,id=a.Id,gadget=kind,position=a.Origin,direction=a.Direction})
 if kind=='Batarang'then
  local angle=rng:NextNumber(0,math.pi*2);local second=rng:NextNumber(0,math.pi*2);if math.abs(math.sin((second-angle)*.5))<1e-8 then second=(angle+math.pi)%(math.pi*2)end
  for i,v in ipairs({angle,second})do local d=Vector2.new(math.cos(v),math.sin(v));a.Projectiles[i]=Projectile.New(a.Id..':'..i,r.owner,f.position,d,R.Batarang,bindings.Bounds())end
 elseif kind=='Grapple'then
  a.Direction=G.Opposite(f.position,f.velocity);a.Phase='Hook';a.P=f.position;a.HookAge=0
  local t=G.Wall(f.position,a.Direction,bindings.Bounds(),.05);a.Anchor=f.position+a.Direction*t
 elseif kind=='Smoke'then
  local proposed=f.position+a.Direction*R.Smoke.Range;local b=bindings.Bounds();a.Anchor=Vector2.new(math.clamp(proposed.X,b.minX+.3,b.maxX-.3),math.clamp(proposed.Y,b.minY+.3,b.maxY-.3))
 elseif kind=='Cuff'then
  a.Projectiles[1]=Projectile.New(a.Id..':cuff',r.owner,f.position,a.Direction,{Speed=R.Cuff.Speed,Radius=R.Cuff.Radius,Range=R.Cuff.Range,Lifetime=R.Cuff.Range/R.Cuff.Speed},bindings.Bounds())
 end
 emit('ActionState',{owner=r.owner,id=a.Id,gadget=kind,position=a.Origin,direction=a.Direction,anchor=a.Anchor,projectiles=publicAction(a).Projectiles})
end
local GADGET_ANTICIPATION=.8
local function lockGadget(r,kind)
 r.pending={Id=id('GadgetLock'),Kind=kind,Age=0}
 emit('GadgetLocked',{owner=r.owner,id=r.pending.Id,gadget=kind,duration=GADGET_ANTICIPATION})
end
local function clearCuff(m,c)
 if m.Parent then m:SetAttribute('BatCuffed',nil)end;cuffs[m]=nil;emit('CuffRelease',{owner=c.Owner,target=m,id=c.Id})
end
local function stepAction(r,dt)
 local a=r.action;if not a then return end;local f=motions[r.owner];a.Age=a.Age+dt
 if a.Kind=='Batarang'or a.Kind=='Cuff'then
  local any=false
  for _,p in ipairs(a.Projectiles)do if not p.Dead then
   p:Step(dt,targets(r.owner),{
    Ended=function(projectile,reason)emit('ProjectileEnd',{owner=r.owner,id=projectile.Id,reason=reason,position=projectile.P})end,
    Bounce=function(projectile)emit('ProjectileBounce',{owner=r.owner,id=projectile.Id,position=projectile.P,velocity=projectile.V,bounces=projectile.Bounces})end,
    Hit=function(projectile,t)
     if a.Kind=='Batarang'then damage(r.owner,t.model,R.Batarang.Damage,'BatBatarang',false);emit('BatarangHit',{owner=r.owner,target=t.model,id=projectile.Id,position=projectile.P})
     else
      -- Shared control and the actual Inverted SILENCE manager retain their own source ownership.
      local key='BatCuff:'..a.Id
      if Control.Apply(t.model,key,R.Cuff.Hold)then
       cuffs[t.model]={Owner=r.owner,Id=a.Id,Until=clock+R.Cuff.Hold,Started=clock};t.model:SetAttribute('BatCuffed',true)
       manager().AddSilence(t.model,R.Cuff.Silence,key);emit('CuffHit',{owner=r.owner,target=t.model,id=a.Id,hold=R.Cuff.Hold})
      end
     end
    end,
   });if not p.Dead then any=true end
  end end
  if not any then finishAction(r)end
 elseif a.Kind=='Grapple'then
  if a.Phase=='Hook'then
   local before=a.P;local distance=math.min((a.Anchor-before).Magnitude,R.Grapple.HookSpeed*dt);local after=before+a.Direction*distance;local first,target=math.huge,nil
   for _,t in ipairs(targets(r.owner))do local hit=G.Sweep(before,after,t.Before,t.position,t.radius+R.Grapple.Radius);if hit and hit<first then first=hit;target=t end end
   if target then a.P=before:Lerp(after,first);a.Anchor=target.position;a.Direct=target.model else a.P=after end
   if target or(a.P-a.Anchor).Magnitude<.001 then
    a.Phase='Pull';a.PullAge=0;a.Speed=f.velocity.Magnitude;r.owner:SetAttribute('BatGrappling',true)
    emit('GrappleLatch',{owner=r.owner,id=a.Id,position=a.P,anchor=a.Anchor,target=a.Direct})
   end
  else
   if bindings.Held(f)then finishAction(r);return end
   if a.Direct then if not targetable(a.Direct)or not motions[a.Direct]then finishAction(r);return end;a.Anchor=motions[a.Direct].position end
   local before=f.position;local delta=a.Anchor-before;a.PullAge=a.PullAge+dt;a.Speed=math.min(R.Grapple.Speed,a.Speed+R.Grapple.Acceleration*dt)
   local travel=math.min(math.max(0,delta.Magnitude-f.radius-.05),a.Speed*dt);local after=before+G.Unit(delta)*travel
   f.position=after;f.velocity=G.Unit(delta)*a.Speed;bindings.ClampMotion(f)
   local hits={};for _,t in ipairs(targets(r.owner))do if not a.Hits[t.model]then local hit=G.Sweep(before,f.position,t.Before,t.position,f.radius+t.radius);if hit then hits[#hits+1]={at=hit,target=t.model}end end end
   table.sort(hits,function(x,y)return x.at<y.at end)
   for _,hit in ipairs(hits)do if state:GetAttribute('Phase')~='Fighting'then break end;a.Hits[hit.target]=true;recentContacts[r.owner]=recentContacts[r.owner]or{};recentContacts[r.owner][hit.target]=true;local n=hit.target==a.Direct and R.Grapple.Critical or R.Grapple.Damage;damage(r.owner,hit.target,n,'BatGrapple',true);emit('GrappleContact',{owner=r.owner,target=hit.target,id=a.Id,amount=n})end
   if a.PullAge>=R.Grapple.Duration or delta.Magnitude<=f.radius+.1 then finishAction(r)end
  end
 elseif a.Kind=='Smoke'then
  if a.Age>=R.Smoke.Flight+R.Smoke.OpenDelay then
   local z={Id=a.Id..':smoke',Owner=r.owner,P=a.Anchor,Age=0};zones[z.Id]=z;emit('SmokeStart',{owner=r.owner,id=z.Id,position=z.P,duration=R.Smoke.Duration,radius=R.Smoke.Radius});finishAction(r)
  end
 elseif a.Kind=='Lab'then
  if a.Age>=R.Lab.HealAt and not a.Healed then a.Healed=true;local gained=M.LabHeal and M.LabHeal(r.owner)or 0;emit('LabHeal',{owner=r.owner,id=a.Id,amount=gained})end
  if a.Age>=R.Lab.Duration then finishAction(r)end
 end
end
local function startLamp(r)
 local f=motions[r.owner];r.lampUsed=true;r.lamp={Id=id('Lamp'),Age=0,Started=workspace:GetServerTimeNow(),Velocity=f.velocity,Anchor=f.position,Center=Vector2.new(R.Lamp.CenterX,R.Lamp.CenterY)}
 r.owner:SetAttribute('BatLampActive',true);emit('LampStart',{owner=r.owner,id=r.lamp.Id,position=r.lamp.Center,started=workspace:GetServerTimeNow(),duration=R.Lamp.Duration})
end
local function stepLamp(r,dt)
 local l=r.lamp;l.Age=math.max(0,workspace:GetServerTimeNow()-l.Started)
 if l.Age>=.3 then r.owner:SetAttribute('BatLampVanished',true)end
 if l.Age<R.Lamp.Duration then return end
 local f=motions[r.owner];f.position=l.Center;bindings.ClampMotion(f);r.owner:SetAttribute('BatLampVanished',nil);l.Impactting=true
 local seen={};for _,t in ipairs(targets(r.owner))do if not seen[t.model]and state:GetAttribute('Phase')=='Fighting'then seen[t.model]=true;local n=G.LampZone(t.position,l.Center);if n>0 then damage(r.owner,t.model,n,'BatLamp',false)end end end
 l.Impactting=false;emit('LampImpact',{owner=r.owner,id=l.Id,position=l.Center});r.owner:SetAttribute('BatLampActive',nil);r.Landing=l.Center;r.ResumeVelocity=l.Velocity;r.lamp=nil
 if alive(r.owner)and state:GetAttribute('Phase')=='Fighting'then Control.Apply(r.owner,'BatLampConfusion:'..l.Id,Confusion)end
end
local function updateSmoke(dt)
 local affected={};local goggles={}
 for m in pairs(smokeAffected)do if not motions[m]then for key in pairs(zones)do manager().SetSilencePresence(m,'BatSmoke:'..key,false)end end end
 for key,z in pairs(zones)do
  if not paused(z.Owner)then z.Age=z.Age+dt end
  if z.Age>=R.Smoke.Duration or not alive(z.Owner)then
   for m in pairs(motions)do manager().ReleaseSilence(m,'BatSmoke:'..key)end
   zones[key]=nil;emit('SmokeEnd',{owner=z.Owner,id=key})
  else
   for m,f in pairs(motions)do
    local inside=alive(m)and not M.Unavailable(m)and(f.position-z.P).Magnitude<=R.Smoke.Radius
    if m==z.Owner then if inside then goggles[m]=true end
    elseif not bindings.SameTeam(z.Owner,m)then
     manager().SetSilencePresence(m,'BatSmoke:'..key,inside)
     if inside then affected[m]=affected[m]or{};affected[m][z.Owner]=true end
    end
   end
  end
 end
 local all={};for m in pairs(smokeAffected)do all[m]=true end;for m in pairs(affected)do all[m]=true end
 for m in pairs(all)do if m.Parent then m:SetAttribute('BatSmokeSlowed',affected[m]~=nil)end end
 smokeAffected=affected
 for m in pairs(records)do if m.Parent and m:GetAttribute('BatGoggles')~=(goggles[m]==true)then m:SetAttribute('BatGoggles',goggles[m]==true);emit('Goggles',{owner=m,on=goggles[m]==true})end end
end
function M.Step(dt,enabled)
 if not bindings then return end
 local _,round=scope();if not enabled or state:GetAttribute('Phase')~='Fighting'then if next(records)or next(zones)then M.Reset()end;return end
 if currentRound~=round then M.Reset();currentRound=round end
 motions={};for _,f in ipairs(bindings.MotionTargets())do motions[f.model]=f end
 for owner,contacts in pairs(recentContacts)do for target in pairs(contacts)do local a,b=motions[owner],motions[target];if not a or not b or(a.position-b.position).Magnitude>a.radius+b.radius+.05 then contacts[target]=nil end end;if not next(contacts)then recentContacts[owner]=nil end end
 local activeScale=bindings.TimeScale and bindings.TimeScale()or 1;if lastScale~=activeScale then lastScale=activeScale;emit('TimeScale',{scale=activeScale})end;local normal=dt*activeScale
 if not bindings.GlobalPause()then clock=clock+normal end
 for m,c in pairs(cuffs)do if not alive(m)or not m:GetAttribute('FleauStunned')or clock>=c.Until then clearCuff(m,c)end end
 for m,f in pairs(motions)do if own(m)and alive(m)then
  local r=records[m];if not r then r={owner=m,level=m:GetAttribute('CraxSkillLevel')or 0,gadgetClock=0,lampClock=0,nextGadget=rng:NextNumber(7,10),nextLamp=rng:NextNumber(12,20)};records[m]=r end
  if r.ResumeVelocity and not r.lamp and not r.Landing and not paused(m)and not bindings.Held(f)then if f.velocity.Magnitude<.001 then f.velocity=r.ResumeVelocity end;r.ResumeVelocity=nil end
  local nowPaused=paused(m)
  if nowPaused~=r.Paused then r.Paused=nowPaused;emit(nowPaused and'OwnerPause'or'OwnerResume',{owner=m})end
  if r.lamp then stepLamp(r,dt)
  else
   if not paused(m)then
    if Silence.CanStart(m)then r.gadgetClock=r.gadgetClock+normal;r.lampClock=r.lampClock+normal end
    -- Continuations survive SILENCE; the next delay is anchored to this action's actual end.
    if r.action then stepAction(r,normal)end
    if r.pending then
     -- No reroll: SILENCE, control holds and global pauses defer the same server-owned choice.
     if canStart(m)then
      r.pending.Age=r.pending.Age+normal
      if r.pending.Age>=GADGET_ANTICIPATION then
       local locked=r.pending;r.pending=nil
       emit('GadgetUnlocked',{owner=m,id=locked.Id,gadget=locked.Kind})
       M.StartAction(r,locked.Kind)
      end
     end
    elseif not r.action and canStart(m)then
     if r.level>=3 and not r.lampUsed and r.lampClock>=r.nextLamp then startLamp(r)
     elseif r.gadgetClock>=r.nextGadget then local list=G.Available(r.level);lockGadget(r,list[rng:NextInteger(1,#list)])end
    end
   end
  end
 elseif records[m]then
  emit('OwnerClear',{owner=m});m:SetAttribute('BatLampActive',nil);m:SetAttribute('BatLampVanished',nil);m:SetAttribute('BatGrappling',nil);records[m]=nil
 end end
 updateSmoke(normal)
end
function M.Enforce(f)
 local r=records[f.model];if not r then return end;if r.lamp then f.position=r.lamp.Anchor;f.velocity=Vector2.zero;f.knockback=nil elseif r.Landing then if f.model:GetAttribute('FleauStunned')then f.position=r.Landing;f.velocity=Vector2.zero;f.knockback=nil else r.Landing=nil end end
end
function M.CaptureFinale(fighters,health)
 local loser,winner;for _,m in ipairs(fighters)do local data=health[m];if data and data.health<=0 then loser=m else winner=m end end
 if not loser or not winner or not own(winner)or(winner:GetAttribute('CraxSkillLevel')or 0)<4 then return end
 local match,round=scope();local saved=kit:FindFirstChild('RoundVictimSnapshot')
 if saved and saved:GetAttribute('Match')==match and saved:GetAttribute('Round')==round then return end
 if saved then saved:Destroy()end
 local staging=Instance.new('Folder');local snapshot=require(RS.CraxRenderRegistryV82).Snapshot(loser,staging)
 if snapshot then local model=snapshot.Model;model.Name='RoundVictimSnapshot';model:SetAttribute('Match',match);model:SetAttribute('Round',round);model:SetAttribute('Loser',loser.Name);model.Parent=kit end;staging:Destroy()
end
function M.Reset()
 for m,r in pairs(records)do if m.Parent then for _,name in ipairs({'BatLampActive','BatLampVanished','BatGrappling','BatGoggles'})do m:SetAttribute(name,nil)end end end
 for m in pairs(smokeAffected)do if m.Parent then m:SetAttribute('BatSmokeSlowed',nil)end end
 for key in pairs(zones)do for m in pairs(motions)do manager().ReleaseSilence(m,'BatSmoke:'..key)end end
 for m,c in pairs(cuffs)do clearCuff(m,c)end
 records={};zones={};smokeAffected={};cuffs={};recentContacts={};lastScale=nil;clock=0;emit('Clear')
end
remote.OnServerEvent:Connect(function(player,request)
 if request~='Sync'then return end;local now=os.clock();if now-(syncLimits[player]or-math.huge)<2 then return end;syncLimits[player]=now
 local list={};for _,r in pairs(records)do list[#list+1]={owner=r.owner,action=publicAction(r.action),pending=r.pending and {Id=r.pending.Id,Kind=r.pending.Kind,Age=r.pending.Age,Duration=GADGET_ANTICIPATION}or nil,lamp=r.lamp,paused=r.Paused,goggles=r.owner:GetAttribute('BatGoggles')}end
 local cuffList={};for m,c in pairs(cuffs)do cuffList[#cuffList+1]={owner=c.Owner,target=m,id=c.Id,age=clock-c.Started}end
 local match,round=scope();remote:FireClient(player,{kind='Sync',seq=seq,match=match,round=round,records=list,zones=zones,cuffs=cuffList,scale=lastScale or 1,serverTime=workspace:GetServerTimeNow()})
end)
game:GetService('Players').PlayerRemoving:Connect(function(player)syncLimits[player]=nil end)
state:GetAttributeChangedSignal('Phase'):Connect(function()if state:GetAttribute('Phase')~='Fighting'then M.Reset()end;if state:GetAttribute('Phase')~='RoundOver'then local saved=kit:FindFirstChild('RoundVictimSnapshot');if saved then saved:Destroy()end end end)
return M
