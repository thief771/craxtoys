"""Construit l'intégration VeniCrax pour la place « copie jeu mardi » (sources réelles inspectées le 10/11/2026).

Sorties (integration/venicrax/) :
  operations.json                  — enveloppes (wrap) et remplacements exacts (patch), chacun vérifié à 1 occurrence
  INSTALLER_VENICRAX.lua           — commande Studio (Play arrêté) : modules, événement, gabarit, aperçu, raccordements, sauvegarde
  BRANCHER_SONS_ET_TEXTURES.lua    — commande Studio : IDs de l'atlas audio, textures du casque, icônes du livre
  RETOUR_ARRIERE_VENICRAX.lua      — commande Studio : restaure les sources d'origine et retire VeniCrax
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src/venicrax'
OUT = ROOT / 'integration/venicrax'
OUT.mkdir(parents=True, exist_ok=True)


def lua(v):
    if isinstance(v, bool):
        return 'true' if v else 'false'
    if isinstance(v, (int, float)):
        return repr(v)
    if isinstance(v, str):
        eq = '===='
        while ']' + eq + ']' in v:
            eq += '='
        return '[' + eq + '[' + ('\n' if v.startswith('\n') else '') + v + ']' + eq + ']'
    if isinstance(v, list):
        return '{' + ','.join(lua(x) for x in v) + '}'
    if isinstance(v, dict):
        return '{' + ','.join('[ ' + lua(k) + ' ]=' + lua(x) for k, x in v.items()) + '}'
    raise TypeError(type(v))


# ------------------------------------------------------------------ modules installés
MODULES = []
for name, parent, cls in [
    ('CraxVeniConfig', 'ReplicatedStorage', 'ModuleScript'),
    ('CraxVeniRules', 'ReplicatedStorage', 'ModuleScript'),
    ('CraxVeniAppearance', 'ReplicatedStorage', 'ModuleScript'),
    ('CraxVeniAudio', 'ReplicatedStorage', 'ModuleScript'),
    ('CraxVeniAudioMap', 'ReplicatedStorage', 'ModuleScript'),
    ('CraxVeniRuntime', 'ServerScriptService', 'ModuleScript'),
    ('CraxVeniClient', 'StarterPlayer.StarterPlayerScripts', 'LocalScript'),
]:
    f = SRC / (name + ('.client.lua' if cls == 'LocalScript' else '.lua'))
    MODULES.append({'path': parent + '.' + name, 'className': cls, 'source': f.read_text()})

# ------------------------------------------------------------------ catalogues (enveloppes)
WRAPS = [
    ('ReplicatedStorage.CraxCatalog', """assert(not data.Crax_Veni,'VeniCrax déjà défini')
local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);local base=assert(data.Crax_Monster);local epic=assert(data.Crax_Ghosty)
data.Crax_Veni={DisplayName='VeniCrax',Rarity=epic.Rarity,RarityColor=epic.RarityColor,TemplateName=C.Id,MaxHealth=C.Health,CollisionDamage=C.Melee,Speed=base.Speed,
 Description='Le vrai Smillin\\'Crax sous un casque capuche de cobra : écailles vert foncé, crête crème, veines de venin néon et quatre crocs verts.',
 PowerDescription='MORSURE LENTE : après 3 collisions de mêlée avec la même cible, l’empoisonne : 2 PV par seconde pendant 5 secondes (10 dégâts).',
 Effects={'VeniPoison'},Ability={Id=C.AbilityId,DisplayName='MORSURE LENTE',Damage=C.BiteTick*C.BiteDuration,Cooldown=0}}"""),
    ('ReplicatedStorage.CraxSkillCatalog', """assert(not data.Crax_Veni)
local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);local prices=assert(data.Crax_Ghosty).Upgrades
local list={
 {Id='VeniRicochet',Name='COBRA RICOCHET',Description='Crache un cobra qui ricoche sur un mur avant de mordre : 5 dégâts à l’impact, puis 3 PV/s pendant 3 s (14 au total). Délai proposé : 7–10 s.'},
 {Id='VeniDistill',Name='DISTILLATION',Description='Après 5 pertes de PV causées par le poison, le prochain rebond contre un mur soigne VeniCrax de 8 PV. Recharge : 15 s.'},
 {Id='VeniMolt',Name='MUE TOXIQUE',Description='Laisse une mue translucide. Au contact d’un ennemi, un cercle apparaît puis, 0,7 s après, un nuage toxique applique Morsure lente. Délai proposé : 14–18 s.'},
 {Id='VeniFinale',Name=C.MaxTitle,Status=C.MaxTitle,TrophyId=C.TrophyId,Description='Exécution MAX sur une élimination par poison : un cobra vert ricoche sur un mur, s’enroule deux fois autour de la tête du vaincu, se resserre, des fissures vertes apparaissent et la figurine éclate en morceaux de vinyle.'}}
