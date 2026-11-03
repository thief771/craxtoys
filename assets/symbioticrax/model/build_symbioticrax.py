"""True CraxSourire mesh + sculpted asymmetric symbiote, no body.
blender -b --threads 4 --python assets/symbioticrax/model/build_symbioticrax.py
"""
import bpy,math,json,hashlib
from pathlib import Path
from mathutils import Vector
from mathutils.geometry import tessellate_polygon
ROOT=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
src=ROOT/'assets/supercrax/model/source/CraxSourire_original.obj'
bpy.ops.wm.read_factory_settings(use_empty=True)
def collection(n):c=bpy.data.collections.new(n);bpy.context.scene.collection.children.link(c);return c
base=collection('CraxSourire_Native');extra=collection('SymbiotiCrax_ACCESSORIES');ref=collection('Original_Source');markers=collection('FIT_MARKERS');markers.hide_render=True
ref.hide_render=True;ref.hide_viewport=True
def mat(n,c,r=.29):
 m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=r;p.inputs['Specular IOR Level'].default_value=.35;return m
black=mat('LivingBlack',(.005,.007,.010),.19);ridge=mat('SymbioteRidges',(.012,.017,.023),.23);white=mat('VinylWhite',(.89,.90,.85),.37);pink=mat('Gums',(.65,.18,.23),.4);red=mat('Tongue',(.66,.075,.15),.28)
# Fine organic relief is a shading detail; larger ribs below survive FBX import.
for material,scale,strength in [(black,18,.18),(ridge,24,.12),(red,48,.22)]:
 nodes=material.node_tree.nodes;links=material.node_tree.links;p=nodes['Principled BSDF']
 noise=nodes.new('ShaderNodeTexNoise');noise.inputs['Scale'].default_value=scale;noise.inputs['Detail'].default_value=3
 bump=nodes.new('ShaderNodeBump');bump.inputs['Strength'].default_value=strength;bump.inputs['Distance'].default_value=.035
 links.new(noise.outputs['Fac'],bump.inputs['Height']);links.new(bump.outputs['Normal'],p.inputs['Normal'])
 p.inputs['Coat Weight'].default_value=.28;p.inputs['Coat Roughness'].default_value=.18
def mesh(n,vs,fs,col,m):
 d=bpy.data.meshes.new(n);d.from_pydata(vs,[],fs);d.update();o=bpy.data.objects.new(n,d);col.objects.link(o);o.data.materials.append(m)
 for f in d.polygons:f.use_smooth=True
 return o
v=[];g={};cur=''
for l in src.read_text().splitlines():
 p=l.split()
 if not p:continue
 if p[0]=='v':v.append(tuple(map(float,p[1:4])))
 elif p[0]=='g':cur=p[1];g[cur]=[]
 elif p[0]=='f':g[cur].append([int(t.split('/')[0])-1 for t in p[1:]])
hidden=[];native=[];fangs=[]
for n,faces in g.items():
 ids=sorted({i for f in faces for i in f});idx={k:j for j,k in enumerate(ids)};coords=[(v[i][0]+15,v[i][2]+4.474234104156494,v[i][1]-25)for i in ids];polys=[[idx[k]for k in f]for f in faces]
 low=n.lower();m=white if low.startswith('tooth')else(pink if 'gums'in low else black)
 mesh(n+'_SOURCE',coords,polys,ref,m)
 o=mesh(n,coords,polys,base,m);native.append(n)
 if low.startswith('eye'):o.hide_render=True
 if low.startswith('tooth'):
  center=sum((Vector(p)for p in coords),Vector())/len(coords)
  if center.x>.3:
   # Retain actual Crax tooth root, narrow towards a longer fang tip in mouth.
   top=center.z>-.85;zs=[p[2]for p in coords];lo,hi=min(zs),max(zs);new=[]
   for x,y,z in coords:
    u=(hi-z)/(hi-lo)if top else(z-lo)/(hi-lo);f=1-.98*u**.7
    new.append((center.x+(x-center.x)*f,center.y+(y-center.y)*(1-.35*u),(hi+(-1.18-hi)*u)if top else(lo+(-1.34-lo)*u)))
   # Two narrower interlocking fangs per native root on the transformed half.
   # Keep the original object name and native root mapping used by the installer.
   width=max(p[0]for p in coords)-min(p[0]for p in coords);split=[];split_faces=[]
   for side in [-1,1]:
    offset=len(split)
    for x,y,z in new:split.append((center.x+(x-center.x)*.48+side*width*.24,y,z+side*.065))
    split_faces.extend([tuple(offset+k for k in face)for face in polys])
   nn='SymFang_'+n;mesh(nn,split,split_faces,extra,white);o.hide_render=True;hidden.append(n);fangs.append(nn)
