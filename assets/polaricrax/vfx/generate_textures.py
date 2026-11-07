"""Deterministic original RGBA particle textures, white so Roblox can tint them."""
from pathlib import Path
import math,struct,zlib,hashlib,json
out=Path(__file__).resolve().parent
size=256

def png(path,rows):
 def chunk(kind,data):return struct.pack('>I',len(data))+kind+data+struct.pack('>I',zlib.crc32(kind+data)&0xffffffff)
 raw=b''.join(b'\0'+row for row in rows)
 path.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',size,size,8,6,0,0,0))+chunk(b'IDAT',zlib.compress(raw,9))+chunk(b'IEND',b''))

def alpha(kind,x,y):
 r=math.hypot(x,y);a=math.atan2(y,x)
 edge=max(0,1-r*r)**2
 if kind=='Flare':
  rays=(.5+.5*math.cos(a*6+.6*math.sin(r*24)))**18
  return min(1,math.exp(-r*r*65)+.45*math.exp(-r*5)+rays*math.exp(-r*8))*edge
 if kind=='Spark':
  arc=math.exp(-((r-(.52+.035*math.sin(a*11)+.018*math.cos(a*23)))/.025)**2)
  breaks=.35+.65*(.5+.5*math.sin(a*7+.5*math.sin(a*19)))
  return min(1,arc*breaks+.18*math.exp(-((r-.52)/.09)**2)+.15*math.exp(-r*r*14))*edge
 turbulence=sum(math.sin(x*f+math.sin(y*f*.83))*math.cos(y*f-x*.6)/2**i for i,f in enumerate((7,15,31,59)))
 return min(1,max(0,.4+.3*turbulence))*math.exp(-r*r*3)*edge

manifest={}
for kind in ('Flare','Spark','Smoke'):
 rows=[]
 for j in range(size):
  row=bytearray()
  for i in range(size):
   x=(i+.5-size/2)/(size/2);y=(j+.5-size/2)/(size/2)
   row.extend((255,255,255,round(255*alpha(kind,x,y))))
  rows.append(bytes(row))
 name='PolariFlux_'+kind+'.png';png(out/name,rows)
 manifest[name]={'size':[size,size],'sha256':hashlib.sha256((out/name).read_bytes()).hexdigest(),'attribute':'Texture_'+kind}
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('POLARI ORIGINAL TEXTURES:',len(manifest),'RGBA PNGs')