for i,u in ipairs(list)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Veni={Order=order+1,AbilityId=C.AbilityId,DisplayName='VeniCrax',Enabled=true,Upgrades=list,Finale=list[4]}"""),
    ('ReplicatedStorage.CraxEffectsCatalog', """data.VeniPoison={DisplayName='VENIN',Description='Perd des PV à chaque seconde (Morsure lente : 2 PV/s pendant 5 s ; Cobra : 3 PV/s pendant 3 s).',Duration=5,Image='',Color=Color3.fromRGB(150,255,40)}"""),
    ('ReplicatedStorage.CraxVictoryCatalog', """local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);data.Crax_Veni={Id='VeniFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(150,255,40),MinimumLevel=4,Duration=C.FinaleDuration,IntroDuration=0,ZoomDuration=0,HoldDuration=0}"""),
    ('ReplicatedStorage.CraxRouletteConfig', """local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local same,total={},0;for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Veni');if cat[e.Id]and cat[e.Id].Rarity==cat.Crax_Veni.Rarity then same[#same+1]=e;total+=e.Weight end end;assert(#same>0,'Aucun Crax épique dans le casino');local w=total/(#same+1);for _,e in ipairs(same)do e.Weight=w end;data.Pool[#data.Pool+1]={Id='Crax_Veni',Weight=total-w*#same} -- Masse Épique inchangée, répartition égale."""),
    ('ServerScriptService.CraxSkinServer', """local A=require(game:GetService('ReplicatedStorage').CraxVeniAppearance);local apply=data.Apply;function data.Apply(m,id,c)A.Restore(m);apply(m,id,c);if id=='Crax_Veni'then A.Apply(m,game:GetService('ReplicatedStorage').CraxVeniImportedAssets)end end"""),
]

