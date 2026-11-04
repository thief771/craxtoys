"""Real CraxSourire head and authored Lucky FX. Blender4.3, no body or fabricated asset ID."""
import bpy,math,json,hashlib
from pathlib import Path
from mathutils import Vector
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(ROOT/'assets/supercrax/model/SuperCrax.blend'))
for col in list(bpy.data.collections):
 if col.name not in ['CraxSourire_ORIGINAL_GEOMETRY','Studio']:bpy.data.collections.remove(col)
for o in list(bpy.data.objects):
 if not o.users_collection:bpy.data.objects.remove(o,do_unlink=True)
base=bpy.data.collections['CraxSourire_ORIGINAL_GEOMETRY'];base.name='LuckyCrax_CANONICAL';base.hide_viewport=False;base.hide_render=False
scene=bpy.context.scene
# Prior camera was outside removed collections: create one explicitly.
bpy.ops.object.camera_add();cam=bpy.context.object;scene.camera=cam;cam.data.type='ORTHO';cam.data.ortho_scale=10
fx=bpy.data.collections.new('LuckyCrax_FX_LIBRARY');scene.collection.children.link(fx)
def mat(n,c,metal=0,rough=.3):
 m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*c,1);p.inputs['Metallic'].default_value=metal;p.inputs['Roughness'].default_value=rough;return m
gold=mat('LuckyGold',(.87,.49,.055),.8,.28);dark=mat('GoldEngraving',(.13,.065,.006),.7,.35);ivory=mat('LuckyIvory',(.94,.91,.79));red=mat('CasinoRed',(.35,.015,.025),.25);pink=mat('LuckyGums',(.67,.25,.28));black=mat('LuckyBlack',(.009,.012,.018));green=mat('LuckyHeart',(.12,.62,.21),.3);purple=mat('LuckyJoker',(.35,.055,.63),.5)
for o in base.objects:
 o.name=o.name.replace('_REFERENCE','');n=o.name.lower();m=gold if n.startswith('tooth')else(pink if 'gums'in n else(black if n.startswith(('eye','inner','cross'))else ivory));o.data.materials.clear();o.data.materials.append(m)
def move(o,n,m):
 o.name=n
 for c in list(o.users_collection):c.objects.unlink(o)
 fx.objects.link(o);o.data.materials.append(m);return o
def bevel(o,amount=.05):
 mod=o.modifiers.new('RoundedEdges','BEVEL');mod.width=amount;mod.segments=3;bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_apply(modifier=mod.name)
 for f in o.data.polygons:f.use_smooth=True
 return o
def cube(n,loc,size,m,r=.05):
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc);o=move(bpy.context.object,n,m);o.scale=size;bpy.ops.object.transform_apply(location=False,rotation=False,scale=True);return bevel(o,r)
def curve(n,points,r,m):
 d=bpy.data.curves.new(n,'CURVE');d.dimensions='3D';d.bevel_depth=r;d.bevel_resolution=3;s=d.splines.new('POLY');s.points.add(len(points)-1)
 for p,co in zip(s.points,points):p.co=(*co,1)
 o=bpy.data.objects.new(n,d);fx.objects.link(o);o.data.materials.append(m);bpy.context.view_layer.objects.active=o;o.select_set(True);bpy.ops.object.convert(target='MESH');o.select_set(False);return bpy.context.view_layer.objects.active
def text(n,string,loc,size,m,rot=(0,0,0)):
 d=bpy.data.curves.new(n,'FONT');d.body=string;d.align_x='CENTER';d.align_y='CENTER';d.size=size;d.extrude=.009;d.bevel_depth=.004;d.bevel_resolution=2;o=bpy.data.objects.new(n,d);fx.objects.link(o);o.location=loc;o.rotation_euler=rot;o.data.materials.append(m);bpy.context.view_layer.objects.active=o;o.select_set(True);bpy.ops.object.convert(target='MESH');o.select_set(False);return bpy.context.view_layer.objects.active
def heart(n,loc,scale,m):
 pts=[]
 for i in range(65):
  a=math.tau*i/64;x=16*math.sin(a)**3;y=13*math.cos(a)-5*math.cos(2*a)-2*math.cos(3*a)-math.cos(4*a);pts.append((loc[0]+x*scale/17,loc[1]+y*scale/17,loc[2]))
 d=bpy.data.meshes.new(n);vs=pts[:-1];d.from_pydata(vs,[],[list(range(len(vs)))]);d.update();o=bpy.data.objects.new(n,d);fx.objects.link(o);o.data.materials.append(m);mod=o.modifiers.new('LeafThickness','SOLIDIFY');mod.thickness=.11;bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_apply(modifier=mod.name);o.location=loc
 for v in o.data.vertices:v.co-=Vector(loc)
 return bevel(o,.025)
# Thick bevelled coin, real ridged edge and two different raised/engraved faces.
bpy.ops.mesh.primitive_cylinder_add(vertices=80,radius=.8,depth=.18);coin=bevel(move(bpy.context.object,'LFX_CoinBody',gold),.035)
for i in range(40):
 a=math.tau*i/40;cube('CoinRidge_%02d'%i,(.784*math.cos(a),.784*math.sin(a),0),(.035,.035,.12),dark,.006)
