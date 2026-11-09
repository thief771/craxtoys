-- Presentation only: all targets, axes, damage, pause and repulsion decisions are server-owned.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players');local SoundService=game:GetService('SoundService')
local VFX=require(RS:WaitForChild('CraxPolariVFX'));local C=require(RS:WaitForChild('CraxPolariConfig'));local Assets=require(RS:WaitForChild('CraxPolariAssets'));local Audio=require(RS:WaitForChild('CraxPolariAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'));local FX=RS:WaitForChild('CraxPolariFX');local state=workspace:WaitForChild('CombatState');local player=Players.LocalPlayer
local low=C.Quality=='Low'or C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local root=Instance.new('Folder');root.Name='PolariCrax_Local';root.Parent=workspace
local CYAN=Color3.fromRGB(140,242,255);local PURPLE=Color3.fromRGB(161,69,233);local RED=Color3.fromRGB(241,38,70);local GOLD=Color3.fromRGB(246,200,76);local shots={};local casts={};local walls={};local sparks={};local connections={};local pulses={};local scene;local seen;local accumulated=0
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(c,p,parent)local o=Instance.new(c);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local f=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=f and id and f:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,m,loop,finale)return Audio.Play(name,position(m)or Vector3.zero,loop,finale,player:GetAttribute('ArenaSeat')~=nil)end
local function aim(a,b,up)
 local direction=b-a
 if direction.Magnitude<1e-6 then return CFrame.new(a)end
 up=up or Vector3.new(0,1,0)
 if up:Cross(direction).Magnitude<1e-6 then up=Vector3.new(0,0,1)end
 if up:Cross(direction).Magnitude<1e-6 then up=Vector3.new(1,0,0)end
 return CFrame.lookAt(a,b,up)
end
local function line(parent,color,width)
 return make('Part',{Name='PolariAxis',Size=Vector3.one*.05,Color=color,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Transparency=.25},parent)
