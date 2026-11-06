-- PolariCraxIntegrationV1
-- Shared timed controls + external source locks (Domino contact remains refreshed by its owner).
local Gate=require(game:GetService('ServerScriptService'):WaitForChild('CraxAbilityGate'))
local previous=workspace:GetServerTimeNow()
local C={};local records=setmetatable({},{__mode='k'})
function C.Apply(model,key,duration)
 if model:GetAttribute('FleauFury')then return false end
 local r=records[model]or {};records[model]=r
 r[key]=math.max(r[key]or 0,workspace:GetServerTimeNow()+duration)
 Gate.Pause(model,'FleauStun:'..key);model:SetAttribute('FleauStunned',true)
 model:SetAttribute('FleauStunUntil',math.max(model:GetAttribute('FleauStunUntil')or 0,r[key]));return true
end
function C.Clear(model)
 local r=records[model];if r then for key in pairs(r)do Gate.Resume(model,'FleauStun:'..key)end end
 records[model]=nil
 if model.Parent then model:SetAttribute('FleauStunned',false);model:SetAttribute('FleauStunUntil',nil)end
end
function C.Step()
 local now=workspace:GetServerTimeNow()
 local dt=math.max(0,now-previous);previous=now
 if workspace.CombatState:GetAttribute('KillaFogActive')then
  for model,r in pairs(records)do
   local latest=0;for key,expires in pairs(r)do r[key]=expires+dt;latest=math.max(latest,r[key])end
   if model.Parent then model:SetAttribute('FleauStunUntil',latest)end
  end
  return
 end
 for model,r in pairs(records)do
  if not model.Parent or model:GetAttribute('FleauFury')or(model:GetAttribute('Health')or 0)<=0 then C.Clear(model)
  else
   for key,expires in pairs(r)do if expires<=now then r[key]=nil;Gate.Resume(model,'FleauStun:'..key)end end
   if not next(r)then C.Clear(model)end
  end
 end
end
function C.Reset()local all={};for m in pairs(records)do all[#all+1]=m end;for _,m in ipairs(all)do C.Clear(m)end end
function C.RemoveSource(model,key)
 local r=records[model];if not r or not r[key]then return end;r[key]=nil;Gate.Resume(model,'FleauStun:'..key)
 local latest=0;for _,v in pairs(r)do latest=math.max(latest,v)end
 if latest==0 then records[model]=nil end
 if model.Parent then model:SetAttribute('FleauStunned',latest>0);model:SetAttribute('FleauStunUntil',latest>0 and latest or nil)end
end
function C.DelaySource(model,key,dt)
 local r=records[model];if r and r[key]then r[key]=r[key]+math.max(0,dt);model:SetAttribute('FleauStunUntil',math.max(model:GetAttribute('FleauStunUntil')or 0,r[key]))end
end
function C.SetSourceRemaining(model,key,seconds)
 if seconds<=0 then C.RemoveSource(model,key);return end
 local r=records[model];if not r or not r[key]then return C.Apply(model,key,seconds)end
 r[key]=workspace:GetServerTimeNow()+seconds;local latest=0;for _,v in pairs(r)do latest=math.max(latest,v)end
 model:SetAttribute('FleauStunUntil',latest);model:SetAttribute('FleauStunned',true)
end

function C.PolariDelay(dt)for _,r in pairs(records)do for k,v in pairs(r)do r[k]=v+dt end end end
return C
