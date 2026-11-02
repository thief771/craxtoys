local n=0
local function check(v,m)n+=1;assert(v,m)end
local function close(x,y,m)check(math.abs(x-y)<1e-6,m)end
local killed={}
M.KillHealthBatch=function(requests,round,match)
 for _,request in ipairs(requests)do check(M.ValidateCrystalKill(request.model,request.carrier,round,match,request.token),'crystal kill proof validated')end
 for _,request in ipairs(requests)do killed[#killed+1]=request;request.model:SetAttribute('Health',0)end
 state:SetAttribute('Phase','RoundOver');return true
end
local function tick(dt)
 now+=dt;M.Step(dt,fighters,true)
 for _,f in ipairs(fighters)do Locks.Enforce(f);f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
end
local function advance(seconds)for i=1,math.floor(seconds*120+.5)do tick(1/120)end end
local function reset(level)
 M.Reset();state:SetAttribute('RoundId',state:GetAttribute('RoundId')+1);state:SetAttribute('Phase','Fighting')
 a:SetAttribute('CraxSkillLevel',level);a:SetAttribute('Health',100);b:SetAttribute('Health',100);a:SetAttribute('InvertedSilenced',nil)
 fa.position=Vector2.new(0,25);fb.position=Vector2.new(10,26.9);fa.velocity=Vector2.new(25,0);fb.velocity=Vector2.new(25,0)
 for _,f in ipairs(fighters)do f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
 events={};hitLog={};M.Begin(fighters)
end
reset(1);advance(9.02)
local damage=0;for _,h in ipairs(hitLog)do if h.kind=='SuperLaser'then damage+=h.amount end end
close(damage,37.5,'real runtime: overlapping lasers total37.5')
check(angleCalls==2,'laser directions generated independently by two server draws')
check(not a:GetAttribute('SuperSteel'),'laser gives no steel')
reset(0);advance(10.02);check(a:GetAttribute('SuperSteel')==true,'steel starts with dash')
check(M.Incoming(a,500,100,b,'Power')==0,'steel blocks ordinary lethal damage')
for i=1,180 do fb.position=fa.position;tick(1/120);check(fa.position.X>=-20-1e-7 and fa.position.X<=20+1e-7 and fa.position.Y>=9-1e-7 and fa.position.Y<=41+1e-7,'circle stays inside real walls')end
local dash=0;for _,h in ipairs(hitLog)do if h.kind=='SuperDash'then dash+=h.amount end end
close(dash,48,'three confirmed turn opportunities16 each, no per-frame damage')
check(not a:GetAttribute('SuperSteel'),'steel stops with dash')
check(M.Incoming(a,500,100,b,'Power')==500,'base character cannot rescue after steel')
reset(2);fb.position=Vector2.new(-12,15)
M.Confirm(a,b,8,0,true);M.Confirm(a,b,8,0,true);M.Confirm(a,b,8,0,true);tick(1/120)
check(a:GetAttribute('SuperMode')=='Frost','third melee starts frost')
check(not M.Held(a),'confirmed mobile channel remains mobile')
advance(2.03);check(b:GetAttribute('SuperFrozen')and Gate.Paused(b),'real freeze uses existing lock/gate')
check(M.ContactDamage(a,b,8)==35,'shatter replaces8 with35')
M.Confirm(a,b,35,0,true);check(not b:GetAttribute('SuperFrozen')and not Gate.Paused(b),'shatter releases owned freeze')
advance(1);check(not b:GetAttribute('SuperFrozen'),'same breath cannot refreeze after shatter')
reset(2);fb.position=Vector2.new(-12,15);for i=1,3 do M.Confirm(a,b,8,0,true)end;tick(1/120);advance(5.5)
check(b:GetAttribute('SuperFrozen')==true,'freeze maintained through full wind')
advance(4.8);check(b:GetAttribute('SuperFrozen')==true,'freeze remains almost5 after final exposure')
advance(.3);check(not b:GetAttribute('SuperFrozen')and not Gate.Paused(b),'freeze expires and mobility restored')
reset(3);local allowed=M.Incoming(a,100,100,b,'Power');check(allowed==99,'actual runtime rescues at1')
a:SetAttribute('Health',1);check(M.AllowHeal(a,50)==0,'creator strict1HP blocks heals')
check(M.Incoming(a,.125,1,b,'SuperLaser')==0,'ordinary periodic damage blocked after rescue')
local stone;for _,e in ipairs(events)do if e.kind=='Crystal'then stone=e.data end end
check(stone and(stone.Position-Vector3.new(0,25,-2.5)).Magnitude>10,'crystal spawned accessible and away from owner')
fb.position=Vector2.new(stone.Position.X,stone.Position.Y);tick(.001)
close(M.Speed(b),1.5,'enemy carrier +50% modifier')
tick(.001);close(M.Speed(b),1.5,'repeated contact does not stack bonus')
advance(10.02);check(a:GetAttribute('SuperSteel')==true,'invincible hero retains base power')
fb.position=fa.position;tick(.001)
check(a:GetAttribute('Health')==0 and #killed>=1,'kryptonite bypasses ordinary immortality AND steel')
close(M.Speed(b),1,'speed modifier removed on final crystal death')
reset(3);M.Incoming(a,100,100,b,'Power');a:SetAttribute('Health',1)
for _,e in ipairs(events)do if e.kind=='Crystal'then stone=e.data end end
fa.position=Vector2.new(stone.Position.X,stone.Position.Y);tick(.001)
check(a:GetAttribute('Health')==0,'owner touching ground crystal dies')
reset(3);a:SetAttribute('InvertedSilenced',true)
check(M.Incoming(a,100,100,b,'Power')==100 and not a:GetAttribute('SuperInvincible'),'SILENCE blocks fresh lethal passive')
reset(2);Locks.Lock(fb,'Fantastic');for i=1,3 do M.Confirm(a,b,8,0,true)end;fb.position=Vector2.new(-12,15);tick(1/120);advance(2.03)
M.Confirm(a,b,35,0,true)
check(fb.velocity.Magnitude==0,'releasing ice preserves another position lock')
Locks.Unlock(fb,'Fantastic');check(fb.velocity.Magnitude>0,'final original lock restores saved motion')
M.Reset();check(not a:GetAttribute('SuperMode')and not b:GetAttribute('SuperFrozen'),'reset clears temporary flags')
print('SUPER REAL RUNTIME PASS',n,'assertions');return n
