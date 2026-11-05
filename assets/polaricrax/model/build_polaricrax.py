"""PolariCrax: unchanged actual CraxSourire geometry plus authored rounded helmet, no body."""
import bpy,bmesh,math,json,hashlib,sys
from pathlib import Path
from mathutils import Vector
from mathutils.geometry import tessellate_polygon
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(ROOT/'assets/luckycrax/model/LuckyCrax.blend'))
for col in list(bpy.data.collections):
 if col.name not in ['LuckyCrax_CANONICAL','Studio']:bpy.data.collections.remove(col)
for o in list(bpy.data.objects):
 if not o.users_collection:bpy.data.objects.remove(o,do_unlink=True)
base=bpy.data.collections['LuckyCrax_CANONICAL'];base.name='CraxSourire_ORIGINAL';base.hide_render=False
new=bpy.data.collections.new('PolariHelmet');bpy.context.scene.collection.children.link(new);fx=bpy.data.collections.new('PolariTransientFX');bpy.context.scene.collection.children.link(fx)
def mat(n,c,rough=.25,metal=0):
 m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True;p=m.node_tree.nodes['Principled BSDF'];p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=rough;p.inputs['Metallic'].default_value=metal;return m
red=mat('Helmet_GlossRed',(.68,.005,.025),.18);burgundy=mat('Helmet_CentralBurgundy',(.19,.008,.035),.23);purple=mat('Helmet_AngularPurple',(.27,.025,.46),.23);white=mat('WhiteVinyl',(.92,.92,.89),.32);ivory=mat('IvorySmile',(.94,.88,.72),.29);pink=mat('PinkGums',(.72,.29,.33),.36);black=mat('ClosedEyesBlack',(.005,.006,.008),.33);gold=mat('TransientClockGold',(.88,.54,.09),.23,.75);metal=mat('ShardMetal',(.35,.39,.49),.24,.8)
for o in base.objects:
 n=o.name.lower();m=ivory if n.startswith('tooth')else(pink if 'gums'in n else(black if n.startswith(('eye','inner','cross'))else white));o.data.materials.clear();o.data.materials.append(m)
def mesh(n,vertices,faces,material,col):
 d=bpy.data.meshes.new(n);d.from_pydata(vertices,[],faces);d.update();o=bpy.data.objects.new(n,d);col.objects.link(o);d.materials.append(material)
 for p in d.polygons:
  p.use_smooth=True
  if col==new and n.startswith('P_Helmet')and p.normal.dot(p.center)<0:p.flip()
 d.update();return o
def solid(o,thick=.12,bevel=.045):
 bpy.context.view_layer.objects.active=o;a=o.modifiers.new('VinylThickness','SOLIDIFY');a.thickness=thick;bpy.ops.object.modifier_apply(modifier=a.name);a=o.modifiers.new('SoftManufacturedEdges','BEVEL');a.width=bevel;a.segments=3;bpy.ops.object.modifier_apply(modifier=a.name);return o
# Full closed upper/back helmet. Front opening descends at cheeks, leaves native eyes/smile visible.
vs=[];fs=[];N=128;K=40
for j in range(K+1):
 for i in range(N):
  az=math.tau*i/N;front=max(0,-math.sin(az));u=max(0,min(1,(front-.12)/.23));u=u*u*(3-2*u);frontEdge=1.80+.65*min(1,abs(math.cos(az))*4.16/1.1);edge=-2.65+(frontEdge+2.65)*u
  polar=math.acos(edge/4.16)*j/K;r=4.16
  vs.append((r*math.sin(polar)*math.cos(az),r*math.sin(polar)*math.sin(az),r*math.cos(polar)))
for j in range(K):
 for i in range(N):a=j*N+i;b=j*N+(i+1)%N;fs.append((a,b,b+N,a+N))
solid(mesh('P_HelmetRedClosed',vs,fs,red,new),.14,.035)
# Raised conformal stripe from crown down the front, no clock in resting silhouette.
vs=[];fs=[];rows=52;cols=12
for j in range(rows+1):
 t=-.70+j/rows*1.76;z=4.205*math.cos(t);y=-4.205*math.sin(t)
 for i in range(cols+1):x=(i/cols-.5)*1.40;factor=math.sqrt(max(.01,1-(x/4.205)**2));vs.append((x,y*factor,z*factor))
for j in range(rows):
 for i in range(cols):a=j*(cols+1)+i;fs.append((a,a+1,a+cols+2,a+cols+1))
