"""Validate shipped texture pixels and V3 sound boundaries, including loop seam."""
from pathlib import Path
import hashlib,json,struct,wave,zlib
r=Path(__file__).resolve().parents[1];folder=r/'assets/polaricrax/vfx'
for name,meta in json.loads((folder/'manifest.json').read_text()).items():
 data=(folder/name).read_bytes();assert hashlib.sha256(data).hexdigest()==meta['sha256']
 assert data[:8]==b'\x89PNG\r\n\x1a\n';pos=8;compressed=b''
 while pos<len(data):
  length=struct.unpack('>I',data[pos:pos+4])[0];kind=data[pos+4:pos+8];chunk=data[pos+8:pos+8+length]
  assert zlib.crc32(kind+chunk)&0xffffffff==struct.unpack('>I',data[pos+8+length:pos+12+length])[0]
  if kind==b'IHDR':assert struct.unpack('>IIBBBBB',chunk)==(256,256,8,6,0,0,0)
  if kind==b'IDAT':compressed+=chunk
  pos+=length+12
 raw=zlib.decompress(compressed);assert len(raw)==256*(1+256*4)
 alphas=[]
 for y in range(256):
  row=raw[y*1025:(y+1)*1025];assert row[0]==0;alphas.extend(row[4::4])
 assert max(alphas)>70 and min(alphas)==0 and len(set(alphas))>50,'missing transparent detail'
 for i in range(256):assert alphas[i]==alphas[-i-1]==alphas[i*256]==alphas[i*256+255]==0,'texture edge must fade out'
with wave.open(str(r/'assets/polaricrax/audio/AttractLoop.wav'),'rb')as w:
 values=struct.unpack('<'+'h'*w.getnframes(),w.readframes(w.getnframes()))
 assert abs(values[-1]-values[0])<32767*.02,'loop seam clicks'
 # Continuous magnetic drone must not repeat an envelope fade to silence every second.
 for start in range(0,len(values)-4410,4410):
  rms=(sum(v*v for v in values[start:start+4410])/4410)**.5
  assert rms>32767*.08,'loop unexpectedly falls silent'
canonical={p.name:p.read_text()for p in(r/'src/polaricrax').glob('*.lua')}
payload=json.loads((r/'integration/polaricrax/v3/payload.json').read_text())
for module in payload['modules']:
 name=module['path'].split('.')[-1]+('.client.lua'if module['className']=='LocalScript'else'.lua')
 assert module['source']==canonical[name],'stale update payload'
 assert(r/'integration/polaricrax/version-actuelle/sources'/(module['path']+'.lua')).read_text()==canonical[name],'stale current sources'
print('POLARI V3 ASSETS PASS: 3 transparent textures, PNG checksums/CRCs, seamless drone, canonical updater sources')
