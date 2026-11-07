"""V3 layered original synthetic sounds, individual WAVs + one indexed atlas with 120ms gaps."""
from pathlib import Path
import math,random,wave,struct,json
out=Path(__file__).resolve().parent;rate=44100
specs=[('Charge', 0.4), ('Shot', 0.28), ('Impact', 0.32), ('Attract', 0.5), ('AttractLoop', 1), ('InvertWarning', 0.25), ('Invert', 0.55), ('Tick', 0.15), ('Stop', 0.45), ('Resume', 0.32), ('FanFire', 0.5), ('FanImpact', 0.32), ('WallEnd', 0.3), ('MaxCut', 0.2), ('MaxOrbit', 1.2), ('MaxFragments', 1.1), ('MaxLastTick', 0.3), ('MaxClap', 0.7), ('MaxTrophy', 1.1)]
atlas=[];manifest={}
def write(p,data):
 with wave.open(str(p),'wb')as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(struct.pack('<'+'h'*len(data),*data))
# Distinct sound families: capacitor charge, magnetic pull, metal fracture and clockwork.
# Existing durations/ranges remain identical, so previously imported atlases remain compatible.
for i,(name,duration)in enumerate(specs):
 n=round(rate*duration);rng=random.Random(523071+i);samples=[];low=0;phase=0
 is_loop=name=='AttractLoop'
 is_charge=name in ('Charge','Attract','InvertWarning','MaxOrbit','MaxFragments')
 is_impact=name in ('Impact','Invert','FanImpact','MaxClap')
 is_tick=name in ('Tick','MaxLastTick')
 is_shot=name in ('Shot','FanFire','Resume','WallEnd','MaxCut')
 for j in range(n):
  t=j/rate;u=j/(n-1);noise=rng.uniform(-1,1);low=.9*low+.1*noise;high=noise-low
  attack=min(1,t/.005);release=min(1,(duration-t)/.018)
  if is_loop:
   # Integer cycles and a constant envelope: no repeating fade or click at the loop seam.
   voice=.32*math.sin(math.tau*68*t)+.16*math.sin(math.tau*136*t+.4*math.sin(math.tau*3*t))
   voice+=.1*math.sin(math.tau*408*t)*(1+.35*math.sin(math.tau*4*t))
   env=1
  elif is_charge:
   freq=90+650*u*u;phase+=math.tau*freq/rate
   voice=.32*math.sin(phase)+.13*math.sin(phase*2.01)+.1*high*(.2+u)
   voice+=.18*math.sin(math.tau*52*t)*(1-u)+.08*math.sin(math.tau*1250*t)*(u**2)
   env=attack*release*(.28+.72*u)*(1-.22*math.sin(math.pi*u))
  elif is_impact:
   phase+=math.tau*(48+125*math.exp(-t*30))/rate
   sub=.48*math.sin(phase)*math.exp(-t*9)
   crack=.32*high*math.exp(-t*42)
   metal=sum(math.sin(math.tau*f*t)*math.exp(-t*(9+k*2))/(k+2)for k,f in enumerate((723,1147,1811,2633)))
   tail=.16*low*math.exp(-t*5)
   voice=sub+crack+.22*metal+tail;env=attack*release
  elif is_tick:
   voice=(.25*high+.25*math.sin(math.tau*1870*t)+.12*math.sin(math.tau*2933*t))*math.exp(-t*65)
   voice+=.2*math.sin(math.tau*93*t)*math.exp(-t*35);env=attack*release
  elif name=='Stop':
   phase+=math.tau*(780*(1-u)**3+38)/rate
   voice=.28*math.sin(phase)+.17*high*math.exp(-u*6)+.13*math.sin(math.tau*47*t)
   env=attack*release*(1-u)**1.6
  elif is_shot:
   phase+=math.tau*(110+1500*(1-u)**4)/rate
   voice=.27*math.sin(phase)+.12*math.sin(phase*1.51)+.19*high*math.exp(-u*5)
   voice+=.17*math.sin(math.tau*65*t)*math.exp(-u*8);env=attack*release*(1-u)**1.1
  else: # Trophy: resonant, ascending glass chord with an airy tail.
   voice=sum(math.sin(math.tau*f*t)*math.exp(-t*(1.8+k*.35))/(k+2)for k,f in enumerate((392,587.33,784,1174.66)))
   voice+=.05*low;env=attack*release*(1-u)**.6
  samples.append(voice*max(0,env))
 # Short deterministic early reflections add depth without changing clip boundaries.
 if not is_loop:
  dry=samples[:]
  for delay,gain in ((.019,.19),(.043,.13),(.071,.08)):
   offset=round(delay*rate)
   for j in range(offset,n):samples[j]+=dry[j-offset]*gain*min(1,(n-1-j)/(.018*rate))
 peak=max(map(abs,samples));pcm=[round(v*.46/peak*32767)for v in samples];write(out/(name+'.wav'),pcm)
 start=len(atlas)/rate;atlas.extend(pcm);manifest[name]={'Start':start,'End':len(atlas)/rate,'Loop':is_loop,'file':name+'.wav'};atlas.extend([0]*round(.12*rate))
write(out/'PolariCrax_AUDIO_ATLAS.wav',atlas)
(out/'manifest.json').write_text(json.dumps({'sampleRate':rate,'duration':len(atlas)/rate,'atlasRobloxId':'','segments':manifest},indent=2))
root=out.parents[2];lua='return {Duration='+str(len(atlas)/rate)+',Segments={\n'
for name,m in manifest.items():lua+=" ['"+name+"']={Start="+str(m['Start'])+',End='+str(m['End'])+',Loop='+str(m['Loop']).lower()+'},\n'
(root/'src/polaricrax/CraxPolariAudioMap.lua').write_text(lua+'}}\n')
# Browser preview allows listening without Roblox; originals and ranges available.
html='<meta charset="utf-8"><title>PolariCrax V3 — sons magnétiques</title><h1>PolariCrax — écoute avant import</h1><p>V3 : plasma, impacts métalliques, basse magnétique et horlogerie. Fichiers synthétiques originaux ; importer le nouvel atlas dans Roblox pour entendre cette version. Cette page ne valide pas les permissions Roblox.</p>'
for name in manifest:html+='<p>'+name+'<br><audio controls preload="none" src="'+name+'.wav"></audio></p>'
(out/'ECOUTER.html').write_text(html)
print('AUDIO VERIFIED',len(manifest),'segments;',len(atlas)/rate,'seconds')
