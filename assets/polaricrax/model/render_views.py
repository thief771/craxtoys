import bpy
from pathlib import Path
from mathutils import Vector
OUT=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(OUT/'PolariCrax.blend'));s=bpy.context.scene;cam=s.camera;s.cycles.samples=96;s.render.resolution_x=800;s.render.resolution_y=800;s.render.resolution_percentage=100;s.render.film_transparent=False;cam.data.ortho_scale=10.2
for name,pos in [('face',(0,-25,1)),('trois-quarts',(11,-24,5)),('profil',(25,-1,3)),('dos',(0,25,3))]:
 cam.location=pos;cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();s.render.filepath=str(OUT/(name+'.png'));bpy.ops.render.render(write_still=True)
print('POLARI final views rendered from validated mesh')
