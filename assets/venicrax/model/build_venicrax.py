"""VeniCrax V2 (d'après le visuel de référence du créateur).

Vraie géométrie CraxSourire inchangée + collerette de cobra serrée (écailles foncées, plaques ventrales crème
tachées de noir), écailles du crâne en dégradé foncé → clair, pastilles, veines de venin néon,
quatre crocs translucides avec gouttes.

Chaque couleur est un objet séparé (une MeshPart par couleur dans Roblox), chacun sous 20 000 triangles.
Usage : python3 assets/venicrax/model/build_venicrax.py [--quick]
"""
import bpy, bmesh, math, json, hashlib, sys, random
from pathlib import Path
from mathutils import Vector, Matrix

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
QUICK = '--quick' in sys.argv
rnd = random.Random(7)

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


def mat(n, c, rough=.25, metal=0., coat=0., emit=0., alpha=1., trans=0.):
    m = bpy.data.materials.new(n)
    m.diffuse_color = (*c, alpha)
    m.use_nodes = True
    p = m.node_tree.nodes['Principled BSDF']
    p.inputs['Base Color'].default_value = (*c, 1)
    p.inputs['Roughness'].default_value = rough
    p.inputs['Metallic'].default_value = metal
    if coat:
        p.inputs['Coat Weight'].default_value = coat
    if emit:
        p.inputs['Emission Color'].default_value = (*c, 1)
        p.inputs['Emission Strength'].default_value = emit
    if trans:
        p.inputs['Transmission Weight'].default_value = trans
    return m


M = dict(
    white=mat('WhiteVinyl', (.92, .92, .89), .32),
    ivory=mat('CreamTeeth', (.95, .84, .66), .27),
    gums=mat('RedGums', (.80, .10, .14), .34),
    black=mat('ClosedEyesBlack', (.005, .006, .008), .33),
    shell=mat('Hood_DarkGreen', (.004, .07, .025), .25, coat=.6),
    hscale=mat('Hood_ScalesDark', (.006, .10, .035), .2, coat=.8),
    bands=mat('Hood_BellyCream', (.80, .66, .30), .3, coat=.5),
    blotch=mat('Hood_Blotches', (.01, .012, .008), .4),
    dark=mat('Scales_Dark', (.004, .14, .04), .18, coat=.8),
    mid=mat('Scales_Mid', (.04, .40, .09), .2, coat=.7),
    light=mat('Scales_Light', (.30, .78, .32), .25, coat=.6),
    veins=mat('Venom_Neon', (.55, 1.0, .05), .3, emit=4.),
    fangs=mat('Fangs_VenomGlass', (.42, .92, .02), .1, coat=1., emit=.35, trans=.12),
)
for o in base.objects:
    n = o.name.lower()
    m = M['ivory'] if n.startswith('tooth') else (M['gums'] if 'gums' in n else (M['black'] if n.startswith(('eye', 'inner', 'cross')) else M['white']))
    o.data.materials.clear()
    o.data.materials.append(m)


def finish(name, bm, material, smooth=True):
    d = bpy.data.meshes.new(name)
    bm.to_mesh(d)
    bm.free()
    o = bpy.data.objects.new(name, d)
    acc.objects.link(o)
    d.materials.append(material)
    for p in d.polygons:
        p.use_smooth = smooth
    return o


def scale_piece(bm, centre, normal, along, size, width=.8, thick=.06, lift=-.2, seg=(8, 4)):
    """Écaille : ellipsoïde aplati posé sur la surface, pointe vers `along`, bord libre relevé."""
    n = normal.normalized()
    a = (along - n * along.dot(n)).normalized()
    e = a.cross(n)
    rot = Matrix((e, a, n)).transposed().to_4x4()
    m = Matrix.Translation(centre) @ rot @ Matrix.Rotation(lift, 4, 'X') @ Matrix.Diagonal((size * width, size, thick * size / .4, 1))
    ret = bmesh.ops.create_uvsphere(bm, u_segments=seg[0], v_segments=seg[1], radius=1)
    bmesh.ops.transform(bm, matrix=m, verts=ret['verts'])


# =================================================================== collerette
R = 4.28


