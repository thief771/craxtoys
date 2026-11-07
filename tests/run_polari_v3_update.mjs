import fs from 'node:fs';
import {LuauState} from 'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
const q=s=>JSON.stringify(s);
const payload=JSON.parse(read('integration/polaricrax/v3/payload.json'));
const script=read('integration/polaricrax/v3/METTRE_A_JOUR_POLARICRAX_V3.lua');
let lua=read('tests/super_installer_fixture.lua').split('local V={}')[0].replace("  if key=='GetPivot'then","  if key=='GetFullName'then return function()return object.Name end end\n  if key=='GetPivot'then");
lua+=`\nlocal ses=create('ScriptEditorService','ScriptEditorService');local concurrent\nfunction ses:GetEditorSource(o)return o.Source end\nfunction ses:UpdateSourceAsync(o,fn)if concurrent==o then concurrent=nil;o.Source=o.Source..'-- user concurrent edit' end;o.Source=fn(o.Source)end\nlocal b=create('ServerStorage.PolariCrax_Backup_V1','Folder');b:SetAttribute('PolariOwned',true);b:SetAttribute('Incomplete',false);b:SetAttribute('PolariRevision',2)\nlocal entries=create('ServerStorage.PolariCrax_Backup_V1.Entries','Folder');local originals={}\nlocal function record(path,source)local o=create(path,path:find('StarterPlayer',1,true)and'LocalScript'or'ModuleScript');o.Source=source;originals[path]=source;local e=new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);local v=new('StringValue');v.Name='Original';v.Value='';v.Parent=e;local a=new('StringValue');a.Name='Installed';a.Value=source;a.Parent=e;e.Parent=entries;return o end\n`;
for(const m of payload.modules){lua+=`record(${q(m.path)},${q('-- installed v1 '+m.path)})\n`;}
for(const w of payload.wraps)lua+=`record(${q(w.path)},'return {Crax_Polari={Upgrades={{},{},{},{}}},PolariAttract={}}')\n`;
lua+=`local deadly=record('ServerScriptService.CraxDeadlyRuntime','-- installed gameplay');deadly.Source='-- user gameplay change';originals['ServerScriptService.CraxDeadlyRuntime']=deadly.Source;local deadlyEntry=entries:GetChildren()[#entries:GetChildren()];local deadlyOriginal=deadlyEntry.Original.Value;local deadlyInstalled=deadlyEntry.Installed.Value\n`;
lua+=`local motion=create('ServerScriptService.ArenaMovement','Script');motion.Source='PolariV1.Pump(deltaTime,fighters) PolariV1.Step( PolariV1.WallContact('\nlocal function update()\n${script}\nend\n`;
lua+=`local initialCount=#entries:GetChildren();local target=create('ReplicatedStorage.CraxPolariVFX','ModuleScript')\nfailure=target;check(not pcall(update),'injected write failure rolls back');for path,source in pairs(originals)do check(create(path,'ModuleScript').Source==source,'original restored '..path)end;check(#entries:GetChildren()==initialCount,'backup entries preserved on failure');check(not game.ServerStorage:FindFirstChild('PolariCrax_Update_V3_Safety'),'clean rollback removes temporary safety folder')\nconcurrent=target;check(not pcall(update),'concurrent edit stops update');check(target.Source:find('user concurrent edit',1,true),'concurrent edit preserved');check(b:GetAttribute('Incomplete'),'conflict marks backup incomplete');check(game.ServerStorage:FindFirstChild('PolariCrax_Update_V3_Safety')~=nil,'conflict retains recovery folder')\n`;
const state=await LuauState.createAsync({print:console.log,warn:console.log});
try{await state.loadstring(lua,'polari-update-failure-and-concurrency',true)();}finally{state.destroy();}
// Fresh fixture: successful application, repeatability, and original-uninstaller compatibility.
let success=lua.slice(0,lua.indexOf('local initialCount='));
success+=`b:SetAttribute('PolariRevision',1);check(not pcall(update),'V1 requires gameplay V2 before presentation V3');check(not game.ServerStorage:FindFirstChild('PolariCrax_Update_V3_Safety'),'V1 rejection writes nothing');b:SetAttribute('PolariRevision',2);update();check(b:GetAttribute('PolariRevision')==3,'V3 revision saved');check(not game.ServerStorage.PolariCrax_Update_V3_Safety:GetAttribute('Incomplete'),'complete safety backup');local count=#entries:GetChildren();update();check(#entries:GetChildren()==count,'repeat creates no duplicates');for _,e in ipairs(entries:GetChildren())do local o=game;for key in e:GetAttribute('Path'):gmatch('[^.]+')do o=o:FindFirstChild(key)end;if e~=deadlyEntry then check(o.Source==e.Installed.Value,'updated presentation backup matches installed source')end end\n`;
for(const m of payload.modules)success+=`check(create(${q(m.path)},${q(m.className)}).Source==${q(m.source)},'exact V3 module ${m.path}')\n`;
success+=`check(deadly.Source=='-- user gameplay change','unrelated gameplay edit preserved');check(deadlyEntry.Original.Value==deadlyOriginal and deadlyEntry.Installed.Value==deadlyInstalled,'unrelated backup remains untouched, preserving rollback conflict checks');local module=create('ReplicatedStorage.CraxPolariVFX','ModuleScript');module.Source=module.Source..'-- later change';check(not pcall(update),'later edit refused');print('POLARI V3 UPDATE PASS',checks,'assertions')`;
const state2=await LuauState.createAsync({print:console.log,warn:console.log});
try{await state2.loadstring(success,'polari-update-success-and-repeat',true)();}finally{state2.destroy();}

// Targeted edits still block before any source or backup write.
for(const mode of ['edited','missing','wrong-class','untracked']){
 let isolated=lua.slice(0,lua.indexOf('local initialCount='));
 isolated+=`local target=create('ReplicatedStorage.CraxPolariVFX','ModuleScript');local before=target.Source;`;
 if(mode==='edited')isolated+=`target.Source=before..'-- user VFX edit';before=target.Source;`;
 if(mode==='missing')isolated+=`target:Destroy();`;
 if(mode==='wrong-class')isolated+=`target:Destroy();target=create('ReplicatedStorage.CraxPolariVFX','Folder');`;
 if(mode==='untracked')isolated+=`for _,e in ipairs(entries:GetChildren())do if e:GetAttribute('Path')=='ReplicatedStorage.CraxPolariVFX'then e:Destroy()end end;`;
 isolated+=`check(not pcall(update),'target preflight refuses ${mode}');check(not game.ServerStorage:FindFirstChild('PolariCrax_Update_V3_Safety'),'target rejection writes no safety folder');check(b:GetAttribute('PolariRevision')==2,'target rejection keeps revision');check(deadly.Source=='-- user gameplay change','target rejection preserves unrelated edit');`;
 if(mode==='edited')isolated+=`check(target.Source==before,'edited VFX preserved');`;
 const vm=await LuauState.createAsync({print:console.log,warn:console.log});
 try{await vm.loadstring(isolated,'v3-target-preflight-'+mode,true)();}finally{vm.destroy();}
}
console.log('POLARI V3 SCOPED PREFLIGHT PASS: unrelated gameplay edits preserved; edited/missing/untracked/wrong-class presentation modules rejected');
