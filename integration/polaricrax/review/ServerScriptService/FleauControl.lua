-- PolariCraxIntegrationV1
-- Shared timed controls + external source locks (Domino contact remains refreshed by its owner).
local Gate=require(game:GetService('ServerScriptService'):WaitForChild('CraxAbilityGate'))
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
 for model,r in pairs(records)do
  if not model.Parent or model:GetAttribute('FleauFury')or(model:GetAttribute('Health')or 0)<=0 then C.Clear(model)
  else
   for key,expires in pairs(r)do if expires<=now then r[key]=nil;Gate.Resume(model,'FleauStun:'..key)end end
   if not next(r)then C.Clear(model)end
  end
 end
end
function C.Reset()local all={};for m in pairs(records)do all[#all+1]=m end;for _,m in ipairs(all)do C.Clear(m)end end
function C.PolariDelay(dt)for _,r in pairs(records)do for k,v in pairs(r)do r[k]=v+dt end end end
return C
