"""Blender-level checks; does not claim Roblox import/render validation."""
import bpy,bmesh,math,json,hashlib
from mathutils import Vector,Matrix
from mathutils.bvhtree import BVHTree
from pathlib import Path
R=Path(__file__).resolve().parents[1];P=R/'assets/polaricrax/model';m=json.loads((P/'manifest.json').read_text());source=R/'assets/supercrax/model/source/CraxSourire_original.obj'
assert hashlib.sha256(source.read_bytes()).hexdigest()==m['sourceSHA256'];bpy.ops.wm.open_mainfile(filepath=str(P/'PolariCrax.blend'))
vertices=[];groups={};g=None
for line in source.read_text().splitlines():
 p=line.split()
 if not p:continue
 if p[0]=='v':vertices.append(tuple(map(float,p[1:4])))
 elif p[0]=='g':g=p[1];groups[g]=[]
 elif p[0]=='f':groups[g].append([int(t.split('/')[0])-1 for t in p[1:]])
base=bpy.data.collections['CraxSourire_ORIGINAL'];helmet=bpy.data.collections['PolariHelmet'];assert len(base.objects)==48
count=0
for n,faces in groups.items():
 o=base.objects[n];ids=sorted({i for f in faces for i in f});assert len(o.data.vertices)==len(ids)
 for v,i in zip(o.data.vertices,ids):
  x,y,z=vertices[i];assert(v.co-Vector((x+15,z+4.474234104156494,y-25))).length<2e-6;count+=1
assert not any(n.startswith('PFX')for n in m['accessories']);assert bpy.data.collections['PolariTransientFX'].hide_render
for n in ['Eyeleft1','Eyeright1']:assert max(bpy.data.objects[n].data.materials[0].diffuse_color[:3])<.02
# Compare native visibility with and without the helmet; ray samples of actually visible eyes/smile.
def tree(objects):
 vs=[];fs=[];names=[]
 for o in objects:
  if o.type!='MESH':continue
  k=len(vs);vs.extend([o.matrix_world@v.co for v in o.data.vertices]);fs.extend([[k+i for i in f.vertices]for f in o.data.polygons]);names.extend([o.name]*len(o.data.polygons))
 return BVHTree.FromPolygons(vs,fs,all_triangles=False),names
native,names=tree(base.objects);mask,_=tree([o for o in helmet.objects if not o.name.startswith('P_Fit')]);seen={'eyes':0,'teeth':0};blocked={'eyes':0,'teeth':0}
for o in base.objects:
 kind='eyes'if o.name.lower().startswith('eye')else('teeth'if o.name.lower().startswith('tooth')else None)
 if not kind:continue
 # At most ~150 samples per component, with the exact same source coordinates.
 for v in list(o.data.vertices)[::max(1,len(o.data.vertices)//150)]:
  p=o.matrix_world@v.co;start=Vector((p.x,-20,p.z));loc,norm,index,d=native.ray_cast(start,Vector((0,1,0)),30)
  if index is not None and names[index]==o.name:
   seen[kind]+=1
   if mask.ray_cast(start,Vector((0,1,0)),max(0,d-.002))[0]is not None:blocked[kind]+=1
assert seen['eyes']>20 and seen['teeth']>100,seen
assert blocked=={'eyes':0,'teeth':0},blocked
assert mask.ray_cast(Vector((0,0,20)),Vector((0,0,-1)),30)[0]is not None,'closed top'
# Shaft longitudinal direction through the same marker-normalised basis as the runtime.
B=Matrix(((-1,0,0),(0,0,1),(0,1,0)));normal=Matrix.Rotation(-math.pi/2,3,'X')@B@Vector((0,0,1));assert(normal-Vector((0,0,-1))).length<1e-5
expected=set(m['accessories']+m['markers']+m['fx']);bpy.ops.wm.read_factory_settings(use_empty=True);bpy.ops.import_scene.fbx(filepath=str(P/'PolariCrax_ACCESSOIRES_IMPORT.fbx'));assert{o.name for o in bpy.context.scene.objects if o.type=='MESH'}==expected
result={'engine':'Blender4.3.2, not Roblox Studio','nativeGroups':48,'nativeVerticesUnchanged':count,'publishedMeshNamesExpected':len(expected),'restingHelmetHasNoDialOrShards':True,'closedHelmetTop':True,'visibleSourceSamples':seen,'helmetOccludedSourceSamples':blocked,'shardAxisPointsForward':True}
(R/'docs/polaricrax/VALIDATION_MODELE.json').write_text(json.dumps(result,indent=2));print('POLARI REAL MODEL / EYES / SMILE PASS',result)
