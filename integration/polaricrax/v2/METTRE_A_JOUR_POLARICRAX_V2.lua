-- POLARICRAX V2 : appliquer dans le jeu ouvert, Play arrêté.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SS=game:GetService('ServerStorage');local SES=game:GetService('ScriptEditorService')
local function resolve(path)local o=game;for key in path:gmatch('[^.]+')do o=o and o:FindFirstChild(key)end;return o end
local backup=assert(SS:FindFirstChild('PolariCrax_Backup_V1'),'Installer PolariCrax avant cette mise à jour')
assert(backup:GetAttribute('PolariOwned')and not backup:GetAttribute('Incomplete'),'Sauvegarde Polari incomplète ou étrangère')
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Écriture non vérifiée')end
local entries=assert(backup:FindFirstChild('Entries'));local indexed={}
for _,e in ipairs(entries:GetChildren())do local path=e:GetAttribute('Path');assert(not indexed[path],'Entrée de sauvegarde dupliquée');indexed[path]=e end
for path,entry in pairs(indexed)do local o=assert(resolve(path),'Source supprimée : '..path);assert(read(o)==entry.Installed.Value,'Source éditée depuis installation : '..path..'. Aucun fichier modifié.')end
local motion=assert(resolve('ServerScriptService.ArenaMovement'));local motionSource=read(motion)
for _,hook in ipairs({'PolariV1.Pump(deltaTime,fighters)','PolariV1.Step(','PolariV1.WallContact('})do assert(motionSource:find(hook,1,true),'Raccordement moteur Polari absent : '..hook)end
local modules={{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxPolariClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- Presentation only: all targets, axes, damage, pause and repulsion decisions are server-owned.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players');local SoundService=game:GetService('SoundService')
local VFX=require(RS:WaitForChild('CraxPolariVFX'));local C=require(RS:WaitForChild('CraxPolariConfig'));local Assets=require(RS:WaitForChild('CraxPolariAssets'));local Audio=require(RS:WaitForChild('CraxPolariAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'));local FX=RS:WaitForChild('CraxPolariFX');local state=workspace:WaitForChild('CombatState');local player=Players.LocalPlayer
local low=C.Quality=='Low'or C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled
local root=Instance.new('Folder');root.Name='PolariCrax_Local';root.Parent=workspace
local PURPLE=Color3.fromRGB(161,69,233);local RED=Color3.fromRGB(241,38,70);local GOLD=Color3.fromRGB(246,200,76);local shots={};local casts={};local walls={};local sparks={};local connections={};local scene;local seen;local accumulated=0
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(c,p,parent)local o=Instance.new(c);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local f=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=f and id and f:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,m,loop,finale)return Audio.Play(name,position(m)or Vector3.zero,loop,finale)end
local function line(parent,color,width)
 return make('Part',{Name='PolariAxis',Size=Vector3.one*.05,Color=color,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Transparency=.25},parent)
end
local function segment(p,a,b,width)
 local d=b-a;p.Size=Vector3.new(width,width,math.max(.001,d.Magnitude));p.CFrame=d.Magnitude>1e-7 and CFrame.lookAt((a+b)*.5,b)or CFrame.new(a)
end
local function burst(p,color,count)
 if not p then return end
 for i=1,(low and math.min(5,count)or count)do local a=i*2.399;local m=Assets.Model('Shard',root);m:ScaleTo(.13+(i%3)*.04);for _,part in ipairs(m:GetDescendants())do if part:IsA('BasePart')then part.Color=color end end;sparks[#sparks+1]={model=m,p=p,v=Vector3.new(math.cos(a),math.sin(a),math.sin(i))*(2+i%3),start=os.clock(),color=color}end
end
local function clearCast(m)local c=casts[m];if c then Audio.Stop(c.loop);if c.freeze then c.freeze:Destroy()end;c.folder:Destroy();casts[m]=nil end end
local function clearWall(id)local r=walls[id];if r then Audio.Stop(r.loop);r.folder:Destroy();walls[id]=nil end end
local function clearCombat()
 for _,s in pairs(shots)do s.model:Destroy()end;shots={};for m in pairs(casts)do clearCast(m)end;for id in pairs(walls)do clearWall(id)end
 for _,s in ipairs(sparks)do s.model:Destroy()end;sparks={}
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
 player:SetAttribute('PolariCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='PolariFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local round=state:GetAttribute('RoundId');local token=state:GetAttribute('CraxMatchToken')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('PolariVictoryMatch')~=token or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local h=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not h or(h.Position-position(winner)).Magnitude>180 then return end end
 clearCombat();Audio.Clear();local s={folder=make('Folder',{Name='PolariFinale'},root),hidden={},saved={},camera=cam,start=state:GetAttribute('RoundVictoryStartedAt'),previous=player:GetAttribute('PolariCameraOwner'),cues={}};seen=tostring(token)..':'..round
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 s.hero=clone(winner,s.folder);s.victim=clone(loser,s.folder);s.shards={};for i=1,5 do s.shards[i]=Assets.Model('Shard',s.folder);s.shards[i]:ScaleTo(1.7)end;s.dial=Assets.Model('Trophy',s.folder);s.dial:ScaleTo(5)
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
 if k=='Charge'then clearCast(m);local r={folder=make('Folder',{},root),kind=d.Kind,start=Clock.Time(m),tick=0};casts[m]=r
  if d.Kind=='Stop'then r.dial=Assets.Model('Dial',r.folder);r.dial:ScaleTo(3.5);VFX.Preview(r.folder,d.Target);r.hasPreview=true;sound('Tick',m)else r.shard=VFX.Projectile(r.folder,false);r.shard:ScaleTo(.65);r.spark=make('Part',{Name='PolariChargeSpark',Shape=Enum.PartType.Ball,Size=Vector3.one*.15,Color=PURPLE,Material=Enum.Material.Neon,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},r.folder);r.rays={};for i=1,3 do r.rays[i]=line(r.folder,PURPLE,.04)end;if not low then make('PointLight',{Color=PURPLE,Brightness=.6,Range=4,Shadows=false},r.spark)end;sound('Charge',m)end
 elseif k=='CastEnd'then clearCast(m)
 elseif k=='Wall'or k=='WallCharge'then
  local folder=make('Folder',{Name='PolariWall'},root);local w={folder=folder,owner=m,target=d.Target,side=d.Side,start=Clock.Time(m),parts={},lines={},charged=k=='WallCharge',chargeDuration=d.Duration};walls[d.Activation]=w
  local names={Left='Arenaleft',Right='ArenaRight',Bottom='Arenabottom',Top='ArenaTop'};local wall=workspace:FindFirstChild(names[d.Side]);if wall then
   w.position=(frame()*wall.CFrame).Position;w.panel=make('Part',{Name='PolarizedWall',Size=wall.Size+Vector3.one*.035,CFrame=frame()*wall.CFrame,Color=PURPLE,Material=Enum.Material.Neon,Transparency=.72,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},folder)
   for i=1,(low and 3 or 6)do w.lines[i]=line(folder,PURPLE,.035)end
  end;if w.charged then if w.panel then w.panel.Color=GOLD;w.panel.Transparency=.9 end;sound('Charge',m)else w.halo=VFX.Attraction(folder,d.Target);w.loop=sound('AttractLoop',m,true);sound('Attract',m)end
 elseif k=='WallArmed'then local w=walls[d.Activation];if w then w.armed=true;w.start=Clock.Time(m);if w.panel then w.panel.Color=RED;w.panel.Transparency=.35 end;for _,p in ipairs(w.lines)do p.Color=RED end end;sound('InvertWarning',m)
 elseif k=='AttractImpact'then burst((frame()*CFrame.new(d.Position)).Position,PURPLE,14);sound('Impact',d.Target)
 elseif k=='InvertWarning'then local w=walls[d.Activation];if w then w.warning=true;if w.panel then w.panel.Color=RED end;for _,p in ipairs(w.lines)do p.Color=RED end end;sound('InvertWarning',d.Target)
 elseif k=='Repel'then burst((frame()*CFrame.new(d.Position)).Position,RED,12);sound('Invert',m)
 elseif k=='WallEnd'then clearWall(d.Activation);sound('WallEnd',m)
 elseif k=='Suspend'then
  local r=casts[m];if not r then r={folder=make('Folder',{},root),kind='Stop',start=Clock.Time(m)};casts[m]=r;r.dial=Assets.Model('Dial',r.folder)end;r.fan={};r.frozen=true;r.freeze=VFX.Freeze(d.Targets or{m,d.Target});if not r.hasPreview then VFX.Preview(r.folder,d.Target);r.hasPreview=true end
  for i,p in ipairs(d.Fan)do local part=Assets.Model('Shard',r.folder);part:ScaleTo(1.6);for _,p in ipairs(part:GetDescendants())do if p:IsA('BasePart')then p.Material=Enum.Material.Neon;p.Color=GOLD end end;local start=(frame()*CFrame.new(p.Position)).Position;local direction=frame():VectorToWorldSpace(p.Direction);part:PivotTo(CFrame.lookAt(start,start+direction)*CFrame.Angles(-math.pi/2,0,0));local axis=line(r.folder,PURPLE,.045);segment(axis,(frame()*CFrame.new(p.Position)).Position,(frame()*CFrame.new(p.Position+p.Direction*(C.FanRadius+5))).Position,.045);r.fan[i]={model=part,axis=axis}end;sound('Stop',m)
 elseif k=='Resume'then local r=casts[m];if r then r.frozen=false;r.released=true;if r.freeze then r.freeze:Destroy();r.freeze=nil end end;sound('Resume',m)
 elseif k=='FanFire'then clearCast(m);sound('FanFire',m)
 elseif k=='Shot'then local model=VFX.Projectile(root,d.Fan);shots[d.Id]={model=model,position=d.Position,from=d.Position,at=os.clock(),direction=d.Direction,owner=m};if not d.Fan then sound('Shot',m)end
 elseif k=='ShotState'then if shots[d.Id]then local s=shots[d.Id];s.from=s.display or s.position;s.position=d.Position;s.at=os.clock()end
 elseif k=='ShotEnd'then if shots[d.Id]then shots[d.Id].model:Destroy();shots[d.Id]=nil end
 elseif k=='Impact'then burst((frame()*CFrame.new(d.Position)).Position,d.Fan and GOLD or PURPLE,10);sound(d.Fan and'FanImpact'or'Impact',m)end
end)
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0
 for id,s in pairs(shots)do if not s.owner.Parent then s.model:Destroy();shots[id]=nil else s.display=s.from:Lerp(s.position,math.clamp((os.clock()-s.at)/.05,0,1));local p=(frame()*CFrame.new(s.display)).Position;local v=frame():VectorToWorldSpace(s.direction);s.model:PivotTo(CFrame.lookAt(p,p+v)*CFrame.Angles(0,0,os.clock()*10))end end
 for m,r in pairs(casts)do
  local h=head(m);if not m.Parent or not h or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then clearCast(m)
  else local t=Clock.Time(m)-r.start;if r.dial then r.dial:PivotTo(frame()*h.CFrame*CFrame.new(0,5,-3.35)*CFrame.Angles(math.pi/2,0,math.floor(t*6)*math.pi/3))elseif r.shard then local p=(frame()*h.CFrame*CFrame.new(0,1,-4.5)).Position;r.shard:PivotTo(CFrame.new(p)*CFrame.Angles(math.pi/2,t*4,0));local u=math.clamp(t/C.Charge,0,1);r.spark.CFrame=CFrame.new(p);r.spark.Size=Vector3.one*(.3+.45*u*u);r.spark.Transparency=.15+.1*math.sin(t*35);for i,ray in ipairs(r.rays)do local angle=i*math.pi/3+t*2;local d=frame():VectorToWorldSpace(Vector3.new(math.cos(angle),math.sin(angle),0))*(.18+.35*u);segment(ray,p-d,p+d,.04)end end
   if r.kind=='Stop'and not r.released and not r.frozen then local tick=math.floor(t/.2);if tick>(r.tick or 0)then r.tick=tick;sound('Tick',m)end end
  end
 end
 for id,w in pairs(walls)do
  local p=w.charged and position(w.owner)or position(w.target);if not p or not w.owner.Parent then clearWall(id)elseif w.position then local t=Clock.Time(w.owner)-w.start;if w.halo then w.halo:PivotTo(CFrame.new(p)*frame().Rotation*CFrame.Angles(0,0,t*2))end;if w.charged and w.panel then w.panel.Transparency=w.armed and(.3+.12*math.sin(t*18))or(.9-.45*math.clamp(t/math.max(.01,w.chargeDuration),0,1))end;for i,ray in ipairs(w.lines)do local u=(t*.8+i/#w.lines)%1;local endpoint=w.position+frame():VectorToWorldSpace(Vector3.new((w.side=='Top'or w.side=='Bottom')and(i-2)*2 or 0,(w.side=='Left'or w.side=='Right')and(i-2)*2 or 0,0));local a=p:Lerp(endpoint,math.max(0,u-.18));segment(ray,a,p:Lerp(endpoint,u),w.charged and .10 or .075)end;Audio.Pause(w.loop,Clock.Paused(w.owner))end
 end
 for i=#sparks,1,-1 do local p=sparks[i];local t=(os.clock()-p.start)/.5;if t>=1 then p.model:Destroy();table.remove(sparks,i)else p.model:PivotTo(CFrame.new(p.p+p.v*t)*CFrame.Angles(t*6,t*4,t*3))end end
end)
local function clearAll()clearCombat();stopScene();Audio.Clear()end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()clearAll();seen=nil end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Values explicitly requested by the creator. Remaining controls are documented prototypes.
local C={Id='Crax_Polari',AbilityId='PolariImpulse',Health=110,Melee=7,
 ImpulseWait={6,9},Charge=.4,ImpulseDamage=10,AttractDuration=2,AttractDamage=8,InvertDamage=15,InvertCharge=1.5,InvertDuration=3,StopDuration=1.2,ShardDamage=6,MaxHits=3,ShardCount=5,
 -- Prototype balancing/visual timings, not implicit creator approval.
 AttractWait={10,14},InvertWait={12,16},StopFirstWait={5,7},StopWait={22,28},InvertWarning=.25,DodgeWindow=.35,TickWarning=.6,
 ProjectileSpeed=38,ProjectileLife=2.5,ProjectileRadius=.38,DeflectAngle=math.rad(13),AttractTurnRate=1.2,RepelAngle=math.rad(28),RepelSpeedScale=1,
 FanRadius=10,Volume=.18,Quality='Auto',FinaleDuration=9,MaxTitle='L’ULTIME SECONDE',TrophyId='PolariFinalSecond',AtlasId='',Icons={Attract='',Invert='',Stop='',Max=''}}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxPolariUserAssets')
if user then
 local id=user:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Icons)do local id=user:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxPolariPause]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Advance only absolute deadlines by the time deliberately omitted from arena simulation.
