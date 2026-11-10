"""Sons originaux VeniCrax (synthèse numpy/scipy, aucun échantillon tiers).

Sorties : assets/venicrax/audio/<Nom>.wav, VeniCrax_Audio_Atlas.wav (tous les sons à la suite, 0,12 s d'écart),
manifest.json, ECOUTER.html et src/venicrax/CraxVeniAudioMap.lua (régions de lecture pour Roblox).
"""
import json, wave
from pathlib import Path
import numpy as np
from scipy import signal

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/venicrax/audio'
OUT.mkdir(parents=True, exist_ok=True)
SR = 44100
rng = np.random.default_rng(1977)


def t_(d):
    return np.arange(int(d * SR)) / SR


def env(d, a=.01, r=.2, curve=3.):
    t = t_(d)
    e = np.minimum(1, t / max(a, 1e-4))
    tail = np.clip((d - t) / max(r, 1e-4), 0, 1) ** curve
    return e * tail


def noise(d):
    return rng.standard_normal(int(d * SR))


def band(x, lo, hi, order=4):
    sos = signal.butter(order, [lo, hi], btype='band', fs=SR, output='sos')
    return signal.sosfilt(sos, x)


def low(x, f, order=4):
    return signal.sosfilt(signal.butter(order, f, btype='low', fs=SR, output='sos'), x)


def high(x, f, order=4):
    return signal.sosfilt(signal.butter(order, f, btype='high', fs=SR, output='sos'), x)


def sweep_band(x, f0, f1, width=.6):
    """Filtre passe-bande glissant (par blocs) : souffles et « whoosh »."""
    out = np.zeros_like(x); n = len(x); block = 1024
    for i in range(0, n, block):
        u = i / max(1, n - 1); f = f0 * (f1 / f0) ** u
        lo, hi = max(40, f * (1 - width / 2)), min(SR / 2 - 100, f * (1 + width / 2))
        seg = x[max(0, i - 2048):i + block]
        y = signal.sosfilt(signal.butter(2, [lo, hi], btype='band', fs=SR, output='sos'), seg)
        out[i:i + block] = y[-len(x[i:i + block]):]
    return out


def chirp(d, f0, f1, kind='exp'):
    t = t_(d)
    if kind == 'exp':
        f = f0 * (f1 / f0) ** (t / d)
    else:
        f = f0 + (f1 - f0) * t / d
    return np.sin(2 * np.pi * np.cumsum(f) / SR)


def hiss(d, a=.04, r=.25, bright=1.):
    x = band(noise(d), 2800, 9000 * bright) + .35 * band(noise(d), 6000, 12000)
    # léger frémissement de la langue
    t = t_(d)
    return x * env(d, a, r, 2) * (.8 + .2 * np.sin(2 * np.pi * 23 * t))


def thump(d, f0=110, f1=45):
    return chirp(d, f0, f1) * env(d, .002, d, 4)


def norm(x, peak=.45):
    m = np.max(np.abs(x)) or 1
    return x / m * peak


def loopable(x, fade=.08):
    """Boucle sans clic : fondu croisé fin -> début."""
    n = int(fade * SR); y = x.copy()
    w = np.linspace(0, 1, n)
    y[:n] = x[:n] * w + x[-n:] * (1 - w)
    return y[:-n]


S = {}
# --- combat
bite = np.zeros(int(.42 * SR))
crack = high(noise(.03), 2500) * env(.03, .0005, .03, 2); bite[:len(crack)] += 1.1 * crack
body = thump(.22, 160, 60); bite[200:200 + len(body)] += .9 * body
sq = band(noise(.25), 900, 3500) * env(.25, .01, .2); bite[1500:1500 + len(sq)] += .45 * sq
hs = hiss(.3, .05, .2) * .5; bite[-len(hs):] += hs
S['Bite'] = norm(bite, .46)

stack = high(noise(.04), 3000) * env(.04, .0005, .04, 2) * .9
st = np.zeros(int(.16 * SR)); st[:len(stack)] += stack; tt = thump(.1, 260, 140); st[100:100 + len(tt)] += .5 * tt
S['BiteStack'] = norm(st, .38)

drip = chirp(.12, 1300, 520) * env(.12, .002, .1, 2) + .15 * band(noise(.12), 3000, 7000) * env(.12, .001, .05)
S['PoisonTick'] = norm(drip, .3)

spit = low(noise(.35), 2400) * env(.35, .004, .3, 2.5) + .5 * chirp(.35, 520, 160) * env(.35, .003, .25)
sp = np.zeros(int(.5 * SR)); sp[:len(spit)] += spit; sp += .4 * np.pad(hiss(.4, .02, .3), (int(.1 * SR), 0))[:len(sp)]
S['Spit'] = norm(sp, .44)

