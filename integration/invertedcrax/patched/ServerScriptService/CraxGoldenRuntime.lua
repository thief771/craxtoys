local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxCombinedFix_v7
-- GoldenUnified-3.0: authoritative combat. No client damage requests.
local SSS=game:GetService('ServerScriptService')
local Rules=require(SSS:WaitForChild('CraxGoldenRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState')
local hit=SSS:WaitForChild('BiteHit')
local M={Version='GoldenUnified-3.0'}
local owners,statuses={},{}
local round,serial=nil,0
local visual=Instance.new('Folder');visual.Name='GoldenCombatState';visual.Parent=workspace
local rng=Random.new()
local function golden(m)return m:GetAttribute('CraxId')=='Crax_Golden'or m:GetAttribute('AbilityId')=='GoldenMidas'end
M.IsGolden=golden
local function living(m)return m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function pos(f)return Vector3.new(f.position.X,f.position.Y,f.depth)end
local function level(m)return math.clamp(m:GetAttribute('CraxSkillLevel')or 0,0,4)end
local function canAct(m)return living(m)and not Gate.Paused(m)and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('PlumberInTransit')and not m:GetAttribute('VicePortalTransit')end
local function newFX(kind,owner,attrs)
 serial=serial+1
 local n=Instance.new('Folder');n.Name=kind..'_'..serial;n:SetAttribute('Kind',kind)
 for k,v in pairs(attrs or{})do n:SetAttribute(k,v)end
 n:SetAttribute('Age',0);n:SetAttribute('Paused',false);n:SetAttribute('RoundId',state:GetAttribute('RoundId'))
 local ref=Instance.new('ObjectValue');ref.Name='Owner';ref.Value=owner;ref.Parent=n
 n.Parent=visual;return n
end
local function publish(n,age,paused)
 n:SetAttribute('Paused',paused)
 if math.floor(age*20)~=n:GetAttribute('Frame')then n:SetAttribute('Frame',math.floor(age*20));n:SetAttribute('Age',age)end
end
local transients={}
local function impact(owner,where,size)
 local n=newFX('Impact',owner,{Center=where,Width=size or 2,Duration=.45})
 transients[#transients+1]={Node=n,Age=0}
end
local function release(m,s)
 Gate.Resume(m,'GoldenStatue')
 if m.Parent then m:SetAttribute('GoldenStatue',false);m:SetAttribute('GoldenGilding',0);m:SetAttribute('GoldenSlowMultiplier',1);m:SetAttribute('GoldenPoolContact',0);m:SetAttribute('GoldenWaterContact',0)end
 s.Anchor=nil
end
function M.Reset()
 for m,s in pairs(statuses)do release(m,s)end
 for m in pairs(owners)do if m.Parent then m:SetAttribute('GoldenCharging',false)end end
 owners={};statuses={};transients={};visual:ClearAllChildren()
end
local function record(m)local s=statuses[m];if not s then s=Rules.New();s.Publish=0;statuses[m]=s end;return s end
local function statue(m,s,f)
 if not s.Anchor then s.Anchor=f.position end
 m:SetAttribute('GoldenStatue',true);Gate.Pause(m,'GoldenStatue');impact(s.Owner,pos(f),f.radius*2)
end
local function addGold(owner,f,points)
 local s=record(f.model)
 if s.Statue>0 then return end
 s.Owner=owner
 if Rules.AddGold(s,points)then statue(f.model,s,f)end
 f.model:SetAttribute('GoldenGilding',s.Gold)
end
function M.Slow(m)return m:GetAttribute('GoldenSlowMultiplier')or 1 end
function M.Hold(m)return m:GetAttribute('GoldenStatue')==true or m:GetAttribute('GoldenCharging')==true end
function M.Outgoing(m,amount)
 local root=Deadly.Root(m)
 if m:GetAttribute('GoldenStatue')or(root and root:GetAttribute('GoldenStatue'))then return 0 end
 return amount
end
function M.Enforce(fighters)
 for _,f in ipairs(Deadly.MotionTargets(fighters))do local s=statuses[f.model];if s and s.Statue>0 and s.Anchor then f.position=s.Anchor end end
end
local function enemy(owner,f)return living(f.model)and not Deadly.SameTeam(owner,f.model)and not f.model:GetAttribute('PlumberInTransit')and not f.model:GetAttribute('VicePortalTransit')end
local function nearest(owner,motions)
 local best,distance
 for _,f in ipairs(motions)do if enemy(owner.model,f)then local d=(f.position-owner.position).Magnitude;if not distance or d<distance then best,distance=f,d end end end
 return best
end
local function damage(owner,f,amount,kind)
 if not enemy(owner,f)then return end
 hit:Fire(owner,f.model,amount,false,kind or 'GoldenHit')
end
local function spawnPool(owner,r,f)
 -- Fixed at the actual owner head center on this simulation frame. Width follows
 -- character size; rendering uses the same ellipse as the authoritative footprint.
 local width=math.clamp(f.radius*3,6,9)*1.3
 local rx,ry=width*.5,width*.4
 local xy=Vector2.new(math.clamp(f.position.X,-24+rx+.12,24-rx-.12),math.clamp(f.position.Y,5+ry+.12,45-ry-.12))
 local center=Vector3.new(xy.X,xy.Y,f.depth)
 local node=newFX('Pool',owner,{Center=center,Width=width,Duration=9})
 r.Pools[#r.Pools+1]={Center=xy,Radius=width*.5,Age=0,Visual=node}
end
local function segmentDistance(p,a,b)
 local d=b-a;local length=d:Dot(d)
 if length<1e-8 then return(p-a).Magnitude end
 local t=math.clamp((p-a):Dot(d)/length,0,1)
 return(p-(a+d*t)).Magnitude
end
local function stepUpgrades(f,r,dt,motions,enabled)
 local lv=level(f.model)
 if lv<1 and r.Charge then r.Charge.Node:Destroy();r.Charge=nil;f.model:SetAttribute('GoldenCharging',false)end
 if enabled and lv>=1 then
  if InvertedSilence.CanStart(f.model)and not r.Charge and r.Time>=r.NextPunch then
   local target=nearest(f,motions)
   if target then
    r.Charge={Age=0,Node=newFX('Charge',f.model,{Center=pos(f),Width=f.radius*2,Duration=1})}
    f.model:SetAttribute('GoldenCharging',true)
   end
  end
  if r.Charge then
   local c=r.Charge;c.Age=c.Age+dt;c.Node:SetAttribute('Center',pos(f));publish(c.Node,c.Age,false)
   if c.Age>=1 then
    c.Node:Destroy();r.Charge=nil;f.model:SetAttribute('GoldenCharging',false);r.NextPunch=r.Time+8
    local target=nearest(f,motions)
    if target then
     local delta=target.position-f.position
     local dir=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
     local start=f.position+dir*(f.radius*.6)
     local width=f.radius*.8
     local node=newFX('Punch',f.model,{Center=Vector3.new(start.X,start.Y,f.depth),Direction=Vector3.new(dir.X,dir.Y,0),Width=width,Speed=48,Duration=1.65})
     r.Shots[#r.Shots+1]={Position=start,Direction=dir,Age=0,Node=node,Radius=width*.5,Hit={}}
     f.knockback={velocity=-dir*26,remaining=.18}
    end
   end
  end
 end
 if r.Charge then publish(r.Charge.Node,r.Charge.Age,not enabled)end
 for i=#r.Shots,1,-1 do
  local shot=r.Shots[i]
  if enabled then
   local before=shot.Position;shot.Position=before+shot.Direction*(48*dt);shot.Age=shot.Age+dt
   for _,target in ipairs(motions)do
    if enemy(f.model,target)and not shot.Hit[target.model]and segmentDistance(target.position,before,shot.Position)<=shot.Radius+(target.radius or 0)then
     shot.Hit[target.model]=true;damage(f.model,target,25,'GoldenPunch');addGold(f.model,target,30);impact(f.model,pos(target),target.radius*1.5)
     shot.Age=2;break
    end
   end
  end
  if shot.Age>=1.65 then shot.Node:Destroy();table.remove(r.Shots,i)else publish(shot.Node,shot.Age,not enabled)end
 end
 if InvertedSilence.CanStart(f.model)and enabled and lv>=2 and r.Time>=r.NextIngot and #r.Ingots<3 then
  r.Ingots[#r.Ingots+1]={Node=newFX('Ingot',f.model,{Center=pos(f),Width=f.radius*.9,Duration=100000}),Phase=rng:NextNumber(0,math.pi*2)}
  r.NextIngot=r.Time+10
 end
 for i=#r.Ingots,1,-1 do
  local ingot=r.Ingots[i]
  local angle=r.Time*1.45+ingot.Phase
  local p=f.position+Vector2.new(math.cos(angle),math.sin(angle))*(f.radius*1.8)
  ingot.Node:SetAttribute('Center',Vector3.new(p.X,p.Y,f.depth));publish(ingot.Node,r.Time,not enabled)
  local consumed=lv<2
  if enabled and not consumed then
   for _,target in ipairs(motions)do if enemy(f.model,target)and(target.position-p).Magnitude<=(target.radius or 0)+f.radius*.4 then
    damage(f.model,target,10,'GoldenIngot');impact(f.model,pos(target),target.radius)
    if not target.model:GetAttribute('GoldenStatue')then
     local d=target.position-f.position;d=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
     target.knockback={velocity=d*48,remaining=.25};target.velocity=d*math.max(target.speed or 25,30)
    end
    consumed=true;break
   end end
  end
  if consumed then ingot.Node:Destroy();table.remove(r.Ingots,i)end
 end
 local cascadeAllowed=lv>=3 and(f.model:GetAttribute('Health')or math.huge)<=60
 if not cascadeAllowed and r.Cascade then r.Cascade.Node:Destroy();r.Cascade=nil end
 if InvertedSilence.CanStart(f.model)and cascadeAllowed and enabled and not r.Cascade then
  local x=rng:NextNumber(-19,19)
  r.Cascade={Age=0,Hit={},Node=newFX('Cascade',f.model,{Top=Vector3.new(x,45,f.depth),Bottom=Vector3.new(x,5,f.depth),Width=2.2,Duration=10}),X=x}
 end
 if r.Cascade then
  local c=r.Cascade;if enabled then c.Age=c.Age+dt end
  publish(c.Node,c.Age,not enabled)
  if c.Age>=.9 and enabled then
   for _,target in ipairs(motions)do
    if enemy(f.model,target)and math.abs(target.position.X-c.X)<=2.31+(target.radius or 0)then
     local clock=c.Hit[target.model]
     if not clock then
      clock={Damage=0,Gold=0}
      target.model:SetAttribute('GoldenWaterContact',(target.model:GetAttribute('GoldenWaterContact')or 0)+1)
     end
     c.Hit[target.model]=clock
     clock.Damage=clock.Damage+dt;clock.Gold=clock.Gold+dt
     if clock.Damage>=.2 then local ticks=math.floor((clock.Damage+1e-8)/.2);clock.Damage=clock.Damage-ticks*.2;damage(f.model,target,ticks,'GoldenCascade')end
     if clock.Gold>=.5 then local ticks=math.floor((clock.Gold+1e-8)/.5);clock.Gold=clock.Gold-ticks*.5;addGold(f.model,target,ticks)end
    else c.Hit[target.model]=nil end
   end
  end
  if c.Age>=10 then c.Node:Destroy();r.Cascade=nil end
 end
end
function M.Step(dt,fighters,active)
 local current=state:GetAttribute('RoundId');if current~=round then M.Reset();round=current end
 if state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('DeadlyDemoActive')then if next(owners)or next(statuses)then M.Reset()end;return end
 if not active then
  for _,node in ipairs(visual:GetChildren())do node:SetAttribute('Paused',true)end
  return
 end
 for i=#transients,1,-1 do local t=transients[i];t.Age=t.Age+dt;if t.Age>=.45 then t.Node:Destroy();table.remove(transients,i)else publish(t.Node,t.Age,false)end end
 local motions=Deadly.MotionTargets(fighters);local byModel={}
 for _,f in ipairs(motions)do byModel[f.model]=f end
 for m,r in pairs(owners)do
  if not byModel[m]or not golden(m)or not living(m)then
   m:SetAttribute('GoldenCharging',false)
   for _,node in ipairs(visual:GetChildren())do local ref=node:FindFirstChild('Owner');if ref and ref.Value==m then node:Destroy()end end
   owners[m]=nil
  end
 end
 for _,f in ipairs(fighters)do
  if golden(f.model)and living(f.model)then
   local r=owners[f.model]
   if not r then r={Time=0,Next=4,NextPunch=8,NextIngot=10,Pools={},Shots={},Ingots={}};owners[f.model]=r end
   local enabled=canAct(f.model);if enabled then r.Time=r.Time+dt end
   for i=#r.Pools,1,-1 do local p=r.Pools[i]
    if enabled then p.Age=p.Age+dt end
    publish(p.Visual,p.Age,not enabled)
    if p.Age>=9 then p.Visual:Destroy();table.remove(r.Pools,i)end
   end
   if InvertedSilence.CanStart(f.model)and enabled and r.Time>=r.Next and #r.Pools<2 then spawnPool(f.model,r,f);r.Next=r.Time+4 end
   stepUpgrades(f,r,dt,motions,enabled)
  end
 end
 local present={}
 for _,f in ipairs(motions)do
  local target=f.model;present[target]=true
  if living(target)then
   local s=statuses[target];local inside=false
   if not target:GetAttribute('PlumberInTransit')and not target:GetAttribute('VicePortalTransit')then
    for owner,r in pairs(owners)do
     if canAct(owner)and not Deadly.SameTeam(owner,target)then
      for _,p in ipairs(r.Pools)do
       local d=f.position-p.Center
       -- Ellipse matches authored 5 x 4 mesh. Include the target's own radius.
       local rx=p.Radius+(f.radius or 0);local ry=p.Radius*.8+(f.radius or 0)
       if(d.X/rx)^2+(d.Y/ry)^2<=1 then inside=true;s=s or record(target);if s.Statue<=0 then s.Owner=owner end;break end
      end
     end
     if inside then break end
    end
   end
   if s then
    if inside and not s.InPool then target:SetAttribute('GoldenPoolContact',(target:GetAttribute('GoldenPoolContact')or 0)+1)end
    s.InPool=inside
    local was=s.Statue>0
    if not Gate.PausedExcept(target,'GoldenStatue')then
     local e=Rules.Step(s,dt,inside)
     if e.StatueStarted then statue(target,s,f)end
     if e.Damage>0 and s.Owner and living(s.Owner)then hit:Fire(s.Owner,target,e.Damage,false,'GoldenStatue')end
     if e.StatueEnded then s.Anchor=nil;Gate.Resume(target,'GoldenStatue');target:SetAttribute('GoldenStatue',false);impact(s.Owner,pos(f),f.radius*2)end
    end
    target:SetAttribute('GoldenSlowMultiplier',Rules.SpeedMultiplier(s))
    s.Publish=s.Publish+dt
    if s.Publish>=.05 or was~=(s.Statue>0)then s.Publish=0;target:SetAttribute('GoldenGilding',s.Gold)end
   end
  end
 end
 for m,s in pairs(statuses)do if not present[m]or not living(m)then release(m,s);statuses[m]=nil end end
 M.Enforce(fighters)
end
-- Cleanup must not depend on ArenaMovement still advancing after the round.
state:GetAttributeChangedSignal('Phase'):Connect(function()
 if state:GetAttribute('Phase')~='Fighting'then M.Reset()end
end)
state:GetAttributeChangedSignal('RoundId'):Connect(function()M.Reset();round=state:GetAttribute('RoundId')end)
return M
