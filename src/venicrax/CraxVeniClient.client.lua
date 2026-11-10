-- VeniCrax : présentation seulement (effets, sons, cinématique). Toutes les décisions sont prises par le serveur.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players');local SoundService=game:GetService('SoundService')
local C=require(RS:WaitForChild('CraxVeniConfig'));local Audio=require(RS:WaitForChild('CraxVeniAudio'));local FX=RS:WaitForChild('CraxVeniFX');local state=workspace:WaitForChild('CombatState');local player=Players.LocalPlayer
local low=C.Quality=='Low'or C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local root=Instance.new('Folder');root.Name='VeniCrax_Local';root.Parent=workspace
local VENOM=Color3.fromRGB(150,255,40);local TOXIC=Color3.fromRGB(70,200,60);local DARK=Color3.fromRGB(16,70,28);local GOLD=Color3.fromRGB(246,214,90);local CREAM=Color3.fromRGB(228,206,146)
local SMOKE='rbxasset://textures/particles/smoke_main.dds';local SPARK='rbxasset://textures/particles/sparkles_main.dds'
local auras={};local cobras={};local molts={};local orbs={};local pips={};local pulses={};local scene;local seen;local accumulated=0
local function make(c,p,parent)local o=Instance.new(c);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local f=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=f and id and f:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function world(p)return(frame()*CFrame.new(p)).Position end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function radiusOf(m)local h=head(m);return h and math.max(1,h.Size.Y*.5)or 2 end
local function sound(name,m,loop,finale)return Audio.Play(name,(typeof(m)=='Vector3'and m)or position(m)or Vector3.zero,loop,finale,player:GetAttribute('ArenaSeat')~=nil)end
local function ease(t,a,b)local u=math.clamp((t-a)/(b-a),0,1);return u*u*(3-2*u)end
local function aim(a,b,up)
 local d=b-a;if d.Magnitude<1e-6 then return CFrame.new(a)end;up=up or Vector3.new(0,1,0)
 if up:Cross(d).Magnitude<1e-6 then up=Vector3.new(0,0,1)end;return CFrame.lookAt(a,b,up)
end
local function part(props,parent)
 local p={Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic}
 for k,v in pairs(props)do p[k]=v end;return make('Part',p,parent)
end
local function seq(a,b)return ColorSequence.new(a,b)end
local function nseq(points)local k={};for _,p in ipairs(points)do k[#k+1]=NumberSequenceKeypoint.new(p[1],p[2])end;return NumberSequence.new(k)end
-- Brume toxique (sans bulle qui éclate) : fumée verte douce + petites gouttelettes lumineuses.
local function mist(parent,color,rate,size)
 local a=make('Attachment',{},parent)
 local smoke=make('ParticleEmitter',{Texture=SMOKE,Color=seq(color,DARK),Rate=low and rate*.5 or rate,Lifetime=NumberRange.new(.9,1.6),Speed=NumberRange.new(.6,1.6),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,size*.5},{.5,size},{1,size*1.5}}),Transparency=nseq({{0,1},{.15,.55},{1,1}}),LightEmission=.35,RotSpeed=NumberRange.new(-30,30),Rotation=NumberRange.new(0,360),Acceleration=Vector3.new(0,1.2,0)},a)
 local drops=make('ParticleEmitter',{Texture=SPARK,Color=seq(VENOM,TOXIC),Rate=low and rate*.2 or rate*.4,Lifetime=NumberRange.new(.5,.9),Speed=NumberRange.new(.5,1.5),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,.25},{1,0}}),Transparency=nseq({{0,.1},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,-3,0)},a)
 return a,smoke,drops
