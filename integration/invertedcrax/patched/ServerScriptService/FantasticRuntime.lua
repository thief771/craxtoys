local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- GoldenCombatBase_v1
-- FantasticRuntime_v9
local SSS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local Rig=require(RS:WaitForChild("FantasticHandRig"))
local PositionLock=require(SSS:WaitForChild('CraxPositionLock'))
local Schedule=require(SSS:WaitForChild("FantasticSchedule"))
local Burning=require(SSS:WaitForChild("CraxBurning"))
local Gate=require(SSS:WaitForChild("CraxAbilityGate"))
local state=workspace:WaitForChild("CombatState")
local Deadly=require(SSS:WaitForChild("CraxDeadlyRuntime"))
local hit=SSS:WaitForChild("BiteHit")
local heal=SSS:WaitForChild("CraxHeal")
local confirmed=SSS:WaitForChild("FantasticDamageConfirmed")
local FX=RS:WaitForChild("FantasticHandFX")
local nextId=0
local random=Random.new();local M={};local records={};local round;local started=workspace:GetServerTimeNow()
local folder=Instance.new("Folder");folder.Name="FantasticHandVisuals";folder.Parent=workspace
local function isFantastic(model)return model:GetAttribute("AbilityId")=="FantasticRock"end
local function part(name,size,color,parent)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Color=color;p.Material=Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent;return p
end
local function rope(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.01,d.Magnitude));p.CFrame=CFrame.lookAt((a+b)/2,b)
end
local function release(r)
 local h=r.hand;if not h then return end
 r.lastHandId=h.id;FX:FireAllClients("Release",{Id=h.id,Owner=r.f.model.Name})
 if h.target then
  h.target.model:SetAttribute("FantasticGrabbed",false)
  Gate.Resume(h.target.model,"FantasticHand")
 end
 PositionLock.Unlock(r.f)
 r.f.model:SetAttribute("FantasticPinned",false);r.f.model:SetAttribute("FantasticElastic",false)
 if h.visual then h.visual:Destroy()end;r.hand=nil;Schedule.ElasticFinished(r.schedule)
end
function M.Reset()
 for model,r in pairs(records)do
  release(r);Gate.Resume(model,"FantasticInvisible")
  for _,key in ipairs({"FantasticInvisible","FantasticReinforced","FantasticTorch","FantasticPinned","FantasticElastic","FantasticGrabbed"})do model:SetAttribute(key,false)end
 end
 records={};Burning.Reset();folder:ClearAllChildren();round=state:GetAttribute("RoundId");started=workspace:GetServerTimeNow()
end
local function launch(r)
 local f=r.f;local angle=random:NextNumber(0,math.pi*2)
 local group=Instance.new("Model");group.Name="ElasticHand";group.Parent=folder
 nextId=nextId+1
 r.hand={position=f.position,direction=Vector2.new(math.cos(angle),math.sin(angle)),elapsed=0,
  path={f.position},visual=group,grip=0,stage="windup",windup=0,tick=0,turnWait=random:NextNumber(.55,1.1),id=nextId,angle=angle-math.pi/2}
 FX:FireAllClients("Launch",{Id=nextId,Owner=f.model.Name})
 PositionLock.Lock(f)
 f.model:SetAttribute("FantasticPinned",true);f.model:SetAttribute("FantasticElastic",true)
end
local function firstHit(a,b,center,radius)
 local d=b-a;local offset=a-center;local length2=d:Dot(d)
 if offset:Dot(offset)<=radius*radius then return 0 end
 if length2<1e-9 then return nil end
 local v=offset:Dot(d);local disc=v*v-length2*(offset:Dot(offset)-radius*radius)
 if disc<0 then return nil end
 local u=(-v-math.sqrt(disc))/length2
 if u>=0 and u<=1 then return u end
