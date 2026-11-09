"""Small deterministic V3 delivery, CRC + SHA256 checked, without old place binaries."""
from pathlib import Path
import hashlib,zipfile
r=Path(__file__).resolve().parents[1]
paths=[r/p for p in ['integration/polaricrax/BRANCHER_ASSETS_POLARICRAX.lua','integration/polaricrax/DIAGNOSTIC_AUDIO_CLIENT.lua','integration/polaricrax/v2/METTRE_A_JOUR_POLARICRAX_V2.lua','integration/polaricrax/version-actuelle/INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua','integration/polaricrax/version-actuelle/INSTALLER-DANS-LE-JEU.md','tools/build_polari_v3.py','tools/build_polari_audio_fix.py','tools/build_polari_finale.py','tools/build_polari_finish.py','tools/build_polari_mirror.py','tools/package_polari_v3.py']]
for folder in ['integration/polaricrax/v3','assets/polaricrax/audio','assets/polaricrax/vfx','src/polaricrax']:
 paths.extend(p for p in(r/folder).rglob('*')if p.is_file()and '__pycache__'not in p.parts)
paths=sorted(set(paths));target=r/'dist/PolariCrax-V3-VFX-AUDIO.zip';sums={}
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6)as z:
 for p in paths:
  name=p.relative_to(r).as_posix();data=p.read_bytes();sums[name]=hashlib.sha256(data).hexdigest()
  info=zipfile.ZipInfo(name,(2026,11,7,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o644<<16;z.writestr(info,data)
 info=zipfile.ZipInfo('LIRE-MOI.md',(2026,11,7,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;z.writestr(info,(r/'integration/polaricrax/v3/README.md').read_bytes())
 sums['LIRE-MOI.md']=hashlib.sha256((r/'integration/polaricrax/v3/README.md').read_bytes()).hexdigest()
 info=zipfile.ZipInfo('SHA256SUMS',(2026,11,7,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;z.writestr(info,'\n'.join(v+'  '+k for k,v in sums.items())+'\n')
with zipfile.ZipFile(target)as z:
 assert z.testzip()is None
 for name,digest in sums.items():assert hashlib.sha256(z.read(name)).hexdigest()==digest
(target.with_suffix('.zip.sha256')).write_text(hashlib.sha256(target.read_bytes()).hexdigest()+'  '+target.name+'\n')
print('POLARI V3 DELIVERY PASS:',len(sums),'files,',target.stat().st_size,'bytes, CRC/SHA256 verified')
