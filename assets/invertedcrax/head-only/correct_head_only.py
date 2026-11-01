"""Correction : tête seule. Ne modifie ni l'OBJ source ni le modèle précédent."""
import bpy,sys,json
from pathlib import Path
from mathutils import Vector,Matrix
out=Path(sys.argv[sys.argv.index('--')+1]);out.mkdir(exist_ok=True,parents=True)
bpy.ops.wm.open_mainfile(filepath='/workspace/invertedcrax/model/InvertedCrax.blend')
# Remove every outfit object and all old technical markers from this new file.
for name in ['Hoodie_Accessories','IntegrationMarkers_NOT_CHARACTER']:
 c=bpy.data.collections.get(name)
 if c:
  for o in list(c.all_objects):bpy.data.objects.remove(o,do_unlink=True)
  bpy.data.collections.remove(c)
head=bpy.data.collections['CraxSourire_Head_Copy'];H=Vector((0,0,10.3))
for o in head.objects:
 world=o.matrix_world.copy()
 for v in o.data.vertices:v.co=world@v.co-H
 o.matrix_world=Matrix.Identity(4)
# Confirm source head, eyes and teeth retained exactly, apart from float precision.
max_error=0
for o in head.objects:
 if o.name=='Rear_X_Continuous':continue
 ref=bpy.data.objects[o.name+'_SOURCE'];assert len(o.data.vertices)==len(ref.data.vertices)
 for a,b in zip(o.data.vertices,ref.data.vertices):max_error=max(max_error,(a.co-b.co).length)
assert max_error<2e-6,max_error
assert len(head.objects)==25
for o in bpy.context.selected_objects:o.select_set(False)
for o in head.objects:o.select_set(True)
bpy.context.view_layer.objects.active=next(iter(head.objects))
bpy.ops.wm.obj_export(filepath=str(out/'InvertedCrax_TeteSeule.obj'),export_selected_objects=True,forward_axis='NEGATIVE_Z',up_axis='Y',export_materials=True)
bpy.ops.export_scene.fbx(filepath=str(out/'InvertedCrax_TeteSeule.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',add_leaf_bones=False,bake_anim=False)
# New asset needed by an installer retaining the native head rig: only the curved X.
for o in bpy.context.selected_objects:o.select_set(False)
bpy.data.objects['Rear_X_Continuous'].select_set(True)
markers=bpy.data.collections.new('IntegrationMarkers_NOT_CHARACTER');bpy.context.scene.collection.children.link(markers);markers.hide_render=True
for name,loc in [('FIT_HeadCenter',(0,0,0)),('FIT_Front',(0,-4,0)),('FIT_Up',(0,0,4))]:
 bpy.ops.mesh.primitive_cube_add(size=.2,location=loc);o=bpy.context.object;o.name=name
 for c in list(o.users_collection):c.objects.unlink(o)
 markers.objects.link(o);o['IntegrationOnly']=True
for o in bpy.context.selected_objects:o.select_set(False)
for o in markers.objects:o.select_set(True)
bpy.data.objects['Rear_X_Continuous'].select_set(True)
bpy.ops.export_scene.fbx(filepath=str(out/'InvertedCrax_Croix_IMPORT.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',add_leaf_bones=False,bake_anim=False)
# Studio scene is excluded from all mesh exports above.
floor=bpy.data.objects['StudioFloor'];floor.location.z=-4.12
scene=bpy.context.scene;camera=scene.camera;camera.data.ortho_scale=9.6
scene.render.resolution_x=900;scene.render.resolution_y=900;scene.cycles.samples=72
for o in bpy.data.collections['Studio'].objects:
 if o.type=='LIGHT':
  o.location.z-=7;o.rotation_euler=(-o.location).to_track_quat('-Z','Y').to_euler()
for label,loc in [('face',(0,-24,1)),('dos',(0,24,1)),('trois-quarts',(15,-23,4))]:
 camera.location=loc;camera.rotation_euler=(-camera.location).to_track_quat('-Z','Y').to_euler()
 scene.render.filepath=str(out/(label+'.png'));bpy.ops.render.render(write_still=True)
scene['HeadCenterBlender']=(0,0,0);scene['IntegrationStatus']='Head only; body removed; not installed in Roblox'
bpy.ops.wm.save_as_mainfile(filepath=str(out/'InvertedCrax_TeteSeule.blend'))
bounds=[o.matrix_world@v.co for o in head.objects for v in o.data.vertices]
minimum=[min(v[i]for v in bounds)for i in range(3)];maximum=[max(v[i]for v in bounds)for i in range(3)]
assert not any(any(x in o.name.lower()for x in ['hoodie','sleeve','shoe','trouser','pocket','hand','cuff','collar'])for o in head.objects)
report={'characterMeshes':len(head.objects),'bodyMeshes':0,'headCenter':[0,0,0],'boundsMin':minimum,'boundsMax':maximum,'sourceHeadVertexMaxError':max_error,'renderEngine':'Blender Cycles, 72 samples','nativeRobloxRig':'Not replaced or modified','RobloxIntegration':'Not installed'}
(out/'validation.json').write_text(json.dumps(report,indent=2));print('HEAD ONLY VERIFIED',report)
