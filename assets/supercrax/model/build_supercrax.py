"""Build SuperCrax from the creator's actual head OBJ. No body or substitute sphere.
blender -b --threads 4 --python build_supercrax.py -- BASE.obj OUTPUT_DIRECTORY
"""
import bpy,sys,math,json,hashlib
from pathlib import Path
from mathutils import Vector
from mathutils.geometry import tessellate_polygon
src=Path(sys.argv[sys.argv.index('--')+1]);out=Path(sys.argv[sys.argv.index('--')+2]);out.mkdir(exist_ok=True,parents=True)
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
root=bpy.context.scene.collection
def collection(name):c=bpy.data.collections.new(name);root.children.link(c);return c
ref=collection('CraxSourire_ORIGINAL_GEOMETRY');char=collection('SuperCrax_HEAD_ONLY');new=collection('SuperCrax_IMPORTED_ACCESSORIES');studio=collection('Studio');markers=collection('FittingMarkers');markers.hide_render=True

def mat(name,rgb,rough=.36):
 m=bpy.data.materials.new(name);m.diffuse_color=(*rgb,1);m.use_nodes=True;p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*rgb,1);p.inputs['Roughness'].default_value=rough;p.inputs['Specular IOR Level'].default_value=.3;return m
ivory=mat('Face_Vinyl_Ivory',(.88,.89,.84),.34);teeth=mat('Teeth_White',(.94,.94,.88),.32);gum=mat('Smile_WarmPink',(.68,.22,.19),.42)
black=mat('Eyes_Black',(.008,.012,.016),.33);hair=mat('Hair_BlackBlue',(.006,.019,.030),.3);lockmat=mat('Hair_SculptedLocks',(.010,.027,.041),.32);groove=mat('Hair_DeepGrooves',(.003,.010,.016),.43)
blue=mat('Classic_Blue',(.016,.24,.49),.36);red=mat('Superman_Red',(.78,.025,.025),.34);yellow=mat('Superman_Yellow',(.98,.68,.025),.36)

def mesh(name,vertices,faces,col,material):
 d=bpy.data.meshes.new(name);d.from_pydata(vertices,[],faces);d.update();o=bpy.data.objects.new(name,d);col.objects.link(o)
 if material:d.materials.append(material)
 for p in d.polygons:p.use_smooth=True
 return o
v=[];groups={};group=None
for line in src.read_text().splitlines():
 p=line.split()
 if not p:continue
 if p[0]=='v':v.append(tuple(map(float,p[1:4])))
 elif p[0]=='g':group=p[1];groups.setdefault(group,[])
 elif p[0]=='f':groups[group].append([int(t.split('/')[0])-1 for t in p[1:]])
source_stats=[]
for name,faces in groups.items():
 ids=sorted({i for f in faces for i in f});lookup={i:j for j,i in enumerate(ids)}
 coords=[(v[i][0]+15,v[i][2]+4.474234104156494,v[i][1]-25)for i in ids];polys=[[lookup[i]for i in f]for f in faces]
 n=name.lower();m=teeth if n.startswith('tooth')else(gum if 'gums'in n else(black if n.startswith(('eye','inner'))else ivory))
 mesh(name+'_REFERENCE',coords,polys,ref,m)
 if not n.startswith('cross'):mesh(name,coords,polys,char,m)
 source_stats.append({'name':name,'vertices':len(coords),'faces':len(faces)})
ref.hide_render=True;ref.hide_viewport=True
# Conformal upper scalp: a swept-back hairline, shorter at front and descending at nape.
verts=[];faces=[];segments=96;rings=28
for j in range(rings+1):
 for i in range(segments):
  a=2*math.pi*i/segments
  front=(-math.sin(a)+1)/2
  hairline=.46+2.43*front**1.65+.16*math.sin(a*2)+.10*front*math.sin(a*4)
  polar=math.acos(hairline/4.075)*j/rings
  edge=math.sin(min(1,(1-j/rings)/.18)*math.pi/2)
  radius=4.018+edge*(.055+.075*math.sin(polar)**2)
  x=radius*math.sin(polar)*math.cos(a);y=radius*math.sin(polar)*math.sin(a)
  z=radius*math.cos(polar)+.25*math.exp(-((x+.55)**2+(y+.8)**2)/3.8)*math.sin(polar)
  sculpt=.065*math.cos((x-.20*math.sin(y*.65))*8.2)*edge*math.sin(polar)**.7
  normal=Vector((x,y,z)).normalized();x+=normal.x*sculpt;y+=normal.y*sculpt;z+=normal.z*sculpt
  verts.append((x,y,z))
