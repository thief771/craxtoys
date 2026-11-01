"""Build a guarded Studio installer against the inspected export, without altering that export."""
from pathlib import Path
import json,hashlib,sys
ROOT=Path(__file__).resolve().parents[1];SRC=ROOT/'src/invertedcrax';OUT=ROOT/'integration/invertedcrax';OUT.mkdir(parents=True,exist_ok=True)
REPORT=Path(sys.argv[1])if len(sys.argv)>1 else ROOT/'tests/fixtures/inspected-export.json'
D=json.loads(REPORT.read_text());entries=D['scripts'];patches={};audit=[]
def original(i):return entries[i]['source']
def save(i,s):
 s="\n".join(line.rstrip()for line in s.splitlines()).rstrip()+"\n"
 assert s!=original(i)
 path=entries[i]['path'];patches[path]=s
 p=OUT/'patched'/('/'.join(path.split('.'))+'.lua');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s)
def replace(s,a,b,n=1):
 assert s.count(a)==n,(a[:100],s.count(a),n)
 return s.replace(a,b)
def wrapper(i,extra):return 'local data=(function()\n'+original(i)+'\nend)()\n'+extra+'\nreturn data\n'
def gate(i,changes):
 s="local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))\n"+original(i)
 for before,after in changes:s=replace(s,before,after)
 save(i,s);audit.append({'path':entries[i]['path'],'guards':len(changes)})
save(0,wrapper(0,"""assert(not data.Crax_Inverted,'Crax_Inverted existe déjà')
local base=assert(data.Crax_Monster,'Base Crax Sourire absente')
data.Crax_Inverted={DisplayName='InvertedCrax',Rarity='Épique',RarityColor=Color3.fromRGB(192,116,255),TemplateName='Crax_Inverted',MaxHealth=120,Speed=assert(base.Speed),CollisionDamage=8,
Description='Un sourire noir, un silence blanc. Il pirate les directions, copie un impact et restaure un instant enregistré.',
PowerDescription='MUTE : toutes les 5 à 9 secondes actives, une onde de rayon égal à la moitié de la largeur de l’arène applique SILENCE pendant 5 secondes. Aucun dégât direct.',
Effects={'Silence'},Ability={Id='InvertedMute',DisplayName='MUTE',Damage=8,Cooldown=5}}"""))
save(7,wrapper(7,"""local reference=assert(data.Crax_Monster).Upgrades
local definitions={
 {Id='InvertedHack',Name='PIRATAGE',Description='MUTE conserve SILENCE (5 s). Change la direction des victimes chaque seconde pendant 4 s sans changer leur vitesse. Elles reçoivent 10 % de dégâts en plus pendant 5 s, sans cumul.'},
 {Id='InvertedCopy',Name='COPIER-COLLER',Description='Au troisième impact de mêlée ayant retiré des PV, mémorise les dégâts réellement subis sur ce troisième coup. La prochaine mêlée efficace remplace ses 8 dégâts par max(8, copie), puis consomme la copie. Les pouvoirs ne comptent pas.'},
 {Id='InvertedRewind',Name='CTRL-Z',Description='Une fois par round : enregistre position et PV à 10 s de combat actif ; à 20 s, restaure exactement ces valeurs. Mort et fin de round annulent la balise. SILENCE à la pose fait perdre cette occasion ; une balise déjà posée continue.'},
 {Id='Inverted404',Name='ERREUR 404',Description='Cinématique de victoire MAX : le vaincu se fragmente dans une immense croix. 404 — CRAX NOT FOUND. Aucun pouvoir, dégât ou trophée supplémentaire.'}}
for i,u in ipairs(definitions)do local p=assert(reference[i]);u.Coins=assert(p.Coins);u.Gems=assert(p.Gems);u.Status=u.Name end
data.Crax_Inverted={Order=9,AbilityId='InvertedMute',DisplayName='InvertedCrax',Enabled=true,Upgrades=definitions,Finale=definitions[4]}"""))
save(4,wrapper(4,"""local config=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedConfig'))
data.Silence={DisplayName='SILENCE',Description='Bloque les nouveaux déclenchements pendant 5 secondes. Ne bloque ni mêlée ni déplacement ; les capacités déjà lancées continuent.',Image=config.SilenceIcon,Icon='Silence',Color=Color3.fromRGB(244,242,232),Duration=5}"""))
save(3,wrapper(3,"""local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local epic={};local total=0
for _,entry in ipairs(data.Pool)do
 assert(entry.Id~='Crax_Inverted','Entrée casino déjà installée')
 local d=catalog[entry.Id]
 if d and(d.Rarity=='Épique'or d.Rarity=='Epique')then epic[#epic+1]=entry;total=total+entry.Weight end
end
assert(#epic>0 and total>0,'Masse épique absente')
local share=total/(#epic+1)
for _,entry in ipairs(epic)do entry.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Inverted',Weight=total-share*#epic}
assert(data.DuplicateGems['Épique']~=nil,'Compensation épique absente')"""))
save(50,wrapper(50,"""data.Crax_Inverted={Id='Inverted404',DisplayName='ERREUR 404',MinimumLevel=4,IntroDuration=0,Duration=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedConfig')).FinaleDuration,ZoomDuration=0,HoldDuration=0,Description='404 — CRAX NOT FOUND. Cinématique de victoire uniquement.'}"""))
save(166,wrapper(166,"""local palette=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedPalette'))
local apply=data.Apply
function data.Apply(model,id,config)
 palette.Restore(model)
 apply(model,id,config)
 if id=='Crax_Inverted'then palette.Apply(model)end
end"""))
# Book: keep its purchasing callbacks and the normal cinema; add explicit monochrome icons.
s=original(251)
a='local function emblem(parent,kind,color,x,y,size)'
s=replace(s,a,a+"""
 if type(kind)=='string'and kind:sub(1,8)=='Inverted'then
  local symbols={InvertedHack='HACK',InvertedCopy='COPY',InvertedRewind='CTRL-Z',Inverted404='404'}
  local f=make('Frame',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(size,size),BackgroundColor3=Color3.fromRGB(13,15,20),BorderSizePixel=0},parent);round(f,math.max(8,size*.2))
  make('UIStroke',{Color=Color3.fromRGB(240,238,228),Thickness=2},f)
  make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=symbols[kind]or'×',Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.fromRGB(245,242,232)},f)
  return
 end""")
