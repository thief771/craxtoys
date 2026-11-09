-- Layered magnetic plasma. Built-in particle textures; all geometry is client-only and bounded.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local Config=require(RS:WaitForChild('CraxPolariConfig'))
local low=Config.Quality=='Low'or Config.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local M={};local PURPLE=Color3.fromRGB(170,63,255);local CYAN=Color3.fromRGB(140,242,255);local GOLD=Color3.fromRGB(255,211,96)
local function make(class,properties,parent)local o=Instance.new(class);for k,v in pairs(properties)do o[k]=v end;o.Parent=parent;return o end
local function part(parent,name,color,size,cf,alpha)
 return make('Part',{Name=name,Size=size,CFrame=cf,Color=color,Material=Enum.Material.Neon,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},parent)
end
local function ring(parent,radius,color,z)
 local n=low and 8 or 12
 for i=1,n do local angle=i*2*math.pi/n;part(parent,'MagneticArc',color,Vector3.new(.07,2*radius*math.sin(math.pi/n)*1.04,.07),CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,z or 0)*CFrame.Angles(0,0,angle),.12)end
end
-- Shared profiles keep transparency/size authored over each particle's lifetime.
local function curve(a,b,c)
 return NumberSequence.new({NumberSequenceKeypoint.new(0,a),NumberSequenceKeypoint.new(.18,b),NumberSequenceKeypoint.new(1,c)})
end
local function particles(parent,name,color,texture,rate,size,speed)
 return make('ParticleEmitter',{Name=name,Texture=texture,Color=ColorSequence.new(color,PURPLE),
  LightEmission=.85,LightInfluence=0,Rate=low and rate*.35 or rate,Lifetime=NumberRange.new(.18,.48),
  Speed=NumberRange.new(speed*.4,speed),Drag=3,Size=curve(size*.3,size,0),Transparency=curve(1,.28,1),
  Rotation=NumberRange.new(0,360),RotSpeed=NumberRange.new(-90,90),SpreadAngle=Vector2.new(180,180)},parent)
end
local SPARK=Config.Textures.Spark~=''and Config.Textures.Spark or 'rbxasset://textures/particles/sparkles_main.dds'
local SMOKE=Config.Textures.Smoke~=''and Config.Textures.Smoke or 'rbxasset://textures/particles/smoke_main.dds'
local FLARE=Config.Textures.Flare~=''and Config.Textures.Flare or 'rbxasset://textures/particles/flare_main.dds'
-- An animated armillary field: separate rotating rings, index marks and drifting plasma.
function M.Field(parent,kind)
 local model=make('Model',{Name='Polari'..kind..'Field'},parent)
 local anchor=part(model,'FieldAnchor',CYAN,Vector3.one*.05,CFrame.identity,1)
 local r={model=model,rings={},kind=kind,bolts={},emitters={}}
 for i=1,(low and 2 or 3)do
  local m=make('Model',{Name='FluxOrbit'..i},model);ring(m,2.3+i*.55,i==2 and GOLD or CYAN,0)
  for j=1,(low and 4 or 8)do local a=j*math.pi/(low and 2 or 4);part(m,'PolarityIndex',i==2 and GOLD or PURPLE,Vector3.new(.1,.38,.12),CFrame.new(math.cos(a)*(2.65+i*.55),math.sin(a)*(2.65+i*.55),0)*CFrame.Angles(0,0,a),.2)end
  r.rings[i]=m
 end
 r.emitters[1]=particles(anchor,'FluxDust',kind=='Time'and GOLD or CYAN,SPARK,low and 5 or 14,.24,2)
 if not low then r.emitters[2]=particles(anchor,'MagneticNebula',PURPLE,SMOKE,6,2.8,.5)end
 for i=1,(low and 1 or 3)do
  local a=make('Attachment',{},anchor);local b=make('Attachment',{},anchor)
  local beam=make('Beam',{Name='MagneticFilament',Attachment0=a,Attachment1=b,Texture=SPARK,TextureSpeed=3,TextureLength=.5,Color=ColorSequence.new(CYAN,PURPLE),Width0=.065,Width1=.025,LightEmission=1,FaceCamera=true,Segments=8,Transparency=NumberSequence.new(.2)},anchor)
  r.bolts[i]={a=a,b=b,beam=beam}
 end
 return r
end
function M.AnimateField(r,cf,t,strength,paused)
 strength=strength or 1
 for _,e in ipairs(r.emitters)do e.Enabled=not paused;e.TimeScale=paused and 0 or 1 end
 for i,b in ipairs(r.bolts)do local a=t*(i%2==0 and -2 or 2)+i*2.1
  b.a.Position=Vector3.new(math.cos(a)*2.8,math.sin(a)*2.8,.3)*(r.scale or 1)
  b.b.Position=Vector3.new(math.cos(a+.9)*3.4,math.sin(a+.9)*3.4,-.3)*(r.scale or 1)
  b.beam.CurveSize0=.6*math.sin(t*13+i);b.beam.CurveSize1=-b.beam.CurveSize0;b.beam.TextureSpeed=paused and 0 or 3
 end
 r.model:PivotTo(cf)
 for i,m in ipairs(r.rings)do local direction=i%2==0 and -1 or 1
  m:PivotTo(cf*CFrame.Angles(i==2 and .65 or 0,i==3 and .55 or 0,t*direction*(.7+i*.3)*strength))
 end