for j in range(rings):
 for i in range(segments):
  a=j*segments+i;b=j*segments+(i+1)%segments;faces.append((a,b,b+segments,a+segments))
cap=mesh('SuperHairCap',verts,faces,new,hair)

def ribbon(name,points,width,material,depth=.12):
 curve=bpy.data.curves.new(name,'CURVE');curve.dimensions='3D';curve.resolution_u=12;curve.bevel_depth=width;curve.bevel_resolution=4;curve.use_fill_caps=True
 sp=curve.splines.new('BEZIER');sp.bezier_points.add(len(points)-1)
 for index,(b,p) in enumerate(zip(sp.bezier_points,points)):
  b.co=p;b.handle_left_type='AUTO';b.handle_right_type='AUTO'
  if name.startswith('SuperCurl')and index==0:b.radius=.10
  if name.startswith(('SuperHairLock','SuperTemple')):b.radius=.035 if index in (0,len(points)-1)else math.sin(math.pi*index/(len(points)-1))**.4
 o=bpy.data.objects.new(name,curve);new.objects.link(o);curve.materials.append(material)
 bpy.ops.object.select_all(action='DESELECT');o.select_set(True);bpy.context.view_layer.objects.active=o;bpy.ops.object.convert(target='MESH');o.select_set(False)
 for poly in o.data.polygons:poly.use_smooth=True
 return o
# Broad combed locks follow the actual spherical crown; distinct ridges, not spikes.
for k in range(6):
 x=-2.45+k*.91;centers=[];steps=45
 for j in range(steps):
  u=j/(steps-1);y=-2.1+4.9*u;xx=x-.45*math.sin(math.pi*u)+.12*u
  z=math.sqrt(max(.2,4.08**2-xx*xx-y*y))+.12*math.exp(-((xx+.55)**2+(y+.8)**2)/3.8)
  centers.append(Vector((xx,y,z)))
 vv=[];ff=[];sides=12
 for j,p in enumerate(centers):
  tangent=(centers[min(j+1,steps-1)]-centers[max(0,j-1)]).normalized();normal=p.normalized();side=tangent.cross(normal).normalized()
  taper=max(.03,math.sin(math.pi*j/(steps-1))**.55)
  for i in range(sides):
   a=2*math.pi*i/sides;v=p+side*(math.cos(a)*.29*taper)+normal*(math.sin(a)*.085*taper-.025)
   vv.append(tuple(v))
 for j in range(steps-1):
  for i in range(sides):
   n=(i+1)%sides;ff.append((j*sides+i,j*sides+n,(j+1)*sides+n,(j+1)*sides+i))
 ff.append(tuple(reversed(range(sides))));ff.append(tuple((steps-1)*sides+i for i in range(sides)))
 mesh('SuperHairLock_%02d'%k,vv,ff,new,lockmat)
# Side swept contour emphasizes the temples and flows into the nape.
for side in (-1,1):
 pts=[(side*3.15,-1.6,2.15),(side*3.6,-.3,1.8),(side*3.55,1.35,1.50),(side*2.9,2.7,1.02)]
 ribbon('SuperTemple_'+str(side),pts,.16,hair)
# Signature forehead curl: continuous, thick S/loop, clear of the native eye arches.
ribbon('SuperCurl',[(.65,-2.50,3.08),(.10,-3.02,2.94),(-.58,-3.23,2.74),(-.90,-3.43,2.48),(-.68,-3.52,2.29),(-.36,-3.52,2.36),(-.42,-3.40,2.57)],.185,hair)
ribbon('SuperCurl_Ridge',[(.56,-2.88,3.20),(-.05,-3.14,3.00),(-.66,-3.37,2.74)],.035,lockmat)
# Blue costume color is confined to a curved CHIN skin patch, never a torso.
verts=[];faces=[];ns=96;nr=12
for j in range(nr+1):
 z=-2.64-(1.37*j/nr)
 for i in range(ns):
  a=2*math.pi*i/ns;radius=math.sqrt(max(.001,4.018**2-z*z))
  verts.append((radius*math.cos(a),radius*math.sin(a)-.015,z))
