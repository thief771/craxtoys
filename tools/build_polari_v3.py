"""Build V3 presentation update from canonical modules; preserve V2 gameplay and installers."""
from pathlib import Path
import json
r=Path(__file__).resolve().parents[1]
def lua(value):
 if isinstance(value,str):
  eq='===='
  while ']'+eq+']'in value:eq+='='
  return '['+eq+'['+('\n'if value.startswith('\n')else'')+value+']'+eq+']'
 if isinstance(value,list):return'{'+','.join(lua(v)for v in value)+'}'
 if isinstance(value,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(v)for k,v in value.items())+'}'
 raise TypeError(type(value))
modules=[]
for p in sorted((r/'src/polaricrax').glob('*.lua')):
 name=p.name.removesuffix('.client.lua').removesuffix('.lua')
 parent='StarterPlayer.StarterPlayerScripts'if p.name.endswith('.client.lua')else('ServerScriptService'if name in ['CraxPolariRuntime','CraxPolariPause']else'ReplicatedStorage')
 modules.append(dict(path=parent+'.'+name,className='LocalScript'if p.name.endswith('.client.lua')else'ModuleScript',source=p.read_text()))
base=r/'integration/polaricrax/version-actuelle'
for m in modules:(base/'sources'/(m['path']+'.lua')).write_text(m['source'])
p=base/'INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua';s=p.read_text();a=s.index('local modules=');b=s.index('local expected=');s=s[:a]+'local modules='+lua(modules)+'\n'+s[b:]
s=s.replace("backup:SetAttribute('PolariRevision',2)","backup:SetAttribute('PolariRevision',3)");p.write_text(s)
updates=[m for m in modules if m['path'].split('.')[-1]in ['CraxPolariConfig','CraxPolariVFX','CraxPolariClient','CraxPolariAudio']]
out=r/'integration/polaricrax/v3';out.mkdir(exist_ok=True)
(out/'payload.json').write_text(json.dumps(dict(modules=updates,wraps=[]),ensure_ascii=False,indent=2)+'\n')
# Reuse the tested transactional V2 writer and its conflict checks, with a separate safety folder.
template=(r/'integration/polaricrax/v2/METTRE_A_JOUR_POLARICRAX_V2.lua').read_text()
a=template.index('local modules=');b=template.index('local revision=2',a)
s=template[:a]+'local modules='+lua(updates)+'\nlocal wraps={}\n'+template[b:]
s=s.replace('POLARICRAX V2','POLARICRAX V3').replace('PolariCraxV2','PolariCraxV3').replace('PolariCrax V2','PolariCrax V3').replace('Version V2','Version V3').replace('PolariCrax_Update_V2_Safety','PolariCrax_Update_V3_Safety').replace('local revision=2','local revision=3')
# V3 only writes presentation modules. Preserve unrelated gameplay edits and their
# original backup records; never bless them as Polari-installed sources.
global_check="for path,entry in pairs(indexed)do local o=assert(resolve(path),'Source supprimée : '..path);assert(read(o)==entry.Installed.Value,'Source éditée depuis installation : '..path..'. Aucun fichier modifié.')end"
assert global_check in s
s=s.replace(global_check, '')
scoped_check="""for _,m in ipairs(modules)do
 local o=assert(resolve(m.path),'Source Polari requise manquante : '..m.path..'. Aucun fichier modifié.')
 local entry=assert(indexed[m.path],'Source Polari non sauvegardée : '..m.path..'. Aucun fichier modifié.')
 assert(o:IsA(m.className),'Classe Polari inattendue : '..m.path..'. Aucun fichier modifié.')
 assert(read(o)==entry.Installed.Value,'Source éditée depuis installation : '..m.path..'. Aucun fichier modifié.')
end
"""
s=s.replace('local revision=3',scoped_check+'local revision=3')
s=s.replace("local revision=3", "assert((backup:GetAttribute('PolariRevision')or 1)>=2,'Appliquer la mise à jour V2 avant les VFX V3. Aucun fichier modifié.')\nlocal revision=3")
s=s.replace("projectile VFX, attraction 8, mur aléatoire 15, temps suspendu.","VFX plasma, murs énergétiques, horlogerie et mixage audio. Mécaniques V2 préservées.")
(out/'METTRE_A_JOUR_POLARICRAX_V3.lua').write_text(s)
print('POLARI V3: four presentation modules, transactional updater and current full installer generated')
