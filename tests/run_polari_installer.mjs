import fs from'node:fs';import{LuauState}from'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');const q=s=>'[========['+s+']========]';const bases=JSON.parse(read('tests/fixtures/polari-inspected-sources.json'));const operations=JSON.parse(read('integration/polaricrax/operations.json'));const expected={};
const apply=(source,op)=>{if(op.kind==='wrap')return '-- PolariCraxIntegrationV1\nlocal data=(function()\n'+source+'\nend)()\n'+op.addition+'\nreturn data\n';for(const r of op.replacements)source=source.replace(r.before,r.after);return '-- PolariCraxIntegrationV1\n'+(op.prepend||'')+source;};
const model=JSON.parse(read('assets/polaricrax/model/manifest.json'));
let fixture=read('tests/super_installer_fixture.lua').replace("module.Name=='CraxSuperAppearance'","module.Name=='CraxPolariAppearance'");const start=fixture.indexOf("for _,name in ipairs({");const end=fixture.indexOf('do\n local o=new',start);fixture=fixture.slice(0,start)+'for _,name in ipairs('+('{'+[...model.accessories,...model.markers,...model.fx].map(q).join(',')+'}')+')'+fixture.slice(end);
fixture=fixture.replace("  if key=='GetPivot'then","  if key=='GetFullName'then return function()return object.Name end end\n  if key=='GetPivot'then");
fixture=fixture.replace("Workspace.ImportedSuper","ServerStorage.PolariCrax_Import").replaceAll('FIT_Front','P_FitFront').replaceAll('FIT_Up','P_FitUp');
let lua=fixture+`\nfor p,c in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenabottom']='Part',['Workspace.ArenaTop']='Part',['Workspace.CombatState']='Folder'})do create(p,c)end\nlocal editors={};local ses=create('ScriptEditorService','ScriptEditorService');function ses:GetEditorSource(o)return editors[o]or o.Source end\nfunction ses:UpdateSourceAsync(o,fn)local after=fn(self:GetEditorSource(o));o.Source=after;editors[o]=after end\nlocal originals={};local expectedSources={}\n`;
for(const[p,s]of Object.entries(bases)){expected[p]=apply(s+'\n-- independent editor Killa fix\n',operations.find(o=>o.path===p));lua+=`do local o=create(${q(p)},'ModuleScript');o.Source='-- stale saved buffer';editors[o]=${q(s+'\n-- independent editor Killa fix\n')};originals[ ${q(p)} ]=editors[o];expectedSources[ ${q(p)} ]=${q(expected[p])}end\n`;}
lua+=`local function install()\n${read('integration/polaricrax/INSTALLER_POLARICRAX.lua')}\nend\nlocal function undo()\n${read('integration/polaricrax/RETOUR_ARRIERE_POLARICRAX.lua')}\nend\n`;
lua+=`
local target=create('ServerScriptService.CombatHealth','ModuleScript');local before=editors[target]
do local controller=create('ServerScriptService.CraxPlumberRuntime','ModuleScript');local old=editors[controller];editors[controller]=old:gsub('%f[%a]logic%f[%A]','networkLogic');check(not pcall(install),'changed private runtime structure refused');check(not game.ServerStorage:FindFirstChild('PolariCrax_Backup_V1'),'private structure guard has no mutation');editors[controller]=old end
local heal=create('ServerScriptService.CraxHeal','BindableEvent');local parent=heal.Parent;heal.Parent=nil;check(not pcall(install)and not game.ServerStorage:FindFirstChild('PolariCrax_Backup_V1'),'missing dependency fails without mutation');heal.Parent=parent
editors[target]='-- unsupported current editor';check(not pcall(install),'preflight reads live editor, not stale Source');check(not game.ServerStorage:FindFirstChild('PolariCrax_Backup_V1'),'no preflight mutation');editors[target]=before
failure=target;check(not pcall(install),'editor write failure rolls back')
for p,s in pairs(originals)do check(ses:GetEditorSource(create(p,'ModuleScript'))==s,'transaction restores visible editor '..p)end
check(not game.ReplicatedStorage:FindFirstChild('CraxPolariRules'),'failed install removes new sources')
install();local backup=game.ServerStorage.PolariCrax_Backup_V1;check(backup and not backup:GetAttribute('Incomplete'),'complete backup')
check(#backup.Entries:GetChildren()==29,'20 editor adaptations plus nine new sources')
for p in pairs(originals)do local o=create(p,'ModuleScript');check(ses:GetEditorSource(o):find('independent editor Killa fix',1,true),'visible editor fix retained '..p);check(ses:GetEditorSource(o)==expectedSources[p],'exact compiled installed source '..p)end
local installed=ses:GetEditorSource(target);install();check(#backup.Entries:GetChildren()==29,'repeat creates no duplicates')
editors[target]=installed..'-- later edit';check(not pcall(install),'install refuses editor change');check(not pcall(undo),'undo refuses editor change');editors[target]=installed
undo();for p,s in pairs(originals)do check(ses:GetEditorSource(create(p,'ModuleScript'))==s,'undo exact visible editor '..p)end
check(imported.Parent~=nil,'original imported asset retained');check(not game.ServerStorage.CraxTemplates:FindFirstChild('Crax_Polari'),'own template removed');check(not game.ReplicatedStorage:FindFirstChild('CraxPolariFX'),'event removed')
install();check(ses:GetEditorSource(target)==installed,'reinstall stable');undo();local normalUpdate=ses.UpdateSourceAsync
function ses:UpdateSourceAsync(o,fn)if o==target then editors[o]=self:GetEditorSource(o)..'-- concurrent human fix';ses.UpdateSourceAsync=normalUpdate end;return normalUpdate(self,o,fn)end
check(not pcall(install),'concurrent editor change stops transaction');check(ses:GetEditorSource(target):find('concurrent human fix',1,true),'concurrent human text preserved');check(game.ServerStorage.PolariCrax_Backup_V1:GetAttribute('Incomplete'),'conflict retains incomplete backup for review')
print('POLARI ACTUAL EDITOR INSTALL / UNDO PASS',checks,'assertions')
`;
const state=await LuauState.createAsync({print:console.log,warn:console.log});for(const[p,s]of Object.entries(expected))state.loadstring(s,p+'-installed-editor',true);await state.loadstring(lua,'sym-editor-install',true)();state.destroy();
