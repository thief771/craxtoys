"""VeniCrax V3 : casque capuche de cobra (choix du créateur).

Vraie géométrie CraxSourire inchangée + casque original façon capuche de cobra : écailles vert foncé,
crête de plaques ventrales crème tachées de noir, intérieur crème, veines de venin néon,
quatre petits crocs verts translucides avec gouttes. Visage (yeux fermés + sourire) découvert.

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
    helmet=bpy.data.materials.new('Helmet_CobraScales'),
    veins=mat('Venom_Neon', (.55, 1.0, .05), .3, emit=2.2),
    fangs=mat('Fangs_VenomGlass', (.30, .80, .0), .1, coat=.5, emit=1.1, trans=.12),
    drops=mat('Venom_Drops', (.62, 1.0, .08), .03, coat=1., emit=1.4, trans=.5),
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


# =================================================================== texture d'écailles de cobra (générée)
import numpy as np
TW, TH, NU, NVS = 2048, 1024, 64, 30
yy, xx = np.mgrid[0:TH, 0:TW].astype(np.float32)
u = xx / TW; v = 1 - yy / TH                       # v = 0 en bas de l'image (convention Blender)
cv = (1 - v) * NVS                                  # rangées depuis le sommet du casque
row = np.floor(cv)
cnt = np.maximum(10, np.round(NU * np.sin(np.radians(np.clip((row + .5) / NVS, 0, 1) * 150 + 8))))   # taille d'écaille constante
cu = u * cnt + .5 * (row % 2)
lu = cu - np.floor(cu) - .5                         # -0.5..0.5 en travers
lv = cv - row                                       # 0 haut .. 1 bas de la rangée
# Écaille en losange arrondi, pointe vers le bas, légèrement imbriquée sur la rangée suivante.
d = np.abs(lu) / .52 + np.abs(lv - .45) / .62
d = np.minimum(d, np.abs(lu) ** 2 * 3.2 + np.abs(lv - .45) / .62 + .06)
h = np.clip(1 - d, 0, 1) ** .6                      # bombé
cell = (np.floor(cu) * 7.13 + row * 3.71) % 1
cell = cell * .6 + .2      # variation par écaille
gap = np.clip((d - .9) / .1, 0, 1)
dark = np.array([.010, .085, .032]); rim = np.array([.04, .24, .085]); groove = np.array([.003, .015, .006])
t = np.clip(d, 0, 1)[..., None]
col = dark * (1 - t) + rim * t
col = col * (.85 + .3 * cell[..., None])
band = ((row % 6) == 3)[..., None]                  # bandes plus claires, façon dos de cobra
col = np.where(band, col * 1.6 + np.array([.02, .03, .0]), col)
col = col * (1 - gap[..., None]) + groove * gap[..., None]
img = bpy.data.images.new('VeniCrax_Helmet_Color', TW, TH, alpha=False)
img.pixels.foreach_set(np.concatenate([col, np.ones((TH, TW, 1))], axis=2).astype(np.float32).ravel())
img.filepath_raw = str(OUT / 'VeniCrax_Helmet_Color.png'); img.file_format = 'PNG'; img.save()
# Normal map tangente (format OpenGL, Y+) dérivée de la hauteur.
gy, gx = np.gradient(h)
k = 9.0
nx, ny, nz = -gx * k, gy * k, np.ones_like(h)
ln = np.sqrt(nx * nx + ny * ny + nz * nz)
nrm = np.stack([nx / ln * .5 + .5, ny / ln * .5 + .5, nz / ln * .5 + .5, np.ones_like(h)], axis=2)
nimg = bpy.data.images.new('VeniCrax_Helmet_Normal', TW, TH, alpha=False)
nimg.colorspace_settings.name = 'Non-Color'
nimg.pixels.foreach_set(nrm.astype(np.float32).ravel())
nimg.filepath_raw = str(OUT / 'VeniCrax_Helmet_Normal.png'); nimg.file_format = 'PNG'; nimg.save()
hm = M['helmet']; hm.use_nodes = True; nt = hm.node_tree; bsdf = nt.nodes['Principled BSDF']
bsdf.inputs['Roughness'].default_value = .28; bsdf.inputs['Coat Weight'].default_value = .6
tc = nt.nodes.new('ShaderNodeTexImage'); tc.image = img
tn = nt.nodes.new('ShaderNodeTexImage'); tn.image = nimg
nm = nt.nodes.new('ShaderNodeNormalMap'); nm.inputs['Strength'].default_value = 1.0
nt.links.new(tc.outputs['Color'], bsdf.inputs['Base Color']); nt.links.new(tn.outputs['Color'], nm.inputs['Color']); nt.links.new(nm.outputs['Normal'], bsdf.inputs['Normal'])
hm.diffuse_color = (.02, .15, .05, 1)

# =================================================================== casque capuche de cobra
# Casque original : coque au-dessus de la tête, arcade pointue au-dessus des yeux, joues qui encadrent le sourire,
# jupe arrière évasée en capuche de cobra. Le visage (yeux + sourire) reste découvert.
HR = 4.3          # rayon de la coque
SKIRT = 158.      # angle polaire du bas de la jupe (depuis le sommet)


def front_angle(az):
    """0 = face, 180 = dos."""
    f = (math.degrees(az) + 90) % 360
    return min(f, 360 - f)


def lerp_table(x, pts):
    for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
        if x <= x1:
            u = (x - x0) / (x1 - x0)
            u = u * u * (3 - 2 * u)
            return y0 + (y1 - y0) * u
    return pts[-1][1]


def edge_polar(az):
    """Bord bas du casque (degrés depuis le sommet) : pointe d'arcade au centre, au-dessus des yeux, puis les joues
    descendent derrière les coins du sourire et rejoignent la jupe arrière."""
    return lerp_table(front_angle(az), [(0, 58), (6, 52), (12, 49), (44, 49), (52, 58), (60, 84), (68, 116), (82, 146), (100, SKIRT), (180, SKIRT)])


def flare(p, az):
    """Évasement de la jupe : nul sur le dessus, large sur les côtés et l'arrière vers le bas."""
    f = front_angle(az)
    side = lerp_table(f, [(0, 0), (50, .55), (80, 1.35), (180, 1.0)])
    u = max(0., (p - 70) / (SKIRT - 70))
    return (1.0 + .6 * abs(math.cos(az))) * side * u ** 1.5


