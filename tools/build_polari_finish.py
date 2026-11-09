"""Final portrait orientation and louder competence audio, without changing cinematic volume."""
from pathlib import Path
import json,runpy
r=Path(__file__).resolve().parents[1]
runpy.run_path(str(r/'tools/build_polari_finale.py'))
payload=json.loads((r/'integration/polaricrax/v3/payload.json').read_text())
modules=[m for m in payload['modules']if m['path'].endswith(('.CraxPolariAudio','.CraxPolariClient'))]
def lua(v):
 if isinstance(v,str):
  eq='===='
  while ']'+eq+']'in v:eq+='='
  return '['+eq+'['+v+']'+eq+']'
 if isinstance(v,list):return'{'+','.join(lua(i)for i in v)+'}'
 if isinstance(v,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(i)for k,i in v.items())+'}'
 raise TypeError(type(v))
s=(r/'integration/polaricrax/v3/REFAIRE_FIN_POLARICRAX.lua').read_text()
a=s.index('local modules=');b=s.index('local wraps=',a)
s=s[:a]+'local modules='+lua(modules)+'\n'+s[b:]
s=s.replace('local revision=5','local revision=6').replace('PolariCrax_Finale_V5_Safety','PolariCrax_Finish_V6_Safety').replace('or 1)>=3','or 1)>=5')
s=s.replace('Installer les VFX V3 avant la nouvelle fin MAX.', 'Installer la fin MAX revision 5 avant ce correctif.')
s=s.replace('Fin MAX magnétique déjà installée et vérifiée','Plan de face et audio des compétences déjà installés et vérifiés')
s=s.replace('fin MAX : lévitation, cinq éclats, arrêt du temps et fragmentation de la cible. Aucun trophée visuel. Volume et ID audio conservés.', 'dernier plan de face ; sons des compétences multipliés par trois. Volume de la cinématique et ID audio conservés.')
out=r/'integration/polaricrax/v3'
(out/'finish-payload.json').write_text(json.dumps({'modules':modules,'wraps':[]},ensure_ascii=False,indent=2)+'\n')
(out/'AJUSTER_FACE_ET_SONS_POLARICRAX.lua').write_text(s)
print('POLARI FINISH: client + audio, revision 6; face based on eyes, skill gain x3, cinematic gain unchanged')
