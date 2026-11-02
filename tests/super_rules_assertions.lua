local checks=0
local function check(v,m)checks+=1;assert(v,m)end
local function close(a,b,m)check(math.abs(a-b)<1e-7,m)end
local random=function(a,b)return(a+b)/2 end
check(C.DashHitPolicy=='PerTurn','creator chose per-turn hits')
check(C.ChannelMobile==true,'creator chose mobile channel')
check(C.LastStandHealing=='LOCK_AT_ONE','creator chose strict1HP')
check(C.PricePolicy=='ReferenceMonsterConfirmed','creator chose reference prices')
close(C.DashDuration,1.5,'dash duration');check(C.DashTurns==3,'three circles')
local hits={};local target={};local total=0
for turn=1,3 do for frame=1,60 do if R.MarkDashHit(hits,target,turn,C)then total+=C.Melee*C.DashDamageMultiplier end end end
close(total,48,'one 16 hit per turn, maximum48 activation')
close(R.Exposure(10,0,10,0,{{x=0,y=0,dx=1,dy=0,length=20},{x=0,y=0,dx=1,dy=0,length=20}},1),1,'two beams union is1, not2')
close(R.Exposure(10,-2,10,2,{{x=0,y=0,dx=1,dy=0,length=20}},1),.5,'continuous crossing half exposure')
close(R.Exposure(10,5,10,5,{{x=0,y=0,dx=1,dy=0,length=20}},1),0,'outside beams zero exposure')
close(R.Exposure(0,0,0,0,{{x=0,y=0,dx=1,dy=0,length=0}},5),0,'blocked zero-length ray causes no damage')
local laser=0
for i=1,300 do laser+=C.LaserDPS/120*R.Exposure(10,0,10,0,{{x=0,y=0,dx=1,dy=0,length=20},{x=0,y=0,dx=1,dy=0,length=20}},1)end
close(laser,37.5,'full 2.5s union exposure37.5, no tick rounding')
local r=R.New(3,random,C);local amount,activated=R.LastStand(r,100,100,true)
check(amount==99 and activated and r.lastStand,'lethal intercepted to1 before death')
check(R.LastStand(r,900,1,true)==0,'ordinary damage blocked after rescue')
local muted=R.New(3,random,C);amount,activated=R.LastStand(muted,100,100,false);check(amount==100 and not activated and not muted.lastStand,'SILENCE blocks new lethal passive')
local base=R.New(0,random,C);amount,activated=R.LastStand(base,100,100,true);check(amount==100 and not activated,'no passive before level3')
local c=R.New(2,random,C);R.Contact(c,true,8,C);R.Contact(c,false,15,C);R.Contact(c,true,0,C);check(c.contacts==1,'laser/blocked contact not counted')
R.Contact(c,true,8,C);R.Contact(c,true,8,C);check(c.contacts==3 and c.ready.Frost~=nil,'third effective normal contact queues frost')
local e=R.Advance(c,0,true,random,C);check(e.started=='Frost'and c.contacts==0,'frost counter reset on start')
for i=1,240 do R.Advance(c,1/120,false,random,C)end;close(c.age,2,'channel lasts2 while new starts silenced')
for i=1,420 do R.Advance(c,1/120,false,random,C)end;check(c.mode==nil,'frost completes total5.5 under SILENCE')
local s=R.New(3,random,C);local startTimes={};local endTimes={};local lastMode;local laserDuration=0;local dashDuration=0
for i=1,7200 do
 local out=R.Advance(s,1/120,true,random,C)
 if out.started then startTimes[#startTimes+1]={kind=out.started,time=s.time};check(lastMode==nil,'active skills serialize');lastMode=out.started end
 if out.active then if out.active.kind=='Dash'then dashDuration+=out.active.dt elseif out.active.kind=='Laser'then laserDuration+=out.active.dt end end
 if out.ended then endTimes[out.ended]=s.time;lastMode=nil end
end
check(#startTimes>5,'scheduler exercises several activations')
for _,event in ipairs(startTimes)do check(event.kind~='Frost','no frost before contacts')end
local p=R.New(0,random,C);R.Advance(p,10,true,random,C);check(p.mode=='Dash','base dash ready8..12')
R.Advance(p,1.5,false,random,C);check(p.mode==nil,'active dash completes under silence');close(p.nextDash-p.time,10,'new random cooldown after finish')
local x,y,length=R.Farthest(-20,10,{minX=-24,maxX=24,minY=5,maxY=45});check(x>0 and y>0 and length>40,'frost aims farthest arena corner, not enemy')
close(C.Finale.ChargeEnd-C.Finale.ChargeStart,1.5,'MAX charge exactly1.5')
print('SUPER PURE RULES PASS',checks,'assertions');return checks
