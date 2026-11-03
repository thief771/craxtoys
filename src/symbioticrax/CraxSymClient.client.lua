-- Presentation only. All positions, damage and control decisions come from the server.
local Players=game:GetService('Players');local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxSymConfig'));local Audio=require(RS:WaitForChild('CraxSymAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxSymFX')
local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local BLACK=Color3.fromRGB(9,13,20);local WHITE=Color3.fromRGB(240,240,226);local RED=Color3.fromRGB(196,54,79);local GOLD=Color3.fromRGB(255,211,87)
local root=Instance.new('Folder');root.Name='SymbiotiCrax_Local';root.Parent=workspace
local connections={};local actors={};local marks={};local bursts={};local idle={};local idleNative={};local armourProgress={};local scene;local seen;local accumulator=0
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(class,props,parent)local p=Instance.new(class);for k,v in pairs(props)do p[k]=v end;p.Parent=parent;return p end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()
 if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end
 local folder=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local f=folder and id and folder:FindFirstChild('Frame_'..id);return f and f.Value or CFrame.identity
end
local function loc(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function mouth(m)local h=head(m);local a=h and h:FindFirstChild('SymMouth');return a and(frame()*a.WorldCFrame).Position or loc(m)end
local function ball(parent,size,color,alpha)
 return make('Part',{Shape=Enum.PartType.Ball,Size=size,Color=color,Material=Enum.Material.SmoothPlastic,Transparency=alpha or 0,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},parent)
end
local function path(parent,color,count)
 local chain={};for i=1,count do chain[i]=ball(parent,Vector3.one*.1,color,1);chain[i].Reflectance=.12 end
 if color==RED then
  chain.grooves={};for i=1,count do chain.grooves[i]=ball(parent,Vector3.one*.02,Color3.fromRGB(112,22,46),1)end
 end
 return chain
end
local function bezier(a,b,c,d,t)local u=1-t;return a*u^3+b*3*u*u*t+c*3*u*t*t+d*t^3 end
local function updatePath(chain,a,b,color,thickness,coil,time)
 local d=b-a;local side=frame():VectorToWorldSpace(Vector3.new(0,1,0));local last=a
 for i,p in ipairs(chain)do
  local u=i/#chain;local pos=bezier(a,a+d*.25+side*math.sin(time*2)*.6,a+d*.7+side*.3,b,u)
  if coil and u>.74 then local angle=(u-.74)/.26*math.pi*1.7;local radius=type(coil)=='number'and coil or 2;local v=(u-.74)/.26;angle=v*math.pi*2.5;local entry=b+frame():VectorToWorldSpace(Vector3.new(radius,0,-radius*.45));pos=entry:Lerp(b+frame():VectorToWorldSpace(Vector3.new(math.cos(angle)*radius,math.sin(angle)*radius,(v-.5)*radius*.9)),math.min(1,v*6)) end
  local delta=pos-last;local width=thickness*(1-.66*u^1.4)*(1+.035*math.sin(u*72-time*8))
  p.Size=Vector3.new(width*2,width*1.65,math.max(width*1.7,delta.Magnitude*1.6));p.CFrame=delta.Magnitude>.0001 and CFrame.lookAt((last+pos)*.5,pos,frame().UpVector)or CFrame.new(pos);p.Color=color;p.Transparency=0
  if chain.grooves then local g=chain.grooves[i];g.Size=Vector3.new(width*.11,width*.10,p.Size.Z*.94);g.CFrame=p.CFrame*CFrame.new(0,width*.77,0);g.Transparency=p.Transparency end
  last=pos
 end
end
local function destroyPath(p)for _,o in ipairs(p or{})do o:Destroy()end;if p and p.grooves then for _,o in ipairs(p.grooves)do o:Destroy()end end end
-- Three equal angular sectors conform to the front hemisphere of the real head.
-- Everything belongs to one local Model, so expiration/round changes remove every tendril.
local function contamination(owner,target,count,terminal)
 marks[owner]=marks[owner]or{}
 local old=marks[owner][target];if old then old:Destroy();marks[owner][target]=nil end
 if count<=0 or not head(target)then return end
 local model=make('Model',{Name='SymContamination'},root)
 model:SetAttribute('Stacks',math.clamp(count,1,3));model:SetAttribute('Born',os.clock())
 if terminal then model:SetAttribute('Terminal',true)end
 local columns=low and 9 or 15;local rows=low and 6 or 10
 for x=1,columns do for y=1,rows do
  local cell=ball(model,Vector3.one*.1,BLACK,1);cell.Name='Coat';cell.Reflectance=.16
  cell:SetAttribute('U',(x-.5)/columns);cell:SetAttribute('V',(y-.5)/rows)
 end end
 for i=1,(low and 5 or 9)do
  for j=1,5 do local cell=ball(model,Vector3.one*.1,BLACK,1);cell.Name='Tendril';cell.Reflectance=.2;cell:SetAttribute('Branch',i);cell:SetAttribute('Segment',j)end
 end
 marks[owner][target]=model
end
local function animateContamination(model,h,now)
 local count=model:GetAttribute('Stacks');local age=now-model:GetAttribute('Born');local spread=math.clamp(age/.24,0,1)
 local cf=frame()*h.CFrame;local sx,sy,sz=h.Size.X*.52,h.Size.Y*.52,h.Size.Z*.52
 for _,p in ipairs(model:GetChildren())do
  if p.Name=='Coat'then
   local u,v=p:GetAttribute('U'),p:GetAttribute('V');local active=u<=count/3
   local longitude=(u-.5)*2.85;local latitude=(v-.5)*2.65
   local pulse=1+.009*math.sin(now*4+u*19+v*11)
   local pos=Vector3.new(math.sin(longitude)*math.cos(latitude)*sx,math.sin(latitude)*sy,-math.cos(longitude)*math.cos(latitude)*sz)*pulse
   p.Size=Vector3.new(sx*(low and .40 or .24),sy*(low and .49 or .30),.13)*(.85+.15*spread)
   p.CFrame=cf*CFrame.new(pos)*CFrame.Angles(latitude,-longitude,math.sin(now*2+u*20)*.04)
   p.Transparency=active and (1-spread)*.85 or 1
  else
   local i,j=p:GetAttribute('Branch'),p:GetAttribute('Segment');local u=(i-.5)/(low and 5 or 9)*count/3
   local angle=(u-.5)*2.7;local v=j/5;local phase=now*3+i*2
   local pos=Vector3.new(math.sin(angle)*sx+math.sin(v*5+phase)*v*sx*.13,math.cos(i*2.399)*sy*.72+v*sy*.22,-math.cos(angle)*sz-.07-v*.24)
   local width=(1-v*.85)*sx*.075
   p.Size=Vector3.new(width,width,sy*.17);p.CFrame=cf*CFrame.new(pos)*CFrame.Angles(math.sin(phase+v)*.6,angle,phase*.15+v*2)
   p.Transparency=1-spread
  end
 end
 return model:GetAttribute('Terminal')and age>.65
end
local function burst(pos,color,inward)
 local list={};for i=1,(low and 8 or 17)do local a=i*2.399;list[i]={p=ball(root,Vector3.one*(i%3==0 and .25 or .13),color),offset=Vector3.new(math.cos(a),math.sin(a),(i%5-2)*.15)*(1+i%3)}end
 bursts[#bursts+1]={items=list,start=os.clock(),position=pos,inward=inward}
end
local function restTongue(m,alpha)local accessories=m and m:FindFirstChild('SymAccessories');if accessories then for _,p in ipairs(accessories:GetChildren())do if p.Name:find('Tongue',1,true)then p.LocalTransparencyModifier=alpha end end end end
local function clearActor(m)
 if marks[m]then for _,v in pairs(marks[m])do v:Destroy()end;marks[m]=nil end
 local a=actors[m];if a then destroyPath(a.tongue);if a.parasite then a.parasite.model:Destroy()end;Audio.Stop(a.loop);actors[m]=nil end
 restTongue(m,0)
end
local function restoreIdle(m)
 local i=idle[m];if not i then return end
 for p,s in pairs(i)do if p.Parent then if s.appliedColor and p.Color==s.appliedColor then p.Color=s.color end;local h=head(m);if h and(s.root or s.jaw)and(m:GetAttribute('CraxId')==C.Id or p.CFrame==s.appliedCF)then p.CFrame=h.CFrame*s.localCF end end end;idle[m]=nil;idleNative[m]=nil;armourProgress[m]=nil
end
local function clearCombat()
 for m in pairs(actors)do clearActor(m)end
 for owner,t in pairs(marks)do for _,m in pairs(t)do m:Destroy()end;marks[owner]=nil end
end
local function parasiteModel()
 local model=make('Model',{},root);local core=ball(model,Vector3.new(1.2,1,1.4),BLACK)
 local eyes={};for i=1,2 do eyes[i]=ball(model,Vector3.new(.27,.35,.1),WHITE)end
 local feet={};for i=1,3 do feet[i]=ball(model,Vector3.new(.19,.19,.8),BLACK)end
 local mouth=ball(model,Vector3.new(.65,.20,.12),RED);local teeth={};for i=1,3 do teeth[i]=ball(model,Vector3.new(.11,.13,.06),WHITE)end
 return{model=model,core=core,eyes=eyes,feet=feet,mouth=mouth,teeth=teeth}
end
local function moveParasite(p,pos,t)
 p.core.CFrame=CFrame.new(pos);p.mouth.CFrame=CFrame.new(pos+Vector3.new(0,-.20,-.69));for i,t in ipairs(p.teeth)do t.CFrame=CFrame.new(pos+Vector3.new((i-2)*.17,-.19,-.77))end;for i,e in ipairs(p.eyes)do e.CFrame=CFrame.new(pos+Vector3.new((i==1 and-.28 or .28),.1,-.68))*CFrame.Angles(0,0,i==1 and-.3 or .3)end
 for i,f in ipairs(p.feet)do f.CFrame=CFrame.new(pos+Vector3.new(math.sin(t*4+i)*.65,-.35,i*.25-.5))*CFrame.Angles(0,i,0)end
end
local function clone(m,parent)
 local arch=m.Archivable;m.Archivable=true;local copy=m:Clone();m.Archivable=arch
 for _,o in ipairs(copy:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('BillboardGui')or o:IsA('Sound')or o:IsA('Beam')or o:IsA('Trail')or o:IsA('ParticleEmitter')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;o.LocalTransparencyModifier=0 end end
 copy.Parent=parent;return copy
end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('SymbiotiCraxExclusiveCamera')
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.FieldOfView=s.fov;s.camera.CFrame=s.cf;s.camera.Focus=s.focus end
 player:SetAttribute('SymCameraOwner',s.previousOwner);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function makeJaw(winner,parent)
 local source=head(winner);local upper={};local lower={};local center=Vector3.new(0,-1.1,0)
 for _,p in ipairs(winner:GetDescendants())do if p:IsA('BasePart')and p.Transparency<.8 then
  local n=p.Name:lower()
  if n:find('gums',1,true)or n:find('tooth',1,true)or n:find('fang',1,true)or n:find('inner',1,true)then
   local c=p:Clone();for _,d in ipairs(c:GetChildren())do d:Destroy()end;c.Size=p.Size*1.85;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.Parent=parent
   local rel=source.CFrame:ToObjectSpace(p.CFrame);local offset=rel.Position-center
   local row=offset.Y>0 and upper or lower;row[#row+1]={part=c,rel=CFrame.new(offset*1.85)*rel.Rotation}
  end
 end end
 local cavity=ball(parent,Vector3.new(13,10,5),BLACK);return{upper=upper,lower=lower,cavity=cavity}
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='SymFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local token=state:GetAttribute('CraxMatchToken');local round=state:GetAttribute('RoundId')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('SymVictoryMatch')~=token or state:GetAttribute('SymVictoryCrax')~=C.Id or(state:GetAttribute('SymVictoryLevel')or 0)<4 then return end
 if seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera
 if not loser or not cam or not head(loser)then return end
 if player:GetAttribute('ArenaSeat')==nil then local hr=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-loc(winner)).Magnitude>180 then return end end
 for m in pairs(idle)do restoreIdle(m)end
 local folder=make('Folder',{Name='SymFinale'},root);local s={folder=folder,winner=winner,loser=loser,round=round,match=token,start=state:GetAttribute('RoundVictoryStartedAt'),camera=cam,kind=cam.CameraType,subject=cam.CameraSubject,fov=cam.FieldOfView,cf=cam.CFrame,focus=cam.Focus,hidden={},cues={},previousOwner=player:GetAttribute('SymCameraOwner')}
 if type(s.start)~='number'then folder:Destroy();return end
 s.hero=clone(winner,folder);s.victim=clone(loser,folder);s.jaw=makeJaw(winner,folder);s.tongue=path(folder,RED,low and 36 or 64);s.filaments={};s.saliva={}
 for i=1,(low and 3 or 6)do s.saliva[i]=path(folder,Color3.fromRGB(151,87,109),low and 3 or 5)end
 for i=1,(low and 4 or 8)do s.filaments[i]=path(folder,BLACK,low and 5 or 8)end
 s.gui=make('ScreenGui',{Name='SymFinaleTitle',IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=95},player:WaitForChild('PlayerGui'))
 s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.12),Position=UDim2.fromScale(.05,.80),Text=C.TrophyTitle,TextScaled=true,BackgroundTransparency=1,TextColor3=GOLD,TextStrokeColor3=BLACK,TextStrokeTransparency=.2,Font=Enum.Font.FredokaOne,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 seen=tostring(token)..':'..round;scene=s;player:SetAttribute('SymCameraOwner',seen)
 local center=frame()*CFrame.new(loser:GetPivot().Position);local rotation=winner:GetPivot().Rotation;local victimRot=loser:GetPivot().Rotation
 Run:BindToRenderStep('SymbiotiCraxExclusiveCamera',Enum.RenderPriority.Last.Value+1200,function()
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.ReturnEnd or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=s.round or state:GetAttribute('CraxMatchToken')~=s.match or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  local deploy=math.clamp(t/F.Capture,0,1);local capture=math.clamp((t-F.Capture)/(F.Close-F.Capture),0,1);local retract=math.clamp((t-F.Retract)/(F.Pose-F.Retract),0,1)
  local jawCF=center*CFrame.new(-11,1+2*(1-deploy),2)*head(winner).CFrame.Rotation;local open=(1-math.clamp((t-F.Close)/(F.Impact-F.Close),0,1))*deploy
  s.hero:PivotTo(center*CFrame.new(-8,-1,0)*rotation*CFrame.Angles(0,0,math.sin(t*1.7)*.04))
  s.victim:PivotTo(center*CFrame.new(-11*capture,1*capture,2*capture)*victimRot)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=t>=F.Impact and 1 or 0 end end
  local size=math.max(.001,deploy*(1-retract));s.jaw.cavity.Size=Vector3.new(13,10,5)*size;s.jaw.cavity.CFrame=jawCF
  for _,row in ipairs({{s.jaw.upper,1},{s.jaw.lower,-1}})do for _,v in ipairs(row[1])do v.part.CFrame=jawCF*CFrame.new(0,row[2]*open*1.8,0)*CFrame.Angles(row[2]*open*.14,0,0)*v.rel;v.part.Transparency=1-size end end
  local endPos=t<F.Capture and(center*CFrame.new(0,0,0)).Position or head(s.victim).Position
  updatePath(s.tongue,jawCF.Position+frame():VectorToWorldSpace(Vector3.new(0,0,-3)),endPos,RED,.65,t>=F.Capture and t<F.Close and head(s.victim).Size.X*.53,t)
  for i,p in ipairs(s.tongue)do p.Transparency=(t<F.Deploy or t>=F.Impact)and 1 or 0;if s.tongue.grooves then s.tongue.grooves[i].Transparency=p.Transparency end end
  for i,chain in ipairs(s.filaments)do local a=i*2.399;local start=(center*CFrame.new(math.cos(a)*7,-5,1)).Position;local finish=(center*CFrame.new(math.cos(a)*3,math.sin(a)*3,1)).Position;updatePath(chain,start,start:Lerp(finish,deploy*(1-retract)),BLACK,.18,false,t+i)end
  for i,chain in ipairs(s.saliva)do
   local x=(i/(#s.saliva+1)-.5)*8
   local upper=(jawCF*CFrame.new(x,open*2.3,-2.6)).Position
   local lower=(jawCF*CFrame.new(x+.2,-open*2.3,-2.6)).Position
   updatePath(chain,upper,lower,Color3.fromRGB(151,87,109),.025,false,t+i)
   for _,p in ipairs(chain)do p.Transparency=(t<F.Deploy or t>=F.Impact)and 1 or .45 end
  end
  if t>=F.Impact and not s.impact then s.impact=true;burst(jawCF.Position,BLACK,false);burst(jawCF.Position,WHITE,false)end
  s.title.Visible=t>=F.Pose
  for _,cue in ipairs({{0,'MaxDeploy'},{F.Capture,'MaxCapture'},{F.Close-.35,'TonguePrepare'},{F.Close,'Bite'},{F.Impact,'MaxBite'},{F.Retract,'MaxRetract'},{F.Pose,'MaxTitle'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;Audio.Play(cue[2],jawCF.Position,false,true)end end
  local target=(center*CFrame.new(-5,1,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(30,24/(2*math.tan(math.rad(22))*math.max(.35,aspect)))
  local wanted=CFrame.lookAt(target+frame():VectorToWorldSpace(Vector3.new(0,3,-distance)),target,frame().UpVector);local finish=math.clamp((t-(F.ReturnEnd-.7))/.7,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=44+(s.fov-44)*finish;cam.CFrame=(wanted*CFrame.Angles(0,0,math.sin(t*47)*.012*math.max(0,1-math.abs(t-F.Impact)/.28))):Lerp(s.cf,finish);cam.Focus=CFrame.new(target)
 end)
end
connect(FX.OnClientEvent,function(kind,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner;local pos=loc(m)
 if kind=='Clear'then clearCombat();return elseif kind=='OwnerClear'then clearActor(m);return end
 if not m or not m.Parent then return end
 if kind=='TongueStart'then local a=actors[m]or{};actors[m]=a;a.tongue=path(root,RED,low and 32 or 56);a.tip=mouth(m);a.mode='Prepare';a.id=d.Activation;restTongue(m,1);Audio.Play('TonguePrepare',pos)
 elseif kind=='TongueLaunch'then Audio.Play('TongueLaunch',pos)
 elseif kind=='TongueState'then local a=actors[m];if a and a.id==d.Activation then a.tip=(frame()*CFrame.new(d.Position)).Position;a.mode=d.Mode;a.target=d.Target;if d.Mode=='Return'then Audio.Stop(a.loop);a.loop=nil end end
 elseif kind=='Capture'then local a=actors[m];if a then a.loop=Audio.Play('Pull',pos,true)end;Audio.Play('Capture',pos)
 elseif kind=='Miss'then Audio.Play('TongueMiss',pos)
 elseif kind=='TongueStop'then local a=actors[m];if a and a.id==d.Activation then destroyPath(a.tongue);a.tongue=nil;Audio.Stop(a.loop);a.loop=nil;restTongue(m,0)end
 elseif kind=='Melee'then local p=loc(d.Target);if p then Audio.Play('Bite',p);burst(p,BLACK,false)end
 elseif kind=='ArmourHit'then Audio.Play('ArmourHit',pos);burst(pos,WHITE,false)
 elseif kind=='Bite'then local a=actors[m];if a then a.biteUntil=os.clock()+.18 end;local p=loc(d.Target);if p then burst(p,d.Damage>0 and RED or WHITE,false);Audio.Play('Bite',p)end
 elseif kind=='Marks'then
  contamination(m,d.Target,d.Count);if d.Count>0 then Audio.Play('Mark',loc(d.Target))end
 elseif kind=='Burst'then local p=loc(d.Target);if p then contamination(m,d.Target,3,true);burst(p,BLACK,false);Audio.Play('Burst',p)end
 elseif kind=='Heal'then burst(pos,WHITE,true);Audio.Play('Heal',pos)
 elseif kind=='Armour'then Audio.Play(d.Active and'ArmourStart'or'ArmourEnd',pos)
 elseif kind=='ParasiteStart'then local a=actors[m]or{};actors[m]=a;if a.parasite then a.parasite.model:Destroy()end;a.parasite=parasiteModel();a.parasiteId=d.Activation;a.parasitePosition=pos;Audio.Play('ParasiteStart',pos)
 elseif kind=='ParasiteState'then local a=actors[m];if a and a.parasiteId==d.Activation then a.parasitePosition=(frame()*CFrame.new(d.Position)).Position;a.parasiteMode=d.Mode end
 elseif kind=='ParasiteAttach'or kind=='ParasiteReturn'then Audio.Play(kind=='ParasiteAttach'and'ParasiteAttach'or'ParasiteReturn',pos)
 elseif kind=='ParasiteMerge'or kind=='ParasiteClear'then local a=actors[m];if a and a.parasiteId==d.Activation and a.parasite then a.parasite.model:Destroy();a.parasite=nil end;if kind=='ParasiteMerge'then Audio.Play('ParasiteMerge',pos);burst(pos,BLACK,true)end
 end
end)
connect(Run.Heartbeat,function(dt)
 accumulator+=dt;if accumulator<(low and 1/20 or 1/30)then return end;local elapsed=accumulator;accumulator=0;local now=os.clock()
 for m in pairs(idle)do if not m.Parent or m:GetAttribute('CraxId')~=C.Id then restoreIdle(m)end end
 for _,name in ipairs({'Fighter1','Fighter2'})do local m=workspace:FindFirstChild(name)
  if m and m:GetAttribute('CraxId')==C.Id and head(m)and not scene then
   armourProgress[m]=(armourProgress[m]or 0)+((m:GetAttribute('SymArmour')and 1 or 0)-(armourProgress[m]or 0))*math.min(1,elapsed*9)
   local h=head(m);local folder=m:FindFirstChild('SymAccessories');local s=idle[m]
   if not s and folder then s={};idle[m]=s;for _,p in ipairs(folder:GetChildren())do if p:IsA('BasePart')then s[p]={color=p.Color,reflect=p.Reflectance,localCF=h.CFrame:ToObjectSpace(p.CFrame),root=p:GetAttribute('SymRootLocal'),jaw=p:GetAttribute('SymJawRow')}end end end
   if s and not idleNative[m]then
    idleNative[m]=true
    for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')and(p.Name:match('^Lower')or p.Name=='InnerLower'or p.Name:match('^Tooth_1_'))then s[p]={color=p.Color,reflect=p.Reflectance,localCF=h.CFrame:ToObjectSpace(p.CFrame),jaw='Lower'}end end
   end
   local actor=actors[m];local open=actor and actor.tongue and(actor.mode=='Prepare'and .12 or .4)or 0
   if actor and actor.biteUntil and now<actor.biteUntil then open=.4*math.abs(math.sin((actor.biteUntil-now)/.18*math.pi))end
   if s then for p,v in pairs(s)do if p.Parent then
    if v.jaw=='Lower'then p.CFrame=h.CFrame*CFrame.new(0,-open*.8,0)*v.localCF;v.appliedCF=p.CFrame end
    if v.root then local phase=tonumber(p.Name:match('(%d+)$'))or 0;p.CFrame=h.CFrame*v.root*CFrame.Angles(math.sin(now*.8+phase)*.025,0,math.cos(now*.7+phase)*.025)*v.root:ToObjectSpace(v.localCF);v.appliedCF=p.CFrame end
    local white=p.Name:find('White',1,true);if white then v.appliedColor=v.color:Lerp(BLACK,(armourProgress[m]or 0)*.90);p.Color=v.appliedColor end
   end end end
  elseif m then restoreIdle(m)end
 end
 for m,a in pairs(actors)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('CraxId')~=C.Id then clearActor(m)
  else
   if a.tongue and a.tip then local radius=a.mode=='Pull'and a.target and head(a.target)and head(a.target).Size.X*.5+.2;local tip=radius and loc(a.target)or a.tip;updatePath(a.tongue,mouth(m),tip,RED,.5,radius,now)end
   if a.loop then Audio.Pause(a.loop,Clock.Paused(m))end
   if a.parasite and a.parasitePosition then moveParasite(a.parasite,a.parasitePosition+Vector3.new(0,math.sin(now*7)*.13,0),now)end
  end
 end
 for owner,targets in pairs(marks)do for target,model in pairs(targets)do
  local h=head(target);if not owner.Parent or not target.Parent or not h or(target:GetAttribute('Health')or 0)<=0 then model:Destroy();targets[target]=nil
  elseif animateContamination(model,h,now)then model:Destroy();targets[target]=nil end
 end end
 for i=#bursts,1,-1 do local b=bursts[i];local t=(now-b.start)/.65;if t>=1 then for _,v in ipairs(b.items)do v.p:Destroy()end;table.remove(bursts,i)else for _,v in ipairs(b.items)do v.p.Position=b.position+v.offset*(b.inward and 1-t or t);v.p.Transparency=t end end end
end)
local function clearAll()
 clearCombat();stopScene();Audio.Clear();for m in pairs(idle)do restoreIdle(m)end
 for _,b in ipairs(bursts)do for _,v in ipairs(b.items)do v.p:Destroy()end end;table.clear(bursts)
end
for _,k in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(k),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,k in ipairs({'RoundVictoryRound','RoundVictoryKind','RoundVictoryStartedAt'})do connect(state:GetAttributeChangedSignal(k),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()if scene and player:GetAttribute('ArenaSeat')==nil then stopScene()end end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
