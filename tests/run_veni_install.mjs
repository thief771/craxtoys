// Exécute les VRAIES commandes Studio VeniCrax (installer, brancher, retour arrière) sur une maquette de la place,
// avec les sources réelles de « copie jeu mardi », puis compile chaque source raccordée avec Luau.
import fs from 'node:fs'; import { LuauState } from 'luau-web';
const read = p => fs.readFileSync(new URL('../' + p, import.meta.url), 'utf8');
const q = s => { let eq = '========'; while (s.includes(']' + eq + ']')) eq += '='; return '[' + eq + '[' + (s.startsWith('\n') ? '\n' : '') + s + ']' + eq + ']'; };
const fixture = JSON.parse(read('tests/fixtures/veni-mardi-sources.json'));
const ops = JSON.parse(read('integration/venicrax/operations.json'));
const manifest = JSON.parse(read('assets/venicrax/model/manifest.json'));
const marker = '-- VeniCraxIntegrationV1';
const count = (s, n) => s.split(n).length - 1;
const apply = (source, op) => {
  if (op.kind === 'wrap') return marker + '\nlocal data=(function()\n' + source + '\nend)()\n' + op.addition + '\nreturn data\n';
  for (const r of op.replacements) { if (count(source, r.before) !== 1) throw new Error('ancre non unique : ' + op.path + ' :: ' + r.before.slice(0, 60)); source = source.replace(r.before, () => r.after); }
  return marker + '\n' + (op.prepend || '') + source;
};
const state = await LuauState.createAsync({ print: console.log, warn: console.log });
// 1) Chaque source raccordée compile (syntaxe Luau) et chaque ancre est unique.
const expected = {};
for (const op of ops) { const out = apply(fixture.sources[op.path], op); expected[op.path] = out; state.loadstring(out, op.path, true); }
console.log('VENI PATCHED SOURCES COMPILE PASS', ops.length, 'sources de la place mardi');

// 2) Commandes réelles dans une maquette Studio.
let lua = read('tests/super_installer_fixture.lua')
  .replace("require=function(module)assert(module.Name=='CraxSuperAppearance');return {Apply=function()end}end", "local applied={};require=function(module)assert(module.Name=='CraxVeniAppearance');return {Apply=function(m)applied[#applied+1]=m end}end")
  .replace("  if key=='GetPivot'then", "  if key=='GetFullName'then return function()return object.Name end end\n  if key=='FindFirstChildWhichIsA'then return function(_,c)for _,o in ipairs(objects)do if o.Parent==object and o:IsA(c)then return o end end end end\n  if key=='GetPivot'then");
