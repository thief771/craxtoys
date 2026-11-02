local n=0;local function check(v,msg)n+=1;assert(v,msg)end
local folder=workspace:FindFirstChild('SuperCrax_LocalPresentation');check(folder~=nil,'local presentation root')
local function fire(kind,d)d=d or{};d.Round=1;d.Match='client-match';d.Owner=d.Owner or a;d.Activation=d.Activation or'test';fx.OnClientEvent:Fire(kind,d)end
local before=#folder:GetChildren()
fx.OnClientEvent:Fire('Start',{Round=99,Match='client-match',Owner=a,Kind='Dash'});check(#folder:GetChildren()==before,'stale round rejected')
fire('Start',{Kind='Dash'});heartbeat:Fire(.1);check(a.Head.Material==Enum.Material.Metal,'dash steel uses real head');fire('Stop');check(a.Head.Material==1,'dash restores original material');check(#folder:GetChildren()==before,'dash trail cleaned')
fire('Start',{Kind='Laser'});check(#folder:GetChildren()>before,'actual beam GUI-free objects created');fire('State',{Beams={{From=Vector3.new(0,0,0),To=Vector3.new(10,0,0)},{From=Vector3.new(0,0,0),To=Vector3.new(10,5,0)}}});heartbeat:Fire(.1);fire('Stop');check(#folder:GetChildren()==before,'laser beam endpoints cleaned')
for i=1,3 do fire('Start',{Kind='Frost'});heartbeat:Fire(.1);fire('FrostFire');fire('Stop')end
check(#folder:GetChildren()==before,'repeated frost clears guide endpoints and wind')
fire('Freeze',{Owner=b});check(#folder:GetChildren()>before,'ice envelope created');fire('Thaw',{Owner=b});check(#folder:GetChildren()==before,'thaw cleans envelope')
fire('Crystal',{Position=Vector3.new(12,12,0),Radius=1.6});fire('Pickup',{Carrier=b});heartbeat:Fire(.1);fire('Clear');check(#folder:GetChildren()==before,'crystal and carrier visual cleaned')
a:SetAttribute('CraxSkillLevel',4)
for k,v in pairs({Phase='RoundOver',RoundWinner='Fighter1',RoundVictoryKind='SuperFinale',RoundVictoryRound=1,SuperVictoryCrax='Crax_Super',SuperVictoryLevel=4,SuperVictoryMatch='client-match',RoundVictoryStartedAt=0})do state:SetAttribute(k,v)end
stateSignals.RoundVictoryStartedAt:Fire();check(render~=nil,'MAX creates dedicated render callback')
local cameraType=cam.CameraType;now=3.6;render();check(cam.CameraType==Enum.CameraType.Scriptable,'MAX camera taken for valid winner only')
now=5.6;render();local sceneFolder=folder:FindFirstChild('SuperFinale');check(sceneFolder~=nil,'MAX uses local clones')
local hiddenClone=false;for _,o in ipairs(sceneFolder:GetDescendants())do if o.Name=='Fighter2'then hiddenClone=o.Head.LocalTransparencyModifier==1 end end;check(hiddenClone,'whole victim disappears into fragments after shot')
now=8.21;render();check(render==nil,'MAX releases callback at declared8.2sec');check(cam.CameraType=='Custom'and cam.FieldOfView==70,'MAX restores camera state');check(a.Head.LocalTransparencyModifier==0 and b.Head.LocalTransparencyModifier==0,'MAX restores original heads')
check(heartbeat:Count()==1,'one throttled loop');script.Destroying:Fire();check(heartbeat:Count()==0,'loop disconnected');check(fx.OnClientEvent:Count()==0,'remote disconnected');check(not workspace:FindFirstChild('SuperCrax_LocalPresentation'),'local presentation root destroyed')
print('SUPER ACTUAL CLIENT LIFECYCLE PASS',n,'assertions')