end
-- Textured energy skin aligned with each real arena wall, never changes collision geometry.
function M.Wall(panel,side)
 local horizontal=side=='Top'or side=='Bottom'
 local span=horizontal and panel.Size.X or panel.Size.Y
 local length=math.min(70,span);local r={panel=panel,beams={},emitters={}}
 local function point(x,y)return make('Attachment',{Position=Vector3.new(horizontal and y or x,horizontal and x or y,-panel.Size.Z*.5-.06)},panel)end
 for i=1,(low and 2 or 4)do
  local offset=(i-((low and 2 or 4)+1)*.5)*.24
  local a=point(offset,-length*.5);local b=point(offset,length*.5)
  r.beams[i]=make('Beam',{Name='PolariWallFlux',Attachment0=a,Attachment1=b,Color=ColorSequence.new(CYAN,PURPLE),
   Texture=SPARK,TextureLength=2.2,TextureSpeed=1+i*.4,Width0=.16,Width1=.16,FaceCamera=true,
   LightEmission=1,LightInfluence=0,Segments=low and 6 or 12,Transparency=NumberSequence.new(.25),CurveSize0=.5,CurveSize1=-.5},panel)
 end
 local center=point(0,0)
 r.emitters[1]=particles(center,'WallCorona',CYAN,FLARE,low and 4 or 12,.8,2)
 if not low then r.emitters[2]=particles(center,'WallVapor',PURPLE,SMOKE,7,3,1)end
 return r
end
function M.AnimateWall(r,t,armed,warning,paused)
 local color=(armed or warning)and Color3.fromRGB(255,65,95)or CYAN
 for i,b in ipairs(r.beams)do
  b.Color=ColorSequence.new(color,PURPLE);b.TextureSpeed=paused and 0 or(armed and 4 or 1.4)*(i%2==0 and -1 or 1)
  b.Width0=(armed and .28 or .14)+.04*math.sin(t*9+i);b.Width1=b.Width0
  b.CurveSize0=math.sin(t*4+i)*.8;b.CurveSize1=-b.CurveSize0
 end
 for _,e in ipairs(r.emitters)do e.Enabled=not paused;e.TimeScale=paused and 0 or 1;e.Color=ColorSequence.new(color,PURPLE)end
end
-- Impacts expand and fade in the existing client loop; no delayed task or extra connection.
function M.Impact(parent,cf,color,scale)
 scale=scale or 1
 local model=make('Model',{Name='PolariShockwave'},parent);local core=part(model,'ImpactBloom',color,Vector3.one*.35,cf,.15);core.Shape=Enum.PartType.Ball
 local r={model=model,core=core,rings={},cf=cf,scale=scale}
 for i=1,(low and 1 or 2)do local m=make('Model',{Name='ShockFront'..i},model);ring(m,.8+i*.35,color,0);m:PivotTo(cf);r.rings[i]=m end
 local e=particles(core,'ImpactPlasma',color,FLARE,0,1.4*scale,7);e:Emit(low and 5 or 12)
 local dust=particles(core,'ImpactSplinters',color,SPARK,0,.22,12);dust:Emit(low and 6 or 22)
 if not low then local smoke=particles(core,'DissipatingFlux',PURPLE,SMOKE,0,3*scale,2);smoke:Emit(4)end
 return r
end
function M.AnimateImpact(r,t)
 local u=math.clamp(t/.65,0,1)
 r.core.Size=Vector3.one*(.35+3*r.scale*u);r.core.Transparency=.15+.85*u
 for i,m in ipairs(r.rings)do
  m:ScaleTo(1+r.scale*u*(4+i*2));m:PivotTo(r.cf*CFrame.Angles(i==2 and .5 or 0,0,u*i))
  for _,p in ipairs(m:GetChildren())do p.Transparency=.15+.85*u end
 end
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
 particles(core,'PlasmaCorona',CYAN,FLARE,low and 8 or 18,fan and .9 or 1.4,.5)
 if not low then particles(core,'IonVapor',PURPLE,SMOKE,10,1.6,.8)end
 local tailA=make('Attachment',{Position=Vector3.new(0,-.45,.4)},core);local tailB=make('Attachment',{Position=Vector3.new(0,.45,.4)},core)
 make('Trail',{Name='PolariPlasmaRibbon',Attachment0=tailA,Attachment1=tailB,Texture=SPARK,TextureLength=1.2,Color=ColorSequence.new(PURPLE,CYAN),Transparency=curve(.55,.7,1),WidthScale=curve(1,.75,0),Lifetime=low and .16 or .35,LightEmission=1,FaceCamera=true,MinLength=.03},core)
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