end
local function burst(p,color,count,size)
 local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root)
 local a=make('Attachment',{},holder)
 local e=make('ParticleEmitter',{Texture=SPARK,Color=seq(color,TOXIC),Rate=0,Lifetime=NumberRange.new(.35,.7),Speed=NumberRange.new(6,14),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,size or .45},{1,0}}),Transparency=nseq({{0,0},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,-14,0),Drag=3},a)
 local s=make('ParticleEmitter',{Texture=SMOKE,Color=seq(color,DARK),Rate=0,Lifetime=NumberRange.new(.5,.9),Speed=NumberRange.new(1,3),SpreadAngle=Vector2.new(180,180),Size=nseq({{0,.8},{1,2.6}}),Transparency=nseq({{0,.45},{1,1}}),LightEmission=.3},a)
 e:Emit(low and math.ceil(count*.5)or count);s:Emit(low and 3 or 6)
 local light=make('PointLight',{Color=color,Brightness=3,Range=10},holder)
 pulses[#pulses+1]={holder=holder,light=light,born=os.clock()}
end
local function ring(cf,color,radius,width)
 return part({Shape=Enum.PartType.Cylinder,Size=Vector3.new(width or .08,radius*2,radius*2),CFrame=cf*CFrame.Angles(0,math.pi/2,0),Color=color,Material=Enum.Material.Neon,Transparency=.35},root)
end
local function arenaRotation()return frame().Rotation end

-- ===================================================================== cobra (modèle procédural)
local function cobraModel(parent,scale)
 local m=make('Model',{Name='VeniCobra'},parent);local segs={}
 local headPart=part({Name='CobraHead',Shape=Enum.PartType.Ball,Size=Vector3.new(.95,.62,1.25)*scale,Color=DARK,Material=Enum.Material.SmoothPlastic,Reflectance=.08},m)
 local hood=part({Name='CobraHood',Size=Vector3.new(1.7,1.1,.12)*scale,Color=TOXIC,Material=Enum.Material.SmoothPlastic},m)
 make('SpecialMesh',{MeshType=Enum.MeshType.Sphere},hood)
 local eyes={part({Shape=Enum.PartType.Ball,Size=Vector3.one*.16*scale,Color=VENOM,Material=Enum.Material.Neon},m),part({Shape=Enum.PartType.Ball,Size=Vector3.one*.16*scale,Color=VENOM,Material=Enum.Material.Neon},m)}
 local fangs={part({Size=Vector3.new(.06,.28,.06)*scale,Color=VENOM,Material=Enum.Material.Neon},m),part({Size=Vector3.new(.06,.28,.06)*scale,Color=VENOM,Material=Enum.Material.Neon},m)}
 local n=low and 8 or 14
 for i=1,n do local k=1-(i-1)/n;segs[i]=part({Name='CobraBody',Shape=Enum.PartType.Ball,Size=Vector3.one*(.62*k+.18)*scale,Color=i%3==0 and CREAM or DARK,Material=Enum.Material.SmoothPlastic,Reflectance=.06},m)end
 local a0=make('Attachment',{Position=Vector3.new(0,.15,0)*scale},headPart);local a1=make('Attachment',{Position=Vector3.new(0,-.15,0)*scale},headPart)
 make('Trail',{Attachment0=a0,Attachment1=a1,Color=seq(VENOM,TOXIC),Lifetime=.35,LightEmission=.8,Transparency=nseq({{0,.3},{1,1}}),WidthScale=nseq({{0,1},{1,0}})},headPart)
 make('PointLight',{Color=VENOM,Brightness=1.6,Range=7},headPart)
 return{model=m,head=headPart,hood=hood,eyes=eyes,fangs=fangs,segs=segs,scale=scale,history={}}
end
-- Place la tête puis fait suivre le corps le long de l'historique des positions.
local function poseCobra(c,pos,dir,up)
 up=up or arenaRotation().ZVector;local s=c.scale
 local cf=aim(pos,pos+dir,up)
 c.head.CFrame=cf;c.hood.CFrame=cf*CFrame.new(0,0,.45*s)*CFrame.Angles(0,0,0)
 c.eyes[1].CFrame=cf*CFrame.new(-.22*s,.2*s,-.38*s);c.eyes[2].CFrame=cf*CFrame.new(.22*s,.2*s,-.38*s)
 c.fangs[1].CFrame=cf*CFrame.new(-.14*s,-.3*s,-.5*s);c.fangs[2].CFrame=cf*CFrame.new(.14*s,-.3*s,-.5*s)
 table.insert(c.history,1,pos);while #c.history>80 do table.remove(c.history)end
 local spacing=.42*s;local idx=1;local acc=0;local prev=pos
 for i,seg in ipairs(c.segs)do
  local need=spacing*i;local placed=false
  while idx<#c.history do local a,b=c.history[idx],c.history[idx+1];local d=(b-a).Magnitude
   if acc+d>=need then seg.Position=a:Lerp(b,(need-acc)/math.max(d,1e-6));placed=true;break end;acc+=d;idx+=1 end
  if not placed then seg.Position=c.history[#c.history]-dir.Unit*spacing*(i-#c.history+1)end
  prev=seg.Position
 end
end

-- ===================================================================== combat
local function clearAura(target,kind)
 local list=auras[target];if not list then return end
 local a=list[kind];if a then a.holder:Destroy();list[kind]=nil end
 if not next(list)then auras[target]=nil end
end
local function clearCombat()
 for t,list in pairs(auras)do for k in pairs(list)do clearAura(t,k)end end;auras={}
 for _,c in pairs(cobras)do Audio.Stop(c.loop);c.model:Destroy()end;cobras={}
 for _,m in pairs(molts)do Audio.Stop(m.loop);m.folder:Destroy()end;molts={}
 for _,o in pairs(orbs)do o.folder:Destroy()end;orbs={}
 for _,p in pairs(pips)do p.gui:Destroy()end;pips={}
 for _,p in ipairs(pulses)do p.holder:Destroy()end;pulses={}
end
local function clone(m,parent)
 local registry=RS:FindFirstChild('CraxRenderRegistryV82');registry=registry and require(registry)
 local snapshot=registry and registry.Snapshot and registry.Snapshot(m,parent);local copy=snapshot and snapshot.Model
 if not copy then local a=m.Archivable;m.Archivable=true;copy=m:Clone();m.Archivable=a end
 copy.Name=m.Name
 for _,o in ipairs(copy:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 copy.Parent=parent;return copy
end
local function showPips(target,count,needed)
 local h=head(target);if not h then return end
 local p=pips[target];if not p then
  local gui=make('BillboardGui',{Name='VeniBitePips',Size=UDim2.fromOffset(90,26),StudsOffsetWorldSpace=Vector3.new(0,radiusOf(target)+2.4,0),AlwaysOnTop=true,Adornee=h},root)
  p={gui=gui,label=make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=VENOM,TextStrokeColor3=DARK,TextStrokeTransparency=0},gui)};pips[target]=p
 end
 p.label.Text=string.rep('◆',count)..string.rep('◇',math.max(0,needed-count));p.born=os.clock()
end

local function onEvent(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner
 if k=='Clear'then clearCombat();return end
 if k=='OwnerClear'then for id,c in pairs(cobras)do if c.owner==m then Audio.Stop(c.loop);c.model:Destroy();cobras[id]=nil end end;if orbs[m]then orbs[m].folder:Destroy();orbs[m]=nil end;return end
 if k=='Poison'then
  local t=d.Target;local h=head(t);if not h then return end
  local list=auras[t]or{};auras[t]=list;if list[d.Kind]then list[d.Kind].holder:Destroy()end
  local holder=part({Name='VeniPoisonAura',Size=Vector3.one*.1,Transparency=1},root)
  local color=d.Kind=='Cobra'and Color3.fromRGB(205,255,60)or VENOM
  local _,smoke=mist(holder,color,22,radiusOf(t)*.9)
  local light=make('PointLight',{Color=color,Brightness=1.4,Range=radiusOf(t)*3.5},holder)
  list[d.Kind]={holder=holder,target=t,smoke=smoke,light=light,born=os.clock()}
  burst(position(t),color,18);sound(d.Kind=='Cobra'and'CobraImpact'or'Bite',t)
 elseif k=='PoisonEnd'then clearAura(d.Target,d.Kind)
 elseif k=='PoisonTick'then local p=position(d.Target);if p then burst(p+Vector3.new(0,radiusOf(d.Target)*.4,0),VENOM,low and 4 or 8,.3);sound('PoisonTick',d.Target)end
 elseif k=='BiteStack'then
  showPips(d.Target,d.Count,d.Needed)
  local a,b=position(m),position(d.Target);if a and b then local p=a:Lerp(b,.5);burst(p,VENOM,6,.3)end
  if d.Count<d.Needed then sound('BiteStack',d.Target)end
 elseif k=='Cobra'then
  if cobras[d.Id]then cobras[d.Id].model:Destroy()end
  local c=cobraModel(root,1.15);c.owner=m;c.from=world(d.Position);c.position=c.from;c.at=os.clock();c.direction=frame():VectorToWorldSpace(d.Direction)
  poseCobra(c,c.position,c.direction);cobras[d.Id]=c;sound('Spit',m);c.loop=sound('CobraLoop',m,true)
  local p=position(m);if p then burst(p+c.direction*radiusOf(m),VENOM,14,.4)end
 elseif k=='CobraState'then local c=cobras[d.Id];if c then c.from=c.display or c.position;c.position=world(d.Position);c.direction=frame():VectorToWorldSpace(d.Direction);c.at=os.clock()end
 elseif k=='CobraBounce'then local p=world(d.Position);burst(p,VENOM,16,.5);sound('Bounce',p);local c=cobras[d.Id];if c then Audio.Move(c.loop,p)end
 elseif k=='CobraImpact'then local p=world(d.Position);burst(p,Color3.fromRGB(205,255,60),26,.55);sound('CobraImpact',p)
  local c=cobras[d.Id];if c then Audio.Stop(c.loop);c.model:Destroy();cobras[d.Id]=nil end
 elseif k=='CobraEnd'then local c=cobras[d.Id];if c then Audio.Stop(c.loop);burst(c.display or c.position,TOXIC,8,.35);c.model:Destroy();cobras[d.Id]=nil end
 elseif k=='DistillReady'then
  if orbs[m]then orbs[m].folder:Destroy()end
  local folder=make('Folder',{Name='VeniDistillOrbs'},root);local list={}
  for i=1,3 do list[i]=part({Shape=Enum.PartType.Ball,Size=Vector3.one*.42,Color=VENOM,Material=Enum.Material.Neon},folder);make('PointLight',{Color=VENOM,Brightness=1,Range=4},list[i])end
  orbs[m]={folder=folder,list=list,born=os.clock()};sound('DistillReady',m)
 elseif k=='Distill'then
  if orbs[m]then orbs[m].folder:Destroy();orbs[m]=nil end
  local p=position(m);if p then
   local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root);local a=make('Attachment',{},holder)
   local e=make('ParticleEmitter',{Texture=SPARK,Color=seq(VENOM,GOLD),Rate=0,Lifetime=NumberRange.new(.8,1.3),Speed=NumberRange.new(3,6),SpreadAngle=Vector2.new(25,25),EmissionDirection=Enum.NormalId.Top,Size=nseq({{0,.5},{1,0}}),Transparency=nseq({{0,0},{1,1}}),LightEmission=1,Acceleration=Vector3.new(0,4,0)},a)
   e:Emit(low and 20 or 40);local light=make('PointLight',{Color=GOLD,Brightness=4,Range=12},holder)
   local halo=ring(CFrame.new(p)*arenaRotation(),GOLD,radiusOf(m)*1.2,.06)
   pulses[#pulses+1]={holder=holder,light=light,born=os.clock(),halo=halo,haloRadius=radiusOf(m)*1.2}
  end
  sound('Distill',m)
 elseif k=='Molt'then
  if molts[d.Id]then molts[d.Id].folder:Destroy()end
  local folder=make('Folder',{Name='VeniMolt'},root);local r={folder=folder,owner=m,born=os.clock(),life=d.Life,position=world(d.Position)}
  if m and m.Parent then
   local ghost=clone(m,folder);ghost:PivotTo(CFrame.new(r.position)*(m:GetPivot().Rotation))
   for _,o in ipairs(ghost:GetDescendants())do if o:IsA('BasePart')then o.Material=Enum.Material.Glass;o.Color=Color3.fromRGB(190,255,170);o.Transparency=math.max(o.Transparency,.55);o.Reflectance=.2 end end
   r.ghost=ghost
  end
  local a,smoke=mist(part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(r.position)},folder),TOXIC,6,1.4);r.smoke=smoke
  r.loop=sound('MoltIdle',r.position,true);sound('MoltShed',m);molts[d.Id]=r
 elseif k=='MoltTrigger'then
  local r=molts[d.Id];local p=world(d.Position)
  if r then r.trigger=os.clock();r.delay=d.Delay;r.radius=d.Radius;r.ring=ring(CFrame.new(p)*arenaRotation(),VENOM,.5,.1);r.inner=ring(CFrame.new(p)*arenaRotation(),Color3.fromRGB(230,255,120),.3,.06)end
  sound('MoltWarn',p)
 elseif k=='MoltCloud'then
  local p=world(d.Position);local holder=part({Size=Vector3.one*.1,Transparency=1,CFrame=CFrame.new(p)},root);local a=make('Attachment',{},holder)
  local e=make('ParticleEmitter',{Texture=SMOKE,Color=seq(VENOM,DARK),Rate=0,Lifetime=NumberRange.new(1.2,2),Speed=NumberRange.new(d.Radius*1.2,d.Radius*2.2),Drag=4,SpreadAngle=Vector2.new(180,180),Size=nseq({{0,2},{.4,d.Radius*.9},{1,d.Radius*1.2}}),Transparency=nseq({{0,.35},{.6,.6},{1,1}}),LightEmission=.4,RotSpeed=NumberRange.new(-40,40),Rotation=NumberRange.new(0,360)},a)
  e:Emit(low and 18 or 36)
  local sphere=part({Shape=Enum.PartType.Ball,Size=Vector3.one*.5,CFrame=CFrame.new(p),Color=VENOM,Material=Enum.Material.ForceField,Transparency=.2},holder)
  pulses[#pulses+1]={holder=holder,light=make('PointLight',{Color=VENOM,Brightness=4,Range=d.Radius*3},holder),born=os.clock(),sphere=sphere,radius=d.Radius,life=1.6}
  local r=molts[d.Id];if r then if r.ring then r.ring:Destroy();r.inner:Destroy();r.ring=nil end;if r.ghost then r.ghost:Destroy();r.ghost=nil end end
  sound('Cloud',p)
 elseif k=='MoltEnd'then local r=molts[d.Id];if r then Audio.Stop(r.loop);r.dying=os.clock();r.smoke.Enabled=false;if r.ring then r.ring:Destroy();r.inner:Destroy();r.ring=nil end end
 end
end
FX.OnClientEvent:Connect(onEvent)

Run.Heartbeat:Connect(function(dt)
 accumulated+=dt;if accumulated<(low and 1/24 or 1/45)then return end;local step=accumulated;accumulated=0
 local now=os.clock()
 for t,list in pairs(auras)do local p=position(t);for k,a in pairs(list)do if not p or not t.Parent then clearAura(t,k)else a.holder.CFrame=CFrame.new(p);a.light.Brightness=1.1+.5*math.sin(now*6)end end end
 for id,c in pairs(cobras)do
  if not c.owner or not c.owner.Parent or now-c.at>1 then Audio.Stop(c.loop);c.model:Destroy();cobras[id]=nil
  else c.display=c.from:Lerp(c.position,math.clamp((now-c.at)/.05,0,1));local wiggle=arenaRotation().UpVector:Cross(c.direction).Unit*math.sin(now*22)*.18
   poseCobra(c,c.display+wiggle,c.direction);Audio.Move(c.loop,c.display)end
 end
 for m,o in pairs(orbs)do local p=position(m);if not p then o.folder:Destroy();orbs[m]=nil else local r=radiusOf(m)*1.35
  for i,b in ipairs(o.list)do local a=now*2.4+i*math.pi*2/3;b.CFrame=CFrame.new(p)*arenaRotation()*CFrame.new(math.cos(a)*r,math.sin(a)*r*.6+.4,0)end end end
 for t,p in pairs(pips)do if now-p.born>1.6 or not t.Parent then p.gui:Destroy();pips[t]=nil end end
 for id,r in pairs(molts)do
  local age=now-r.born
  if r.ghost then local fade=math.clamp(age/(r.life or 8),0,1);for _,o in ipairs(r.ghost:GetDescendants())do if o:IsA('BasePart')then o.LocalTransparencyModifier=fade*.6 end end end
  if r.ring then local u=math.clamp((now-r.trigger)/math.max(r.delay,.05),0,1);local rad=.5+(r.radius-.5)*u;local pulse=.25+.2*math.sin(now*30)
   r.ring.Size=Vector3.new(.1,rad*2,rad*2);r.ring.Transparency=pulse;r.inner.Size=Vector3.new(.06,rad*1.4,rad*1.4)end
  if r.dying and now-r.dying>1.2 then r.folder:Destroy();molts[id]=nil elseif age>(r.life or 8)+3 then Audio.Stop(r.loop);r.folder:Destroy();molts[id]=nil end
 end
 for i=#pulses,1,-1 do local p=pulses[i];local age=now-p.born;local life=p.life or .8
  if age>=life+.6 then p.holder:Destroy();if p.halo then p.halo:Destroy()end;table.remove(pulses,i)
  else p.b0=p.b0 or p.light.Brightness;p.light.Brightness=p.b0*(1-math.clamp(age/life,0,1))
   if p.sphere then local u=ease(age,0,.45);p.sphere.Size=Vector3.one*(p.radius*2*u+.5);p.sphere.Transparency=.2+.8*ease(age,.5,life)end
   if p.halo then local u=ease(age,0,.6);p.halo.Size=Vector3.new(.06,p.haloRadius*2*(1+u),p.haloRadius*2*(1+u));p.halo.Transparency=.3+.7*u end
  end
 end
end)

-- ===================================================================== exécution MAX : « Animation 3 »
local function duck(s,winner,loser)
 s.ducked={};local group=SoundService:FindFirstChild('CraxMusicControl')
 if group and group:IsA('SoundGroup')then s.equalizer=make('EqualizerSoundEffect',{Name='VeniFinaleDuck',HighGain=-80,MidGain=-80,LowGain=-80},group)end
 local function candidate(o)
  if not o:IsA('Sound')then return end;local parent=o.Parent;local scoped=false
  while parent and parent~=workspace do if parent==winner or parent==loser then scoped=true;break end;parent=parent.Parent end
  if not scoped or s.ducked[o]then return end;s.ducked[o]=o.Volume;o.Volume=0
 end
 for _,o in ipairs(workspace:GetDescendants())do candidate(o)end;s.soundAdded=workspace.DescendantAdded:Connect(candidate)
end
local function hideActor(s,model)
 for _,o in ipairs(model:GetDescendants())do
  if s.hidden[o]==nil then
   if o:IsA('BasePart')then s.hidden[o]=o.LocalTransparencyModifier;o.LocalTransparencyModifier=1
   elseif o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then s.hidden[o]=o.Enabled;o.Enabled=false end
  end
 end
end
local function alpha(model,value)for _,o in ipairs(model:GetDescendants())do if o:IsA('BasePart')then o.LocalTransparencyModifier=math.clamp(value,0,1)end end end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('VeniFinaleCamera')
 if s.soundAdded then s.soundAdded:Disconnect()end;for o,v in pairs(s.ducked or{})do if o.Parent then o.Volume=v end end;if s.equalizer then s.equalizer:Destroy()end
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('VeniCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='VeniFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local h=player.Character and player.Character:FindFirstChild('HumanoidRootPart');local p=position(winner);if not h or not p or(h.Position-p).Magnitude>180 then return end end
 local started=state:GetAttribute('RoundVictoryStartedAt');if type(started)~='number'or workspace:GetServerTimeNow()-started>=C.FinaleDuration then return end
 local wh,lh=head(winner),head(loser);if not wh or not lh then return end
 clearCombat();Audio.Clear();seen=tostring(token)..':'..round
 local s={folder=make('Folder',{Name='VeniFinale'},root),hidden={},saved={},camera=cam,start=started,previous=player:GetAttribute('VeniCameraOwner'),cues={}}
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 local r=math.max(1,wh.Size.Y*.5,lh.Size.Y*.5)
 local stage=lh.Position;local L,Rt,T,B=workspace:FindFirstChild('Arenaleft'),workspace:FindFirstChild('ArenaRight'),workspace:FindFirstChild('ArenaTop'),workspace:FindFirstChild('Arenabottom')
 if L and Rt and T and B then stage=Vector3.new((L.Position.X+Rt.Position.X)*.5,(T.Position.Y+B.Position.Y)*.5,lh.Position.Z)end
 local basis=frame().Rotation;local center=frame()*CFrame.new(stage)*CFrame.new(0,0,-r*6)
 s.backdrop=part({Name='VeniCinemaBackdrop',Size=Vector3.new(r*36,r*60,.1),CFrame=center*CFrame.new(0,0,r*5),Color=Color3.fromRGB(4,14,7)},s.folder)
 s.wall=part({Name='VeniRicochetWall',Size=Vector3.new(r*.35,r*7,r*2),CFrame=center*CFrame.new(r*5.2,r*1.5,0),Color=Color3.fromRGB(30,60,36),Material=Enum.Material.Slate},s.folder)
 s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder)
 local heroHead=s.hero:FindFirstChild('Head',true);local victimHead=s.victim:FindFirstChild('Head',true)
 local heroOffset=heroHead and s.hero:GetPivot():ToObjectSpace(heroHead.CFrame)or CFrame.identity
 local victimOffset=victimHead and s.victim:GetPivot():ToObjectSpace(victimHead.CFrame)or CFrame.identity
 local wr,lr=wh.CFrame.Rotation,lh.CFrame.Rotation
 s.cobra=cobraModel(s.folder,r*.62)
 -- Fissures vertes : segments néon posés sur la face visible de la victime.
 s.cracks={};local n=low and 12 or 22
 for i=1,n do
  local ang=i*2.399963;local zz=1-2*(i-.5)/n;local rad=math.sqrt(math.max(0,1-zz*zz))
  local dir=Vector3.new(math.cos(ang)*rad,zz,-math.abs(math.sin(ang*1.7))*.6-.4).Unit
  s.cracks[i]={part=part({Name='VeniCrack',Size=Vector3.new(r*.05,r*.05,r*(.35+(i%4)*.12)),Color=VENOM,Material=Enum.Material.Neon,Transparency=1},s.folder),dir=dir,tilt=(i%7)*.9,at=5.9+(i/n)*.8}
 end
 -- Éclats de vinyle façon figurine : couleurs réelles de la victime, matière lisse et brillante.
 local palette={};for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.95 then palette[#palette+1]=p.Color end end;if #palette==0 then palette[1]=Color3.new(1,1,1)end
 s.debris={};local count=low and 20 or 40
 for i=1,count do
  local ang=i*2.399963;local zz=1-2*(i-.5)/count;local rad=math.sqrt(math.max(0,1-zz*zz));local dir=Vector3.new(math.cos(ang)*rad,math.sin(ang)*rad,zz*.45)
  s.debris[i]={part=make(i%2==0 and'WedgePart'or'Part',{Name='VeniVinylShard',Size=Vector3.new(.2+(i%3)*.07,.28,.1+(i%4)*.05)*r,Color=palette[(i-1)%#palette+1],Material=Enum.Material.SmoothPlastic,Reflectance=.12,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},s.folder),dir=dir,offset=dir*r*(.4+(i%5)*.1),spin=Vector3.new(i%4+1,i%3+1,i%5+1)}
 end
 s.gui=make('ScreenGui',{Name='VeniExecutionCinema',IgnoreGuiInset=true,ResetOnSpawn=false},player:WaitForChild('PlayerGui'))
 s.top=make('Frame',{Size=UDim2.fromScale(1,.08),BackgroundColor3=Color3.fromRGB(3,10,5),BorderSizePixel=0},s.gui)
 s.bottom=make('Frame',{Size=UDim2.fromScale(1,.08),Position=UDim2.fromScale(0,.92),BackgroundColor3=Color3.fromRGB(3,10,5),BorderSizePixel=0},s.gui)
 s.title=make('TextLabel',{Size=UDim2.fromScale(.8,.07),Position=UDim2.fromScale(.1,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=VENOM,TextStrokeColor3=DARK,TextStrokeTransparency=0,Font=Enum.Font.GothamBlack,TextScaled=true,TextTransparency=1},s.gui)
 s.mist=mist(part({Size=Vector3.one*.1,Transparency=1,CFrame=center},s.folder),VENOM,0,r*.8)
 hideActor(s,winner);hideActor(s,loser);duck(s,winner,loser);scene=s;player:SetAttribute('VeniCameraOwner',seen)
 local heroPos=(center*CFrame.new(-r*3.2,0,0)).Position;local victimPos=center.Position;local wallHit=(center*CFrame.new(r*5,r*2.6,0)).Position
 local function cobraAt(t)
  -- 0,6–1,6 : crachat vers le mur ; 1,6–2,4 : ricochet vers la victime ; 2,4–4,4 : deux tours autour de la tête ;
  -- 4,4–5,2 : pause ; 5,2–5,9 : resserrement ; ensuite le cobra reste serré jusqu'à l'éclatement.
  local mouth=heroPos+basis.XVector*r*.9+basis.YVector*(-r*.3)
  if t<1.6 then local u=ease(t,.6,1.6);return mouth:Lerp(wallHit,u)+basis.YVector*math.sin(u*math.pi)*r*.6,(wallHit-mouth).Unit
  elseif t<2.4 then local u=ease(t,1.6,2.4);local target=victimPos+basis.YVector*r*1.25;return wallHit:Lerp(target,u),(target-wallHit).Unit
  end
  local coil=ease(t,2.4,4.4);local tight=ease(t,5.2,5.9);local a=coil*math.pi*4+math.pi/2
  local radius=r*(1.32-.3*tight);local y=r*(.55-1.1*coil)
  local p=victimPos+basis.XVector*math.cos(a)*radius+basis.YVector*y+basis.ZVector*(-math.sin(a)*radius)
  local tangent=basis.XVector*-math.sin(a)+basis.ZVector*-math.cos(a)-basis.YVector*.18
  return p,tangent.Unit
 end
 Run:BindToRenderStep('VeniFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  t=math.max(0,t)
  local rear=ease(t,0,.55)*(1-ease(t,.6,.8));local shattered=t>=6.8;local tight=ease(t,5.2,5.9);local closing=ease(t,7.6,8.6)
  -- Héros : se cabre avant de cracher, puis se tourne vers la caméra à la fin.
  s.hero:PivotTo(CFrame.new(heroPos+basis.YVector*r*.25*rear)*wr*CFrame.Angles(-.25*rear,0,0)*heroOffset:Inverse())
  -- Victime : immobile, comprimée au resserrement, tremble pendant les fissures.
  local shake=(t>5.9 and t<6.8)and math.sin(t*90)*r*.03 or 0
  s.victim:PivotTo(CFrame.new(victimPos+basis.XVector*shake)*lr*victimOffset:Inverse())
  alpha(s.victim,shattered and 1 or 0)
  -- Cobra.
  local cp,cd=cobraAt(t);local visible=t>=.6 and t<6.8
  alpha(s.cobra.model,visible and 0 or 1)
  if visible then poseCobra(s.cobra,cp,cd,basis.YVector)end
  if t>=4.4 and t<5.2 then s.cobra.head.CFrame=aim(cp,(s.camera.CFrame.Position),basis.YVector);s.cobra.hood.Size=Vector3.new(1.7+.8*ease(t,4.4,4.8),1.1+.4*ease(t,4.4,4.8),.12)*s.cobra.scale;s.cobra.hood.CFrame=s.cobra.head.CFrame*CFrame.new(0,0,.45*s.cobra.scale)end
  -- Fissures puis éclatement.
  for _,c in ipairs(s.cracks)do
   local u=ease(t,c.at,c.at+.25);local p=victimPos+(basis:VectorToWorldSpace(c.dir))*r*1.01
   c.part.CFrame=aim(p,p+basis:VectorToWorldSpace(c.dir),basis.YVector)*CFrame.Angles(0,0,c.tilt)*CFrame.new(0,0,0)*CFrame.Angles(0,math.pi/2,0)
   c.part.Transparency=shattered and 1 or 1-u
  end
  local flight=math.max(0,t-6.8)
  for _,d in ipairs(s.debris)do
   local off=d.offset+d.dir*(r*flight*4)+Vector3.new(0,-r*.9*flight*flight,0)
   d.part.CFrame=CFrame.new(victimPos+basis:VectorToWorldSpace(off))*CFrame.Angles(flight*d.spin.X,flight*d.spin.Y,flight*d.spin.Z)
   d.part.Transparency=shattered and ease(t,7.8,8.9)or 1
  end
  if shattered and not s.burst then s.burst=true;burst(victimPos,VENOM,low and 30 or 60,r*.25)end
  s.title.TextTransparency=1-ease(t,7.2,7.6)*(1-ease(t,9,C.FinaleDuration))
  local bars=1-ease(t,0,.45)*(1-ease(t,C.FinaleDuration-.8,C.FinaleDuration));s.top.BackgroundTransparency=bars;s.bottom.BackgroundTransparency=bars
  for _,cue in ipairs({{0,'MaxHiss'},{.6,'MaxSpit'},{1.6,'MaxBounce'},{2.4,'MaxCoil'},{4.4,'MaxHiss'},{5.2,'MaxSqueeze'},{5.9,'MaxCrack'},{6.8,'MaxShatter'},{7.4,'MaxSting'}})do
   local key=tostring(cue[1])..cue[2];if t>=cue[1]and not s.cues[key]then s.cues[key]=true;if t-cue[1]<.35 then sound(cue[2],victimPos,false,true)end end
  end
  -- Caméra : plan large (héros + mur + victime), gros plan sur l'étreinte, puis retour sur VeniCrax.
  local wide=1-ease(t,2.2,2.9);local hero=closing
  local focus=(victimPos:Lerp((heroPos+wallHit)*.5,wide*.6)):Lerp(heroPos,hero)+basis.YVector*r*.2
  local half=r*(1.9+3.6*wide)*(1-.25*hero)
  local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local fov=42
  local distance=math.max(half,half*1.3/math.max(.2,aspect))/math.tan(math.rad(fov*.5))
  local orbit=(1-wide)*(1-hero)*math.sin(t*.6)*.35
  local offset=basis:VectorToWorldSpace(Vector3.new(math.sin(orbit)*distance,r*.25,-math.cos(orbit)*distance))
  local kick=t>=6.8 and math.max(0,1-(t-6.8)/.25)*r*.05 or 0
  local wanted=aim(focus+offset,focus,basis.YVector)*CFrame.new(math.sin(t*83)*kick,math.cos(t*71)*kick,0)
  if hero>0 then s.hero:PivotTo(CFrame.new(heroPos):Lerp(aim(heroPos,wanted.Position,basis.YVector),hero)*heroOffset:Inverse())end
  local back=ease(t,C.FinaleDuration-.8,C.FinaleDuration);s.backdrop.Transparency=back;s.wall.Transparency=back
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=fov+(s.saved.FieldOfView-fov)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
 end)
end
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do state:GetAttributeChangedSignal(key):Connect(function()task.defer(beginScene)end)end
state:GetAttributeChangedSignal('Phase'):Connect(function()if state:GetAttribute('Phase')=='Fighting'then stopScene()end end)
task.defer(beginScene)
