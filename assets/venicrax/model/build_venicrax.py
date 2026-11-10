"""VeniCrax : vraie géométrie CraxSourire inchangée + collerette de cobra, crocs verts et écailles en relief.

Usage : python3 assets/venicrax/model/build_venicrax.py [--quick]
Sorties : VeniCrax.blend, VeniCrax_TeteSeule.fbx/.obj, VeniCrax_ACCESSOIRES_IMPORT.fbx, rendus PNG, manifest.json.
"""
import bpy, bmesh, math, json, hashlib, sys
from pathlib import Path
from mathutils import Vector, Matrix

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
QUICK = '--quick' in sys.argv

bpy.ops.wm.open_mainfile(filepath=str(ROOT / 'assets/luckycrax/model/LuckyCrax.blend'))
for col in list(bpy.data.collections):
    if col.name not in ['LuckyCrax_CANONICAL', 'Studio']:
        bpy.data.collections.remove(col)
for o in list(bpy.data.objects):
    if not o.users_collection:
        bpy.data.objects.remove(o, do_unlink=True)
base = bpy.data.collections['LuckyCrax_CANONICAL']
base.name = 'CraxSourire_ORIGINAL'
base.hide_render = False
acc = bpy.data.collections.new('VeniAccessories')
bpy.context.scene.collection.children.link(acc)


def mat(n, c, rough=.25, metal=0., coat=0.):
    m = bpy.data.materials.new(n)
    m.diffuse_color = (*c, 1)
    m.use_nodes = True
    p = m.node_tree.nodes['Principled BSDF']
    p.inputs['Base Color'].default_value = (*c, 1)
    p.inputs['Roughness'].default_value = rough
    p.inputs['Metallic'].default_value = metal
    if coat:
        p.inputs['Coat Weight'].default_value = coat
    return m


white = mat('WhiteVinyl', (.92, .92, .89), .32)
ivory = mat('IvorySmile', (.94, .88, .72), .29)
pink = mat('PinkGums', (.72, .29, .33), .36)
black = mat('ClosedEyesBlack', (.005, .006, .008), .33)
emerald = mat('Hood_Emerald', (.002, .13, .05), .2, coat=.7)
emerald_in = mat('Hood_EmeraldInner', (.004, .24, .09), .26, coat=.4)
ribs_mat = mat('Hood_RibsLight', (.08, .55, .22), .3, coat=.3)
scale_mat = mat('Scales_Emerald', (.003, .20, .075), .18, coat=.7)
venom = mat('Fangs_VenomGreen', (.20, .85, .06), .15, coat=.8)

for o in base.objects:
    n = o.name.lower()
    m = ivory if n.startswith('tooth') else (pink if 'gums' in n else (black if n.startswith(('eye', 'inner', 'cross')) else white))
    o.data.materials.clear()
    o.data.materials.append(m)


def mesh(n, vs, fs, material):
    d = bpy.data.meshes.new(n)
    d.from_pydata(vs, [], fs)
    d.update()
    o = bpy.data.objects.new(n, d)
    acc.objects.link(o)
    d.materials.append(material)
    for p in d.polygons:
        p.use_smooth = True
    return o


def modifier(o, kind, **kw):
    bpy.context.view_layer.objects.active = o
    m = o.modifiers.new(kind, kind)
    for k, v in kw.items():
        setattr(m, k, v)
    bpy.ops.object.modifier_apply(modifier=m.name)


# ---------------------------------------------------------------- collerette de cobra
# Coque qui épouse l'arrière de la tête (r=4.28) puis s'évase en collerette : large sur les côtés,
# plus courte au-dessus, nulle en bas (le cou). Légère courbure vers l'avant comme un capuchon de cobra.
R = 4.28
NA, NS = 112, 30


def flare(a):
    # Capuchon plus haut que large : sommet 2,6, côtés 1,9, bas resserré vers le cou (0,7).
    # Capuchon nettement plus haut que large : sommet 3,4, côtés 2,0, bas resserré vers le cou.
    s = math.sin(a)
    if s >= 0:
        return 2.0 + 1.4 * s ** 3
    return 2.0 - 1.6 * (-s) ** 1.3


def hood_point(a, s):
    # a : angle autour de l'axe Y (0 = +X, pi/2 = haut). s : 0 = pôle arrière, 1 = bord de la collerette.
    if s <= .62:
        phi = s / .62 * math.pi / 2
        rho, y = R * math.sin(phi), R * math.cos(phi)
    else:
        t = (s - .62) / .38
        e = flare(a)
        rho = R + t * e
        # Les ailes latérales s'enroulent vers l'avant, le sommet beaucoup moins.
        y = -t * t * (.6 + 1.5 * abs(math.cos(a))) * min(1, e / 1.2)
    return Vector((rho * math.cos(a), y, rho * math.sin(a)))


vs, fs = [], []
for j in range(NS + 1):
    for i in range(NA):
        vs.append(hood_point(math.tau * i / NA, j / NS))
