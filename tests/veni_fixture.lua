-- Banc de test VeniCrax : services Roblox simulés, vrai CraxVeniRuntime + CraxVeniRules + CraxVeniConfig.
local V={}
V.__index=function(t,k)
 if k=='Magnitude'then return math.sqrt(t.X*t.X+t.Y*t.Y+(t.Z or 0)^2)end
 if k=='Unit'then local m=t.Magnitude;if m==0 then return t end;return setmetatable({X=t.X/m,Y=t.Y/m,Z=(t.Z or 0)/m},V)end
 return V[k]
end
V.__add=function(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=(a.Z or 0)+(b.Z or 0)},V)end
V.__sub=function(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=(a.Z or 0)-(b.Z or 0)},V)end
V.__mul=function(a,b)if type(a)=='number'then a,b=b,a end;return setmetatable({X=a.X*b,Y=a.Y*b,Z=(a.Z or 0)*b},V)end
V.__unm=function(a)return a*-1 end
function V:Dot(b)return self.X*b.X+self.Y*b.Y+(self.Z or 0)*(b.Z or 0)end
Vector2={new=function(x,y)return setmetatable({X=x,Y=y},V)end};Vector2.zero=Vector2.new(0,0)
Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end}
local seq=0;function Random_next()seq+=1;return seq end
Random={new=function()return{NextNumber=function(_,a,b)return a end,NextInteger=function(_,a,b)return a end}end}
local now=0
local function model(name,attrs)
 local a=attrs or{};local m={Name=name,Parent=true}
 function m:GetAttribute(k)return a[k]end;function m:SetAttribute(k,v)a[k]=v end
 return m
end
state=model('CombatState',{Phase='Fighting',RoundId=1,CraxMatchToken='T1'})
local function wall(name,x,y,sx,sy)return{Name=name,Position=Vector3.new(x,y,0),Size=Vector3.new(sx,sy,1)}end
local walls={Arenaleft=wall('Arenaleft',-21,0,2,40),ArenaRight=wall('ArenaRight',21,0,2,40),Arenabottom=wall('Arenabottom',0,-13,40,2),ArenaTop=wall('ArenaTop',0,13,40,2)}
fired={};heals={};events={}
local hit={Fire=function(_,a,b,amount,collision,kind,_,id)fired[#fired+1]={a=a,b=b,amount=amount,kind=kind,id=id}end}
local heal={Fire=function(_,m,amount,source)heals[#heals+1]={m=m,amount=amount,source=source}end}
local fx={FireAllClients=function(_,k,d)events[#events+1]={k=k,d=d}end}
local modules={}
modules.gate={Paused=function()return false end}
modules.deadly={MotionTargets=function(f)return f end,SameTeam=function()return false end,Hold=function()return false end}
modules.skills={Resolve=function(m)return m:GetAttribute('CraxSkillLevel')or 0 end}
modules.silence={CanStart=function(m)return not m:GetAttribute('InvertedSilenced')end}
local rsChildren={CraxVeniConfig='config',CraxVeniRules='rules',CraxSilenceGate='silence',CraxVeniFX=fx}
local sssChildren={CraxAbilityGate='gate',CraxDeadlyRuntime='deadly',CraxSkillResolver='skills',BiteHit=hit,CraxHeal=heal}
local function container(children)return{WaitForChild=function(_,n)return assert(children[n],n)end,FindFirstChild=function(_,n)return children[n]end}end
local rs,sss=container(rsChildren),container(sssChildren)
game={GetService=function(_,n)if n=='ReplicatedStorage'then return rs end;return sss end}
workspace={WaitForChild=function(_,n)return state end,FindFirstChild=function(_,n)return walls[n]end,GetServerTimeNow=function()return now end}
function require(x)return modules[x]end
modules.config=CONFIG_SOURCE();modules.rules=RULES_SOURCE()
VENI=RUNTIME_SOURCE()
veni=model('Fighter1',{CraxId='Crax_Veni',Health=100,CraxSkillLevel=0})
foe=model('Fighter2',{CraxId='Crax_Monster',Health=100})
fighters={{model=veni,position=Vector2.new(-8,0),velocity=Vector2.new(0,0),radius=2,depth=0},{model=foe,position=Vector2.new(8,0),velocity=Vector2.new(0,0),radius=2,depth=0}}
function advance(seconds,step)step=step or 1/60;local t=0;while t<seconds-1e-9 do now+=step;t+=step;VENI.Step(step,fighters,true)end end
function setNow(t)now=t end
function clock()return now end
function count(kind)local n,total=0,0;for _,f in ipairs(fired)do if f.kind==kind then n+=1;total+=f.amount end end;return n,total end
function hasEvent(k)for _,e in ipairs(events)do if e.k==k then return e end end end
function reset()fired={};heals={};events={}end