-- Relative timers, trajectories, velocities, captures and other lock reasons are left intact.
local SS=game:GetService('ServerScriptService');local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local state=workspace:WaitForChild('CombatState');local M={}
local keys={'PlumberStarUntil','PlumberBoostUntil','GhostDodgeUntil','GhostTeleportUntil','SpideyPoisonUntil','SpideyStingingUntil','SilkSlowUntil','FleauStunUntil','DeadlySlowUntil'}
function M.Shift(dt,fighters)
 if dt<=0 then return end
 for _,f in ipairs(Deadly.MotionTargets(fighters))do
  local m=f.model;for _,key in ipairs(keys)do local value=m:GetAttribute(key);if type(value)=='number'and value>0 then m:SetAttribute(key,value+dt)end end
  if f.sting then for _,k in ipairs({'started','expires'})do if f.sting[k]then f.sting[k]+=dt end end end
  if f.pendingSting and f.pendingSting.deadline then f.pendingSting.deadline+=dt end
 end
 for _,key in ipairs({'GhostFreezeUntil','GhostNightEnd','GhostGrandFrissonEnd'})do local value=state:GetAttribute(key);if type(value)=='number'and value>0 then state:SetAttribute(key,value+dt)end end
 for _,name in ipairs({'CraxSpideyRuntime','CraxPlumberRuntime','FleauRuntime','FleauControl','FantasticRuntime','GhostyNight','CraxDeadlyRuntime','CraxBatRuntime'})do
  local module=SS:FindFirstChild(name);if module then local runtime=require(module);assert(runtime.PolariDelay,'Adaptateur de pause manquant : '..name);runtime.PolariDelay(dt)end
 end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariRules]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[local R={}
function R.NearestWall(p,b)
 local sides={{id='Left',d=p.X-b.minX,n=Vector2.new(1,0)},{id='Right',d=b.maxX-p.X,n=Vector2.new(-1,0)},{id='Bottom',d=p.Y-b.minY,n=Vector2.new(0,1)},{id='Top',d=b.maxY-p.Y,n=Vector2.new(0,-1)}}
 local best=sides[1];for i=2,4 do if sides[i].d<best.d then best=sides[i]end end;return best.id,best.n
end
function R.WallNormal(side)
 return ({Left=Vector2.new(1,0),Right=Vector2.new(-1,0),Bottom=Vector2.new(0,1),Top=Vector2.new(0,-1)})[side]
end
function R.Turn(v,to,rate,dt)
 if v.Magnitude<1e-8 then return v end;local d=v.Unit:Lerp(to.Unit,1-math.exp(-rate*dt));return(d.Magnitude>1e-8 and d.Unit or to.Unit)*v.Magnitude
end
function R.Repel(p,n,b,speed,angle)
 local center=Vector2.new((b.minX+b.maxX)*.5,(b.minY+b.maxY)*.5);local tangent=Vector2.new(-n.Y,n.X);local sign=(center-p):Dot(tangent)>=0 and 1 or-1;return(n*math.cos(angle)+tangent*math.sin(angle)*sign).Unit*speed
end
function R.Sweep(a,b,p,r)
 local v=b-a;local d=a-p;local cc=d:Dot(d)-r*r;if cc<=0 then return 0 end;local aa=v:Dot(v);if aa<1e-12 then return end;local bb=2*d:Dot(v);local disc=bb*bb-4*aa*cc;if disc<0 then return end;local t=(-bb-math.sqrt(disc))/(2*aa);if t>=0 and t<=1 then return t end
end
function R.Fan(center,forward,radius,count)
 local axis=forward.Magnitude>1e-8 and forward.Unit or Vector2.new(1,0);local out={}
 for i=1,count do local angle=(i-(count+1)*.5)*.22;local d=Vector2.new(axis.X*math.cos(angle)-axis.Y*math.sin(angle),axis.X*math.sin(angle)+axis.Y*math.cos(angle));out[i]={position=center-d*radius,direction=d}end;return out
end
function R.TouchWall(side,p,r,b)
 return side=='Left'and p.X-r<=b.minX+.025 or side=='Right'and p.X+r>=b.maxX-.025 or side=='Bottom'and p.Y-r<=b.minY+.025 or side=='Top'and p.Y+r>=b.maxY-.025
end
return R
]====]},{[ [====[path]====] ]=[====[ServerScriptService.CraxPolariRuntime]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Authority only: uses existing motions, pause reasons, hit event and confirmed damage.
local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local R=require(RS:WaitForChild('CraxPolariRules'));local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Skills=require(SS:WaitForChild('CraxSkillResolver'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local FX=RS:WaitForChild('CraxPolariFX');local Hit=SS:WaitForChild('BiteHit');local state=workspace:WaitForChild('CombatState');local M={};local records={};local shots={};local freeze;local round;local match;local serial=0;local rng=Random.new();local motions={};local previous={};local list={};local pendingRepel={};local pendingDeflect={};local running=false
local function rand(v)return rng:NextNumber(v[1],v[2])end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m:GetAttribute('CraxId')==C.Id end
local function enabled(m)return alive(m)and own(m)and not m:GetAttribute('LuckyTricked')end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function xyz(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bounds()
 local a=workspace:FindFirstChild('Arenaleft');local b=workspace:FindFirstChild('ArenaRight');local c=workspace:FindFirstChild('Arenabottom');local d=workspace:FindFirstChild('ArenaTop');return{minX=a.Position.X+a.Size.X*.5,maxX=b.Position.X-b.Size.X*.5,minY=c.Position.Y+c.Size.Y*.5,maxY=d.Position.Y-d.Size.Y*.5}
end
local function enemy(a,b)return alive(b)and not Deadly.SameTeam(a,b)and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('DeadlyPhantom')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')end
local function target(f)local best,dist;for m,g in pairs(motions)do if enemy(f.model,m)then local d=(g.position-f.position).Magnitude;if not dist or d<dist then best=g;dist=d end end end;return best end
local function externallyHeld(m)
 for _,spec in ipairs({{'CraxBatRuntime','Hold'},{'CraxHangoverRuntime','Hold'},{'CraxBlackSpideyRuntime','Hold'},{'CraxSonGoRuntime','Hold'},{'CraxLuckyRuntime','Hold'},{'CraxSymRuntime','Held'},{'CraxSuperRuntime','Held'}})do
  local source=SS:FindFirstChild(spec[1]);if source then local runtime=require(source);if runtime[spec[2]]and runtime[spec[2]](m)then return true end end
 end
 return false
end
local function get(m)
 if not own(m)then return end;if not records[m]then records[m]={time=0,level=Skills.Resolve(m),due={Impulse=rand(C.ImpulseWait),Attract=rand(C.AttractWait),Invert=rand(C.InvertWait),Stop=rand(C.StopFirstWait)}}end;return records[m]
end
local function release()
 local s=freeze;if not s then return end;freeze=nil
 for m,snapshot in pairs(s.models)do snapshot.motion.position=snapshot.position;snapshot.motion.velocity=snapshot.velocity;if m.Parent then m:PivotTo(snapshot.pivot)end;Gate.Resume(m,s.reason);m:SetAttribute('PolariFrozen',nil)end
 state:SetAttribute('PolariTimeFrozen',nil);state:SetAttribute('PolariTimeOwner',nil);state:SetAttribute('PolariTimeRemaining',nil)
 local r=records[s.owner];if r and r.cast and r.cast.id==s.id then r.cast.phase='Dodge';r.cast.age=0 end;emit('Resume',{Owner=s.owner,Activation=s.id,Window=C.DodgeWindow})
end
function M.Frozen()return freeze~=nil end
function M.Cancel(m)
 if freeze and freeze.owner==m then release()end;records[m]=nil
 for i=#shots,1,-1 do if shots[i].owner==m then emit('ShotEnd',{Id=shots[i].id});table.remove(shots,i)end end;emit('OwnerClear',{Owner=m})
end
function M.Reset()
 running=false;release();records={};shots={};motions={};previous={};pendingRepel={};pendingDeflect={};round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')
end
function M.Begin(fighters)M.Reset();running=true;list=fighters;for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end end
-- Called before every other arena simulation. It never overwrites velocities, captures or lock snapshots.
function M.Pump(dt,fighters)
 list=fighters
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')or state:GetAttribute('Phase')~='Fighting'then if running or round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Reset()end;return false end
 for m in pairs(records)do if not enabled(m)then M.Cancel(m)end end
 if not freeze then return false end;local s=freeze
 for _,f in ipairs(fighters)do if not alive(f.model)then release();return false end end
 if not enabled(s.owner)or not alive(s.target)then M.Cancel(s.owner);return false end
 for m,snapshot in pairs(s.models)do if m.Parent then snapshot.motion.position=snapshot.position;snapshot.motion.velocity=snapshot.velocity;m:PivotTo(snapshot.pivot)end end
 local used=math.min(math.max(0,dt),s.remaining);require(SS:WaitForChild('CraxPolariPause')).Shift(used,fighters)
 s.remaining-=used;state:SetAttribute('PolariTimeRemaining',math.max(0,s.remaining))
 if s.remaining<=1e-8 then release()end
 -- Skip this whole heartbeat, including the final fraction: movement starts before the dodge window can elapse.
 return true
end
local function stop(f,r,a)
 local t=motions[a.target];if not t then r.cast=nil;return end
 local dir=t.position-f.position;a.fan=R.Fan(t.position,dir,C.FanRadius,C.ShardCount);a.phase='Frozen';a.age=0
 freeze={owner=f.model,target=t.model,id=a.id,remaining=C.StopDuration,reason='PolariTime_'..a.id,models={}}
 for _,g in ipairs(Deadly.MotionTargets(list))do freeze.models[g.model]={motion=g,position=g.position,velocity=g.velocity,pivot=g.model:GetPivot()};Gate.Pause(g.model,freeze.reason);g.model:SetAttribute('PolariFrozen',true)end
 state:SetAttribute('PolariTimeFrozen',true);state:SetAttribute('PolariTimeOwner',f.model.Name);state:SetAttribute('PolariTimeRemaining',C.StopDuration)
 local fan={};local b=bounds();for i,p in ipairs(a.fan)do p.position=Vector2.new(math.clamp(p.position.X,b.minX+C.ProjectileRadius,b.maxX-C.ProjectileRadius),math.clamp(p.position.Y,b.minY+C.ProjectileRadius,b.maxY-C.ProjectileRadius));fan[i]={Position=xyz(f,p.position),Direction=Vector3.new(p.direction.X,p.direction.Y,0)}end
 local targets={};for m in pairs(freeze.models)do targets[#targets+1]=m end
 emit('Suspend',{Owner=f.model,Target=t.model,Targets=targets,Activation=a.id,Fan=fan,Duration=C.StopDuration})
end
local function spawn(f,a,p,d,damage,volley)
 serial+=1;local shot={id=serial,activation=a.id,owner=f.model,position=p,velocity=d*C.ProjectileSpeed,damage=damage,life=0,fan=volley,hits=a.hits or{},net=0};shots[#shots+1]=shot;emit('Shot',{Owner=f.model,Id=shot.id,Activation=a.id,Position=xyz(f,p),Direction=Vector3.new(d.X,d.Y,0),Fan=volley})
end
local function start(f,r,kind)
 local t=target(f);if not t then r.due[kind]=r.time+1;return end;serial+=1;if kind=='Impulse'then r.due.Impulse=r.time+rand(C.ImpulseWait)end;r.cast={kind=kind,id=serial,target=t.model,age=0,phase=kind=='Stop'and'Tick'or'Charge'};emit('Charge',{Owner=f.model,Target=t.model,Kind=kind,Activation=serial,Duration=kind=='Stop'and C.TickWarning or C.Charge})
end
local function cast(f,r,dt)
 local a=r.cast
 if not enemy(f.model,a.target)then r.cast=nil;r.due[a.kind]=r.time+rand(a.kind=='Stop'and C.StopWait or C.ImpulseWait);emit('CastEnd',{Owner=f.model,Activation=a.id});return end
 if a.kind=='Stop'and a.phase=='Dodge'and(externallyHeld(a.target)or Gate.Paused(a.target)or Deadly.Hold(a.target)or(motions[a.target]and motions[a.target].capturedBy))then a.age=0;return end
 a.age+=dt
 if a.kind=='Impulse'and a.age+1e-8>=C.Charge then
  local t=motions[a.target];if t and enemy(f.model,t.model)then local d=t.position-f.position;d=d.Magnitude>1e-8 and d.Unit or Vector2.new(1,0);spawn(f,a,f.position+d*(f.radius+.2),d,C.ImpulseDamage,false)end;r.cast=nil;emit('CastEnd',{Owner=f.model,Activation=a.id})
 elseif a.kind=='Stop'then
  if a.phase=='Tick'and a.age+1e-8>=C.TickWarning then stop(f,r,a)
  elseif a.phase=='Dodge'and a.age+1e-8>=C.DodgeWindow then
   a.hits={};for _,p in ipairs(a.fan)do spawn(f,a,p.position,p.direction,C.ShardDamage,true)end;r.cast=nil;r.due.Stop=r.time+rand(C.StopWait);emit('FanFire',{Owner=f.model,Activation=a.id})
  end
 end
end
local function polarize(f,r)
 local t=target(f);if not t then r.due.Attract=r.time+1;return end;local side,normal=R.NearestWall(t.position,bounds());serial+=1;r.wall={target=t.model,side=side,normal=normal,age=0,id=serial};r.due.Attract=r.time+C.AttractDuration+rand(C.AttractWait);emit('Wall',{Owner=f.model,Target=t.model,Side=side,Activation=serial,Duration=C.AttractDuration})
end
local function attractHit(f,r,t)
 local w=r.wall
 if not w or w.hit or w.target~=t.model or w.age>=C.AttractDuration then return end
 if Gate.Paused(t.model)or Deadly.Hold(t.model)or externallyHeld(t.model)or t.capturedBy then return end
 w.hit=true
 Hit:Fire(f.model,t.model,C.AttractDamage,false,'PolariAttract',nil,w.id)
 emit('AttractImpact',{Owner=f.model,Target=t.model,Activation=w.id,Position=xyz(t,t.position)})
end
local function wall(f,r,dt)
 local w=r.wall;local t=motions[w.target]
 if not t or not enemy(f.model,w.target)then emit('WallEnd',{Owner=f.model,Activation=w.id});r.wall=nil;return end
 w.age+=dt
 if w.age>=C.AttractDuration then emit('WallEnd',{Owner=f.model,Activation=w.id});r.wall=nil
 elseif not Gate.Paused(t.model)and not Deadly.Hold(t.model)and not externallyHeld(t.model)and not t.capturedBy then
  t.velocity=R.Turn(t.velocity,-w.normal,C.AttractTurnRate,dt)
  if R.TouchWall(w.side,t.position,t.radius,bounds())then attractHit(f,r,t)end
 end
end
local function chargeWall(f,r)
 serial+=1;local sides={'Left','Right','Bottom','Top'};local side=sides[rng:NextInteger(1,4)]
 r.charged={side=side,normal=R.WallNormal(side),age=0,id=serial,hits={}}
 r.due.Invert=r.time+C.InvertCharge+C.InvertDuration+rand(C.InvertWait)
 emit('WallCharge',{Owner=f.model,Side=side,Activation=serial,Duration=C.InvertCharge})
end
local function invertHit(f,r,t)
 local w=r.charged
 if not w or not w.active or w.hits[t.model]or w.age>=C.InvertCharge+C.InvertDuration then return end
 if not enemy(f.model,t.model)or Gate.Paused(t.model)or Deadly.Hold(t.model)or externallyHeld(t.model)or t.capturedBy then return end
 w.hits[t.model]=true;pendingRepel[f.model]=pendingRepel[f.model]or{};pendingRepel[f.model][t.model]={target=t.model,normal=w.normal,id=w.id}
 Hit:Fire(f.model,t.model,C.InvertDamage,false,'PolariInvert',nil,w.id)
end
local function chargedWall(f,r,dt)
 local w=r.charged;w.age+=dt
 if w.age>=C.InvertCharge+C.InvertDuration then emit('WallEnd',{Owner=f.model,Activation=w.id});r.charged=nil;return end
 if not w.active and w.age+1e-8>=C.InvertCharge then w.active=true;emit('WallArmed',{Owner=f.model,Side=w.side,Activation=w.id,Duration=C.InvertDuration})end
 if w.active then for _,t in pairs(motions)do if R.TouchWall(w.side,t.position,t.radius,bounds())then invertHit(f,r,t)end end end
end
local function advanceShot(s,dt)
 local f=motions[s.owner];if not f or not enabled(s.owner)then return false end;if Gate.Paused(s.owner)then return true end
 local used=math.min(dt,C.ProjectileLife-s.life);s.life+=used;local from=s.position;local to=from+s.velocity*used;local b=bounds();local wallT=1
 for _,axis in ipairs({'X','Y'})do local lo=axis=='X'and b.minX or b.minY;local hi=axis=='X'and b.maxX or b.maxY;local v=to[axis]-from[axis];if math.abs(v)>1e-9 then local q=((v>0 and hi-C.ProjectileRadius or lo+C.ProjectileRadius)-from[axis])/v;if q>=0 then wallT=math.min(wallT,q)end end end
 local first,entry
 for m,g in pairs(motions)do if enemy(s.owner,m)and(not s.fan or(s.hits[m]or 0)<C.MaxHits)then local prior=previous[m]or g.position;local hit=R.Sweep(from-prior,to-g.position,Vector2.zero,g.radius+C.ProjectileRadius);if hit and hit<=wallT and(not entry or hit<entry)then first=g;entry=hit end end end
 if first then
  s.hits[first.model]=(s.hits[first.model]or 0)+1;if not s.fan then pendingDeflect[s.owner]={target=first.model,id=s.id}end;Hit:Fire(s.owner,first.model,s.damage,false,s.fan and'PolariFan'or'PolariImpulse',nil,s.activation);emit('Impact',{Owner=s.owner,Target=first.model,Id=s.id,Position=xyz(f,from+(to-from)*entry),Fan=s.fan})

  return false
 end
 if wallT<1 then return false end;s.position=to;s.net+=dt;if s.net>=.05 then s.net=0;emit('ShotState',{Id=s.id,Owner=s.owner,Position=xyz(f,to)})end;return s.life<C.ProjectileLife-1e-8
end
function M.MaxFanPacket(amount)return math.min(amount,C.ShardDamage)end
function M.PowerResult(owner,target,loss,kind)
 if kind=='PolariInvert'then local queue=pendingRepel[owner];local p=queue and queue[target];if queue then queue[target]=nil;if not next(queue)then pendingRepel[owner]=nil end end;local f=motions[target];if p and p.target==target and f and loss>0 and not Gate.Paused(target)and not Deadly.Hold(target)and not f.capturedBy then f.velocity=R.Repel(f.position,p.normal,bounds(),math.max(f.speed or 0,f.velocity.Magnitude)*C.RepelSpeedScale,C.RepelAngle);f.knockback=nil;emit('Repel',{Owner=owner,Target=target,Activation=p.id,Position=xyz(f,f.position)})end;return end
 if kind~='PolariImpulse'then return end;local p=pendingDeflect[owner];pendingDeflect[owner]=nil
 local f=motions[target];if p and p.target==target and f and loss>0 and not Gate.Paused(target)and not Deadly.Hold(target)and not f.capturedBy then local v=f.velocity;local angle=C.DeflectAngle*(p.id%2==0 and 1 or-1);f.velocity=Vector2.new(v.X*math.cos(angle)-v.Y*math.sin(angle),v.X*math.sin(angle)+v.Y*math.cos(angle))end
end
function M.WallContact(model,side)
 local t=motions[model];if not t then return end
 for owner,r in pairs(records)do local f=motions[owner]
  if f then
   if r.wall and r.wall.side==side then attractHit(f,r,t)end
   if r.charged and r.charged.side==side then invertHit(f,r,t)end
  end
 end
end
function M.Step(dt,fighters,active)
 if state:GetAttribute('Phase')~='Fighting'then if running then M.Reset()end;return end;if not running or round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 if not active or freeze then return end
 for _,f in ipairs(fighters)do local r=get(f.model);if r then r.level=Skills.Resolve(f.model);f.model:SetAttribute('PolariLevel',r.level)end
  if r and not enabled(f.model)then M.Cancel(f.model)
  elseif r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)and not externallyHeld(f.model)then
   r.time+=dt;if r.wall then wall(f,r,dt)end;if r.charged then chargedWall(f,r,dt)end
   if r.cast then cast(f,r,dt)elseif Silence.CanStart(f.model)then
    if r.level>=3 and r.time+1e-8>=r.due.Stop then start(f,r,'Stop')elseif r.level>=2 and not r.charged and r.time+1e-8>=r.due.Invert then chargeWall(f,r)elseif r.time+1e-8>=r.due.Impulse then start(f,r,'Impulse')elseif r.level>=1 and not r.wall and r.time+1e-8>=r.due.Attract then polarize(f,r)end
   end
  end
  if freeze then break end
 end
 if not freeze then for i=#shots,1,-1 do if not advanceShot(shots[i],dt)then emit('ShotEnd',{Id=shots[i].id});table.remove(shots,i)end end end
 for m,g in pairs(motions)do previous[m]=g.position end
end
return M
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariVFX]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Bounded procedural effects: no new uploaded texture or mesh required.
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
]====]}}
local wraps={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxSkillCatalog]====],[ [====[addition]====] ]=[====[local levels=data.Crax_Polari.Upgrades
levels[1].Description='Polarise le mur le plus proche pendant 2 s et attire la cible. Premier contact : 8 dégâts, sans répétition pendant cette activation.'
levels[2].Description='Charge un des quatre murs au hasard pendant 1,5 s. Il reste actif 3 s. Une collision ennemie inflige 15 dégâts et projette dans l’arène, une fois par cible.'
levels[3].Description='Avertissement visible, arrêt du combat 1,2 s puis fenêtre d’esquive de 0,35 s et cinq éclats. 6 dégâts par éclat, trois touches maximum par cible : 18. Première activation après 5–7 s actives.']====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxEffectsCatalog]====],[ [====[addition]====] ]=[====[data.PolariAttract.Description='Attire vers un mur pendant 2 s ; premier contact : 8 dégâts.']====]}}