solid(mesh('P_HelmetBurgundyStripe',vs,fs,burgundy,new),.08,.02)
# Conformal front brow with angular M silhouette and rounded manufactured edges.
def front_patch(name,points):
 poly=[Vector((x,z,0))for x,z in points];tri=tessellate_polygon([poly]);vertices=[];faces=[];indices={}
 def vertex(p):
  x,z=p.x,p.y;co=(x,-math.sqrt(max(.15,4.27**2-x*x-z*z)),z);key=tuple(round(t,6)for t in co)
  if key not in indices:indices[key]=len(vertices);vertices.append(co)
  return indices[key]
 for t in tri:
  a,b,c=[poly[v]if isinstance(v,int)else v for v in t];N=9
  for i in range(N):
   for j in range(N-i):
    A=a+(b-a)*i/N+(c-a)*j/N;B=a+(b-a)*(i+1)/N+(c-a)*j/N;D=a+(b-a)*i/N+(c-a)*(j+1)/N;faces.append(tuple(map(vertex,[A,B,D])))
    if i+j<N-1:
     E=a+(b-a)*(i+1)/N+(c-a)*(j+1)/N;faces.append(tuple(map(vertex,[B,E,D])))
 # Explicit watertight shell avoids Solidify/Bevel intersections at the concave M corners.
 o=mesh(name+'_temp',vertices,faces,purple,new);o.data.update()
 for face in o.data.polygons:
  if face.normal.dot(face.center)<0:face.flip()
 faces=[list(f.vertices)for f in o.data.polygons];bpy.data.objects.remove(o,do_unlink=True)
 count=len(vertices);edges={}
 for f in faces:
  for a,b in zip(f,f[1:]+f[:1]):
   key=tuple(sorted((a,b)));edges.setdefault(key,[]).append((a,b))
 vertices+=list(tuple(Vector(v)*(4.13/4.27))for v in list(vertices))
 front=list(faces);faces+=list([i+count for i in reversed(f)]for f in front)
 for e in edges.values():
  if len(e)==1:
   a,b=e[0];faces.append((b,a,a+count,b+count))
 return mesh(name,vertices,faces,purple,new)
front_patch('P_PurpleBrow',[(-4.05,1.1),(-3.45,2.15),(-2.45,2.75),(-2.45,3.25),(-1.4,2.9),(0,2.04),(1.4,2.9),(2.45,3.25),(2.45,2.75),(3.45,2.15),(4.05,1.1),(3.43,1.15),(2.6,2.05),(1.7,2.32),(0,1.56),(-1.7,2.32),(-2.6,2.05),(-3.43,1.15)])
for sign in [-1,1]:
 # Side pieces stay outside mouth silhouette (native teeth are x=-2.7..2.7).
 pts=[(sign*x,z)for x,z in [(3.62,1.38),(4.05,.7),(3.95,-.8),(3.1,-2.7),(2.55,-3.2),(2.5,-2.95),(3.45,-1.65),(3.50,-.85),(3.55,.05)]]
 front_patch('P_Cheek_'+str(sign),pts)
# Transient resources: five instances are created at runtime; none attached to resting skin.
shard=mesh('PFX_Shard',[(-.22,0,-.65),(.22,0,-.65),(.14,0,.55),(0,0,1.2),(-.14,0,.55),(-.22,.13,-.65),(.22,.13,-.65),(.14,.13,.55),(0,.13,1.2),(-.14,.13,.55)],[(0,1,2,3,4),(9,8,7,6,5),(0,5,6,1),(1,6,7,2),(2,7,8,3),(3,8,9,4),(4,9,5,0)],metal,fx);solid(shard,.015,.025)
# Dial ring, face and hands are separate meshes for an actual stopped hand, not a default skin ornament.
def torus(n,major,minor):
 bpy.ops.mesh.primitive_torus_add(major_radius=major,minor_radius=minor,major_segments=64,minor_segments=10);o=bpy.context.object;o.name=n
 for c in list(o.users_collection):c.objects.unlink(o)
 fx.objects.link(o);o.data.materials.append(gold);return o
ring=torus('PFX_DialRing',.72,.065)
vs=[];fs=[]
for i in range(12):
 a=i*math.tau/12;p=Vector((math.cos(a)*.58,math.sin(a)*.58,0));u=Vector((math.cos(a),math.sin(a),0))*.06;v=Vector((-math.sin(a),math.cos(a),0))*.025;k=len(vs);vs.extend([p-u-v,p+u-v,p+u+v,p-u+v]);fs.append((k,k+1,k+2,k+3))
