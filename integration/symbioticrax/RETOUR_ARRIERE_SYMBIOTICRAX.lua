-- STOP. Restaure les versions exactes antérieures via ScriptEditorService.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local b=assert(SS:FindFirstChild('SymbiotiCrax_Backup_V1'),'Sauvegarde absente');assert(b:GetAttribute('SymOwned')and not b:GetAttribute('Incomplete'),'Sauvegarde incomplète, examiner les entrées')
local entries=b.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and SES:GetEditorSource(o)==e.Installed.Value,'Source éditée : '..e:GetAttribute('Path'))end
local restored={};local ok,err=pcall(function()
 for _,e in ipairs(entries)do if e.Original.Value~=''then local o=resolve(e:GetAttribute('Path'));SES:UpdateSourceAsync(o,function(s)assert(s==e.Installed.Value,'Conflit éditeur');return e.Original.Value end);restored[#restored+1]=e end end
end)
if not ok then
 for i=#restored,1,-1 do local e=restored[i];pcall(function()SES:UpdateSourceAsync(resolve(e:GetAttribute('Path')),function(s)assert(s==e.Original.Value);return e.Installed.Value end)end)end
 error('Retour arrière interrompu, sauvegarde conservée : '..tostring(err))
end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxSymFX','ReplicatedStorage.CraxSymImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Symbioti','ServerStorage.CraxTemplates.Crax_Symbioti'})do local o=resolve(path);if o and o:GetAttribute('SymOwned')then o:Destroy()end end
b:Destroy();print('SymbiotiCrax retiré. Sources antérieures, possessions et niveaux conservés. Enregistrer puis nouveau Play.')
end
