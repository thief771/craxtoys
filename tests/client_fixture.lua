local now=0
local function sig()
 local list={};return {Connect=function(_,f)local c={live=true};function c:Disconnect()self.live=false end;list[#list+1]={c,f};return c end,Fire=function(_,...)for _,e in ipairs(list)do if e[1].live then e[2](...)end end end,Count=function()local n=0;for _,e in ipairs(list)do if e[1].live then n+=1 end end;return n end}
end
local V={};V.__index=V;V.__mul=function(v,n)return setmetatable({X=v.X*n,Y=v.Y*n,Z=(v.Z or 0)*n},V)end;V.__add=function(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=(a.Z or 0)+(b.Z or 0)},V)end
Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end};Vector3.one=Vector3.new(1,1,1)
Vector2={new=function(x,y)return setmetatable({X=x,Y=y},V)end}
local CF={};CF.__index=CF;CF.__mul=function(a,b)return a end
CFrame={new=function()return setmetatable({Position=Vector3.new(0,0,0)},CF)end,Angles=function()return setmetatable({},CF)end};CFrame.identity=CFrame.new()
Color3={fromRGB=function()return {}end}
UDim2={fromOffset=function()return {}end,fromScale=function()return {}end}
Enum={Material={SmoothPlastic=1},Font={GothamBold=1,GothamBlack=2,FredokaOne=3},RenderPriority={Last={Value=200}},CameraType={Scriptable=1}}
Random={new=function()return {NextNumber=function(_,a,b)return(a+b)/2 end}end}
task={defer=function(fn)fn()end}
local player=create('Players.LocalPlayer','Player');create('Players.LocalPlayer.PlayerGui','PlayerGui')
player:SetAttribute('ArenaSeat',1);local seatSignal=sig();function player:GetAttributeChangedSignal()return seatSignal end
local input=create('UserInputService','UserInputService');input.TouchEnabled=true
create('SoundService','SoundService')
workspace=create('Workspace','Workspace');workspace.CurrentCamera={};function workspace:GetServerTimeNow()return now end
local state=create('Workspace.CombatState','Folder');state:SetAttribute('Phase','Fighting');state:SetAttribute('RoundId',1)
local stateSignals={};function state:GetAttributeChangedSignal(k)stateSignals[k]=stateSignals[k]or sig();return stateSignals[k]end
local heartbeat=sig();game.RunService.Heartbeat=heartbeat
local rs=game.ReplicatedStorage;local fx=create('ReplicatedStorage.CraxInvertedFX','RemoteEvent');fx.OnClientEvent=sig()
local configObject=create('ReplicatedStorage.CraxInvertedConfig','ModuleScript');local clockObject=create('ReplicatedStorage.CraxAbilityClock','ModuleScript')
local a=create('Workspace.Fighter1','Model');local b=create('Workspace.Fighter2','Model')
for _,m in ipairs({a,b})do
 local h=new('Part');h.Name='Head';h.Position=Vector3.new(0,25,-2.5);h.Size=Vector3.new(8,8,8);h.CFrame=CFrame.new();h.Parent=m
 m:SetAttribute('Health',100)
end
a:SetAttribute('InvertedCopyCount',0)
script=new('LocalScript');script.Destroying=sig()
