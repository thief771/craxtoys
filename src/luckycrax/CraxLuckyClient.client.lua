local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService');local Players=game:GetService('Players')
local C=require(RS:WaitForChild('CraxLuckyConfig'));local Assets=require(RS:WaitForChild('CraxLuckyAssets'));local Audio=require(RS:WaitForChild('CraxLuckyAudio'));local Clock=require(RS:WaitForChild('CraxAbilityClock'))
local player=Players.LocalPlayer;local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxLuckyFX');local low=C.Quality=='Low'or(C.Quality=='Auto'and game:GetService('UserInputService').TouchEnabled)
local root=Instance.new('Folder');root.Name='LuckyCrax_Local';root.Parent=workspace
local GOLD=Color3.fromRGB(241,186,55);local RED=Color3.fromRGB(137,20,37);local PURPLE=Color3.fromRGB(163,80,218);local coins={};local casts={};local clovers={};local particles={};local cheats={};local poses={};local connections={};local scene;local seen
local function connect(s,f)local c=s:Connect(f);connections[#connections+1]=c;return c end
local function make(class,p,parent)local o=Instance.new(class);for k,v in pairs(p)do o[k]=v end;o.Parent=parent;return o end
local function head(m)return m and m:FindFirstChild('Head',true)end
local function frame()if player:GetAttribute('ArenaSeat')~=nil then return CFrame.identity end;local a=RS:FindFirstChild('CraxArenaConfigV37');local id=state:GetAttribute('CraxActiveArenaV37');local cf=a and id and a:FindFirstChild('Frame_'..id);return cf and cf.Value or CFrame.identity end
local function pos(m)local h=head(m);return h and(frame()*h.CFrame).Position end
local function sound(name,m,loop,finale)return Audio.Play(name,pos(m)or Vector3.zero,loop,finale)end
local function spark(p,color,n)
 for i=1,(low and math.min(n,5)or n)do local a=i*2.4;local o=make('Part',{Size=Vector3.one*.12,Shape=Enum.PartType.Ball,Color=color,Material=Enum.Material.Neon,Transparency=.1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},root);particles[#particles+1]={part=o,start=os.clock(),p=p,v=Vector3.new(math.cos(a),math.sin(a),i%3-1)*3}end
end
local function glyph(parent,kind)
 local f=make('Frame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},parent)
 if kind=='Coin'then
  local disk=make('Frame',{Size=UDim2.fromScale(.72,.72),Position=UDim2.fromScale(.14,.14),BackgroundColor3=GOLD,BorderSizePixel=0},f);make('UICorner',{CornerRadius=UDim.new(1,0)},disk);make('UIStroke',{Color=Color3.fromRGB(122,73,12),Thickness=2},disk)
  make('TextLabel',{Size=UDim2.fromScale(1,1),Text='⌣',Font=Enum.Font.FredokaOne,TextScaled=true,BackgroundTransparency=1,TextColor3=Color3.fromRGB(79,41,9)},disk)
 else make('TextLabel',{Size=UDim2.fromScale(1,1),Text=kind=='Heal'and'♥'or'J',TextScaled=true,Font=Enum.Font.FredokaOne,BackgroundTransparency=1,TextColor3=kind=='Heal'and Color3.fromRGB(118,225,107)or PURPLE,TextStrokeColor3=GOLD,TextStrokeTransparency=.15},f)end
 return f
end
local function reel(owner,parent,large)
 local h=head(owner);local hp=h and h:FindFirstChild('HealthBar');local hpPixels=hp and hp.Size.Y.Offset or 60
 local anchor=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false},parent)
 local gui=make('BillboardGui',{Adornee=anchor,Size=UDim2.fromOffset(200,190),AlwaysOnTop=true,LightInfluence=0},anchor)
 local panel=make('Frame',{Size=UDim2.fromOffset(186,78),AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,.5,-hpPixels*.5-10),BackgroundColor3=RED,BorderSizePixel=0},gui)
 make('UICorner',{CornerRadius=UDim.new(0,12)},panel);make('UIStroke',{Color=GOLD,Thickness=4},panel)
 local strips={}
 for i=1,3 do local window=make('Frame',{Size=UDim2.fromOffset(48,52),Position=UDim2.fromOffset(9+(i-1)*60,13),ClipsDescendants=true,BackgroundColor3=Color3.fromRGB(38,25,25),BorderSizePixel=0},panel)
  local strip=make('Frame',{Size=UDim2.fromOffset(48,52*6),BackgroundTransparency=1},window);strips[i]=strip
  for j=0,5 do local cell=make('Frame',{Size=UDim2.fromOffset(48,52),Position=UDim2.fromOffset(0,j*52),BackgroundTransparency=1},strip);glyph(cell,({'Heal','Coin','Cheat'})[j%3+1])end
 end
 return{anchor=anchor,gui=gui,strips=strips,stopped={}}