def helmet_point(az, v, lift=0.):
    """v : 0 = sommet, 1 = bord bas pour cet azimut."""
    p = math.radians(v * edge_polar(az))
    r = HR + flare(math.degrees(p), az) + lift
    return Vector((r * math.sin(p) * math.cos(az), r * math.sin(p) * math.sin(az), HR * math.cos(p) - .25 * flare(math.degrees(p), az)))


def helmet_frame(az, v, lift=0.):
    p = helmet_point(az, v, lift)
    dv = (helmet_point(az, min(1, v + .004), lift) - helmet_point(az, max(0, v - .004), lift)).normalized()
    da = (helmet_point(az + .004, v, lift) - helmet_point(az - .004, v, lift)).normalized()
    n = dv.cross(da).normalized()
    if n.dot(p) < 0:
        n = -n
    return p, dv, n


NA, NV = 112, 36
SEAM = math.pi / 2          # couture UV à l'arrière, sous la crête


def az_of(i):
    return SEAM + math.tau * i / NA


bm = bmesh.new()
uv = bm.loops.layers.uv.new('UVMap')
grid = [[bm.verts.new(helmet_point(az_of(i), max(j / NV, .004))) for i in range(NA)] for j in range(NV + 1)]   # petit anneau au sommet (caché sous la crête) : pas de face dégénérée
for j in range(NV):
    for i in range(NA):
        f = bm.faces.new((grid[j][i], grid[j][(i + 1) % NA], grid[j + 1][(i + 1) % NA], grid[j + 1][i]))
        for loop, (uu, vv) in zip(f.loops, [(i, j), (i + 1, j), (i + 1, j + 1), (i, j + 1)]):
            loop[uv].uv = (uu / NA, 1 - vv / NV)
