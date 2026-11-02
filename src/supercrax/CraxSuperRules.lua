-- Pure rules/geometry, no services. Directions and randomness are supplied by the server.
local R={}
function R.New(level,random,c)
 return {level=math.clamp(level,0,4),time=0,age=0,mode=nil,nextDash=random(c.DashWait[1],c.DashWait[2]),nextLaser=random(c.LaserWait[1],c.LaserWait[2]),contacts=0,ready={},serial=0,lastStand=false}
end
function R.Contact(r,normal,loss,c)
 if r.level>=2 and normal and loss>0 then r.contacts=math.min(c.FrostContacts,r.contacts+1);if r.contacts>=c.FrostContacts then r.ready.Frost=r.ready.Frost or r.time end end
end
function R.Advance(r,dt,canStart,random,c)
 assert(dt>=0 and dt<math.huge);local out={};r.time+=dt
 if r.mode then
  local duration=r.mode=='Dash'and c.DashDuration or(r.mode=='Laser'and c.LaserDuration or(c.FrostCharge+c.FrostDuration))
  local used=math.min(dt,math.max(0,duration-r.age));local before=r.age;r.age+=used
  out.active={kind=r.mode,before=before,after=r.age,dt=used}
  if r.age>=duration-1e-9 then
   out.ended=r.mode
   if c.CooldownOrigin=='End'and r.mode=='Dash'then r.nextDash=r.time+random(c.DashWait[1],c.DashWait[2])elseif c.CooldownOrigin=='End'and r.mode=='Laser'then r.nextLaser=r.time+random(c.LaserWait[1],c.LaserWait[2])end
   r.mode=nil;r.age=0
  end
  return out
 end
 if r.time>=r.nextDash then r.ready.Dash=r.ready.Dash or r.nextDash end
 if r.level>=1 and r.time>=r.nextLaser then r.ready.Laser=r.ready.Laser or r.nextLaser end
 if r.level>=2 and r.contacts>=c.FrostContacts then r.ready.Frost=r.ready.Frost or r.time end
 if not canStart then return out end
 local best,deadline
 -- Oldest ready wins; tie order is explicit. Ready skills cannot be starved by newly ready skills.
 for _,kind in ipairs({'Frost','Dash','Laser'})do local t=r.ready[kind];if t and(not deadline or t<deadline)then best=kind;deadline=t end end
 if best then
  r.mode=best;r.age=0;r.serial+=1;r.ready[best]=nil
  if best=='Frost'then r.contacts=0 end
  if c.CooldownOrigin=='Launch'then if best=='Dash'then r.nextDash=r.time+random(c.DashWait[1],c.DashWait[2])elseif best=='Laser'then r.nextLaser=r.time+random(c.LaserWait[1],c.LaserWait[2])end end
  out.started=best
 end
 return out
end
function R.LastStand(r,damage,hp,canStart)
 if r.lastStand then return 0,false end
 if r.level>=3 and damage>=hp and damage>0 and canStart then r.lastStand=true;return math.max(0,hp-1),true end
 return damage,false
end
function R.Turn(age,c)return math.min(c.DashTurns,math.floor(math.max(0,age)/c.DashDuration*c.DashTurns)+1)end
function R.MarkDashHit(hits,target,turn,c)
 local key=c.DashHitPolicy=='PerTurn'and turn or 1
 if hits[target]==key then return false end;hits[target]=key;return true
end
function R.Farthest(x,y,b)
 local best,dist
 for _,p in ipairs({{b.minX,b.minY},{b.minX,b.maxY},{b.maxX,b.minY},{b.maxX,b.maxY}})do
  local d=(p[1]-x)^2+(p[2]-y)^2
  if not dist or d>dist then best=p;dist=d end
 end
 local dx,dy=best[1]-x,best[2]-y;local length=math.sqrt(dx*dx+dy*dy)
 return dx/length,dy/length,length
end
-- Intervals of a moving point inside a finite capsule. Supports target sweep, not a point sample.
local function linear(a,d,lo,hi)
 if math.abs(d)<1e-12 then if a>=lo and a<=hi then return 0,1 end;return end
 local x,y=(lo-a)/d,(hi-a)/d;if x>y then x,y=y,x end
 x,y=math.max(0,x),math.min(1,y);if y>x then return x,y end
end
local function circle(px,py,vx,vy,cx,cy,r)
 px-=cx;py-=cy;local a=vx*vx+vy*vy;local cc=px*px+py*py-r*r
 if a<1e-18 then if cc<=0 then return 0,1 end;return end
 local b=2*(px*vx+py*vy);local discriminant=b*b-4*a*cc;if discriminant<=0 then return end
 local q=math.sqrt(discriminant);local x,y=math.max(0,(-b-q)/(2*a)),math.min(1,(-b+q)/(2*a));if y>x then return x,y end
end
function R.Exposure(px0,py0,px1,py1,beams,radius)
 local intervals={};local vx,vy=px1-px0,py1-py0
 for _,beam in ipairs(beams)do
  if beam.length>1e-9 then
  local px,py=px0-beam.x,py0-beam.y
  local dx,dy=beam.dx,beam.dy;local length=beam.length
  local a,b=linear(px*dx+py*dy,vx*dx+vy*dy,0,length)
  local c,d=linear(px*dy-py*dx,vx*dy-vy*dx,-radius,radius)
  if a and c then local lo,hi=math.max(a,c),math.min(b,d);if hi>lo then intervals[#intervals+1]={lo,hi}end end
  for _,endp in ipairs({0,length})do local lo,hi=circle(px,py,vx,vy,dx*endp,dy*endp,radius);if lo then intervals[#intervals+1]={lo,hi}end end
  end
 end
 table.sort(intervals,function(a,b)return a[1]<b[1]end)
 local total,lo,hi=0
 for _,i in ipairs(intervals)do
  if not lo then lo,hi=i[1],i[2]elseif i[1]<=hi then hi=math.max(hi,i[2])else total+=hi-lo;lo,hi=i[1],i[2]end
 end
 if lo then total+=hi-lo end
 return math.clamp(total,0,1)
end
return R