end
local function updateReel(r,owner,t,reward,total)
 local h=head(owner);if h then local hp=h:FindFirstChild('HealthBar');local off=hp and hp.StudsOffsetWorldSpace or Vector3.new(0,h.Size.Y*.5+1.3,0);r.anchor.CFrame=frame()*h.CFrame*CFrame.new(off)end
 local index=({Heal=0,Coins=1,Cheat=2})[reward]or 0
 for i,strip in ipairs(r.strips)do local stop=total-.36+(i-1)*.18;local u=math.clamp(t/stop,0,1);local travel=(12+index)*(1-(1-u)^3);strip.Position=UDim2.fromOffset(0,-(travel%3)*52)
  if u>=1 and not r.stopped[i]then r.stopped[i]=true;sound('ReelStop',owner)end
 end
end
local faceRotation={CFrame.Angles(-math.pi/2,0,0),CFrame.Angles(0,0,-math.pi/2)*CFrame.Angles(0,-math.pi/2,0),CFrame.identity,CFrame.Angles(0,0,math.pi)*CFrame.Angles(0,math.pi,0),CFrame.Angles(0,0,math.pi/2)*CFrame.Angles(0,math.pi/2,0),CFrame.Angles(math.pi/2,0,0)}
local function clearCast(m)local r=casts[m];if r then Audio.Stop(r.loop);r.folder:Destroy();casts[m]=nil end end
local function restorePose(m)
 local s=poses[m];if not s then return end;local h=head(m)
 for p,v in pairs(s)do if p.Parent and h and(m:GetAttribute('CraxId')==C.Id or p.CFrame==v.applied)then p.CFrame=h.CFrame*v.rest end end;poses[m]=nil
end
local function mouthPose(m,amount)
 local h=head(m);if not h then return end
 if not poses[m]then local list={};for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')and(p.Name:match('^Lower')or p.Name=='InnerLower'or p.Name:match('^Tooth_1_'))then list[p]={rest=h.CFrame:ToObjectSpace(p.CFrame)}end end;poses[m]=list end
 for p,v in pairs(poses[m])do if p.Parent then v.applied=h.CFrame*CFrame.new(0,-amount*.6,0)*v.rest;p.CFrame=v.applied end end
end
local function clearCombat()
 for _,p in pairs(coins)do p.model:Destroy()end;coins={}
 for m in pairs(casts)do clearCast(m)end
 for _,r in pairs(clovers)do r.model:Destroy()end;clovers={}
 for _,r in pairs(cheats)do r.folder:Destroy()end;cheats={}
 for m in pairs(poses)do restorePose(m)end
end
local function clone(m,parent)local arch=m.Archivable;m.Archivable=true;local c=m:Clone();m.Archivable=arch;for _,o in ipairs(c:GetDescendants())do if o:IsA('LuaSourceContainer')or o:IsA('BillboardGui')or o:IsA('Sound')then o:Destroy()elseif o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanQuery=false;o.CanTouch=false;o.LocalTransparencyModifier=0 end end;c.Parent=parent;return c end
local function stopScene()
 local s=scene;if not s then return end;scene=nil;Run:UnbindFromRenderStep('LuckyFinaleCamera')
 for p,v in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=v else p.Enabled=v end end end
 if workspace.CurrentCamera==s.camera then for k,v in pairs(s.saved)do s.camera[k]=v end end
 player:SetAttribute('LuckyCameraOwner',s.previous);s.folder:Destroy();s.gui:Destroy();Audio.Clear()
