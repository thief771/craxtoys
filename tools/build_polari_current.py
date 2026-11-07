from pathlib import Path
import json
r=Path(__file__).resolve().parents[1]
def lua(v):
 if isinstance(v,str):
  eq='===='
  while ']'+eq+']' in v:eq+='='
  return '['+eq+'['+('\n' if v.startswith('\n')else '')+v+']'+eq+']'
 if isinstance(v,list):return'{'+','.join(lua(x)for x in v)+'}'
 if isinstance(v,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(x)for k,x in v.items())+'}'
 raise TypeError(type(v))
modules=[]
for p in sorted((r/'src/polaricrax').glob('*.lua')):
 name=p.name.removesuffix('.client.lua').removesuffix('.lua');parent='StarterPlayer.StarterPlayerScripts'if p.name.endswith('.client.lua')else('ServerScriptService'if name in ['CraxPolariRuntime','CraxPolariPause']else'ReplicatedStorage')
 source=p.read_text()
 # Keep the modern Bat lamp adapter in both the canonical and current variant.
 if name=='CraxPolariPause':source=source.replace("'CraxDeadlyRuntime'})","'CraxDeadlyRuntime','CraxBatRuntime'})");p.write_text(source)
 modules.append(dict(path=parent+'.'+name,className='LocalScript'if p.name.endswith('.client.lua')else'ModuleScript',source=source))
base=r/'integration/polaricrax/version-actuelle'
for m in modules:(base/'sources'/(m['path']+'.lua')).write_text(m['source'])
ops=json.loads((base/'operations.json').read_text())
replaces={"Aucun dégât.":"8 dégâts au contact du mur, une seule fois par activation.","Au contact du mur polarisé, avertissement rouge puis répulsion diagonale vers le centre et 12 dégâts. Un seul déclenchement par polarisation. Prototype : avertissement 0,25 s.":"Charge un des quatre murs au hasard pendant 1,5 s. Il reste actif 3 s : collision ennemie, 15 dégâts puis projection dans l’arène, une fois par cible et activation.","sans dégâts.":"avec 8 dégâts au premier contact du mur.","Prototype : délai 22–28 s.":"Première activation après 5–7 s actives, puis délai 22–28 s."}
for o in ops:
 if o['kind']=='wrap':
  for a,b in replaces.items():o['addition']=o['addition'].replace(a,b)