def flare(a):
    s = math.sin(a)
    return 1.65 - .5 * s * s if s >= 0 else 1.65 - .2 * s * s


def curl(a):
    return 1.2 + .6 * abs(math.cos(a))


def hood_point(a, s):
    """a : angle autour de Y (0 = +X, pi/2 = haut). s : 0 = pôle arrière, .62 = bord de la tête, 1 = bord extérieur."""
    if s <= .62:
        phi = s / .62 * math.pi / 2
        rho, y = R * math.sin(phi), R * math.cos(phi)
    else:
        t = (s - .62) / .38
        rho, y = R + t * flare(a), -t * t * curl(a)
    return Vector((rho * math.cos(a), y, rho * math.sin(a)))


def hood_frame(a, s):
    p = hood_point(a, s)
    ds = (hood_point(a, min(1, s + .003)) - hood_point(a, max(0, s - .003))).normalized()
    da = (hood_point(a + .003, s) - hood_point(a - .003, s)).normalized()
    n = ds.cross(da).normalized()
    return p, ds, n


NA, NS = 112, 30
bm = bmesh.new()
grid = [[bm.verts.new(hood_point(math.tau * i / NA, j / NS)) for i in range(NA)] for j in range(NS + 1)]
for j in range(NS):
    for i in range(NA):
        bm.faces.new((grid[j][i], grid[j][(i + 1) % NA], grid[j + 1][(i + 1) % NA], grid[j + 1][i]))
bmesh.ops.remove_doubles(bm, verts=list(bm.verts), dist=1e-5)
bmesh.ops.recalc_face_normals(bm, faces=list(bm.faces))
shell = finish('V_HoodShell', bm, M['shell'])
bpy.context.view_layer.objects.active = shell
mod = shell.modifiers.new('T', 'SOLIDIFY'); mod.thickness = .12; mod.offset = 0
bpy.ops.object.modifier_apply(modifier=mod.name)


# --- plaques ventrales crème (côtés) + taches noires, posées sur la face avant de la collerette
def front_y(x, z):
    rho = math.hypot(x, z)
    a = math.atan2(z, x)
    t = (rho - R) / flare(a)
    return -t * t * curl(a), t, a


band_bm, blot_bm = bmesh.new(), bmesh.new()
PITCH, CELL = .56, .1
z = -R - 1.6
while z < R + 1.2:
    z0, z1 = z + .05, z + PITCH
    nz = 6
    xs = [x * CELL for x in range(-62, 63)]
    for xi in range(len(xs) - 1):
        for k in range(nz):
            za, zb = z0 + (z1 - z0) * k / nz, z0 + (z1 - z0) * (k + 1) / nz
            corners = [(xs[xi], za), (xs[xi + 1], za), (xs[xi + 1], zb), (xs[xi], zb)]
            ok = True; pts = []
            for (x, zz) in corners:
                y, t, a = front_y(x, zz)
                if not (.02 < t < .66) or abs(x) < 2.1:
                    ok = False; break
                u = (zz - z0) / (z1 - z0)
                bulge = .09 * math.sin(math.pi * u) + .07 * (1 - u)   # bord bas en avant : plaques imbriquées
                pts.append(Vector((x, y - .1 - bulge, zz)))
            if not ok:
                continue
            cx = sum(p.x for p in pts) / 4; cz = sum(p.z for p in pts) / 4
            _, tc, _ = front_y(cx, cz)
            spot = tc > .38 and (math.sin(cz * 4.1 + abs(cx) * 2.3) + .8 * math.sin(cz * 9.7 - abs(cx) * 5.1)) > .55
            target = blot_bm if spot else band_bm
            target.faces.new([target.verts.new(p + Vector((0, -.004 if spot else 0, 0))) for p in pts])
    z += PITCH
for name, b, m in [('V_HoodBellyBands', band_bm, M['bands']), ('V_HoodBlotches', blot_bm, M['blotch'])]:
    bmesh.ops.remove_doubles(b, verts=list(b.verts), dist=1e-5)
    o = finish(name, b, m)
    for p in o.data.polygons:
        if p.normal.y > 0:
            p.flip()
    bpy.context.view_layer.objects.active = o
    mod = o.modifiers.new('T', 'SOLIDIFY'); mod.thickness = .05
    bpy.ops.object.modifier_apply(modifier=mod.name)

