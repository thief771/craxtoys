import fs from'node:fs';import{LuauState}from'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');const q=s=>'[========['+s+']========]';
const fixtures=JSON.parse(read('tests/fixtures/super-inspected-sources.json'));
const install=read('integration/supercrax/INSTALLER_SUPERCRAX.lua'),undo=read('integration/supercrax/RETOUR_ARRIERE_SUPERCRAX.lua');
let lua=read('tests/super_installer_fixture.lua')+'\nlocal originals={}\n';
for(const e of Object.entries(fixtures[process.env.SUPER_BASE ? 'base' : 'canonical']).map(([path,source])=>({path,source}))){lua+=`do local o=create(${q(e.path)},'ModuleScript');o.Source=${q(e.source+'\n-- independent current Killa hotfix preserved\n')};originals[ ${q(e.path)} ]=o.Source end\n`;}
lua+=`local function install()\n${install}\nend\nlocal function undo()\n${undo}\nend\n`;
lua+=`
local target=create('ServerScriptService.CombatHealth','ModuleScript');local before=target.Source
local wrong=create('ReplicatedStorage.CraxSuperRules','ModuleScript');check(not pcall(install),'reject foreign module');wrong:Destroy()
target.Source='-- unsupported current source';check(not pcall(install),'reject unsupported anchor before writes');check(not game.ServerStorage:FindFirstChild('SuperCrax_Integration_Backup_V1'),'no backup on invalid source');target.Source=before
local hair=imported.SuperHairCap;hair.MeshId='';check(not pcall(install),'reject unpublished actual meshes');hair.MeshId='rbxassetid://123'
failure=target;check(not pcall(install),'injected midinstall failure')
for p,s in pairs(originals)do check(create(p,'ModuleScript').Source==s,'failure restores '..p)end
check(not game.ReplicatedStorage:FindFirstChild('CraxSuperRules'),'failure removes created modules')
install();local backup=game.ServerStorage.SuperCrax_Integration_Backup_V1;check(backup~=nil,'backup exists');check(#backup.Entries:GetChildren()==19,'five new sources plus fourteen live patches')
check(game.ServerStorage.CraxTemplates.Crax_Super~=nil,'actual head template cloned');check(game.ReplicatedStorage.CraxSuperImportedAssets~=nil,'selected assets cloned')
for p in pairs(originals)do check(create(p,'ModuleScript').Source:find('independent current Killa hotfix preserved',1,true),'current independent change retained '..p)end
local installed=target.Source;install();check(#backup.Entries:GetChildren()==19,'idempotent install')
target.Source=installed..'-- subsequent edit';check(not pcall(install),'refuse later source edits');check(not pcall(undo),'rollback refuses later edits');target.Source=installed
undo();for p,s in pairs(originals)do check(create(p,'ModuleScript').Source==s,'exact rollback '..p)end
check(not game.ReplicatedStorage:FindFirstChild('CraxSuperFX'),'rollback removes event');check(not game.ServerStorage.CraxTemplates:FindFirstChild('Crax_Super'),'rollback removes model');check(imported.Parent~=nil,'original import retained')
install();check(target.Source==installed,'reinstallation identical')
print('SUPER ACTUAL INSTALL / ROLLBACK PASS',checks,'assertions')
`;
const state=await LuauState.createAsync({print:console.log,warn:()=>{}});await state.loadstring(lua,'super-installer-tests',true)();state.destroy();
