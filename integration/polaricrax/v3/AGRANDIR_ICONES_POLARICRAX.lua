-- Play arrêté. Ajuste uniquement les images des trois compétences Polari dans le cahier.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local editor=game:GetService('ScriptEditorService');local SS=game:GetService('ServerStorage')
local book=assert(game:GetService('StarterPlayer'):FindFirstChild('StarterPlayerScripts'):FindFirstChild('CopEmClient'),'CopEmClient absent')
local marker='-- PolariSkillIconSizeV1'
local before=editor:GetEditorSource(book)
if before:find(marker,1,true)then print('Taille des images Polari déjà ajustée. Enregistrer puis nouveau Play.');return end
local anchor='i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f'
local first,last=before:find(anchor,1,true)
assert(first and not before:find(anchor,last+1,true),'Structure des images Polari différente : aucun fichier modifié')
local replacement=[[i.Name='PolariSkillImage';i.AnchorPoint=Vector2.new(.5,.5);i.Position=UDim2.fromScale(.5,.5);i.Size=UDim2.fromScale(1.25,1.25);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;f.ClipsDescendants=true;i.Parent=f]]
local after=marker..'\n'..before:sub(1,first-1)..replacement..before:sub(last+1)
local safetyName='PolariCrax_IconSize_Safety_V1'
assert(not SS:FindFirstChild(safetyName),'Sauvegarde de taille existante : inspecter '..safetyName..' avant de continuer')
local safety=Instance.new('Folder');safety.Name=safetyName;safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true)
for key,value in pairs({Original=before,Installed=after})do local v=Instance.new('StringValue');v.Name=key;v.Value=value;v.Parent=safety end
safety.Parent=SS
local ok,problem=pcall(function()
 editor:UpdateSourceAsync(book,function(current)assert(current==before,'Édition concurrente du cahier ; ne pas écraser');return after end)
 assert(editor:GetEditorSource(book)==after,'Écriture non vérifiée')
end)
if not ok then
 if editor:GetEditorSource(book)==before then safety:Destroy()else warn('Édition concurrente préservée ; sauvegarde conservée dans '..safetyName)end
 error(tostring(problem))
end
local backup=SS:FindFirstChild('PolariCrax_Backup_V1');local entries=backup and backup:FindFirstChild('Entries')
if entries then for _,entry in ipairs(entries:GetChildren())do if entry:GetAttribute('Path')=='StarterPlayer.StarterPlayerScripts.CopEmClient'then local installed=entry:FindFirstChild('Installed');if installed and installed.Value==before then installed.Value=after end end end end
safety:SetAttribute('Incomplete',false)
print('Images Polari agrandies dans les sceaux ET les fiches de compétences. MAX, noms, sons et autres personnages conservés. ENREGISTRER puis NOUVEAU Play.')
end