for j in range(NS):
    for i in range(NA):
        a, b = j * NA + i, j * NA + (i + 1) % NA
        fs.append((a, b, b + NA, a + NA))
hood = mesh('V_CobraHood', vs, fs, emerald)
bm = bmesh.new(); bm.from_mesh(hood.data)
bmesh.ops.remove_doubles(bm, verts=list(bm.verts), dist=1e-5)
bm.to_mesh(hood.data); bm.free()
for p in hood.data.polygons:
    if p.normal.dot(p.center) < 0:
        p.flip()
hood.data.update()
modifier(hood, 'SOLIDIFY', thickness=.16, offset=1)
modifier(hood, 'BEVEL', width=.05, segments=3, limit_method='ANGLE', angle_limit=.7)
# Face avant de la collerette (visible autour de la tête) en émeraude plus clair.
hood.data.materials.append(emerald_in)
for p in hood.data.polygons:
    rho = math.hypot(p.center.x, p.center.z)
    if p.normal.y < -.35 and rho > R + .2:
        p.material_index = 1

# Nervures rayonnantes en relief (l'ossature du capuchon), plus claires, sur la face avant.
bm = bmesh.new()
for a in [math.radians(d) for d in (-28, -2, 24, 52, 90, 128, 156, 182, 208)]:
    M = 10
    ring_idx = []
    for j in range(17):
        t = j / 16
        sv = .655 + .30 * t
        c = hood_point(a, sv)
        tan = (hood_point(a, sv + .002) - hood_point(a, sv - .002)).normalized()
        across = (hood_point(a + .002, sv) - hood_point(a - .002, sv)).normalized()
        front = tan.cross(across).normalized()
        if front.y > 0:
            front = -front
        c = c + front * .2
        side = tan.cross(front).normalized()
        r = .13 * (1 - .65 * t) + .03
        ring = [bm.verts.new(c + (side * math.cos(k * math.tau / M) * 1.3 + front * math.sin(k * math.tau / M) * .55) * r) for k in range(M)]
        if ring_idx:
            for k in range(M):
                bm.faces.new((ring_idx[k], ring_idx[(k + 1) % M], ring[(k + 1) % M], ring[k]))
        ring_idx = ring
    bm.faces.new(list(reversed(ring_idx)))
bmesh.ops.recalc_face_normals(bm, faces=list(bm.faces))
rd = bpy.data.meshes.new('V_HoodRibs'); bm.to_mesh(rd); bm.free()
ro = bpy.data.objects.new('V_HoodRibs', rd); acc.objects.link(ro); rd.materials.append(ribs_mat)
for p in rd.polygons:
    p.use_smooth = True

# ---------------------------------------------------------------- crocs verts aux coins du sourire
def fang(sign):
    vs, fs = [], []
    N, M = 26, 18
    def centre(t):
        return Vector((sign * (3.02 - .22 * t), -2.80 - .42 * math.sin(math.pi * t * .85) + .22 * t * t, .10 - 2.05 * t))
    for j in range(N + 1):
        t = j / N
        c = centre(t)
        tan = (centre(min(1, t + .01)) - centre(max(0, t - .01))).normalized()
        u = tan.cross(Vector((1, 0, 0))).normalized()
        v = tan.cross(u).normalized()
        r = .31 * (1 - t) ** .85 + .012
        for i in range(M):
            a = math.tau * i / M
            vs.append(c + (u * math.cos(a) + v * math.sin(a)) * r)
    for j in range(N):
        for i in range(M):
            a, b = j * M + i, j * M + (i + 1) % M
            fs.append((a, a + M, b + M, b))
    tip = len(vs); vs.append(centre(1.0) + (centre(1) - centre(.98)).normalized() * .03)
    for i in range(M):
        fs.append((N * M + i, tip, N * M + (i + 1) % M))
    top = len(vs); vs.append(centre(0))
    for i in range(M):
        fs.append(((i + 1) % M, top, i))
    o = mesh('V_Fang_' + ('R' if sign > 0 else 'L'), vs, fs, venom)
    bm = bmesh.new(); bm.from_mesh(o.data); bmesh.ops.recalc_face_normals(bm, faces=list(bm.faces)); bm.to_mesh(o.data); bm.free()
    return o


fang(-1); fang(1)

