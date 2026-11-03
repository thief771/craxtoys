-- SymbiotiCraxIntegrationV1
local data=(function()
-- 7 Deadly'Crax : construction commune des têtes, cols et aperçus.
local V={}
V.Colors={OG=Color3.fromRGB(255,132,34),Domino=Color3.fromRGB(235,235,245),Parker=Color3.fromRGB(240,35,45),Dodger=Color3.fromRGB(38,97,156),Vice=Color3.fromRGB(255,0,170),Stack=Color3.fromRGB(117,73,45),Void=Color3.fromRGB(6,6,8)}
V.Emerald=Color3.fromRGB(22,238,151)
local headCache=setmetatable({},{__mode='k'})
function V.Head(model)
 local cached=headCache[model];if cached and cached.Parent then return cached end
 local h=model:FindFirstChild('Head',true)
 if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 headCache[model]=h;return h
end
function V.Clean(model)
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('BillboardGui')or o:IsA('Sound')or o:IsA('Highlight')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false end
 end
 return model
end
-- Imported mesh parts can sit inside matching *_Node models.
local function ancestryName(part,model)
 local p=part
 while p and p~=model do
  local name=p.Name:gsub('_Node$','')
  if name:match('^Tooth_%d+_%d+$')or name=='Gums'or name=='Head'or name:find('Shell')or name:find('Eye')then return name end
  p=p.Parent
 end
 return part.Name
end
local function solidColor(part,color,material,reflectance)
 -- The imported albedo otherwise tints the gold and keeps gums pink.
 if part:IsA('MeshPart')then part.TextureID=''end
 for _,child in ipairs(part:GetDescendants())do
  if child:IsA('SurfaceAppearance')or child:IsA('Decal')or child:IsA('Texture')then child:Destroy()
  elseif child:IsA('SpecialMesh')then child.TextureId='';child.VertexColor=Vector3.one end
 end
 part.Color=color;part.Material=material or Enum.Material.SmoothPlastic;part.Reflectance=reflectance or 0
end
local function sparkle(part)
 local old=part:FindFirstChild('DeadlyGoldSparkle');if old then old:Destroy()end
 local e=Instance.new('ParticleEmitter');e.Name='DeadlyGoldSparkle'
 e.Texture='rbxasset://textures/particles/sparkles_main.dds';e.Color=ColorSequence.new(Color3.fromRGB(255,226,118),Color3.new(1,1,1))
 e.LightEmission=1;e.Rate=1.2;e.Lifetime=NumberRange.new(.25,.5);e.Speed=NumberRange.new(.05,.2)
 e.SpreadAngle=Vector2.new(180,180);e.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.35,.12),NumberSequenceKeypoint.new(1,0)})
 e.Parent=part
end
local function rightIncisor(model,head)
 -- Upper central incisor on the character's right (the viewer's left).
 local best,score
 local left=model:FindFirstChild('EyeLeft',true);local rightEye=model:FindFirstChild('EyeRight',true)
 if left and not left:IsA('BasePart')then left=left:FindFirstChildWhichIsA('BasePart',true)end
 if rightEye and not rightEye:IsA('BasePart')then rightEye=rightEye:FindFirstChildWhichIsA('BasePart',true)end
 local front=left and rightEye and((left.Position+rightEye.Position)*.5-head.Position)or head.CFrame.LookVector
 front=Vector3.new(front.X,0,front.Z);front=front.Magnitude>.001 and front.Unit or Vector3.new(0,0,-1)
 local right=front:Cross(Vector3.new(0,1,0)).Unit
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')and ancestryName(p,model):match('^Tooth_0_%d+$')then
  local horizontal=(p.Position-head.Position):Dot(right)
  if horizontal>0 then local value=horizontal;if not score or value<score then best=p;score=value end end
 end end
 return best or model:FindFirstChild('Tooth_0_4',true)
