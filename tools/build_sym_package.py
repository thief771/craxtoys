"""Target current editor sources, preserve prior fixes, transactional ScriptEditorService writes."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parents[1];SRC=ROOT/'src/symbioticrax';OUT=ROOT/'integration/symbioticrax';OUT.mkdir(exist_ok=True,parents=True)
ops=[]
def wrap(p,a):ops.append(dict(path=p,kind='wrap',addition=a))
def patch(p,rs,prepend=''):ops.append(dict(path=p,kind='patch',prepend=prepend,replacements=[dict(before=a,after=b)for a,b in rs]))
RS='ReplicatedStorage.';SS='ServerScriptService.';SP='StarterPlayer.StarterPlayerScripts.'
wrap(RS+'CraxCatalog',"""assert(not data.Crax_Symbioti,'SymbiotiCrax déjà défini')
local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local base=assert(data.Crax_Monster);local epic=assert(data.Crax_Ghosty)
data.Crax_Symbioti={DisplayName='SymbiotiCrax',Rarity=epic.Rarity,RarityColor=epic.RarityColor,TemplateName=C.Id,MaxHealth=C.Health,CollisionDamage=C.Melee,Speed=base.Speed,
 Description='Le vrai Crax Sourire transformé : langue recourbée, crocs et filaments noirs.',PowerDescription='Langue prédatrice : capture et traction progressive, puis morsure à 16 dégâts. Délai de 8 à 12 secondes actives après rétraction. Les contacts ordinaires ne s’ajoutent pas à la capture.',Effects={'SymMarks','SymArmour','SymParasite'},Ability={Id=C.AbilityId,DisplayName='LANGUE PRÉDATRICE',Damage=C.Damage,Cooldown=C.Wait[1]}}""")
wrap(RS+'CraxSkillCatalog',"""assert(not data.Crax_Symbioti)
local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local prices=assert(data.Crax_Ghosty).Upgrades
local list={
 {Id='SymMarks',Name='CONTAMINATION',Description='Trois mêlées ayant réellement retiré des PV sur la même victime font éclater les marques : 15 dégâts supplémentaires, puis 5 PV soignés seulement si l’explosion retire des PV. Marques : 15 s, rafraîchies ; langue et parasite exclus.'},
 {Id='SymArmour',Name='ARMURE VIVANTE',Description='Après 30 PV réellement perdus : réduction de 35 % pendant 4 s sur les coups suivants. Dépassement perdu, recharge suspendue pendant la protection. Aucun sauvetage mortel.'},
 {Id='SymParasite',Name='NOUS SOMMES DEUX',Description='Un parasite poursuit une cible pendant au plus 4 s, s’accroche 3 s : vitesse ×0,75 et 3 dégâts/s, puis revient. 5 PV de soin au retour uniquement après dégâts effectifs. Un seul parasite par héros ; délai 12–16 s après retour.'},
 {Id='SymFinale',Name=C.TrophyTitle,Status=C.TrophyTitle,TrophyId=C.TrophyId,Description='À chaque victoire MAX : déploiement d’une énorme mâchoire, capture du vrai vaincu, traction et morsure, rétraction puis pose et titre doré. Présentation uniquement, aucun gain supplémentaire.'}}
