-- CraxCombinedFix_v7
-- Pure deterministic rules. No Roblox services; tested independently.
local R={}
R.Config={Health=145,Speed=30,Contact=8,RagePerHP=(2/1.2),MaxRage=100,
 RageHit=15,Thresholds={30,60},Windup=2,ChargeDamage=20,Stun=2.5,
 WindupMultiplier=.2,RollInterval=10,RollChance=.5,GiantDuration=10,
 GiantHP=300,GiantContact=10,GiantFlatReduction=50,GiantScale=1.55,
 RageLock=3,FuryDuration=5,FuryDamage=30,ChargeSpeed=80,FurySpeed=105,
 FinaleDuration=12,ReductionOrder='FLAT_THEN_PERCENT',
 FuryHealing='REJECT',FuryControls='IGNORE',Prices={5000,15000,30000,50000},Gems={30,80,150,250}}
local C=R.Config
function R.New(level)
 return {level=level or 0,rage=0,used={},queue={},mode='Normal',time=0,
  rollAt=C.RollInterval,giantUsed=false,furyUsed=false,lock=0,pass=0,hits={}}
end
function R.ResetCycle(s) s.rage=0;s.used={};s.queue={} end
function R.Loss(s,hp)
 assert(type(hp)=='number'and hp>=0 and hp<math.huge,'invalid loss')
 if s.mode=='Fury'or s.lock>0 or hp==0 then return end
 local old=s.rage;s.rage=math.min(C.MaxRage,old+hp*C.RagePerHP)
 if s.level>=1 then for _,threshold in ipairs(C.Thresholds)do
  if old<threshold and s.rage>=threshold and not s.used[threshold]then
   s.used[threshold]=true;s.queue[#s.queue+1]=threshold
  end
 end end
end
function R.Protect(s,amount)
 assert(type(amount)=='number'and amount>=0 and amount<math.huge,'invalid damage')
 if s.mode=='Fury'then return 0 end
 if s.giant then amount=amount*.5 end
 if s.mode=='Windup'then amount=amount*C.WindupMultiplier end
 return amount
end
function R.Contact(s)
 if s.mode=='Fury'or s.mode=='Charge'or s.mode=='Windup'then return 0,'Controlled'end
 if s.rage>=100 then return C.RageHit,'Rage'end
 return s.giant and C.GiantContact or C.Contact,'Normal'
end
function R.Consume(s,kind) if kind=='Rage'then R.ResetCycle(s)end end
function R.Lethal(s)
 if s.level<3 or s.furyUsed then return false end
 s.furyUsed=true;s.mode='Fury';s.time=0;s.rage=300;s.queue={};s.giant=false;s.savedHP=nil;s.pass=s.pass+1;s.hits={}
 return true
end
function R.Giant(s,hp,max)
 if s.giantUsed or s.mode=='Fury'then return false end
 s.giantUsed=true;s.giant=true;s.giantAge=0;s.savedHP=hp;s.savedMax=max
 return true
end
function R.Pass(s) s.pass=s.pass+1;s.hits={} end
function R.Hit(s,id) if s.hits[id]then return false end;s.hits[id]=true;return true end
function R.Tick(s,dt,roll,canStart)
 canStart=canStart~=false
 assert(dt>=0 and dt<math.huge,'invalid dt')
 local e={};s.lock=math.max(0,s.lock-dt)
 if s.mode=='Fury'then
  s.time=s.time+dt;s.rage=300*math.min(1,math.max(0,C.FuryDuration-s.time))
  if s.time>=C.FuryDuration then e.exhaust=true end
  return e
 end
 s.elapsed=(s.elapsed or 0)+dt
 if canStart and s.level>=2 and not s.giantUsed then
  while s.elapsed>=s.rollAt do s.rollAt=s.rollAt+C.RollInterval
   if roll()<C.RollChance then e.giant=true;break end
  end
 end
 if s.giant then
  s.giantAge=s.giantAge+dt
  if s.giantAge>=C.GiantDuration then
   e.restore={s.savedHP,s.savedMax};s.giant=false;s.savedHP=nil;R.ResetCycle(s);s.lock=C.RageLock
  end
 end
 if canStart and s.mode=='Normal'and #s.queue>0 then
  table.remove(s.queue,1);s.mode='Windup';s.time=0;e.windup=true
 elseif s.mode=='Windup'then
  s.time=s.time+dt;if s.time>=C.Windup then s.mode='Charge';s.time=0;R.Pass(s);e.charge=true end
 end
 return e
end
return R
