"""Reproducible LuckyCrax integration archive, verified CRC and SHA256, no node_modules."""
from pathlib import Path
import hashlib,zipfile
root=Path(__file__).resolve().parents[1];dist=root/'dist';dist.mkdir(exist_ok=True)
paths=[root/p for p in ['README.md','package.json','package-lock.json','.gitignore','ETAT-INTEGRATION.md']]
# Include old tests/sources because npm test intentionally runs their regression suite too.
for name in ['assets','src','integration','tests','tools','docs']:
 for p in (root/name).rglob('*'):
  if p.is_file()and p.suffix not in {'.zip','.pyc','.log','.blend1','.blend2'}and'__pycache__'not in p.parts:paths.append(p)
paths=sorted(set(paths));archive=dist/'LuckyCrax-TOTAL.zip';sums=[]
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6)as z:
 for p in paths:
  name=p.relative_to(root).as_posix();data=p.read_bytes();sums.append(hashlib.sha256(data).hexdigest()+'  '+name)
  info=zipfile.ZipInfo(name,(2026,11,4,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o644<<16;z.writestr(info,data)
 info=zipfile.ZipInfo('SHA256SUMS',(2026,11,4,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;z.writestr(info,'\n'.join(sums)+'\n')
with zipfile.ZipFile(archive)as z:
 assert z.testzip()is None
 for line in sums:
  digest,name=line.split('  ',1);assert hashlib.sha256(z.read(name)).hexdigest()==digest
(dist/'LuckyCrax-TOTAL.sha256').write_text(hashlib.sha256(archive.read_bytes()).hexdigest()+'  LuckyCrax-TOTAL.zip\n')
print('LUCKYCRAX ZIP VERIFIED:',len(paths)+1,'files;',round(archive.stat().st_size/1048576,2),'MiB; CRC and SHA256 all pass')
