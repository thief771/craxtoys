import fs from'node:fs';import{LuauState}from'luau-web';const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
const base=read('tests/super_installer_fixture.lua').split('local V={}')[0];
const extension=read('tests/super_client_extension.lua')+`\nfx.Name='CraxSymFX';configObject.Name='CraxSymConfig';local audioObject=create('ReplicatedStorage.CraxSymAudio','ModuleScript');local played={};local audio={Play=function(name)played[name]=(played[name]or 0)+1;return{}end,Stop=function()end,Pause=function()end,Clear=function()end};a:SetAttribute('CraxId','Crax_Symbioti')\n`;
const asserts=`
local n=0;local function check(v,msg)n+=1;assert(v,msg)end
local folder=workspace:FindFirstChild('SymbiotiCrax_Local');check(folder~=nil,'local root created')
local function fire(k,d)d=d or{};d.Round=1;d.Match='client-match';d.Owner=d.Owner or a;d.Activation=d.Activation or 1;fx.OnClientEvent:Fire(k,d)end
fx.OnClientEvent:Fire('TongueStart',{Owner=a,Round=999,Match='client-match'});check(#folder:GetChildren()==0,'old round rejected')
fire('TongueStart');fire('TongueState',{Mode='Extend',Position=Vector3.new(8,25,0)});heartbeat:Fire(.1);check(#folder:GetChildren()>0,'continuous tongue chain constructed')
fire('Capture');fire('TongueState',{Mode='Pull',Position=Vector3.new(5,25,0),Target=b});heartbeat:Fire(.1);fire('Bite',{Target=b,Damage=16});fire('TongueStop');check(played.Capture==1 and played.Bite==1,'successful capture and bite sound hooks')
fire('TongueStart');fire('Miss');fire('TongueStop');check(played.TongueMiss==1,'miss is distinct from bite')

local function coating()for _,v in ipairs(folder:GetChildren())do if v.Name=='SymContamination'then return v end end end
local visible={}
for count=1,2 do
 fire('Marks',{Target=b,Count=count});heartbeat:Fire(.1)
 local coat=coating();check(coat and coat:GetAttribute('Stacks')==count,'contamination stage delivered')
 visible[count]=0;for _,p in ipairs(coat:GetChildren())do if p.Name=='Coat'and p.Transparency<1 then visible[count]+=1 end end
 check(visible[count]>0,'face coverage visible')
 local tendrils=0;for _,p in ipairs(coat:GetChildren())do if p.Name=='Tendril'then tendrils+=1 end end;check(tendrils>0,'animated small tendrils created')
end
check(visible[2]==visible[1]*2,'second stack covers twice the first surface')
fire('Burst',{Target=b});heartbeat:Fire(.1);local full=coating();check(full:GetAttribute('Stacks')==3 and full:GetAttribute('Terminal'),'third stage retained visually after server consumes marks')
local total=0;for _,p in ipairs(full:GetChildren())do if p.Name=='Coat'and p.Transparency<1 then total+=1 end end;check(total==visible[1]*3,'third stage covers all three sectors')
now=.8;heartbeat:Fire(.1);check(not coating(),'terminal full-face stage expires after burst');now=0;fire('Marks',{Target=b,Count=1});
fire('OwnerClear');check(not coating(),'owner cleanup removes all contamination geometry')
fire('Marks',{Target=b,Count=2});heartbeat:Fire(.1);
fire('Marks',{Target=b,Count=0});fire('ParasiteStart');fire('ParasiteState',{Position=Vector3.new(10,25,0),Mode='Attached'});heartbeat:Fire(.1);fire('ParasiteMerge');fire('Armour',{Active=true});fire('ArmourHit');fire('Armour',{Active=false});check(played.ParasiteMerge==1 and played.ArmourHit==1,'parasite and armour sound hooks')
fire('Clear');check(heartbeat:Count()==1,'one bounded presentation loop')
a:SetAttribute('CraxSkillLevel',4)
for k,v in pairs({Phase='RoundOver',RoundWinner='Fighter1',RoundVictoryKind='SymFinale',RoundVictoryRound=1,SymVictoryCrax='Crax_Symbioti',SymVictoryLevel=4,SymVictoryMatch='client-match',RoundVictoryStartedAt=0})do state:SetAttribute(k,v)end
stateSignals.RoundVictoryStartedAt:Fire();check(render~=nil,'valid MAX starts dedicated scene');check(player:GetAttribute('SymCameraOwner')~=nil,'camera ownership claimed')
now=2.5;render();check(cam.CameraType==Enum.CameraType.Scriptable,'exclusive camera active')
now=5.2;render();local sceneFolder=folder:FindFirstChild('SymFinale');local hidden=false;for _,o in ipairs(sceneFolder:GetDescendants())do if o.Name=='Fighter2'then hidden=o.Head.LocalTransparencyModifier==1 end end;check(hidden,'complete victim removed at bite')
now=9.1;render();check(render==nil and player:GetAttribute('SymCameraOwner')==nil,'camera ownership released');check(cam.CameraType=='Custom'and cam.FieldOfView==70,'camera and FOV restored');check(a.Head.LocalTransparencyModifier==0 and b.Head.LocalTransparencyModifier==0,'originals restored exactly')
state:SetAttribute('RoundId',2);state:SetAttribute('RoundVictoryRound',2);state:SetAttribute('RoundVictoryStartedAt',now);stateSignals.RoundId:Fire();stateSignals.RoundVictoryStartedAt:Fire();check(render~=nil,'new round permits one new MAX');state:SetAttribute('Phase','Preparing');stateSignals.Phase:Fire();check(render==nil and player:GetAttribute('SymCameraOwner')==nil,'interruption releases camera');check(a.Head.LocalTransparencyModifier==0 and b.Head.LocalTransparencyModifier==0,'interruption restores original visibility')
script.Destroying:Fire();check(heartbeat:Count()==0 and fx.OnClientEvent:Count()==0,'all loop and network connections disconnected');check(not workspace:FindFirstChild('SymbiotiCrax_Local'),'all presentation destroyed');print('SYM REAL CLIENT LIFECYCLE PASS',n,'assertions')
`;
const source=`${base}\n${read('tests/client_fixture.lua')}\n${extension}\nlocal os={clock=function()return now end}\nlocal Config=(function()${read('src/symbioticrax/CraxSymConfig.lua')}end)()\nrequire=function(o)if o==configObject then return Config elseif o==audioObject then return audio elseif o==clockObject then return {Paused=function()return false end}end;error('unexpected require')end\ndo\n${read('src/symbioticrax/CraxSymClient.client.lua')}\nend\n${asserts}`;
const state=await LuauState.createAsync({print:console.log});await state.loadstring(source,'sym-real-client',true)();state.destroy();