bm.normal_update()
for f in bm.faces:
    if f.normal.dot(f.calc_center_median()) < 0:
        f.normal_flip()
shell = finish('V_HelmetShell', bm, M['helmet'])
shell.data.materials.append(M['bands'])          # intérieur crème (visible sous la jupe)
bpy.context.view_layer.objects.active = shell
mod = shell.modifiers.new('T', 'SOLIDIFY'); mod.thickness = .14; mod.offset = -1; mod.material_offset = 1
bpy.ops.object.modifier_apply(modifier=mod.name)

# --- crête centrale : plaques ventrales crème segmentées, de l'arcade jusqu'au bas de la nuque
CREST_W = .78   # demi-largeur
crest, blot = bmesh.new(), bmesh.new()


def crest_point(t, w, h):
    """t : 0 = pointe de l'arcade, 1 = bas de la nuque ; w : -1..1 en travers ; h : hauteur au-dessus de la coque."""
    ang = math.radians(-58 + t * (58 + 150))        # angle dans le plan Y-Z, depuis le sommet, négatif = vers l'avant
    az = -math.pi / 2 if ang < 0 else math.pi / 2
    v = abs(math.degrees(ang)) / edge_polar(az)
    base = helmet_point(az, min(v, 1))
    out = base.normalized() if base.length else Vector((0, 0, 1))
    side = Vector((1, 0, 0))
    return base + side * (w * CREST_W) + out * (.06 + h)


PLATES = 15
for k in range(PLATES):
    t0, t1 = k / PLATES + .006, (k + 1) / PLATES - .006
    rows = []
    NU, NW = 5, 8
    for i in range(NU + 1):
        t = t0 + (t1 - t0) * i / NU
        u = i / NU
        row = []
        for j in range(NW + 1):
            w = -1 + 2 * j / NW
            taper = 1 - .35 * max(0, (k - 9) / 6)          # se resserre vers la nuque
            h = .13 * math.sin(math.pi * u) * (1 - w * w * .6) + .09 * u
            row.append(crest.verts.new(crest_point(t, w * taper, h)))
        rows.append(row)
    for i in range(NU):
        for j in range(NW):
            crest.faces.new((rows[i][j], rows[i][j + 1], rows[i + 1][j + 1], rows[i + 1][j]))
bmesh.ops.recalc_face_normals(crest, faces=list(crest.faces))
o = finish('V_HelmetCrest', crest, M['bands'])
bpy.context.view_layer.objects.active = o
mod = o.modifiers.new('T', 'SOLIDIFY'); mod.thickness = .08; mod.offset = -1
bpy.ops.object.modifier_apply(modifier=mod.name)
blot.free()

# --- arcade en relief le long du bord avant, pointe centrale descendante entre les yeux
brow = bmesh.new()


def brow_tube(pts, radius, sides=10):
    rings = []
    for i, p in enumerate(pts):
        tan = (pts[min(i + 1, len(pts) - 1)] - pts[max(i - 1, 0)]).normalized()
        n = p.normalized()
        b = tan.cross(n).normalized()
        r = radius(i / (len(pts) - 1))
        rings.append([brow.verts.new(p + (n * math.cos(k * math.tau / sides) * .8 + b * math.sin(k * math.tau / sides)) * r) for k in range(sides)])
    for A, B in zip(rings, rings[1:]):
        for k in range(sides):
            brow.faces.new((A[k], A[(k + 1) % sides], B[(k + 1) % sides], B[k]))
    for ring in (rings[0], rings[-1][::-1]):
        brow.faces.new(ring)


