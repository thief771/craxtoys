-- Service stand-ins for the REAL Super runtime and lock code, not duplicated gameplay rules.
local now=0;local V={}
V.__index=function(t,k)
 if k=='Magnitude'then return math.sqrt(t.X*t.X+t.Y*t.Y+(t.Z or 0)^2)end
 if k=='Unit'then local m=t.Magnitude;return setmetatable({X=t.X/m,Y=t.Y/m,Z=(t.Z or 0)/m},V)end
 return V[k]
end
V.__add=function(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=(a.Z or 0)+(b.Z or 0)},V)end
V.__sub=function(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=(a.Z or 0)-(b.Z or 0)},V)end
V.__mul=function(a,b)if type(a)=='number'then a,b=b,a end;return setmetatable({X=a.X*b,Y=a.Y*b,Z=(a.Z or 0)*b},V)end
V.__div=function(a,b)return a*(1/b)end;V.__unm=function(a)return a*-1 end
function V:Dot(b)return self.X*b.X+self.Y*b.Y+(self.Z or 0)*(b.Z or 0)end
function V:Lerp(b,t)return self+(b-self)*t end
Vector2={new=function(x,y)return setmetatable({X=x,Y=y},V)end};Vector2.zero=Vector2.new(0,0)
Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end};Vector3.zero=Vector3.new(0,0,0);Vector3.one=Vector3.new(1,1,1)
local CF={};CF.__index=CF;CF.__mul=function(a,b)return a end
CFrame={new=function(x,y,z)if type(x)=='table'then return setmetatable({Position=x},CF)end;return setmetatable({Position=Vector3.new(x or 0,y or 0,z or 0)},CF)end};CFrame.identity=CFrame.new()
local function signal()
 local list={};return {Connect=function(_,fn)local c={live=true};function c:Disconnect()self.live=false end;list[#list+1]={c,fn};return c end,Fire=function(_,...)for _,c in ipairs(list)do if c[1].live then c[2](...)end end end,Count=function()local n=0;for _,c in ipairs(list)do if c[1].live then n+=1 end end;return n end}
end
local function actor(name,attributes)
 local a=attributes or{};local changes={};local m={Name=name,Parent=true,pivot=CFrame.new(0,25,-2.5),parts={}}
 function m:GetAttribute(k)return a[k]end
 function m:SetAttribute(k,v)local old=a[k];a[k]=v;if old~=v and changes[k]then changes[k]:Fire()end end
 function m:GetAttributeChangedSignal(k)changes[k]=changes[k]or signal();return changes[k]end
 function m:GetPivot()return self.pivot end
 function m:PivotTo(cf)self.pivot=cf;for _,p in pairs(self.parts)do p.Position=cf.Position+p.offset;p.CFrame=cf end end
 function m:FindFirstChild(name)return self.parts[name]end
 for _,name in ipairs({'Head','EyeLeft','EyeRight','UpperGums','LowerGums'})do
  local offset=name=='EyeLeft'and Vector3.new(-1.6,1.9,-3.2)or(name=='EyeRight'and Vector3.new(1.6,1.9,-3.2)or(name=='UpperGums'and Vector3.new(0,-.5,-3)or(name=='LowerGums'and Vector3.new(0,-1.5,-3)or Vector3.zero)))
  local changed=signal();local p={Parent=m,offset=offset,Size=Vector3.new(8,8,8),Position=m.pivot.Position+offset,CFrame=m.pivot}
  function p:IsA(c)return c=='BasePart'end;function p:FindFirstChild()return nil end;function p:GetPropertyChangedSignal()return changed end
  m.parts[name]=p
 end
 return m
end
local a=actor('Fighter1',{CraxId='Crax_Super',CraxSkillLevel=3,Health=100,MaxHealth=100,CollisionDamage=8})
local b=actor('Fighter2',{CraxId='Crax_Monster',Health=100,MaxHealth=100,CollisionDamage=8})
local fa={model=a,head=a.parts.Head,position=Vector2.new(0,25),velocity=Vector2.new(25,0),radius=4,depth=-2.5,rotation=CFrame.identity}
local fb={model=b,head=b.parts.Head,position=Vector2.new(10,26.9),velocity=Vector2.new(25,0),radius=4,depth=-2.5,rotation=CFrame.identity}
local fighters={fa,fb};local state=actor('CombatState',{Phase='Fighting',RoundId=1,CraxMatchToken='match-test'})
local events={};local hitLog={};local hitSignal=signal()
local hits={Event=hitSignal,Fire=function(_,aa,bb,amount,collision,kind,recoil)hitLog[#hitLog+1]={attacker=aa,target=bb,amount=amount,collision=collision,kind=kind};hitSignal:Fire(aa,bb,amount,collision,kind,recoil)end}
local fx={FireAllClients=function(_,kind,d)events[#events+1]={kind=kind,data=d}end}
local rs={CraxSuperRules='rules',CraxSuperConfig='config',CraxSuperFX=fx};local sss={CraxAbilityGate='gate',CraxPositionLock='locks',CraxDeadlyRuntime='deadly',CraxSkillResolver='resolver',BiteHit=hits}
function rs:FindFirstChild(n)return self[n]end;function rs:WaitForChild(n)return assert(self[n],n)end
sss.FindFirstChild=rs.FindFirstChild;sss.WaitForChild=rs.WaitForChild
workspace={GetServerTimeNow=function()return now end,WaitForChild=function(_,n)if n=='CombatState'then return state elseif n=='Fighter1'then return a elseif n=='Fighter2'then return b end;error(n)end,
 FindFirstChild=function(_,n)
 local data={Arenaleft={-24.5,25,1,40},ArenaRight={24.5,25,1,40},Arenabottom={0,4.5,50,1},ArenaTop={0,45.5,50,1}}
 local d=data[n];if d then return {Position=Vector3.new(d[1],d[2],-2.5),Size=Vector3.new(d[3],d[4],6),IsA=function()return true end}end
 end,Raycast=function()return nil end}
game={GetService=function(_,name)return name=='ReplicatedStorage'and rs or sss end}
local angleCalls=0
Random={new=function()return {NextNumber=function(_,lo,hi)if lo==0 and math.abs(hi-2*math.pi)<1e-7 then angleCalls+=1;return 0 end;return(lo+hi)/2 end,NextInteger=function(_,lo,hi)return lo end}end}
RaycastParams={new=function()return {}end};Enum={RaycastFilterType={Include=1}}
local gateLocks={};local Gate={}
function Gate.Pause(m,reason)gateLocks[m]=gateLocks[m]or{};gateLocks[m][reason]=true end
function Gate.Resume(m,reason)if gateLocks[m]then gateLocks[m][reason]=nil end end
function Gate.Paused(m)return gateLocks[m]and next(gateLocks[m])~=nil or false end
local modules={rules=R,config=C,gate=Gate,resolver={Resolve=function(m)return m:GetAttribute('CraxSkillLevel')or 0 end},deadly={MotionTargets=function()return fighters end,GetMotion=function(m)return m==a and fa or(m==b and fb or nil)end,SameTeam=function(x,y)return x==y end,Hold=function()return false end}}
require=function(id)return assert(modules[id],tostring(id))end
