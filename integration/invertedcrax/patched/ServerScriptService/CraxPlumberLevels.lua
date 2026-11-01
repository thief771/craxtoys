local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- PlumberFinale_v3
-- PlumberFix_v2
-- PlumberLevels_v1: all damage, pickups and movement are server-authoritative.
local SSS=game:GetService('ServerScriptService')
local RS=game:GetService('ReplicatedStorage')
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState')
local event=RS:WaitForChild('CraxPlumberLevelEvent')
local hit=SSS:WaitForChild('BiteHit')
local Spatial=require(SSS:WaitForChild('PlumberSpatialRules'))
local M={};local records={};local serial=0;local rng=Random.new()
local function now()return workspace:GetServerTimeNow()end
local function level(m)return m:GetAttribute('CraxSkillLevel')or 0 end
local function vec(p,z)return Vector3.new(p.X,p.Y,z)end
local function send(kind,payload)payload.RoundId=state:GetAttribute('RoundId');event:FireAllClients(kind,payload)end
-- CombatHealth emits this only after resolving protection and the real health loss.
SSS:WaitForChild('FantasticDamageConfirmed').Event:Connect(function(attacker,target,lost,kind,round)
 if kind~='PlumberPiranha' or type(lost)~='number' or lost<=0 or round~=state:GetAttribute('RoundId') then return end
 if not attacker or attacker:GetAttribute('CraxId')~='Crax_Plumber' or not target or not target.Parent then return end
 local h=target:FindFirstChild('Head',true)
 if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 if h then send('PlantBiteHit',{Owner=attacker,Target=target,Damage=lost,Position=h.Position,Radius=math.max(h.Size.X,h.Size.Y)*.5})end
end)
local function uid()serial=serial+1;return serial end
local function active(f)
 return f.model.Parent and f.model:GetAttribute('CraxId')=='Crax_Plumber'and(f.model:GetAttribute('Health')or 0)>0 and state:GetAttribute('Phase')=='Fighting'and not state:GetAttribute('DeadlyDemoActive')
end
local function available(f)
 return active(f)and not Gate.Paused(f.model)and not state:GetAttribute('GhostNightActive')and not f.capturedBy and not f.model:GetAttribute('FantasticPinned')
end
local function record(f)
 local r=records[f.model]
 if not r then r={clock=0,jets={},plants={},nextStar=10,owner=f};records[f.model]=r end
 return r
end
local function targetAllowed(owner,g)
 return g.model~=owner.model and g.model.Parent and(g.model:GetAttribute('Health')or 0)>0 and not Deadly.SameTeam(owner.model,g.model)
  and not g.model:GetAttribute('PlumberInTransit')and not g.model:GetAttribute('FantasticInvisible')and not g.model:GetAttribute('DeadlyPhantom')
end
local function damage(f,g,amount,kind)
 if targetAllowed(f,g)then hit:Fire(f.model,g.model,amount,false,kind)end
end
local function push(g,n)
 -- Use the same scripted knockback channel as ArenaMovement, never physics velocity.
 g.knockback={velocity=n*76,remaining=.18}
end
local function removeItem(item)
 send('Remove',{Id=item.id})
end
function M.Clear(model)
 local r=records[model];if not r then return end
 for _,j in ipairs(r.jets)do removeItem(j)end
 for _,p in pairs(r.plants)do removeItem(p)end
 if r.star then removeItem(r.star)end
 records[model]=nil
 if model.Parent then model:SetAttribute('PlumberStarUntil',nil)end
