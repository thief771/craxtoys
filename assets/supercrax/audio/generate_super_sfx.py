"""Original procedural SFX, standard Python, no samples. No Roblox IDs are invented."""
from pathlib import Path
import math,random,struct,wave,json
OUT=Path(__file__).resolve().parent;SR=44100
SPECS=[('SteelStart',.55,145,460,.12),('CircleDash',.50,95,70,.22),('DashHit',.33,105,-60,.26),('SteelEnd',.35,420,-230,.05),('LaserStart',.35,340,780,.06),('LaserLoop',.50,330,0,.04),('LaserEnd',.32,640,-410,.08),('FrostCharge',2.,170,210,.28),('FrostLoop',.70,130,0,.42),('FreezeApply',.65,950,-430,.14),('IceShatter',.9,1450,-860,.40),('LastStand',.85,155,520,.12),('KryptoniteSpawn',1.1,105,145,.15),('KryptonitePickup',.5,310,390,.08),('KryptoniteDeath',1.05,440,-365,.26),('FinaleFly',1.1,145,-65,.22),('FinaleLaserCharge',1.5,220,1040,.10),('FinaleLaserShot',.55,710,-280,.13),('FinaleShatter',1.55,1850,-1350,.37)]
manifest=[]
for index,(name,duration,base,sweep,noise)in enumerate(SPECS):
 rng=random.Random(771+index);phase=0.;slow=0.;samples=[];n=round(duration*SR)
 loop=name in ('CircleDash','LaserLoop','FrostLoop')
 for i in range(n):
  t=i/SR;u=i/(n-1);frequency=max(35,base+sweep*u)
  phase+=2*math.pi*frequency/SR
  slow=.89*slow+.11*rng.uniform(-1,1)
  if 'Frost'in name:core=.3*math.sin(phase)+.12*math.sin(phase*1.997)+slow*2.2
  elif 'Shatter'in name or name=='FreezeApply':
   core=sum(math.sin(phase*k+index*.17)*math.exp(-u*(2+k*.15))/(k+1)for k in (1,2.71,4.17,6.33))+slow*1.5
  else:core=.66*math.sin(phase)+.18*math.sin(phase*2.003)+.08*math.sin(phase*.5)
  value=core*(1-noise)+slow*noise*2
  if loop:envelope=min(1,t/.014,(duration-t)/.014)*(.88+.12*math.sin(2*math.pi*6*t))
  elif 'Charge'in name:envelope=math.sin(math.pi*u)**.5*(.18+.82*u)
  else:envelope=min(1,t/.01)*(1-u)**1.65
  samples.append(value*max(0,envelope))
 peak=max(map(abs,samples));gain=.48/max(peak,1e-9);samples=[v*gain for v in samples]
 pcm=b''.join(struct.pack('<h',round(v*32767))for v in samples)
 path=OUT/(name+'.wav')
 with wave.open(str(path),'wb')as w:w.setparams((1,2,SR,0,'NONE','not compressed'));w.writeframes(pcm)
 with wave.open(str(path),'rb')as w:assert w.getnframes()==n and w.getsampwidth()==2 and w.getframerate()==SR
 assert all(math.isfinite(v)and abs(v)<=.480001 for v in samples)
 manifest.append({'name':name,'file':path.name,'seconds':n/SR,'loop':loop,'peak':max(map(abs,samples)),'rms':math.sqrt(sum(v*v for v in samples)/n),'robloxId':''})
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2))
print('Verified',len(manifest),'original mono PCM16 WAVs, 44100 Hz, peak <= 0.48; not auditioned.')
