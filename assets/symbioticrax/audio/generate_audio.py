"""Original synthetic sounds, individual WAVs + one indexed atlas with 120ms gaps."""
from pathlib import Path
import math,random,wave,struct,json
out=Path(__file__).resolve().parent;rate=44100
specs=[('TonguePrepare',.35),('TongueLaunch',.32),('TongueMiss',.4),('Capture',.25),('Pull',.6),('Bite',.34),('Mark',.18),('Burst',.65),('Heal',.45),('ArmourStart',.6),('ArmourHit',.16),('ArmourEnd',.5),('ParasiteStart',.4),('ParasiteAttach',.3),('ParasiteReturn',.4),('ParasiteMerge',.55),('MaxDeploy',1.3),('MaxCapture',.7),('MaxBite',.8),('MaxRetract',1),('MaxTitle',.7)]
atlas=[];manifest={}
def write(p,data):
 with wave.open(str(p),'wb')as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(struct.pack('<'+'h'*len(data),*data))
for i,(name,duration)in enumerate(specs):
 n=round(rate*duration);rng=random.Random(77103+i);samples=[];low=0;phase=0
 for j in range(n):
  t=j/rate;u=j/(n-1);low=.86*low+.14*rng.uniform(-1,1);freq=max(30,115+(i%5)*28+(100 if 'Start'in name or 'Prepare'in name else -70)*u);phase+=math.tau*freq/rate
  voice=.5*math.sin(phase+2*math.sin(math.tau*8*t))+.2*math.sin(phase*1.49)+.8*low
  env=min(1,t/.009,(duration-t)/.014)*(1-u)**(.6 if name=='Pull'else 1.5);samples.append(voice*max(0,env))
 peak=max(map(abs,samples));pcm=[round(v*.46/peak*32767)for v in samples];write(out/(name+'.wav'),pcm)
 start=len(atlas)/rate;atlas.extend(pcm);manifest[name]={'Start':start,'End':len(atlas)/rate,'Loop':name=='Pull','file':name+'.wav'};atlas.extend([0]*round(.12*rate))
write(out/'SymbiotiCrax_AUDIO_ATLAS.wav',atlas)
(out/'manifest.json').write_text(json.dumps({'sampleRate':rate,'duration':len(atlas)/rate,'atlasRobloxId':'','segments':manifest},indent=2))
root=out.parents[2];lua='return {Duration='+str(len(atlas)/rate)+',Segments={\n'
for name,m in manifest.items():lua+=" ['"+name+"']={Start="+str(m['Start'])+',End='+str(m['End'])+',Loop='+str(m['Loop']).lower()+'},\n'
(root/'src/symbioticrax/CraxSymAudioMap.lua').write_text(lua+'}}\n')
# Browser preview allows listening without Roblox; originals and ranges available.
html='<meta charset="utf-8"><title>SymbiotiCrax — écoute des sons originaux</title><h1>SymbiotiCrax — écoute avant import</h1><p>Fichiers synthétiques originaux. Cette page ne valide pas les permissions Roblox.</p>'
for name in manifest:html+='<p>'+name+'<br><audio controls preload="none" src="'+name+'.wav"></audio></p>'
(out/'ECOUTER.html').write_text(html)
print('AUDIO VERIFIED',len(manifest),'segments;',len(atlas)/rate,'seconds')