end
local function pose(r,force)
 local h=r.hand;if not h then return end
 local now=workspace:GetServerTimeNow()
 if not force and now-(h.sent or 0)<1/30 then return end
 h.sent=now
 local depth=h.target and h.target.depth+h.target.radius*.95 or r.f.depth+r.f.head.Size.Z*.48+.2
 local points={Vector3.new(r.f.position.X,r.f.position.Y,depth)}
 local last=h.stage=='out'and #h.path or math.max(1,h.index or #h.path)
 for i=2,last do points[#points+1]=Vector3.new(h.path[i].X,h.path[i].Y,depth)end
 points[#points+1]=Vector3.new(h.position.X,h.position.Y,depth)
 FX:FireAllClients('Pose',{Id=h.id,Round=round,Owner=r.f.model.Name,Target=h.target and h.target.model.Name,
  CF=CFrame.new(h.position.X,h.position.Y,depth)*CFrame.Angles(0,0,h.angle or 0)*CFrame.Angles(0,math.pi,0),
  Grip=h.grip,Scale=h.target and math.clamp(h.target.radius*.68,1.9,3.06)or 1.9,
  Radius=h.target and h.target.radius or 0,Depth=h.target and h.target.depth-depth or 0,
  Points=points,Stage=h.stage,GrabAge=h.grabTime or 0})
end
local function handStep(r,enemy,dt)
 local h=r.hand;if not h then return end
 if h.target and (not h.target.model.Parent or(h.target.model:GetAttribute('Health')or 0)<=0
  or h.target.model:GetAttribute('DeadlyPhantom')or workspace:GetServerTimeNow()<(h.target.model:GetAttribute('GhostTeleportUntil')or 0))then release(r);return end
 if h.stage=='windup'then
  h.windup=h.windup+dt;local u=math.clamp(h.windup/.18,0,1)
  h.position=r.f.position+h.direction*(r.f.radius*.55*u*u*(3-2*u))
  if u==1 then h.path[#h.path+1]=h.position;h.stage='out' end
 elseif h.stage=='grab'then
  h.grabTime=h.grabTime+dt;local u=math.clamp(h.grabTime/.28,0,1);local smooth=u*u*(3-2*u)
  h.position=h.grabFrom+(h.grabGoal-h.grabFrom)*smooth;h.grip=math.clamp((h.grabTime-.08)/.48,0,1)
  if h.grabTime>=1.5 then h.stage='return';h.index=#h.path;h.position=h.grabGoal end
 elseif h.stage=='out'then
  local remaining=math.min(dt,math.max(0,4-h.elapsed));h.elapsed=h.elapsed+remaining
  local canGrab=not enemy.model:GetAttribute('FantasticInvisible')and not enemy.capturedBy and not enemy.model:GetAttribute('FantasticGrabbed')
  local safety=0
  while remaining>1e-7 and h.stage=='out'and safety<16 do
   safety=safety+1;local a=h.position;local dir=h.direction
   local tx=dir.X>1e-8 and (22.6-a.X)/(dir.X*48)or dir.X< -1e-8 and (-22.6-a.X)/(dir.X*48)or math.huge
   local ty=dir.Y>1e-8 and (43.6-a.Y)/(dir.Y*48)or dir.Y< -1e-8 and (6.4-a.Y)/(dir.Y*48)or math.huge
   local step=math.max(0,math.min(remaining,tx,ty,h.turnWait));local b=a+dir*48*step
   local u,chosen=nil,nil
   for _,candidate in ipairs(Deadly.MotionTargets({r.f,enemy}))do
    if not Deadly.SameTeam(r.f.model,candidate.model)and(candidate.model:GetAttribute('Health')or 0)>0
     and not candidate.model:GetAttribute('FantasticInvisible')and not candidate.model:GetAttribute('DeadlyPhantom')and not candidate.capturedBy and not candidate.model:GetAttribute('FantasticGrabbed')then
     local entry=firstHit(a,b,candidate.position,candidate.radius+1.3)
     if entry and(not u or entry<u)then u=entry;chosen=candidate end
    end
   end
   if chosen then enemy=chosen end
   if u then
    h.position=a+(b-a)*u;h.path[#h.path+1]=h.position;h.target=enemy;h.stage='grab';h.grabTime=0;h.grabFrom=h.position;h.grabGoal=enemy.position
    enemy.model:SetAttribute('FantasticGrabbed',true);Gate.Pause(enemy.model,'FantasticHand')
    FX:FireAllClients('Grab',{Id=h.id,Owner=r.f.model.Name,Target=enemy.model.Name});break
   end
   h.position=b;remaining=remaining-step;h.turnWait=h.turnWait-step
   if step>=tx-1e-7 or step>=ty-1e-7 then
    h.path[#h.path+1]=b
    h.direction=Vector2.new(step>=tx-1e-7 and -dir.X or dir.X,step>=ty-1e-7 and -dir.Y or dir.Y)
    FX:FireAllClients('Bounce',{Id=h.id,Owner=r.f.model.Name})
   elseif h.turnWait>1e-7 then break end
   if h.turnWait<=1e-7 then
    if (h.path[#h.path]-b).Magnitude>.01 then h.path[#h.path+1]=b end
    local angle=math.atan2(h.direction.Y,h.direction.X)+random:NextNumber(-2.15,2.15)
    h.direction=Vector2.new(math.cos(angle),math.sin(angle));h.turnWait=random:NextNumber(.55,1.1)
   end
  end
  h.angle=math.atan2(h.direction.Y,h.direction.X)-math.pi/2
  if h.stage=='out'and h.elapsed>=4-1e-7 then h.stage='return';h.index=#h.path end
 else
  local distance=48*dt;local moving=dt
  while distance>1e-7 and h.index>=1 do
   local goal=h.path[h.index];local delta=goal-h.position;local length=delta.Magnitude
   local nextPosition=length<=distance and goal or h.position+delta.Unit*distance
   if length>.001 then h.angle=math.atan2(-delta.Y,-delta.X)-math.pi/2 end
   -- Les doigts pointent à l’opposé de la traction ; le poignet accompagne le trajet.
   if h.target and h.index<=2 then
    local u=firstHit(h.position,nextPosition,r.f.position,r.f.radius+h.target.radius-.02)
    if u then nextPosition=h.position+(nextPosition-h.position)*u;moving=math.max(0,dt-(distance-(nextPosition-h.position).Magnitude)/48);h.index=0 end
   end
   local used=(nextPosition-h.position).Magnitude;h.position=nextPosition;distance=math.max(0,distance-used)
   if h.index==0 then break end
   if length<=used+1e-7 then h.index=h.index-1 else break end
  end
  if h.target then
   h.target.position=h.position;h.tick=h.tick+moving
   while h.tick>=.2-1e-8 do h.tick=h.tick-.2;hit:Fire(r.f.model,h.target.model,2,false,'FantasticElastic')end
  end
  if h.index<1 then
   if h.target and (h.target.position-r.f.position).Magnitude<r.f.radius+h.target.radius-.05 then
    local d=h.target.position-r.f.position;local direction=d.Magnitude>.001 and d.Unit or Vector2.new(1,0)
    h.target.position=r.f.position+direction*(r.f.radius+h.target.radius-.02);h.position=h.target.position
   end
   pose(r,true);release(r);return
  end
 end
 pose(r,false)
end

confirmed.Event:Connect(function(attacker,defender,lost,kind,roundId)
 if roundId~=round or state:GetAttribute("Phase")~="Fighting"then return end
 if kind=="FantasticElastic"and lost>0 then
  local owner=records[attacker];local h=owner and owner.hand
  local id=h and h.id or owner and owner.lastHandId
  if id then owner.damageSequence=(owner.damageSequence or 0)+1;FX:FireAllClients("Tick",{Id=id,Owner=attacker.Name,Target=defender.Name,Damage=lost,Sequence=owner.damageSequence,At=workspace:GetServerTimeNow()})end
 end
 local r=records[defender];if r then Schedule.Lost(r.schedule,lost)end
 if kind=="FantasticTorch"and lost>0 then Burning.Apply(attacker,defender)end
end)
function M.BlockContact(a,b)
 return a.model:GetAttribute("FantasticInvisible")or b.model:GetAttribute("FantasticInvisible")
  or a.model:GetAttribute("FantasticGrabbed")or b.model:GetAttribute("FantasticGrabbed")
end
function M.Hold(f)return f.model:GetAttribute("FantasticPinned")or f.model:GetAttribute("FantasticGrabbed")end
function M.Step(dt,fighters)
 if round~=state:GetAttribute("RoundId")then M.Reset()end
 if state:GetAttribute("Phase")~="Fighting"or state:GetAttribute('GhostNightActive')then return end
 Burning.Step(dt)
 for index,f in ipairs(fighters)do
  PositionLock.Enforce(f)
  if isFantastic(f.model)then
   local r=records[f.model]
   if not r then
    r={f=f,schedule=Schedule.New(f.model:GetAttribute("CraxSkillLevel")or 0,function(a,b)return random:NextNumber(a,b)end),contact=-1}
    records[f.model]=r
   end
   local s=r.schedule;local enemy=fighters[3-index]
   if not f.model:GetAttribute("GoldenStatue")and (f.model:GetAttribute("Health")or 0)>0 and (s.invisible>0 or not Gate.Paused(f.model))then
    local actions=Schedule.Step(s,dt,f.sting~=nil or f.capturedBy~=nil or f.model:GetAttribute("FantasticGrabbed"),workspace:GetServerTimeNow()-started,InvertedSilence.CanStart(f.model))
    if actions.invisibleStart then f.model:SetAttribute("FantasticInvisible",true);Gate.Pause(f.model,"FantasticInvisible")end
    if actions.heal and actions.heal>0 then heal:Fire(f.model,actions.heal)end
    if actions.invisibleEnd then f.model:SetAttribute("FantasticInvisible",false);Gate.Resume(f.model,"FantasticInvisible")end
    if actions.reinforceStart then f.model:SetAttribute("FantasticReinforced",true)end
    if actions.reinforceEnd then f.model:SetAttribute("FantasticReinforced",false)end
    if actions.torchStart then f.model:SetAttribute("FantasticTorch",true)end
    if actions.torchEnd then f.model:SetAttribute("FantasticTorch",false)end
    if actions.elasticStart then launch(r)end
    if s.invisible==0 then
     if r.hand then handStep(r,enemy,dt)end
     if s.torch>0 and s.time-r.contact>=1-1e-8 then
      local touched=false
      for _,candidate in ipairs(Deadly.MotionTargets(fighters))do
       if not Deadly.SameTeam(f.model,candidate.model)and not candidate.model:GetAttribute('FantasticInvisible')and not candidate.model:GetAttribute('DeadlyPhantom')and(candidate.position-f.position).Magnitude<=f.radius+candidate.radius+.18 then
        touched=true;hit:Fire(f.model,candidate.model,20,false,'FantasticTorch')
       end
      end
      if touched then r.contact=s.time end
     end
    end
   end
  end
 end
end
return M
