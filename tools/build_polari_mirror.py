"""Build a targeted client patch, preserving user captions, skills, audio and book changes."""
from pathlib import Path
import json,runpy
r=Path(__file__).resolve().parents[1]
runpy.run_path(str(r/'tools/build_polari_finish.py'))
patches=json.loads((r/'integration/polaricrax/v3/mirror-patches.json').read_text())['patches']
def q(s):
 eq='===='
 while ']'+eq+']'in s:eq+='='
 return '['+eq+'['+s+']'+eq+']'
header="""-- Play arrêté : duel PolariCrax contre PolariCrax, perdant de face et gagnant de profil.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local editor=game:GetService('ScriptEditorService');local SS=game:GetService('ServerStorage')
local client=assert(game:GetService('StarterPlayer'):FindFirstChild('StarterPlayerScripts'):FindFirstChild('CraxPolariClient'),'Client Polari absent')
local marker='-- PolariMirrorPortraitV1'
local before=editor:GetEditorSource(client)
if before:find(marker,1,true)then print('Duel Polari déjà ajusté. Enregistrer puis nouveau Play.');return end
local function once(source,old,new)
 local a,b=source:find(old,1,true);assert(a and not source:find(old,b+1,true),'Version de cinématique différente : aucun fichier modifié')
 return source:sub(1,a-1)..new..source:sub(b+1)
end
local after=before
"""
for p in patches:header+='after=once(after,'+q(p['before'])+','+q(p['after'])+')\n'
footer="""after=marker..'\\n'..after
local safetyName='PolariCrax_MirrorPose_Safety_V1'
assert(not SS:FindFirstChild(safetyName),'Inspecter la sauvegarde existante '..safetyName..' avant de continuer')
local safety=Instance.new('Folder');safety.Name=safetyName;safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true)
for key,value in pairs({Original=before,Installed=after})do local v=Instance.new('StringValue');v.Name=key;v.Value=value;v.Parent=safety end
safety.Parent=SS
local ok,problem=pcall(function()
 editor:UpdateSourceAsync(client,function(current)assert(current==before,'Édition concurrente ; ne pas écraser');return after end)
 assert(editor:GetEditorSource(client)==after,'Écriture non vérifiée')
end)
if not ok then
 if editor:GetEditorSource(client)==before then safety:Destroy()else warn('Édition concurrente préservée ; sauvegarde conservée dans '..safetyName)end
 error(tostring(problem))
end
local backup=SS:FindFirstChild('PolariCrax_Backup_V1');local entries=backup and backup:FindFirstChild('Entries')
if entries then for _,entry in ipairs(entries:GetChildren())do if entry:GetAttribute('Path')=='StarterPlayer.StarterPlayerScripts.CraxPolariClient'then local installed=entry:FindFirstChild('Installed');if installed and installed.Value==before then installed.Value=after end end end end
safety:SetAttribute('Incomplete',false)
print('Duel Polari : perdant de face, gagnant de profil. Autres duels, sons, titre et cahier conservés. ENREGISTRER puis NOUVEAU Play.')
end
"""
(r/'integration/polaricrax/v3/AJUSTER_DUEL_POLARICRAX.lua').write_text(header+footer)
print('POLARI MIRROR: two targeted client edits; no full script/config/audio replacement')
