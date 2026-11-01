-- Deterministic server rules; no Roblox services or client-supplied decisions.
local R={}
local function finite(v)return type(v)=='number'and v==v and math.abs(v)<math.huge end
function R.Round(v)assert(finite(v)and v>=0);return math.floor(v+.5)end
function R.New(round,identity,level,random)
 assert(type(random)=='function')
 local wait=random(5,9);assert(wait>=5 and wait<=9)
 return {round=round,identity=identity,level=math.clamp(level,0,4),time=0,nextMute=wait,count=0,pending=nil,mark=nil,markAttempted=false,returned=false,alive=true}
end
function R.Received(r,amount,melee)
 if not r.alive or r.level<2 or not melee or not finite(amount)or amount<=0 or r.pending~=nil then return false end
 r.count=r.count+1
 if r.count==3 then r.pending=amount;return true end
 return false
end
function R.Base(r)return r and r.alive and r.pending~=nil and math.max(8,r.pending)or 8 end
function R.Consume(r,lost,melee)
 if r and r.alive and melee and lost>0 and r.pending~=nil then r.pending=nil;r.count=0;return true end
 return false
end
function R.Damage(amount,vulnerable)
 assert(finite(amount)and amount>=0)
 if amount==0 then return 0 end
 return R.Round(amount*(vulnerable and 1.10 or 1))
end
function R.Cancel(r)r.alive=false;r.mark=nil;r.pending=nil;r.count=0 end
-- Silenced at t=10 => the single marking opportunity is lost, never delayed.
-- A mark already placed always returns even if subsequently silenced.
function R.Advance(r,dt,context,random)
 assert(finite(dt)and dt>=0)
 local e={}
 if not r.alive then return e end
 if context.round~=r.round or context.identity~=r.identity or not context.alive then
  e.cancel=r.mark~=nil;R.Cancel(r);return e
 end
 if not context.active or context.paused then return e end
 local before=r.time;r.time=r.time+dt
 if r.level>=3 and not r.markAttempted and r.time>=10-1e-8 then
  r.markAttempted=true
  if not context.silenced then
   r.mark={position=context.position,health=context.health};e.mark=r.mark
  else e.markSkipped=true end
 end
 if r.mark and not r.returned and r.time>=20-1e-8 then
  r.returned=true;e.restore=r.mark;r.mark=nil
 end
 if r.time>=r.nextMute and not context.silenced then
  e.mute=true
  local wait=random(5,9);assert(wait>=5 and wait<=9)
  r.nextMute=r.time+wait
 end
 return e
end
function R.ApplyStatus(s,time,hack)
 s=s or {};s.silence=math.max(s.silence or 0,time+5)
 if hack then
  s.vulnerable=math.max(s.vulnerable or 0,time+5)
  s.hack=math.max(s.hack or 0,time+4)
  s.nextDirection=time
 end
 return s
end
return R