for i,u in ipairs(list)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Symbioti={Order=order+1,AbilityId=C.AbilityId,DisplayName='SymbiotiCrax',Enabled=C.PricesEnabled,Upgrades=list,Finale=list[4]}""")
wrap(RS+'CraxEffectsCatalog',"""data.SymMarks={DisplayName='CONTAMINATION',Description='Trois marques du même SymbiotiCrax déclenchent 15 dégâts supplémentaires. Expiration après 15 s sans nouvelle marque.',Icon='SymMarks',Image='',Color=Color3.fromRGB(110,115,130)}
data.SymArmour={DisplayName='ARMURE VIVANTE',Description='35 % de dégâts reçus en moins pendant 4 s. Aucun soin ou sauvetage automatique.',Icon='SymArmour',Image='',Duration=4,Color=Color3.fromRGB(80,86,100)}
data.SymParasite={DisplayName='PARASITE',Description='Vitesse ×0,75 pendant l’accrochage ; 3 dégâts/s durant au plus 3 s.',Icon='SymParasite',Image='',Duration=3,Color=Color3.fromRGB(178,73,100)}""")
wrap(RS+'CraxRouletteConfig',"""local catalog=require(game:GetService('ReplicatedStorage').CraxCatalog);local epic={};local total=0
for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Symbioti');if catalog[e.Id].Rarity==catalog.Crax_Symbioti.Rarity then epic[#epic+1]=e;total+=e.Weight end end
assert(#epic>0 and total>0);local share=total/(#epic+1);for _,e in ipairs(epic)do e.Weight=share end
data.Pool[#data.Pool+1]={Id='Crax_Symbioti',Weight=total-share*#epic} -- provisional equal redistribution within unchanged Epic mass
""")
wrap(RS+'CraxVictoryCatalog',"""local C=require(game:GetService('ReplicatedStorage').CraxSymConfig)
data.Crax_Symbioti={Id='SymFinale',DisplayName=C.TrophyTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(255,211,87),MinimumLevel=4,IntroDuration=0,Duration=C.Finale.ReturnEnd,ZoomDuration=0,HoldDuration=0,Description='Victoire MAX : mâchoire, capture, morsure et retour. Aucun dégât ni récompense supplémentaire.'}""")
wrap(SS+'CraxSkinServer',"""local appearance=require(game:GetService('ReplicatedStorage').CraxSymAppearance);local apply=data.Apply
function data.Apply(model,id,config)appearance.Restore(model);apply(model,id,config);if id=='Crax_Symbioti'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSymImportedAssets')))end end""")
patch(SS+'CraxPositionLock', [('return M',"""-- A controlled pull may move ONLY its own exclusive lock. Other statuses keep priority.
function M.Move(f,reason,position)
 local r=records[f.model];if not r or not r.reasons[reason]then return false end
 for key in pairs(r.reasons)do if key~=reason then return false end end
 r.position=position;r.pivot=CFrame.new(position.X,position.Y,r.depth)*r.rotation;f.position=position
 f.model:SetAttribute('FantasticAnchorPosition',Vector3.new(position.X,position.Y,r.depth));M.Enforce(f);return true
end
return M""")])
prefix="local SymV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))\n"
patch(SS+'ArenaMovement',[
 (' SuperCraxV1.Begin(fighters)',' SuperCraxV1.Begin(fighters)\n SymV1.Begin(fighters)'),
 ("  alive=alive and state:GetAttribute('Phase')=='Fighting'", "  SymV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))\n  alive=alive and state:GetAttribute('Phase')=='Fighting'"),
 ('not SuperCraxV1.Held(f.model)and','not SymV1.Held(f.model)and not SuperCraxV1.Held(f.model)and'),
 ('f.velocity * SuperCraxV1.Speed(f.model)','f.velocity * SymV1.Speed(f.model) * SuperCraxV1.Speed(f.model)'),
 ('f.velocity.Magnitude*SuperCraxV1.Speed(f.model)','f.velocity.Magnitude*SymV1.Speed(f.model)*SuperCraxV1.Speed(f.model)'),
 ('not SuperCraxV1.SuppressNormalContact(a.model,b.model)', 'not SymV1.SuppressContact(a.model,b.model)and not SuperCraxV1.SuppressNormalContact(a.model,b.model)')],prefix)
bridge="local function SymBridgeV1()return require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))end\n"
patch(SS+'CraxDeadlyRuntime',[
 ('speed=speed*SuperCraxBridgeV1().Speed(n.model)','speed=speed*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)'),
 ('*100*SuperCraxBridgeV1().Speed(n.model)','*100*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)'),
 ('+dt*2.8*SuperCraxBridgeV1().Speed(n.model)','+dt*2.8*SymBridgeV1().Speed(n.model)*SuperCraxBridgeV1().Speed(n.model)')],bridge)
patch(SS+'FleauRuntime',[('speed=speed*SuperCraxBridgeV1().Speed(m)','speed=speed*SymBridgeV1().Speed(m)*SuperCraxBridgeV1().Speed(m)')],bridge)
patch(SS+'CombatHealth',[
 ('local function report(a,b,lost,kind)','local function report(a,b,lost,kind)\n SymV1.PowerResult(a,b,lost,kind)'),
 ("amount=kind=='SuperLaser'and", "amount=(kind=='SuperLaser'or kind=='SymParasite')and"),
 ('amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)', 'amount=SymV1.Reduce(defender,amount);incoming=SymV1.Reduce(attacker,incoming)\n amount=SuperCraxV1.Incoming(defender,amount,b.health,attacker,kind)'),
 ('SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);','SymV1.Confirm(attacker,defender,lost,attackerLost,collision);SuperCraxV1.Confirm(attacker,defender,lost,attackerLost,collision);'),
 ('if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end','SymV1.Healed(model,r.health-before)\n if Deadly.OnHeal then Deadly.OnHeal(model,r.health-before,source)end')],prefix)
patch(SS+'RoundManager', [('state:SetAttribute("RoundVictoryStartedAt",start)',"""if model and model:GetAttribute('CraxId')=='Crax_Symbioti'then
 state:SetAttribute('SymVictoryCrax','Crax_Symbioti');state:SetAttribute('SymVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0);state:SetAttribute('SymVictoryMatch',state:GetAttribute('CraxMatchToken'))
 end
 state:SetAttribute("RoundVictoryStartedAt",start)""")])
icon="""local function symIconV1(parent,id,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local key=({SymMarks='Marks',SymArmour='Armour',SymParasite='Parasite',SymFinale='Max'})[id]
 local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundColor3=Color3.fromRGB(16,18,26);f.BorderSizePixel=0;f.Parent=parent
 local corner=Instance.new('UICorner');corner.CornerRadius=UDim.new(.2,0);corner.Parent=f
 if key and C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f
 else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.Text=({Marks='3',Armour='35%',Parasite='DUO',Max='MAX'})[key]or'S';t.Font=Enum.Font.FredokaOne;t.TextScaled=true;t.BackgroundTransparency=1;t.TextColor3=key=='Max'and Color3.fromRGB(255,211,87)or Color3.fromRGB(240,240,226);t.ZIndex=5;t.Parent=f end
 return f
end
"""
patch(SP+'CopEmClient',[
 ('local function emblem(parent,kind,color,x,y,size)',"local function emblem(parent,kind,color,x,y,size)\n if type(kind)=='string'and kind:sub(1,3)=='Sym'then symIconV1(parent,kind,x,y,size);return end"),
 ('    if i==4 and currentCrax=="Crax_Super"then', '    if i==4 and currentCrax=="Crax_Symbioti"then\n     if revealed then symIconV1(node,upgrade.Id,3,3,56)else local t=text(node,"?",0,0,62,62,35,C.muted);t.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 and currentCrax=="Crax_Super"then')],icon)
patch(RS+'CraxBookCinema', [('self.trophyArt:ClearAllChildren()',"""self.trophyArt:ClearAllChildren()
 if self._symTitleScaled==nil then self._symTitleScaled=self.trophyIcon.TrophyTitle.TextScaled end
 self.trophyIcon.TrophyTitle.TextScaled=self._symTitleScaled
 if id=='Crax_Symbioti'then
  local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(255,211,87),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text=C.TrophyTitle;self.trophyIcon.TrophyTitle.TextScaled=true;return
 end""")])
patch(SS+'CraxTrophyServer',[('label.Text=title;label.Font=Enum.Font.GothamBlack;label.TextSize=22','label.Text=title;label.Font=Enum.Font.GothamBlack;label.TextSize=22\n  if entry.crax=="Crax_Symbioti"then label.TextScaled=true end')])
patch(SP+'ArenaCamera',[
 ("local function beginDefeat() -- FantasticExclusiveFinale_v4", "local function beginDefeat() -- FantasticExclusiveFinale_v4\n if state:GetAttribute('RoundVictoryKind')=='SymFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end"),
 ('function()\n\t\tlocal seated = player:GetAttribute("ArenaSeat") ~= nil', 'function()\n  if player:GetAttribute("SymCameraOwner")then if defeat then clearDefeat()end;return end\n\t\tlocal seated = player:GetAttribute("ArenaSeat") ~= nil')])
wrap(RS+'CraxDeadlyVisuals',"""local fit=data.Fit
function data.Fit(view,model)
 if model:GetAttribute('SymPreview')then return require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSymPreview')).Bind(view,model)end
 return fit(view,model)
end""")
patch('StarterGui.InventoryGui.InventoryClient',[("if model:GetAttribute('DeadlySpiral')then local cf,sz=model:GetBoundingBox();center=cf.Position;radius=math.max(sz.X,sz.Y)/2 end","if model:GetAttribute('DeadlySpiral')or model:GetAttribute('SymPreview')then local cf,sz=model:GetBoundingBox();center=cf.Position;radius=math.max(sz.X,sz.Y)/2 end")])
raw={e['path']:e.get('source','')for e in json.loads((ROOT/'tests/fixtures/inspected-export.json').read_text())['scripts']}
# Some additional sources were not in the old Inverted fixture; preserve a reproducible snapshot.
fixture=ROOT/'tests/fixtures/sym-inspected-sources.json'
if fixture.exists():bases=json.loads(fixture.read_text())
else:
 report=json.loads(Path('/workspace/invertedcrax/current/report.json').read_text());raw.update({e['path']:e.get('source','')for e in report['scripts']})
 bases={}
 for op in ops:
  p=ROOT/'integration/supercrax/review'/('/'.join(op['path'].split('.'))+'.lua');bases[op['path']]=p.read_text()if p.exists()else raw[op['path']]
 fixture.write_text(json.dumps(bases,ensure_ascii=False,indent=2))
def apply(source,op):
 marker='-- SymbiotiCraxIntegrationV1'
 assert marker not in source
 if op['kind']=='wrap':return marker+'\nlocal data=(function()\n'+source+'\nend)()\n'+op['addition']+'\nreturn data\n'
 for r in op['replacements']:
  assert source.count(r['before'])==1,(op['path'],r['before'][:80],source.count(r['before']))
  source=source.replace(r['before'],r['after'],1)
 return marker+'\n'+op.get('prepend','')+source
for op in ops:
 p=OUT/'review'/('/'.join(op['path'].split('.'))+'.lua');p.parent.mkdir(exist_ok=True,parents=True);p.write_text(apply(bases[op['path']],op))
(OUT/'operations.json').write_text(json.dumps(ops,ensure_ascii=False,indent=2))
def long(s):
 e='===='
 while ']'+e+']'in s:e+='='
 return '['+e+'['+s+']'+e+']'
def lua(v):
 if isinstance(v,str):return long(v)
 if isinstance(v,list):return'{'+','.join(lua(x)for x in v)+'}'
 if isinstance(v,dict):return'{'+','.join('[ '+lua(k)+' ]='+lua(a)for k,a in v.items())+'}'
 raise TypeError(v)
modules=[]
for p in sorted(SRC.glob('*.lua')):
 n=p.name.removesuffix('.client.lua').removesuffix('.lua');service=SP if p.name.endswith('.client.lua')else(SS if n=='CraxSymRuntime'else RS)
 modules.append(dict(path=service+n,className='LocalScript'if p.name.endswith('.client.lua')else'ModuleScript',source=p.read_text()))
model=json.loads((ROOT/'assets/symbioticrax/model/manifest.json').read_text());expected=model['accessories']+model['markers']
header="""-- SYMBIOTICRAX. STOP. Sélectionner le modèle accessoires FBX importé et publié.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play avant installation')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local p=game;for n in path:gmatch('[^.]+')do p=p and p:FindFirstChild(n)end;return p end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)
 SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end)
 assert(read(o)==after,'Vérification éditeur échouée : '..o:GetFullName())
end
local ops="""+lua(ops)+'\nlocal modules='+lua(modules)+'\nlocal expected='+lua(expected)+'\n'
body=r"""
local backupName='SymbiotiCrax_Backup_V1';local previous=SS:FindFirstChild(backupName)
if previous then
 assert(previous:GetAttribute('SymOwned')and not previous:GetAttribute('Incomplete'),'Sauvegarde incomplète ou étrangère ; inspecter avant reprise')
 for _,e in ipairs(previous.Entries:GetChildren())do local o=resolve(e:GetAttribute('Path'));assert(o and read(o)==e.Installed.Value,'Source éditée après installation : '..e:GetAttribute('Path'))end
 for _,path in ipairs({'ReplicatedStorage.CraxSymFX','ReplicatedStorage.CraxSymImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Symbioti','ServerStorage.CraxTemplates.Crax_Symbioti'})do local o=resolve(path);assert(o and o:GetAttribute('SymOwned'),'Élément installé supprimé ou remplacé : '..path)end
 print('SymbiotiCrax déjà installé, aucun doublon');return
end
for path,class in pairs({['ReplicatedStorage.CraxAbilityClock']='ModuleScript',['ServerScriptService.CraxAbilityGate']='ModuleScript',['ServerScriptService.CraxSkillResolver']='ModuleScript',['ServerScriptService.BiteHit']='BindableEvent',['ServerScriptService.CraxHeal']='BindableEvent',['Workspace.Arenaleft']='BasePart',['Workspace.ArenaRight']='BasePart',['Workspace.Arenabottom']='BasePart',['Workspace.ArenaTop']='BasePart'})do local o=resolve(path);assert(o and o:IsA(class),'Dépendance absente ou mauvais type : '..path)end
assert(resolve('Workspace.CombatState'),'CombatState absent')
local plan={};local marker='-- SymbiotiCraxIntegrationV1'
local function count(s,n)local total,p=0,1;while true do local a,b=s:find(n,p,true);if not a then return total end;total+=1;p=b+1 end end
for _,op in ipairs(ops)do
 local o=assert(resolve(op.path),'Source manquante : '..op.path);assert(o:IsA('LuaSourceContainer'),'Type de source incorrect');local before=read(o);assert(not before:find(marker,1,true),'Patch sans sauvegarde : '..op.path);local after=before
 if op.kind=='wrap'then after=marker..'\nlocal data=(function()\n'..before..'\nend)()\n'..op.addition..'\nreturn data\n'
 else
  for _,r in ipairs(op.replacements)do assert(count(after,r.before)==1,'Source actuelle non reconnue : '..op.path..'. Aucun fichier modifié ; ne pas rétablir une ancienne version.');local a,b=after:find(r.before,1,true);after=after:sub(1,a-1)..r.after..after:sub(b+1)end
  after=marker..'\n'..(op.prepend or'')..after
 end
 plan[#plan+1]={path=op.path,object=o,before=before,after=after}
end
for _,m in ipairs(modules)do assert(not resolve(m.path),'Nom utilisé : '..m.path)end
for _,n in ipairs({'CraxSymFX','CraxSymImportedAssets'})do assert(not RS:FindFirstChild(n),'Nom utilisé : '..n)end
local templates=assert(SS:FindFirstChild('CraxTemplates'));local base=assert(templates:FindFirstChild('Crax_Monster'));local previews=assert(RS:FindFirstChild('CraxPreviews'))
assert(not templates:FindFirstChild('Crax_Symbioti')and not previews:FindFirstChild('Crax_Symbioti'),'Template/preview déjà présent')
local selected=game:GetService('Selection'):Get();assert(#selected==1,'Sélectionner une seule racine de SymbiotiCrax_ACCESSOIRES_IMPORT.fbx')
local imported=selected[1];assert(imported:IsA('Model')or imported:IsA('Folder'),'Racine importée attendue');local found={};local countParts=0
for _,p in ipairs(imported:GetDescendants())do
 assert(not p:IsA('LuaSourceContainer'),'Aucun script autorisé dans les accessoires')
 if p:IsA('BasePart')then assert(not found[p.Name],'Nom dupliqué : '..p.Name);found[p.Name]=p;countParts+=1
  if p.Name:match('^Sym')then assert(p:IsA('MeshPart'),'MeshPart requis : '..p.Name);local id=p.MeshId:match('rbxassetid://(%d+)')or p.MeshId:match('[?&]id=(%d+)');assert(id and tonumber(id)>0,'Mesh non publié : '..p.Name)end
 end
end
assert(countParts==#expected,'Import incomplet ou pièces supplémentaires')
for _,n in ipairs(expected)do assert(found[n],'Pièce manquante : '..n)end
local c,f,u=found.FIT_HeadCenter.Position,found.FIT_Front.Position,found.FIT_Up.Position
assert((f-c).Magnitude>.001 and(u-c).Magnitude>.001 and math.abs((f-c).Unit:Dot((u-c).Unit))<.05,'Repères invalides')
local backup=Instance.new('Folder');backup.Name=backupName;backup:SetAttribute('SymOwned',true);backup:SetAttribute('Incomplete',true)
local entries=Instance.new('Folder');entries.Name='Entries';entries.Parent=backup
local created={};local changed={}
local function register(o)o:SetAttribute('SymOwned',true);created[#created+1]=o;return o end
local function record(path,before,after)local e=Instance.new('Folder');e.Name=tostring(#entries:GetChildren()+1);e:SetAttribute('Path',path);for n,v in pairs({Original=before,Installed=after})do local s=Instance.new('StringValue');s.Name=n;s.Value=v;s.Parent=e end;e.Parent=entries end
backup.Parent=SS
local ok,err=pcall(function()
 for _,m in ipairs(modules)do local parent,name=m.path:match('^(.*)%.([^.]+)$');local o=register(Instance.new(m.className));o.Name=name;o.Parent=assert(resolve(parent));record(m.path,'',m.source);write(o,read(o),m.source)end
 local event=register(Instance.new('RemoteEvent'));event.Name='CraxSymFX';event.Parent=RS
 local assets=register(imported:Clone());assets.Name='CraxSymImportedAssets';assets.Parent=RS
 local appearance=require(RS.CraxSymAppearance)
 local template=register(base:Clone());template.Name='Crax_Symbioti';appearance.Apply(template,assets);template:SetAttribute('AbilityId','SymTongue');template.Parent=templates
 local preview=register(template:Clone());preview.Name='Crax_Symbioti';preview.Parent=previews
 for _,item in ipairs(plan)do record(item.path,item.before,item.after);changed[#changed+1]=item;write(item.object,item.before,item.after)end
 backup:SetAttribute('Incomplete',false)
end)
if not ok then
 local conflicts={}
 for i=#changed,1,-1 do local p=changed[i];local success=pcall(function()local s=read(p.object);if s==p.after then write(p.object,p.after,p.before)elseif s~=p.before then error('édition concurrente')end end);if not success then conflicts[#conflicts+1]=p.path end end
 if #conflicts==0 then for i=#created,1,-1 do created[i]:Destroy()end;backup:Destroy()else warn('Sauvegarde conservée : rollback bloqué par édition concurrente : '..table.concat(conflicts,', '))end
 error('Installation arrêtée : '..tostring(err))
end
print('SymbiotiCrax installé. Sources de l’éditeur préservées, sauvegarde créée. Enregistrer, fermer/rouvrir puis NOUVEAU Play. Importer et brancher l’atlas audio et les illustrations pour les activer.')
end
"""
# Raw Python string holds literal Lua backslash-newlines, reduce double escapes once.
body=body.replace('\\\\n','\\n')
(OUT/'INSTALLER_SYMBIOTICRAX.lua').write_text(header+body)
rollback=r"""-- STOP. Restaure les versions exactes antérieures via ScriptEditorService.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local b=assert(SS:FindFirstChild('SymbiotiCrax_Backup_V1'),'Sauvegarde absente');assert(b:GetAttribute('SymOwned')and not b:GetAttribute('Incomplete'),'Sauvegarde incomplète, examiner les entrées')
local entries=b.Entries:GetChildren()
for _,e in ipairs(entries)do local o=resolve(e:GetAttribute('Path'));assert(o and SES:GetEditorSource(o)==e.Installed.Value,'Source éditée : '..e:GetAttribute('Path'))end
local restored={};local ok,err=pcall(function()
 for _,e in ipairs(entries)do if e.Original.Value~=''then local o=resolve(e:GetAttribute('Path'));SES:UpdateSourceAsync(o,function(s)assert(s==e.Installed.Value,'Conflit éditeur');return e.Original.Value end);restored[#restored+1]=e end end
end)
if not ok then
 for i=#restored,1,-1 do local e=restored[i];pcall(function()SES:UpdateSourceAsync(resolve(e:GetAttribute('Path')),function(s)assert(s==e.Original.Value);return e.Installed.Value end)end)end
 error('Retour arrière interrompu, sauvegarde conservée : '..tostring(err))
end
for _,e in ipairs(entries)do if e.Original.Value==''then resolve(e:GetAttribute('Path')):Destroy()end end
for _,path in ipairs({'ReplicatedStorage.CraxSymFX','ReplicatedStorage.CraxSymImportedAssets','ReplicatedStorage.CraxPreviews.Crax_Symbioti','ServerStorage.CraxTemplates.Crax_Symbioti'})do local o=resolve(path);if o and o:GetAttribute('SymOwned')then o:Destroy()end end
b:Destroy();print('SymbiotiCrax retiré. Sources antérieures, possessions et niveaux conservés. Enregistrer puis nouveau Play.')
end
"""
(OUT/'RETOUR_ARRIERE_SYMBIOTICRAX.lua').write_text(rollback)
print('SYMBIOTICRAX BUILD',len(ops),'live patches',len(modules),'new sources')
