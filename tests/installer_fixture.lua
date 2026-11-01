local objects={};local failure
local function new(class)
 local values={ClassName=class,Name=class,Source='',Value=''};local attributes={};local object={}
 setmetatable(object,{__index=function(_,key)
  if key=='Parent'then return values.Parent end
  if key=='IsA'then return function(_,c)return c==class or(c=='BasePart'and(class=='Part'or class=='MeshPart'))or(c=='LuaSourceContainer'and(class=='Script'or class=='LocalScript'or class=='ModuleScript'))end end
  if key=='GetAttribute'then return function(_,k)return attributes[k]end end
  if key=='SetAttribute'then return function(_,k,v)attributes[k]=v end end
  if key=='GetChildren'then return function()local a={}for _,o in ipairs(objects)do if o.Parent==object then a[#a+1]=o end end;return a end end
  if key=='FindFirstChild'or key=='WaitForChild'then return function(_,name)for _,o in ipairs(objects)do if o.Parent==object and o.Name==name then return o end end end end
  if key=='Destroy'then return function()
   for _,o in ipairs(object:GetChildren())do o:Destroy()end;values.Parent=nil
  end end
  if key=='Clone'then return function()
   local copy=new(class);copy.Name=object.Name
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
require=function(module)assert(module.Name=='CraxInvertedPalette');return {Apply=function()end}end
local checks=0
local function check(v,m)checks+=1;assert(v,m)end
