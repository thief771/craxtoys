"""Execute in Blender: verifies native coordinates, actual imported FX and die orientations."""
import bpy,math,json,hashlib
from mathutils import Vector,Matrix,Euler
from pathlib import Path
R=Path(__file__).resolve().parents[1];P=R/'assets/luckycrax/model';m=json.loads((P/'manifest.json').read_text());source=R/'assets/supercrax/model/source/CraxSourire_original.obj'
assert hashlib.sha256(source.read_bytes()).hexdigest()==m['sourceSHA256']
bpy.ops.wm.open_mainfile(filepath=str(P/'LuckyCrax.blend'))
vs=[];groups={};g=None
for line in source.read_text().splitlines():
 p=line.split()
 if not p:continue
 if p[0]=='v':vs.append(tuple(map(float,p[1:4])))
 elif p[0]=='g':g=p[1];groups[g]=[]
 elif p[0]=='f':groups[g].append([int(t.split('/')[0])-1 for t in p[1:]])
base=bpy.data.collections['LuckyCrax_CANONICAL'];assert len(base.objects)==len(groups)==48
count=0
for name,faces in groups.items():
 o=base.objects[name];ids=sorted({i for f in faces for i in f});assert len(o.data.vertices)==len(ids)
 for v,i in zip(o.data.vertices,ids):
  x,y,z=vs[i];assert(v.co-Vector((x+15,z+4.474234104156494,y-25))).length<2e-6;count+=1
 if name.lower().startswith('tooth'):assert o.data.materials[0].name.startswith('LuckyGold')
assert not any(any(n in o.name.lower()for n in ['body','torso','leg','arm'])for o in base.objects)
# The fitting markers define canonical local X=-sourceX,Y=sourceZ,Z=sourceY.
B=Matrix(((-1,0,0),(0,0,1),(0,1,0)))
rx=lambda a:Matrix.Rotation(a,3,'X');ry=lambda a:Matrix.Rotation(a,3,'Y');rz=lambda a:Matrix.Rotation(a,3,'Z');pi=math.pi
faces=[('1',(0,0,0)),('6',(pi,0,0)),('2',(0,pi/2,0)),('5',(0,-pi/2,0)),('3',(pi/2,0,0)),('4',(-pi/2,0,0))]
rot=[rx(-pi/2),rz(-pi/2)@ry(-pi/2),Matrix.Identity(3),rz(pi)@ry(pi),rz(pi/2)@ry(pi/2),rx(pi/2)]
for d,e in faces:
 mesh=bpy.data.objects['LFX_Digit_'+d];M=rot[int(d)-1]@B@mesh.rotation_euler.to_matrix();assert(M@Vector((0,0,1))-Vector((0,0,-1))).length<1e-5;assert(M@Vector((0,1,0))-Vector((0,1,0))).length<1e-5
for a,b in [('1','6'),('2','5'),('3','4')]:
 na=bpy.data.objects['LFX_Digit_'+a].rotation_euler.to_matrix()@Vector((0,0,1));nb=bpy.data.objects['LFX_Digit_'+b].rotation_euler.to_matrix()@Vector((0,0,1));assert na.dot(nb)<-.999
leafcenters=[bpy.data.objects['LFX_CloverLeaf_'+str(i)].location.copy()for i in range(4)];assert all((a-b).length>.5 for i,a in enumerate(leafcenters)for b in leafcenters[i+1:])
# Verify the exported file, not just Blender's source collection.
bpy.ops.wm.read_factory_settings(use_empty=True);bpy.ops.import_scene.fbx(filepath=str(P/'LuckyCrax_FX_IMPORT.fbx'));actual={o.name for o in bpy.context.scene.objects if o.type=='MESH'};assert actual==set(m['fx'])
result={'nativeGroups':48,'nativeVerticesUnchanged':count,'fxMeshesReimported':len(actual),'diceFacesFrontAndUpright':6,'oppositePairs':['1/6','2/5','3/4'],'distinctHeartLeaves':4,'body':False,'engine':'Blender4.3.2; not Roblox Studio'}
(R/'docs/luckycrax/VALIDATION_MODELE.json').write_text(json.dumps(result,indent=2));print('LUCKY MODEL PASS',result)
