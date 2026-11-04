-- LuckyCraxIntegrationV1
-- PlumberBugFix_v5
-- PlumberFix_v2
-- PlumberLevels_v1
-- PlumberIntegration_v1: authoritative integration for the supplied ArenaMovement.
local SSS=game:GetService('ServerScriptService')
local RS=game:GetService('ReplicatedStorage')
local Gate=require(SSS:WaitForChild('CraxAbilityGate'))
local Core=require(SSS:WaitForChild('CraxPlumberCore'))
local state=workspace:WaitForChild('CombatState')
local assets=RS:WaitForChild('CraxPlumberAssets')
local event=RS:WaitForChild('CraxPlumberEvent')
local logic=Core.new();local fighters={};local records={}
local Levels=require(SSS:WaitForChild('CraxPlumberLevels'))
local Spatial=require(SSS:WaitForChild('PlumberSpatialRules'))
local exitRandom=Random.new()
local M={};local Z=Vector3.new(0,0,1)
local normal={Left=Vector2.new(1,0),Right=Vector2.new(-1,0),Bottom=Vector2.new(0,1),Top=Vector2.new(0,-1)}
local function now()return workspace:GetServerTimeNow()end
local function isPlumber(model)
 return model:GetAttribute('CraxId')=='Crax_Plumber'and model:GetAttribute('AbilityId')=='PlumberPipe'
end
local function vec(p,depth)return Vector3.new(p.X,p.Y,depth)end
local function frame(p,n,depth)
 local up=Vector3.new(n.X,n.Y,0);return CFrame.fromMatrix(vec(p,depth),up:Cross(Z),up,Z)
end
local function cap(model,white)
 local saved=records[model];if not saved then saved={colours={}};records[model]=saved end
 for _,part in ipairs(model:GetDescendants())do
  if part:IsA('BasePart')and part.Name:sub(1,3)=='Cap'then
   if not saved.colours[part]then saved.colours[part]=part.Color end
   if white then
    local name=part.Name:lower();part.Color=(name:find('large_c',1,true)or name:find('raised_c',1,true))and Color3.fromRGB(196,13,22)or Color3.fromRGB(248,248,242)
   else part.Color=saved.colours[part]end
  end
 end
 model:SetAttribute('PlumberWhiteCap',white)
end
local function allowed(f)
 return isPlumber(f.model)and state:GetAttribute('Phase')=='Fighting'and(f.model:GetAttribute('Health')or 0)>0
  and not Gate.Paused(f.model)and not state:GetAttribute('GhostNightActive')and not state:GetAttribute('DeadlyDemoActive')
  and not f.capturedBy and not f.model:GetAttribute('FantasticPinned')
end
function M.ContactDamage(model)
 if isPlumber(model)then if(model:GetAttribute('PlumberStarUntil')or 0)>now()then return 40 end;return logic:Damage(model,now())end
 return model:GetAttribute('CollisionDamage')or 0
end
function M.Hold(model)
 local r=logic.records[model];return r~=nil and r.transit~=nil
end
function M.Speed(f)
 if not isPlumber(f.model)or not allowed(f)then return 1 end
 if(f.model:GetAttribute('PlumberStarUntil')or 0)>now()then return 1.6 end
 local r=logic:Get(f.model);local t=now()
 return r.boostUntil>t and 1.20*((r.impulseUntil or 0)>t and 1.12 or 1)or 1
end
local function destroy(model)
 Levels.Clear(model)
 local r=logic:Clear(model)
 if r then for _,pipe in ipairs(r.pipes)do if pipe.Model then pipe.Model:Destroy()end end end
 if model.Parent then
  cap(model,false);model:SetAttribute('PlumberInTransit',nil);model:SetAttribute('PlumberPipeCount',nil);model:SetAttribute('PlumberBoostUntil',nil)
 end
 event:FireAllClients('Cancel',model);records[model]=nil