def smooth(points,steps=8):
 p=[Vector(x)for x in points];q=[]
 for i in range(len(p)-1):
  a,b,c,d=p[max(0,i-1)],p[i],p[i+1],p[min(len(p)-1,i+2)]
  for j in range(steps):
   t=j/steps;q.append(.5*((2*b)+(-a+c)*t+(2*a-5*b+4*c-d)*t*t+(-a+3*b-3*c+d)*t*t*t))
 q.append(p[-1]);return q
def tube(n,points,radius,m,taper=.9,flat=1):
 ps=smooth(points,12);vs=[];fs=[];sides=18;previous=None
 for i,p in enumerate(ps):
  u=i/(len(ps)-1);t=(ps[min(i+1,len(ps)-1)]-ps[max(0,i-1)]).normalized();axis=Vector((0,0,1))if abs(t.z)<.92 else Vector((1,0,0));a=(previous-t*previous.dot(t)).normalized()if previous is not None else t.cross(axis).normalized();previous=a;b=t.cross(a).normalized();r=radius*(1-taper*u**1.3)
  for j in range(sides):
   angle=j*math.tau/sides
   # Geometry relief remains visible in Studio without uploaded texture IDs.
   relief=1+(.026*math.sin(u*math.tau*38+angle*2)if 'Tongue'in n else .035*math.sin(angle*5+u*12))
   vs.append(p+r*relief*(a*math.cos(angle)+b*math.sin(angle)*flat))
 for i in range(len(ps)-1):
  for j in range(sides):a=i*sides+j;b=i*sides+(j+1)%sides;fs.append((a,b,b+sides,a+sides))
 vs.extend([ps[0],ps[-1]]);end=len(vs)-1
 for j in range(sides):fs.append((end-1,(j+1)%sides,j));a=(len(ps)-1)*sides;fs.append((end,a+j,a+(j+1)%sides))
 return mesh(n,vs,fs,extra,m)
def front(x,z,offset=.045):return(x,-math.sqrt(max(.03,16-x*x-z*z))-offset,z)
def patch(n,points,m,offset=.065):
 # Subdivide face triangles then project every vertex onto actual round skull surface.
 raw=[Vector((x,z,0))for x,z in points];poly=[]
 for i in range(len(raw)):
  a,b,c,d=raw[(i-1)%len(raw)],raw[i],raw[(i+1)%len(raw)],raw[(i+2)%len(raw)]
  for j in range(5):
   t=j/5;poly.append(.5*(2*b+(-a+c)*t+(2*a-5*b+4*c-d)*t*t+(-a+3*b-3*c+d)*t*t*t))
 tri=tessellate_polygon([poly]);vs=[];fs=[]
 for tr in tri:
  coords=[poly[k]if isinstance(k,int)else k for k in tr];a,b,c=coords;steps=8;idx={}
  for i in range(steps+1):
   for j in range(steps+1-i):
    p=a+(b-a)*i/steps+(c-a)*j/steps;idx[i,j]=len(vs);vs.append(front(p.x,p.y,offset))
  for i in range(steps):
   for j in range(steps-i):
    fs.append((idx[i,j],idx[i+1,j],idx[i,j+1]))
    if j<steps-i-1:fs.append((idx[i+1,j],idx[i+1,j+1],idx[i,j+1]))
 o=mesh(n,vs,fs,extra,m)
 import bmesh
 bm=bmesh.new();bm.from_mesh(o.data);bmesh.ops.remove_doubles(bm,verts=list(bm.verts),dist=.0001);bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(o.data);bm.free()
 mod=o.modifiers.new('OrganicThickness','SOLIDIFY');mod.thickness=.028;bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_apply(modifier=mod.name)
 return o
# Sculpted conformal envelope with asymmetric relief, open around the real mouth.
vs=[];fs=[];around=100;bands=52
for j in range(bands+1):
 polar=math.pi*j/bands
 for k in range(around):
  a=math.tau*k/around;frontward=max(0,-math.sin(a));relief=(.018+.018*math.sin(a*7+polar*3)*math.sin(polar*9+a*2))*frontward+(.04+.085*math.sin(a*9+polar*11)**6)*(1-frontward)
  r=4.012+relief;vs.append((r*math.sin(polar)*math.cos(a),r*math.sin(polar)*math.sin(a),r*math.cos(polar)))