end
function V.Decorate(model,member)
 local h=assert(V.Head(model),'Tête manquante');model.PrimaryPart=h;h.PivotOffset=CFrame.identity
 local old=model:FindFirstChild('DeadlyCollar');if old then old:Destroy()end
 local gold=Color3.fromRGB(245,193,53)
 local incisor=member=='Stack'and rightIncisor(model,h)or nil
 for _,p in ipairs(model:GetDescendants())do
  if p:IsA('BasePart')then
   local name=ancestryName(p,model)
   local hidden=name=='Throat'or name=='InnerUpper'or name=='InnerLower'or name:match('^Angry')or name:find('Fangs')or name:find('FangGums')
   if name=='Head'and(model:FindFirstChild('UpperShell',true)or model:FindFirstChild('LowerShell',true))then hidden=true end
   p.Transparency=hidden and 1 or 0;p.LocalTransparencyModifier=0
   if member=='Void'then
    if name:match('^Tooth_')then solidColor(p,gold,Enum.Material.Metal,.32);sparkle(p)
    elseif name=='Gums'or name=='Head'or name:find('Shell')then solidColor(p,V.Colors.Void)end
   elseif member=='Domino'then
    if name=='Gums'then solidColor(p,Color3.fromRGB(3,3,5))
    elseif name=='Head'or name:find('Shell')then solidColor(p,Color3.fromRGB(255,255,255))end
   elseif member=='Stack'and p==incisor then solidColor(p,gold,Enum.Material.Metal,.3);sparkle(p)
   end
  end
 end
 if member~='Void'then
  local collar=Instance.new('Model');collar.Name='DeadlyCollar';collar.Parent=model
  local collarColor=member=='Domino'and Color3.fromRGB(3,3,5)or V.Colors[member]
  -- Broad upper fold plus vertical knit ribs: the collar remains visible around the jaw.
  for row=1,2 do for i=1,32 do
   local a=i*math.pi*2/32;local part=Instance.new('Part');part.Name='Knit'
   part.Size=Vector3.new(h.Size.X*.115,h.Size.Y*.16,h.Size.Z*.105)
   part.CFrame=h.CFrame*CFrame.new(math.cos(a)*h.Size.X*.38,-h.Size.Y*(.44+(row-1)*.115),math.sin(a)*h.Size.Z*.34)*CFrame.Angles(0,-a,0)
   part.Color=collarColor;part.Material=Enum.Material.Fabric;part.Anchored=true
   part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Parent=collar
  end end
 end
 model:SetAttribute('DeadlyMember',member)
 return model
end
function V.Make(base,member,scale)
 local model=V.Clean(base:Clone());model.Name=member
 V.Decorate(model,member);model:ScaleTo((model:GetScale())*(scale or .5));return model
end
function V.Aura(model,color,name)
 local old=V.Head(model):FindFirstChild(name or 'DeadlyAura');if old then old:Destroy()end
 local h=V.Head(model);local att=Instance.new('Attachment');att.Name=name or 'DeadlyAura';att.Position=Vector3.new(0,0,h.Size.Z*.4);att.Parent=model
 -- Attachments need a BasePart to emit; keep ownership under the head.
 att.Parent=h
 local emitter=Instance.new('ParticleEmitter');emitter.Name='Prestige';emitter.Texture='rbxasset://textures/particles/sparkles_main.dds'
 emitter.Color=ColorSequence.new(color,Color3.new(1,1,1));emitter.LightEmission=1;emitter.Rate=28
 emitter.Speed=NumberRange.new(1,3);emitter.Lifetime=NumberRange.new(.4,1);emitter.SpreadAngle=Vector2.new(180,180)
 emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,.3),NumberSequenceKeypoint.new(.6,.5),NumberSequenceKeypoint.new(1,0)});emitter.Parent=att
 return att
end
local function portalPart(parent,name,size,cf,color,alpha,material)
 local p=Instance.new('Part');p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color
 p.Material=material or Enum.Material.Neon;p.Transparency=alpha or 0;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent;return p
