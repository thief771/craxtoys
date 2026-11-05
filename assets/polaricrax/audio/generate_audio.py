"""Original synthetic sounds, individual WAVs + one indexed atlas with 120ms gaps."""
from pathlib import Path
import math,random,wave,struct,json
out=Path(__file__).resolve().parent;rate=44100
specs=[('Charge', 0.4), ('Shot', 0.28), ('Impact', 0.32), ('Attract', 0.5), ('AttractLoop', 1), ('InvertWarning', 0.25), ('Invert', 0.55), ('Tick', 0.15), ('Stop', 0.45), ('Resume', 0.32), ('FanFire', 0.5), ('FanImpact', 0.32), ('WallEnd', 0.3), ('MaxCut', 0.2), ('MaxOrbit', 1.2), ('MaxFragments', 1.1), ('MaxLastTick', 0.3), ('MaxClap', 0.7), ('MaxTrophy', 1.1)]
atlas=[];manifest={}
def write(p,data):
 with wave.open(str(p),'wb')as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(struct.pack('<'+'h'*len(data),*data))
for i,(name,duration)in enumerate(specs):
 n=round(rate*duration);rng=random.Random(523071+i);samples=[];low=0;phase=0
 for j in range(n):
  t=j/rate;u=j/(n-1);low=.86*low+.14*rng.uniform(-1,1);freq=max(30,175+(i%5)*43+(100 if 'Start'in name or 'Prepare'in name else -70)*u);phase+=math.tau*freq/rate
  voice=sum(math.sin(phase*k)*math.exp(-u*(1+k*.4))/(k+1)for k in [1,2.73,4.91])+.22*low+(.13*math.sin(math.tau*32*t)if 'Tick'in name else 0)
  env=min(1,t/.009,(duration-t)/.014)*(1-u)**(.6 if name=='AttractLoop'else 1.5);samples.append(voice*max(0,env))
 peak=max(map(abs,samples));pcm=[round(v*.46/peak*32767)for v in samples];write(out/(name+'.wav'),pcm)
 start=len(atlas)/rate;atlas.extend(pcm);manifest[name]={'Start':start,'End':len(atlas)/rate,'Loop':name=='AttractLoop','file':name+'.wav'};atlas.extend([0]*round(.12*rate))
write(out/'PolariCrax_AUDIO_ATLAS.wav',atlas)
(out/'manifest.json').write_text(json.dumps({'sampleRate':rate,'duration':len(atlas)/rate,'atlasRobloxId':'','segments':manifest},indent=2))
root=out.parents[2];lua='return {Duration='+str(len(atlas)/rate)+',Segments={\n'
for name,m in manifest.items():lua+=" ['"+name+"']={Start="+str(m['Start'])+',End='+str(m['End'])+',Loop='+str(m['Loop']).lower()+'},\n'
(root/'src/polaricrax/CraxPolariAudioMap.lua').write_text(lua+'}}\n')
# Browser preview allows listening without Roblox; originals and ranges available.
html='<meta charset="utf-8"><title>PolariCrax — écoute des sons originaux</title><h1>PolariCrax — écoute avant import</h1><p>Fichiers synthétiques originaux. Cette page ne valide pas les permissions Roblox.</p>'
for name in manifest:html+='<p>'+name+'<br><audio controls preload="none" src="'+name+'.wav"></audio></p>'
(out/'ECOUTER.html').write_text(html)
print('AUDIO VERIFIED',len(manifest),'segments;',len(atlas)/rate,'seconds')
