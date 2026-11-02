-- Extend service stand-ins for the actual Super presentation callbacks.
V.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,(a.Z or 0)-(b.Z or 0))end
V.__div=function(a,n)return a*(1/n)end
V.__index=function(t,k)if k=='Magnitude'then return math.sqrt(t.X^2+t.Y^2+(t.Z or 0)^2)elseif k=='Unit'then return t*(1/math.max(t.Magnitude,.00001))end;return V[k]end
function V:Cross(b)return Vector3.new(self.Y*b.Z-self.Z*b.Y,self.Z*b.X-self.X*b.Z,self.X*b.Y-self.Y*b.X)end
function V:Lerp(b,t)return self+(b-self)*t end
CF.__mul=function(a,b)return a end
function CF:VectorToWorldSpace(v)return v end
CFrame.lookAt=function()return CFrame.new()end
Color3.fromRGB=function()return{Lerp=function(self)return self end}end
ColorSequence={new=function(c)return c end};NumberSequence={new=function(n)return n end}
Enum.Material.Metal=2;Enum.Material.Glass=3;Enum.Material.Ice=4;Enum.PartType={Ball=1}
task.spawn=function(f)f()end;create('ContentProvider','ContentProvider')
fx.Name='CraxSuperFX';configObject.Name='CraxSuperConfig'
state:SetAttribute('CraxMatchToken','client-match');a:SetAttribute('CraxId','Crax_Super');a:SetAttribute('CraxSkillLevel',3)
for _,m in ipairs({a,b})do
 for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then p.Color=Color3.fromRGB();p.Material=1;p.Reflectance=0 end end
 function m:GetPivot()return self.Head.CFrame end
 function m:PivotTo(cf)self.Head.CFrame=cf end
end

function CF:PointToWorldSpace(v)return self.Position+v end
function CF:Lerp()return self end
CF.Rotation=CFrame.identity;CF.LookVector=Vector3.new(0,0,-1);CF.UpVector=Vector3.new(0,1,0)
Enum.Material.Neon=5
local render
function game.RunService:BindToRenderStep(_,_,fn)render=fn end
function game.RunService:UnbindFromRenderStep()render=nil end
local cam=new('Camera');cam.CameraType='Custom';cam.CameraSubject=a;cam.FieldOfView=70;cam.CFrame=CFrame.new();cam.Focus=CFrame.new();cam.ViewportSize=Vector2.new(390,844);cam.Parent=workspace;workspace.CurrentCamera=cam
for _,m in ipairs({a,b})do for _,name in ipairs({'EyeLeft','EyeRight'})do local p=new('Part');p.Name=name;p.Position=Vector3.new(0,25,-2.5);p.Size=Vector3.new(1,1,1);p.CFrame=CFrame.new();p.Color=Color3.fromRGB();p.Parent=m end end