end
local function beginScene()
 if scene or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundVictoryKind')~='LuckyFinale'or state:GetAttribute('RoundVictoryRound')~=state:GetAttribute('RoundId')then return end
 local winner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or'');local token=state:GetAttribute('CraxMatchToken');local round=state:GetAttribute('RoundId')
 if not winner or winner:GetAttribute('CraxId')~=C.Id or(winner:GetAttribute('CraxSkillLevel')or 0)<4 or state:GetAttribute('LuckyVictoryMatch')~=token or seen==tostring(token)..':'..round then return end
 local loser=workspace:FindFirstChild(winner.Name=='Fighter1'and'Fighter2'or'Fighter1');local cam=workspace.CurrentCamera;if not loser or not cam then return end
 if player:GetAttribute('ArenaSeat')==nil then local hr=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if not hr or(hr.Position-pos(winner)).Magnitude>180 then return end end
 clearCombat();local folder=make('Folder',{Name='LuckyFinale'},root);local s={folder=folder,hidden={},saved={},camera=cam,start=state:GetAttribute('RoundVictoryStartedAt'),previous=player:GetAttribute('LuckyCameraOwner'),cues={}}
 for _,k in ipairs({'CameraType','CameraSubject','FieldOfView','CFrame','Focus'})do s.saved[k]=cam[k]end
 s.hero=clone(winner,folder);s.victim=clone(loser,folder);s.case=Assets.Model('Chest',folder);s.lid=Assets.Model('Lid',folder);s.machine=Assets.Model('Reels',folder);s.prize=Assets.Model('Coin',folder);s.reels=reel(winner,folder,true);s.money={}
 for i=1,(low and 12 or 28)do s.money[i]=Assets.Model('Coin',folder)end
 s.gui=make('ScreenGui',{IgnoreGuiInset=true,ResetOnSpawn=false,Name='LuckyFinaleTitle'},player:WaitForChild('PlayerGui'));s.title=make('TextLabel',{Size=UDim2.fromScale(.9,.12),Position=UDim2.fromScale(.05,.8),BackgroundTransparency=1,Text=C.MaxTitle,TextColor3=GOLD,TextStrokeTransparency=.2,Font=Enum.Font.FredokaOne,TextScaled=true,Visible=false},s.gui)
 for _,m in ipairs({winner,loser})do for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then s.hidden[p]=p.LocalTransparencyModifier;p.LocalTransparencyModifier=1 elseif p:IsA('BillboardGui')then s.hidden[p]=p.Enabled;p.Enabled=false end end end
 scene=s;seen=tostring(token)..':'..round;player:SetAttribute('LuckyCameraOwner',seen);local center=frame()*CFrame.new(loser:GetPivot().Position);local wr=winner:GetPivot().Rotation;local lr=loser:GetPivot().Rotation
 Run:BindToRenderStep('LuckyFinaleCamera',Enum.RenderPriority.Last.Value+1250,function()
  local t=workspace:GetServerTimeNow()-s.start;local F=C.Finale
  if t>=F.End or state:GetAttribute('Phase')~='RoundOver'or state:GetAttribute('RoundId')~=round or state:GetAttribute('CraxMatchToken')~=token or not winner.Parent or not loser.Parent or winner:GetAttribute('CraxId')~=C.Id or workspace.CurrentCamera~=cam then stopScene();return end
  for p in pairs(s.hidden)do if p.Parent then if p:IsA('BasePart')then p.LocalTransparencyModifier=1 else p.Enabled=false end end end
  s.hero:PivotTo(center*CFrame.new(-10,0,0)*wr);local vanish=math.clamp((t-F.Result)/(F.Vanish-F.Result),0,1);s.victim:PivotTo(center*CFrame.new(0,-vanish*3,0)*lr)
  for _,p in ipairs(s.victim:GetDescendants())do if p:IsA('BasePart')then p.LocalTransparencyModifier=vanish end end
  s.case:ScaleTo(math.max(.01,math.clamp(t/F.Build,0,1)*3.8));s.case:PivotTo(center*CFrame.new(0,-2,1));local open=math.clamp((t-(F.Result-.5))/.5,0,1);s.lid:ScaleTo(math.max(.01,math.clamp(t/F.Build,0,1)*3.8));s.lid:PivotTo(center*CFrame.new(0,-2,1)*CFrame.new(0,2.1,4)*CFrame.Angles(-open*1.7,0,0)*CFrame.new(0,-2.1,-4));s.machine:ScaleTo(math.max(.01,math.clamp((t-F.Build)/.8,0,1)*3.8));s.machine:PivotTo(center*CFrame.new(0,6.5,1));local take=math.clamp((t-F.Vanish)/(F.Pose-F.Vanish),0,1);s.prize:PivotTo(center*CFrame.new(-10+5*(1-take),-1+4*(1-take),-4)*CFrame.Angles(-math.pi/2,0,take*math.pi));updateReel(s.reels,loser,math.max(0,t-F.Build),'Coins',F.Result-F.Build)
  s.reels.anchor.CFrame=center*CFrame.new(0,7,0)
  for i,m in ipairs(s.money)do local angle=i*2.399+t*.8;local radius=t<F.Result and 5 or 5+math.max(0,t-F.Result)*1.1;local drop=t>=F.Result and(t-F.Result)^2*.7 or 0;m:PivotTo(center*CFrame.new(math.cos(angle)*radius,math.sin(angle)*3-drop,math.sin(i)*2)*CFrame.Angles(t*2+i,0,angle))end
  s.title.Visible=t>=F.Pose
  for _,cue in ipairs({{0,'MaxBuild'},{F.Build,'MaxSuspense'},{F.Result,'MaxPrize'},{F.Pose,'MaxTitle'}})do if t>=cue[1]and not s.cues[cue[2]]then s.cues[cue[2]]=true;sound(cue[2],winner,false,true)end end
  local focus=(center*CFrame.new(-3,2,0)).Position;local aspect=cam.ViewportSize.X/math.max(1,cam.ViewportSize.Y);local distance=math.max(29,23/(2*math.tan(math.rad(22))*math.max(.35,aspect)));local wanted=CFrame.lookAt(focus+frame():VectorToWorldSpace(Vector3.new(0,3,-distance)),focus,frame().UpVector);local back=math.clamp((t-(F.End-.8))/.8,0,1)
  cam.CameraType=Enum.CameraType.Scriptable;cam.FieldOfView=44+(s.saved.FieldOfView-44)*back;cam.CFrame=wanted:Lerp(s.saved.CFrame,back);cam.Focus=CFrame.new(focus)
 end)
