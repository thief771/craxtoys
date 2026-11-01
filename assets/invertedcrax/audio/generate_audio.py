"""Original procedural effects. Python standard library only. No sampled audio."""
import math, random, wave, struct, json
from pathlib import Path
OUT=Path(__file__).parent/'audio';OUT.mkdir(exist_ok=True)
SR=44100
# name, seconds, base frequency, frequency motion, noise mix, rhythmic cuts
SPECS=[('MuteTrigger',.85,160,-100,.18,7),('SilenceApply',.45,660,-420,.07,10),('SilenceEnd',.40,360,320,.04,3),('HackActivate',.65,240,300,.16,12),('HackDirection01',.15,540,-140,.06,13),('HackDirection02',.16,610,-180,.06,14),('HackDirection03',.14,470,-120,.05,12),('CopyCapture',.65,310,520,.08,8),('CopyImpact',.50,105,-65,.30,9),('RewindMark',.80,480,-180,.06,6),('RewindBuild',2.0,130,760,.18,17),('TeleportDepart',.70,900,-820,.18,15),('TeleportArrive',.75,120,540,.12,9),('MarkCancel',.40,320,-220,.07,5),('MaxRise',2.5,95,800,.16,12),('MaxLoop',2.,230,0,.12,16),('MaxFragment',1.2,780,-560,.30,22),('MaxSuction',1.8,520,-450,.20,19),('MaxClose',.65,130,-90,.25,11)]
manifest=[]
for index,(name,duration,base,sweep,noise,cuts) in enumerate(SPECS):
 rng=random.Random(404+index);n=round(SR*duration);phase=0.;samples=[];low=0.
 for i in range(n):
  t=i/SR;u=i/max(1,n-1)
  # Quiet bounded digital timbre, filtered noise and rounded amplitude cuts.
  frequency=max(32,base+sweep*u+9*math.sin(2*math.pi*3*t))
  phase+=2*math.pi*frequency/SR
  low=.84*low+.16*rng.uniform(-1,1)
  tone=.62*math.sin(phase)+.18*math.sin(phase*2.003)+.08*math.sin(phase*.5)
  gate=.48+.52*(.5+.5*math.sin(2*math.pi*cuts*t))**2
  if name=='MaxLoop':
   # Raised-cosine fade at both boundaries; loop contains a brief breath.
   env=min(1,t/.06,(duration-t)/.06)
  elif name in ('RewindBuild','MaxRise','MaxSuction'):
   env=math.sin(math.pi*u)**.65*(.30+.70*u)
  else:
   env=min(1,t/.012)*max(0,1-u)**1.7
  samples.append((tone*(1-noise)+low*noise*3)*gate*env)
 peak=max(map(abs,samples));gain=.55/max(peak,1e-9)
 samples=[x*gain for x in samples]
 pcm=b''.join(struct.pack('<h',round(max(-1,min(1,x))*32767))for x in samples)
 path=OUT/(name+'.wav')
 with wave.open(str(path),'wb')as f:f.setparams((1,2,SR,0,'NONE','not compressed'));f.writeframes(pcm)
 with wave.open(str(path),'rb')as f:
  assert f.getnframes()==n and f.getframerate()==SR and f.getsampwidth()==2
 assert max(map(abs,samples))<.56 and all(math.isfinite(x)for x in samples)
 manifest.append(dict(name=name,file=path.name,seconds=n/SR,peak=round(max(map(abs,samples)),4),rms=round(math.sqrt(sum(x*x for x in samples)/n),4),robloxId=''))
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2))
print(f'{len(manifest)} WAV verified: mono PCM 16-bit, {SR} Hz; peak <= 0.55; no clipping. Not auditioned.')