end
function V.VoidPortal(size,depthSign)
 local portal=Instance.new('Model');portal.Name='DeadlyVoidPortal';portal:SetAttribute('VoidPortalSize',size)
 local depth=size*.95*depthSign
 -- A deep opaque back closes the tunnel; the front remains hollow around the family.
 local back=portalPart(portal,'VoidAbyss',Vector3.new(.08,size*2.12,size*2.12),CFrame.new(0,0,depth+size*.68*depthSign)*CFrame.Angles(0,math.pi/2,0),Color3.fromRGB(1,3,2),0,Enum.Material.SmoothPlastic)
 back.Shape=Enum.PartType.Cylinder
 local palette={Color3.fromRGB(24,236,105),Color3.fromRGB(4,110,66),Color3.fromRGB(41,255,180)}
 -- Layered rings and jagged sigils travel in opposing directions.
 for ring=1,3 do
  local layer=Instance.new('Model');layer.Name='VoidRing_'..ring;layer.Parent=portal
  layer:SetAttribute('VoidSpin',(ring%2==0 and -1 or 1)*(.10+ring*.035))
  local radius=size*(1.04-ring*.15);local z=depth+size*(ring-1)*.115*depthSign
  for i=1,32 do
   local angle=i*math.pi*2/32
   local length=radius*.205;local wave=math.sin(i*1.77+ring)*.015*size
   local cf=CFrame.new(math.cos(angle)*(radius+wave),math.sin(angle)*(radius+wave),z)*CFrame.Angles(0,0,angle+math.pi/2)
   portalPart(layer,'VoidCurrent',Vector3.new(length,size*(ring==1 and .058 or .026),size*.026),cf,palette[(i+ring)%3+1],ring==1 and .06 or .24)
   if ring==1 and i%4==0 then
    portalPart(layer,'VoidRune',Vector3.new(size*.075,size*.013,size*.017),cf*CFrame.new(0,size*.049,0)*CFrame.Angles(0,0,math.pi/3),palette[3],.12)
    portalPart(layer,'VoidRune',Vector3.new(size*.035,size*.013,size*.017),cf*CFrame.new(size*.022,size*.069,0)*CFrame.Angles(0,0,-math.pi/3),palette[1],.12)
   end
  end
  layer.WorldPivot=CFrame.new(0,0,z)
 end
 -- Curved streams coil toward the distant core, rather than flat concentric hoops.
 local stream=Instance.new('Model');stream.Name='VoidSpiral';stream.Parent=portal;stream:SetAttribute('VoidSpin',-.27)
 for arm=1,3 do
  for i=1,16 do
   local u=i/16;local angle=arm*math.pi*2/3+u*math.pi*2.4;local r=size*(.06+.58*u)
   local angle2=angle+.12;local r2=r+size*.018
   local start=Vector3.new(math.cos(angle)*r,math.sin(angle)*r,depth+size*(.2+.42*(1-u))*depthSign)
   local finish=Vector3.new(math.cos(angle2)*r2,math.sin(angle2)*r2,start.Z)
   local delta=finish-start
   portalPart(stream,'VoidSpiralStream',Vector3.new(delta.Magnitude+size*.008,size*(.012+.016*u),size*.014),CFrame.new((start+finish)*.5)*CFrame.Angles(0,0,math.atan2(delta.Y,delta.X)),palette[arm],.22+.3*(1-u))
  end
 end
 stream.WorldPivot=CFrame.new(0,0,depth)
 local core=portalPart(portal,'VoidCore',Vector3.new(size*.012,size*.09,size*.09),CFrame.new(0,0,depth+size*.61*depthSign)*CFrame.Angles(0,math.pi/2,0),Color3.fromRGB(173,255,153),.12)
 core.Shape=Enum.PartType.Cylinder
 local sparks=Instance.new('Model');sparks.Name='VoidSparks';sparks.Parent=portal;sparks:SetAttribute('VoidSpin',.17)
 for i=1,12 do
  local a=i*2.399963;local r=size*(.78+(i%4)*.085)
  portalPart(sparks,'VoidEmber',Vector3.new(size*.016,size*.05,size*.012),CFrame.new(math.cos(a)*r,math.sin(a)*r,depth-size*.035*depthSign)*CFrame.Angles(0,0,a),palette[i%3+1],.2)
 end
 sparks.WorldPivot=CFrame.new(0,0,depth)
 portal.WorldPivot=CFrame.new(0,0,depth);return portal
end
function V.OptimizePreview(scene)
 if scene:GetAttribute('DeadlyPreviewLite')then return scene end
 for _,object in ipairs(scene:GetDescendants())do
  if object:IsA('ParticleEmitter')or object:IsA('Trail')or object:IsA('Beam')then object:Destroy()end
 end
 for _,object in ipairs(scene:GetDescendants())do if object:IsA('Model')and object.Name=='DeadlyCollar'then
  local count=0
  for _,part in ipairs(object:GetChildren())do if part:IsA('BasePart')then count=count+1;if count%2==0 then part:Destroy()else part.Size=Vector3.new(part.Size.X*1.8,part.Size.Y,part.Size.Z)end end end
 end end
 scene:SetAttribute('DeadlyPreviewLite',true);return scene
