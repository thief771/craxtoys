import fs from 'node:fs';
import path from 'node:path';
import {pathToFileURL} from 'node:url';
const root=path.resolve(import.meta.dirname,'..');
const {LuauState}=process.env.LUAU_WEB_PATH?await import(pathToFileURL(process.env.LUAU_WEB_PATH)):await import('luau-web');
const state=await LuauState.createAsync({print:console.log});
const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const long=s=>'[========['+s+']========]';
let compiled=0;
function compileDir(dir){for(const f of fs.readdirSync(path.join(root,dir),{withFileTypes:true})){const p=dir+'/'+f.name;if(f.isDirectory())compileDir(p);else if(p.endsWith('.lua')){state.loadstring(read(p),p,true);compiled++;}}}
compileDir('src/invertedcrax');compileDir('integration/invertedcrax');console.log('COMPILE PASS',compiled,'complete Luau scripts');
let checks=0;
const rules=read('src/invertedcrax/CraxInvertedRules.lua');
const fantastic=read('integration/invertedcrax/patched/ServerScriptService/FantasticSchedule.lua');
const fleau=read('integration/invertedcrax/patched/ReplicatedStorage/CraxFleau/FleauRules.lua');
const pure=`
local R=(function() ${rules} end)()
local tests=0
local function check(v,message)tests+=1;assert(v,message)end
local function context(r)return {round=r.round,identity=r.identity,active=true,alive=true,health=95,position='saved-position'}end
local function random(a,b)check(a==5 and b==9,'server interval');return 7 end
for _,damage in ipairs({5,8,12,25})do
 local r=R.New(11,'fighter',2,random)
 check(not R.Received(r,999,false),'power never counted')
 check(not R.Received(r,0,true),'blocked melee never counted')
 R.Received(r,100,true);R.Received(r,200,true)
 check(R.Received(r,damage,true),'third received')
 check(r.pending==damage,'third hit, not maximum')
 check(R.Base(r)==math.max(8,damage),'copy replaces base')
 check(not R.Received(r,300,true),'no queued second copy')
 check(not R.Consume(r,0,true),'blocked attack preserves copy')
 check(R.Consume(r,8,true),'successful attack consumes once')
 check(not R.Consume(r,8,true)and r.count==0,'single consume and reset')
end
check(R.Damage(8,true)==9,'8*1.10 rounds 9')
check(R.Damage(12,true)==13,'12*1.10 rounds 13')
check(R.Damage(0,true)==0,'no protected damage created')
check(R.Damage(8,false)==8,'base damage')
local r=R.New(3,'identity',3,random);local c=context(r);local marks,restores,mutes=0,0,0
for i=1,2400 do
 c.health=i<1200 and 95 or 30;c.position=i<1200 and'old'or'new'
 local e=R.Advance(r,1/120,c,random)
 if e.mark then marks+=1;check(math.abs(r.time-10)<1e-6,'mark at 10');check(e.mark.health==30,'health at marking instant');check(e.mark.position=='new','exact position')end
 if e.restore then restores+=1;check(math.abs(r.time-20)<1e-6,'return at 20');check(e.restore.health==30 and e.restore.position=='new','snapshot preserved')end
 if e.mute then mutes+=1 end
end
check(marks==1 and restores==1 and mutes==2,'single ctrl cycle')
local dead=R.New(4,'f',3,random);local dc=context(dead);R.Advance(dead,10,dc,random);dc.alive=false
local e=R.Advance(dead,10,dc,random);check(e.cancel and not e.restore and not dead.alive,'death cancels no resurrection')
local stale=R.New(4,'f',3,random);local sc=context(stale);R.Advance(stale,10,sc,random);sc.round=5;e=R.Advance(stale,10,sc,random);check(e.cancel and not e.restore,'old round invalidated')
local changed=R.New(4,'f',3,random);local cc=context(changed);cc.identity='other';R.Advance(changed,20,cc,random);check(not changed.alive,'identity invalidation')
local paused=R.New(4,'f',3,random);local pc=context(paused);pc.paused=true;R.Advance(paused,100,pc,random);check(paused.time==0,'paused active clock')
local silenced=R.New(4,'f',3,random);local si=context(silenced);si.silenced=true;e=R.Advance(silenced,10,si,random);check(not e.mute and e.markSkipped and silenced.mark==nil,'silence blocks new start at 10')
si.silenced=false;e=R.Advance(silenced,10,si,random);check(not e.mark and not e.restore,'lost marking not delayed')
local marked=R.New(4,'f',3,random);local mc=context(marked);R.Advance(marked,10,mc,random);mc.silenced=true;e=R.Advance(marked,10,mc,random);check(e.restore~=nil,'existing mark continues under silence')
local s=R.ApplyStatus(nil,1,true);s=R.ApplyStatus(s,2,true);check(s.silence==7 and s.vulnerable==7 and s.hack==6,'refresh without stacking')
local F=(function() ${fantastic} end)();local f=F.New(3,function()return 1 end)
f.reinforce=1;f.torch=1;f.torchPending=1;f.reinforceWait=0;f.elasticWait=0
local fe=F.Step(f,1,false,1,false);check(fe.reinforceEnd and fe.torchEnd,'active effects finish under silence');check(not fe.reinforceStart and not fe.torchStart and not fe.elasticStart,'new Fantastic starts blocked')
local L=(function() ${fleau} end)();local l=L.New(3);l.mode='Windup';l.time=1.9
local le=L.Tick(l,.2,function()return 0 end,false);check(le.charge and l.mode=='Charge','existing windup completes')
local n=L.New(3);n.elapsed=10;n.queue={30};le=L.Tick(n,.1,function()return 0 end,false);check(not le.giant and not le.windup,'new Fleau thresholds blocked')
print('PURE RULES PASS',tests,'assertions')
return tests
`;
const result=await state.loadstring(pure,'inverted-rules-tests',true)();checks+=Number(Array.isArray(result)?result[0]:result)||0;
// Evaluate the actual catalog sources with only service/value stand-ins.
const pbase='integration/invertedcrax/patched/';
const load=p=>`(function()\n${read(pbase+p)}\nend)()`;
const catalogs=`
local passed=0
local function check(v,m)passed+=1;assert(v,m)end
Color3={fromRGB=function(r,g,b)return {R=r/255,G=g/255,B=b/255}end}
local modules={};local rs={CraxCatalog='catalog',CraxInvertedConfig='invertedConfig',CraxFleau={FleauRules='fleau'}}
function rs:WaitForChild(n)return self[n]end
game={GetService=function()return rs end};require=function(id)return assert(modules[id],tostring(id))end
modules.invertedConfig={FinaleDuration=10.5}
modules.fleau=(function()${fleau}end)()
local cat=${load('ReplicatedStorage/CraxCatalog.lua')};modules.catalog=cat
check(cat.Crax_Inverted.MaxHealth==120,'120 HP');check(cat.Crax_Inverted.CollisionDamage==8,'8 melee');check(cat.Crax_Inverted.Speed==cat.Crax_Monster.Speed,'reference speed');check(cat.Crax_Inverted.Rarity=='Épique','epic rarity')
local skills=${load('ReplicatedStorage/CraxSkillCatalog.lua')}
for i,u in ipairs(skills.Crax_Inverted.Upgrades)do check(u.Coins==skills.Crax_Monster.Upgrades[i].Coins and u.Gems==skills.Crax_Monster.Upgrades[i].Gems,'existing price grid');check(u.TrophyId==nil,'no invented trophy')end
check(#skills.Crax_Inverted.Upgrades==4,'four levels')
local casino=${load('ReplicatedStorage/CraxRouletteConfig.lua')}
local originalCasino=(function()${JSON.parse(read('tests/fixtures/inspected-export.json')).scripts[3].source}end)()
local function sums(c)local s={}for _,e in ipairs(c.Pool)do local r=cat[e.Id].Rarity;s[r]=(s[r]or 0)+e.Weight end return s end
local a,b=sums(casino),sums(originalCasino)
for r,v in pairs(a)do check(math.abs(v-b[r])<1e-6,'rarity probability unchanged: '..r)end
local found=0;for _,e in ipairs(casino.Pool)do if e.Id=='Crax_Inverted'then found+=1;check(e.Weight>0,'positive drop weight')end end;check(found==1,'one casino entry')
local victory=${load('ReplicatedStorage/CraxVictoryCatalog.lua')}
check(victory.Crax_Inverted.MinimumLevel==4 and victory.Crax_Inverted.Id=='Inverted404','MAX victory');check(victory.Crax_Inverted.TrophyId==nil,'no new trophy')
print('CATALOG PASS',passed,'assertions');return passed
`;
const cr=await state.loadstring(catalogs,'real-catalog-tests',true)();checks+=Number(Array.isArray(cr)?cr[0]:cr)||0;
const runtimeHarness=`local Rules=(function()${rules}end)()\nlocal Silence=(function()${read('src/invertedcrax/CraxSilenceGate.lua')}end)()\n${read('tests/runtime_fixture.lua')}\nlocal Runtime=(function()${read('src/invertedcrax/CraxInvertedRuntime.lua')}end)()\n${read('tests/runtime_assertions.lua')}`;
const rr=await state.loadstring(runtimeHarness,'actual-runtime-fixture',true)();checks+=Number(Array.isArray(rr)?rr[0]:rr)||0;
const healthHarness=`local Rules=(function()${rules}end)()\nlocal Silence=(function()${read('src/invertedcrax/CraxSilenceGate.lua')}end)()\n${read('tests/runtime_fixture.lua')}\nlocal Runtime=(function()${read('src/invertedcrax/CraxInvertedRuntime.lua')}end)()\n${read('tests/health_fixture.lua')}\ndo\n${read('integration/invertedcrax/patched/ServerScriptService/CombatHealth.lua')}\nend\n${read('tests/health_assertions.lua')}`;
const hr=await state.loadstring(healthHarness,'actual-combat-health-fixture',true)();checks+=Number(Array.isArray(hr)?hr[0]:hr)||0;
console.log('TOTAL ASSERTIONS',checks);state.destroy();