d = 1.1; t = t_(d)
slither = band(noise(d), 1200, 6000) * (.55 + .45 * np.abs(np.sin(2 * np.pi * 9 * t))) + .4 * band(noise(d), 300, 900) * (.6 + .4 * np.sin(2 * np.pi * 3 * t))
S['CobraLoop'] = norm(loopable(slither), .3)

b = np.zeros(int(.45 * SR)); th = thump(.3, 95, 40); b[:len(th)] += th
spl = low(noise(.35), 3500) * env(.35, .002, .3); b[300:300 + len(spl)] += .7 * spl
S['Bounce'] = norm(b, .44)

imp = np.zeros(int(.7 * SR)); th = thump(.4, 140, 45); imp[:len(th)] += 1.2 * th
sl = low(noise(.5), 2500) * env(.5, .001, .45, 2); imp[:len(sl)] += .9 * sl
sz = band(noise(.6), 2000, 8000) * env(.6, .05, .5); imp[int(.08 * SR):int(.08 * SR) + len(sz)] += .45 * sz
S['CobraImpact'] = norm(imp, .46)

d = .7; t = t_(d)
shim = sum(np.sin(2 * np.pi * f * t + p) for f, p in [(1320, 0), (1980, 1), (2640, 2), (3300, .5)]) * (.6 + .4 * np.sin(2 * np.pi * 11 * t)) * env(d, .08, .4, 2)
S['DistillReady'] = norm(shim + .2 * hiss(d, .1, .4), .3)

d = 1.1; heal = np.zeros(int(d * SR))
for i, f in enumerate([523.25, 659.25, 783.99, 1046.5]):
    n0 = int(i * .12 * SR); tt = t_(d - i * .12)
    bell = (np.sin(2 * np.pi * f * tt) + .45 * np.sin(2 * np.pi * f * 2.01 * tt) + .2 * np.sin(2 * np.pi * f * 3.02 * tt)) * np.exp(-tt * 3.2)
    heal[n0:n0 + len(bell)] += bell[:len(heal) - n0]
heal += .25 * sweep_band(noise(d), 800, 6000, .5) * env(d, .1, .6)
S['Distill'] = norm(heal, .4)

d = .8; t = t_(d); cr = np.zeros(int(d * SR))
for _ in range(70):
    p = int(rng.uniform(0, d - .02) * SR); c = high(noise(.012), 1800) * env(.012, .0005, .012, 2); cr[p:p + len(c)] += c * rng.uniform(.3, 1)
cr = cr * env(d, .05, .4) + .35 * band(noise(d), 500, 2500) * env(d, .1, .5)
S['MoltShed'] = norm(cr, .38)

d = 1.2; t = t_(d)
S['MoltIdle'] = norm(loopable(band(noise(d), 400, 1800) * (.7 + .3 * np.sin(2 * np.pi * 1.5 * t)) + .4 * hiss(d, .3, .3)), .18)

d = .75; t = t_(d)
warn = chirp(d, 180, 640) * (.65 + .35 * np.sin(2 * np.pi * 14 * t)) * env(d, .05, .08, 1) + .5 * hiss(d, .1, .1)
S['MoltWarn'] = norm(warn, .4)

d = 1.4
cl = sweep_band(noise(d), 300, 3500, .9) * env(d, .05, 1., 2); boom = thump(.6, 80, 35); cl[:len(boom)] += .8 * boom
S['Cloud'] = norm(cl, .44)

# --- exécution MAX
d = 1.3; S['MaxHiss'] = norm(hiss(d, .12, .5, 1.1) + .3 * band(noise(d), 200, 600) * env(d, .2, .6), .42)
ms = np.zeros(int(1.0 * SR)); a = S['Spit'] / .44; ms[:len(a)] += a; bb = thump(.5, 70, 30); ms[:len(bb)] += .8 * bb
S['MaxSpit'] = norm(ms, .45)
mb = np.zeros(int(.8 * SR)); a = S['Bounce'] / .44; mb[:len(a)] += a; rv = low(noise(.8), 1800) * env(.8, .01, .7, 3) * .4; mb += rv
S['MaxBounce'] = norm(mb, .45)
d = 2.0; t = t_(d)
coil = band(noise(d), 900, 5000) * (.5 + .5 * np.abs(np.sin(2 * np.pi * (5 + 6 * t / d) * t))) * env(d, .1, .3, 1) + .35 * chirp(d, 60, 110) * env(d, .3, .3, 1)
S['MaxCoil'] = norm(coil, .4)
d = .8; t = t_(d)
saw = signal.sawtooth(2 * np.pi * np.cumsum(70 + 25 * np.sin(2 * np.pi * 7 * t) + 15 * rng.standard_normal(len(t)).cumsum() / 400) / SR)
S['MaxSqueeze'] = norm(low(saw, 1200) * env(d, .05, .25) + .3 * band(noise(d), 300, 1500) * env(d, .05, .3), .42)
d = 1.0; mc = np.zeros(int(d * SR))
for i, at in enumerate(np.sort(rng.uniform(0, .8, 9))):
    p = int(at * SR); c = high(noise(.05), 2200) * env(.05, .0005, .05, 3) + .4 * chirp(.05, 3200, 1800) * env(.05, .0005, .05)
    mc[p:p + len(c)] += c * (.5 + .5 * i / 9)
