-- Local presentation only. No FireServer; victims, time and health come from the server.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage')
local Run=game:GetService('RunService');local SoundService=game:GetService('SoundService')
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState')
local FX=RS:WaitForChild('CraxInvertedFX');local C=require(RS:WaitForChild('CraxInvertedConfig'))
local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local mobile=game:GetService('UserInputService').TouchEnabled
local low=C.Quality=='Low'or(C.Quality=='Auto'and mobile)
local folder=Instance.new('Folder');folder.Name='InvertedCrax_LocalFX';folder.Parent=workspace
local connections={};local effects={};local statuses={};local marks={};local sounds={};local scene;local alive=true
local random=Random.new();local elapsed=0;local poll=0;local nextSceneRound
local WHITE=Color3.fromRGB(244,242,232);local BLACK=Color3.fromRGB(12,13,18)
local function connect(signal,fn)local c=signal:Connect(fn);connections[#connections+1]=c;return c end
local function make(kind,props,parent)local o=Instance.new(kind);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local config=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37')
 local f=config and id and config:FindFirstChild('Frame_'..id)
 return f and f.Value or CFrame.identity
end
local function head(m)
 local p=m and m:FindFirstChild('Head',true)
 if p and not p:IsA('BasePart')then p=p:FindFirstChildWhichIsA('BasePart',true)end
 return p
end
local function position(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function part(parent,size,color,cf)
 return make('Part',{Size=size,Color=color,CFrame=cf or CFrame.identity,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.SmoothPlastic},parent)
end
local function sound(name,at,cinematic)
 local id=C.Sounds[name]
 if type(id)~='string'or not id:match('^rbxassetid://%d+$')then return end
 local anchor=part(folder,Vector3.one*.05,BLACK,CFrame.new(at));anchor.Transparency=1
 local s=make('Sound',{SoundId=id,Volume=cinematic and C.CinematicVolume or C.CombatVolume,RollOffMinDistance=C.RollOffMinDistance,RollOffMaxDistance=C.RollOffMaxDistance},anchor)
 local group=SoundService:FindFirstChild('CraxMusicControl');if cinematic and group and group:IsA('SoundGroup')then s.SoundGroup=group end
 s:Play();sounds[#sounds+1]={object=s,anchor=anchor,born=os.clock(),cinematic=cinematic}
end
local function cross(parent,where,size)
 local m=make('Model',{},parent)
 for _,angle in ipairs({45,-45})do local p=part(m,Vector3.new(size*.15,size,.055),WHITE,where*CFrame.Angles(0,0,math.rad(angle)));p.Name='CrossStroke'end
 return m
end
local function add(duration,update,cleanup)
 effects[#effects+1]={born=os.clock(),duration=duration,update=update,cleanup=cleanup}
end
local function ring(at,radius,duration)
 local count=low and 24 or 48;local pieces={};local origin=frame()*CFrame.new(at)
 for i=1,count do
  pieces[i]=part(folder,Vector3.new(.12,.12,.07),i%5==0 and BLACK or WHITE,origin)
 end
 add(duration,function(t)
  local r=radius*math.min(1,t/duration)
  for i,p in ipairs(pieces)do
   local a=i/count*math.pi*2
   p.Size=Vector3.new(.12,math.max(.12,2*math.pi*r/count*.72),.07)
   p.CFrame=origin*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)*CFrame.Angles(0,0,a)
   p.Transparency=math.clamp((t/duration-.7)/.3,0,1)
  end
 end,function()for _,p in ipairs(pieces)do p:Destroy()end end)
end
local function bits(at,count,duration,inward)
 local origin=frame()*CFrame.new(at);local pieces={};local offsets={}
 for i=1,(low and math.min(count,16)or count)do
  local a=random:NextNumber(0,math.pi*2);local r=random:NextNumber(.5,3)
  offsets[i]=Vector3.new(math.cos(a)*r,math.sin(a)*r,random:NextNumber(-.4,.4))
  pieces[i]=part(folder,Vector3.one*random:NextNumber(.08,.23),i%2==0 and WHITE or BLACK,origin)
 end
 add(duration,function(t)
  local u=math.clamp(t/duration,0,1)
  for i,p in ipairs(pieces)do p.CFrame=origin*CFrame.new(offsets[i]*(inward and(1-u)or(.2+u)))*CFrame.Angles(u*i,u,0);p.Transparency=u*u end
 end,function()for _,p in ipairs(pieces)do p:Destroy()end end)
end
local function clone(model,cf)
 local archivable=model.Archivable;model.Archivable=true;local ok,m=pcall(function()return model:Clone()end);model.Archivable=archivable
 if not ok or not m then return end
 for _,o in ipairs(m:GetDescendants())do
  if o:IsA('LuaSourceContainer')or o:IsA('Sound')or o:IsA('BillboardGui')or o:IsA('ParticleEmitter')or o:IsA('Trail')or o:IsA('Beam')then o:Destroy()
  elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end
 end
 m.Parent=folder;m:PivotTo(cf);return m
end
local function ghost(model,cf,duration)
 local m=clone(model,cf);if not m then return end
 local p={};for _,o in ipairs(m:GetDescendants())do if o:IsA('BasePart')then p[o]=o.Transparency;o.Color=WHITE end end
 add(duration,function(t)for o,base in pairs(p)do o.Transparency=base+(1-base)*(.65+.35*t/duration)end end,function()m:Destroy()end)
end
local function clearMark(m)
 local r=marks[m];if r then r.object:Destroy();marks[m]=nil end
end
local function stopScene()
 if not scene then return end
 local s=scene;scene=nil
 Run:UnbindFromRenderStep('Inverted404Camera')
 for p,value in pairs(s.hidden)do if p.Parent then p.LocalTransparencyModifier=value end end
 for gui,value in pairs(s.hiddenguis)do if gui.Parent then gui.Enabled=value end end
 if s.camera and s.camera==workspace.CurrentCamera then
  s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus
 end
 s.folder:Destroy();s.gui:Destroy();if s.color then s.color:Destroy()end
 for i=#sounds,1,-1 do if sounds[i].cinematic then sounds[i].anchor:Destroy();table.remove(sounds,i)end end
end
local function clear()
 stopScene()
 for _,e in ipairs(effects)do e.cleanup()end;table.clear(effects)
 for m in pairs(marks)do clearMark(m)end
 for m,r in pairs(statuses)do r.gui:Destroy();r.anchor:Destroy();statuses[m]=nil end
 for _,s in ipairs(sounds)do s.anchor:Destroy()end;table.clear(sounds)
end
local function status(m)
 local h=head(m);if not h then return end
 local anchor=part(folder,Vector3.one*.05,BLACK,frame()*h.CFrame);anchor.Transparency=1
 local billboard=make('BillboardGui',{Name='InvertedStatus',AlwaysOnTop=false,Size=UDim2.fromOffset(180,54),StudsOffsetWorldSpace=Vector3.new(0,h.Size.Y*.5+2,0),MaxDistance=160,Adornee=anchor},folder)
 local text=make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=17,TextColor3=WHITE,TextStrokeTransparency=.15,TextWrapped=true},billboard)
 local x=cross(anchor,frame()*CFrame.new(h.Position+Vector3.new(h.Size.X*.4,h.Size.Y*.25,-h.Size.Z*.5-.2)),.9)
 local icon=make('ImageLabel',{Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(-26,12),BackgroundTransparency=1,Image=C.SilenceIcon,Visible=C.SilenceIcon~=''},billboard)
 statuses[m]={gui=billboard,text=text,icon=icon,anchor=anchor,cross=x}
end
local function beginScene()
 if state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='Inverted404'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local round=state:GetAttribute('RoundId');if nextSceneRound==round or scene then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or '')
 if not winner or winner:GetAttribute('CraxId')~='Crax_Inverted'or(winner:GetAttribute('CraxSkillLevel')or 0)<4 then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1')
 if not loser or not head(loser)or not head(winner)then return end
 local cam=workspace.CurrentCamera;if not cam then return end
 -- Avoid taking the camera of a distant player who is not watching this arena.
 if player:GetAttribute('ArenaSeat')==nil then local ch=player.Character;local hr=ch and ch:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-position(winner)).Magnitude>180 then return end end
 nextSceneRound=round
 local s={folder=make('Folder',{Name='Inverted404'},folder),hidden={},camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,round=round,played={},winner=winner,loser=loser,hiddenguis={}}
 s.gui=make('ScreenGui',{Name='Inverted404Gui',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=180},player:WaitForChild('PlayerGui'))
 s.caption=make('TextLabel',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.8),Size=UDim2.fromScale(.9,.13),BackgroundTransparency=1,Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=WHITE,TextStrokeTransparency=.05,Text='404 — CRAX NOT FOUND',Visible=false},s.gui)
 s.color=make('ColorCorrectionEffect',{Name='Inverted404_LocalMonochrome',Saturation=-1,Contrast=.08,Brightness=0},cam)
 s.start=state:GetAttribute('RoundVictoryStartedAt')or workspace:GetServerTimeNow()
 local f=frame();s.winCF=f*winner:GetPivot();s.loseCF=f*loser:GetPivot();s.center=(f*head(loser).CFrame).Position
 s.actor=clone(winner,s.winCF);s.victim=clone(loser,s.loseCF)
 if not s.actor or not s.victim then s.folder:Destroy();s.gui:Destroy();s.color:Destroy();if s.actor then s.actor:Destroy()end;if s.victim then s.victim:Destroy()end;return end
 s.actor.Parent=s.folder;s.victim.Parent=s.folder
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hiddenguis[p]=p.Enabled;p.Enabled=false end end end
 s.x=cross(s.folder,CFrame.new(s.center+Vector3.new(0,0,3)),18)
 s.cubes={}
 for i=1,(low and 24 or 56)do
  local off=Vector3.new(random:NextNumber(-3,3),random:NextNumber(-3,3),random:NextNumber(-2,2))
  local p=part(s.folder,Vector3.one*random:NextNumber(.18,.58),i%2==0 and BLACK or WHITE,CFrame.new(s.center+off));p.Transparency=1
  s.cubes[i]={p=p,offset=off,seed=random:NextNumber()}
 end
 scene=s
 Run:BindToRenderStep('Inverted404Camera',Enum.RenderPriority.Last.Value+1000,function()
  if scene~=s then return end
  if state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=s.round or not winner.Parent or not loser.Parent or workspace.CurrentCamera~=cam then stopScene();return end
  local t=workspace:GetServerTimeNow()-s.start
  if t>=C.FinaleDuration then stopScene();return end
  local steps={{0,'MaxRise'},{2,'MaxLoop'},{4,'MaxFragment'},{6,'MaxSuction'},{8,'MaxClose'}}
  for _,entry in ipairs(steps)do if t>=entry[1]and not s.played[entry[2]]then s.played[entry[2]]=true;sound(entry[2],s.center,true)end end
  local xScale=t<1 and math.max(.02,t)or(t>8 and math.max(.001,1-(t-8)*2)or 1)
  for _,p in ipairs(s.x:GetChildren())do if p:IsA('BasePart')then p.Size=Vector3.new(2.7*xScale,18*xScale,.055);p.Transparency=math.clamp((t-8.3)*2,0,1)end end
  s.victim:PivotTo(s.loseCF*CFrame.new(math.sin(t*7)*.23,0,0))
  -- Head-only character: a restrained head inclination replaces the obsolete hand gesture.
  s.actor:PivotTo(s.winCF*CFrame.Angles(0,0,math.sin(math.clamp((t-3.3)*2,0,math.pi))*.09))
  local dissolve=math.clamp((t-4)/2,0,1)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=dissolve end end
  for _,c in ipairs(s.cubes)do
   local u=math.clamp((t-4-c.seed*.6)/3.8,0,1)
   c.p.Transparency=(t<4 or t>8.4)and 1 or math.clamp((u-.85)/.15,0,1)
   c.p.CFrame=CFrame.new(s.center+c.offset*(1-u)^2+Vector3.new(0,0,3*u))*CFrame.Angles(t*c.seed,t,0)
  end
  if t>1.6 and t<4 and not low then
   local interval=math.floor(t*3)
   if s.lastGhost~=interval then s.lastGhost=interval;ghost(loser,s.loseCF*CFrame.new(math.sin(t*8)*.6,0,0),.45)end
  end
  s.caption.Visible=t>=8.25
  local target=t<8 and s.center or(s.winCF*winner:GetPivot():ToObjectSpace(head(winner).CFrame)).Position
  local distance=t<8 and 23 or 14
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=40
  cam.CFrame=CFrame.lookAt(target+Vector3.new(math.sin(t*.15)*3,1,-distance),target);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.RoundId~=state:GetAttribute('RoundId')then return end
 local at=d.Position or(d.Owner and head(d.Owner)and head(d.Owner).Position)
 if kind=='Mute'and at then ring(at,d.Radius,.55);sound('MuteTrigger',(frame()*CFrame.new(at)).Position)
 elseif kind=='Silence'and at then if d.Owner and not statuses[d.Owner]then status(d.Owner)end;sound('SilenceApply',(frame()*CFrame.new(at)).Position);if d.Hack then sound('HackActivate',(frame()*CFrame.new(at)).Position)end
 elseif kind=='SilenceEnd'and at then sound('SilenceEnd',(frame()*CFrame.new(at)).Position)
 elseif kind=='HackTurn'and at then bits(at,4,.18,false);sound('HackDirection0'..tostring(d.Variant),(frame()*CFrame.new(at)).Position)
 elseif kind=='Capture'and at then bits(at,14,.4,true);sound('CopyCapture',(frame()*CFrame.new(at)).Position)
 elseif kind=='CopyImpact'and at then bits(at,16,.35,false);sound('CopyImpact',(frame()*CFrame.new(at)).Position)
 elseif kind=='Mark'and at then
  if not d.Owner or not d.Owner.Parent then return end
  clearMark(d.Owner);local object=cross(folder,frame()*CFrame.new(at),1.2)
  local frozen={}
  for i=1,(low and 4 or 8)do local a=i*math.pi/4;frozen[i]=part(object,Vector3.one*.13,i%2==0 and WHITE or BLACK,frame()*CFrame.new(at+Vector3.new(math.cos(a),math.sin(a),0)*1.15))end
  marks[d.Owner]={object=object,position=at,born=Clock.Time(d.Owner),frozen=frozen};sound('RewindMark',(frame()*CFrame.new(at)).Position);bits(at,10,.5,false)
 elseif kind=='Cancel'then clearMark(d.Owner);if at then sound('MarkCancel',(frame()*CFrame.new(at)).Position)end
 elseif kind=='Restore'and at then
  clearMark(d.Owner);sound('TeleportDepart',(frame()*CFrame.new(d.From)).Position);sound('TeleportArrive',(frame()*CFrame.new(at)).Position)
  ring(at,5,.4);bits(at,18,.55,true)
  local strips={};local start=frame()*CFrame.new(d.From)
  for i=1,6 do strips[i]=part(folder,Vector3.new(7,.38,.045),i%2==0 and WHITE or BLACK,start*CFrame.new(0,(i-3.5)*.9,-4.05))end
  add(.28,function(t)for i,p in ipairs(strips)do local u=t/.28;p.Size=Vector3.new(math.max(.03,7*(1-u)),.38,.045);p.CFrame=start*CFrame.new(0,(i-3.5)*.9*(1-u),-4.05);p.Transparency=u end end,function()for _,p in ipairs(strips)do p:Destroy()end end)
  if d.Owner and not low then
   local rotation=d.Owner:GetPivot().Rotation
   ghost(d.Owner,frame()*CFrame.new(d.From:Lerp(at,.33))*rotation,.33)
   ghost(d.Owner,frame()*CFrame.new(d.From:Lerp(at,.66))*rotation,.25)
  end
  if d.Owner and not low then ghost(d.Owner,frame()*CFrame.new(d.From)*d.Owner:GetPivot().Rotation,.45)end
 end
end)
connect(state:GetAttributeChangedSignal('RoundId'),function()clear();nextSceneRound=nil end)
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then
 for m in pairs(marks)do clearMark(m)end
 for m,r in pairs(statuses)do r.gui:Destroy();r.anchor:Destroy();statuses[m]=nil end
 if state:GetAttribute('Phase')~='RoundOver'then clear()end
 end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryKind','RoundVictoryRound','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(Run.Heartbeat,function(dt)
 elapsed=elapsed+dt;poll=poll+dt;if elapsed<(low and 1/20 or 1/30)then return end;elapsed=0
 local now=os.clock()
 for m,r in pairs(statuses)do local h=head(m);if h and m.Parent then
 r.anchor.CFrame=frame()*h.CFrame
 local cf=frame()*CFrame.new(h.Position+Vector3.new(h.Size.X*.4,h.Size.Y*.25,-h.Size.Z*.5-.2))
 for i,p in ipairs(r.cross:GetChildren())do if p:IsA('BasePart')then p.CFrame=cf*CFrame.Angles(0,0,math.rad(i==1 and 45 or -45));p.Transparency=m:GetAttribute('InvertedSilenced')and .08 or 1 end end
 end end
 for i=#effects,1,-1 do local e=effects[i];local age=now-e.born;if age>=e.duration then e.cleanup();table.remove(effects,i)else e.update(age)end end
 for i=#sounds,1,-1 do local s=sounds[i];if now-s.born>20 or(now-s.born>1 and not s.object.IsPlaying)then s.anchor:Destroy();table.remove(sounds,i)end end
 for m,r in pairs(marks)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 then clearMark(m)
  else
   local remaining=m:GetAttribute('InvertedCtrlRemaining')
   local age=type(remaining)=='number'and(10-remaining)or(Clock.Time(m)-r.born)
   for _,p in ipairs(r.object:GetChildren())do if p:IsA('BasePart')and p.Name=='CrossStroke'then p.Transparency=.16+.10*math.sin(age*2);p.Size=Vector3.new(.18,1.2*math.min(1,age*4),.055)end end
   if age>=8 and not r.sound then r.sound=true;sound('RewindBuild',(frame()*CFrame.new(r.position)).Position);bits(r.position,10,.6,true)end
  end
 end
 if poll>=.15 then poll=0
  local targets={};for i=1,2 do local m=workspace:FindFirstChild('Fighter'..i);if m then targets[#targets+1]=m end end
  -- Events also register summoned victims; scans are limited to tracked models plus the two roots.
  for m in pairs(statuses)do if not table.find(targets,m)then targets[#targets+1]=m end end
  for _,m in ipairs(targets)do
   local silence=m:GetAttribute('InvertedSilenced');local count=m:GetAttribute('InvertedCopyCount')
   local visible=m.Parent~=nil and state:GetAttribute('Phase')=='Fighting'and(m:GetAttribute('Health')or 0)>0 and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('DeadlyPhantom')
   if visible and(silence or count~=nil)then
    if not statuses[m]then status(m)end
    local r=statuses[m]
    if r then
     local ready=m:GetAttribute('InvertedCopyReady');local amount=m:GetAttribute('InvertedCopyAmount')or 8
     r.text.Text=(silence and '× SILENCE'or'')..(m:GetAttribute('InvertedHacked')and'  ▦ PIRATÉ'or'')..(count~=nil and('\n'..(ready and(amount>8 and('COPIE : '..amount)or'COPIE PRÊTE : 8')or('COPIE '..count..'/3')))or'')
     r.icon.Visible=silence==true and C.SilenceIcon~=''
    end
   elseif statuses[m]then statuses[m].gui:Destroy();statuses[m].anchor:Destroy();statuses[m]=nil end
  end
 end
end)
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()alive=false;clear();for _,c in ipairs(connections)do c:Disconnect()end;folder:Destroy()end)
task.defer(beginScene)
