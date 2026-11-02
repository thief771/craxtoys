-- Presentation only: no FireServer, client-selected targets, HP writes or gameplay physics.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local SoundService=game:GetService('SoundService');local Content=game:GetService('ContentProvider')
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxSuperFX')
local C=require(RS:WaitForChild('CraxSuperConfig'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local RED=Color3.fromRGB(244,38,41);local BLUE=Color3.fromRGB(40,156,255);local ICE=Color3.fromRGB(154,235,255);local GREEN=Color3.fromRGB(78,239,82);local WHITE=Color3.fromRGB(247,250,240)
local root=Instance.new('Folder');root.Name='SuperCrax_LocalPresentation';root.Parent=workspace
local actors={};local frozen={};local crystals={};local bursts={};local deaths={};local audio={};local connections={};local scene;local seenFinale;local now=0;local accumulator=0
local random=Random.new()
local function connect(signal,fn)local c=signal:Connect(fn);connections[#connections+1]=c;return c end
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function head(m)local p=m and m:FindFirstChild('Head',true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local config=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local f=config and id and config:FindFirstChild('Frame_'..id)
 return f and f.Value or CFrame.identity
end
local function part(parent,size,color,cf,alpha)
 return make('Part',{Size=size,Color=color,CFrame=cf or CFrame.identity,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic},parent)
end
local function location(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,pos,loop,group,offset)
 local id=C.Audio[name];if type(id)~='string'or not id:match('^rbxassetid://%d+$')then return end
 local anchor=part(root,Vector3.one*.05,WHITE,CFrame.new(pos),1)
 local s=make('Sound',{SoundId=id,Volume=group=='Finale'and C.FinaleVolume or C.CombatVolume,Looped=loop==true,RollOffMinDistance=C.RollOffMin,RollOffMaxDistance=C.RollOffMax},anchor)
 local mix=SoundService:FindFirstChild('CraxMusicControl');if group=='Finale'and mix and mix:IsA('SoundGroup')then s.SoundGroup=mix end
 if offset then s.TimePosition=offset end;s:Play()
 local entry={sound=s,anchor=anchor,born=os.clock(),group=group,loop=loop};audio[#audio+1]=entry
 return entry
end
local function stopAudio(entry)if entry then entry.sound:Stop();entry.anchor:Destroy();entry.dead=true end end
local function beam(parent,width,color)
 local a=part(parent,Vector3.one*.05,WHITE,nil,1);local b=part(parent,Vector3.one*.05,WHITE,nil,1)
 local at0=make('Attachment',{},a);local at1=make('Attachment',{},b)
 local layers={}
 for i,factor in ipairs({3.1,1,.28})do
  layers[i]=make('Beam',{Attachment0=at0,Attachment1=at1,Width0=width*factor,Width1=width*factor,FaceCamera=true,Color=ColorSequence.new(i==3 and WHITE or color),Transparency=NumberSequence.new(i==1 and .82 or(i==2 and .18 or .03)),LightEmission=.9,LightInfluence=0,Segments=1},a)
 end
 return {a=a,b=b,layers=layers}
end
local function setBeam(line,a,b,visible)
 line.a.Position=a;line.b.Position=b;for _,v in ipairs(line.layers)do v.Enabled=visible~=false end
end
local function destroyBeam(line)line.a:Destroy();line.b:Destroy()end
local function burst(pos,color,count,lifetime,inward)
 local items={};count=low and math.min(count,12)or count
 for i=1,count do local p=part(root,Vector3.one*random:NextNumber(.10,.30),i%3==0 and WHITE or color,CFrame.new(pos));items[i]={part=p,offset=Vector3.new(random:NextNumber(-1,1),random:NextNumber(-1,1),random:NextNumber(-.5,.5)).Unit*random:NextNumber(1,3)}end
 bursts[#bursts+1]={born=os.clock(),duration=lifetime,items=items,origin=pos,inward=inward}
end
local function crystal(parent,scale)
 local model=make('Model',{},parent)
 local core=part(model,Vector3.new(scale*.80,scale*1.60,scale*.85),GREEN,CFrame.identity,.15);core.Material=Enum.Material.Glass
 for i=1,6 do local a=i*math.pi/3;local p=make('WedgePart',{Size=Vector3.new(scale*.66,scale,scale*.75),Color=i%2==0 and GREEN or Color3.fromRGB(139,255,157),Material=Enum.Material.Glass,Transparency=.23,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,CFrame=CFrame.new(math.cos(a)*scale*.35,0,math.sin(a)*scale*.35)*CFrame.Angles(0,-a,math.rad(14))},model)end
 if not low then make('PointLight',{Color=GREEN,Brightness=.65,Range=scale*8,Shadows=false},core)end
 return model
end
local function shell(m,parent)
 local h=head(m);if not h then return end
 local model=make('Model',{},parent);local ball=part(model,h.Size*1.08,ICE,frame()*h.CFrame,.74);ball.Shape=Enum.PartType.Ball;ball.Material=Enum.Material.Ice
 local cracks={}
 for i=1,(low and 5 or 9)do
  local a=i*2.39996;local p=part(model,Vector3.new(.035,h.Size.Y*.3,.035),i%3==0 and WHITE or ICE,CFrame.identity,.3);cracks[i]={part=p,angle=a}
 end
 return {model=model,ball=ball,cracks=cracks,source=m}
end
local function updateShell(s,cf,size,alpha)
 s.ball.CFrame=cf;s.ball.Size=size*1.08;if alpha then s.ball.Transparency=alpha end
 for _,v in ipairs(s.cracks)do v.part.CFrame=cf*CFrame.new(math.cos(v.angle)*size.X*.28,math.sin(v.angle)*size.Y*.28,-size.Z*.48)*CFrame.Angles(0,0,v.angle)end
end
local function restoreSteel(a)
 if not a.materials then return end
 for p,s in pairs(a.materials)do if p.Parent then
  if p.Material==Enum.Material.Metal then p.Material=s.material end
  if p.Color==s.applied then p.Color=s.color end
  if p.Reflectance==.22 then p.Reflectance=s.reflectance end
 end end;a.materials=nil
end
local function steel(a)
 a.materials={}
 for _,p in ipairs(a.owner:GetDescendants())do if p:IsA('BasePart')then
  local hair=p.Name:find('Hair',1,true)or p.Name:find('Curl',1,true)
  local color=hair and Color3.fromRGB(45,61,72)or Color3.fromRGB(177,205,223)
  a.materials[p]={material=p.Material,color=p.Color,reflectance=p.Reflectance,applied=p.Color,target=color};p.Material=Enum.Material.Metal;p.Reflectance=.22
 end end
end
local function clearActor(m)
 local a=actors[m];if not a then return end
 restoreSteel(a);stopAudio(a.loop)
 for _,line in ipairs(a.beams or{})do destroyBeam(line)end
 for _,p in ipairs(a.trail or{})do p.part:Destroy()end
 for _,p in ipairs(a.flow or{})do p:Destroy()end
 actors[m]=nil
end
local function clearCombat()
 for m in pairs(actors)do clearActor(m)end
 for m,s in pairs(frozen)do s.model:Destroy();frozen[m]=nil end
 for m,k in pairs(crystals)do k.model:Destroy();crystals[m]=nil end
 for _,s in ipairs(audio)do if s.loop and s.group~='Finale'then stopAudio(s)end end
end
local function clone(m,cf,parent)
 local arch=m.Archivable;m.Archivable=true;local ok,copy=pcall(function()return m:Clone()end);m.Archivable=arch
 if not ok or not copy then return end
 for _,o in ipairs(copy:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')or o:IsA('BillboardGui')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 copy.Parent=parent;copy:PivotTo(cf);return copy
end
local function clearDeaths()
 for m,d in pairs(deaths)do
  for p,v in pairs(d.hidden)do if p.Parent then p.LocalTransparencyModifier=v end end
  d.copy:Destroy();deaths[m]=nil
 end
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('SuperCraxFinaleCamera')
 for p,value in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=value else p.Enabled=value end end end
 if workspace.CurrentCamera==s.camera then s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus end
 s.folder:Destroy();if s.color then s.color:Destroy()end
 for _,a in ipairs(audio)do if a.group=='Finale'then stopAudio(a)end end
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='SuperFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 then return end
 if state:GetAttribute('SuperVictoryCrax')~=C.Id or (state:GetAttribute('SuperVictoryLevel')or 0)<4 or state:GetAttribute('SuperVictoryMatch')~=state:GetAttribute('CraxMatchToken')then return end
 local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken');if seenFinale==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera
 if not loser or not head(loser)or not head(winner)or not cam then return end
 local projection=frame()
 if player:GetAttribute('ArenaSeat')==nil then local ch=player.Character;local hr=ch and ch:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-location(winner)).Magnitude>180 then return end end
 seenFinale=tostring(token)..':'..round;clearDeaths()
 local s={folder=make('Folder',{Name='SuperFinale'},root),winner=winner,loser=loser,round=round,match=token,camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,hidden={},cues={},start=state:GetAttribute('RoundVictoryStartedAt'),projection=projection}
 local center=loser:GetPivot().Position;s.center=center;s.winPosition=center+Vector3.new(-11,2.1,0);s.winRotation=winner:GetPivot().Rotation
 s.victim=clone(loser,projection*CFrame.new(center)*loser:GetPivot().Rotation,s.folder)
 s.hero=clone(winner,projection*CFrame.new(s.winPosition)*s.winRotation,s.folder)
 if not s.victim or not s.hero then s.folder:Destroy();return end
 s.ice=shell(loser,s.folder)
 s.lines={beam(s.folder,.20,RED),beam(s.folder,.20,RED)}
 for _,line in ipairs(s.lines)do for _,layer in ipairs(line.layers)do layer.Enabled=false end end
 s.fragments={};s.wind={}
 for i=1,(low and 12 or 24)do s.wind[i]=part(s.folder,Vector3.one*.16,ICE,nil,1)end
 local visible={};for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.8 then visible[#visible+1]=p end end
 if #visible==0 then s.folder:Destroy();return end
 for i=1,(low and 32 or 84)do
  local source=visible[(i-1)%#visible+1];local off=Vector3.new(random:NextNumber(-.45,.45)*source.Size.X,random:NextNumber(-.45,.45)*source.Size.Y,random:NextNumber(-.45,.45)*source.Size.Z)
  local origin=source.CFrame:PointToWorldSpace(off)
  local p=part(s.folder,Vector3.one*random:NextNumber(.18,.56),i%3==0 and ICE or source.Color,CFrame.new(origin),1)
  if i%3==0 then p.Material=Enum.Material.Ice end
  s.fragments[i]={part=p,origin=origin,velocity=(origin-(projection*CFrame.new(center)).Position+Vector3.new(random:NextNumber(-3,3),random:NextNumber(0,5),random:NextNumber(-2,2)))*1.5}
 end
 for _,m in ipairs({winner,loser})do for _,o in ipairs(m:GetDescendants())do
  if o:IsA('BasePart')then s.hidden[o]=o.LocalTransparencyModifier;o.LocalTransparencyModifier=1
  elseif o:IsA('BillboardGui')then s.hidden[o]=o.Enabled;o.Enabled=false end
 end end
 s.color=make('ColorCorrectionEffect',{Name='SuperFinaleLocalColor',Saturation=-.12,Contrast=.025},cam)
 scene=s
 Run:BindToRenderStep('SuperCraxFinaleCamera',Enum.RenderPriority.Last.Value+1100,function()
  if scene~=s then return end
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.ReturnEnd or state:GetAttribute('RoundId')~=s.round or state:GetAttribute('CraxMatchToken')~=s.match or state:GetAttribute('Phase')~='RoundOver'or workspace.CurrentCamera~=cam or not winner.Parent or winner:GetAttribute('CraxId')~=C.Id then stopScene();return end
  local fly=math.clamp(t/F.FlyEnd,0,1);fly=1-(1-fly)^3
  local heroPos=s.winPosition+Vector3.new(-4*(1-fly),2.2*(1-fly)+math.sin(t*2)*.18,0)
  s.hero:PivotTo(projection*CFrame.new(heroPos)*s.winRotation*CFrame.Angles(0,0,-.10))
  local victimHead=head(s.victim);local heroHead=head(s.hero)
  local freeze=math.clamp((t-F.FreezeStart)/(F.FreezeEnd-F.FreezeStart),0,1)
  updateShell(s.ice,victimHead.CFrame,victimHead.Size,1-freeze*.62)
  for _,v in ipairs(s.ice.cracks)do v.part.Transparency=1-freeze*.8 end
  for i,p in ipairs(s.wind)do
   if t>=F.FreezeStart and t<F.FreezeEnd then
    local u=(t*1.3+i/#s.wind)%1;local from=heroHead.Position+projection:VectorToWorldSpace(Vector3.new(0,-.8,-3.8));local finish=victimHead.Position
    p.Position=from:Lerp(finish,u)+projection:VectorToWorldSpace(Vector3.new(0,math.sin(i*2.4+t)*u*2,math.cos(i*2.4+t)*u*.6));p.Size=Vector3.one*(.15+u*.35);p.Transparency=.4+math.abs(u-.5)*.8
   else p.Transparency=1 end
  end
  local charge=t>=F.ChargeStart and t<F.ChargeEnd
  local redEyes=t>=F.ChargeStart and t<F.ShotEnd
  local chargeAmount=math.clamp((t-F.ChargeStart)/(F.ChargeEnd-F.ChargeStart),0,1)
  for _,v in ipairs(s.ice.cracks)do v.part.Color=redEyes and ICE:Lerp(RED,chargeAmount*.6)or ICE end
  for i,line in ipairs(s.lines)do
   local eye=s.hero:FindFirstChild(i==1 and'EyeLeft'or'EyeRight',true)
   if eye and not eye:IsA('BasePart')then eye=eye:FindFirstChildWhichIsA('BasePart',true)end
   local p=eye and eye.Position or heroHead.Position
   setBeam(line,p,victimHead.Position+projection:VectorToWorldSpace(Vector3.new((i==1 and-.5 or .5),0,-victimHead.Size.Z*.45)),t>=F.ChargeEnd and t<F.ShotEnd)
   if eye then eye.Color=redEyes and Color3.fromRGB(12,17,21):Lerp(RED,chargeAmount)or Color3.fromRGB(12,17,21);eye.Material=redEyes and Enum.Material.Neon or Enum.Material.SmoothPlastic end
  end
  if t>=F.ShotEnd then
   for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=1 end end
   for _,p in ipairs(s.ice.model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 end end
   local age=t-F.ShotEnd
   for _,f in ipairs(s.fragments)do f.part.Transparency=math.clamp((age-.6)/(F.ShatterEnd-F.ShotEnd-.6),0,1);f.part.CFrame=CFrame.new(f.origin+f.velocity*age+Vector3.new(0,-2.5*age*age,0))*CFrame.Angles(age,age*.6,age*.4)end
  end
  local cues={{0,'FinaleFly'},{F.FreezeStart,'FrostLoop'},{F.FreezeEnd-.4,'FreezeApply'},{F.ChargeStart,'FinaleLaserCharge'},{F.ChargeEnd,'FinaleLaserShot'},{F.ShotEnd,'FinaleShatter'}}
  for i,cue in ipairs(cues)do if t>=cue[1]and not s.cues[i]then s.cues[i]=true;sound(cue[2],heroHead.Position,false,'Finale',math.max(0,t-cue[1]))end end
  local middle=projection*CFrame.new(center+Vector3.new(-5,1,0));local target=middle.Position
  local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(23,20/(2*math.tan(math.rad(20))*math.max(.42,aspect)))
  if charge then target=target:Lerp(heroHead.Position,.5);distance*=.78 end
  local wanted=CFrame.lookAt(target+projection:VectorToWorldSpace(Vector3.new(0,3,-distance)),target,projection.UpVector)
  local ending=math.clamp((t-F.ShatterEnd)/(F.ReturnEnd-F.ShatterEnd),0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=40+(s.fov-40)*ending
  cam.CFrame=wanted:Lerp(s.cf,ending*ending);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner;local pos=m and location(m)
 if kind=='Clear'then clearCombat();return end
 if kind=='OwnerClear'then clearActor(m);if crystals[m]then crystals[m].model:Destroy();crystals[m]=nil end;return end
 if kind=='Start'and m and pos then
  clearActor(m);local a={owner=m,kind=d.Kind,id=d.Activation,beams={},trail={},flow={},age=0,born=os.clock()};actors[m]=a
  if d.Kind=='Dash'then steel(a);sound('SteelStart',pos);a.loop=sound('CircleDash',pos,true)
  elseif d.Kind=='Laser'then sound('LaserStart',pos);a.loop=sound('LaserLoop',pos,true);a.beams={beam(root,.18,RED),beam(root,.18,RED)}
   if player:GetAttribute('ArenaSeat')~=nil then for i,line in ipairs(a.beams)do local eye=m:FindFirstChild(i==1 and'EyeLeft'or'EyeRight',true);local origin=eye and eye:FindFirstChild('SuperLaserOriginV1');if origin then for _,layer in ipairs(line.layers)do layer.Attachment0=origin end end end end
  elseif d.Kind=='Frost'then a.guide=beam(root,.1,ICE);a.beams={a.guide};for _,layer in ipairs(a.guide.layers)do layer.Enabled=false end;sound('FrostCharge',pos);for i=1,(low and 9 or 18)do a.flow[i]=part(root,Vector3.one*.15,ICE,CFrame.new(pos),.55)end end
 elseif kind=='State'then local a=actors[m];if a and a.id==d.Activation then a.snapshot=d;a.age=d.Age end
 elseif kind=='Stop'then local a=actors[m];if a and a.id==d.Activation then
  if pos then sound(a.kind=='Dash'and'SteelEnd'or(a.kind=='Laser'and'LaserEnd'or'FreezeApply'),pos)end;clearActor(m)
 end
 elseif kind=='FrostFire'then local a=actors[m];if a and a.id==d.Activation and pos then stopAudio(a.loop);a.loop=sound('FrostLoop',pos,true)end
 elseif kind=='DashHit'and d.Target then local p=location(d.Target);if p then burst(p,WHITE,10,.3,false);sound('DashHit',p)end
 elseif kind=='Freeze'and m and pos then
  if not frozen[m]then frozen[m]=shell(m,root);sound('FreezeApply',pos)end
 elseif kind=='Thaw'or kind=='Shatter'then
  if frozen[m]then frozen[m].model:Destroy();frozen[m]=nil end
  if kind=='Shatter'and pos then burst(pos,ICE,low and 14 or 30,.7,false);sound('IceShatter',pos)end
 elseif kind=='LastStand'and pos then burst(pos,WHITE,18,.6,false);sound('LastStand',pos)
 elseif kind=='Crystal'then
  if crystals[m]then crystals[m].model:Destroy()end
  local k={model=crystal(root,d.Radius),position=d.Position,id=d.Activation};crystals[m]=k
  k.model:PivotTo(frame()*CFrame.new(d.Position));sound('KryptoniteSpawn',(frame()*CFrame.new(d.Position)).Position)
 elseif kind=='Pickup'then local k=crystals[m];if k and k.id==d.Activation then k.carrier=d.Carrier;if location(d.Carrier)then sound('KryptonitePickup',location(d.Carrier))end end
 elseif kind=='KryptoniteDeath'then
  if crystals[m]then crystals[m].model:Destroy();crystals[m]=nil end
  if pos then
   burst(pos,GREEN,24,.7,true);sound('KryptoniteDeath',pos)
   if not scene and m.Parent then
    local copy=clone(m,frame()*m:GetPivot(),root)
    if copy then
     local hidden={};for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 end end
     deaths[m]={copy=copy,hidden=hidden,start=os.clock(),base=frame()*m:GetPivot()}
    end
   end
  end
 end
end)
connect(Run.Heartbeat,function(dt)
 accumulator+=dt;if accumulator<(low and 1/20 or 1/30)then return end;accumulator=0;now=os.clock()
 for m,a in pairs(actors)do
  local pos=location(m)
  if not pos or not m.Parent or m:GetAttribute('CraxId')~=C.Id or(m:GetAttribute('Health')or 0)<=0 then clearActor(m)
  else
   if a.loop and not a.loop.dead then a.loop.anchor.Position=pos;local paused=Clock.Paused(m);if paused and a.loop.sound.IsPlaying then a.loop.sound:Pause();a.loop.paused=true elseif not paused and a.loop.paused then a.loop.paused=false;a.loop.sound:Resume()end end
   local snapshot=a.snapshot
   if a.kind=='Dash'then
    if a.materials then local u=math.clamp((now-a.born)/.10,0,1);for p,s in pairs(a.materials)do if p.Parent then s.applied=s.color:Lerp(s.target,u);p.Color=s.applied end end end
    if not a.last or(pos-a.last).Magnitude>.25 then
     local line=part(root,Vector3.new(.11,.11,math.max(.05,a.last and(pos-a.last).Magnitude or .05)),#a.trail%2==0 and RED or BLUE,nil,.5)
     line.CFrame=a.last and CFrame.lookAt((pos+a.last)*.5,pos,frame().LookVector)or CFrame.new(pos)
     a.trail[#a.trail+1]={part=line,born=now};a.last=pos
    end
    for i=#a.trail,1,-1 do local v=a.trail[i];local age=now-v.born;if age>.24 then v.part:Destroy();table.remove(a.trail,i)else v.part.Transparency=.5+age*.5/.24 end end
   elseif a.kind=='Laser'and snapshot and snapshot.Beams then
    for i,line in ipairs(a.beams)do local b=snapshot.Beams[i];if b then setBeam(line,(frame()*CFrame.new(b.From)).Position,(frame()*CFrame.new(b.To)).Position)end end
   elseif a.kind=='Frost'then
    if snapshot and snapshot.From and snapshot.To and a.guide then
     a.guide.a.Position=(frame()*CFrame.new(snapshot.From)).Position;a.guide.b.Position=(frame()*CFrame.new(snapshot.To)).Position
     for i,layer in ipairs(a.guide.layers)do layer.Enabled=i==1;if i==1 then layer.Width0=snapshot.Width;layer.Width1=snapshot.Width;layer.Transparency=NumberSequence.new(.90)end end
    end
    for i,p in ipairs(a.flow)do
     if snapshot and snapshot.From and snapshot.To then
      local start=(frame()*CFrame.new(snapshot.From)).Position;local finish=(frame()*CFrame.new(snapshot.To)).Position
      local u=(now*.75+i/#a.flow)%1;local axis=(finish-start).Unit;local side=axis:Cross(frame().LookVector).Unit
      p.Size=Vector3.one*(.17+u*.45);p.Position=start:Lerp(finish,u)+side*(math.sin(i*2.399+now)*(snapshot.Width or 8)*.43*u)
      p.Transparency=.4+math.abs(u-.5)*.8
     else p.Position=pos+frame():VectorToWorldSpace(Vector3.new(math.sin(now*3+i),math.cos(now*3+i),-4))*(1-(now*.4+i/#a.flow)%1);p.Transparency=.65 end
    end
   end
  end
 end
 for m,s in pairs(frozen)do local h=head(m);if not h or not m.Parent or(m:GetAttribute('Health')or 0)<=0 then s.model:Destroy();frozen[m]=nil else updateShell(s,frame()*h.CFrame,h.Size,.74)end end
 for owner,k in pairs(crystals)do
  if not owner or not owner.Parent or(owner:GetAttribute('Health')or 0)<=0 then k.model:Destroy();crystals[owner]=nil
  elseif k.carrier and location(k.carrier)then k.model:PivotTo(CFrame.new(location(k.carrier)+frame():VectorToWorldSpace(Vector3.new(4.7,1.1,-1)))*CFrame.Angles(0,now*.5,0))
  else k.model:PivotTo(frame()*CFrame.new(k.position+Vector3.new(0,math.sin(now*1.5)*.12,0))*CFrame.Angles(0,now*.35,0))end
 end
 for i=#bursts,1,-1 do local b=bursts[i];local u=(now-b.born)/b.duration
  if u>=1 then for _,v in ipairs(b.items)do v.part:Destroy()end;table.remove(bursts,i)
  else for _,v in ipairs(b.items)do v.part.Position=b.origin+v.offset*(b.inward and(1-u)or u);v.part.Transparency=u*u end end
 end
 for m,d in pairs(deaths)do local t=math.min(1,(now-d.start)/.7);d.copy:PivotTo(d.base*CFrame.new(0,-t*t*1.2,0)*CFrame.Angles(0,0,t*.7));for _,p in ipairs(d.copy:GetDescendants())do if p:IsA('BasePart')and p.Transparency<1 then p.Color=p.Color:Lerp(GREEN,.02*(1-t));p.Reflectance=.03 end end end
 for i=#audio,1,-1 do local a=audio[i];if a.dead or(not a.loop and a.sound.IsLoaded and now-a.born>1 and not a.sound.IsPlaying and not a.sound.IsPaused)or now-a.born>30 then if not a.dead then stopAudio(a)end;table.remove(audio,i)end end
end)
local function clearAll()
 clearCombat();stopScene();clearDeaths()
 for _,b in ipairs(bursts)do for _,v in ipairs(b.items)do v.part:Destroy()end end;table.clear(bursts)
 for _,a in ipairs(audio)do stopAudio(a)end;table.clear(audio)
end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seenFinale=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryKind','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.spawn(function()local list={};for _,id in pairs(C.Audio)do if id~=''then list[#list+1]=id end end;if #list>0 then pcall(function()Content:PreloadAsync(list)end)end end)
task.defer(beginScene)
