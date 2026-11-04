-- Per-source suppression. No inventory/level/CraxId swapping and no delayed attribute snapshots.
local SSS=game:GetService('ServerScriptService');local state=workspace:WaitForChild('CombatState');local M={};local entries={};local adapters={};local fighters={};local clock=0
function M.Register(id,cancel,individual)assert(type(cancel)=='function');adapters[id]={cancel=cancel,individual=individual~=false}end
function M.Supported(id)return adapters[id]~=nil end
function M.Begin(list)M.Reset();fighters=list end
function M.Apply(owner,target,duration,token)
 local id=target:GetAttribute('CraxId');local adapter=adapters[id];if not adapter then return false,'Annulation non intégrée : '..tostring(id)end
 -- Global family cleanups are only safe in the inspected two-root architecture.
 for _,f in ipairs(fighters)do if not adapter.individual and f.model~=target and f.model:GetAttribute('CraxId')==id and(f.model:GetAttribute('Health')or 0)>0 then return false,'Plusieurs propriétaires de cette famille : adaptateur individuel requis'end end
 local ok,err=pcall(function()local burning=SSS:FindFirstChild('CraxBurning');if burning then require(burning).CancelLuckyOwner(target)end;adapter.cancel(target,fighters)end);if not ok then return false,tostring(err)end
 local group=entries[target]or{};entries[target]=group;group[token]={owner=owner,untilTime=clock+duration};target:SetAttribute('LuckyTricked',true);target:SetAttribute('LuckyCheatRemaining',duration);return true
end
function M.Step(dt,enabled)
 if enabled then clock+=dt end
 for target,group in pairs(entries)do
  local remaining=0
  for key,e in pairs(group)do if not target.Parent or not e.owner.Parent or(target:GetAttribute('Health')or 0)<=0 or(e.owner:GetAttribute('Health')or 0)<=0 or e.untilTime<=clock then group[key]=nil else remaining=math.max(remaining,e.untilTime-clock)end end
  if not next(group)then if target.Parent then target:SetAttribute('LuckyTricked',nil);target:SetAttribute('LuckyCheatRemaining',nil)end;entries[target]=nil else target:SetAttribute('LuckyCheatRemaining',math.ceil(remaining*10)/10)end
 end
end
function M.RemoveOwner(owner)for _,group in pairs(entries)do for key,e in pairs(group)do if e.owner==owner then group[key]=nil end end end;M.Step(0,false)end
function M.Reset()for m in pairs(entries)do if m.Parent then m:SetAttribute('LuckyTricked',nil);m:SetAttribute('LuckyCheatRemaining',nil)end end;entries={};clock=0 end
return M