for j in range(nr):
 for i in range(ns):
  a=j*ns+i;b=j*ns+(i+1)%ns;faces.append((a,b,b+ns,a+ns))
mesh('SuperChinBlue',verts,faces,new,blue)
# Red/yellow Superman shield, conformal to the lower front of the real head.
# Own authored geometry; no externally claimed asset ID or generated-image substitute.
def badge_point(x,z,offset):
 z=-3.14+z*.43;x=x*.79
 return (x,-math.sqrt(max(.01,4.018**2-x*x-z*z))-offset,z)
def polygon(name,points,material,offset):
 vertices=[];faces=[];lookup={}
 def add(x,z):
  key=(round(x,7),round(z,7))
  if key not in lookup:lookup[key]=len(vertices);vertices.append(badge_point(x,z,offset))
  return lookup[key]
 outline=[Vector((x,0,z))for x,z in points]
 for triangle in tessellate_polygon([outline]):
  a,b,c=triangle if hasattr(triangle[0],'x')else[outline[index]for index in triangle];grid={};n=8
  for i in range(n+1):
   for j in range(n+1-i):
    p=a+(b-a)*(i/n)+(c-a)*(j/n);grid[i,j]=add(p.x,p.z)
  for i in range(n):
   for j in range(n-i):
    faces.append((grid[i,j],grid[i+1,j],grid[i,j+1]))
    if j<n-i-1:faces.append((grid[i+1,j],grid[i+1,j+1],grid[i,j+1]))
 for i,f in enumerate(faces):
  a,b,c=[Vector(vertices[k])for k in f]
  if (b-a).cross(c-a).dot(Vector((0,-1,0)))<0:faces[i]=(f[0],f[2],f[1])
 o=mesh(name,vertices,faces,new,material)
 solid=o.modifiers.new('ThinVinylRelief','SOLIDIFY');solid.thickness=.015
 bevel=o.modifiers.new('RoundedReliefEdges','BEVEL');bevel.width=.012;bevel.segments=2
 bpy.context.view_layer.objects.active=o;bpy.ops.object.select_all(action='DESELECT');o.select_set(True)
 for m in list(o.modifiers):bpy.ops.object.modifier_apply(modifier=m.name)
 o.select_set(False);return o
shield=[(-1,.55),(-.62,1),(.62,1),(1,.55),(0,-1)]
polygon('SuperEmblem_RedShield',shield,red,.035)
polygon('SuperEmblem_YellowField',[(x*.79,z*.79)for x,z in shield],yellow,.060)
# Broad angular S with characteristic upper/lower cutouts, fitting inside the shield.
s_points=[(-.54,.50),(-.34,.70),(.40,.70),(.57,.45),(.26,.45),(.17,.54),(-.21,.54),(-.30,.39),(.34,.22),(.47,.03),(.25,-.38),(0,-.65),(-.26,-.38),(-.42,-.15),(-.12,-.15),(0,-.31),(.15,-.13),(.21,.02),(-.36,.18),(-.51,.30)]
polygon('SuperEmblem_S',s_points,red,.083)
# Fit markers are for import alignment; they are NOT part of the playable appearance.
for name,loc in [('FIT_HeadCenter',(0,0,0)),('FIT_Front',(0,-4,0)),('FIT_Up',(0,0,4))]:
 bpy.ops.mesh.primitive_cube_add(size=.15,location=loc);o=bpy.context.object;o.name=name
 for c in list(o.users_collection):c.objects.unlink(o)
 markers.objects.link(o)
