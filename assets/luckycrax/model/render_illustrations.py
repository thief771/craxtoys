"""Transparent book art built from the actual Lucky head and exported FX meshes."""
import bpy,math
from pathlib import Path
from mathutils import Vector,Matrix
R=Path(__file__).resolve().parents[3];O=R/'assets/luckycrax/illustrations';O.mkdir(exist_ok=True)
bpy.ops.wm.open_mainfile(filepath=str(R/'assets/luckycrax/model/LuckyCrax.blend'))
s=bpy.context.scene;base=bpy.data.collections['LuckyCrax_CANONICAL'];fx=bpy.data.collections['LuckyCrax_FX_LIBRARY'];fx.hide_render=True
floor=bpy.data.objects.get('DisplayFloor')
if floor:floor.hide_render=True
s.render.engine='CYCLES';s.cycles.samples=128;s.render.film_transparent=True;s.render.resolution_x=640;s.render.resolution_y=640;s.render.resolution_percentage=100;s.render.image_settings.color_mode='RGBA';s.render.image_settings.file_format='PNG';cam=s.camera;cam.data.ortho_scale=12.4;cam.location=(0,-27,7);cam.rotation_euler=(Vector((0,0,.4))-cam.location).to_track_quat('-Z','Y').to_euler()
art=bpy.data.collections.new('LuckyBookArt');s.collection.children.link(art)
def assembly(names,loc=(0,0,0),rotation=(0,0,0),scale=1):
 t=Matrix.Translation(Vector(loc))@__import__('mathutils').Euler(rotation).to_matrix().to_4x4()@Matrix.Scale(scale,4)
 for name in names:
  src=bpy.data.objects[name];o=src.copy();o.data=src.data.copy();art.objects.link(o);o.matrix_world=t@src.matrix_world
coin=['LFX_CoinBody','LFX_CoinDetail'];die=['LFX_Die']+['LFX_Digit_'+str(i)for i in range(1,7)];clover=[o.name for o in fx.objects if o.name.startswith(('LFX_Clover','LFX_Leaf'))];reels=['LFX_ReelCase','LFX_ReelInset'];chest=[o.name for o in fx.objects if o.name.startswith('LFX_Chest')]
def clean():
 for o in list(art.objects):bpy.data.objects.remove(o,do_unlink=True)
for kind in (['Max']if '--max-only'in __import__('sys').argv else ['Dice','Clover','Jackpot','Max']):
 clean()
 cam.data.ortho_scale=14.8 if kind=='Max'else 12.4
 cam.rotation_euler=(Vector((0,0,-.9 if kind=='Max'else .4))-cam.location).to_track_quat('-Z','Y').to_euler()
 if kind=='Dice':
  assembly(die,(-3.3,-4,2.7),(.7,.3,-.3),1.8);assembly(die,(3,-4,1.8),(.5,.5,.3),1.8)
 elif kind=='Clover':assembly(clover,(2.8,-4,2),(math.pi/2,0,.3),1.4)
 elif kind=='Jackpot':
  assembly(reels,(0,-.5,4.3),scale=2.3)
  for i,n in enumerate(['LFX_Heart','LFX_CoinBody','LFX_Joker']):assembly([n],(-2.6+i*2.6,-1.4,4.3),(math.pi/2,0,0),.85)
 else:
  assembly(chest,(0,-1,-4.2),scale=1.7);assembly(['LFX_Lid'],(0,2,-3.7),(.85,0,0),1.7)
  for i in range(6):assembly(coin,((i-2.5)*1.2,-2.4,3.6+(.4 if i%2 else 0)),(.8,.3,i*.7),.65)
 s.render.filepath=str(O/('Lucky'+kind+'.png'));bpy.ops.render.render(write_still=True)
# Honest Blender preview of real library, not a purported in-game capture.
clean();base.hide_render=True;cam.data.ortho_scale=11.5;cam.location=(0,-18,15);cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler()
assembly(coin,(-3,0,2),(1.1,0,.3),1.35);assembly(die,(0,0,2),(.5,.4,.4),1.5);assembly(clover,(3,0,2),(.7,0,.2),1.3);assembly(reels,(-2.5,0,-1),scale=1.25);assembly(chest,(2.5,0,-1),scale=1.25);assembly(['LFX_Lid'],(2.5,.5,-.1),(.5,0,0),1.25)
s.render.filepath=str(O/'Bibliotheque-FX-Blender.png');bpy.ops.render.render(write_still=True)
print('LUCKY transparent book illustrations rendered from actual meshes')