REQ = "require(game:GetService('ServerScriptService'):WaitForChild('CraxVeniRuntime'))"
PATCHES = [
    ('ServerScriptService.ArenaMovement', f'local VeniV1={REQ}\n', [
        (' PolariV1.Begin(fighters)', ' PolariV1.Begin(fighters)\n VeniV1.Begin(fighters)'),
        ('  if PolariV1.Frozen()then break end',
         "  if PolariV1.Frozen()then break end\n  VeniV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not Killa.Fog()and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))"),
        ('PolariV1.WallContact(f.model,side);', 'PolariV1.WallContact(f.model,side);VeniV1.WallContact(f.model,side);'),
    ]),
    ('ServerScriptService.CombatHealth', f'local VeniV1={REQ}\n', [
        ('Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)',
         'Inverted.Confirm(attacker,defender,lost,attackerLost,collision);VeniV1.Confirm(attacker,defender,lost,attackerLost,collision,kind);report(attacker,defender,lost,kind)'),
    ]),
    ('ServerScriptService.RoundManager', '', [
        (' local enhanced=spec and(model:GetAttribute("CraxSkillLevel")or 0)>=spec.MinimumLevel',
         " local enhanced=spec and(model:GetAttribute(\"CraxSkillLevel\")or 0)>=spec.MinimumLevel\n -- VeniCrax : exécution MAX seulement sur une élimination par poison de cette manche.\n if enhanced and model:GetAttribute('CraxId')=='Crax_Veni'and(state:GetAttribute('VeniPoisonKillRound')~=state:GetAttribute('RoundId')or state:GetAttribute('VeniPoisonKillMatch')~=state:GetAttribute('CraxMatchToken'))then enhanced=false end"),
    ]),
    ('StarterPlayer.StarterPlayerScripts.ArenaCamera', '', [
        ("if state:GetAttribute('RoundVictoryKind')=='PolariFinale'",
         "if state:GetAttribute('RoundVictoryKind')=='VeniFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end\n if state:GetAttribute('RoundVictoryKind')=='PolariFinale'"),
        ('if player:GetAttribute("PolariCameraOwner")then',
         'if player:GetAttribute("VeniCameraOwner")then if defeat then clearDefeat()end;return end\n  if player:GetAttribute("PolariCameraOwner")then'),
    ]),
    ('StarterPlayer.StarterPlayerScripts.CopEmClient', """local function veniIconV1(parent,kind,x,y,size)
 local RSv=game:GetService('ReplicatedStorage');local C=require(RSv:WaitForChild('CraxVeniConfig'))
 local holder=Instance.new('Frame');holder.Size=UDim2.fromOffset(size,size);holder.Position=UDim2.fromOffset(x,y);holder.BackgroundTransparency=1;holder.ZIndex=4;holder.Parent=parent
 local key=({VeniBite='Bite',VeniRicochet='Cobra',VeniDistill='Distill',VeniMolt='Molt',VeniFinale='Max'})[kind]
 if key and C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=holder;return holder end
 if kind=='VeniFinale'then require(RSv:WaitForChild('CraxTrophyIcons')).Build(holder,true);return holder end
 local disc=Instance.new('Frame');disc.Size=UDim2.fromScale(1,1);disc.BackgroundColor3=Color3.fromRGB(16,70,28);disc.ZIndex=5;disc.Parent=holder
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.5,0);corner.Parent=disc
 local stroke=Instance.new('UIStroke');stroke.Color=Color3.fromRGB(150,255,40);stroke.Thickness=2;stroke.Parent=disc
 local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(.8,.8);t.Position=UDim2.fromScale(.1,.1);t.BackgroundTransparency=1;t.TextScaled=true;t.Font=Enum.Font.GothamBlack;t.TextColor3=Color3.fromRGB(150,255,40);t.ZIndex=6
 t.Text=({VeniBite='§',VeniRicochet='S',VeniDistill='+',VeniMolt='◌'})[kind]or'V';t.Parent=disc;return holder
end
""", [
        ("if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end",
         "if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end\n if type(kind)=='string'and kind:sub(1,4)=='Veni'then veniIconV1(parent,kind,x,y,size);return end"),
        ("if currentCrax=='Crax_Polari'then earned:ClearAllChildren()",
         "if currentCrax=='Crax_Veni'then earned:ClearAllChildren();veniIconV1(earned,'VeniFinale',0,0,88);name.Text=require(RS.CraxVeniConfig).MaxTitle end\n   if currentCrax=='Crax_Polari'then earned:ClearAllChildren()"),
        ('  -- PolariNomMaxCorrige',
         "  if currentCrax=='Crax_Veni'then local title=require(RS.CraxVeniConfig).MaxTitle;if owned and lv>=4 then status='MAX · '..title end;local caption=left:FindFirstChild('CraxTrophyCaption');if caption then caption.Text=title end end\n  -- PolariNomMaxCorrige"),
    ]),
    ('ReplicatedStorage.CraxBookCinema', '', [
        ("if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig)",
         "if id=='Crax_Veni'then local C=require(game:GetService('ReplicatedStorage').CraxVeniConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(150,255,40),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end\n if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig)"),
    ]),
]

OPS = [{'kind': 'wrap', 'path': p, 'addition': a} for p, a in WRAPS] + \
      [{'kind': 'patch', 'path': p, 'prepend': pre, 'replacements': [{'before': b, 'after': a} for b, a in reps]} for p, pre, reps in PATCHES]
(OUT / 'operations.json').write_text(json.dumps(OPS, ensure_ascii=False, indent=2) + '\n')

EXPECTED = ['V_HelmetShell', 'V_HelmetInner', 'V_HelmetCrest', 'V_HelmetBrow', 'V_VenomVeins', 'V_Fangs', 'V_FangsCore', 'V_VenomDrops', 'V_FitOrigin', 'V_FitUp', 'V_FitFront']
MANIFEST = json.loads((ROOT / 'assets/venicrax/model/manifest.json').read_text())
assert sorted(MANIFEST['accessories'] + MANIFEST['markers']) == sorted(EXPECTED), 'Le modèle exporté ne correspond plus à la liste attendue'

COMMON = r"""
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play (mode Édition), puis relancer cette commande')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local backupName='VeniCrax_Backup_V1'
"""

