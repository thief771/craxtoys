-- Play ARRÊTÉ. Restaure les sources telles qu’elles étaient AVANT SuperCrax.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play.')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local storage=game:GetService('ServerStorage');local backup=assert(storage:FindFirstChild('SuperCrax_Integration_Backup_V1'),'Sauvegarde absente')
assert(backup:GetAttribute('SuperOwned')==true,'Sauvegarde non reconnue')
local entries=backup.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and o.Source==e.Installed.Value,'Source modifiée après installation : '..e:GetAttribute('Path')..'. Aucune modification effectuée.')end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if e.Original.Value~=''then o.Source=e.Original.Value end end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxSuperFX','ReplicatedStorage.CraxSuperImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Super','ServerStorage.CraxTemplates.Crax_Super'})do local o=resolve(path);if o and o:GetAttribute('SuperOwned')then o:Destroy()end end
backup:Destroy();print('SuperCrax retiré ; versions précédentes exactes restaurées. Les données joueur et les IDs utilisateur ne sont pas effacés.')
end
