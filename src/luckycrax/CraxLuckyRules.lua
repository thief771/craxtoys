local R={}
function R.Dice(a,b,c)assert(a%1==0 and b%1==0 and a>=1 and a<=6 and b>=1 and b<=6);return(a+b)*c.DiceMultiplier+(a==b and c.DiceDoubleBonus or 0)end
function R.Reward(u,c)local total=c.Weights.Heal+c.Weights.Coins+c.Weights.Cheat;local v=u*total;if v<c.Weights.Heal then return'Heal'elseif v<c.Weights.Heal+c.Weights.Coins then return'Coins'else return'Cheat'end end
function R.New(level,random,c)return{level=level,time=0,due={Coin=random(c.CoinWait[1],c.CoinWait[2]),Dice=random(c.DiceWait[1],c.DiceWait[2]),Reels=random(c.ReelsWait[1],c.ReelsWait[2])},received={},count=0}end
function R.Next(r,c)
 if r.cast then return end;local best,t
 for i,kind in ipairs({'Coin','Dice','Reels'})do if r.level>=({Coin=0,Dice=1,Reels=3})[kind]and r.time>=r.due[kind]and(not t or r.due[kind]<t)then best=kind;t=r.due[kind]end end
 return best
end
function R.Received(r,key,loss,c)
 if r.level<2 or loss<=0 or r.readyUntil and r.readyUntil>r.time or r.received[key]then return false end
 r.received[key]=true;r.count+=1;if r.count>=c.CloverHits then r.count=0;r.readyUntil=r.time+c.CloverDuration;return true end;return false
end
function R.Dodge(r,c)if r and r.readyUntil and r.time<r.readyUntil then r.readyUntil=nil;r.count=0;r.received={};return true end;return false end
function R.Sweep(a,b,p,r)
 local v=b-a;local d=a-p;local cc=d:Dot(d)-r*r;if cc<=0 then return 0 end
 local aa=v:Dot(v);if aa<1e-12 then return end;local bb=2*d:Dot(v);local disc=bb*bb-4*aa*cc;if disc<0 then return end
 local t=(-bb-math.sqrt(disc))/(2*aa);if t>=0 and t<=1 then return t end
end
-- Exact first wall time within a movement interval, corners count as one bounce.
function R.Wall(p,v,b,dt)
 local t,x,y=dt,false,false
 for _,d in ipairs({{'X',b.minX,b.maxX},{'Y',b.minY,b.maxY}})do
  local axis,lo,hi=d[1],d[2],d[3];local speed=v[axis]
  if math.abs(speed)>1e-10 then local q=((speed>0 and hi or lo)-p[axis])/speed
   if q>=-1e-9 and q<=t+1e-9 then if q<t-1e-9 then x=false;y=false end;t=math.max(0,q);if axis=='X'then x=true else y=true end end
  end
 end
 return t,x,y
end
return R