end
connect(FX.OnClientEvent,function(k,d)
 if type(d)~='table'or d.Round~=state:GetAttribute('RoundId')or d.Match~=state:GetAttribute('CraxMatchToken')then return end
 local m=d.Owner
 if k=='Clear'then clearCombat();return elseif k=='OwnerClear'then clearCast(m);restorePose(m);return end
 if k=='Coin'then local model=Assets.Model('Coin',root);local body=model:FindFirstChild('LFX_CoinBody');if body then local aa=make('Attachment',{Position=Vector3.new(-.13,0,0)},body);local ab=make('Attachment',{Position=Vector3.new(.13,0,0)},body);make('Trail',{Attachment0=aa,Attachment1=ab,Lifetime=low and .09 or .15,FaceCamera=true,Color=ColorSequence.new(GOLD),LightEmission=.45,MinLength=.08},body)end;coins[d.Id]={model=model,position=d.Position,owner=m,start=Clock.Time(m),volley=d.Volley};sound(d.Volley and'CoinVolley'or'CoinLaunch',m)
 elseif k=='CoinState'then if coins[d.Id]then coins[d.Id].position=d.Position end
 elseif k=='CoinEnd'then if coins[d.Id]then coins[d.Id].model:Destroy();coins[d.Id]=nil end
 elseif k=='Bounce'or k=='CoinHit'then local p=(frame()*CFrame.new(d.Position)).Position;spark(p,GOLD,k=='Bounce'and 6 or 12);Audio.Play(k=='Bounce'and'CoinBounce'or'CoinHit',p)
 elseif k=='Cast'then
  clearCast(m);local folder=make('Folder',{},root);local r={folder=folder,kind=d.Kind,start=Clock.Time(m),id=d.Activation,data=d};casts[m]=r
  if r.kind=='Coin'then r.coin=Assets.Model('Coin',folder);sound('CoinFlip',m)
  elseif r.kind=='Dice'then r.dice={Assets.Model('Dice',folder),Assets.Model('Dice',folder)};sound('DiceLaunch',m)
  else r.reels=reel(m,folder);sound('ReelsStart',m);r.loop=sound('ReelsLoop',m,true)end
 elseif k=='CastEnd'then local r=casts[m];if r and r.kind=='Volley'then sound('JackpotCoins',m);return end;if r and r.kind=='Coin'then sound(r.data.Face and'CoinRevealFace'or'CoinRevealPile',m)elseif r and r.kind=='Reels'then sound('Jackpot'..r.data.Reward,m)end;clearCast(m)
 elseif k=='DiceImpact'then sound(d.A==d.B and'DiceDouble'or'DiceSettle',m);spark((frame()*CFrame.new(d.Position)).Position,GOLD,15)
 elseif k=='Clover'then if clovers[m]then clovers[m].model:Destroy()end;clovers[m]={model=Assets.Model('Clover',root),start=Clock.Time(m),duration=d.Duration};sound('CloverReady',m)
 elseif k=='Dodge'or k=='CloverExpire'then if clovers[m]then clovers[m].model:Destroy();clovers[m]=nil end;sound(k=='Dodge'and'CloverDodge'or'CloverExpire',m);if k=='Dodge'then spark(pos(m),GOLD,10)end
 elseif k=='Volley'then poses[m]=nil;casts[m]={kind='Volley',folder=make('Folder',{},root),start=Clock.Time(m),id=d.Activation}
 elseif k=='Heal'then local p=pos(m);if p then for i=1,(low and 2 or 4)do local start=p+Vector3.new((i-2)*.65,4.5,0);local a=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CFrame=CFrame.new(start)},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(24,24),AlwaysOnTop=false,Adornee=a},a);make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='♥',Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=Color3.fromRGB(120,244,135)},g);particles[#particles+1]={part=a,start=os.clock(),p=start,v=p-start}end;spark(p,Color3.fromRGB(115,238,136),12);local a=make('Part',{Size=Vector3.one*.05,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CFrame=CFrame.new(p)},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(110,36),AlwaysOnTop=true,Adornee=a},a);make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=d.AtMax and'PV MAX'or('+'..tostring(d.Amount)),Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=Color3.fromRGB(120,244,135)},g);particles[#particles+1]={part=a,start=os.clock(),p=p,v=Vector3.new(0,2,0)}end
 elseif k=='Cheat'then sound('JackpotCheat',m);spark(pos(d.Target),PURPLE,13)
 elseif k=='Unsupported'then warn('LuckyCrax : '..tostring(d.Reason))end
end)
local accumulated=0
connect(Run.Heartbeat,function(dt)
 accumulated+=dt;if accumulated<(low and 1/20 or 1/30)then return end;accumulated=0;local now=os.clock()
 for id,p in pairs(coins)do if not p.owner.Parent then p.model:Destroy();coins[id]=nil else local t=Clock.Time(p.owner)-p.start;p.model:PivotTo(frame()*CFrame.new(p.position)*CFrame.Angles(-math.pi/2,0,t*10))end end
 for m,r in pairs(casts)do
  if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then clearCast(m);restorePose(m)
  else local t=Clock.Time(m)-r.start;local h=head(m)
   if r.kind=='Coin'then r.coin:PivotTo(frame()*h.CFrame*CFrame.new(0,1,-5)*CFrame.Angles(-math.pi/2+t*16,0,t*4))
   elseif r.kind=='Dice'then local bounce=math.min(2,math.floor(t/math.max(.1,C.DiceDuration-.3)*3));if bounce>0 and bounce~=(r.bounce or 0)then sound('DiceBounce',m);r.bounce=bounce end;for i,die in ipairs(r.dice)do local u=math.clamp(t/math.max(.1,C.DiceDuration-.3),0,1);local target=(frame()*CFrame.new(r.data.Position)).Position;local start=(frame()*h.CFrame*CFrame.new(i==1 and-4 or 4,1,-3)).Position;local p=start:Lerp(target+frame():VectorToWorldSpace(Vector3.new(i==1 and-1 or 1,0,0)),u)+frame():VectorToWorldSpace(Vector3.new(0,math.abs(math.sin(u*math.pi*3))*(1-u)*3,0));local spin=(1-u)^2*math.pi*8;die:PivotTo(CFrame.new(p)*CFrame.Angles(spin,spin*.7,spin*.5)*faceRotation[i==1 and r.data.A or r.data.B])end
   elseif r.kind=='Reels'then updateReel(r.reels,m,t,r.data.Reward,C.ReelsDuration);Audio.Pause(r.loop,Clock.Paused(m))
   elseif r.kind=='Volley'then mouthPose(m,math.sin(math.min(1,t/.15)*math.pi*.5));if t>.8 then clearCast(m);restorePose(m)end end
  end
 end
 for m,r in pairs(clovers)do if not m.Parent or(m:GetAttribute('Health')or 0)<=0 or m:GetAttribute('LuckyTricked')then r.model:Destroy();clovers[m]=nil else r.model:PivotTo(frame()*head(m).CFrame*CFrame.new(5,1,-1)*CFrame.Angles(-math.pi/2,0,(Clock.Time(m)-r.start)*.7))end end
 for _,name in ipairs({'Fighter1','Fighter2'})do local m=workspace:FindFirstChild(name);if m then local remain=m:GetAttribute('LuckyCheatRemaining');if remain then
  if not cheats[m]then local folder=make('Folder',{Name='LuckyCheatLinks'},root);local g=make('BillboardGui',{Size=UDim2.fromOffset(150,35),AlwaysOnTop=true,Adornee=head(m),StudsOffsetWorldSpace=Vector3.new(0,-head(m).Size.Y*.65,0)},folder);make('TextLabel',{Name='Countdown',Size=UDim2.fromScale(1,1),BackgroundTransparency=.2,BackgroundColor3=Color3.fromRGB(44,18,65),TextColor3=GOLD,TextScaled=true,Font=Enum.Font.FredokaOne},g);local r={folder=folder,gui=g,cards={},start=Clock.Time(m)};cheats[m]=r
   for i=1,(low and 2 or 3)do local card=make('Part',{Name='TrickedJoker',Size=Vector3.new(.65,.9,.09),Color=PURPLE,Material=Enum.Material.SmoothPlastic,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},folder);local face=make('BillboardGui',{Size=UDim2.fromOffset(22,30),AlwaysOnTop=false,Adornee=card},card);make('TextLabel',{Size=UDim2.fromScale(1,1),Text=i==1 and'⊘'or'J',Font=Enum.Font.FredokaOne,TextScaled=true,TextColor3=GOLD,BackgroundTransparency=1},face);r.cards[i]=card end
  end
  local r=cheats[m];r.gui.Countdown.Text='TRICHE '..math.ceil(remain)..' s';local h=head(m);for i,card in ipairs(r.cards)do local angle=(Clock.Time(m)-r.start)*1.5+i*math.pi*2/#r.cards;local radius=math.max(h.Size.X,h.Size.Y)*.5+.8;card.CFrame=frame()*h.CFrame*CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,-1)*CFrame.Angles(0,0,math.sin(angle)*.25)end
  elseif cheats[m]then cheats[m].folder:Destroy();cheats[m]=nil;sound('CheatEnd',m)end end end
 for i=#particles,1,-1 do local p=particles[i];local t=(now-p.start)/.65;if t>=1 then p.part:Destroy();table.remove(particles,i)else p.part.Position=p.p+p.v*t;p.part.Transparency=t end end
end)
local function clearAll()clearCombat();stopScene();Audio.Clear();for _,p in ipairs(particles)do p.part:Destroy()end;particles={}end
for _,key in ipairs({'RoundId','CraxMatchToken'})do connect(state:GetAttributeChangedSignal(key),function()clearAll();seen=nil end)end
connect(state:GetAttributeChangedSignal('Phase'),function()if state:GetAttribute('Phase')~='Fighting'then clearCombat();Audio.Clear();if state:GetAttribute('Phase')~='RoundOver'then clearAll()end end;task.defer(beginScene)end)
for _,key in ipairs({'RoundVictoryRound','RoundVictoryStartedAt','RoundVictoryKind'})do connect(state:GetAttributeChangedSignal(key),function()task.defer(beginScene)end)end
connect(player:GetAttributeChangedSignal('ArenaSeat'),function()clearAll();seen=nil end)
connect(script.Destroying,function()clearAll();for _,c in ipairs(connections)do c:Disconnect()end;root:Destroy()end)
task.defer(beginScene)