INSTALL = """-- VENICRAX · INSTALLATION. Studio, Play ARRÊTÉ, barre de commande.
-- Prérequis : importer assets/venicrax/model/VeniCrax_ACCESSOIRES_IMPORT.fbx (Import 3D), placer le modèle importé
-- dans ServerStorage et le renommer VeniCrax_Import. Rien n'est modifié si une vérification échoue.
do
""" + COMMON + 'local ops=' + lua(OPS) + '\nlocal modules=' + lua(MODULES) + '\nlocal expected=' + lua(EXPECTED) + r"""
local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('VeniOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde VeniCrax incomplète ou étrangère : lancer RETOUR_ARRIERE_VENICRAX.lua ou l’inspecter')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source modifiée après installation : '..e:GetAttribute('Path'))end
 print('VeniCrax déjà installé et vérifié : aucun doublon.');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ReplicatedStorage.CraxSilenceGate']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.CraxDeadlyRuntime']='ModuleScript',['ServerScriptService.CraxPolariRuntime']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do
 local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)
end
local plan={};local marker='-- VeniCraxIntegrationV1'
local function count(s,n)local total,p=0,1;while true do local a,b=s:find(n,p,true);if not a then return total end;total+=1;p=b+1 end end
for _,op in ipairs(ops)do
 local o=assert(resolve(op.path),'Source manquante : '..op.path);assert(o:IsA('LuaSourceContainer'),'Type de source incorrect : '..op.path)
 local before=read(o);assert(not before:find(marker,1,true),'Déjà modifié sans sauvegarde : '..op.path);local after=before
 if op.kind=='wrap'then after=marker..'\nlocal data=(function()\n'..before..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,r in ipairs(op.replacements)do assert(count(after,r.before)==1,'Source actuelle non reconnue : '..op.path..' (place différente de copie jeu mardi ?). Aucun fichier modifié.');local a,b=after:find(r.before,1,true);after=after:sub(1,a-1)..r.after..after:sub(b+1)end
  after=marker..'\n'..(op.prepend or'')..after
 end
 plan[#plan+1]={path=op.path,object=o,before=before,after=after}
end
for _,m in ipairs(modules)do assert(not resolve(m.path),'Nom déjà utilisé : '..m.path)end
for _,n in ipairs({'CraxVeniFX','CraxVeniImportedAssets','CraxVeniUserAssets'})do assert(not RS:FindFirstChild(n),'Nom déjà utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'),'ServerStorage.CraxTemplates absent');local base=assert(templates:FindFirstChild('Crax_Monster'),'Gabarit Crax_Monster absent');local previews=assert(RS:FindFirstChild('CraxPreviews'),'ReplicatedStorage.CraxPreviews absent')
assert(not templates:FindFirstChild('Crax_Veni')and not previews:FindFirstChild('Crax_Veni'),'Gabarit ou aperçu Crax_Veni déjà présent')
local imported=assert(SS:FindFirstChild('VeniCrax_Import'),'Importer VeniCrax_ACCESSOIRES_IMPORT.fbx, le placer dans ServerStorage et le renommer VeniCrax_Import.')
assert(imported:IsA('Model')or imported:IsA('Folder'),'VeniCrax_Import doit être un Model ou un Folder');local found={};local parts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans l’import')
 if p:IsA('BasePart')then assert(not found[p.Name],'Pièce en double : '..p.Name);found[p.Name]=p;parts+=1
  assert(p:IsA('MeshPart'),'MeshPart attendue : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)
 end
end
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante dans l’import : '..n)end
assert(parts==#expected,'Import avec des pièces en trop : vérifier VeniCrax_Import')
local c,f,u=found.V_FitOrigin.Position,found.V_FitFront.Position,found.V_FitUp.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères V_Fit invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('VeniOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('VeniOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxVeniFX';event.Parent=RS
 local user=register(Instance.new('Folder'));user.Name='CraxVeniUserAssets';user.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxVeniImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxVeniAppearance)
 local template=register(base:Clone());template.Name='Crax_Veni';appearance.Apply(template,assets);template:SetAttribute('AbilityId','VeniBite');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Veni';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('VeniRevision',1);backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : retour bloqué par une édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation VeniCrax arrêtée : '..tostring(err))
end
print('VeniCrax installé : 7 modules, 12 raccordements, gabarit et aperçu créés, sauvegarde ServerStorage.'..backupName..'. Enregistrer, puis lancer BRANCHER_SONS_ET_TEXTURES.lua avec tes IDs, puis un NOUVEAU Play.')
end
"""
(OUT / 'INSTALLER_VENICRAX.lua').write_text(INSTALL)

