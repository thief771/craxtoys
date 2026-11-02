"""Build SuperCrax using targeted operations on LIVE Studio sources, never old replacements."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parents[1];SRC=ROOT/'src/supercrax';OUT=ROOT/'integration/supercrax';OUT.mkdir(parents=True,exist_ok=True)
operations=[]
def wrap(path,addition):operations.append({'path':path,'kind':'wrap','addition':addition})
def patch(path,replacements,prepend=''):
 operations.append({'path':path,'kind':'patch','prepend':prepend,'replacements':[item if isinstance(item,dict)else{'before':item[0],'after':item[1]}for item in replacements]})
RS='ReplicatedStorage.';SSS='ServerScriptService.'
wrap(RS+'CraxCatalog',"""assert(not data.Crax_Super,'SuperCrax existe déjà dans le catalogue')
local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
local base=assert(data.Crax_Monster,'CraxSourire réel absent')
data.Crax_Super={DisplayName='SuperCrax',Rarity='Commun',TemplateName='Crax_Super',MaxHealth=C.Health,Speed=assert(base.Speed),CollisionDamage=C.Melee,
 Description='Le vrai sourire Craxtoys, une boucle héroïque et une volonté d’acier.',
 PowerDescription='Dash circulaire : trois tours en 1,5 seconde, Homme d’acier durant l’activation et 16 dégâts par ennemi et par tour. Délai serveur de 8 à 12 secondes actives.',
 Effects={'SuperSteel','SuperFreeze','SuperKryptonite'},Ability={Id=C.AbilityId,DisplayName='Dash circulaire',Damage=C.Melee,Cooldown=C.DashWait[1]}}""")
wrap(RS+'CraxSkillCatalog',"""assert(not data.Crax_Super,'SuperCrax existe déjà dans le livre')
local reference=assert(data.Crax_Monster).Upgrades
local upgrades={
 {Id='SuperLaser',Name='RAYON LASER',Description='Deux rayons rouges aux directions aléatoires indépendantes, pendant 2,5 s. Au maximum 15 PV/s par victime, même si les deux rayons touchent : 37,5 dégâts de base pour une exposition complète. Délai de 5 à 8 s actives après la fin.'},
 {Id='SuperFrost',Name='SOUFFLE GELÉ',Description='Après trois mêlées efficaces : canalisation mobile de 2 s, puis souffle de 3,5 s vers le coin le plus éloigné de l’arène. Gel entretenu jusqu’à 5 s après la dernière exposition. Une nouvelle mêlée de SuperCrax brise ce gel pour 35 dégâts au total, sans regel par ce même souffle.'},
 {Id='SuperInvincible',Name="L’INVINCIBLE SUPERCRAX",Description='Un dégât ordinaire mortel est intercepté avant la mort : maintien strict à 1 PV, aucun soin et protection ordinaire pour le reste du round. Les pouvoirs restent actifs. Une kryptonite liée au héros apparaît : le toucher tue le héros, même en acier. Un ennemi peut la porter pour +50 % de vitesse.'},
 {Id='SuperFinale',Name='EXÉCUTION MAX',Description='À chaque victoire de SuperCrax MAX : vol près du vaincu, congélation complète, charge rouge des yeux de 1,5 s, lasers puis éclatement de la victime et de la glace. Aucun dégât ni récompense supplémentaire.'}}
