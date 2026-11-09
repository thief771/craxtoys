-- Numerical CFrame stand-in: catches degenerate lookAts and tests real cinematic distances.
local identity={1,0,0,0,1,0,0,0,1}
local function cf(p,r)return setmetatable({Position=p,_r=r or identity},CF)end
local function rotate(r,v)return Vector3.new(r[1]*v.X+r[2]*v.Y+r[3]*v.Z,r[4]*v.X+r[5]*v.Y+r[6]*v.Z,r[7]*v.X+r[8]*v.Y+r[9]*v.Z)end
local function transpose(r)return{r[1],r[4],r[7],r[2],r[5],r[8],r[3],r[6],r[9]}end
CF.__index=function(self,key)
 local r=rawget(self,'_r')or identity
 if key=='Rotation'then return cf(Vector3.zero,r)elseif key=='UpVector'then return Vector3.new(r[2],r[5],r[8])elseif key=='LookVector'then return Vector3.new(-r[3],-r[6],-r[9])end
 return CF[key]
end
CF.__mul=function(a,b)
 local ar=a._r or identity;local br=b._r or identity;local r={}
 for i=0,2 do for j=1,3 do r[i*3+j]=ar[i*3+1]*br[j]+ar[i*3+2]*br[j+3]+ar[i*3+3]*br[j+6]end end
 return cf(a.Position+rotate(ar,b.Position),r)
end
CFrame.new=function(x,y,z)if type(x)=='table'then return cf(x)end;return cf(Vector3.new(x or 0,y or 0,z or 0))end
CFrame.identity=CFrame.new()
CFrame.Angles=function(x,y,z)
 local cx,sx,cy,sy,cz,sz=math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
 return cf(Vector3.zero,{cy*cz,-cy*sz,sy,cx*sz+sx*sy*cz,cx*cz-sx*sy*sz,-sx*cy,sx*sz-cx*sy*cz,sx*cz+cx*sy*sz,cx*cy})
end
function CF:VectorToWorldSpace(v)return rotate(self._r or identity,v)end
function CF:PointToWorldSpace(v)return self.Position+self:VectorToWorldSpace(v)end
function CF:Inverse()local r=transpose(self._r or identity);return cf(rotate(r,self.Position)*-1,r)end
function CF:ToObjectSpace(other)return self:Inverse()*other end
function CF:Lerp(other,t)
 local a,b=self._r or identity,other._r or identity;local r={}
 for i=1,9 do r[i]=a[i]+(b[i]-a[i])*t end
 return cf(self.Position:Lerp(other.Position,t),r)
end
CFrame.lookAt=function(from,to,up)
 local back=from-to;assert(back.Magnitude>1e-6,'degenerate cinematic lookAt');back=back.Unit
 local right=(up or Vector3.new(0,1,0)):Cross(back);assert(right.Magnitude>1e-6,'parallel lookAt up');right=right.Unit
 local above=back:Cross(right)
 return cf(from,{right.X,above.X,back.X,right.Y,above.Y,back.Y,right.Z,above.Z,back.Z})
end
for _,m in ipairs({a,b})do m.Head.CFrame=CFrame.new(m.Head.Position)end
cam.CFrame=CFrame.new(0,25,-40);cam.Focus=CFrame.new(0,25,0)
local numericalFrames=true