BRANCH = """-- VENICRAX · SONS, TEXTURES ET ICÔNES. Studio, Play ARRÊTÉ, après INSTALLER_VENICRAX.lua.
-- Remplace les zéros par tes IDs Roblox (laisser 0 pour ne rien changer), puis exécute dans la barre de commande.
local IDS={
 AudioAtlas=0,      -- VeniCrax_Audio_Atlas.wav (assets/venicrax/audio) importé comme Audio
 HelmetColor=0,     -- VeniCrax_Helmet_Color.png (assets/venicrax/model) importé comme Image
 HelmetNormal=0,    -- VeniCrax_Helmet_Normal.png
 Icon_Bite=0,Icon_Cobra=0,Icon_Distill=0,Icon_Molt=0,Icon_Max=0,  -- illustrations du livre (facultatif)
}
do
""" + COMMON + r"""
local backup=assert(SS:FindFirstChild(backupName),'Installer VeniCrax d’abord');assert(not backup:GetAttribute('Incomplete'),'Installation VeniCrax incomplète')
local user=assert(RS:FindFirstChild('CraxVeniUserAssets'));local assets=assert(RS:FindFirstChild('CraxVeniImportedAssets'))
local changed={}
for k,v in pairs(IDS)do if type(v)=='number'and v>0 then user:SetAttribute(k,'rbxassetid://'..math.floor(v));changed[#changed+1]=k end end
-- Texture d'écailles : SurfaceAppearance posé ici (ColorMap ne peut pas être écrit pendant le jeu).
local shell=assets:FindFirstChild('V_HelmetShell',true);local color=user:GetAttribute('HelmetColor')
if shell and color then
 local sa=shell:FindFirstChildWhichIsA('SurfaceAppearance')or Instance.new('SurfaceAppearance')
 sa.ColorMap=color;local normal=user:GetAttribute('HelmetNormal');if normal then sa.NormalMap=normal end;sa.Parent=shell
 local appearance=require(RS.CraxVeniAppearance)
 for _,m in ipairs({SS.CraxTemplates:FindFirstChild('Crax_Veni'),RS.CraxPreviews:FindFirstChild('Crax_Veni')})do if m then appearance.Apply(m,assets)end end
end
print('VeniCrax : '..(#changed>0 and table.concat(changed,', ')or'aucun ID')..' branché(s). Enregistrer puis NOUVEAU Play.')
end
"""
(OUT / 'BRANCHER_SONS_ET_TEXTURES.lua').write_text(BRANCH)

ROLLBACK = """-- VENICRAX · RETOUR ARRIÈRE. Studio, Play ARRÊTÉ. Restaure exactement les sources d'avant installation.
do
""" + COMMON + r"""
local backup=assert(SS:FindFirstChild(backupName),'Aucune sauvegarde VeniCrax');assert(backup:GetAttribute('VeniOwned'),'Sauvegarde étrangère')
local entries=backup.Entries:GetChildren();table.sort(entries,function(a,b)return tonumber(a.Name)>tonumber(b.Name)end)
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if o and e.Original.Value~=''then assert(read(o)==e.Installed.Value,'Source modifiée depuis l’installation : '..e:GetAttribute('Path')..'. Rien n’a été restauré.')end end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if o and e.Original.Value~=''then write(o,read(o),e.Original.Value)end end
for _,root in ipairs({game:GetService('ReplicatedStorage'),game:GetService('ServerScriptService'),game:GetService('StarterPlayer'),SS})do
 for _,o in ipairs(root:GetDescendants())do if o.Parent and o~=backup and o:GetAttribute('VeniOwned')then o:Destroy()end end
end
backup:Destroy();print('VeniCrax retiré, sources d’origine restaurées. Enregistrer puis NOUVEAU Play.')
end
"""
(OUT / 'RETOUR_ARRIERE_VENICRAX.lua').write_text(ROLLBACK)
print('VENI PACKAGE OK', len(OPS), 'opérations,', len(MODULES), 'modules')
