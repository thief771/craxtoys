-- Horloges et priorité indépendantes de la géométrie et de l'affichage.
local M={}
function M.New(level,random)
 return {level=level,random=random,time=0,reinforce=0,reinforceWait=random(7,11),torch=0,
  torchPending=0,damageLost=0,nextThreshold=40,elastic=false,elasticWait=random(5,10),
  invisible=0,invisibleUsed=false,invisiblePending=false,healed=0}
end
function M.Lost(r,amount)
 if r.level<1 or amount<=0 then return end
 r.damageLost=r.damageLost+amount
 while r.damageLost>=r.nextThreshold do
  r.nextThreshold=r.nextThreshold+40;r.torchPending=r.torchPending+1
 end
end
function M.ElasticFinished(r)
 r.elastic=false;r.elasticWait=r.random(5,10)
end
function M.Step(r,dt,externalBusy,roundElapsed,canStart)
 canStart=canStart~=false
 local out={}
 r.time=roundElapsed or(r.time+dt)
 if r.level>=2 and not r.invisibleUsed and r.time>=15 then r.invisiblePending=true end
 if r.invisible>0 then
  local active=math.min(dt,r.invisible)
  r.invisible=math.max(0,r.invisible-dt)
  local healing=math.min(20-r.healed,active*20/3)
  r.healed=r.healed+healing;out.heal=healing
  if r.invisible<=1e-8 then r.invisible=0;out.invisibleEnd=true end
  return out
 end
 if canStart and r.invisiblePending and r.reinforce==0 and r.torch==0 and not r.elastic and not externalBusy then
  r.invisiblePending=false;r.invisibleUsed=true;r.invisible=3;r.healed=0
  out.invisibleStart=true;return out
 end
 if r.reinforce>0 then
  r.reinforce=math.max(0,r.reinforce-dt)
  if r.reinforce==0 then r.reinforceWait=r.random(7,11);out.reinforceEnd=true end
 else r.reinforceWait=math.max(0,r.reinforceWait-dt)end
 if r.torch>0 then r.torch=math.max(0,r.torch-dt);if r.torch==0 then out.torchEnd=true end end
 if not r.elastic then r.elasticWait=math.max(0,r.elasticWait-dt)end
 -- Une invisibilité en attente bloque seulement les nouvelles activations.
 if r.invisiblePending then return out end
 if canStart and r.reinforce==0 and r.reinforceWait==0 then r.reinforce=4;out.reinforceStart=true end
 if canStart and r.torch==0 and r.torchPending>0 then r.torchPending=r.torchPending-1;r.torch=7;out.torchStart=true end
 if canStart and r.level>=3 and not r.elastic and r.elasticWait==0 and not externalBusy then r.elastic=true;out.elasticStart=true end
 return out
end
return M