const s0 = lua.indexOf('local imported=create('); lua = lua.slice(0, s0);
lua += `warn=function(...)print('WARN',...)end
local V={};V.__index=function(t,k)if k=='Magnitude'then return math.sqrt(t.X^2+t.Y^2+t.Z^2)elseif k=='Unit'then local m=t.Magnitude;return setmetatable({X=t.X/m,Y=t.Y/m,Z=t.Z/m},V)end;return V[k]end
V.__sub=function(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=a.Z-b.Z},V)end;function V:Dot(b)return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
local function vec(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end
for p,c in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ReplicatedStorage.CraxSilenceGate']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.CraxDeadlyRuntime']='ModuleScript',['ServerScriptService.CraxPolariRuntime']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenabottom']='Part',['Workspace.ArenaTop']='Part'})do create(p,c)end
local editors={};local ses=create('ScriptEditorService','ScriptEditorService');function ses:GetEditorSource(o)return editors[o]or o.Source end
function ses:UpdateSourceAsync(o,fn)local after=fn(self:GetEditorSource(o));o.Source=after;editors[o]=after end
local originals={};local expected={};local objectsByPath={}
`;
for (const op of ops) lua += `do local o=create(${q(op.path)},${q(op.path.endsWith('RoundManager') || op.path.endsWith('ArenaMovement') || op.path.endsWith('CombatHealth') ? 'Script' : (op.path.startsWith('StarterPlayer') ? 'LocalScript' : 'ModuleScript'))});o.Source='-- ancien tampon enregistré';editors[o]=${q(fixture.sources[op.path])};originals[ ${q(op.path)} ]=editors[o];expected[ ${q(op.path)} ]=${q(expected[op.path])};objectsByPath[ ${q(op.path)} ]=o end\n`;
lua += `local imported=create('ServerStorage.VeniCrax_Import','Model')
for _,name in ipairs(${'{' + [...manifest.accessories, ...manifest.markers].map(q).join(',') + '}'})do
 local o=Instance.new('MeshPart');o.Name=name;o.MeshId='rbxassetid://123';o.Position=name=='V_FitFront'and vec(0,0,-4)or(name=='V_FitUp'and vec(0,4,0)or vec(0,0,0));o.Parent=imported
end
local function install()\n${read('integration/venicrax/INSTALLER_VENICRAX.lua')}\nend
local function branch()\n${read('integration/venicrax/BRANCHER_SONS_ET_TEXTURES.lua')}\nend
local function undo()\n${read('integration/venicrax/RETOUR_ARRIERE_VENICRAX.lua')}\nend
local SS=game:GetService('ServerStorage');local RS=game:GetService('ReplicatedStorage')
-- Panne injectée au milieu de l'écriture : tout doit être annulé.
failure=objectsByPath['ServerScriptService.CombatHealth']
check(not pcall(install),'panne d’écriture détectée')
check(not SS:FindFirstChild('VeniCrax_Backup_V1'),'aucune sauvegarde laissée après panne')
for p,o in pairs(objectsByPath)do check(editors[o]==originals[p],'source restaurée après panne : '..p)end
check(not RS:FindFirstChild('CraxVeniConfig')and not RS:FindFirstChild('CraxVeniFX'),'modules retirés après panne')
-- Installation réelle.
table.clear(applied)
install()
for p,o in pairs(objectsByPath)do check(editors[o]==expected[p],'source raccordée exacte : '..p)end
for _,n in ipairs({'CraxVeniConfig','CraxVeniRules','CraxVeniAppearance','CraxVeniAudio','CraxVeniAudioMap','CraxVeniFX','CraxVeniImportedAssets','CraxVeniUserAssets'})do check(RS:FindFirstChild(n),'créé : '..n)end
check(game.ServerScriptService:FindFirstChild('CraxVeniRuntime'),'runtime serveur créé')
check(game.StarterPlayer.StarterPlayerScripts:FindFirstChild('CraxVeniClient'),'client créé')
check(SS.CraxTemplates:FindFirstChild('Crax_Veni')and RS.CraxPreviews:FindFirstChild('Crax_Veni'),'gabarit et aperçu créés')
check(#applied==1,'apparence appliquée au gabarit')
local backup=SS:FindFirstChild('VeniCrax_Backup_V1');check(backup and backup:GetAttribute('Incomplete')==false,'sauvegarde complète')
-- Deuxième exécution : aucun doublon.
install();check(#applied==1,'aucun doublon à la seconde exécution')
-- Branchement des IDs (zéros par défaut : rien ne change, aucune erreur).
branch()
-- Source modifiée après installation : le retour arrière refuse.
local cm=objectsByPath['ServerScriptService.CombatHealth'];local saved=editors[cm];editors[cm]=saved..'\\n-- édition ultérieure'
check(not pcall(undo),'retour arrière refusé si une source a été modifiée');editors[cm]=saved
-- Retour arrière.
undo()
for p,o in pairs(objectsByPath)do check(editors[o]==originals[p],'source d’origine restaurée : '..p)end
check(not SS:FindFirstChild('VeniCrax_Backup_V1'),'sauvegarde retirée')
check(not RS:FindFirstChild('CraxVeniConfig')or not RS.CraxVeniConfig.Parent,'modules retirés')
check(not SS.CraxTemplates:FindFirstChild('Crax_Veni'),'gabarit retiré')
print('VENI INSTALLER PASS',checks,'vérifications')
`;
await state.loadstring(lua, 'veni-installer', true)();
state.destroy();
