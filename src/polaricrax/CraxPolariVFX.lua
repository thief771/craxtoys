-- Bounded procedural effects: no new uploaded texture or mesh required.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local low=game:GetService('UserInputService').TouchEnabled
local M={};local PURPLE=Color3.fromRGB(170,63,255);local CYAN=Color3.fromRGB(140,242,255);local GOLD=Color3.fromRGB(255,211,96)
local function make(class,properties,parent)local o=Instance.new(class);for k,v in pairs(properties)do o[k]=v end;o.Parent=parent;return o end
local function part(parent,name,color,size,cf,alpha)
 return make('Part',{Name=name,Size=size,CFrame=cf,Color=color,Material=Enum.Material.Neon,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},parent)
end
local function ring(parent,radius,color,z)
 local n=low and 8 or 12
 for i=1,n do local angle=i*2*math.pi/n;part(parent,'MagneticArc',color,Vector3.new(.07,2*radius*math.sin(math.pi/n)*1.04,.07),CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,z or 0)*CFrame.Angles(0,0,angle),.12)end
end
function M.Projectile(parent,fan)
 local model=make('Model',{Name='PolariShard'},parent)
 local core=part(model,'PolariProjectileCore',fan and GOLD or CYAN,Vector3.one*(fan and .55 or .85),CFrame.identity,0);core.Shape=Enum.PartType.Ball
 local halo=part(model,'PolariProjectileHalo',PURPLE,Vector3.one*(fan and .95 or 1.4),CFrame.identity,.72);halo.Shape=Enum.PartType.Ball
 ring(model,fan and .6 or .9,PURPLE,0);if not low then ring(model,.62,CYAN,.3)end
 for i=1,3 do local angle=i*2*math.pi/3;part(model,'IonFin',CYAN,Vector3.new(.10,.12,fan and 1.1 or 1.8),CFrame.new(math.cos(angle)*.3,math.sin(angle)*.3,.6),.15)end
 local a=make('Attachment',{Position=Vector3.new(-.3,0,0)},core);local b=make('Attachment',{Position=Vector3.new(.3,0,0)},core)
 make('Trail',{Name='PolariIonTrail',Attachment0=a,Attachment1=b,Color=ColorSequence.new(CYAN,PURPLE),Transparency=NumberSequence.new(.15,1),Lifetime=low and .16 or .3,LightEmission=1,FaceCamera=true,MinLength=.02},core)
 make('ParticleEmitter',{Name='PolariIonSparks',Texture='rbxasset://textures/particles/sparkles_main.dds',Color=ColorSequence.new(CYAN,PURPLE),LightEmission=1,Rate=low and 8 or 22,Lifetime=NumberRange.new(.12,.25),Speed=NumberRange.new(.2,1),Size=NumberSequence.new(.1),SpreadAngle=Vector2.new(20,20)},core)
 if not low then make('PointLight',{Color=PURPLE,Brightness=1.7,Range=7,Shadows=false},core)end
 model.PrimaryPart=core;return model
end
function M.Attraction(parent,target)
 local halo=make('Model',{Name='PolariAttractionHalo'},parent);ring(halo,4.5,CYAN,0)
 make('Highlight',{Name='PolarizedVictim',Adornee=target,FillColor=PURPLE,FillTransparency=.82,OutlineColor=CYAN,OutlineTransparency=.15},parent)
 return halo
end
function M.Preview(parent,target)
 local head=target and target:FindFirstChild('Head',true)
 if head and head:IsA('BasePart')then
  local gui=make('BillboardGui',{Name='PolariStopWarning',Adornee=head,Size=UDim2.fromOffset(270,65),StudsOffsetWorldSpace=Vector3.new(0,6,0),AlwaysOnTop=true},parent)
  make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='TEMPS SUSPENDU',TextScaled=true,TextColor3=GOLD,TextStrokeTransparency=.15,Font=Enum.Font.FredokaOne},gui)
 end
 if target then make('Highlight',{Name='PolariTimeTarget',Adornee=target,FillColor=PURPLE,FillTransparency=.78,OutlineColor=GOLD,OutlineTransparency=0},parent)end
end
function M.Freeze(targets)
 local snapshots={};local registryObject=RS:FindFirstChild('CraxRenderRegistryV82');local registry=registryObject and require(registryObject)
 for _,model in ipairs(targets)do
  if model and model.Parent then
   if registry then for _,entry in ipairs(registry.Sources(model))do snapshots[entry.Part]=entry.Part.CFrame end
   else for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then snapshots[p]=p.CFrame end end end
  end
 end
 Run:BindToRenderStep('PolariTimeFreeze',Enum.RenderPriority.Last.Value+1600,function()
  for p,cf in pairs(snapshots)do if p.Parent then p.CFrame=cf end end
 end)
 local released=false
 return{Destroy=function()if released then return end;released=true;Run:UnbindFromRenderStep('PolariTimeFreeze');snapshots={}end}
end
return M