for j in range(bands):
 for k in range(around):
  ids=(j*around+k,j*around+(k+1)%around,(j+1)*around+(k+1)%around,(j+1)*around+k);mid=sum((Vector(vs[t])for t in ids),Vector())/4
  if not(mid.y<-.9 and (mid.x/3.68)**2+((mid.z+1.18)/1.52)**2<1+.03*math.sin(mid.x*4)):fs.append(ids)
coat=mesh('SymLivingCoat',vs,fs,extra,black)
import bmesh
bm=bmesh.new();bm.from_mesh(coat.data);bmesh.ops.remove_doubles(bm,verts=list(bm.verts),dist=.00001)
edgeverts={v for e in bm.edges if len(e.link_faces)==1 for v in e.verts}
for vtx in edgeverts:
 x,y,z=vtx.co
 if y<0 and -3.5<z<1:
  r=math.sqrt((x/3.68)**2+((z+1.18)/1.52)**2)
  if r>.001:
   x=x/r;z=-1.18+(z+1.18)/r;vtx.co=(x,-math.sqrt(max(.1,4.03**2-x*x-z*z)),z)
bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(coat.data);bm.free()

patch('SymWhite_Forehead',[(-.55,2.94),(-.15,3.03),(.14,2.78),(.22,2.20),(.03,1.75),(-.14,1.22),(-.35,1.45),(-.58,2.02),(-.65,2.57)],white)
patch('SymWhite_Left',[(-2.48,2.18),(-2.12,2.46),(-1.89,2.15),(-1.96,1.66),(-2.07,1.13),(-2.30,.66),(-2.48,.80)],white)
patch('SymWhite_BrokenCenter',[(-1.43,1.23),(-.94,1.27),(-.71,.95),(-.76,.50),(-1.04,.36),(-1.2,.67),(-1.48,.8)],white)
patch('SymWhite_BrowSpot',[(.65,2.99),(.98,2.86),(.96,2.54),(.78,2.60)],white)
patch('SymEye_Right',[(1.08,.10),(1.42,.04),(1.94,.28),(2.43,.78),(2.82,1.52),(2.88,2.43),(2.61,1.99),(2.17,1.54),(1.60,.94)],white,.095)
patch('SymEye_Left',[(-3.21,.45),(-3.08,1.18),(-2.78,1.66),(-2.71,1.10),(-2.72,.65),(-2.90,.15)],white,.09)
# Creeping organic lips and tendrils conform to the cranial surface, not a second sphere.
paths=[[(.38,3.58),(.55,3.02),(.30,2.55),(.35,1.91),(.16,1.17),(.57,.54)], [(-2.1,2.75),(-1.55,2.42),(-1.58,1.83),(-1.3,1.37),(-.79,1.18),(-.55,.54)],[(3.18,1.62),(3.11,.85),(2.81,.25),(2.42,-.12),(1.72,-.24)], [(-3.63,.92),(-3.40,.25),(-3.08,-.37),(-2.68,-.63)], [(-1.88,.20),(-1.54,-.12),(-1.60,-.68),(-1.94,-1.24)]]
for i,ps in enumerate(paths):tube('SymMaskRidge_%02d'%i,[front(x,z,.10)for x,z in ps],.13 if i!=1 else .19,ridge,.65)
# Different top loops, varied tapered side/back extensions. Root anchors stay on skull.
tentacles=[ [(-2,0,3.44),(-2.7,-.6,4.45),(-1.9,-.7,4.85),(-1.5,-1,4.1)], [(-.8,.2,3.9),(-1.4,0,5.35),(-.7,-.5,5.6),(-.12,-1.2,4.5)],[(.5,.1,3.96),(1.3,-.3,5.1),(.6,-1.2,5.45),(-.2,-1.8,4.1)],[(1.8,.5,3.45),(1.5,.2,4.9),(2.4,-.1,4.5),(2.8,-1.1,3.2)],[(0,1.8,3.55),(.6,2.5,4.6),(1.6,2.5,4.9),(1.4,2.4,4.3)],[(3.5,1,1.8),(4.7,1.7,1.1),(6.3,2.1,.95),(6.8,2.1,1.6),(6.2,1.8,1.7)],[(3.6,1.9,.2),(4.6,2.5,-.4),(6.6,2.6,-.1),(7.3,2.1,.45)],[(3.4,1.9,-.7),(4.5,2.6,-1.1),(5.3,2.8,-2.1),(4.4,2.3,-2)], [(-3.5,1.7,.5),(-4.5,2.2,1.1),(-4.1,2.4,1.8),(-3.7,2.1,1.6)]]
roots={}
for i,ps in enumerate(tentacles):
 o=tube('SymTentacle_%02d'%i,ps,[.31,.36,.30,.25,.21,.23,.16,.20,.22][i],black,.94)
 # Object origin at actual root: client can animate without floating at attachment.
 root=Vector(ps[0]);o.location=root
 for vert in o.data.vertices:vert.co-=root
 roots[o.name]=list(root)