# --- grosses écailles foncées : bordure avant + tout le dos de la collerette
front_bm, back_bm = bmesh.new(), bmesh.new()
# Bordure avant : rangées pointes vers l'extérieur ; au-dessus et au-dessous de la tête, toute la largeur.
for row, s in enumerate([.985, .93, .875, .82, .765, .71, .655]):
    count = 46 if row < 3 else 40
    for k in range(count):
        a = math.tau * (k + .5 * (row % 2)) / count
        if row >= 3 and abs(math.cos(a) * (R + 1)) > 2.3:
            continue
        p, ds, n = hood_frame(a, s)
        if n.y > 0:
            n = -n
        scale_piece(front_bm, p + n * .09, n, ds, .52, width=.85, thick=.07, lift=-.25)
# Dos : rangées du bord vers le pôle arrière, pointes vers le bord.
s, row = .995, 0
while s > .03:
    q = hood_point(0, s)
    rho = math.hypot(q.x, q.z)
    count = max(6, round(2 * math.pi * max(rho, .4) / .84))
    for k in range(count):
        a = math.tau * (k + .5 * (row % 2)) / count
        p, ds, n = hood_frame(a, s)
        if n.y < 0:
            n = -n
        scale_piece(back_bm, p + n * .09, n, ds, .88, width=.85, thick=.07, lift=-.22)
    s -= .075 if s > .62 else .095
    row += 1
finish('V_HoodScalesFront', front_bm, M['hscale'])
finish('V_HoodScalesBack', back_bm, M['hscale'])

# =================================================================== écailles du crâne


def theta_max(az):
    """Limite basse (degrés depuis le sommet) des écailles selon l'azimut : pointe au centre du front,
    dégagement au-dessus des yeux, longues bandes sur les côtés jusqu'aux coins de la bouche."""
    f = (math.degrees(az) + 90) % 360
    f = min(f, 360 - f)
    pts = [(0, 64), (8, 54), (15, 49), (38, 48), (48, 66), (56, 92), (90, 100), (180, 100)]
    for (f0, t0), (f1, t1) in zip(pts, pts[1:]):
        if f <= f1:
            return t0 + (t1 - t0) * (f - f0) / (f1 - f0)
    return 100


tiers = {'dark': bmesh.new(), 'mid': bmesh.new(), 'light': bmesh.new()}
theta = 2.0
while theta < 100:
    th = math.radians(theta)
    count = max(5, round(2 * math.pi * 4 * math.sin(th) / (.58 - .2 * theta / 100)))
    for k in range(count):
        az = math.tau * (k + rnd.random() * .3) / count
        tm = theta_max(az)
        d = theta / tm
        if d > 1:
            continue
        dirv = Vector((math.sin(th) * math.cos(az), math.sin(th) * math.sin(az), math.cos(th)))
        if dirv.y > .25:
            continue
        tier = 'dark' if d < .5 else ('mid' if d < .78 else 'light')
        size = .6 - .32 * d ** 1.3
        down = Vector((0, 0, -1)) - dirv * (-dirv.z)
        scale_piece(tiers[tier], dirv * 3.985, dirv, down if down.length > 1e-3 else Vector((0, -1, 0)), size, width=.82, thick=.06, lift=-.22)
    theta += 3.6
for tier, b in tiers.items():
    finish('V_SkullScales_' + {'dark': 'Fonce', 'mid': 'Moyen', 'light': 'Clair'}[tier], b, M[tier])
# Pastilles éparpillées sous la ligne d'écailles.
dots = bmesh.new()
for _ in range(900):
    az = rnd.uniform(-math.pi, 0)
    tm = theta_max(az)
    theta = tm + rnd.uniform(1, 14) ** 1.1
    th = math.radians(theta)
    dirv = Vector((math.sin(th) * math.cos(az), math.sin(th) * math.sin(az), math.cos(th)))
    # Jamais sur les yeux ni dans la bouche.
    p = dirv * 4
    if (abs(p.x) < 2.6 and 1.45 < p.z < 2.5) or p.z < -.2 or (abs(p.x) < 3.4 and p.z < .9 and p.y < -1.5) or dirv.y > .1:
        continue
    if rnd.random() > .25:
        continue
    scale_piece(dots, dirv * 3.99, dirv, Vector((0, 0, -1)), rnd.uniform(.07, .13), width=.75, thick=.09, lift=0)