end
function M.Reset()
 Levels.Reset()
 local list={};for model in pairs(logic.records)do list[#list+1]=model end
 for _,model in ipairs(list)do destroy(model)end
end
function M.Bind(list)M.Reset();fighters=list end
local function pose(f,p)return CFrame.new(p.X,p.Y,f.depth)*f.rotation end
function M.Wall(f,side)
 if not allowed(f)or M.Hold(f.model)then return end
 -- Only the bound fighter which physically touched this wall may create a pipe.
 local registered=false
 for _,fighter in ipairs(fighters)do if fighter==f then registered=true;break end end
 if not registered then return end
 local contact=side=='Left'and math.abs(f.position.X-(-24+f.radius))
  or side=='Right'and math.abs(f.position.X-(24-f.radius))
  or side=='Bottom'and math.abs(f.position.Y-(5+f.radius))
  or side=='Top'and math.abs(f.position.Y-(45-f.radius))
 if not contact or contact>.2 then return end
 local n=normal[side];if not n then return end
 local model=f.model;local r=logic:Get(model);local t=now()
 if r.boostUntil>t or #r.pipes>=6 or t<r.nextWall then return end
 local point=f.position-n*(f.radius-.12)
 -- Snap the normal coordinate to the real arena wall, never a fighter's centre.
 if side=='Left'then point=Vector2.new(-23.88,point.Y)
 elseif side=='Right'then point=Vector2.new(23.88,point.Y)
 elseif side=='Bottom'then point=Vector2.new(point.X,5.12)
 else point=Vector2.new(point.X,44.88)end
 local occupied={}
 for _,network in pairs(logic.records)do for _,pipe in ipairs(network.pipes)do occupied[#occupied+1]=pipe end end
 point=Spatial.WallSlot(point,side,f.radius,occupied)
 if not point then return end
 local tangent=(side=='Left'or side=='Right')and point.Y or point.X
 local key=side..':'..tostring(math.floor(tangent/math.max(1,f.radius*1.2)))
 local index=#r.pipes+1;local colour=({'Vert','Vert','Orange','Orange','Rouge','Rouge'})[index]
 local template=assets:FindFirstChild('Pipe'..colour)
 if not template then warn('Plumber : modèle de tuyau absent : '..colour);return end
 local pipeModel=template:Clone();local mouth=frame(point,n,f.depth)
 local size=template:GetAttribute('MouthInnerDiameter');if type(size)~='number'or size<=0 then pipeModel:Destroy();return end
 pipeModel:ScaleTo(pipeModel:GetScale()*(f.radius*2.04/size));pipeModel:PivotTo(mouth)
 local pipe={Owner=model,RoundId=state:GetAttribute('RoundId'),Key=key,Side=side,Point=point,Normal=n,Frame=mouth,Model=pipeModel,Radius=f.radius}
 local ok=logic:Add(model,pipe,t)
 if not ok then pipeModel:Destroy();return end
 local folder=workspace:FindFirstChild('CraxPlumberPipes')
 if not folder then folder=Instance.new('Folder');folder.Name='CraxPlumberPipes';folder.Parent=workspace end
 pipeModel.Name=model.Name..'_Pipe_'..pipe.Index;pipeModel:SetAttribute('PlumberOwner',model.Name);pipeModel:SetAttribute('PlumberOwnerCraxId','Crax_Plumber');pipeModel:SetAttribute('PlumberRoundId',state:GetAttribute('RoundId'));pipeModel:SetAttribute('PipeIndex',pipe.Index);pipeModel.Parent=folder
 model:SetAttribute('PlumberPipeCount',#r.pipes)
 event:FireAllClients('PipeCreated',model,mouth,nil,{Pipe=pipeModel})
end
local function cancel(f,t)
 if t then
  f.position=t.Exited and t.EndPosition or t.StartPosition;f.velocity=t.SavedVelocity
  event:FireAllClients('Cancel',f.model)
 end
 logic:Cancel(f.model);f.model:SetAttribute('PlumberInTransit',nil)
end
function M.Step(dt,enabled)
 for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Plumber"and f.model:GetAttribute("LuckyTricked")then return end end
 local t=now()
 for _,f in ipairs(fighters)do
  local model=f.model
  if not model.Parent or not isPlumber(model)or(model:GetAttribute('Health')or 0)<=0 or state:GetAttribute('Phase')~='Fighting'then
   if logic.records[model]then destroy(model)end
  else
   local r=logic:Get(model)
   if not enabled or not allowed(f)then if r.transit then cancel(f,r.transit)end end
   local events,transit=logic:Advance(model,t)
   for _,kind in ipairs(events)do
    if kind=='Exit'then
     f.position=transit.EndPosition
     local n=transit.Exit.Normal;local tangent=Vector2.new(-n.Y,n.X)
     local angle=exitRandom:NextNumber(-math.pi*.42,math.pi*.42)
     f.velocity=(n*math.cos(angle)+tangent*math.sin(angle)).Unit*f.speed
     transit.SavedVelocity=f.velocity
     r.white=true;cap(model,true);model:SetAttribute('PlumberBoostUntil',r.boostUntil)
     Levels.Exit(f,transit.Exit,r)
    elseif kind=='End'then model:SetAttribute('PlumberInTransit',nil)
    elseif kind=='Red'then cap(model,false);model:SetAttribute('PlumberBoostUntil',nil)end
   end
   if enabled and allowed(f)and not r.transit then
    local contacts={}
    for _,pipe in ipairs(r.pipes)do
     local centre=pipe.Point+pipe.Normal*(f.radius*.50)
     if(f.position-centre).Magnitude<=f.radius*.82+.14 then contacts[pipe.Index]=true end
    end
    local transit=logic:Contact(model,contacts,t)
    if transit then
     Levels.Enter(f,transit)
     transit.StartPosition=f.position;transit.SavedVelocity=f.velocity
     local p=transit.Exit.Point+transit.Exit.Normal*(f.radius+.80)
     p=Vector2.new(math.clamp(p.X,-24+f.radius,24-f.radius),math.clamp(p.Y,5+f.radius,45-f.radius))
     transit.EndPosition=p;model:SetAttribute('PlumberInTransit',true);f.knockback=nil
     local packet={StartPivot=pose(f,f.position),EndPivot=pose(f,p),StartedAt=t,WaterScale=math.max(.6,f.radius*.8),RoundId=state:GetAttribute('RoundId')}
     event:FireAllClients('Transit',model,transit.Entry.Frame,transit.Exit.Frame,packet)
    end
   end
  end
 end
 Levels.Step(fighters,logic,dt,enabled)
end
function M.EnforceBarriers()Levels.EnforceBarriers()end
return M
