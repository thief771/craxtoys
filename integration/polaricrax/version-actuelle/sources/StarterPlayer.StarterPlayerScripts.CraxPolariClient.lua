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
local function line(parent,color,width)
 return make('Part',{Name='PolariAxis',Size=Vector3.one*.05,Color=color,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Transparency=.25},parent)
end
local function segment(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.001,d.Magnitude));p.CFrame=d.Magnitude>1e-7 and CFrame.lookAt((a+b)*.5,b)or CFrame.new(a)
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
local function clone(m,parent)
 local a=m.Archivable;m.Archivable=true;local copy=m:Clone();m.Archivable=a
 for _,o in ipairs(copy:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end end;copy.Parent=parent;return copy
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
 clearCombat();Audio.Clear();local s={folder=make('Folder',{Name='PolariFinale'},root),hidden={},saved={},camera=cam,start=state:GetAttribute('RoundVictoryStartedAt'),previous=player:GetAttribute('PolariCameraOwner'),cues={}};seen=tostring(token)..':'..round
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 s.field=VFX.Field(s.folder,'Finale');s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder);s.shards={};for i=1,5 do s.shards[i]=Assets.Model('Shard',s.folder);s.shards[i]:ScaleTo(1.7)end;s.dial=Assets.Model('Trophy',s.folder);s.dial:ScaleTo(5)
 s.rays={};for i=1,5 do s.rays[i]=line(s.folder,PURPLE,.08)end
 s.gui=make('ScreenGui',{Name='PolariFinaleTrophy',IgnoreGuiInset=true,ResetOnSpawn=false},player:WaitForChild('PlayerGui'));s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.13),Position=UDim2.fromScale(.05,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=GOLD,TextStrokeTransparency=.15,Font=Enum.Font.FredokaOne,TextScaled=true,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 duck(s,winner,loser);scene=s;player:SetAttribute('PolariCameraOwner',seen)
 local logical=loser:GetPivot().Position;local center=frame()*CFrame.new(logical);local wr=winner:GetPivot().Rotation;local lr=loser:GetPivot().Rotation
 local left=workspace:FindFirstChild('Arenaleft');local right=workspace:FindFirstChild('ArenaRight');local top=workspace:FindFirstChild('ArenaTop');local bottom=workspace:FindFirstChild('Arenabottom');local starts={Vector3.new(left.Position.X,logical.Y,logical.Z),Vector3.new(right.Position.X,logical.Y,logical.Z),Vector3.new(logical.X,top.Position.Y,logical.Z),Vector3.new(logical.X,bottom.Position.Y,logical.Z),Vector3.new(left.Position.X,math.min(top.Position.Y,logical.Y+7),logical.Z)}
 Run:BindToRenderStep('PolariFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  VFX.AnimateField(s.field,center,t,t>=4.2 and .12 or 1);
  if t>=5.2 and not s.collapse then s.collapse=true;shock(center.Position,GOLD,2.3)end
  s.hero:PivotTo(center*CFrame.new(-10,0,0)*wr);s.victim:PivotTo(center*lr);local vanish=math.clamp((t-5.2)/.45,0,1)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=vanish end end
  for i,m in ipairs(s.shards)do
   local angle=(i-1)*math.pi*2/5+math.pi/2;local arranged=(center*CFrame.new(math.cos(angle)*7,math.sin(angle)*7,0)).Position
   local from=(frame()*CFrame.new(starts[i])).Position;local assemble=math.clamp((t-1.2)/2,0,1);assemble=assemble*assemble*(3-2*assemble);local p=from:Lerp(arranged,assemble);local collapse=math.clamp((t-4.85)/.35,0,1);p=p:Lerp(center.Position,collapse)
   if t>5.6 then p=(center*CFrame.new(math.cos(angle)*5,math.sin(angle)*5,0)).Position end
   m:PivotTo(CFrame.lookAt(p,center.Position)*CFrame.Angles(-math.pi/2,0,0));s.rays[i].Color=t>=4.8 and RED or PURPLE;segment(s.rays[i],p,center.Position,.04);s.rays[i].Transparency=t>=5.6 and .85 or .35
  end
  s.dial:PivotTo(center*CFrame.new(0,t>=5.6 and 0 or 3,-1)*CFrame.Angles(math.pi/2,0,math.floor(math.min(t,4.2)*6)*math.pi/3));s.title.Visible=t>=5.6
  for _,cue in ipairs({{0,'MaxCut'},{.4,'MaxOrbit'},{1.2,'MaxFragments'},{4.2,'MaxLastTick'},{5.2,'MaxClap'},{5.6,'MaxTrophy'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;sound(cue[2],winner,false,true)end end
  local focus=(center*CFrame.new(-3,1,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(32,25/(2*math.tan(math.rad(23))*math.max(.35,aspect)));local angle=t<1.2 and(.75-t*.62)or 0;local offset=Vector3.new(math.sin(angle)*distance,3,-math.cos(angle)*distance);local wanted=CFrame.lookAt(focus+frame():VectorToWorldSpace(offset),focus,frame().UpVector);local back=math.clamp((t-(C.FinaleDuration-.8))/.8,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=46+(s.saved.FieldOfView-46)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
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
  for i,p in ipairs(d.Fan)do local part=VFX.Projectile(r.folder,true);part:ScaleTo(1.3);for _,p in ipairs(part:GetDescendants())do if p:IsA('BasePart')then p.Material=Enum.Material.Neon;p.Color=GOLD end end;local start=(frame()*CFrame.new(p.Position)).Position;local direction=frame():VectorToWorldSpace(p.Direction);part:PivotTo(CFrame.lookAt(start,start+direction)*CFrame.Angles(-math.pi/2,0,0));local axis=line(r.folder,PURPLE,.045);segment(axis,(frame()*CFrame.new(p.Position)).Position,(frame()*CFrame.new(p.Position+p.Direction*(C.FanRadius+5))).Position,.045);r.fan[i]={model=part,axis=axis}end;shock(position(m)or Vector3.zero,GOLD,1.5);sound('Stop',m)
 elseif k=='Resume'then local r=casts[m];if r then r.frozen=false;r.released=true;if r.freeze then r.freeze:Destroy();r.freeze=nil end end;shock(position(m)or Vector3.zero,CYAN,1.2);sound('Resume',m)
 elseif k=='FanFire'then clearCast(m);sound('FanFire',m)
 elseif k=='Shot'then if shots[d.Id]then shots[d.Id].model:Destroy()end;local model=VFX.Projectile(root,d.Fan);shots[d.Id]={model=model,position=d.Position,from=d.Position,at=os.clock(),direction=d.Direction,owner=m,born=Clock.Time(m)};if not d.Fan then sound('Shot',m)end
 elseif k=='ShotState'then if shots[d.Id]then local s=shots[d.Id];s.from=s.display or s.position;s.position=d.Position;s.at=os.clock()end
 elseif k=='ShotEnd'then if shots[d.Id]then shots[d.Id].model:Destroy();shots[d.Id]=nil end
 elseif k=='Impact'then burst((frame()*CFrame.new(d.Position)).Position,d.Fan and GOLD or PURPLE,10);sound(d.Fan and'FanImpact'or'Impact',m)end
end)
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0
 for id,s in pairs(shots)do if not s.owner.Parent or Clock.Time(s.owner)-s.born>C.ProjectileLife+.5 then s.model:Destroy();shots[id]=nil else s.display=s.from:Lerp(s.position,math.clamp((os.clock()-s.at)/.05,0,1));local p=(frame()*CFrame.new(s.display)).Position;local v=frame():VectorToWorldSpace(s.direction);s.model:PivotTo(CFrame.lookAt(p,p+v)*CFrame.Angles(0,0,os.clock()*10))end end
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