finish('V_SkullDots', dots, M['light'])

# =================================================================== veines de venin néon


def sph(theta_deg, az_deg, r=4.07):
    t, a = math.radians(theta_deg), math.radians(az_deg)
    return Vector((math.sin(t) * math.cos(a), math.sin(t) * math.sin(a), math.cos(t))) * r


def tube(bm, pts, r0, r1, sides=6):
    rings = []
    for i, p in enumerate(pts):
        t = i / (len(pts) - 1)
        tan = (pts[min(i + 1, len(pts) - 1)] - pts[max(i - 1, 0)]).normalized()
        n = p.normalized()
        b = tan.cross(n).normalized()
        r = r0 + (r1 - r0) * t
        rings.append([bm.verts.new(p + (n * math.cos(k * math.tau / sides) + b * math.sin(k * math.tau / sides)) * r) for k in range(sides)])
    for A, B in zip(rings, rings[1:]):
        for k in range(sides):
            bm.faces.new((A[k], A[(k + 1) % sides], B[(k + 1) % sides], B[k]))


def vein(bm, ctrl, r0=.06, r1=.025):
    pts = []
    for (t0, a0), (t1, a1) in zip(ctrl, ctrl[1:]):
        for i in range(8):
            u = i / 8
            j = 2.2 * math.sin(u * math.pi) * (rnd.random() - .5)
            pts.append(sph(t0 + (t1 - t0) * u + j, a0 + (a1 - a0) * u + j * 1.5))
    pts.append(sph(*ctrl[-1]))
    tube(bm, pts, r0, r1)


vb = bmesh.new()
for mirror in (False, True):
    m = (lambda a: -180 - a) if mirror else (lambda a: a)
    vein(vb, [(6, m(-80)), (18, m(-55)), (30, m(-42)), (45, m(-33)), (62, m(-28)), (80, m(-26)), (96, m(-30))])
    vein(vb, [(18, m(-55)), (28, m(-70)), (40, m(-74)), (47, m(-80))], .045, .02)
    vein(vb, [(30, m(-42)), (40, m(-50)), (47, m(-58))], .04, .02)
    vein(vb, [(45, m(-33)), (55, m(-20)), (70, m(-10))], .04, .02)
vein(vb, [(4, -95), (16, -88), (28, -96), (42, -88), (56, -90)], .05, .022)
finish('V_VenomVeins', vb, M['veins'])

# =================================================================== crocs + gouttes de venin
fb = bmesh.new()


def fang(bm, x0, length, radius, sign):
    N, S = 22, 14

    def centre(t):
        x = sign * (x0 - .12 * t)
        z = .15 - length * t
        y = -math.sqrt(max(.5, 4.12 ** 2 - x * x - (z * .55) ** 2)) - .08 - .35 * math.sin(math.pi * t * .8) + .2 * t * t
        return Vector((x, y, z))
    rings = []
    for j in range(N + 1):
        t = j / N
        c = centre(t)
        tan = (centre(min(1, t + .01)) - centre(max(0, t - .01))).normalized()
        u = tan.cross(Vector((1, 0, 0))).normalized()
        v = tan.cross(u).normalized()
        r = radius * (1 - t) ** .8 + .012
        rings.append([bm.verts.new(c + (u * math.cos(a) + v * math.sin(a) * 1.15) * r) for a in [math.tau * i / S for i in range(S)]])
    for A, B in zip(rings, rings[1:]):
        for i in range(S):
            bm.faces.new((A[i], B[i], B[(i + 1) % S], A[(i + 1) % S]))
    tip = bm.verts.new(centre(1) + (centre(1) - centre(.97)).normalized() * .03)
    for i in range(S):
        bm.faces.new((rings[-1][i], tip, rings[-1][(i + 1) % S]))
    top = bm.verts.new(centre(0))
    for i in range(S):
        bm.faces.new((rings[0][(i + 1) % S], top, rings[0][i]))
    return centre(1)