for sgn in (-1, 1):
    pts = [helmet_point(math.radians(-90 + sgn * f), .975, .06) for f in [i * 1.6 for i in range(0, 44)]]
    brow_tube(pts, lambda t: .2 - .08 * t)
# Pointe centrale (comme un croc) qui descend vers le nez, et deux petites pointes au-dessus des yeux.
for xoff, length, w in [(0, .75, .3), (-1.85, .38, .16), (1.85, .38, .16)]:
    az = math.atan2(-4, xoff)
    top = helmet_point(az, .97, .1)
    tip = top + Vector((0, -.18, -length))
    side = Vector((1, 0, 0)) * w
    a, b, c, d = brow.verts.new(top - side), brow.verts.new(top + side), brow.verts.new(tip), brow.verts.new(top + Vector((0, -.14, -.05)))
    brow.faces.new((a, d, c)); brow.faces.new((d, b, c)); brow.faces.new((a, c, b)); brow.faces.new((a, b, d))
bmesh.ops.recalc_face_normals(brow, faces=list(brow.faces))
finish('V_HelmetBrow', brow, M['shell'])

# =================================================================== veines de venin néon (sur le casque)
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
    """ctrl : liste (azimut en degrés, v 0..1) sur le casque."""
    pts = []
    for (a0, v0), (a1, v1) in zip(ctrl, ctrl[1:]):
        for i in range(10):
            u = i / 10
            j = math.sin(u * math.pi) * (rnd.random() - .5)
            pts.append(helmet_point(math.radians(a0 + (a1 - a0) * u + 4 * j), min(.995, v0 + (v1 - v0) * u + .015 * j), .05))
    pts.append(helmet_point(math.radians(ctrl[-1][0]), ctrl[-1][1], .05))
    tube(bm, pts, r0, r1)


vb = bmesh.new()
for mirror in (False, True):
    m = (lambda a: -180 - a) if mirror else (lambda a: a)
    vein(vb, [(m(-80), .25), (m(-50), .4), (m(-15), .55), (m(5), .75), (m(-5), .97)], .04, .016)
    vein(vb, [(m(-15), .55), (m(25), .6), (m(45), .85)], .03, .014)
    vein(vb, [(m(-65), .15), (m(-10), .3), (m(40), .4), (m(70), .62)], .035, .015)
    vein(vb, [(m(5), .75), (m(20), .95)], .03, .014)
finish('V_VenomVeins', vb, M['veins'])

# =================================================================== crocs + gouttes de venin
# Chaque croc : coque translucide (verre vert) + cœur néon à l'intérieur, racine enfoncée dans la gencive,
# courbure de croc de serpent (vers l'avant puis la pointe revient vers la bouche), section aplatie.
fb, core, drops = bmesh.new(), bmesh.new(), bmesh.new()


def fang_centre(x0, length, sign, t):
    x = sign * (x0 - .1 * t - .22 * t * t)
    z = .32 - (length + .17) * t
    y = -math.sqrt(max(.5, 4.12 ** 2 - x * x - (z * .55) ** 2)) - .06 - .42 * math.sin(math.pi * t * .78) + .38 * t * t
    return Vector((x, y, z))


def fang(bm, x0, length, radius, sign, scale=1., tip_len=.05):
    N, S = 36, 24
    rings = []
    for j in range(N + 1):
        t = j / N
        c = fang_centre(x0, length, sign, t)
        tan = (fang_centre(x0, length, sign, min(1, t + .01)) - fang_centre(x0, length, sign, max(0, t - .01))).normalized()
        u = tan.cross(Vector((0, -1, 0))).normalized()      # travers (largeur)
        v = tan.cross(u).normalized()                       # profondeur
        r = radius * scale * ((1 - t) ** .85) * (1 + .12 * math.sin(math.pi * min(1, t * 2.2))) + .006
        ring = []
        for i in range(S):
            a = math.tau * i / S
            ring.append(bm.verts.new(c + u * math.cos(a) * r + v * math.sin(a) * r * .72))
        rings.append(ring)
    for A, B in zip(rings, rings[1:]):
        for i in range(S):
            bm.faces.new((A[i], B[i], B[(i + 1) % S], A[(i + 1) % S]))
    end = fang_centre(x0, length, sign, 1)
    tip = bm.verts.new(end + (end - fang_centre(x0, length, sign, .97)).normalized() * tip_len)
    for i in range(S):
        bm.faces.new((rings[-1][i], tip, rings[-1][(i + 1) % S]))
    top = bm.verts.new(fang_centre(x0, length, sign, 0))
    for i in range(S):
        bm.faces.new((rings[0][(i + 1) % S], top, rings[0][i]))
    return tip.co.copy()


