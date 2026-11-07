-- Advance only absolute deadlines by the time deliberately omitted from arena simulation.
-- Relative timers, trajectories, velocities, captures and other lock reasons are left intact.
local SS=game:GetService('ServerScriptService');local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local state=workspace:WaitForChild('CombatState');local M={}
local keys={'PlumberStarUntil','PlumberBoostUntil','GhostDodgeUntil','GhostTeleportUntil','SpideyPoisonUntil','SpideyStingingUntil','SilkSlowUntil','FleauStunUntil','DeadlySlowUntil'}
function M.Shift(dt,fighters)
 if dt<=0 then return end
 for _,f in ipairs(Deadly.MotionTargets(fighters))do
  local m=f.model;for _,key in ipairs(keys)do local value=m:GetAttribute(key);if type(value)=='number'and value>0 then m:SetAttribute(key,value+dt)end end
  if f.sting then for _,k in ipairs({'started','expires'})do if f.sting[k]then f.sting[k]+=dt end end end
  if f.pendingSting and f.pendingSting.deadline then f.pendingSting.deadline+=dt end
 end
 for _,key in ipairs({'GhostFreezeUntil','GhostNightEnd','GhostGrandFrissonEnd'})do local value=state:GetAttribute(key);if type(value)=='number'and value>0 then state:SetAttribute(key,value+dt)end end
 for _,name in ipairs({'CraxSpideyRuntime','CraxPlumberRuntime','FleauRuntime','FleauControl','FantasticRuntime','GhostyNight','CraxDeadlyRuntime','CraxBatRuntime'})do
  local module=SS:FindFirstChild(name);if module then local runtime=require(module);assert(runtime.PolariDelay,'Adaptateur de pause manquant : '..name);runtime.PolariDelay(dt)end
 end
end
return M