end
function M.Reset()
 local list={};for model in pairs(records)do list[#list+1]=model end
 for _,model in ipairs(list)do M.Clear(model)end
 send('Reset',{})
end
function M.Enter(f,transit)
 local r=records[f.model];if not r then return end
 for index,p in pairs(r.plants)do
  if p.pipe==transit.Entry or p.pipe==transit.Exit then removeItem(p);r.plants[index]=nil end
 end
end
function M.Exit(f,pipe,network)
 if level(f.model)<1 or #network.pipes<4 then return end
 local r=record(f);local p=pipe.Point;local n=pipe.Normal
 local length
 if n.X>0 then length=24-p.X elseif n.X<0 then length=p.X+24 elseif n.Y>0 then length=45-p.Y else length=p.Y-5 end
 local j={id=uid(),pipe=pipe,point=p,normal=n,length=math.max(.1,length),untilTime=r.clock+2,nextHit={},previous={}}
 for index,plant in pairs(r.plants)do if plant.pipe==pipe then removeItem(plant);r.plants[index]=nil end end
 r.jets[#r.jets+1]=j
 send('Jet',{Id=j.id,Owner=f.model,Start=vec(p,f.depth),Finish=vec(p+n*j.length,f.depth),Radius=f.radius*.43,StartedAt=now(),Duration=2})
end
local function busy(f,r,network,pipe)
 if network.transit and(network.transit.Entry==pipe or network.transit.Exit==pipe)then return true end
 if(f.position-pipe.Point).Magnitude<f.radius*1.65 then return true end
 for _,j in ipairs(r.jets)do if j.pipe==pipe and j.untilTime>r.clock then return true end end
 return r.plants[pipe.Index]~=nil
end
local function spawnPlant(f,r,network)
 if not InvertedSilence.CanStart(f.model)then return false end
 local free={};for _,pipe in ipairs(network.pipes)do if not busy(f,r,network,pipe)then free[#free+1]=pipe end end
 if #free==0 then return false end
 local pipe=free[rng:NextInteger(1,#free)]
 local p={id=uid(),pipe=pipe,start=r.clock,activeAt=r.clock+.35,untilTime=r.clock+3.7,bite=0}
 r.plants[pipe.Index]=p
 send('Plant',{Id=p.id,Owner=f.model,Frame=pipe.Frame,Radius=f.radius,StartedAt=now(),Duration=3.7})
 return true
end
local function spawnStar(f,r,network)
 if not InvertedSilence.CanStart(f.model)then return end
 if #network.pipes==0 or r.star or rng:NextNumber()>=.5 then return end
 local pipe=network.pipes[rng:NextInteger(1,#network.pipes)]
 local p=pipe.Point+pipe.Normal*(f.radius*.8)
 local a=rng:NextNumber(0,math.pi*2);local direction=Vector2.new(math.cos(a),math.sin(a))
 local star={id=uid(),position=Vector2.new(math.clamp(p.X,-23,23),math.clamp(p.Y,6,44)),velocity=direction*62,radius=math.max(.3,f.radius*.25),untilTime=r.clock+5,nextTurn=r.clock+.32,net=0}
 r.star=star
 send('Star',{Id=star.id,Owner=f.model,Position=vec(star.position,f.depth),Radius=star.radius,StartedAt=now(),Duration=5})
end
local function segmentDistance(p,a,b)
 local d=b-a;local dd=d:Dot(d);local t=dd>0 and math.clamp((p-a):Dot(d)/dd,0,1)or 0
 return(p-(a+d*t)).Magnitude
end
local function starStep(f,r,dt)
 local star=r.star;if not star then return end
 if r.clock>=star.untilTime then removeItem(star);r.star=nil;return end
 local old=star.position
 if r.clock>=star.nextTurn then
  local a=rng:NextNumber(-.62,.62);local v=star.velocity
  star.velocity=Vector2.new(v.X*math.cos(a)-v.Y*math.sin(a),v.X*math.sin(a)+v.Y*math.cos(a)).Unit*62
  star.nextTurn=r.clock+rng:NextNumber(.22,.58)
 end
 local p=star.position+star.velocity*dt;local v=star.velocity;local bounce=false
 local minX,maxX=-24+star.radius,24-star.radius;local minY,maxY=5+star.radius,45-star.radius
 if p.X<minX or p.X>maxX then p=Vector2.new(math.clamp(p.X,minX,maxX),p.Y);v=Vector2.new(-v.X,v.Y);bounce=true end
 if p.Y<minY or p.Y>maxY then p=Vector2.new(p.X,math.clamp(p.Y,minY,maxY));v=Vector2.new(v.X,-v.Y);bounce=true end
 star.position=p;star.velocity=v;star.net=star.net+dt
 if not f.model:GetAttribute('PlumberInTransit')and segmentDistance(f.position,old,p)<=f.radius+star.radius then
  f.model:SetAttribute('PlumberStarUntil',now()+7)
  send('Collect',{Id=star.id,Owner=f.model,Position=vec(p,f.depth),Until=now()+7});r.star=nil;return
 end
 if star.net>=.05 or bounce then
  star.net=0;send('StarMove',{Id=star.id,Position=vec(p,f.depth),Bounce=bounce})
 end
end
local currentTargets={}
function M.Step(fighters,logic,dt,enabled)
 local targets=Deadly.MotionTargets(fighters);currentTargets=targets
 for _,f in ipairs(fighters)do
  if not active(f)then M.Clear(f.model)
  else
   local r=record(f);local network=logic:Get(f.model)
   local can=enabled and available(f)
   if not can then
    -- End short effects cleanly when another cinematic suspends combat.
    for _,j in ipairs(r.jets)do removeItem(j)end;r.jets={}
    for _,p in pairs(r.plants)do removeItem(p)end;r.plants={}
    if r.star then removeItem(r.star);r.star=nil end
   else
    r.clock=r.clock+dt
    for i=#r.jets,1,-1 do
     local j=r.jets[i]
     if r.clock>=j.untilTime then removeItem(j);table.remove(r.jets,i)
     else
      for _,g in ipairs(targets)do
       j.previous[g.model]=g.position
      end
     end
    end
    if level(f.model)>=2 and #network.pipes>=6 then
     r.nextPlant=r.nextPlant or(r.clock+5)
     if r.clock>=r.nextPlant and spawnPlant(f,r,network)then r.nextPlant=r.clock+5 end
    end
    for index,p in pairs(r.plants)do
     local occupied=network.transit and(network.transit.Entry==p.pipe or network.transit.Exit==p.pipe)
     if occupied or r.clock>=p.untilTime then removeItem(p);r.plants[index]=nil
     else
      local elapsed=r.clock-p.activeAt
      -- Six closures at .5, 1, 1.5, 2, 2.5 and 3 seconds.
      local wanted=math.min(6,math.max(0,math.floor((elapsed+1e-7)/.5)))
      while p.bite<wanted do
       p.bite=p.bite+1
       send('PlantSnap',{Id=p.id,Index=p.bite,Position=p.pipe.Frame:PointToWorldSpace(Vector3.new(0,f.radius*2.15,0))})
       local mouth3=p.pipe.Frame:PointToWorldSpace(Vector3.new(0,f.radius*2.15,0))
       local mouth=Vector2.new(mouth3.X,mouth3.Y)
       for _,g in ipairs(targets)do
        if targetAllowed(f,g)and(g.position-mouth).Magnitude<=g.radius+f.radius*.7 then
         damage(f,g,10,'PlumberPiranha')
        end
       end
      end
     end
    end
    if level(f.model)>=3 and r.clock>=r.nextStar then
     r.nextStar=r.clock+10;spawnStar(f,r,network)
    end
    starStep(f,r,dt)
   end
  end
 end
end
function M.EnforceBarriers()
 if state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('GhostNightActive')then return end
 for _,r in pairs(records)do
  local f=r.owner
  if available(f)then
   for _,j in ipairs(r.jets)do
    if r.clock<j.untilTime then
     for _,g in ipairs(currentTargets)do
      if targetAllowed(f,g)and not g.capturedBy and not g.model:GetAttribute('FantasticPinned')and not Deadly.Hold(g.model)then
       local p,v,out=Spatial.WaterWall(g.position,j.previous[g.model]or g.position,g.velocity,j.point,j.normal,j.length,f.radius*.43,g.radius)
       if p then
        g.position=p;g.velocity=v
        if g.knockback then
         local into=g.knockback.velocity:Dot(out)
         if into<0 then g.knockback.velocity=g.knockback.velocity-out*(2*into)end
        end
        if r.clock>=(j.nextHit[g.model]or 0)then
         j.nextHit[g.model]=r.clock+.4;damage(f,g,5,'PlumberPressure')
         send('Contact',{Position=vec(p,g.depth or f.depth),Water=true})
        end
       end
       j.previous[g.model]=g.position
      end
     end
    end
   end
  end
 end
end
return M
