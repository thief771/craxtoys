import fs from'node:fs';import{LuauState}from'luau-web';const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
let base=read('tests/super_installer_fixture.lua').split('local V={}')[0];base=base.replace("  if key=='GetPivot'then", "  if key=='ScaleTo'then return function(_,s)values.Scale=s end end\n  if key=='GetPivot'then");
const extension=read('tests/super_client_extension.lua')+`
fx.Name='CraxLuckyFX';configObject.Name='CraxLuckyConfig';a:SetAttribute('CraxId','Crax_Lucky');Vector3.zero=Vector3.new(0,0,0);Vector2.zero=Vector2.new(0,0);UDim={new=function()return{}end};UDim2.new=function()return{}end;Enum.ScaleType={Fit=1};Enum.Material.Metal=2;Enum.PartType={Ball=1};Color3.new=Color3.fromRGB
local audioObject=create('ReplicatedStorage.CraxLuckyAudio','ModuleScript');local assetsObject=create('ReplicatedStorage.CraxLuckyAssets','ModuleScript');local played={};local audio={Play=function(name)played[name]=(played[name]or 0)+1;return{}end,Stop=function()end,Pause=function()end,Clear=function()end}
local assets={Model=function(kind,parent)local m=new('Model');m.Name='Lucky'..kind;m.Parent=parent;local p=new('MeshPart');p.Name='Visual';p.Parent=m;return m end}
function CF:ToObjectSpace(v)return v end
local health=create('Workspace.Fighter1.Head.HealthBar','BillboardGui');health.Size={Y={Offset=40}};health.StudsOffsetWorldSpace=Vector3.new(0,5,0)
`;
const asserts=`
local n=0;local function check(v,msg)n+=1;assert(v,msg)end
local folder=workspace:FindFirstChild('LuckyCrax_Local');check(folder~=nil,'local root created')
local function fire(k,d)d=d or{};d.Round=1;d.Match='client-match';d.Owner=d.Owner or a;d.Activation=d.Activation or 1;fx.OnClientEvent:Fire(k,d)end
fx.OnClientEvent:Fire('Cast',{Owner=a,Round=999,Match='client-match',Kind='Coin'});check(#folder:GetChildren()==0,'old round rejected')
fire('Cast',{Kind='Coin',Face=true});heartbeat:Fire(.1);fire('CastEnd');check(played.CoinFlip==1 and played.CoinRevealFace==1,'server Face reveal cue')
fire('Coin',{Id=4,Position=Vector3.new(0,25,0)});heartbeat:Fire(.1);check(folder:FindFirstChild('LuckyCoin')~=nil,'authored coin library requested');fire('Bounce',{Position=Vector3.new(2,25,0)});fire('CoinEnd',{Id=4});check(not folder:FindFirstChild('LuckyCoin'),'projectile removed')
fire('Cast',{Kind='Dice',A=6,B=6,Position=Vector3.new(0,25,0)});heartbeat:Fire(.1);fire('DiceImpact',{A=6,B=6,Position=Vector3.new(0,25,0)});fire('CastEnd');check(played.DiceDouble==1,'double cue comes from authoritative result')
fire('Cast',{Kind='Reels',Reward='Cheat'});heartbeat:Fire(.1);local windows=0;local strips=0;for _,o in ipairs(folder:GetDescendants())do if o.ClassName=='Frame'and o.ClipsDescendants then windows+=1;strips+=#o:GetChildren()end end;check(windows==3 and strips==3,'exactly three clipped reel windows');fire('CastEnd');check(played.JackpotCheat==1,'revealed reward matches server')
fire('Clover',{Duration=4});heartbeat:Fire(.1);check(folder:FindFirstChild('LuckyClover')~=nil,'four-leaf authored model');fire('Dodge');check(not folder:FindFirstChild('LuckyClover'),'one dodge consumes visible charge')
fire('Volley');fire('CastEnd');heartbeat:Fire(.1);check(played.JackpotCoins==1,'volley reveal keeps mouth pose alive')
fire('Heal',{Amount=15});fire('Heal',{AtMax=true,Amount=0});local texts={};for _,o in ipairs(folder:GetDescendants())do if o.ClassName=='TextLabel'then texts[o.Text]=true end end;check(texts['+15']and texts['PV MAX'],'actual capped heal display')
fire('Clear');check(heartbeat:Count()==1,'one bounded presentation loop')
a:SetAttribute('CraxSkillLevel',4)
for k,v in pairs({Phase='RoundOver',RoundWinner='Fighter1',RoundVictoryKind='LuckyFinale',RoundVictoryRound=1,LuckyVictoryMatch='client-match',RoundVictoryStartedAt=0})do state:SetAttribute(k,v)end
stateSignals.RoundVictoryStartedAt:Fire();check(render~=nil,'valid MAX starts dedicated scene');check(player:GetAttribute('LuckyCameraOwner')~=nil,'camera ownership claimed')
now=2.5;render();check(cam.CameraType==Enum.CameraType.Scriptable,'exclusive camera active')
now=6.5;render();local f=folder:FindFirstChild('LuckyFinale');local hidden=false;for _,o in ipairs(f:GetDescendants())do if o.Name=='Fighter2'then hidden=o.Head.LocalTransparencyModifier==1 end end;check(hidden,'cosmetic victim hidden after result')
now=9.1;render();check(render==nil and player:GetAttribute('LuckyCameraOwner')==nil,'MAX camera released');check(cam.CameraType=='Custom'and cam.FieldOfView==70,'camera and FOV restored');check(a.Head.LocalTransparencyModifier==0 and b.Head.LocalTransparencyModifier==0,'originals restored')
state:SetAttribute('RoundId',2);state:SetAttribute('RoundVictoryRound',2);state:SetAttribute('RoundVictoryStartedAt',now);stateSignals.RoundId:Fire();stateSignals.RoundVictoryStartedAt:Fire();check(render~=nil,'next round starts fresh scene');player:SetAttribute('ArenaSeat',nil);seatSignal:Fire();check(render==nil and player:GetAttribute('LuckyCameraOwner')==nil,'seat departure restores camera and scene');check(a.Head.LocalTransparencyModifier==0 and b.Head.LocalTransparencyModifier==0,'seat departure restores originals')
script.Destroying:Fire();check(heartbeat:Count()==0 and fx.OnClientEvent:Count()==0 and seatSignal:Count()==0,'all loop/event connections disconnected');check(not workspace:FindFirstChild('LuckyCrax_Local'),'presentation destroyed');print('LUCKY REAL CLIENT LIFECYCLE PASS',n,'assertions')
`;
const source=`${base}\n${read('tests/client_fixture.lua')}\n${extension}\nlocal Config=(function()${read('src/luckycrax/CraxLuckyConfig.lua')}end)()\nrequire=function(o)if o==configObject then return Config elseif o==audioObject then return audio elseif o==assetsObject then return assets elseif o==clockObject then return {Paused=function()return false end,Time=function()return now end}end;error('unexpected require')end\ndo\n${read('src/luckycrax/CraxLuckyClient.client.lua')}\nend\n${asserts}`;
const state=await LuauState.createAsync({print:console.log,warn:console.log});await state.loadstring(source,'lucky-real-client',true)();state.destroy();
