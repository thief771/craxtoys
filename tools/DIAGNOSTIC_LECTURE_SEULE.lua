-- 7 DEADLY CRAX · DIAGNOSTIC EN LECTURE SEULE. Barre de commande Studio, Play arrêté.
-- Ne crée, ne modifie et ne supprime rien ; n'exécute aucun ModuleScript (pas de require). Résultat dans Output.
do
local out={}
local function p(...)local t={};for i,v in ipairs({...})do t[i]=tostring(v)end;out[#out+1]=table.concat(t,' ')end
local function has(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
p('=== DIAGNOSTIC 7 DEADLY CRAX ===');p('Place :',game.Name,'| PlaceId',game.PlaceId,'| GameId',game.GameId)
local classes={};local scripts={Script=0,LocalScript=0,ModuleScript=0};local disabled=0;local total=0
for _,o in ipairs(game:GetDescendants())do total+=1;if scripts[o.ClassName]then scripts[o.ClassName]+=1;if o:IsA('BaseScript')and o.Disabled then disabled+=1 end end end
p('Objets :',total,'| Script',scripts.Script,'| LocalScript',scripts.LocalScript,'| ModuleScript',scripts.ModuleScript,'| scripts désactivés',disabled)
p('--- Contenu principal des services');for _,name in ipairs({'Workspace','ServerScriptService','ServerStorage','ReplicatedStorage','StarterGui','StarterPlayer','Lighting','SoundService'})do
 local s=game:GetService(name);local kids=s:GetChildren();local names={};for i,c in ipairs(kids)do if i<=60 then names[#names+1]=c.Name end end
 table.sort(names);p(name..' ('..#kids..') :',table.concat(names,', ')..(#kids>60 and ' …'or''))
end
p('--- Crax (gabarits / aperçus)')
for _,path in ipairs({'ServerStorage.CraxTemplates','ReplicatedStorage.CraxPreviews'})do local f=has(path);if f then local n={};for _,c in ipairs(f:GetChildren())do n[#n+1]=c.Name end;table.sort(n);p(path..' ('..#n..') :',table.concat(n,', '))else p(path..' : ABSENT')end end
p('--- Points clés')
for _,path in ipairs({'ReplicatedStorage.CraxSonGoFX','ServerScriptService.RoundManager','ServerScriptService.ArenaMovement','ServerScriptService.CombatHealth','ServerScriptService.CraxPolariRuntime','ServerStorage.PolariCrax_Backup_V1','ReplicatedStorage.CraxVeniConfig','ServerScriptService.CraxVeniRuntime','ServerStorage.VeniCrax_Backup_V1','ServerStorage.VeniCrax_Import','ReplicatedStorage.CraxVeniImportedAssets','ReplicatedStorage.CraxVeniUserAssets','Workspace.CraxEquilibrage_20261107','Workspace.CombatState'})do
 local o=has(path);p((o and'PRÉSENT  'or'absent   ')..path..(o and(' ['..o.ClassName..']')or''))
end
local user=has('ReplicatedStorage.CraxVeniUserAssets');if user then for k,v in pairs(user:GetAttributes())do p('  CraxVeniUserAssets.'..k..' =',v)end end
p('--- Marqueurs d’intégration dans les sources raccordées')
for _,path in ipairs({'ServerScriptService.ArenaMovement','ServerScriptService.CombatHealth','ServerScriptService.RoundManager','ReplicatedStorage.CraxCatalog','ReplicatedStorage.CraxSkillCatalog','StarterPlayer.StarterPlayerScripts.ArenaCamera'})do
 local o=has(path);if o then local src=o.Source;local marks={};for m in src:gmatch('%-%- ([%w]+Integration[%w]*)')do marks[#marks+1]=m end;for m in src:gmatch('%-%- (Crax%w+V%d+)')do marks[#marks+1]=m end;p(path,'('..#src..' car.) :',#marks>0 and table.concat(marks,', ')or'aucun marqueur')end
end
print(table.concat(out,'\n'))
print('=== FIN DU DIAGNOSTIC (aucune modification) ===')
end