end
function V.PreviewClone(template)
 return V.OptimizePreview(V.Clean(template:Clone()))
end
function V.Spiral(base)
 local scene=Instance.new('Model');scene.Name='Crax_Deadly'
 local names={'OG','Domino','Parker','Dodger','Vice','Stack','Void'}
 local size=V.Head(base).Size.X;local og
 for i,name in ipairs(names)do
  local scale=i==1 and .5 or .5*(1-(i-1)*.09)
  local m=V.Make(base,name,scale);m.Parent=scene
  local h=V.Head(m);if i==1 then og=h end
  local a=(i-2)*1.32;local r=size*(.53+(i-2)*.045)
  local pos=i==1 and Vector3.zero or Vector3.new(math.cos(a)*r,math.sin(a)*r,(i-1)*size*.11)
  if name=='Void'then pos=pos+Vector3.new(0,size*.34,0)end -- DeadlyVoidPreviewRaised_v1
  m:PivotTo(CFrame.new(pos)*base:GetPivot().Rotation)
 end
 scene.PrimaryPart=og;scene:SetAttribute('DeadlySpiral',true)
 local eye=base:FindFirstChild('EyeLeft',true);if eye and not eye:IsA('BasePart')then eye=eye:FindFirstChildWhichIsA('BasePart',true)end
 local front=eye and(eye.Position-V.Head(base).Position)or Vector3.new(0,0,-1)
 local depthSign=front.Z>0 and -1 or 1
 if depthSign<0 then for _,m in ipairs(scene:GetChildren())do if m:IsA('Model')then local cf=m:GetPivot();m:PivotTo(CFrame.new(cf.Position.X,cf.Position.Y,-cf.Position.Z)*cf.Rotation)end end end
 local portal=V.VoidPortal(size,depthSign);portal.Parent=scene
 scene:SetAttribute('DeadlyAnimatedPreview',true)
 return V.OptimizePreview(scene)
end
local previewRecords=setmetatable({},{__mode='k'});local renderConnection
local function visible(view)
 local p=view
 while p do
  if p:IsA('GuiObject')and not p.Visible then return false end
  if p:IsA('ScreenGui')and not p.Enabled then return false end
  p=p.Parent
 end
 return view.AbsoluteSize.X>0 and view.AbsoluteSize.Y>0
end
local function cameraFit(view,record)
 local camera=view.CurrentCamera;if not camera then return end
 local aspect=view.AbsoluteSize.X/math.max(1,view.AbsoluteSize.Y)
 local size=record.size
 local distance=(math.max(size.Y,size.X/math.max(.2,aspect))/(2*math.tan(math.rad(camera.FieldOfView/2)))*1.16+size.Z/2)*.74 -- DeadlyPreviewZoom_v1
 record.frame=CFrame.lookAt(record.center+record.front*distance,record.center)
 camera.CFrame=record.frame;camera.Focus=CFrame.new(record.center)
end
function V.AnimatePreview(view,time)
 local r=previewRecords[view];if not r or not r.model.Parent then return end
 if not visible(view)or view.AbsoluteSize.X<180 or view.AbsoluteSize.Y<150 then return end
 for i,m in ipairs(r.members)do
  if m.model.Parent then
   local offset=Vector3.new(math.sin(time*.71+i*1.4)*r.unit*.008,math.sin(time*1.12+i*1.17)*r.unit*.027,0)
   m.model:PivotTo(CFrame.new(offset)*m.base)
  end
 end
 for _,layer in ipairs(r.layers)do if layer.model.Parent then layer.model:PivotTo(layer.base*CFrame.Angles(0,0,time*layer.speed))end end
 if r.core and r.core.Parent then r.core.Transparency=.13+.12*(.5+.5*math.sin(time*1.7))end
 local camera=view.CurrentCamera
 if camera then camera.CFrame=r.frame;camera.Focus=CFrame.new(r.center)end
