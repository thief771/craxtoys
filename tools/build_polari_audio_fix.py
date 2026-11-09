"""Build persistent audio fix for installed V3, preserving gameplay and user's sources."""
from pathlib import Path
import json,runpy
r=Path(__file__).resolve().parents[1]
runpy.run_path(str(r/'tools/build_polari_v3.py'))
s=(r/'integration/polaricrax/v3/METTRE_A_JOUR_POLARICRAX_V3.lua').read_text()
payload=json.loads((r/'integration/polaricrax/v3/payload.json').read_text())
modules=[m for m in payload['modules']if m['path'].endswith(('.CraxPolariAudio','.CraxPolariClient'))]
# Use the generator's safe Lua string serializer without executing it twice.
def lua(v):
 if isinstance(v,str):
  eq='===='
  while ']'+eq+']'in v:eq+='='
  return '['+eq+'['+v+']'+eq+']'
 if isinstance(v,list):return'{'+','.join(lua(i)for i in v)+'}'
 if isinstance(v,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(i)for k,i in v.items())+'}'
 raise TypeError(type(v))
a=s.index('local modules=');b=s.index('local wraps=',a)
s=s[:a]+'local modules='+lua(modules)+'\n'+s[b:]
s=s.replace('local revision=3','local revision=4').replace('PolariCrax_Update_V3_Safety','PolariCrax_Audio_V4_Safety')
s=s.replace("or 1)>=2", "or 1)>=3").replace('Appliquer la mise à jour V2 avant les VFX V3.', 'Installer les VFX V3 avant ce correctif audio.')
s=s.replace('PolariCrax V3 déjà installé et vérifié','Correctif audio Polari déjà installé et vérifié').replace('VFX plasma, murs énergétiques, horlogerie et mixage audio. Mécaniques V2 préservées.', 'correctif audio : chargement typé, ID relu et mixage de combat.')
folder=r/'integration/polaricrax/v3'
(folder/'audio-fix-payload.json').write_text(json.dumps({'modules':modules,'wraps':[]},ensure_ascii=False,indent=2)+'\n')
(folder/'CORRIGER_AUDIO_POLARICRAX.lua').write_text("""-- Coller côté SERVEUR / édition, Play arrêté. ID audio fourni par le propriétaire.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play avant le correctif audio')
local RS=game:GetService('ReplicatedStorage')
local assets=RS:FindFirstChild('CraxPolariUserAssets')
assert(not assets or assets:IsA('Folder'),'CraxPolariUserAssets doit être un Folder ; aucun fichier modifié')
local function update()
"""+s+"""
end
update()
if not assets then assets=Instance.new('Folder');assets.Name='CraxPolariUserAssets';assets.Parent=RS end
assets:SetAttribute('PolariUserAssets',true)
assets:SetAttribute('AudioAtlas','rbxassetid://126174551693820')
print('Audio Polari enregistré : 126174551693820. ENREGISTRER la place, puis nouveau Play et combat.')
end
""")
print('POLARI AUDIO FIX: two presentation modules, persistent audio binding, revision 4')
