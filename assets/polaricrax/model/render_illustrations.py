"""Transparent skill artwork rendered from the delivered native head/helmet and transient meshes."""
import bpy,math,sys
from pathlib import Path
from mathutils import Vector,Matrix,Euler
R=Path(__file__).resolve().parents[3];OUT=R/'assets/polaricrax/illustrations';OUT.mkdir(exist_ok=True)
bpy.ops.wm.open_mainfile(filepath=str(R/'assets/polaricrax/model/PolariCrax.blend'));s=bpy.context.scene
floor=bpy.data.objects.get('DisplayFloor')
if floor:floor.hide_render=True
s.render.engine='CYCLES';s.cycles.samples=96;s.render.film_transparent=True;s.render.resolution_x=640;s.render.resolution_y=640;s.render.resolution_percentage=100;s.render.image_settings.color_mode='RGBA';s.render.image_settings.file_format='PNG';cam=s.camera;cam.data.ortho_scale=12.5;cam.location=(0,-28,4);cam.rotation_euler=(Vector((0,0,.5))-cam.location).to_track_quat('-Z','Y').to_euler()
art=bpy.data.collections.new('PolariBookArtwork');s.collection.children.link(art)
def material(name,color):
 m=bpy.data.materials.new(name);m.diffuse_color=(*color,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*color,1);p.inputs['Metallic'].default_value=.3;p.inputs['Roughness'].default_value=.27;return m
purple=material('ArtPolarityPurple',(.45,.035,.8));red=material('ArtRepelRed',(.9,.015,.05))
def part(name,pos,scale=(1,1,1),rot=(0,0,0)):
 src=bpy.data.objects[name];o=src.copy();o.data=src.data.copy();art.objects.link(o);o.matrix_world=Matrix.Translation(Vector(pos))@Euler(rot).to_matrix().to_4x4()@Matrix.Diagonal((*scale,1))@src.matrix_world;return o

def curve(name,points,m,r=.04):
 d=bpy.data.curves.new(name,'CURVE');d.dimensions='3D';d.bevel_depth=r;d.bevel_resolution=4;sp=d.splines.new('BEZIER');sp.bezier_points.add(len(points)-1)
 for b,p in zip(sp.bezier_points,points):b.co=p;b.handle_left_type='AUTO';b.handle_right_type='AUTO'
 o=bpy.data.objects.new(name,d);art.objects.link(o);o.data.materials.append(m)
for kind in (['Max']if '--max-only'in sys.argv else ['Attract','Invert','Stop','Max']):
 for o in list(art.objects):bpy.data.objects.remove(o,do_unlink=True)
 if kind in ['Attract','Invert']:
  m=purple if kind=='Attract'else red;side=-1 if kind=='Attract'else 1
  curve('PolarizedWall',[(side*4.8,-1,-3.3),(side*4.8,-1,3.3)],m,.16)
  for i in range(3):
   z=-1.7+i*1.6;curve('Convergence'+str(i),[(side*2.7,-3.5,z),(side*3.5,-3,z+.3),(side*4.8,-1,z+.6)],m,.05)
  if kind=='Invert':
   curve('RepulsionArrow',[(4.3,-4,1.3),(2.4,-4,3.4)],red,.09);curve('ArrowTipA',[(2.4,-4,3.4),(3.2,-4,3.1)],red,.09);curve('ArrowTipB',[(2.4,-4,3.4),(2.5,-4,2.6)],red,.09)
 else:
  for i in range(5):
   a=math.pi*(.16+.68*i/4);p=(math.cos(a)*4.8,-1,math.sin(a)*4.8+.4);part('PFX_Shard',p,(.7,.7,.7),(0,math.pi/2-a,0))
  if kind=='Max':
   gold=material('TrophyGoldenHead',(.82,.49,.08))
   for col in ['CraxSourire_ORIGINAL','PolariHelmet']:
    for o in bpy.data.collections[col].objects:
     if o.type=='MESH'and not o.name.lower().startswith(('eye','inner')):o.data.materials.clear();o.data.materials.append(gold)
   part('PFX_TrophyBase',(0,-4.0,3.7),(1.5,1.5,1.5),(math.pi/2,0,0))
  for n in ['PFX_DialRing','PFX_DialTicks','PFX_DialHand']:part(n,(0,-4.0,3.0 if kind=='Stop'else 3.7),(1.5,1.5,1.5),(math.pi/2,0,0))
 s.render.filepath=str(OUT/('Polari'+kind+'.png'));bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'PolariCrax_Illustrations.blend'))
print('POLARI four RGBA book illustrations rendered from true delivered geometry')