def drip(bm, tip, size):
    """Filet de venin effilé depuis la pointe, puis goutte en forme de larme."""
    L = size * 1.6
    S = 10
    rings = []
    for j in range(7):
        t = j / 6
        c = tip + Vector((0, 0, -L * t))
        r = .012 + (size * .45) * t ** 2.2
        rings.append([bm.verts.new(c + Vector((math.cos(a) * r, math.sin(a) * r, 0))) for a in [math.tau * i / S for i in range(S)]])
    for A, B in zip(rings, rings[1:]):
        for i in range(S):
            bm.faces.new((A[i], A[(i + 1) % S], B[(i + 1) % S], B[i]))
    ret = bmesh.ops.create_uvsphere(bm, u_segments=14, v_segments=10, radius=1)
    for v in ret['verts']:
        k = max(0, v.co.z)
        v.co.x *= 1 - .55 * k ** 1.4
        v.co.y *= 1 - .55 * k ** 1.4
        v.co.z *= 1.35 if v.co.z > 0 else 1.05
    bmesh.ops.transform(bm, matrix=Matrix.Translation(tip + Vector((0, 0, -L - size * .9))) @ Matrix.Scale(size, 4), verts=ret['verts'])


for sign in (-1, 1):
    for x0, length, rad, d in [(3.0, 1.35, .3, .1), (2.36, .95, .22, .075)]:
        tip = fang(fb, x0, length, rad, sign)
        fang(core, x0, length * .93, rad, sign, scale=.42, tip_len=.0)
        drip(drops, tip, d)
for b in (fb, core, drops):
    bmesh.ops.recalc_face_normals(b, faces=list(b.faces))
finish('V_Fangs', fb, M['fangs'])
finish('V_FangsCore', core, M['veins'])
finish('V_VenomDrops', drops, M['drops'])

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
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_ACCESSOIRES_IMPORT.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False, path_mode='COPY', embed_textures=True)
for o in base.objects:
    o.select_set(True)
bpy.ops.export_scene.fbx(filepath=str(OUT / 'VeniCrax_TeteSeule.fbx'), use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y', bake_anim=False, path_mode='COPY', embed_textures=True)
bpy.ops.wm.obj_export(filepath=str(OUT / 'VeniCrax_TeteSeule.obj'), export_selected_objects=True, forward_axis='NEGATIVE_Z', up_axis='Y')

# =================================================================== rendus
s = bpy.context.scene
s.render.engine = 'CYCLES'; s.cycles.samples = 24 if QUICK else 128; s.cycles.use_denoising = not QUICK
s.render.resolution_x = s.render.resolution_y = 900; s.render.resolution_percentage = 100
s.render.image_settings.file_format = 'PNG'
bpy.ops.object.camera_add(); cam = bpy.context.object; s.camera = cam
cam.data.type = 'ORTHO'; cam.data.ortho_scale = 14.5
cam.data.ortho_scale = 4.2
cam.location = (2.2, -25, -.9); cam.rotation_euler = (math.radians(90), 0, 0)
s.render.filepath = str(OUT / 'crocs.png'); bpy.ops.render.render(write_still=True)
cam.data.ortho_scale = 14.5
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
