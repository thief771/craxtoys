-- VENICRAX · RETOUR ARRIÈRE. Studio, Play ARRÊTÉ. Restaure exactement les sources d'avant installation.
do

assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play (mode Édition), puis relancer cette commande')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local backupName='VeniCrax_Backup_V1'

local backup=assert(SS:FindFirstChild(backupName),'Aucune sauvegarde VeniCrax');assert(backup:GetAttribute('VeniOwned'),'Sauvegarde étrangère')
local entries=backup.Entries:GetChildren();table.sort(entries,function(a,b)return tonumber(a.Name)>tonumber(b.Name)end)
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if o and e.Original.Value~=''then assert(read(o)==e.Installed.Value,'Source modifiée depuis l’installation : '..e:GetAttribute('Path')..'. Rien n’a été restauré.')end end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if o and e.Original.Value~=''then write(o,read(o),e.Original.Value)end end
for _,root in ipairs({game:GetService('ReplicatedStorage'),game:GetService('ServerScriptService'),game:GetService('StarterPlayer'),SS})do
 for _,o in ipairs(root:GetDescendants())do if o.Parent and o~=backup and o:GetAttribute('VeniOwned')then o:Destroy()end end
end
backup:Destroy();print('VeniCrax retiré, sources d’origine restaurées. Enregistrer puis NOUVEAU Play.')
end