end
local function segment(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.001,d.Magnitude));p.CFrame=d.Magnitude>1e-7 and aim((a+b)*.5,b)or CFrame.new(a)
end
local function shock(p,color,scale)
 if #pulses>=16 then pulses[1].effect.model:Destroy();table.remove(pulses,1)end
 pulses[#pulses+1]={effect=VFX.Impact(root,CFrame.new(p)*frame().Rotation,color,scale),born=os.clock()}
end
local function burst(p,color,count)
 if not p then return end
 shock(p,color,count>=12 and 1.3 or 1)
 local limit=low and 32 or 96
 while #sparks+count>limit do sparks[1].model:Destroy();table.remove(sparks,1)end
 for i=1,(low and math.min(5,count)or count)do local a=i*2.399;local m=Assets.Model('Shard',root);m:ScaleTo(.13+(i%3)*.04);for _,part in ipairs(m:GetDescendants())do if part:IsA('BasePart')then part.Color=color end end;sparks[#sparks+1]={model=m,p=p,v=Vector3.new(math.cos(a),math.sin(a),math.sin(i))*(2+i%3),start=os.clock(),color=color}end
end
local function clearCast(m)local c=casts[m];if c then Audio.Stop(c.loop);if c.freeze then c.freeze:Destroy()end;c.folder:Destroy();casts[m]=nil end end
local function clearWall(id)local r=walls[id];if r then Audio.Stop(r.loop);r.folder:Destroy();walls[id]=nil end end
local function clearCombat()
 for _,s in pairs(shots)do s.model:Destroy()end;shots={};for m in pairs(casts)do clearCast(m)end;for id in pairs(walls)do clearWall(id)end
 for _,s in ipairs(sparks)do s.model:Destroy()end;sparks={}
 for _,p in ipairs(pulses)do p.effect.model:Destroy()end;pulses={}
end
-- Duck only this arena's fighters/effects and the existing music group; preserve live user volume edits.
local function duck(s,winner,loser)
 s.ducked={};local group=SoundService:FindFirstChild('CraxMusicControl')
 if group and group:IsA('SoundGroup')then s.equalizer=make('EqualizerSoundEffect',{Name='PolariFinaleDuck',HighGain=-80,MidGain=-80,LowGain=-80},group)end
 local function candidate(o)
  if not o:IsA('Sound')then return end;local parent=o.Parent;local scoped=false
  while parent and parent~=workspace do if parent==winner or parent==loser or parent.Name=='SuperAudio'or parent.Name=='SymAudio'or parent.Name=='LuckyAudio'then scoped=true;break end;parent=parent.Parent end
  if not scoped or s.ducked[o]then return end
  local e={volume=o.Volume,guard=true};s.ducked[o]=e;o.Volume=0;e.guard=false
  e.connection=o:GetPropertyChangedSignal('Volume'):Connect(function()if not e.guard then e.volume=o.Volume;e.guard=true;o.Volume=0;e.guard=false end end)
 end
 for _,o in ipairs(workspace:GetDescendants())do candidate(o)end
 s.soundAdded=workspace.DescendantAdded:Connect(candidate)
end
local function unduck(s)
 if s.soundAdded then s.soundAdded:Disconnect()end
 for o,e in pairs(s.ducked or{})do e.connection:Disconnect();if o.Parent then o.Volume=e.volume end end
 if s.equalizer then s.equalizer:Destroy()end
end
local function renderRegistry()
 local object=RS:FindFirstChild('CraxRenderRegistryV82');return object and require(object)
end
local function clone(m,parent)
 local registry=renderRegistry();local snapshot=registry and registry.Snapshot and registry.Snapshot(m,parent)
 local copy=snapshot and snapshot.Model
 if not copy then local a=m.Archivable;m.Archivable=true;copy=m:Clone();m.Archivable=a end
 copy.Name=m.Name
 for _,o in ipairs(copy:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 copy.Parent=parent;return copy
end
local function ease(t,a,b)
 local u=math.clamp((t-a)/(b-a),0,1);return u*u*(3-2*u)
end
local function alpha(model,value)
 value=math.clamp(value,0,1)
 for _,o in ipairs(model:GetDescendants())do if o:IsA('BasePart')then o.LocalTransparencyModifier=value elseif o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o.Enabled=value<.95 end end
end
local function hideActor(s,model)
 local function hide(o)
  if s.hidden[o]~=nil then return end
  if o:IsA('BasePart')then s.hidden[o]=o.LocalTransparencyModifier;o.LocalTransparencyModifier=1
  elseif o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then s.hidden[o]=o.Enabled;o.Enabled=false end
 end
 for _,o in ipairs(model:GetDescendants())do hide(o)end
 local registry=renderRegistry()
 if registry and registry.Sources then for _,entry in ipairs(registry.Sources(model))do if entry.Part then hide(entry.Part)end end end
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('PolariFinaleCamera');unduck(s)
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('PolariCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();for _,p in ipairs(pulses)do p.effect.model:Destroy()end;pulses={};Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='PolariFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('PolariVictoryMatch')~=token or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local h=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not h or(h.Position-position(winner)).Magnitude>180 then return end end
 local started=state:GetAttribute('RoundVictoryStartedAt');if type(started)~='number'or workspace:GetServerTimeNow()-started>=C.FinaleDuration then return end
 clearCombat();Audio.Clear();local s={folder=make('Folder',{Name='PolariFinale'},root),hidden={},saved={},camera=cam,start=started,previous=player:GetAttribute('PolariCameraOwner'),cues={}};seen=tostring(token)..':'..round
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 -- Stage size follows the real heads rather than a fixed zoom or the physics pivot.
 local wh=head(winner);local lh=head(loser)
 if not wh or not lh then s.folder:Destroy();return end
 local radius=math.max(1,wh.Size.X*.5,wh.Size.Y*.5,lh.Size.X*.5,lh.Size.Y*.5)
 local stagePosition=lh.Position
 local left=workspace:FindFirstChild('Arenaleft');local right=workspace:FindFirstChild('ArenaRight');local top=workspace:FindFirstChild('ArenaTop');local bottom=workspace:FindFirstChild('Arenabottom')
 if left and right and top and bottom then stagePosition=Vector3.new((left.Position.X+right.Position.X)*.5,(top.Position.Y+bottom.Position.Y)*.5,lh.Position.Z)end
 local center=frame()*CFrame.new(stagePosition)*CFrame.new(0,0,-radius*6);local basis=frame().Rotation
 s.backdrop=make('Part',{Name='PolariCinemaBackdrop',Size=Vector3.new(radius*32,radius*64,.1),CFrame=center*CFrame.new(0,0,radius*5),Color=Color3.fromRGB(6,4,16),Material=Enum.Material.SmoothPlastic,Transparency=0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},s.folder)
 local wr=wh.CFrame.Rotation;local lr=lh.CFrame.Rotation
 s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder)
 -- Snapshots may have detached render parts: preserve their head-to-pivot offsets.
 local heroHead=s.hero:FindFirstChild('Head',true);local victimHead=s.victim:FindFirstChild('Head',true)
 local heroOffset=heroHead and s.hero:GetPivot():ToObjectSpace(heroHead.CFrame)or CFrame.identity
 local victimOffset=victimHead and s.victim:GetPivot():ToObjectSpace(victimHead.CFrame)or CFrame.identity
 -- Authored eyes define each face, including meshes authored on the opposite axis.
 local function actorFaceOffset(model,fallback)
  local actorHead=model:FindFirstChild('Head',true)
  local leftEye=model:FindFirstChild('EyeLeft',true);local rightEye=model:FindFirstChild('EyeRight',true)
  if leftEye and not leftEye:IsA('BasePart')then leftEye=leftEye:FindFirstChildWhichIsA('BasePart',true)end
  if rightEye and not rightEye:IsA('BasePart')then rightEye=rightEye:FindFirstChildWhichIsA('BasePart',true)end
  if actorHead and leftEye and rightEye then
   local eyes=(leftEye.Position+rightEye.Position)*.5
   if(eyes-actorHead.Position).Magnitude>.01 then return model:GetPivot():ToObjectSpace(aim(actorHead.Position,eyes,actorHead.CFrame.UpVector))end
  end
  return fallback
 end
 local faceOffset=actorFaceOffset(s.hero,heroOffset)
 local victimFaceOffset=actorFaceOffset(s.victim,victimOffset)
 local mirrorMatch=loser:GetAttribute('CraxId')==C.Id
 s.field=VFX.Field(s.folder,'Finale');s.field.model:ScaleTo(radius*.55);s.field.scale=radius*.55
 s.dial=Assets.Model('Dial',s.folder);s.dial:ScaleTo(radius*.48)
 s.shards={};s.rays={}
 for i=1,5 do s.shards[i]=VFX.Projectile(s.folder,true);s.shards[i]:ScaleTo(radius*.32);s.rays[i]=line(s.folder,GOLD,.08)end
 s.glow=make('Highlight',{Name='PolariExecutionTarget',Adornee=s.victim,FillColor=PURPLE,FillTransparency=.85,OutlineColor=GOLD,OutlineTransparency=.15},s.folder)
 -- The defeated Crax breaks into bounded, deterministic colored fragments, not a trophy.
 local palette={};for _,part in ipairs(s.victim:GetDescendants())do if part:IsA('BasePart')and part.Transparency<.95 then palette[#palette+1]=part.Color end end
 if #palette==0 then palette[1]=PURPLE end
 s.debris={}
 local count=low and 18 or 36
 for i=1,count do
  local angle=i*2.399963;local z=1-2*(i-.5)/count;local radial=math.sqrt(math.max(0,1-z*z))
  local direction=Vector3.new(math.cos(angle)*radial,math.sin(angle)*radial,z*.4)
  local part=make('WedgePart',{Name='PolariDefeatFragment',Size=Vector3.new(.18+(i%3)*.06,.25,.38)*radius,
   Color=palette[(i-1)%#palette+1],Material=i%5==0 and Enum.Material.Neon or Enum.Material.Metal,
   Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},s.folder)
  s.debris[i]={part=part,direction=direction,offset=direction*radius*(.35+(i%5)*.12),spin=Vector3.new(i%4+1,i%3+1,i%5+1)}
 end
 s.gui=make('ScreenGui',{Name='PolariExecutionCinema',IgnoreGuiInset=true,ResetOnSpawn=false},player:WaitForChild('PlayerGui'))
 s.top=make('Frame',{Name='CinemaTop',Size=UDim2.fromScale(1,.07),BackgroundColor3=Color3.fromRGB(5,4,13),BorderSizePixel=0},s.gui)
 s.bottom=make('Frame',{Name='CinemaBottom',Size=UDim2.fromScale(1,.07),Position=UDim2.fromScale(0,.93),BackgroundColor3=Color3.fromRGB(5,4,13),BorderSizePixel=0},s.gui)
 s.title=make('TextLabel',{Name='TimeLockCaption',Size=UDim2.fromScale(.8,.06),Position=UDim2.fromScale(.1,.82),BackgroundTransparency=1,Text='L’ULTIME SECONDE',TextColor3=GOLD,TextStrokeTransparency=.4,Font=Enum.Font.GothamBlack,TextScaled=true,Visible=false},s.gui)
 hideActor(s,winner);hideActor(s,loser)
 duck(s,winner,loser);scene=s;player:SetAttribute('PolariCameraOwner',seen)
 Run:BindToRenderStep('PolariFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  t=math.max(0,t)
  local lift=ease(t,.65,2.4);local lock=ease(t,3.25,4.2);local collapse=ease(t,4.85,5.2)
  local shattered=t>=5.2;local recover=ease(t,6.7,7.6)
  local victimCenter=center*CFrame.new(0,radius*.8*lift,0)
  local heroCenter=center*CFrame.new(-radius*3,radius*(.12*math.sin(math.min(t,4.2)*1.5))*(1-recover),0)
  s.hero:PivotTo(heroCenter*wr*heroOffset:Inverse())
  s.victim:PivotTo(victimCenter*lr*victimOffset:Inverse())
  alpha(s.victim,shattered and 1 or 0)
  local fieldTime=math.min(t,4.2)
  alpha(s.field.model,ease(t,5.2,5.65))
  VFX.AnimateField(s.field,victimCenter,fieldTime,1,t>=4.2)
  s.glow.FillTransparency=shattered and 1 or(.92-.45*lock);s.glow.OutlineTransparency=shattered and 1 or .15
  if shattered and not s.collapse then s.collapse=true;shock(victimCenter.Position,GOLD,math.min(3,radius*.65))end
  -- Spiral -> exact five-point lock -> a short, simultaneous convergence.
  for i,m in ipairs(s.shards)do
   local assemble=ease(t,1.1,3.2);local angle=(i-1)*math.pi*2/5+math.pi/2+(1-assemble)*2.4
   local orbit=radius*((3.2-1.35*assemble)*(1-collapse)+.28*collapse)
   local p=(victimCenter*CFrame.new(math.cos(angle)*orbit,math.sin(angle)*orbit,math.sin(angle*2)*radius*.12*(1-lock))).Position
   -- Keep a nonzero distance at impact: lookAt never receives identical points.
   m:PivotTo(aim(p,victimCenter.Position)*CFrame.Angles(0,0,t<4.2 and t*2 or 8.4))
   alpha(m,1-ease(t,1.05,1.4)+ease(t,5.2,5.55))
   for _,o in ipairs(m:GetDescendants())do if o:IsA('ParticleEmitter')then o.TimeScale=t>=4.2 and t<4.85 and 0 or 1 end end
   segment(s.rays[i],p,victimCenter.Position,radius*(.012+.035*collapse))
   s.rays[i].Transparency=.65-.45*lock
   if t<2.7 or shattered then s.rays[i].Transparency=1 end
  end
  -- No trophy: the original silhouette disappears only at the impact and scatters.
  local flight=math.max(0,t-5.2)
  for _,d in ipairs(s.debris)do
   local offset=d.offset+d.direction*(radius*flight*3.6)+Vector3.new(0,-radius*.8*flight*flight,0)
   d.part.CFrame=victimCenter*CFrame.new(offset)*CFrame.Angles(flight*d.spin.X,flight*d.spin.Y,flight*d.spin.Z)
   d.part.Transparency=shattered and ease(t,6.15,7.4)or 1
  end
  s.dial:PivotTo(victimCenter*CFrame.new(0,0,radius*.4)*CFrame.Angles(math.pi/2,0,math.floor(math.min(t,4.2)*6)*math.pi/3))
  alpha(s.dial,ease(t,4.85,5.2));s.title.Visible=t>=4.2 and t<4.85
  local bars=1-ease(t,0,.45)*(1-ease(t,8.2,9));s.top.BackgroundTransparency=bars;s.bottom.BackgroundTransparency=bars
  for _,cue in ipairs({{0,'MaxCut'},{.4,'MaxOrbit'},{1.2,'MaxFragments'},{2.7,'Tick'},{3.4,'Tick'},{4.2,'MaxLastTick'},{5.2,'MaxClap'}})do
   local key=tostring(cue[1]);if t>=cue[1]and not s.cues[key]then s.cues[key]=true;if t-cue[1]<.35 then sound(cue[2],winner,false,true)end end
  end
  -- Fit the whole execution on portrait screens; finish on the winner after fragments fade.
  local opening=ease(t,0,1.2);local closing=ease(t,6.7,7.8)
  local focus=center.Position:Lerp(heroCenter.Position,(1-opening)+closing*opening)+basis:VectorToWorldSpace(Vector3.new(0,radius*.35,0))
  local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y)
  local fov=44-6*lock+6*ease(t,5.2,5.5)-6*closing
  local halfHeight=radius*(1.5+1.8*opening)*(1-.5*closing)
  local halfWidth=radius*(1.5+2.7*opening)*(1-.55*closing)
  local distance=math.max(halfHeight,halfWidth/math.max(.2,aspect))/math.tan(math.rad(fov*.5))*1.12
  local orbit=.22*(1-opening);local offset=basis:VectorToWorldSpace(Vector3.new(math.sin(orbit)*distance,radius*.2,-math.cos(orbit)*distance))
  local impactShake=t>=5.2 and math.max(0,1-(t-5.2)/.22)*radius*.035 or 0
  local wanted=aim(focus+offset,focus,basis.UpVector)*CFrame.new(math.sin(t*83)*impactShake,math.cos(t*71)*impactShake,0)
  local heroPose=heroCenter*wr*heroOffset:Inverse()
  local faceCamera=aim(heroCenter.Position,wanted.Position,basis.UpVector)*faceOffset:Inverse()
  local back=ease(t,C.FinaleDuration-.8,C.FinaleDuration)
  if mirrorMatch then
   local view=wanted:Lerp(s.saved.CFrame,back)
   s.victim:PivotTo(aim(victimCenter.Position,view.Position,basis.UpVector)*victimFaceOffset:Inverse())
   -- A quarter-turn relative to the actual camera: the winner is always in profile.
   local side=(view.Position-heroCenter.Position):Cross(basis.UpVector)
   if side.Magnitude<1e-6 then side=basis:VectorToWorldSpace(Vector3.new(1,0,0))end
   s.hero:PivotTo(aim(heroCenter.Position,heroCenter.Position+side,basis.UpVector)*faceOffset:Inverse())
  else s.hero:PivotTo(heroPose:Lerp(faceCamera,closing))end
  s.backdrop.Transparency=back
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=fov+(s.saved.FieldOfView-fov)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)

 end)
end
connect(FX.OnClientEvent,function(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end;local m=d.Owner
 if(k=='Charge'or k=='Wall'or k=='WallCharge'or k=='Suspend'or k=='Shot')and(not m or not m.Parent)then return end
 if k=='Clear'then clearCombat();return elseif k=='OwnerClear'then clearCast(m);for id,w in pairs(walls)do if w.owner==m then clearWall(id)end end;return end
 if k=='Charge'then clearCast(m);local r={folder=make('Folder',{},root),kind=d.Kind,start=Clock.Time(m),tick=0};casts[m]=r;r.field=VFX.Field(r.folder,d.Kind=='Stop'and'Time'or'Charge')
  if d.Kind=='Stop'then r.dial=Assets.Model('Dial',r.folder);r.dial:ScaleTo(3.5);VFX.Preview(r.folder,d.Target);r.hasPreview=true;sound('Tick',m)else r.shard=VFX.Projectile(r.folder,false);r.shard:ScaleTo(.65);r.spark=make('Part',{Name='PolariChargeSpark',Shape=Enum.PartType.Ball,Size=Vector3.one*.15,Color=PURPLE,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},r.folder);r.rays={};for i=1,3 do r.rays[i]=line(r.folder,PURPLE,.04)end;if not low then make('PointLight',{Color=PURPLE,Brightness=.6,Range=4,Shadows=false},r.spark)end;sound('Charge',m)end
 elseif k=='CastEnd'then clearCast(m)
 elseif k=='Wall'or k=='WallCharge'then
  clearWall(d.Activation);local folder=make('Folder',{Name='PolariWall'},root);local w={folder=folder,owner=m,target=d.Target,side=d.Side,start=Clock.Time(m),parts={},lines={},charged=k=='WallCharge',chargeDuration=d.Duration};walls[d.Activation]=w
  local names={Left='Arenaleft',Right='ArenaRight',Bottom='Arenabottom',Top='ArenaTop'};local wall=workspace:FindFirstChild(names[d.Side]);if wall then
   w.position=(frame()*wall.CFrame).Position;w.panel=make('Part',{Name='PolarizedWall',Size=wall.Size+Vector3.one*.035,CFrame=frame()*wall.CFrame,Color=PURPLE,Material=Enum.Material.Neon,Transparency=.72,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},folder)
   w.skin=VFX.Wall(w.panel,d.Side)
   for i=1,(low and 3 or 6)do w.lines[i]=line(folder,PURPLE,.035)end
  end;if w.charged then if w.panel then w.panel.Color=GOLD;w.panel.Transparency=.9 end;sound('Charge',m)else w.halo=VFX.Attraction(folder,d.Target);w.loop=sound('AttractLoop',m,true);sound('Attract',m)end
 elseif k=='WallArmed'then local w=walls[d.Activation];if w then w.armed=true;w.start=Clock.Time(m);if w.panel then w.panel.Color=RED;w.panel.Transparency=.35 end;for _,p in ipairs(w.lines)do p.Color=RED end end;sound('InvertWarning',m)
 elseif k=='AttractImpact'then burst((frame()*CFrame.new(d.Position)).Position,PURPLE,14);sound('Impact',d.Target)
 elseif k=='InvertWarning'then local w=walls[d.Activation];if w then w.warning=true;if w.panel then w.panel.Color=RED end;for _,p in ipairs(w.lines)do p.Color=RED end end;sound('InvertWarning',d.Target)
 elseif k=='Repel'then burst((frame()*CFrame.new(d.Position)).Position,RED,12);sound('Invert',m)
 elseif k=='WallEnd'then clearWall(d.Activation);sound('WallEnd',m)
 elseif k=='Suspend'then
  local r=casts[m];if not r then r={folder=make('Folder',{},root),kind='Stop',start=Clock.Time(m)};casts[m]=r;r.dial=Assets.Model('Dial',r.folder);r.field=VFX.Field(r.folder,'Time')end;r.fan={};r.frozen=true;r.freezeVisualAt=Clock.Time(m)-r.start;r.freeze=VFX.Freeze(d.Targets or{m,d.Target});if not r.hasPreview then VFX.Preview(r.folder,d.Target);r.hasPreview=true end
  for i,p in ipairs(d.Fan)do local part=VFX.Projectile(r.folder,true);part:ScaleTo(1.3);for _,p in ipairs(part:GetDescendants())do if p:IsA('BasePart')then p.Material=Enum.Material.Neon;p.Color=GOLD end end;local start=(frame()*CFrame.new(p.Position)).Position;local direction=frame():VectorToWorldSpace(p.Direction);part:PivotTo(aim(start,start+direction)*CFrame.Angles(-math.pi/2,0,0));local axis=line(r.folder,PURPLE,.045);segment(axis,(frame()*CFrame.new(p.Position)).Position,(frame()*CFrame.new(p.Position+p.Direction*(C.FanRadius+5))).Position,.045);r.fan[i]={model=part,axis=axis}end;shock(position(m)or Vector3.zero,GOLD,1.5);sound('Stop',m)
 elseif k=='Resume'then local r=casts[m];if r then r.frozen=false;r.released=true;if r.freeze then r.freeze:Destroy();r.freeze=nil end end;shock(position(m)or Vector3.zero,CYAN,1.2);sound('Resume',m)
 elseif k=='FanFire'then clearCast(m);sound('FanFire',m)
 elseif k=='Shot'then if shots[d.Id]then shots[d.Id].model:Destroy()end;local model=VFX.Projectile(root,d.Fan);shots[d.Id]={model=model,position=d.Position,from=d.Position,at=os.clock(),direction=d.Direction,owner=m,born=Clock.Time(m)};if not d.Fan then sound('Shot',m)end
 elseif k=='ShotState'then if shots[d.Id]then local s=shots[d.Id];s.from=s.display or s.position;s.position=d.Position;s.at=os.clock()end
 elseif k=='ShotEnd'then if shots[d.Id]then shots[d.Id].model:Destroy();shots[d.Id]=nil end
 elseif k=='Impact'then burst((frame()*CFrame.new(d.Position)).Position,d.Fan and GOLD or PURPLE,10);sound(d.Fan and'FanImpact'or'Impact',m)end
end)
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0
 for id,s in pairs(shots)do if not s.owner.Parent or Clock.Time(s.owner)-s.born>C.ProjectileLife+.5 then s.model:Destroy();shots[id]=nil else s.display=s.from:Lerp(s.position,math.clamp((os.clock()-s.at)/.05,0,1));local p=(frame()*CFrame.new(s.display)).Position;local v=frame():VectorToWorldSpace(s.direction);s.model:PivotTo(aim(p,p+v)*CFrame.Angles(0,0,os.clock()*10))end end
 for m,r in pairs(casts)do
  local h=head(m);if not m.Parent or not h or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then clearCast(m)
  else local t=Clock.Time(m)-r.start;if r.field then VFX.AnimateField(r.field,frame()*h.CFrame*CFrame.new(0,0,-2),r.frozen and r.freezeVisualAt or t,1,r.frozen or Clock.Paused(m))end;if r.dial then r.dial:PivotTo(frame()*h.CFrame*CFrame.new(0,5,-3.35)*CFrame.Angles(math.pi/2,0,math.floor(t*6)*math.pi/3))elseif r.shard then local p=(frame()*h.CFrame*CFrame.new(0,1,-4.5)).Position;r.shard:PivotTo(CFrame.new(p)*CFrame.Angles(math.pi/2,t*4,0));local u=math.clamp(t/C.Charge,0,1);r.spark.CFrame=CFrame.new(p);r.spark.Size=Vector3.one*(.3+.45*u*u);r.spark.Transparency=.15+.1*math.sin(t*35);for i,ray in ipairs(r.rays)do local angle=i*math.pi/3+t*2;local d=frame():VectorToWorldSpace(Vector3.new(math.cos(angle),math.sin(angle),0))*(.18+.35*u);segment(ray,p-d,p+d,.04)end end
   if r.kind=='Stop'and not r.released and not r.frozen then local tick=math.floor(t/.2);if tick>(r.tick or 0)then r.tick=tick;sound('Tick',m)end end
  end
 end
 for id,w in pairs(walls)do
  local p=w.charged and position(w.owner)or position(w.target);if not p or not w.owner.Parent then clearWall(id)elseif w.position then local t=Clock.Time(w.owner)-w.start;if w.skin then VFX.AnimateWall(w.skin,t,w.armed,w.warning,Clock.Paused(w.owner))end;if w.halo then w.halo:PivotTo(CFrame.new(p)*frame().Rotation*CFrame.Angles(0,0,t*2))end;if w.charged and w.panel then w.panel.Transparency=w.armed and(.3+.12*math.sin(t*18))or(.9-.45*math.clamp(t/math.max(.01,w.chargeDuration),0,1))end;for i,ray in ipairs(w.lines)do local u=(t*.8+i/#w.lines)%1;local endpoint=w.position+frame():VectorToWorldSpace(Vector3.new((w.side=='Top'or w.side=='Bottom')and(i-2)*2 or 0,(w.side=='Left'or w.side=='Right')and(i-2)*2 or 0,0));local a=p:Lerp(endpoint,math.max(0,u-.18));segment(ray,a,p:Lerp(endpoint,u),w.charged and .10 or .075)end;Audio.Move(w.loop,w.position);Audio.Pause(w.loop,Clock.Paused(w.owner))end
 end
 for i=#pulses,1,-1 do local p=pulses[i];local age=os.clock()-p.born;if age>=.65 then p.effect.model:Destroy();table.remove(pulses,i)else VFX.AnimateImpact(p.effect,age)end end
 for i=#sparks,1,-1 do local p=sparks[i];local t=(os.clock()-p.start)/.5;if t>=1 then p.model:Destroy();table.remove(sparks,i)else p.model:PivotTo(CFrame.new(p.p+p.v*t)*CFrame.Angles(t*6,t*4,t*3))end end
end)
local function clearAll()clearCombat();stopScene();Audio.Clear()end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()clearAll();seen=nil end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
