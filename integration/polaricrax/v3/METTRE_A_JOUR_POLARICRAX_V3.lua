-- POLARICRAX V3 : appliquer dans le jeu ouvert, Play arrêté.
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

local motion=assert(resolve('ServerScriptService.ArenaMovement'));local motionSource=read(motion)
for _,hook in ipairs({'PolariV1.Pump(deltaTime,fighters)','PolariV1.Step(','PolariV1.WallContact('})do assert(motionSource:find(hook,1,true),'Raccordement moteur Polari absent : '..hook)end
local modules={{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariAudio]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxPolariConfig'));local Map=require(RS:WaitForChild('CraxPolariAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false;local missingReported=false
local mix={Tick=.48,MaxLastTick=.75,AttractLoop=.65,Charge=.85,Impact=1,Invert=1,MaxClap=1,MaxTrophy=.85}
local function atlasId()
 local user=RS:FindFirstChild('CraxPolariUserAssets');local id=user and user:GetAttribute('AudioAtlas')
 if type(id)=='string'and id:match('^rbxassetid://%d+$')then return id end
 return C.AtlasId
end
local function remove(i)local e=entries[i];e.sound:Stop();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale,localMix)
 local clip=Map.Segments[name];if not clip then return end
 local id=atlasId()
 if id==''then if not missingReported then missingReported=true;warn('PolariCrax : importer le nouvel atlas WAV et configurer CraxPolariUserAssets.AudioAtlas pour activer les sons.')end;return end
 if #entries>=28 then remove(1)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='PolariAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.Name='Polari_'..name;s.SoundId=id;s.Volume=C.Volume*(mix[name]or 1)*(finale and .95 or 1);s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop

 -- Seated arena presentation uses a camera mix; spectators keep spatial attenuation.
 s.Parent=localMix and root or p
 if preloaded~=id then preloaded=id;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({s})end)end)end
 local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('PolariCrax : mauvais atlas audio ; lancer DIAGNOSTIC_AUDIO_CLIENT.lua');e.born=-math.huge
    else e.sound.TimePosition=e.clip.Start;e.sound:Play();e.started=true end
   end
   if not e.anchor.Parent or os.clock()-e.born>15 or(e.sound.IsLoaded and not e.sound.Looped and e.sound.TimePosition>=e.clip.End-.001)or(e.started and e.sound.IsLoaded and os.clock()-e.born>.2 and not e.sound.IsPlaying and not e.sound.IsPaused)then remove(i)end
  end
  if #entries==0 and connection then connection:Disconnect();connection=nil end
 end)end
 return entry
