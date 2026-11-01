-- UNE commande, Play arrêté. Refuse de perdre une modification ultérieure.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play.')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local storage=game:GetService('ServerStorage');local backup=assert(storage:FindFirstChild('InvertedCrax_Integration_Backup_V1'),'Sauvegarde absente')
assert(backup:GetAttribute('InvertedOwned')==true,'Sauvegarde non reconnue')
local entries=backup.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and o.Source==e.Installed.Value,'Source modifiée depuis installation : '..e:GetAttribute('Path')..'. Aucun écrasement.')end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if e.Original.Value~=''then o.Source=e.Original.Value end end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxInvertedFX','ReplicatedStorage.CraxPreviews.Crax_Inverted','ServerStorage.CraxTemplates.Crax_Inverted'})do local o=resolve(path);if o and o:GetAttribute('InvertedOwned')then o:Destroy()end end
backup:Destroy();print('Intégration InvertedCrax retirée. Les profils et possessions sauvegardés ne sont pas effacés ; conserver les données pour réinstallation.')
end