for i,u in ipairs(upgrades)do local p=assert(reference[i]);u.Coins=assert(p.Coins);u.Gems=assert(p.Gems);u.Status=u.Name end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Super={Order=order+1,AbilityId='SuperHero',DisplayName='SuperCrax',Enabled=true,Upgrades=upgrades,Finale=upgrades[4]}""")
wrap(RS+'CraxEffectsCatalog',"""data.SuperSteel={DisplayName="HOMME D’ACIER",Description='Invulnérable aux dégâts ordinaires pendant les 1,5 s du dash. La kryptonite du héros reste mortelle.',Icon='Steel',Image='',Color=Color3.fromRGB(177,205,223),Duration=1.5}
data.SuperFreeze={DisplayName='GEL',Description='Immobilisé. Durée de 5 s rafraîchie sous le souffle. Une mêlée du SuperCrax poseur brise sa glace pour 35 dégâts au total, sans cumul de vulnérabilité générale.',Icon='Ice',Image='',Color=Color3.fromRGB(154,235,255),Duration=5}
data.SuperKryptonite={DisplayName='KRYPTONITE',Description='Cristal lié à un SuperCrax invincible. Le porteur gagne 50 % de vitesse sans cumul ; toucher le héros concerné le tue immédiatement.',Icon='Crystal',Image='',Color=Color3.fromRGB(78,239,82)}""")
wrap(RS+'CraxRouletteConfig',"""local catalog=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxCatalog'))
local common,total={},0
for _,e in ipairs(data.Pool)do
 assert(e.Id~='Crax_Super','SuperCrax déjà présent dans le tirage')
 if catalog[e.Id]and catalog[e.Id].Rarity=='Commun'then common[#common+1]=e;total=total+e.Weight end
end
assert(#common>0 and total>0,'Groupe Commun absent')
local share=total/(#common+1);for _,e in ipairs(common)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Super',Weight=total-share*#common}
assert(data.DuplicateGems.Commun~=nil,'Compensation des doublons Commune absente')""")
wrap(RS+'CraxVictoryCatalog',"""local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
data.Crax_Super={Id='SuperFinale',DisplayName='EXÉCUTION MAX',MinimumLevel=4,IntroDuration=0,Duration=C.Finale.ReturnEnd,ZoomDuration=0,HoldDuration=0,Description='Gel, charge laser de 1,5 s, puis éclatement du vaincu. Présentation de victoire uniquement.'}""")
wrap(SSS+'CraxSkinServer',"""local appearance=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperAppearance'))
local apply=data.Apply
function data.Apply(model,id,config)
 appearance.Restore(model);apply(model,id,config)
 if id=='Crax_Super'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSuperImportedAssets'),'Importer les accessoires de SuperCrax'))end
end""")
prefix="local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))\n"
patch(SSS+'ArenaMovement',[
 ('local function launch()','local function launch()\n SuperCraxV1.Begin(fighters)'),
 ('Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)',"SuperCraxV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))\n  alive=alive and state:GetAttribute('Phase')=='Fighting'\n  Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)"),
 ("if alive and not frozen and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))", "if alive and not frozen and not SuperCraxV1.Held(f.model)and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))"),
 ('f.velocity * Plumber.Speed(f)', 'f.velocity * SuperCraxV1.Speed(f.model) * Plumber.Speed(f)'),
 ('f.velocity.Magnitude*Plumber.Speed(f)', 'f.velocity.Magnitude*SuperCraxV1.Speed(f.model)*Plumber.Speed(f)'),
 ('elseif distance < radius and not Plumber.Hold(a.model)', 'elseif distance < radius and not SuperCraxV1.SuppressNormalContact(a.model,b.model)and not Plumber.Hold(a.model)'),
],prefix)
# The original pause/position-lock system becomes reason-scoped so ice cannot release another lock.
patch(SSS+'CraxPositionLock',[
 ('function M.Lock(f)\n if records[f.model]then return end', "function M.Lock(f,reason)\n reason=reason or 'Fantastic'\n if records[f.model]then records[f.model].reasons[reason]=true;return end"),
 ('restoring=false}', 'restoring=false,reasons={[reason]=true}}'),
 ('function M.Unlock(f)\n local r=records[f.model];if not r then return end', "function M.Unlock(f,reason)\n local r=records[f.model];if not r then return end\n r.reasons[reason or 'Fantastic']=nil;if next(r.reasons)then return end"),
])
# Late-bound bridge: Deadly is a dependency of SuperRuntime; no circular require at module load.
bridge="local _superBridge\nlocal function SuperCraxBridgeV1()if not _superBridge then _superBridge=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))end;return _superBridge end\n"
patch(SSS+'CraxDeadlyRuntime',[
 ("speed=speed*M.Slow(n.model)","speed=speed*SuperCraxBridgeV1().Speed(n.model)*M.Slow(n.model)"),
 ('local budget=math.max(0,dt)*100*math.max(0,slow)','local budget=math.max(0,dt)*100*SuperCraxBridgeV1().Speed(n.model)*math.max(0,slow)'),
 # A carrier Vice receives the same modifier on its existing orbital advance, never a new loop.
 ('+dt*2.8', '+dt*2.8*SuperCraxBridgeV1().Speed(n.model)'),
],bridge)
patch(SSS+'FleauRuntime',[
 ("local from=f.position;local step=math.min(d.Magnitude,speed*dt)","speed=speed*SuperCraxBridgeV1().Speed(m)\n     local from=f.position;local step=math.min(d.Magnitude,speed*dt)")
],bridge)
# CombatHealth is patched at the existing authority boundary; never a second damage system.
health=[
 ('local function report(a,b,lost,kind)','local function report(a,b,lost,kind)\n SuperCraxV1.PowerResult(a,b,lost,kind)'),
 ('local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end', 'local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end\n if SuperCraxV1.TryCrystalContact(attacker,defender)then return end'),
 ('if amount==nil then amount=attacker:GetAttribute(\'BiteDamage\')or 0 end', "if amount==nil then amount=attacker:GetAttribute('BiteDamage')or 0 end\n if collision then amount=SuperCraxV1.ContactDamage(attacker,defender,amount)end"),
 ('local fleauRecoilMode','if collision then recoil=SuperCraxV1.ContactDamage(defender,attacker,recoil)end\n local fleauRecoilMode'),
 ('local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)', "amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)\n if collision then incoming=SuperCraxV1.Incoming(attacker,incoming,a.health,defender,'Collision')end\n local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)"),
 ('update(attacker);update(defender);', 'update(attacker);update(defender);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);'),
 ('if not Fleau.HealAllowed(model)then return end','if not Fleau.HealAllowed(model)then return end\n amount=SuperCraxV1.AllowHeal(model,amount);if amount<=0 then return end'),
 ("state:SetAttribute('HealthReady',true)","""SuperCraxV1.KillHealthBatch=function(requests,expectedRound,expectedMatch)
 if #requests==0 or state:GetAttribute('Phase')~='Fighting'or state:GetAttribute('RoundId')~=expectedRound or state:GetAttribute('CraxMatchToken')~=expectedMatch then return false end
 local unique={}
 for _,request in ipairs(requests)do
  local model=request.model;local r=states[model]
  if unique[model]or not r or r.health<=0 or not SuperCraxV1.ValidateCrystalKill(model,request.carrier,expectedRound,expectedMatch,request.token)then return false end
  unique[model]=true
 end
 for _,request in ipairs(requests)do local model=request.model;local r=states[model];local loss=r.health;r.health=0;update(model);if request.carrier then report(request.carrier,model,loss,'SuperKryptonite')end end
 finish();return true
end
state:SetAttribute('HealthReady',true)"""),
]
# These alternatives preserve the Inverted precision path if it is present; no old source is restored.
health.append({'variants':[
 {'before':'amount=Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)','after':"amount=kind=='SuperLaser'and adjust(defender,amount,kind)or Inverted.Final(defender,adjust(defender,Inverted.RawInput(attacker,defender,amount),kind),attacker)"},
 {'before':'amount=adjust(defender,math.floor(amount+.5),kind)','after':"amount=kind=='SuperLaser'and adjust(defender,amount,kind)or adjust(defender,math.floor(amount+.5),kind)"}
]})
operations.append({'path':SSS+'CombatHealth','kind':'patch','prepend':prefix,'replacements':[item if isinstance(item,dict)else{'before':item[0],'after':item[1]}for item in health]})
patch(SSS+'RoundManager',[
 ('state:SetAttribute("RoundVictoryStartedAt",start)',"""if model and model:GetAttribute('CraxId')=='Crax_Super'then
  state:SetAttribute('SuperVictoryCrax','Crax_Super');state:SetAttribute('SuperVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0)
  state:SetAttribute('SuperVictoryMatch',state:GetAttribute('CraxMatchToken'));state:SetAttribute('SuperVictoryOwner',model.Name)
 end
 state:SetAttribute("RoundVictoryStartedAt",start)"""),
])
icon="""local function superSkillIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'))
 local key=({SuperLaser='Laser',SuperFrost='Frost',SuperInvincible='Invincible',SuperFinale='Max'})[kind]
 local holder=Instance.new('Frame');holder.Position=UDim2.fromOffset(x,y);holder.Size=UDim2.fromOffset(size,size);holder.BackgroundColor3=Color3.fromRGB(14,33,63);holder.BorderSizePixel=0;holder.Parent=parent
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.2,0);corner.Parent=holder
 if key and C.Icons[key]~=''then local image=Instance.new('ImageLabel');image.Size=UDim2.fromScale(1,1);image.BackgroundTransparency=1;image.ScaleType=Enum.ScaleType.Fit;image.Image=C.Icons[key];image.ZIndex=4;image.Parent=holder
 else
  local text=Instance.new('TextLabel');text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Font=Enum.Font.FredokaOne;text.TextScaled=true;text.Text=({SuperLaser='LASER',SuperFrost='GEL',SuperInvincible='1 PV',SuperFinale='MAX'})[kind]or'S';text.TextColor3=key=='Laser'and Color3.fromRGB(255,55,55)or(key=='Invincible'and Color3.fromRGB(90,240,105)or Color3.fromRGB(200,243,255));text.ZIndex=4;text.Parent=holder
 end
 return holder
end
"""
patch('StarterPlayer.StarterPlayerScripts.CopEmClient',[
 ('local function emblem(parent,kind,color,x,y,w,h)', 'INVALID_UNUSED')
] if False else[
 ('local function emblem(parent,kind,color,x,y,size)', "local function emblem(parent,kind,color,x,y,size)\n if type(kind)=='string'and kind:sub(1,5)=='Super'then superSkillIconV1(parent,kind,x,y,size);return end"),
 # Existing Inverted guard may already be present; the Super condition is additive.
 {'variants':[
  {'before':'if currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then','after':'if currentCrax~="Crax_Super"and currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then'},
  {'before':'if lv>=4 and TrophyIcons then','after':'if currentCrax~="Crax_Super"and lv>=4 and TrophyIcons then'}]},
 {'variants':[
  {'before':'if i==4 and currentCrax=="Crax_Inverted"then','after':'    if i==4 and currentCrax=="Crax_Super"then\n     if revealed then superSkillIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 and currentCrax=="Crax_Inverted"then'},
  {'before':'    if i==4 then\n     local holder=','after':'    if i==4 and currentCrax=="Crax_Super"then\n     if revealed then superSkillIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 then\n     local holder='}]},
],icon)
# Normalize dict alternatives introduced above.
for op in operations:
 if op['kind']=='patch':
  op['replacements']=[r if isinstance(r,dict)else{'before':r[0],'after':r[1]}for r in op['replacements']]
patch(RS+'CraxBookCinema',[
 ('self.trophyArt:ClearAllChildren()',"""self.trophyArt:ClearAllChildren()
 if id=='Crax_Super'then
  local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'));local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='SUPER MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(246,192,42),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text='EXÉCUTION MAX';return
 end"""),
])
# Review output is generated from the inspected repository version. The installer applies
# the operations to the live version and preserves every byte outside these insertion sites.
fixture=ROOT/'tests/fixtures/super-inspected-sources.json'
if not fixture.exists():
 raw=json.loads(Path('/workspace/invertedcrax/current/report.json').read_text());by_path={e['path']:e.get('source')for e in raw['scripts']}
 canonical={}
 for op in operations:
  candidate=ROOT/'integration/invertedcrax/patched'/('/'.join(op['path'].split('.'))+'.lua')
  canonical[op['path']]=candidate.read_text()if candidate.exists()else by_path[op['path']]
 fixture.write_text(json.dumps({'canonical':canonical,'base':{p:by_path[p]for p in canonical}},ensure_ascii=False,indent=2))
fixtures=json.loads(fixture.read_text())
def apply_operation(source,op):
 assert '-- SuperCraxIntegrationV1'not in source
 if op['kind']=='wrap':return '-- SuperCraxIntegrationV1\nlocal data=(function()\n'+source+'\nend)()\n'+op['addition']+'\nreturn data\n'
 for replacement in op['replacements']:
  variants=replacement.get('variants',[replacement]);matches=[v for v in variants if source.count(v['before'])==1]
  assert len(matches)==1,(op['path'],[v['before'][:65]for v in variants],len(matches))
  v=matches[0];source=source.replace(v['before'],v['after'],1)
 return '-- SuperCraxIntegrationV1\n'+op.get('prepend','')+source
review=[]
for op in operations:
 source=fixtures['canonical'][op['path']];result=apply_operation(source,op)
 path=OUT/'review'/('/'.join(op['path'].split('.'))+'.lua');path.parent.mkdir(parents=True,exist_ok=True);path.write_text(result)
 review.append({'path':op['path'],'mode':op['kind'],'reviewBaseSha256':hashlib.sha256(source.encode()).hexdigest(),'resultSha256':hashlib.sha256(result.encode()).hexdigest()})
(OUT/'operations.json').write_text(json.dumps(operations,ensure_ascii=False,indent=2));(OUT/'review-manifest.json').write_text(json.dumps(review,indent=2))
def long(s):
 equals='===='
 while ']'+equals+']'in s:equals+='='
 return '['+equals+'['+s+']'+equals+']'
def lua(v):
 if isinstance(v,str):return long(v)
 if isinstance(v,list):return '{'+','.join(lua(x)for x in v)+'}'
 if isinstance(v,dict):return '{'+','.join('[ '+lua(k)+' ]='+lua(value)for k,value in v.items())+'}'
 raise TypeError(v)
modules=[]
for f in sorted(SRC.glob('*.lua')):
 name=f.name.removesuffix('.client.lua').removesuffix('.lua');service='StarterPlayer.StarterPlayerScripts'if f.name.endswith('.client.lua')else('ServerScriptService'if name=='CraxSuperRuntime'else'ReplicatedStorage')
 modules.append({'path':service+'.'+name,'class':'LocalScript'if f.name.endswith('.client.lua')else'ModuleScript','source':f.read_text()})
header="""-- SUPERCRAX : UNE COMMANDE. PLAY ARRÊTÉ. Importer puis sélectionner les accessoires FBX.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play avant installation.')
local function resolve(path)local o=game;for key in path:gmatch('[^.]+')do o=o and o:FindFirstChild(key)end;return o end
local RS=game:GetService('ReplicatedStorage');local storage=game:GetService('ServerStorage')
local backupName='SuperCrax_Integration_Backup_V1';local marker='-- SuperCraxIntegrationV1'
local operations="""+lua(operations)+"\nlocal modules="+lua(modules)+"\n"
body="""
local previous=storage:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('SuperOwned')==true,'Nom de sauvegarde déjà utilisé.')
 for _,entry in ipairs(previous.Entries:GetChildren())do local object=resolve(entry:GetAttribute('Path'));assert(object and object.Source==entry.Installed.Value,'Source retouchée depuis installation : '..entry:GetAttribute('Path')..'. Aucun écrasement.')end
 print('SuperCrax déjà installé : aucun doublon.');return
end
local function count(source,needle)local n,pos=0,1;while true do local a,b=source:find(needle,pos,true);if not a then return n end;n+=1;pos=b+1 end end
local planned={}
for _,op in ipairs(operations)do
 local target=resolve(op.path);assert(target and target:IsA('LuaSourceContainer'),'Source absente : '..op.path)
 local source=target.Source;assert(not source:find(marker,1,true),'Patch SuperCrax déjà présent sans sauvegarde : '..op.path)
 local updated=source
 if op.kind=='wrap'then
  if op.path=='ReplicatedStorage.CraxCatalog'or op.path=='ReplicatedStorage.CraxSkillCatalog'then assert(not source:find('data.Crax_Super',1,true),'SuperCrax semble déjà déclaré : '..op.path)end
  updated=marker..'\nlocal data=(function()\n'..source..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,replacement in ipairs(op.replacements)do
   local chosen
   for _,v in ipairs(replacement.variants or{replacement})do if count(updated,v.before)==1 then assert(not chosen,'Ancres ambiguës : '..op.path);chosen=v end end
   assert(chosen,'Version non reconnue : '..op.path..'. Aucun fichier modifié. Fournir cette source actuelle ; ne pas restaurer une ancienne version.')
   local a,b=updated:find(chosen.before,1,true);updated=updated:sub(1,a-1)..chosen.after..updated:sub(b+1)
  end
  updated=marker..'\n'..(op.prepend or'')..updated
 end
 planned[#planned+1]={object=target,path=op.path,before=source,after=updated}
end
for _,spec in ipairs(modules)do assert(not resolve(spec.path),'Nom déjà utilisé : '..spec.path)end
for _,name in ipairs({'CraxSuperFX','CraxSuperImportedAssets'})do assert(not RS:FindFirstChild(name),'Nom déjà utilisé : '..name)end
local templates=assert(storage:FindFirstChild('CraxTemplates'),'CraxTemplates absent');local base=assert(templates:FindFirstChild('Crax_Monster'),'Vrai CraxSourire absent')
local previews=assert(RS:FindFirstChild('CraxPreviews'),'CraxPreviews absent')
assert(not templates:FindFirstChild('Crax_Super')and not previews:FindFirstChild('Crax_Super'),'Template ou aperçu SuperCrax déjà présent')
local selection=game:GetService('Selection'):Get();assert(#selection==1,'Sélectionnez UN modèle importé depuis SuperCrax_ACCESSOIRES_IMPORT.fbx.')
local imported=selection[1];assert(imported:IsA('Model')or imported:IsA('Folder'),'Sélectionner la racine du modèle importé')
local found={};local parts=0
for _,o in ipairs(imported:GetDescendants())do
 if o:IsA('LuaSourceContainer')then error('La sélection contient des scripts : sélectionner seulement les accessoires FBX.')end
 if o:IsA('BasePart')then
  assert(o.Name:match('^Super')or o.Name:match('^FIT_'),'Pièce étrangère dans la sélection : '..o.Name)
  assert(not found[o.Name],'Noms de pièces dupliqués dans l’import : '..o.Name);found[o.Name]=o;parts+=1
  if o:IsA('MeshPart')and not o.Name:match('^FIT_')then local id=o.MeshId:match('rbxassetid://(%d+)')or o.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..o.Name..'. Terminer l’import 3D sous le propriétaire de l’expérience.')end
 end
end
for _,name in ipairs({'FIT_Front','FIT_HeadCenter','FIT_Up','SuperChinBlue','SuperCurl','SuperCurl_Ridge','SuperEmblem_RedShield','SuperEmblem_S','SuperEmblem_YellowField','SuperHairCap','SuperHairLock_00','SuperHairLock_01','SuperHairLock_02','SuperHairLock_03','SuperHairLock_04','SuperHairLock_05','SuperTemple_-1','SuperTemple_1'})do assert(found[name],'Pièce manquante à l’import : '..name)end
assert(parts==18,'Import incomplet ou pièces supplémentaires : 15 meshes et 3 repères attendus')
local center,front,up=found.FIT_HeadCenter.Position,found.FIT_Front.Position,found.FIT_Up.Position
assert((front-center).Magnitude>.001 and(up-center).Magnitude>.001,'Repères importés invalides')
assert(math.abs((front-center).Unit:Dot((up-center).Unit))<.05,'Repères importés non orthogonaux : ne pas déplacer les pièces séparément')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('SuperOwned',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created,changed={},{}
local function register(o)created[#created+1]=o;o:SetAttribute('SuperOwned',true);return o end
local function record(path,before,after)
 local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path)
 for name,value in pairs({Original=before,Installed=after})do local v=Instance.new('StringValue');v.Name=name;v.Value=value;v.Parent=e end;e.Parent=entries
end
local ok,err=pcall(function()
 for _,spec in ipairs(modules)do
  local parent,name=spec.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(spec.class));o.Name=name;o.Source=spec.source;o.Parent=assert(resolve(parent));record(spec.path,'',spec.source)
 end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxSuperFX';event.Parent=RS
 local assets=register(assert(imported:Clone()));assets.Name='CraxSuperImportedAssets';assets.Parent=RS
 for _,o in ipairs(assets:GetDescendants())do if o:IsA('BasePart')then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false end end
 local appearance=require(RS.CraxSuperAppearance)
 local template=register(assert(base:Clone()));template.Name='Crax_Super';appearance.Apply(template,assets);template:SetAttribute('AbilityId','SuperHero');template.Parent=templates
 local preview=register(assert(template:Clone()));preview.Name='Crax_Super';preview.Parent=previews
 for _,item in ipairs(planned)do record(item.path,item.before,item.after);changed[#changed+1]=item;item.object.Source=item.after end
 backup.Parent=storage
end)
if not ok then
 for i=#changed,1,-1 do pcall(function()changed[i].object.Source=changed[i].before end)end
 for i=#created,1,-1 do pcall(function()created[i]:Destroy()end)end
 backup:Destroy();error('Installation annulée, sources restaurées : '..tostring(err))
end
print('SuperCrax installé avec les sources ACTUELLES préservées et les vrais meshes importés. Sauvegarder la place puis lancer un NOUVEAU Play.')
print('Configuration : ReplicatedStorage.CraxSuperConfig ; sons/icônes : BRANCHER_ASSETS.lua. Les ressources sans ID ne bloquent pas les pouvoirs.')
end
"""
# Keep literal backslash-n inside the Lua command, not newlines within quoted Lua strings.
# Python's body above contains escaped Lua newlines in concatenations; normalize only those literals.
body=body.replace("marker..'\nlocal data=(function()\n'..source..'\nend)()\n'..op.addition..'\nreturn data\n'", "marker..'\\nlocal data=(function()\\n'..source..'\\nend)()\\n'..op.addition..'\\nreturn data\\n'")
body=body.replace("marker..'\n'..(op.prepend", "marker..'\\n'..(op.prepend")
(OUT/'INSTALLER_SUPERCRAX.lua').write_text(header+body)
(OUT/'RETOUR_ARRIERE_SUPERCRAX.lua').write_text("""-- Play ARRÊTÉ. Restaure les sources telles qu’elles étaient AVANT SuperCrax.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêtez Play.')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local storage=game:GetService('ServerStorage');local backup=assert(storage:FindFirstChild('SuperCrax_Integration_Backup_V1'),'Sauvegarde absente')
assert(backup:GetAttribute('SuperOwned')==true,'Sauvegarde non reconnue')
local entries=backup.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and o.Source==e.Installed.Value,'Source modifiée après installation : '..e:GetAttribute('Path')..'. Aucune modification effectuée.')end
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));if e.Original.Value~=''then o.Source=e.Original.Value end end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxSuperFX','ReplicatedStorage.CraxSuperImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Super','ServerStorage.CraxTemplates.Crax_Super'})do local o=resolve(path);if o and o:GetAttribute('SuperOwned')then o:Destroy()end end
backup:Destroy();print('SuperCrax retiré ; versions précédentes exactes restaurées. Les données joueur et les IDs utilisateur ne sont pas effacés.')
end
""")
print('SUPERCRAX BUILT:',len(operations),'live-source operations,',len(modules),'new sources,',len((OUT/'INSTALLER_SUPERCRAX.lua').read_bytes()),'installer bytes')