local revision=2
if backup:GetAttribute('PolariRevision')==revision then
 for _,m in ipairs(modules)do assert(read(assert(resolve(m.path)))==m.source,'Version V2 différente : '..m.path)end
 print('PolariCrax V2 déjà installé et vérifié');return
end
assert(not SS:FindFirstChild('PolariCrax_Update_V2_Safety'),'Mise à jour précédente à inspecter : PolariCrax_Update_V2_Safety')
local plan={}
for _,m in ipairs(modules)do
 local o=resolve(m.path);local entry=indexed[m.path]
 if o then assert(o:IsA(m.className)and entry,'Nom utilisé hors sauvegarde : '..m.path)
 else assert(m.path=='ReplicatedStorage.CraxPolariVFX'and not entry,'Source Polari requise manquante : '..m.path)end
 plan[#plan+1]={path=m.path,object=o,className=m.className,before=o and read(o)or'',after=m.source,entry=entry}
end
for _,item in ipairs(wraps)do local o=assert(resolve(item.path));assert(indexed[item.path],'Source non sauvegardée : '..item.path);local before=read(o)
 plan[#plan+1]={path=item.path,object=o,before=before,after='-- PolariCraxV2\nlocal data=(function()\n'..before..'\nend)()\n'..item.addition..'\nreturn data\n',entry=indexed[item.path]}
end
local safety=Instance.new('Folder');safety.Name='PolariCrax_Update_V2_Safety';safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true);safety.Parent=SS
for i,item in ipairs(plan)do local e=Instance.new('Folder');e.Name=tostring(i);e:SetAttribute('Path',item.path);for name,value in pairs({Original=item.before,Installed=item.after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=safety end
local attempted={};local added={}
local ok,err=pcall(function()
 for _,item in ipairs(plan)do
  if not item.object then local parent,name=item.path:match('^(.*)%.([^.]+)$');local o=Instance.new(item.className);o.Name=name;o:SetAttribute('PolariOwned',true);o.Parent=assert(resolve(parent));item.object=o;item.created=true;added[#added+1]=o end
  attempted[#attempted+1]=item;write(item.object,item.before,item.after)
 end
 for _,item in ipairs(plan)do
  if item.entry then item.entry.Installed.Value=item.after
  else local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',item.path);for name,value in pairs({Original='',Installed=item.after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=entries;item.newEntry=e end
 end
 backup:SetAttribute('PolariRevision',revision);safety:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#attempted,1,-1 do local item=attempted[i];local restored=pcall(function()local current=read(item.object);if current==item.after then write(item.object,item.after,item.before)else assert(current==item.before,'Édition concurrente')end end);if not restored then conflicts[#conflicts+1]=item.path end end
 if #conflicts==0 then
  for _,item in ipairs(plan)do if item.entry then item.entry.Installed.Value=item.before end;if item.newEntry then item.newEntry:Destroy()end end
  for _,o in ipairs(added)do o:Destroy()end;safety:Destroy()
 else warn('Sauvegarde conservée, conflit : '..table.concat(conflicts,', '));backup:SetAttribute('Incomplete',true)end
 error('Mise à jour arrêtée : '..tostring(err))
end
print('PolariCrax V2 installé : projectile VFX, attraction 8, mur aléatoire 15, temps suspendu. Enregistrer puis NOUVEAU Play pour recharger les modules.')
end