solid(mesh('PFX_DialTicks',vs,fs,gold,fx),.025,.008)
solid(mesh('PFX_DialHand',[(0,-.035,.015),(.51,-.035,.015),(.62,0,.015),(.51,.035,.015),(0,.035,.015)],[(0,1,2,3,4)],gold,fx),.025,.01)
# Separate trophy pedestal: never included in the combat dial or resting helmet.
bpy.ops.mesh.primitive_cube_add(size=1,location=(0,.90,0));o=bpy.context.object;o.name='PFX_TrophyBase';o.scale=(1.5,.2,.5);bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
for col in list(o.users_collection):col.objects.unlink(o)
fx.objects.link(o);o.data.materials.append(gold);bpy.context.view_layer.objects.active=o;mod=o.modifiers.new('TrophyBevel','BEVEL');mod.width=.07;mod.segments=3;bpy.ops.object.modifier_apply(modifier=mod.name)
for n,loc in [('P_FitOrigin',(0,0,0)),('P_FitUp',(0,0,4)),('P_FitFront',(0,-4,0))]:
 bpy.ops.mesh.primitive_cube_add(size=.03,location=loc);o=bpy.context.object;o.name=n
 for c in list(o.users_collection):c.objects.unlink(o)
 new.objects.link(o)
# Standalone transient markers use one-unit fit, independent of native radius.
for n,loc in [('PFX_Origin',(0,0,0)),('PFX_Up',(0,0,1)),('PFX_Front',(0,-1,0))]:
 bpy.ops.mesh.primitive_cube_add(size=.03,location=loc);o=bpy.context.object;o.name=n
 for c in list(o.users_collection):c.objects.unlink(o)
 fx.objects.link(o)
# Weld shared boundaries and orient the closed shells consistently before the final edge polish.
for o in new.objects:
 if o.name.startswith('P_Fit'):continue
 bm=bmesh.new();bm.from_mesh(o.data);bmesh.ops.remove_doubles(bm,verts=list(bm.verts),dist=1e-5);bmesh.ops.dissolve_degenerate(bm,edges=list(bm.edges),dist=1e-6);bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(o.data);bm.free();o.data.update()
 if o.name.startswith(('P_Purple','P_Cheek')):
  bpy.context.view_layer.objects.active=o;mod=o.modifiers.new('SoftRim','BEVEL');mod.width=.035;mod.segments=3;mod.limit_method='ANGLE';mod.angle_limit=.65;bpy.ops.object.modifier_apply(modifier=mod.name)
bpy.ops.object.select_all(action='DESELECT')
for o in list(new.objects)+list(fx.objects):o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT/'PolariCrax_ACCESSOIRES_IMPORT.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
for o in fx.objects:o.select_set(False)
for o in base.objects:o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT/'PolariCrax_TeteSeule.fbx'),use_selection=True,object_types={'MESH'},axis_forward='-Z',axis_up='Y',bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(OUT/'PolariCrax_TeteSeule.obj'),export_selected_objects=True,forward_axis='NEGATIVE_Z',up_axis='Y')
fx.hide_render=True
for o in new.objects:
 if o.name.startswith('P_Fit'):o.hide_render=True
s=bpy.context.scene;s.render.engine='CYCLES';s.cycles.samples=32 if '--quick'in sys.argv else 96;s.cycles.use_denoising=False;s.render.resolution_x=900;s.render.resolution_y=900;s.render.resolution_percentage=100;s.render.image_settings.file_format='PNG'
bpy.ops.object.camera_add();cam=bpy.context.object;s.camera=cam;cam.data.type='ORTHO';cam.data.ortho_scale=10.2;cam.location=(0,-25,1);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler()
for name,pos in ([]if '--assets-only'in sys.argv else [('face',(0,-25,1))]if '--quick'in sys.argv else [('face',(0,-25,1)),('trois-quarts',(11,-24,5)),('profil',(25,-1,3)),('dos',(0,25,3))]):
 cam.location=pos;cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();s.render.filepath=str(OUT/(name+'.png'));bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'PolariCrax.blend'))
(OUT/'manifest.json').write_text(json.dumps({'headOnly':True,'originalGroups':len(base.objects),'accessories':[o.name for o in new.objects if not o.name.startswith('P_Fit')],'markers':['P_FitOrigin','P_FitUp','P_FitFront'],'fx':[o.name for o in fx.objects],'sourceSHA256':hashlib.sha256((ROOT/'assets/supercrax/model/source/CraxSourire_original.obj').read_bytes()).hexdigest()},indent=2))
