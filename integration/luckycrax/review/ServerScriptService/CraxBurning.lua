-- LuckyCraxIntegrationV1
-- Effet serveur partagé : require(CraxBurning).Apply(attacker, target).
local SSS=game:GetService("ServerScriptService")
local Gate=require(SSS:WaitForChild("CraxAbilityGate"))
local hit=SSS:WaitForChild("BiteHit")
local state=workspace:WaitForChild("CombatState")
local M={};local records={};local luckySerial=0
function M.Clear(target)
 records[target]=nil
 if target.Parent then target:SetAttribute("BurningActive",false);target:SetAttribute("BurningRemaining",0)end
end
function M.Reset()
 local targets={};for target in pairs(records)do targets[#targets+1]=target end
 for _,target in ipairs(targets)do M.Clear(target)end
end
function M.CancelLuckyOwner(owner)
 local Deadly=require(SSS.CraxDeadlyRuntime);local targets={};for target,r in pairs(records)do if r.attacker==owner or Deadly.Root(r.attacker)==owner then targets[#targets+1]=target end end;for _,target in ipairs(targets)do M.Clear(target)end
end
function M.Apply(attacker,target)
 if attacker and attacker:GetAttribute('LuckyTricked')then return false end
 if attacker and target and require(SSS:WaitForChild('CraxDeadlyRuntime')).SameTeam(attacker,target)then return false end
 if not attacker or not target or attacker==target or state:GetAttribute("Phase")~="Fighting"then return false end
 if target:GetAttribute("FantasticInvisible")or(target:GetAttribute("Health")or 0)<=0 then return false end
 local record=records[target]
 if record then record.remaining=3;record.attacker=attacker
 else luckySerial+=1;record={attacker=attacker,remaining=3,tick=0,round=state:GetAttribute("RoundId"),luckyAttackId=luckySerial};records[target]=record end
 target:SetAttribute("BurningActive",true);target:SetAttribute("BurningRemaining",3)
 return true
end
function M.Step(dt)
 if state:GetAttribute("Phase")~="Fighting"then M.Reset();return end
 if state:GetAttribute("GhostNightActive")then return end
 for target,r in pairs(records)do
  if not target.Parent or r.round~=state:GetAttribute("RoundId")or(target:GetAttribute("Health")or 0)<=0 then M.Clear(target)
  elseif not Gate.Paused(target)and not target:GetAttribute("FantasticInvisible")then
   local advance=math.min(dt,r.remaining);r.remaining=math.max(0,r.remaining-advance);r.tick=r.tick+advance
   while r.tick>=1-1e-8 do
    r.tick=r.tick-1;hit:Fire(r.attacker,target,5,false,"Burning",nil,r.luckyAttackId)
   end
   target:SetAttribute("BurningRemaining",r.remaining)
   if r.remaining<=1e-8 then M.Clear(target)end
  end
 end
end
return M

