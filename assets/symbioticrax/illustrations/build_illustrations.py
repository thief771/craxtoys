"""Render real meshes, neutral pose checks and skill illustrations. No Roblox screenshots."""
import bpy,math,json
from pathlib import Path
from mathutils import Vector
out=Path(__file__).resolve().parent;model=out.parent/'model';root=out.parents[2]
bpy.ops.wm.open_mainfile(filepath=str(model/'SymbiotiCrax.blend'))
scene=bpy.context.scene;cam=scene.camera;scene.cycles.samples=32;scene.render.resolution_x=512;scene.render.resolution_y=512
cam.data.ortho_scale=13.3;cam.location=(9,-27,5);cam.rotation_euler=(Vector((1,0,.6))-cam.location).to_track_quat('-Z','Y').to_euler()
col=bpy.data.collections.new('IllustrationVFX');scene.collection.children.link(col)
def material(n,c):
 m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=.3;return m
black=material('Ink',(.009,.012,.021));gold=material('Gold',(.8,.48,.055))
def blob(pos,scale,m):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=20,ring_count=10,location=pos);o=bpy.context.object
 for c in list(o.users_collection):c.objects.unlink(o)
 col.objects.link(o);o.scale=scale;o.data.materials.append(m)
 for p in o.data.polygons:p.use_smooth=True
 return o
def render(n):scene.render.filepath=str(out/(n+'.png'));bpy.ops.render.render(write_still=True)
for pos in [(-1.4,-3.7,.8),(-.6,-4,.4),(.2,-4,.8)]:blob(pos,(.4,.2,.3),black)
render('SymMarksIcon')
for o in list(col.objects):bpy.data.objects.remove(o,do_unlink=True)
white=[o for o in bpy.data.collections['SymbiotiCrax_ACCESSORIES'].objects if 'White'in o.name]
oldm={o:o.data.materials[0]for o in white}
for o in white:o.data.materials[0]=black
render('SymArmourIcon')
for o,m in oldm.items():o.data.materials[0]=m
p=blob((4.2,-4,-2),(1.1,.9,.75),black)
for x in [3.8,4.4]:blob((x,-4.85,-1.8),(.16,.08,.22),oldm[white[0]])
render('SymParasiteIcon')
for o in list(col.objects):bpy.data.objects.remove(o,do_unlink=True)
# Gold frame around the same actual creature, unique MAX trophy art.
for i in range(18):
 a=math.tau*i/18;blob((1+5.8*math.cos(a),1,1+5.7*math.sin(a)),(.22,.16,.38),gold)
render('SymMaxIcon')
for o in list(col.objects):bpy.data.objects.remove(o,do_unlink=True)
scene.render.resolution_x=900;scene.render.resolution_y=900
lower=[o for o in list(bpy.data.collections['CraxSourire_Native'].objects)+list(bpy.data.collections['SymbiotiCrax_ACCESSORIES'].objects)if o.name.lower().startswith(('lower','innerlower','tooth1','symfang_tooth1'))]
for name,dz in [('bouche-entrouverte',-.15),('bouche-ouverte',-.32)]:
 for o in lower:o.location.z+=dz
 scene.render.filepath=str(model/(name+'.png'));bpy.ops.render.render(write_still=True)
 for o in lower:o.location.z-=dz
# Reuse the actual original head geometry from the prior verified source scene.
with bpy.data.libraries.load(str(root/'assets/supercrax/model/SuperCrax.blend'),link=False)as(a,b):b.collections=['CraxSourire_ORIGINAL_GEOMETRY']
reference=b.collections[0];scene.collection.children.link(reference);reference.hide_render=False;reference.hide_viewport=False
for o in reference.objects:o.location.x=-6
for c in ['CraxSourire_Native','SymbiotiCrax_ACCESSORIES']:
 for o in bpy.data.collections[c].objects:o.location.x+=6
cam.location=(1.6,-32,4);cam.rotation_euler=(Vector((1.6,0,.8))-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.ortho_scale=25
scene.render.resolution_x=1800;scene.render.resolution_y=900;scene.render.filepath=str(model/'comparaison-base-symbioti.png');bpy.ops.render.render(write_still=True)
print('ILLUSTRATIONS AND REAL POSE VIEWS COMPLETE')