s=replace(s,'if lv>=4 and TrophyIcons then','if currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then')
s=replace(s,'    if i==4 then\n     local holder=', '    if i==4 and currentCrax=="Crax_Inverted"then\n     if revealed then emblem(node,upgrade.Id,metal,3,3,56)else local hidden=text(node,"?",0,0,62,62,35,C.muted);hidden.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 then\n     local holder=')
save(251,s)
s=original(16)
s=replace(s,' self.trophyArt:ClearAllChildren()',""" self.trophyArt:ClearAllChildren()
 if id=='Crax_Inverted'then
  make('TextLabel',{Size=UDim2.fromScale(1,1),Text='404',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(244,242,232),BackgroundTransparency=1,ZIndex=113},self.trophyArt)
  self.trophyIcon.TrophyTitle.Text='ERREUR 404';return
 end""")
save(16,s)
# Server integration in the existing movement loop and internal health table.
s=original(114)
s="local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))\nlocal InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))\n"+s
s=replace(s,'local function launch()','local function launch()\n Inverted.Begin(fighters)')
s=replace(s,'local frozen = Deadly.Flash()','local frozen = Deadly.Flash()\n  Inverted.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute(\'GhostNightActive\')and workspace:GetServerTimeNow()>=(state:GetAttribute(\'GhostFreezeUntil\')or 0))')
s=replace(s,'if clock >= f.nextWeb then','if clock >= f.nextWeb and InvertedSilence.CanStart(f.model)then')
s=replace(s,'local function shoot(f, enemy,red)','local function shoot(f, enemy,red)\n if not InvertedSilence.CanStart(f.model)then return end')
# Followup is a new volley; processing shots/charges already present is intentionally not gated.
s=replace(s,'local function followup(f)','local function followup(f)\n if not InvertedSilence.CanStart(f.model)then return false end')
s=replace(s,'if not pending or pending.target~=b', 'if not InvertedSilence.CanStart(attacker)or not pending or pending.target~=b')
save(114,s);audit.append({'path':entries[114]['path'],'guards':4})
s=original(148);s="local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))\n"+s
s=replace(s,"local function report(a,b,lost,kind)","""Inverted.SetHealth=function(model,hp,round)
 local r=states[model]
 if r and r.health>0 and model.Parent and state:GetAttribute('Phase')=='Fighting'and state:GetAttribute('RoundId')==round then r.health=hp;update(model);return true end
 return false
end
local function report(a,b,lost,kind)""")
s=replace(s,"then return Fleau.FlatProtect(model,amount)end","then return Inverted.Vulnerable(model,Fleau.FlatProtect(model,amount))end")
s=replace(s,'return Deadly.AdjustDamage(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind))','return Deadly.AdjustDamage(model,Inverted.Vulnerable(model,Mod.Apply(model,Fleau.FlatProtect(model,amount),kind)))')
s=replace(s,'amount=Golden.Outgoing(attacker,amount)','if collision then amount=Inverted.Melee(attacker,amount)end\n amount=Golden.Outgoing(attacker,amount)')
s=replace(s,'amount=adjust(defender,math.floor(amount+.5),kind)',"amount=Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)")
s=replace(s,"if collision then recoil,fleauRecoilMode=Fleau.Contact(defender,recoil)end", "if collision then recoil=Inverted.Melee(defender,recoil);recoil,fleauRecoilMode=Fleau.Contact(defender,recoil)end")
s=replace(s,"adjust(attacker,Golden.Outgoing(defender,math.floor(recoil+.5)),'Collision')", "Inverted.Final(attacker,adjust(attacker,Golden.Outgoing(defender,Inverted.RawInput(defender,attacker,recoil)),'Collision'),defender)")
s=replace(s,'update(attacker);update(defender);report(attacker,defender,lost,kind)','update(attacker);update(defender);Inverted.Confirm(attacker,defender,lost,attackerLost,collision);report(attacker,defender,lost,kind)')
save(148,s)
# New activation guards. Do not gate simulation functions, old projectiles, ongoing statuses or melee.
gate(115,[('and f.clock >= cooldown then','and f.clock >= cooldown and InvertedSilence.CanStart(f.model)then')])
gate(126,[('function Night.TryEscape(model,enemy)','function Night.TryEscape(model,enemy)\n if not InvertedSilence.CanStart(model)then return false end'),('if knifeTimers[f.model]>=3 then','if knifeTimers[f.model]>=3 and InvertedSilence.CanStart(f.model)then'),('if not Gate.Paused(f.model) and due<=clock then','if not Gate.Paused(f.model) and InvertedSilence.CanStart(f.model)and due<=clock then')])
gate(132,[('local function spawn(f,now)','local function spawn(f,now)\n if not InvertedSilence.CanStart(f.model)then return end')])
# Fantastic scheduler: a trigger switch does not pause ongoing heals/torch/hand/reinforcement.
s=original(135);s=replace(s,'function M.Step(r,dt,externalBusy,roundElapsed)','function M.Step(r,dt,externalBusy,roundElapsed,canStart)\n canStart=canStart~=false')
s=replace(s,'if r.invisiblePending and r.reinforce==0','if canStart and r.invisiblePending and r.reinforce==0')
s=replace(s,'if r.reinforce==0 and r.reinforceWait==0 then','if canStart and r.reinforce==0 and r.reinforceWait==0 then')
s=replace(s,'if r.torch==0 and r.torchPending>0 then','if canStart and r.torch==0 and r.torchPending>0 then')
s=replace(s,'if r.level>=3 and not r.elastic','if canStart and r.level>=3 and not r.elastic')
save(135,s)
gate(137,[('workspace:GetServerTimeNow()-started)','workspace:GetServerTimeNow()-started,InvertedSilence.CanStart(f.model))')])
gate(156,[('function M.Wall(f,side)','function M.Wall(f,side)\n if not InvertedSilence.CanStart(f.model)then return end'),('if enabled and allowed(f)and not r.transit then','if enabled and allowed(f)and InvertedSilence.CanStart(model)and not r.transit then')])
gate(158,[('local function spawnPlant(f,r,network)','local function spawnPlant(f,r,network)\n if not InvertedSilence.CanStart(f.model)then return false end'),('local function spawnStar(f,r,network)','local function spawnStar(f,r,network)\n if not InvertedSilence.CanStart(f.model)then return end')])
gate(162,[('if not r.Charge and r.Time>=r.NextPunch then','if InvertedSilence.CanStart(f.model)and not r.Charge and r.Time>=r.NextPunch then'),('if enabled and lv>=2 and r.Time>=r.NextIngot','if InvertedSilence.CanStart(f.model)and enabled and lv>=2 and r.Time>=r.NextIngot'),('if cascadeAllowed and enabled and not r.Cascade then','if InvertedSilence.CanStart(f.model)and cascadeAllowed and enabled and not r.Cascade then'),('if enabled and r.Time>=r.Next and #r.Pools<2 then','if InvertedSilence.CanStart(f.model)and enabled and r.Time>=r.Next and #r.Pools<2 then')])
# Fléau active modes finish; only new rolls, threshold windups and lethal activation are inhibited.
s=original(54);s=replace(s,'function R.Tick(s,dt,roll)','function R.Tick(s,dt,roll,canStart)\n canStart=canStart~=false')
s=replace(s,'if s.level>=2 and not s.giantUsed then','if canStart and s.level>=2 and not s.giantUsed then')
s=replace(s,"if s.mode=='Normal'and #s.queue>0 then","if canStart and s.mode=='Normal'and #s.queue>0 then")
save(54,s)
gate(164,[('if not Rules.Lethal(s)then return false end','if not InvertedSilence.CanStart(m)or not Rules.Lethal(s)then return false end'),('Rules.Tick(s,tick,function()return random:NextNumber()end)','Rules.Tick(s,tick,function()return random:NextNumber()end,InvertedSilence.CanStart(m))')])
gate(149,[
 ("if n.name=='Vice'then\n  local og=n.family.og","if n.name=='Vice'and not n.model:GetAttribute('InvertedHacked')then\n  local og=n.family.og"),
 ('local function spawn(f,name)','local function spawn(f,name)\n if not InvertedSilence.CanStart(f.og.model)then return false end'),
 ('local function fusionWarning(f)','local function fusionWarning(f)\n if not InvertedSilence.CanStart(f.og.model)then return end'),
 # beginFusion is the completion of a warning that has already started: leave it running.
 ('elseif n.t>=n.nextPulsar then','elseif InvertedSilence.CanStart(n.model)and n.t>=n.nextPulsar then'),
 ('local function beginAssimilation(n,a)','local function beginAssimilation(n,a)\n if not InvertedSilence.CanStart(n.model)then return end'),
 ('if n.t>=n.nextGrid then','if InvertedSilence.CanStart(n.model)and n.t>=n.nextGrid then'),
 ('if not n.portals and n.t>=n.nextPortal then','if InvertedSilence.CanStart(n.model)and not n.portals and n.t>=n.nextPortal then'),
 ("if n.name=='Domino'then\n     n.stunTargets", "if n.name=='Domino'and InvertedSilence.CanStart(n.model)then\n     n.stunTargets"),
 ("if opposing and opposing.name=='Domino'then opposing.stunTargets", "if opposing and opposing.name=='Domino'and InvertedSilence.CanStart(opposing.model)then opposing.stunTargets"),
 ('if alive(vice)and not Gate.Paused(vice.model)and vice.t>=vice.nextHeal then','if alive(vice)and InvertedSilence.CanStart(vice.model)and not Gate.Paused(vice.model)and vice.t>=vice.nextHeal then'),
])
# Output the complete reviewed patched sources, original digests, and guard inventory.
manifest=[]
for path,source in patches.items():
 old=next(e['source']for e in entries if e['path']==path)
 h=5381
 for b in old.encode():h=(h*33+b)%4294967296
 manifest.append({'path':path,'originalBytes':len(old.encode()),'originalHash':h,'originalSha256':hashlib.sha256(old.encode()).hexdigest(),'patchedSha256':hashlib.sha256(source.encode()).hexdigest()})