end
local function bind(view,model,cf,size,front)
 V.OptimizePreview(model)
 local r=previewRecords[view]
 if not r or r.model~=model then
  r={model=model,center=cf.Position,size=size,front=front,members={},layers={},unit=V.Head(model).Size.X*2,time=0};previewRecords[view]=r
  for _,child in ipairs(model:GetChildren())do if child:IsA('Model')and child:GetAttribute('DeadlyMember')then r.members[#r.members+1]={model=child,base=child:GetPivot()}end end
  local portal=model:FindFirstChild('DeadlyVoidPortal')
  if portal then
   r.unit=portal:GetAttribute('VoidPortalSize')or r.unit;r.core=portal:FindFirstChild('VoidCore')
   for _,layer in ipairs(portal:GetChildren())do local speed=layer:GetAttribute('VoidSpin')
    if layer:IsA('Model')and speed then r.layers[#r.layers+1]={model=layer,base=layer:GetPivot(),speed=speed}end
   end
  end
  view:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()if previewRecords[view]==r and view.Parent then cameraFit(view,r)end end)
 end
 cameraFit(view,r)
 if not renderConnection then
  local Run=game:GetService('RunService')
  if Run:IsClient()then
   local accumulated=0
   renderConnection=Run.RenderStepped:Connect(function(dt)
    accumulated=accumulated+dt;if accumulated<1/20 then return end
    local advance=accumulated;accumulated=0
    for surface,record in pairs(previewRecords)do
     if not surface.Parent or not record.model.Parent then previewRecords[surface]=nil
     elseif visible(surface)then record.time=record.time+advance;V.AnimatePreview(surface,record.time)end
    end
   end)
  end
 end
end
function V.Fit(view,model)
 if not model:GetAttribute('DeadlySpiral')then return end
 local h=V.Head(model);local eye=model:FindFirstChild('EyeLeft',true)
 if eye and not eye:IsA('BasePart')then eye=eye:FindFirstChildWhichIsA('BasePart',true)end
 local other=model:FindFirstChild('EyeRight',true)
 if other and not other:IsA('BasePart')then other=other:FindFirstChildWhichIsA('BasePart',true)end
 local front=eye and other and((eye.Position+other.Position)*.5-h.Position)or Vector3.new(0,0,-1)
 front=Vector3.new(front.X,0,front.Z);front=front.Magnitude>.001 and front.Unit or Vector3.new(0,0,-1)
 local cf,size=model:GetBoundingBox()
 bind(view,model,cf,size,front)
end
local emeraldLabels=setmetatable({},{__mode='k'})
function V.EmeraldStyle(label,enabled)
 local entry=emeraldLabels[label]
 if not enabled then
  if entry then entry.tween:Cancel();if entry.gradient.Parent then entry.gradient:Destroy()end;label.TextColor3=entry.color;label.TextStrokeColor3=entry.stroke;label.TextStrokeTransparency=entry.alpha;emeraldLabels[label]=nil end
  return
 end
 if entry then label.TextColor3=Color3.new(1,1,1);return end
 local g=label:FindFirstChild('DeadlyEmeraldGem')or Instance.new('UIGradient');g.Name='DeadlyEmeraldGem';g.Rotation=35
 g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,55,36)),ColorSequenceKeypoint.new(.25,V.Emerald),ColorSequenceKeypoint.new(.43,Color3.fromRGB(210,255,240)),ColorSequenceKeypoint.new(.52,Color3.fromRGB(0,110,75)),ColorSequenceKeypoint.new(.8,V.Emerald),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,40,30))})
 entry={color=label.TextColor3,stroke=label.TextStrokeColor3,alpha=label.TextStrokeTransparency,gradient=g};emeraldLabels[label]=entry
 label.TextColor3=Color3.new(1,1,1);label.TextStrokeColor3=Color3.fromRGB(0,50,33);label.TextStrokeTransparency=.15;g.Parent=label
 entry.tween=game:GetService('TweenService'):Create(g,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Offset=Vector2.new(.25,0)});entry.tween:Play()
 label.Destroying:Connect(function()if emeraldLabels[label]==entry then entry.tween:Cancel();emeraldLabels[label]=nil end end)
end
return V

end)()
local fit=data.Fit
function data.Fit(view,model)
 if model:GetAttribute('SymPreview')then return require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSymPreview')).Bind(view,model)end
 return fit(view,model)
end
return data