# ---------------------------------------------------------------- écailles en relief sur le crâne
# Écailles ovales imbriquées, posées sur la sphère r=4 entre le front (au-dessus des yeux) et la collerette.
bm = bmesh.new()
rows = 9
for row in range(rows):
    theta = math.radians(4 + row * 6.0)          # angle depuis le sommet
    ring = 2 * math.pi * 4 * math.sin(theta) if theta > 0 else 0
    count = max(1, round(ring / .62))
    for k in range(count):
        az = math.tau * (k + .5 * (row % 2)) / count  # azimut autour de Z, 0 = +X
        d = Vector((math.sin(theta) * math.cos(az), math.sin(theta) * math.sin(az), math.cos(theta)))
        if d.y > .08:            # l'arrière est sous la collerette
            continue
        size = .36 + .08 * row / rows
        ret = bmesh.ops.create_uvsphere(bm, u_segments=10, v_segments=5, radius=1)
        verts = ret['verts']
        normal = d
        north = Vector((0, 0, 1)) - normal * normal.z
        north = north.normalized() if north.length > 1e-4 else Vector((0, -1, 0))
        east = north.cross(normal)
        rot = Matrix((east, north, normal)).transposed().to_4x4()
        # Tuile plate, bord libre relevé vers l'arrière (imbrication).
        m = Matrix.Translation(normal * 3.985) @ rot @ Matrix.Rotation(-.18, 4, 'X') @ Matrix.Diagonal((size * .78, size, .055, 1))
        bmesh.ops.transform(bm, matrix=m, verts=verts)
# Bandeau d'écailles qui descend sur le front, entre les yeux.
for row in range(4):
    theta = math.radians(58 + row * 6)
    for k in range(-1 - (row < 2), 2 + (row < 2)):
        az = -math.pi / 2 + k * .16 + (.08 if row % 2 else 0)
        d = Vector((math.sin(theta) * math.cos(az), math.sin(theta) * math.sin(az), math.cos(theta)))
        if abs(d.x * 4) > 1.0 - row * .15 or d.z * 4 < 2.25:
            continue
        ret = bmesh.ops.create_uvsphere(bm, u_segments=10, v_segments=5, radius=1)
        north = (Vector((0, 0, 1)) - d * d.z).normalized()
        rot = Matrix((north.cross(d), north, d)).transposed().to_4x4()
        size = .27 - row * .02
        bmesh.ops.transform(bm, matrix=Matrix.Translation(d * 3.99) @ rot @ Matrix.Rotation(-.18, 4, 'X') @ Matrix.Diagonal((size * .78, size, .05, 1)), verts=ret['verts'])
sd = bpy.data.meshes.new('V_SkullScales'); bm.to_mesh(sd); bm.free()
so = bpy.data.objects.new('V_SkullScales', sd); acc.objects.link(so); sd.materials.append(scale_mat)
for p in sd.polygons:
    p.use_smooth = True

# Repères d'alignement (comme PolariCrax) pour caler les accessoires sur la tête dans Studio.
for n, loc in [('V_FitOrigin', (0, 0, 0)), ('V_FitUp', (0, 0, 4)), ('V_FitFront', (0, -4, 0))]:
    bpy.ops.mesh.primitive_cube_add(size=.03, location=loc)
    o = bpy.context.object; o.name = n
    for c in list(o.users_collection):
        c.objects.unlink(o)
    acc.objects.link(o); o.hide_render = True

# ---------------------------------------------------------------- exports
bpy.ops.object.select_all(action='DESELECT')
for o in acc.objects:
    o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_ACCESSOIRES_IMPORT.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False)
for o in base.objects:
    o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_TeteSeule.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(OUT / 'VeniCrax_TeteSeule.obj'), export_selected_objects=True, forward_axis='NEGATIVE_Z', up_axis='Y')

# ---------------------------------------------------------------- rendus
s = bpy.context.scene
s.render.engine = 'CYCLES'; s.cycles.samples = 24 if QUICK else 96; s.cycles.use_denoising = False
s.render.resolution_x = s.render.resolution_y = 900; s.render.resolution_percentage = 100
s.render.image_settings.file_format = 'PNG'
bpy.ops.object.camera_add(); cam = bpy.context.object; s.camera = cam
cam.data.type = 'ORTHO'; cam.data.ortho_scale = 17
views = [('face', (0, -25, 1.6)), ('trois-quarts', (13, -22, 6)), ('profil', (25, -1, 3.5)), ('dos', (0, 25, 3.5))]
for name, pos in views:
    cam.location = pos
    cam.rotation_euler = (-cam.location).to_track_quat('-Z', 'Y').to_euler()
    s.render.filepath = str(OUT / (name + '.png'))
    bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT / 'VeniCrax.blend'))
(OUT / 'VeniCrax.blend1').unlink(missing_ok=True)
(OUT / 'manifest.json').write_text(json.dumps({
    'headOnly': True,
    'originalGroups': len(base.objects),
    'accessories': [o.name for o in acc.objects if not o.name.startswith('V_Fit')],
    'markers': ['V_FitOrigin', 'V_FitUp', 'V_FitFront'],
    'triangles': {o.name: sum(len(p.vertices) - 2 for p in o.data.polygons) for o in acc.objects if not o.name.startswith('V_Fit')},
    'sourceSHA256': hashlib.sha256((ROOT / 'assets/supercrax/model/source/CraxSourire_original.obj').read_bytes()).hexdigest(),
}, indent=2, ensure_ascii=False) + '\n')
print('VENICRAX OK', [o.name for o in acc.objects])
