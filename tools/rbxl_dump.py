import struct, sys, json, lz4.block, zstandard
def rd_ints(b, n):
    # interleaved big-endian int32, zigzag
    out=[]
    for i in range(n):
        v=(b[i]<<24)|(b[i+n]<<16)|(b[i+2*n]<<8)|b[i+3*n]
        out.append((v>>1) ^ -(v&1))
    return out
def refs(b,n):
    r=rd_ints(b,n); acc=0; o=[]
    for x in r: acc+=x; o.append(acc)
    return o
def parse(path):
    d=open(path,'rb').read()
    assert d[:8]==b'<roblox!'
    ncls,ninst=struct.unpack('<ii',d[18:26]); p=32
    classes={}; inst={}; props={}; parent={}
    while p<len(d):
        name=d[p:p+4]; cl,ul=struct.unpack('<II',d[p+4:p+12]); p+=16
        if cl==0: body=d[p:p+ul]; p+=ul
        else:
            raw=d[p:p+cl]; p+=cl
            body=zstandard.ZstdDecompressor().decompress(raw,max_output_size=ul) if raw[:4]==b'\x28\xb5\x2f\xfd' else lz4.block.decompress(raw,uncompressed_size=ul)
        if name==b'INST':
            cid,=struct.unpack('<I',body[:4]); sl,=struct.unpack('<I',body[4:8]); cn=body[8:8+sl].decode(); q=8+sl+1
            n,=struct.unpack('<I',body[q:q+4]); q+=4; rs=refs(body[q:],n)
            classes[cid]=(cn,rs)
            for r in rs: inst[r]={'ClassName':cn}
        elif name==b'PROP':
            cid,=struct.unpack('<I',body[:4]); sl,=struct.unpack('<I',body[4:8]); pn=body[8:8+sl].decode(errors='replace'); t=body[8+sl]; q=9+sl
            if t==1 and pn in ('Name','Source','AttributesSerialize','Value','Tags','Text','Image','SoundId','Texture','MeshId','TextureID'):
                cn,rs=classes[cid]
                for r in rs:
                    l,=struct.unpack('<I',body[q:q+4]); v=body[q+4:q+4+l]; q+=4+l
                    inst[r][pn]=v
        elif name==b'PRNT':
            n,=struct.unpack('<I',body[1:5]); c=refs(body[5:],n); pa=refs(body[5+4*n:],n)
            for a,b in zip(c,pa): parent[a]=b
        elif name==b'END\0': break
    return inst,parent
def paths(inst,parent):
    cache={}
    def fp(r):
        if r in cache: return cache[r]
        nm=inst[r].get('Name',b'?').decode(errors='replace')
        pr=parent.get(r,-1)
        s=nm if pr==-1 or pr not in inst else fp(pr)+'.'+nm
        cache[r]=s; return s
    return {r:fp(r) for r in inst}

if __name__ == '__main__':
    # Usage : python3 -I tools/rbxl_dump.py place.rbxl dossier_sortie
    # Écrit tree.txt (chemin + classe) et scripts/<chemin>.<Classe>.lua. Nécessite : pip install lz4 zstandard
    import os
    src, out = sys.argv[1], sys.argv[2]
    inst, par = parse(src); P = paths(inst, par)
    os.makedirs(os.path.join(out, 'scripts'), exist_ok=True)
    with open(os.path.join(out, 'tree.txt'), 'w') as tree:
        for r, p in sorted(P.items(), key=lambda x: x[1]):
            c = inst[r]['ClassName']; tree.write(f'{p}\t{c}\n')
            if 'Source' in inst[r] and c in ('Script', 'LocalScript', 'ModuleScript'):
                open(os.path.join(out, 'scripts', p.replace('/', '_') + '.' + c + '.lua'), 'wb').write(inst[r]['Source'])
    print(len(inst), 'instances')
