"""Fresh Blender reimport; geometry/markers check, not Roblox import validation."""
import bpy,json
from pathlib import Path
p=Path(__file__).resolve().parent
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=str(p/'SuperCrax_ACCESSOIRES_IMPORT.fbx'))
meshes=[o for o in bpy.data.objects if o.type=='MESH'];names={o.name for o in meshes}
required={'SuperHairCap','SuperCurl','SuperChinBlue','SuperEmblem_RedShield','SuperEmblem_YellowField','SuperEmblem_S','FIT_HeadCenter','FIT_Front','FIT_Up'}
assert required<=names
assert len(meshes)==18
assert all(n.startswith(('Super','FIT_'))for n in names)
c,f,u=[bpy.data.objects[n].matrix_world.translation for n in ['FIT_HeadCenter','FIT_Front','FIT_Up']]
assert abs((f-c).normalized().dot((u-c).normalized()))<1e-6
assert abs((f-c).length-(u-c).length)<1e-5
assert all(len(o.data.vertices)>0 and len(o.data.polygons)>0 for o in meshes)
result={'reimport':'Blender 4.3.2 FBX','meshParts':len(meshes)-3,'fitMarkers':3,'orthogonal':True,'allPartsNonempty':True,'bodyParts':0,'names':sorted(names)}
(p/'validation-fbx.json').write_text(json.dumps(result,indent=2)+'\n');print('FBX ROUNDTRIP PASS',len(meshes),'meshes')