# Export new imported meshes independently of the native head rig.
bpy.ops.object.select_all(action='DESELECT')
for o in list(new.objects)+list(markers.objects):o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(out/'SuperCrax_ACCESSOIRES_IMPORT.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',add_leaf_bones=False,bake_anim=False)
bpy.ops.object.select_all(action='DESELECT')
for o in list(char.objects)+list(new.objects):o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(out/'SuperCrax_TeteSeule.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',add_leaf_bones=False,bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(out/'SuperCrax_TeteSeule.obj'),export_selected_objects=True,forward_axis='NEGATIVE_Z',up_axis='Y',export_materials=True)
# Simple photographic staging. All views show the meshes exported above.
world=bpy.data.worlds.new('SuperStudio');bpy.context.scene.world=world;world.use_nodes=True;world.node_tree.nodes['Background'].inputs[0].default_value=(.12,.15,.20,1);world.node_tree.nodes['Background'].inputs[1].default_value=.45
floor=mesh('DisplayFloor',[(-100,-100,-4.1),(100,-100,-4.1),(100,100,-4.1),(-100,100,-4.1)],[(0,1,2,3)],studio,mat('Floor',(.06,.075,.10),.8))
for name,loc,energy,size in [('Key',(-8,-10,13),1900,8),('Fill',(7,-7,5),1400,7),('Rim',(2,6,12),2200,7)]:
 bpy.ops.object.light_add(type='AREA',location=loc);o=bpy.context.object;o.name=name;o.data.energy=energy;o.data.size=size;o.rotation_euler=(-o.location).to_track_quat('-Z','Y').to_euler()
 for c in list(o.users_collection):c.objects.unlink(o)
 studio.objects.link(o)
bpy.ops.object.camera_add();cam=bpy.context.object;scene=bpy.context.scene;scene.camera=cam;cam.data.type='ORTHO';cam.data.ortho_scale=9.7
scene.render.engine='CYCLES';scene.cycles.samples=64;scene.cycles.use_denoising=False
scene.render.resolution_x=900;scene.render.resolution_y=900;scene.render.resolution_percentage=100;scene.render.image_settings.file_format='PNG';scene.view_settings.view_transform='AgX'
for name,loc in [('face',(0,-24,1)),('profil',(24,0,1)),('dos',(0,24,1)),('trois-quarts',(15,-23,4))]:
 cam.location=loc;cam.rotation_euler=(Vector((0,0,.1))-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(out/(name+'.png'));bpy.ops.render.render(write_still=True)
# Real small-size preview, not a resized illustration.
scene.render.resolution_x=128;scene.render.resolution_y=128;cam.location=(0,-24,1);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(out/'apercu-128.png');bpy.ops.render.render(write_still=True)
scene.render.resolution_x=900;scene.render.resolution_y=900
# Geometry comparison: source in neutral reference materials, without Super accessories.
for o in new.objects:o.hide_render=True
cam.location=(0,-24,1);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(out/'base-geometrie.png');bpy.ops.render.render(write_still=True)
for o in new.objects:o.hide_render=False
# Side-by-side real source geometry versus the modeled character.
ref.hide_render=False
for o in ref.objects:o.location.x=-5.2
for o in list(char.objects)+list(new.objects):o.location.x=5.2
cam.location=(0,-28,1);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.ortho_scale=20.4
scene.render.resolution_x=1800;scene.render.resolution_y=900;scene.render.filepath=str(out/'comparaison-base-super.png');bpy.ops.render.render(write_still=True)
for o in ref.objects:o.location.x=0
for o in list(char.objects)+list(new.objects):o.location.x=0
ref.hide_render=True;cam.data.ortho_scale=9.7;scene.render.resolution_x=900
cam.location=(15,-23,4);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler()
scene['OriginalOBJ_SHA256']=hashlib.sha256(src.read_bytes()).hexdigest();scene['HeadOnly']=True;scene['Status']='Model assets; requires Studio mesh import'
bpy.ops.wm.save_as_mainfile(filepath=str(out/'SuperCrax.blend'))
max_error=0
for o in char.objects:
 source=bpy.data.objects[o.name+'_REFERENCE'];assert len(o.data.vertices)==len(source.data.vertices)
 for a,b in zip(o.data.vertices,source.data.vertices):max_error=max(max_error,(a.co-b.co).length)
assert max_error==0
report={'headOnly':True,'nativeHeadPieces':len(char.objects),'newMeshParts':len(new.objects),'sourceHeadVertexMaxError':max_error,'sourceOBJ_SHA256':hashlib.sha256(src.read_bytes()).hexdigest(),'accessoryTriangles':sum(len(p.vertices)-2 for o in new.objects for p in o.data.polygons),'physicalHeadDiameter':8,'sourceParts':source_stats,'photo':'User-supplied chat reference, blue/red character; no local image file provided'}
(out/'validation-model.json').write_text(json.dumps(report,indent=2));print('SUPERCRAX MODEL EXPORTED',report['newMeshParts'])