(OUT/'patch-manifest.json').write_text(json.dumps(manifest,indent=2));(OUT/'silence-audit.json').write_text(json.dumps(audit,indent=2))
# Installer generation below is deliberately separate from implementation patches.
def long(s):
 equals='===='
 while ']'+equals+']'in s:equals+='='
 return '['+equals+'['+s+']'+equals+']'
newModules=[]
for f in sorted(SRC.glob('*.lua')):
 name=f.name.removesuffix('.client.lua').removesuffix('.lua')
 service='StarterPlayer.StarterPlayerScripts'if f.name.endswith('.client.lua')else('ServerScriptService'if name=='CraxInvertedRuntime'else'ReplicatedStorage')
 newModules.append({'path':service+'.'+name,'class':'LocalScript'if f.name.endswith('.client.lua')else'ModuleScript','source':f.read_text()})
# Pack module sources and source checks into a single command-bar installer.
records=[]
for m in manifest:records.append('{path='+long(m['path'])+',bytes='+str(m['originalBytes'])+',hash='+str(m['originalHash'])+',source='+long(patches[m['path']])+'}')
modules=['{path='+long(m['path'])+',class='+long(m['class'])+',source='+long(m['source'])+'}'for m in newModules]
header="""-- INVERTEDCRAX V1 : UNE commande, Play ARRÊTÉ. Aucun reset de profil.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play avant installation.')
local function resolve(path)
 local current=game;for token in path:gmatch('[^.]+')do current=current and current:FindFirstChild(token)end;return current
end
local function hash(source)local n=5381;for i=1,#source do n=(n*33+source:byte(i))%4294967296 end;return n end
local storage=game:GetService('ServerStorage');local RS=game:GetService('ReplicatedStorage')
local backupName='InvertedCrax_Integration_Backup_V1'
"""
body="local patches={\n"+',\n'.join(records)+'\n}\nlocal modules={\n'+',\n'.join(modules)+'\n}\n'
footer="""
local previous=storage:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('InvertedOwned')==true,'Sauvegarde de même nom non reconnue.')
 for _,r in ipairs(patches)do local o=resolve(r.path);assert(o and o.Source==r.source,'Installation existante modifiée : aucune mise à jour automatique.')end
 for _,r in ipairs(modules)do local o=resolve(r.path);assert(o and o.Source==r.source,'Module existant modifié : aucune mise à jour automatique.')end
 print('InvertedCrax déjà installé, aucun doublon.');return
end
for _,r in ipairs(patches)do
 local o=resolve(r.path);assert(o and o:IsA('LuaSourceContainer'),'Source absente : '..r.path)
 local s=o.Source;assert(#s==r.bytes and hash(s)==r.hash,'Source différente de l’export analysé : '..r.path..'. Aucun fichier modifié ; fournir le script actuel.')
end
for _,r in ipairs(modules)do assert(not resolve(r.path),'Nom déjà utilisé : '..r.path)end
assert(not RS:FindFirstChild('CraxInvertedFX'),'Remote déjà présent et non reconnu.')
local templates=assert(storage:FindFirstChild('CraxTemplates'),'CraxTemplates absent')
local base=assert(templates:FindFirstChild('Crax_Monster'),'Base Crax Sourire absente')
assert(not templates:FindFirstChild('Crax_Inverted'),'Template Inverted déjà présent')
local previews=assert(RS:FindFirstChild('CraxPreviews'),'CraxPreviews absent')
assert(not previews:FindFirstChild('Crax_Inverted'),'Aperçu Inverted déjà présent')
assert(resolve('Workspace.Arenaleft')and resolve('Workspace.ArenaRight'),'Murs canoniques absents')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('InvertedOwned',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(object)created[#created+1]=object;return object end
local function entry(path,original,installed)
 local item=Instance.new('Folder');item.Name=tostring(#entries:GetChildren()+1);item:SetAttribute('Path',path)
 local a=Instance.new('StringValue');a.Name='Original';a.Value=original;a.Parent=item
 local b=Instance.new('StringValue');b.Name='Installed';b.Value=installed;b.Parent=item;item.Parent=entries
end
local ok,err=pcall(function()
 for _,r in ipairs(modules)do
  local parentPath,name=r.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(r.class));o.Name=name;o.Source=r.source;o:SetAttribute('InvertedOwned',true);o.Parent=assert(resolve(parentPath))
  entry(r.path,'',r.source)
 end
 local fx=register(Instance.new('RemoteEvent'));fx.Name='CraxInvertedFX';fx:SetAttribute('InvertedOwned',true);fx.Parent=RS
 local palette=require(RS.CraxInvertedPalette)
 local model=register(assert(base:Clone()));model.Name='Crax_Inverted';palette.Apply(model);model:SetAttribute('InvertedOwned',true);model:SetAttribute('AbilityId','InvertedMute');model.Parent=templates
 local preview=register(assert(model:Clone()));preview:SetAttribute('InvertedOwned',true);preview.Parent=previews
 -- The native curved X is retained. No invented MeshId or mandatory import is needed.
 for _,r in ipairs(patches)do
  local o=resolve(r.path);entry(r.path,o.Source,r.source);changed[#changed+1]={o=o,source=o.Source};o.Source=r.source
 end
 backup.Parent=storage
end)
if not ok then
 for i=#changed,1,-1 do pcall(function()changed[i].o.Source=changed[i].source end)end
 for i=#created,1,-1 do pcall(function()created[i]:Destroy()end)end
 backup:Destroy();error('Installation annulée, sources restaurées : '..tostring(err))
end
print('InvertedCrax installé : tête native préservée, livre, casino, serveur et client ajoutés.')
warn('Les sons et l’icône sont configurables dans ReplicatedStorage.CraxInvertedConfig. Les IDs vides ne bloquent pas le gameplay. TESTER À DEUX CLIENTS AVANT PUBLICATION.')
end
"""
(OUT/'INSTALLER_INVERTEDCRAX.lua').write_text(header+body+footer)
(OUT/'RETOUR_ARRIERE.lua').write_text("""-- UNE commande, Play arrêté. Refuse de perdre une modification ultérieure.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play.')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local storage=game:GetService('ServerStorage');local backup=assert(storage:FindFirstChild('InvertedCrax_Integration_Backup_V1'),'Sauvegarde absente')
assert(backup:GetAttribute('InvertedOwned')==true,'Sauvegarde non reconnue')
local entries=backup.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and o.Source==e.Installed.Value,'Source modifiée depuis installation : '..e:GetAttribute('Path')..'. Aucun écrasement.')end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if e.Original.Value~=''then o.Source=e.Original.Value end end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxInvertedFX','ReplicatedStorage.CraxPreviews.Crax_Inverted','ServerStorage.CraxTemplates.Crax_Inverted'})do local o=resolve(path);if o and o:GetAttribute('InvertedOwned')then o:Destroy()end end
backup:Destroy();print('Intégration InvertedCrax retirée. Les profils et possessions sauvegardés ne sont pas effacés ; conserver les données pour réinstallation.')
end
""")
print('Built',len(patches),'patched sources,',len(newModules),'new sources; installer bytes',len((OUT/'INSTALLER_INVERTEDCRAX.lua').read_bytes()))
