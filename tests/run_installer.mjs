import fs from 'node:fs';import path from 'node:path';import {pathToFileURL}from'node:url';
const root=path.resolve(import.meta.dirname,'..');const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const {LuauState}=process.env.LUAU_WEB_PATH?await import(pathToFileURL(process.env.LUAU_WEB_PATH)):await import('luau-web');
const state=await LuauState.createAsync({print:console.log,warn:()=>{}});const long=s=>'[========['+s+']========]';
const manifest=JSON.parse(read('integration/invertedcrax/patch-manifest.json'));const fixture=JSON.parse(read('tests/fixtures/inspected-export.json'));
const install=read('integration/invertedcrax/INSTALLER_INVERTEDCRAX.lua');const undo=read('integration/invertedcrax/RETOUR_ARRIERE.lua');
let lua=read('tests/installer_fixture.lua');
lua+='\nlocal originals={}\n';
for(const m of manifest){const e=fixture.scripts.find(e=>e.path===m.path);lua+=`do local o=create(${long(m.path)},'ModuleScript');o.Source=${long(e.source)};originals[ ${long(m.path)} ]=o.Source end\n`;}
lua+=`local function install()\n${install}\nend\nlocal function undo()\n${undo}\nend\n`;
lua+=`
local bad=create('ReplicatedStorage.CraxInvertedRules','ModuleScript')
local ok=pcall(install);check(not ok,'reject an unrelated existing module');bad:Destroy()
local target=create('ServerScriptService.CombatHealth','ModuleScript')
local before=target.Source;target.Source=before..'-- newer project version'
ok=pcall(install);check(not ok,'reject stale inspected source');check(not game.ServerStorage:FindFirstChild('InvertedCrax_Integration_Backup_V1'),'no mutation on preflight failure');target.Source=before
failure=target;ok=pcall(install);check(not ok,'injected mid-install failure')
for p,s in pairs(originals)do check(create(p,'ModuleScript').Source==s,'transaction restores '..p)end
check(not game.ReplicatedStorage:FindFirstChild('CraxInvertedRules'),'new module removed on failed install')
check(not game.ServerStorage.CraxTemplates:FindFirstChild('Crax_Inverted'),'template removed on failed install')
install()
local backup=game.ServerStorage.InvertedCrax_Integration_Backup_V1
check(backup~=nil,'backup exists')
local n=#backup.Entries:GetChildren();check(n==27,'21 patches + 6 new sources backed up')
check(game.ServerStorage.CraxTemplates:FindFirstChild('Crax_Inverted')~=nil,'template created')
check(game.ReplicatedStorage.CraxPreviews:FindFirstChild('Crax_Inverted')~=nil,'preview created')
check(game.ReplicatedStorage:FindFirstChild('CraxInvertedFX')~=nil,'server event created')
local installed=target.Source
install();check(#backup.Entries:GetChildren()==n,'repeat does not duplicate')
target.Source=installed..'-- later edit'
ok=pcall(install);check(not ok,'install preserves later edits')
ok=pcall(undo);check(not ok,'rollback preserves later edits')
check(target.Source==installed..'-- later edit','edited source unchanged')
target.Source=installed
undo()
for p,s in pairs(originals)do check(create(p,'ModuleScript').Source==s,'rollback restores exact '..p)end
check(not game.ReplicatedStorage:FindFirstChild('CraxInvertedFX'),'event removed')
check(not game.ReplicatedStorage:FindFirstChild('CraxInvertedRules'),'module removed')
check(not game.ServerStorage.CraxTemplates:FindFirstChild('Crax_Inverted'),'template removed')
check(not game.ServerStorage:FindFirstChild('InvertedCrax_Integration_Backup_V1'),'backup removed')
install();check(target.Source==installed,'reinstall exact')
print('ACTUAL INSTALLER / ROLLBACK FIXTURE PASS',checks,'assertions')
return checks
`;
const result=await state.loadstring(lua,'actual-installer-tests',true)();state.destroy();
