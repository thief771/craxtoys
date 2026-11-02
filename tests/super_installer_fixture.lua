local objects={};local failure
local function new(class)
 local values={ClassName=class,Name=class,Source='',Value='',Transparency=0,LocalTransparencyModifier=0,Enabled=true};local attributes={};local object={}
 setmetatable(object,{__index=function(_,key)
  if key=='Parent'then return values.Parent end
  if key=='IsA'then return function(_,c)return c==class or(c=='BasePart'and(class=='Part'or class=='MeshPart'))or(c=='LuaSourceContainer'and(class=='Script'or class=='LocalScript'or class=='ModuleScript'))end end
  if key=='GetAttribute'then return function(_,k)return attributes[k]end end
  if key=='SetAttribute'then return function(_,k,v)attributes[k]=v end end
  if key=='GetChildren'then return function()local a={}for _,o in ipairs(objects)do if o.Parent==object then a[#a+1]=o end end;return a end end
  if key=='FindFirstChild'or key=='WaitForChild'then return function(_,name)for _,o in ipairs(objects)do if o.Parent==object and o.Name==name then return o end end end end
  if key=='GetPivot'then return function()return values.Pivot or CFrame.identity end end
  if key=='PivotTo'then return function(_,cf)values.Pivot=cf end end
  if key=='GetDescendants'then return function()local a={};local function walk(o)for _,c in ipairs(o:GetChildren())do a[#a+1]=c;walk(c)end end;walk(object);return a end end
  if key=='Destroy'then return function()
   for _,o in ipairs(object:GetChildren())do o:Destroy()end;values.Parent=nil
  end end
  if key=='Clone'then return function()
   local copy=new(class);for k,v in pairs(values)do if k~='Parent'then copy[k]=v end end;for k,v in pairs(attributes)do copy:SetAttribute(k,v)end
   for _,child in ipairs(object:GetChildren())do local c=child:Clone();c.Parent=copy end
   return copy
  end end
  if values[key]~=nil then return values[key]end
  return object:FindFirstChild(key)
 end,__newindex=function(_,k,v)
  if k=='Visible'or k=='Enabled'then assert(type(v)=='boolean','GUI boolean property cannot be nil: '..k)end
  if k=='Source'and object==failure and v~=values.Source then failure=nil;error('INJECTED_SOURCE_WRITE_FAILURE')end
  values[k]=v
 end})
 objects[#objects+1]=object;return object
end
Instance={new=new};game=new('DataModel')
function game:GetService(name)return assert(self:FindFirstChild(name),name)end
local function create(path,class)
 local parent=game;local tokens={};for t in path:gmatch('[^.]+')do tokens[#tokens+1]=t end
 for i,t in ipairs(tokens)do local o=parent:FindFirstChild(t);if not o then o=new(i==#tokens and class or'Folder');o.Name=t;o.Parent=parent end;parent=o end
 return parent
end
local run=create('RunService','RunService');function run:IsRunning()return false end
create('ServerStorage','ServerStorage');create('ReplicatedStorage','ReplicatedStorage');create('StarterPlayer.StarterPlayerScripts','StarterPlayerScripts')
create('ServerStorage.CraxTemplates.Crax_Monster','Model');create('ReplicatedStorage.CraxPreviews','Folder')
create('Workspace.Arenaleft','Part');create('Workspace.ArenaRight','Part')
require=function(module)assert(module.Name=='CraxSuperAppearance');return {Apply=function()end}end
local checks=0
local function check(v,m)checks+=1;assert(v,m)end

local V={};V.__index=function(t,k)if k=='Magnitude'then return math.sqrt(t.X^2+t.Y^2+t.Z^2)elseif k=='Unit'then return setmetatable({X=t.X/t.Magnitude,Y=t.Y/t.Magnitude,Z=t.Z/t.Magnitude},V)end;return V[k]end
V.__sub=function(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=a.Z-b.Z},V)end
function V:Dot(b)return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
local function vec(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end
local imported=create('Workspace.ImportedSuper','Model')
for _,name in ipairs({'FIT_Front','FIT_HeadCenter','FIT_Up','SuperChinBlue','SuperCurl','SuperCurl_Ridge','SuperEmblem_RedShield','SuperEmblem_S','SuperEmblem_YellowField','SuperHairCap','SuperHairLock_00','SuperHairLock_01','SuperHairLock_02','SuperHairLock_03','SuperHairLock_04','SuperHairLock_05','SuperTemple_-1','SuperTemple_1'})do
 local o=new('MeshPart');o.Name=name;o.MeshId='rbxassetid://123';o.Position=name=='FIT_Front'and vec(0,0,-4)or(name=='FIT_Up'and vec(0,4,0)or vec(0,0,0));o.Parent=imported
end
local selection=create('Selection','Selection');function selection:Get()return {imported}end
