"""Real SuperCrax mesh renders, no Roblox IDs. blender -b --threads 4 --python this.py"""
import bpy,math
from pathlib import Path
from mathutils import Vector
out=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(out.parent/'model/SuperCrax.blend'))
scene=bpy.context.scene;cam=scene.camera
scene.render.resolution_x=512;scene.render.resolution_y=512;scene.cycles.samples=32;scene.cycles.use_denoising=False
cam.location=(11,-24,5);target=Vector((0,0,0));cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.ortho_scale=11.7
col=bpy.data.collections.new('IllustrationVFX');scene.collection.children.link(col)
def material(name,rgb,emission=0):
 m=bpy.data.materials.new(name);m.diffuse_color=(*rgb,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*rgb,1);p.inputs['Metallic'].default_value=.2;p.inputs['Roughness'].default_value=.28;p.inputs['Emission Color'].default_value=(*rgb,1);p.inputs['Emission Strength'].default_value=emission;return m
red=material('LaserRed',(1,.008,.02),3);white=material('LaserCore',(1,.25,.15),5);ice=material('IceCyan',(.12,.7,.95),.3);green=material('KryptoniteGreen',(.08,.85,.12),.5)
def move(o):
 for c in list(o.users_collection):c.objects.unlink(o)
 col.objects.link(o)
 return o
def line(a,b,r,m):
 d=Vector(b)-Vector(a);bpy.ops.mesh.primitive_cylinder_add(vertices=12,radius=r,depth=d.length,location=(Vector(a)+Vector(b))/2);o=move(bpy.context.object);o.rotation_euler=d.to_track_quat('Z','Y').to_euler();o.data.materials.append(m);return o
def crystal(pos,scale,m):
 bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=1,radius=1,location=pos);o=move(bpy.context.object);o.scale=scale;o.data.materials.append(m);return o
def clear():
 for o in list(col.objects):bpy.data.objects.remove(o,do_unlink=True)
def eyes():
 for n in ['Eyeleft1','Eyeright1']:
  o=bpy.data.objects[n];p=o.matrix_world@sum((v.co for v in o.data.vertices),Vector())/len(o.data.vertices);a=p+Vector((0,-.18,0));b=a+Vector((.3,-5.5,-.15));line(a,b,.11,red);line(a,b,.045,white)
def render(name):scene.render.filepath=str(out/(name+'.png'));bpy.ops.render.render(write_still=True)
eyes();render('SuperLaserIcon');clear()
for i in range(9):
 a=i*math.tau/9;crystal((4.4*math.cos(a),-1.8,3.8*math.sin(a)),(.28,.25,.65),ice)
for j in range(3):
 pts=[Vector((.5*math.sin(i*.5+j),-3.3-i*.25,-.8+j*.55))for i in range(14)]
 for a,b in zip(pts,pts[1:]):line(a,b,.055,ice)
render('SuperFrostIcon');clear()
for i in range(3):crystal((3+i*.3,-2.5,-2+i*.7),(.6,.6,1.2),green)
render('SuperInvincibleIcon');clear()
eyes()
for i in range(8):
 a=i*math.tau/8;crystal((4*math.cos(a),-1.5,4*math.sin(a)),(.3,.25,.8),ice)
render('SuperMaxIcon')
scene['Presentation']='Illustrations from actual SuperCrax meshes; representative VFX, not Studio screenshots'
bpy.ops.wm.save_as_mainfile(filepath=str(out/'SuperCrax_Illustrations.blend'))