S['MaxCrack'] = norm(mc, .45)
d = 1.5; sh = np.zeros(int(d * SR)); bm = thump(.9, 90, 28); sh[:len(bm)] += 1.4 * bm
burst = high(noise(.25), 1500) * env(.25, .001, .25, 2); sh[:len(burst)] += burst
for _ in range(60):
    p = int(rng.uniform(.05, 1.3) * SR); c = band(noise(.02), 2500, 9000) * env(.02, .0005, .02, 2)
    sh[p:p + len(c)] += c * rng.uniform(.15, .55) * (1.4 - p / len(sh))
S['MaxShatter'] = norm(sh, .46)
d = 1.8; t = t_(d); sting = np.zeros(len(t))
for f in [110, 130.81, 164.81, 220, 261.63]:   # accord mineur sombre
    sting += (signal.sawtooth(2 * np.pi * f * t) * .3 + np.sin(2 * np.pi * f * t)) * np.exp(-t * 1.2)
sting = low(sting, 2600) * env(d, .01, .8, 1.5) + .35 * hiss(d, .05, .9)
S['MaxSting'] = norm(sting, .42)

ORDER = ['Bite', 'BiteStack', 'PoisonTick', 'Spit', 'CobraLoop', 'Bounce', 'CobraImpact', 'DistillReady', 'Distill',
         'MoltShed', 'MoltIdle', 'MoltWarn', 'Cloud', 'MaxHiss', 'MaxSpit', 'MaxBounce', 'MaxCoil', 'MaxSqueeze', 'MaxCrack',
         'MaxShatter', 'MaxSting']
LOOPS = {'CobraLoop', 'MoltIdle'}
GAP = int(.12 * SR)


def pcm(x):
    return (np.clip(x, -1, 1) * 32767).astype('<i2')


def write(path, data):
    with wave.open(str(path), 'wb') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR); w.writeframes(data.tobytes())


atlas = []; segs = {}; pos = 0
for name in ORDER:
    x = S[name]
    assert np.all(np.isfinite(x)) and np.max(np.abs(x)) < .47, name
    data = pcm(x)
    write(OUT / f'{name}.wav', data)
    segs[name] = {'Start': round(pos / SR, 4), 'End': round((pos + len(data)) / SR, 4), 'Loop': name in LOOPS, 'file': f'{name}.wav'}
    atlas.append(data); atlas.append(np.zeros(GAP, '<i2')); pos += len(data) + GAP
atlas = np.concatenate(atlas)
write(OUT / 'VeniCrax_Audio_Atlas.wav', atlas)
duration = round(len(atlas) / SR, 4)
(OUT / 'manifest.json').write_text(json.dumps({'duration': duration, 'sampleRate': SR, 'segments': segs, 'atlasRobloxId': ''}, indent=2, ensure_ascii=False) + '\n')
(OUT / 'ECOUTER.html').write_text('<meta charset="utf-8"><title>VeniCrax — sons</title><h1>VeniCrax — écoute avant import</h1>'
                                  '<p>Sons originaux synthétisés (sifflements, morsures, venin, mue, exécution). Importer VeniCrax_Audio_Atlas.wav dans Roblox pour les entendre en jeu.</p>'
                                  + ''.join(f'<p>{n}<br><audio controls preload="none" src="{n}.wav"></audio></p>' for n in ORDER), encoding='utf-8')
lua = 'return {Duration=%s,Segments={\n' % duration + ''.join(
    " ['%s']={Start=%s,End=%s,Loop=%s},\n" % (n, s['Start'], s['End'], 'true' if s['Loop'] else 'false') for n, s in segs.items()) + '}}\n'
(ROOT / 'src/venicrax/CraxVeniAudioMap.lua').write_text(lua)
print('VENI AUDIO OK', len(ORDER), 'sons, atlas', duration, 's')