(base/'operations.json').write_text(json.dumps(ops,ensure_ascii=False,indent=2)+'\n')
p=base/'INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua';s=p.read_text();a=s.index('local ops=');b=s.index('local expected=');s=s[:a]+'local ops='+lua(ops)+'\nlocal modules='+lua(modules)+'\n'+s[b:];s=s.replace("backup:SetAttribute('PolariRevision',2);", "");s=s.replace("backup:SetAttribute('Incomplete',false)","backup:SetAttribute('PolariRevision',2);backup:SetAttribute('Incomplete',false)");p.write_text(s)
updates=[m for m in modules if m['path'].split('.')[-1]in['CraxPolariConfig','CraxPolariRules','CraxPolariRuntime','CraxPolariClient','CraxPolariVFX','CraxPolariPause']]
# Wrappers operate on the current sources, preserving all existing other characters.
wraps=[dict(path='ReplicatedStorage.CraxSkillCatalog',addition="""local levels=data.Crax_Polari.Upgrades
levels[1].Description='Polarise le mur le plus proche pendant 2 s et attire la cible. Premier contact : 8 dégâts, sans répétition pendant cette activation.'
levels[2].Description='Charge un des quatre murs au hasard pendant 1,5 s. Il reste actif 3 s. Une collision ennemie inflige 15 dégâts et projette dans l’arène, une fois par cible.'
levels[3].Description='Avertissement visible, arrêt du combat 1,2 s puis fenêtre d’esquive de 0,35 s et cinq éclats. 6 dégâts par éclat, trois touches maximum par cible : 18. Première activation après 5–7 s actives.'"""),dict(path='ReplicatedStorage.CraxEffectsCatalog',addition="data.PolariAttract.Description='Attire vers un mur pendant 2 s ; premier contact : 8 dégâts.'")]
p=r/'integration/polaricrax/v2/payload.json';p.write_text(json.dumps(dict(modules=updates,wraps=wraps),ensure_ascii=False,indent=2)+'\n')
header="""-- POLARICRAX V2 : appliquer dans le jeu ouvert, Play arrêté.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SS=game:GetService('ServerStorage');local SES=game:GetService('ScriptEditorService')
local function resolve(path)local o=game;for key in path:gmatch('[^.]+')do o=o and o:FindFirstChild(key)end;return o end
local backup=assert(SS:FindFirstChild('PolariCrax_Backup_V1'),'Installer PolariCrax avant cette mise à jour')
assert(backup:GetAttribute('PolariOwned')and not backup:GetAttribute('Incomplete'),'Sauvegarde Polari incomplète ou étrangère')
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Écriture non vérifiée')end
local entries=assert(backup:FindFirstChild('Entries'));local indexed={}
for _,e in ipairs(entries:GetChildren())do local path=e:GetAttribute('Path');assert(not indexed[path],'Entrée de sauvegarde dupliquée');indexed[path]=e end
for path,entry in pairs(indexed)do local o=assert(resolve(path),'Source supprimée : '..path);assert(read(o)==entry.Installed.Value,'Source éditée depuis installation : '..path..'. Aucun fichier modifié.')end
local motion=assert(resolve('ServerScriptService.ArenaMovement'));local motionSource=read(motion)
for _,hook in ipairs({'PolariV1.Pump(deltaTime,fighters)','PolariV1.Step(','PolariV1.WallContact('})do assert(motionSource:find(hook,1,true),'Raccordement moteur Polari absent : '..hook)end
"""
body="""
local revision=2
if backup:GetAttribute('PolariRevision')==revision then
 for _,m in ipairs(modules)do assert(read(assert(resolve(m.path)))==m.source,'Version V2 différente : '..m.path)end
 print('PolariCrax V2 déjà installé et vérifié');return
end
assert(not SS:FindFirstChild('PolariCrax_Update_V2_Safety'),'Mise à jour précédente à inspecter : PolariCrax_Update_V2_Safety')
local plan={}
for _,m in ipairs(modules)do
 local o=resolve(m.path);local entry=indexed[m.path]
 if o then assert(o:IsA(m.className)and entry,'Nom utilisé hors sauvegarde : '..m.path)
 else assert(m.path=='ReplicatedStorage.CraxPolariVFX'and not entry,'Source Polari requise manquante : '..m.path)end
 plan[#plan+1]={path=m.path,object=o,className=m.className,before=o and read(o)or'',after=m.source,entry=entry}
end
for _,item in ipairs(wraps)do local o=assert(resolve(item.path));assert(indexed[item.path],'Source non sauvegardée : '..item.path);local before=read(o)
 plan[#plan+1]={path=item.path,object=o,before=before,after='-- PolariCraxV2\nlocal data=(function()\n'..before..'\nend)()\n'..item.addition..'\nreturn data\n',entry=indexed[item.path]}
end
local safety=Instance.new('Folder');safety.Name='PolariCrax_Update_V2_Safety';safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true);safety.Parent=SS
for i,item in ipairs(plan)do local e=Instance.new('Folder');e.Name=tostring(i);e:SetAttribute('Path',item.path);for name,value in pairs({Original=item.before,Installed=item.after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=safety end
local attempted={};local added={}
local ok,err=pcall(function()
 for _,item in ipairs(plan)do
  if not item.object then local parent,name=item.path:match('^(.*)%.([^.]+)$');local o=Instance.new(item.className);o.Name=name;o:SetAttribute('PolariOwned',true);o.Parent=assert(resolve(parent));item.object=o;item.created=true;added[#added+1]=o end
  attempted[#attempted+1]=item;write(item.object,item.before,item.after)
 end
 for _,item in ipairs(plan)do
  if item.entry then item.entry.Installed.Value=item.after
  else local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',item.path);for name,value in pairs({Original='',Installed=item.after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=entries;item.newEntry=e end
 end
 backup:SetAttribute('PolariRevision',revision);safety:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#attempted,1,-1 do local item=attempted[i];local restored=pcall(function()local current=read(item.object);if current==item.after then write(item.object,item.after,item.before)else assert(current==item.before,'Édition concurrente')end end);if not restored then conflicts[#conflicts+1]=item.path end end
 if #conflicts==0 then
  for _,item in ipairs(plan)do if item.entry then item.entry.Installed.Value=item.before end;if item.newEntry then item.newEntry:Destroy()end end
  for _,o in ipairs(added)do o:Destroy()end;safety:Destroy()
 else warn('Sauvegarde conservée, conflit : '..table.concat(conflicts,', '));backup:SetAttribute('Incomplete',true)end
 error('Mise à jour arrêtée : '..tostring(err))
end
print('PolariCrax V2 installé : projectile VFX, attraction 8, mur aléatoire 15, temps suspendu. Enregistrer puis NOUVEAU Play pour recharger les modules.')
end
"""
# Python source literals above must encode the Lua concatenated newline escapes.
body=body.replace("after='-- PolariCraxV2\nlocal data=(function()\n'..before..'\nend)()\n'..item.addition..'\nreturn data\n'", "after='-- PolariCraxV2\\nlocal data=(function()\\n'..before..'\\nend)()\\n'..item.addition..'\\nreturn data\\n'")
(r/'integration/polaricrax/v2/METTRE_A_JOUR_POLARICRAX_V2.lua').write_text(header+'local modules='+lua(updates)+'\nlocal wraps='+lua(wraps)+'\n'+body)