tube('SymTongueRest',[(.45,-3.5,-1.05),(1.25,-4.4,-1.2),(2.9,-4.85,-.85),(4.5,-4.6,-1.25),(4.9,-4.6,-2.35),(4.10,-4.9,-3.05),(3.15,-5,-2.73)],.63,red,.95,.62)
tube('SymTongueGroove',[(1,-4.7,-1.10),(2.65,-5.21,-.81),(4,-5.0,-1.0)],.025,pink,.95)
for name,loc in list(('SYM_Root_'+k[-2:],tuple(v))for k,v in roots.items())+[('FIT_HeadCenter',(0,0,0)),('FIT_Front',(0,-4,0)),('FIT_Up',(0,0,4)),('SYM_Mouth',(.45,-3.8,-1.05))]:
 bpy.ops.mesh.primitive_cube_add(size=.12,location=loc);o=bpy.context.object;o.name=name
 for c in list(o.users_collection):c.objects.unlink(o)
 markers.objects.link(o)
bpy.ops.object.select_all(action='DESELECT')
for o in list(extra.objects)+list(markers.objects):o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(out/'SymbiotiCrax_ACCESSOIRES_IMPORT.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
bpy.ops.object.select_all(action='DESELECT')
for o in list(base.objects)+list(extra.objects):
 if not o.hide_render:o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(out/'SymbiotiCrax_TeteSeule.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(out/'SymbiotiCrax_TeteSeule.obj'),export_selected_objects=True,forward_axis='NEGATIVE_Z',up_axis='Y')
# Neutral black backdrop, controlled large reflections keep black sculpt readable.
world=bpy.data.worlds.new('Studio');world.use_nodes=True;world.node_tree.nodes['Background'].inputs[0].default_value=(.06,.075,.1,1);world.node_tree.nodes['Background'].inputs[1].default_value=.3;bpy.context.scene.world=world
for loc,energy,size in [((-9,-12,12),2300,9),((9,-9,5),1700,7),((2,7,8),2400,7)]:
 bpy.ops.object.light_add(type='AREA',location=loc);o=bpy.context.object;o.data.energy=energy;o.data.size=size;o.rotation_euler=(-o.location).to_track_quat('-Z','Y').to_euler()
bpy.ops.object.camera_add();cam=bpy.context.object;scene=bpy.context.scene;scene.camera=cam;cam.data.type='ORTHO';cam.data.ortho_scale=14.1
scene.render.engine='CYCLES';scene.cycles.samples=40;scene.cycles.use_denoising=False;scene.render.resolution_x=900;scene.render.resolution_y=900;scene.render.resolution_percentage=100;scene.render.image_settings.file_format='PNG';scene.view_settings.view_transform='AgX'
for n,loc in [('face',(1,-28,3)),('trois-quarts',(12,-25,7)),('profil-droit',(28,-1,3)),('profil-gauche',(-28,-1,3)),('dos',(0,28,5))]:
 cam.location=loc;cam.rotation_euler=(Vector((1,0,.7))-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(out/(n+'.png'));bpy.ops.render.render(write_still=True)
cam.location=(1,-28,3);cam.rotation_euler=(Vector((1,0,.7))-cam.location).to_track_quat('-Z','Y').to_euler();scene.render.resolution_x=128;scene.render.resolution_y=128;scene.render.filepath=str(out/'apercu-128.png');bpy.ops.render.render(write_still=True)
scene.render.resolution_x=900;scene.render.resolution_y=900
bpy.ops.wm.save_as_mainfile(filepath=str(out/'SymbiotiCrax.blend'))
(out/'manifest.json').write_text(json.dumps({'sourceSHA256':hashlib.sha256(src.read_bytes()).hexdigest(),'nativeHead':True,'body':False,'accessories':[o.name for o in extra.objects],'hideNative':hidden+['EyeLeft','EyeRight'],'tentacleRoots':roots,'markers':[o.name for o in markers.objects],'back':'interpreted; native cross inherited','triangles':sum(len(o.data.polygons)*2 for o in extra.objects)},indent=2))
print('SYMBIOTICRAX EXPORT COMPLETE',len(extra.objects),'accessories')