curve('CoinSmile',[(.5*math.cos(a),.04+.35*math.sin(a),.096)for a in [math.pi+math.pi*j/32 for j in range(33)]],.027,dark)
for x in [-.27,.27]:curve('CoinEye',[(x+.12*math.cos(a),.24+.08*math.sin(a),.10)for a in [math.pi*j/12 for j in range(13)]],.02,dark)
for i in range(7):curve('CoinTooth_%d'%i,[(i*.105-.315,-.13,.101),(i*.105-.315,-.25,.101)],.012,dark)
for i in range(4):
 a=i*math.pi*.5;h=heart('CoinClover_%d'%i,(math.cos(a)*.24,math.sin(a)*.24,-.101),.26,dark);h.rotation_euler[2]=a-math.pi*.5
# Coin library is consolidated by material to bound runtime instance count.
for material,name in [(gold,'LFX_CoinBody'),(dark,'LFX_CoinDetail')]:
 bpy.ops.object.select_all(action='DESELECT');items=[o for o in fx.objects if o.type=='MESH'and o.data.materials and o.data.materials[0]==material]
 for o in items:o.select_set(True)
 bpy.context.view_layer.objects.active=items[0];bpy.ops.object.join();bpy.context.object.name=name
# Rounded die, 1/6 2/5 3/4 on opposing faces. Exact visible value from server orientation.
cube('LFX_Die', (0,0,0),(1.05,1.05,1.05),ivory,.12)
faces=[('1',(0,0,.535),(0,0,0)),('6',(0,0,-.535),(math.pi,0,0)),('2',(.535,0,0),(0,math.pi/2,0)),('5',(-.535,0,0),(0,-math.pi/2,0)),('3',(0,-.535,0),(math.pi/2,0,0)),('4',(0,.535,0),(-math.pi/2,0,0))]
for digit,pos,rot in faces:text('LFX_Digit_'+digit,digit,pos,.68,red,rot)
# Four sculpted heart leaves, curved vein and short stalk.
for i in range(4):
 a=i*math.pi/2;h=heart('LFX_CloverLeaf_'+str(i),(math.cos(a)*.42,math.sin(a)*.42,0),.56,gold);h.rotation_euler[2]=a-math.pi*.5
 curve('LFX_LeafVein_'+str(i),[(math.cos(a)*t,math.sin(a)*t,.10+.04*math.sin(t*4))for t in [.08,.2,.35,.5,.65]],.018,dark)
curve('LFX_CloverStem',[(0,0,0),(.08,-.6,-.04),(.3,-1,-.03)],.055,gold)
cube('LFX_ReelCase',(0,0,0),(3.6,.6,1.7),gold,.17);cube('LFX_ReelInset',(0,-.33,-.03),(3.22,.08,1.23),red,.07)
heart('LFX_Heart',(0,0,0),.55,green);text('LFX_Joker','J',(0,0,0),1,purple)
# Hollow jackpot chest: open top, four rounded walls, separate animated lid.
cube('LFX_ChestFloor',(0,0,-.85),(3.6,2.2,.22),gold,.08)
for n,loc,size in [('Front',(0,-1,-.2),(3.6,.22,1.3)),('Back',(0,1,-.2),(3.6,.22,1.3)),('Left',(-1.7,0,-.2),(.22,2.2,1.3)),('Right',(1.7,0,-.2),(.22,2.2,1.3))]:cube('LFX_Chest'+n,loc,size,gold,.08)
cube('LFX_Lid',(0,0,.62),(3.7,2.3,.25),gold,.12)
cube('LFX_ChestLock',(0,-1.14,.1),(.4,.12,.55),red,.06)
for n,loc in [('LFX_Origin',(0,0,0)),('LFX_Up',(0,0,1)),('LFX_Front',(0,-1,0))]:
 cube(n,loc,(.04,.04,.04),black,.002)
# Library export; objects intentionally share origin and are grouped at runtime by name.
bpy.ops.object.select_all(action='DESELECT')
for o in fx.objects:o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT/'LuckyCrax_FX_IMPORT.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
fx.hide_render=True
bpy.ops.object.select_all(action='DESELECT')
for o in base.objects:o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT/'LuckyCrax_TeteSeule.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(OUT/'LuckyCrax_TeteSeule.obj'),export_selected_objects=True,forward_axis='NEGATIVE_Z',up_axis='Y')
scene.render.engine='CYCLES';scene.cycles.samples=48;scene.cycles.use_denoising=False;scene.render.resolution_x=800;scene.render.resolution_y=800;scene.render.resolution_percentage=100;scene.render.image_settings.file_format='PNG'
for name,pos in ([]if '--assets-only'in __import__('sys').argv else [('face',(0,-24,1)),('trois-quarts',(12,-24,5)),('profil',(24,-1,2)),('dos',(0,24,2))]):
 cam.location=pos;cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(OUT/(name+'.png'));bpy.ops.render.render(write_still=True)
cam.location=(0,-24,1);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.resolution_x=128;scene.render.resolution_y=128;scene.render.filepath=str(OUT/'apercu-128.png');bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'LuckyCrax.blend'))
(OUT/'manifest.json').write_text(json.dumps({'headOnly':True,'nativeGroups':len(base.objects),'fx':[o.name for o in fx.objects if o.type=='MESH'],'reference':'docs/luckycrax/references/LuckyCrax_reference.jpeg','sourceSHA256':hashlib.sha256((ROOT/'assets/supercrax/model/source/CraxSourire_original.obj').read_bytes()).hexdigest()},indent=2))
