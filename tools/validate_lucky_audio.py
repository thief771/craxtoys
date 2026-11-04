from pathlib import Path
import json,wave,struct,hashlib
root=Path(__file__).resolve().parents[1];p=root/'assets/luckycrax/audio';m=json.loads((p/'manifest.json').read_text());clips=m['segments'];assert len(clips)==25
with wave.open(str(p/'LuckyCrax_AUDIO_ATLAS.wav'),'rb')as w:
 assert(w.getnchannels(),w.getsampwidth(),w.getframerate())==(1,2,44100)
 atlas=w.readframes(w.getnframes());assert w.getnframes()==round(m['duration']*44100)
previous=0
for name,c in clips.items():
 start,end=round(c['Start']*44100),round(c['End']*44100);assert start>=previous and end>start
 with wave.open(str(p/c['file']),'rb')as w:
  data=w.readframes(w.getnframes());assert w.getnframes()==end-start and data==atlas[start*2:end*2]
 assert max(map(abs,struct.unpack('<'+'h'*(len(data)//2),data)))<.47*32767
 previous=end
assert m['atlasRobloxId']==''
print('LUCKY AUDIO ASSETS PASS:25 clips, exact atlas slices, 16.24s, PCM16 mono44100, peak<0.47, no published ID')
