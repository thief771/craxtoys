"""Build the magnetic shatter finale update; preserve configured volumes and audio IDs."""
from pathlib import Path
import json,runpy
r=Path(__file__).resolve().parents[1]
runpy.run_path(str(r/'tools/build_polari_audio_fix.py'))
payload=json.loads((r/'integration/polaricrax/v3/payload.json').read_text())
modules=[m for m in payload['modules']if m['path'].endswith(('.CraxPolariVFX','.CraxPolariClient'))]
def lua(v):
 if isinstance(v,str):
  eq='===='
  while ']'+eq+']'in v:eq+='='
  return '['+eq+'['+v+']'+eq+']'
 if isinstance(v,list):return'{'+','.join(lua(i)for i in v)+'}'
 if isinstance(v,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(i)for k,i in v.items())+'}'
 raise TypeError(type(v))
s=(r/'integration/polaricrax/v3/METTRE_A_JOUR_POLARICRAX_V3.lua').read_text()
a=s.index('local modules=');b=s.index('local wraps=',a)
s=s[:a]+'local modules='+lua(modules)+'\n'+s[b:]
s=s.replace('local revision=3','local revision=5').replace('PolariCrax_Update_V3_Safety','PolariCrax_Finale_V5_Safety').replace('or 1)>=2','or 1)>=3')
s=s.replace('Appliquer la mise à jour V2 avant les VFX V3.', 'Installer les VFX V3 avant la nouvelle fin MAX.')
s=s.replace('PolariCrax V3 déjà installé et vérifié','Fin MAX magnétique déjà installée et vérifiée')
s=s.replace('VFX plasma, murs énergétiques, horlogerie et mixage audio. Mécaniques V2 préservées.', 'fin MAX : lévitation, cinq éclats, arrêt du temps et fragmentation de la cible. Aucun trophée visuel. Volume et ID audio conservés.')
out=r/'integration/polaricrax/v3'
(out/'finale-payload.json').write_text(json.dumps({'modules':modules,'wraps':[]},ensure_ascii=False,indent=2)+'\n')
(out/'REFAIRE_FIN_POLARICRAX.lua').write_text(s)
print('POLARI FINALE: two presentation modules, revision 5; no audio/config/gameplay replacement')