drops = bmesh.new()
for sign in (-1, 1):
    for x0, length, rad in [(3.0, 2.15, .33), (2.38, 1.45, .24)]:
        tip = fang(fb, x0, length, rad, sign)
        # Goutte de venin suspendue sous la pointe.
        ret = bmesh.ops.create_uvsphere(drops, u_segments=12, v_segments=8, radius=1)
        for v in ret['verts']:
            k = max(0, v.co.z)
            v.co.x *= 1 - .75 * k ** 1.5
            v.co.y *= 1 - .75 * k ** 1.5
            v.co.z *= 1.6 if v.co.z > 0 else 1
        r = .12 if length > 2 else .085
        bmesh.ops.transform(drops, matrix=Matrix.Translation(tip + Vector((0, 0, -.12 - r * 1.1))) @ Matrix.Scale(r, 4), verts=ret['verts'])
bmesh.ops.recalc_face_normals(fb, faces=list(fb.faces))
finish('V_Fangs', fb, M['fangs'])
finish('V_VenomDrops', drops, M['veins'])

# Repères d'alignement pour caler les accessoires sur la tête dans Studio.
for n, loc in [('V_FitOrigin', (0, 0, 0)), ('V_FitUp', (0, 0, 4)), ('V_FitFront', (0, -4, 0))]:
    bpy.ops.mesh.primitive_cube_add(size=.03, location=loc)
    o = bpy.context.object; o.name = n
    for c in list(o.users_collection):
        c.objects.unlink(o)
    acc.objects.link(o); o.hide_render = True

tri = {o.name: sum(len(p.vertices) - 2 for p in o.data.polygons) for o in acc.objects if not o.name.startswith('V_Fit')}
over = {k: v for k, v in tri.items() if v > 20000}
assert not over, f'Pièces au-dessus de la limite Roblox de 20 000 triangles : {over}'

# =================================================================== exports
bpy.ops.object.select_all(action='DESELECT')
for o in acc.objects:
    o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_ACCESSOIRES_IMPORT.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False)
for o in base.objects:
    o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_TeteSeule.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False)
bpy.ops.wm.obj_export(filepath=str(OUT / 'VeniCrax_TeteSeule.obj'), export_selected_objects=True, forward_axis='NEGATIVE_Z', up_axis='Y')

# =================================================================== rendus
s = bpy.context.scene
s.render.engine = 'CYCLES'; s.cycles.samples = 24 if QUICK else 128; s.cycles.use_denoising = not QUICK
s.render.resolution_x = s.render.resolution_y = 900; s.render.resolution_percentage = 100
s.render.image_settings.file_format = 'PNG'
bpy.ops.object.camera_add(); cam = bpy.context.object; s.camera = cam
cam.data.type = 'ORTHO'; cam.data.ortho_scale = 14.5
for name, pos in [('face', (0, -25, .6)), ('trois-quarts', (13, -22, 5)), ('profil', (25, -1, 2.5)), ('dos', (0, 25, 2.5))]:
    if QUICK and name in ('profil', 'dos'):
        continue
    cam.location = pos
    cam.rotation_euler = (-cam.location).to_track_quat('-Z', 'Y').to_euler()
    s.render.filepath = str(OUT / (name + '.png'))
    bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT / 'VeniCrax.blend'))
(OUT / 'VeniCrax.blend1').unlink(missing_ok=True)
(OUT / 'manifest.json').write_text(json.dumps({
    'headOnly': True,
    'version': 2,
    'originalGroups': len(base.objects),
    'accessories': list(tri),
    'markers': ['V_FitOrigin', 'V_FitUp', 'V_FitFront'],
    'triangles': tri,
    'sourceSHA256': hashlib.sha256((ROOT / 'assets/supercrax/model/source/CraxSourire_original.obj').read_bytes()).hexdigest(),
}, indent=2, ensure_ascii=False) + '\n')
print('VENICRAX OK', tri)
