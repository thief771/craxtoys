-- Tiny service/motion fixture: executes the real runtime, not a reimplementation.
local V={}
V.__index=function(t,k)
 if k=='Magnitude'then return math.sqrt(t.X*t.X+t.Y*t.Y+(t.Z or 0)^2)end
 if k=='Unit'then local m=t.Magnitude;return setmetatable({X=t.X/m,Y=t.Y/m,Z=(t.Z or 0)/m},V)end
 return V[k]
end
V.__add=function(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=(a.Z or 0)+(b.Z or 0)},V)end
V.__sub=function(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=(a.Z or 0)-(b.Z or 0)},V)end
V.__mul=function(a,b)return setmetatable({X=a.X*b,Y=a.Y*b,Z=(a.Z or 0)*b},V)end
function V:Dot(b)return self.X*b.X+self.Y*b.Y+(self.Z or 0)*(b.Z or 0)end
Vector2={new=function(x,y)return setmetatable({X=x,Y=y},V)end}
Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end}
CFrame={new=function(...)return setmetatable({args={...}},{__mul=function(a,b)return a end})end}
local now=0
local function model(name,attributes)
 local a=attributes or {};local m={Name=name,Parent=true}
 function m:GetAttribute(k)return a[k]end
 function m:SetAttribute(k,v)a[k]=v end
 function m:PivotTo(cf)self.pivot=cf end
 return m
end
local a=model('Fighter1',{CraxId='Crax_Inverted',CraxSkillLevel=3,Health=120})
local b=model('Fighter2',{CraxId='Crax_Monster',Health=100})
local fa={model=a,position=Vector2.new(0,25),velocity=Vector2.new(20,0),radius=4,depth=-2.5,rotation={}}
local fb={model=b,position=Vector2.new(10,25),velocity=Vector2.new(20,0),radius=4,depth=-2.5,rotation={}}
local fighters={fa,fb};local state=model('CombatState',{Phase='Fighting',RoundId=1})
local log={};local rs={CraxInvertedRules='rules',CraxSilenceGate='silence',CraxInvertedFX={FireAllClients=function(_,kind,d)table.insert(log,{kind=kind,data=d})end}}
local sss={CraxAbilityGate='gate',CraxDeadlyRuntime='deadly',CraxSkillResolver='resolver'}
function rs:WaitForChild(n)return assert(self[n],n)end;sss.WaitForChild=rs.WaitForChild
workspace={WaitForChild=function(_,name)assert(name=='CombatState');return state end,GetServerTimeNow=function()return now end,
 FindFirstChild=function(_,name)
 if name=='Arenaleft'then return {IsA=function()return true end,Position=Vector3.new(-24.5,25,-2.5),Size=Vector3.new(1,40,6)}end
 if name=='ArenaRight'then return {IsA=function()return true end,Position=Vector3.new(24.5,25,-2.5),Size=Vector3.new(1,40,6)}end
 end}
game={GetService=function(_,name)return name=='ReplicatedStorage'and rs or sss end}
Random={new=function()return {NextNumber=function(_,lo,hi)return(lo+hi)/2 end,NextInteger=function(_,lo,hi)return lo end}end}
local modules={rules=Rules,silence=Silence,gate={Paused=function(m)return m:GetAttribute('AbilityPaused')end},
 deadly={MotionTargets=function()return fighters end,SameTeam=function(x,y)return x==y end,Hold=function()return false end},resolver={Resolve=function()end}}
require=function(id)return assert(modules[id],id)end