end
function M.Move(entry,position)if entry and entry.anchor.Parent then entry.anchor.Position=position end end
function M.Stop(entry)if not entry then return end;for i=#entries,1,-1 do if entries[i]==entry then remove(i)end end end
function M.Pause(entry,paused)if entry and entry.anchor.Parent then entry.paused=paused;if entry.started then if paused and entry.sound.IsPlaying then entry.sound:Pause()elseif not paused and entry.sound.IsPaused then entry.sound:Resume()end end end end
function M.Clear()for i=#entries,1,-1 do remove(i)end;if connection then connection:Disconnect();connection=nil end;if root then root:Destroy();root=nil end end
return M
]====]},{[ [====[path]====] ]=[====[StarterPlayer.StarterPlayerScripts.CraxPolariClient]====],[ [====[className]====] ]=[====[LocalScript]====],[ [====[source]====] ]=[====[-- Presentation only: all targets, axes, damage, pause and repulsion decisions are server-owned.
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
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariConfig]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Values explicitly requested by the creator. Remaining controls are documented prototypes.
local C={Id='Crax_Polari',AbilityId='PolariImpulse',Health=110,Melee=7,
 ImpulseWait={6,9},Charge=.4,ImpulseDamage=10,AttractDuration=2,AttractDamage=8,InvertDamage=15,InvertCharge=1.5,InvertDuration=3,StopDuration=1.2,ShardDamage=6,MaxHits=3,ShardCount=5,
 -- Prototype balancing/visual timings, not implicit creator approval.
 AttractWait={10,14},InvertWait={12,16},StopFirstWait={5,7},StopWait={22,28},InvertWarning=.25,DodgeWindow=.35,TickWarning=.6,
 ProjectileSpeed=38,ProjectileLife=2.5,ProjectileRadius=.38,DeflectAngle=math.rad(13),AttractTurnRate=1.2,RepelAngle=math.rad(28),RepelSpeedScale=1,
 FanRadius=10,Volume=.18,Quality='Auto',FinaleDuration=9,MaxTitle='L’ULTIME SECONDE',TrophyId='PolariFinalSecond',AtlasId='',Textures={Flare='',Spark='',Smoke=''},Icons={Attract='',Invert='',Stop='',Max=''}}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxPolariUserAssets')
if user then
 local id=user:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Textures)do local id=user:GetAttribute('Texture_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Textures[k]=id end end
 for k in pairs(C.Icons)do local id=user:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
]====]},{[ [====[path]====] ]=[====[ReplicatedStorage.CraxPolariVFX]====],[ [====[className]====] ]=[====[ModuleScript]====],[ [====[source]====] ]=[====[-- Layered magnetic plasma. Built-in particle textures; all geometry is client-only and bounded.
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
  b.a.Position=Vector3.new(math.cos(a)*2.8,math.sin(a)*2.8,.3)
  b.b.Position=Vector3.new(math.cos(a+.9)*3.4,math.sin(a+.9)*3.4,-.3)
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
]====]}}
local wraps={}
for _,m in ipairs(modules)do
 local o=assert(resolve(m.path),'Source Polari requise manquante : '..m.path..'. Aucun fichier modifié.')
 local entry=assert(indexed[m.path],'Source Polari non sauvegardée : '..m.path..'. Aucun fichier modifié.')
 assert(o:IsA(m.className),'Classe Polari inattendue : '..m.path..'. Aucun fichier modifié.')
 assert(read(o)==entry.Installed.Value,'Source éditée depuis installation : '..m.path..'. Aucun fichier modifié.')
end
assert((backup:GetAttribute('PolariRevision')or 1)>=2,'Appliquer la mise à jour V2 avant les VFX V3. Aucun fichier modifié.')
local revision=3
if backup:GetAttribute('PolariRevision')==revision then
 for _,m in ipairs(modules)do assert(read(assert(resolve(m.path)))==m.source,'Version V3 différente : '..m.path)end
 print('PolariCrax V3 déjà installé et vérifié');return
end
assert(not SS:FindFirstChild('PolariCrax_Update_V3_Safety'),'Mise à jour précédente à inspecter : PolariCrax_Update_V3_Safety')
local plan={}
for _,m in ipairs(modules)do
 local o=resolve(m.path);local entry=indexed[m.path]
 if o then assert(o:IsA(m.className)and entry,'Nom utilisé hors sauvegarde : '..m.path)
 else assert(m.path=='ReplicatedStorage.CraxPolariVFX'and not entry,'Source Polari requise manquante : '..m.path)end
 plan[#plan+1]={path=m.path,object=o,className=m.className,before=o and read(o)or'',after=m.source,entry=entry}
end
for _,item in ipairs(wraps)do local o=assert(resolve(item.path));assert(indexed[item.path],'Source non sauvegardée : '..item.path);local before=read(o)
 plan[#plan+1]={path=item.path,object=o,before=before,after='-- PolariCraxV3\nlocal data=(function()\n'..before..'\nend)()\n'..item.addition..'\nreturn data\n',entry=indexed[item.path]}
end
local safety=Instance.new('Folder');safety.Name='PolariCrax_Update_V3_Safety';safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true);safety.Parent=SS
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
print('PolariCrax V3 installé : VFX plasma, murs énergétiques, horlogerie et mixage audio. Mécaniques V2 préservées. Enregistrer puis NOUVEAU Play pour recharger les modules.')
end
