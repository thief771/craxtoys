"""Package current code/resources without node_modules, Git metadata or nested old ZIPs."""
from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parents[1];DIST=ROOT/'dist';DIST.mkdir(exist_ok=True)
paths=[]
for name in ['README.md','ETAT-INTEGRATION.md','package.json','package-lock.json']:
 paths.append(ROOT/name)
for name in ['assets/invertedcrax','src','integration','tests','tools']:
 for p in (ROOT/name).rglob('*'):
  if p.is_file()and p.suffix not in {'.zip','.pyc','.log'}and'__pycache__'not in p.parts:paths.append(p)
paths=sorted(set(paths));sums=[]
for p in paths:sums.append(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.relative_to(ROOT).as_posix())
checksum='\n'.join(sums)+'\n'
archive=DIST/'InvertedCrax-TOTAL.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED)as z:
 for p in paths:z.write(p,p.relative_to(ROOT))
 z.writestr('SHA256SUMS',checksum)
with zipfile.ZipFile(archive)as z:
 assert z.testzip()is None
 for line in sums:
  expected,name=line.split('  ',1);assert hashlib.sha256(z.read(name)).hexdigest()==expected
(DIST/'InvertedCrax-TOTAL.sha256').write_text(hashlib.sha256(archive.read_bytes()).hexdigest()+'  InvertedCrax-TOTAL.zip\n')
print('TOTAL ZIP VERIFIED:',len(paths)+1,'files;',round(archive.stat().st_size/1048576,2),'MiB; CRC + SHA-256 checks passed')
