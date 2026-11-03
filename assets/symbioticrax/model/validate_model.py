"""Verify real native vertex conservation and fresh FBX import. Not a Roblox test."""
import bpy,json
from pathlib import Path
p=Path(__file__).resolve().parent;m=json.loads((p/'manifest.json').read_text())
bpy.ops.wm.open_mainfile(filepath=str(p/'SymbiotiCrax.blend'));error=0;vertices=0
for o in bpy.data.collections['CraxSourire_Native'].objects:
 source=bpy.data.objects[o.name+'_SOURCE'];assert len(o.data.vertices)==len(source.data.vertices)
 for a,b in zip(o.data.vertices,source.data.vertices):error=max(error,(a.co-b.co).length);vertices+=1
assert error==0
bpy.ops.wm.read_factory_settings(use_empty=True);bpy.ops.import_scene.fbx(filepath=str(p/'SymbiotiCrax_ACCESSOIRES_IMPORT.fbx'))
parts=[o for o in bpy.data.objects if o.type=='MESH'];assert {o.name for o in parts}==set(m['accessories']+m['markers'])
assert all(len(o.data.vertices)>0 and len(o.data.polygons)>0 for o in parts)
c,f,u=[bpy.data.objects[n].matrix_world.translation for n in ['FIT_HeadCenter','FIT_Front','FIT_Up']];assert abs((f-c).normalized().dot((u-c).normalized()))<1e-6
result={'nativeVerticesChecked':vertices,'nativeVertexMaxError':error,'accessoryMeshes':len(m['accessories']),'markers':len(m['markers']),'orthogonal':True,'fbxRoundtrip':'Blender 4.3.2','body':False,'trianglesAfterImport':sum(len(o.data.polygons)for o in parts)}
(p/'validation.json').write_text(json.dumps(result,indent=2)+'\n');print('SYM MODEL VALIDATION PASS',result)
