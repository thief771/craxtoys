"""Guarded integration over the latest inspected LuckyCrax architecture; no whole-script restore."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'integration/polaricrax';SRC=ROOT/'src/polaricrax';RS='ReplicatedStorage.';SS='ServerScriptService.';SP='StarterPlayer.StarterPlayerScripts.';ops=[]
def wrap(p,s):ops.append(dict(path=p,kind='wrap',addition=s))
def patch(p,items,prepend=''):ops.append(dict(path=p,kind='patch',prepend=prepend,replacements=[dict(before=a+'\n'if a.startswith('\nreturn ')and not a.endswith('\n')else a,after=b+'\n'if a.startswith('\nreturn ')and not b.endswith('\n')else b)for a,b in items]))
wrap(RS+'CraxCatalog',"""assert(not data.Crax_Polari);local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local base=assert(data.Crax_Monster);local rare=assert(data.Crax_Spidey)
data.Crax_Polari={DisplayName='PolariCrax',Rarity=rare.Rarity,RarityColor=rare.RarityColor,TemplateName=C.Id,MaxHealth=110,CollisionDamage=7,Speed=base.Speed,Description='Vinyle blanc, sourire ivoire, yeux fermés et casque rouge à protections violettes.',PowerDescription='IMPULSION MAGNÉTIQUE : toutes les 6–9 secondes actives, charge 0,4 s puis éclat vers la position actuelle de la cible. Impact 10 dégâts et légère déviation.',Effects={'PolariAttract','PolariFrozen'},Ability={Id=C.AbilityId,DisplayName='IMPULSION MAGNÉTIQUE',Damage=10,Cooldown=6}}""")
wrap(RS+'CraxSkillCatalog',"""local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local prices=assert(data.Crax_Spidey).Upgrades;local levels={
{Id='PolariAttract',Name='PÔLE D’ATTRACTION',Description='Polarise pendant 2 s le mur le plus proche de la cible ; incurve progressivement sa trajectoire. Premier contact avec ce mur : 8 dégâts, une seule fois par activation. Délai 10–14 s.'},
{Id='PolariInvert',Name='INVERSION DES PÔLES',Description='Charge un des quatre murs au hasard pendant 1,5 s ; actif 3 s. Collision ennemie : 15 dégâts et projection vers le centre, une fois par cible et activation.'},
{Id='PolariStop',Name='TEMPS SUSPENDU',Description='Tic-tac, arrêt du combat 1,2 s, cinq éclats et axes annoncés. Mouvement repris 0,35 s avant le tir simultané. 6 dégâts par éclat, trois impacts maximum par cible : 18. Première activation après 5–7 s actives, puis délai 22–28 s.'},
{Id='PolariFinale',Name=C.MaxTitle,TrophyId=C.TrophyId,Description='Exécution MAX : cadran, cinq fragments, inversion des murs et trophée L’ULTIME SECONDE. Scène cosmétique après le résultat du combat.'}}
for i,u in ipairs(levels)do u.Coins=assert(prices[i].Coins);u.Gems=assert(prices[i].Gems)end;local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Polari={Order=order+1,AbilityId=C.AbilityId,DisplayName='PolariCrax',Enabled=true,Upgrades=levels,Finale=levels[4]}""")
wrap(RS+'CraxEffectsCatalog',"data.PolariAttract={DisplayName='POLARISATION',Description='Trajectoire attirée vers un mur pendant 2 s ; premier contact : 8 dégâts.',Duration=2,Image='',Color=Color3.fromRGB(163,75,230)};data.PolariFrozen={DisplayName='TEMPS SUSPENDU',Description='Pause imbriquée du combat pendant 1,2 s, puis fenêtre d’esquive.',Duration=1.2,Image='',Color=Color3.fromRGB(242,194,75)}")
wrap(RS+'CraxVictoryCatalog',"local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);data.Crax_Polari={Id='PolariFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(247,201,76),MinimumLevel=4,Duration=C.FinaleDuration,IntroDuration=0,ZoomDuration=0,HoldDuration=0}")
wrap(RS+'CraxRouletteConfig',"local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local rare,total={},0;for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Polari');if cat[e.Id].Rarity==cat.Crax_Polari.Rarity then rare[#rare+1]=e;total+=e.Weight end end;assert(#rare>0);local w=total/(#rare+1);for _,e in ipairs(rare)do e.Weight=w end;data.Pool[#data.Pool+1]={Id='Crax_Polari',Weight=total-w*#rare} -- Explicit prototype: unchanged Rare mass, equal redistribution.")
wrap(SS+'CraxSkinServer',"local A=require(game:GetService('ReplicatedStorage').CraxPolariAppearance);local apply=data.Apply;function data.Apply(m,id,c)A.Restore(m);apply(m,id,c);if id=='Crax_Polari'then A.Apply(m,game:GetService('ReplicatedStorage').CraxPolariImportedAssets)end end")
prefix="local PolariV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxPolariRuntime'))\n"
patch(SS+'ArenaMovement',[(" LuckyV1.Begin(fighters)"," LuckyV1.Begin(fighters)\n PolariV1.Begin(fighters)"),("RunService.Heartbeat:Connect(function(deltaTime)","RunService.Heartbeat:Connect(function(deltaTime)\n if PolariV1.Pump(deltaTime,fighters)then return end"),("  SymV1.Step(step*Deadly.CinematicScale()", "  PolariV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))\n  if PolariV1.Frozen()then break end\n  SymV1.Step(step*Deadly.CinematicScale()"),("for _,side in ipairs(plumberSides)do Plumber.Wall(f,side)end","for _,side in ipairs(plumberSides)do PolariV1.WallContact(f.model,side);Plumber.Wall(f,side)end")],prefix)
patch(SS+'CombatHealth',[(" local a,b=states[attacker],states[defender]", " if attacker:GetAttribute('PolariFrozen')or defender:GetAttribute('PolariFrozen')then return end\n local a,b=states[attacker],states[defender]"),(" local luckyDef=LuckyV1.Dodge(defender,amount,attacker,kind,attackId)", " if kind=='PolariFan'then amount=PolariV1.MaxFanPacket(amount)end\n local luckyDef=LuckyV1.Dodge(defender,amount,attacker,kind,attackId)"),("local function report(a,b,lost,kind)","local function report(a,b,lost,kind)\n PolariV1.PowerResult(a,b,lost,kind)")],prefix)
patch(SS+'RoundManager',[("state:SetAttribute(\"RoundVictoryStartedAt\",start)","if model and model:GetAttribute('CraxId')=='Crax_Polari'then state:SetAttribute('PolariVictoryMatch',state:GetAttribute('CraxMatchToken'))end\n state:SetAttribute(\"RoundVictoryStartedAt\",start)")])
patch(SS+'CraxLuckyAdapters',[(" S.Register('Crax_Monster',function()end)"," S.Register('Crax_Polari',function(m)require(SS.CraxPolariRuntime).Cancel(m)end)\n S.Register('Crax_Monster',function()end)")])
# Pause adapters shift live absolute deadlines; no state restoration from obsolete snapshots.
patch(SS+'CraxPlumberRuntime',[("\nreturn M", "\nfunction M.PolariDelay(dt)for _,r in pairs(logic.records)do for _,k in ipairs({'boostUntil','impulseUntil','nextWall','nextTransit'})do if type(r[k])=='number'and r[k]>0 then r[k]+=dt end end;local t=r.transit;if t then for _,k in ipairs({'Start','ExitAt','EndAt'})do if t[k]then t[k]+=dt end end end end end\nreturn M")])
patch(SS+'CraxSpideyRuntime',[("\nreturn R", "\nfunction R.PolariDelay(dt)if lastStep then lastStep+=dt end;for m,t in pairs(timers)do timers[m]=t+dt end;for _,p in pairs(poisons)do p.next+=dt end;for _,t in ipairs(traps)do t.expires+=dt;if t.part.Parent then t.part:SetAttribute('Expires',t.expires);local born=t.part:GetAttribute('Born');if born then t.part:SetAttribute('Born',born+dt)end end end end\nreturn R")])
patch(SS+'FleauRuntime',[("\nreturn M", "\nfunction M.PolariDelay(dt)for _,r in pairs(records)do for _,k in ipairs({'furyEnds','furyLast','contactSuppressedUntil'})do if type(r[k])=='number'and r[k]>0 then r[k]+=dt end end end end\nreturn M")])
patch(SS+'FleauControl',[("\nreturn C", "\nfunction C.PolariDelay(dt)for _,r in pairs(records)do for k,v in pairs(r)do r[k]=v+dt end end end\nreturn C")])
patch(SS+'FantasticRuntime',[("\nreturn M", "\nfunction M.PolariDelay(dt)started+=dt end\nreturn M")])
patch(SS+'GhostyNight',[("\nreturn Night", "\nfunction Night.PolariDelay(dt)if active and active.serverEnd then active.serverEnd+=dt end end\nreturn Night")])
patch(SS+'CraxDeadlyRuntime',[("\nreturn M", "\nfunction M.PolariDelay(dt)for _,e in pairs(M.cinematics)do e.finish+=dt end end\nreturn M")])
icon="""local function polariIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);local key=({PolariAttract='Attract',PolariInvert='Invert',PolariStop='Stop',PolariFinale='Max'})[kind];local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundTransparency=1;f.Parent=parent
 if C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=({Attract='PÔLE',Invert='±',Stop='1,2 s',Max='MAX'})[key];t.TextScaled=true;t.TextColor3=Color3.fromRGB(230,185,80);t.Font=Enum.Font.FredokaOne;t.ZIndex=5;t.Parent=f end;return f
end
"""
patch(SP+'CopEmClient',[("local function emblem(parent,kind,color,x,y,size)","local function emblem(parent,kind,color,x,y,size)\n if type(kind)=='string'and kind:sub(1,6)=='Polari'then polariIconV1(parent,kind,x,y,size);return end"),("    if i==4 and currentCrax==\"Crax_Lucky\"then", "    if i==4 and currentCrax==\"Crax_Polari\"then\n     if revealed then polariIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,\"?\",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 and currentCrax==\"Crax_Lucky\"then")],icon)
patch(RS+'CraxBookCinema',[("self.trophyArt:ClearAllChildren()","self.trophyArt:ClearAllChildren()\n if id=='Crax_Polari'then local C=require(game:GetService('ReplicatedStorage').CraxPolariConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(247,201,76),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end")])
patch(SP+'ArenaCamera',[("local function beginDefeat() -- FantasticExclusiveFinale_v4","local function beginDefeat() -- FantasticExclusiveFinale_v4\n if state:GetAttribute('RoundVictoryKind')=='PolariFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end"),("if player:GetAttribute(\"LuckyCameraOwner\")then","if player:GetAttribute(\"PolariCameraOwner\")then if defeat then clearDefeat()end;return end\n  if player:GetAttribute(\"LuckyCameraOwner\")then")])
fixture=ROOT/'tests/fixtures/polari-inspected-sources.json'
if fixture.exists():base=json.loads(fixture.read_text())
else:
 report=json.loads(Path('/workspace/invertedcrax/current/report.json').read_text());lookup={x['path']:x['source']for x in report['scripts']};base={}
 for op in ops:
  path=op['path'];p=ROOT/'integration/luckycrax/review'/('/'.join(path.split('.'))+'.lua');q=ROOT/'src/luckycrax'/(path.split('.')[-1]+'.lua')
  base[path]=p.read_text()if p.exists()else(q.read_text()if q.exists()else lookup[path])
 fixture.write_text(json.dumps(base,ensure_ascii=False,indent=2))
def apply(s,op):
 if op['kind']=='wrap':return '-- PolariCraxIntegrationV1\nlocal data=(function()\n'+s+'\nend)()\n'+op['addition']+'\nreturn data\n'
 for r in op['replacements']:
  assert s.count(r['before'])==1,(op['path'],r['before'][:100],s.count(r['before']));s=s.replace(r['before'],r['after'],1)
 return '-- PolariCraxIntegrationV1\n'+op.get('prepend','')+s
for op in ops:
 p=OUT/'review'/('/'.join(op['path'].split('.'))+'.lua');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(apply(base[op['path']],op))
# A generic final return is insufficient evidence that an adapted private state still exists.
state_guards={'CraxPlumberRuntime':'local logic=Core.new();local fighters={};local records={}', 'CraxSpideyRuntime':'local R={};local traps,poisons,timers,previous={},{},{},{};local serial=0;local lastStep=nil', 'FleauRuntime':'local M={Health=nil};local records={}', 'FleauControl':"local C={};local records=setmetatable({},{__mode='k'})", 'FantasticRuntime':'local records={};local round;local started=workspace:GetServerTimeNow()', 'GhostyNight':'local active,freezeEnd,sequence=nil,0,0', 'CraxDeadlyRuntime':'local M={families={},nodes={},fighters={},aimSpawns={},cinematics={},viceTransits={},Health=nil}'}
for op in ops:
 key=op['path'].split('.')[-1]
 if key in state_guards:
  assert state_guards[key]in base[op['path']];op['requires']=[state_guards[key]]
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
 name=p.name.removesuffix('.client.lua').removesuffix('.lua');service=SP if p.name.endswith('.client.lua')else(SS if name in ['CraxPolariRuntime','CraxPolariPause']else RS);modules.append(dict(path=service+name,className='LocalScript'if p.name.endswith('.client.lua')else'ModuleScript',source=p.read_text()))
model=json.loads((ROOT/'assets/polaricrax/model/manifest.json').read_text());expected=model['accessories']+model['markers']+model['fx']
lucky=(ROOT/'integration/luckycrax/INSTALLER_LUCKYCRAX.lua').read_text();body=lucky[lucky.index('local backupName='):].replace('LuckyCrax','PolariCrax').replace('LuckyOwned','PolariOwned').replace('CraxLucky','CraxPolari').replace('Crax_Lucky','Crax_Polari').replace('LFX_Origin','P_FitOrigin').replace('LFX_Up','P_FitUp').replace('LFX_Front','P_FitFront').replace("p.Name:match('^LFX_')","p.Name:match('^P')").replace('PolariCrax_FX_IMPORT.fbx','PolariCrax_ACCESSOIRES_IMPORT.fbx').replace('appearance.Apply(template)','appearance.Apply(template,assets)').replace("'LuckyCoin'","'PolariImpulse'")
body=body.replace('local before=read(o);assert(not before:find(marker',"local before=read(o);for _,required in ipairs(op.requires or{})do assert(before:find(required,1,true),'Structure interne actuelle non reconnue : '..op.path..'. Exporter le diagnostic ; aucun fichier modifié.')end;assert(not before:find(marker")
body=body.replace("assert(resolve('Workspace.CombatState'),'CombatState absent')",'-- CombatState is created by RoundManager at runtime and may be absent in STOP.\nif not resolve(\'Workspace.CombatState\')then\n local manager=resolve(\'ServerScriptService.RoundManager\')\n assert(manager and manager:IsA(\'Script\')and not manager.Disabled,\'RoundManager serveur actif requis\')\n local source=read(manager)\n for _,anchor in ipairs({\'state = Instance.new("Folder")\',\'state.Name = "CombatState"\',\'state.Parent = workspace\'})do\n  assert(source:find(anchor,1,true),\'Initialisation CombatState non reconnue dans RoundManager ; aucun fichier modifié\')\n end\nend')
header=lucky[:lucky.index('local ops=')].replace('LUCKYCRAX','POLARICRAX').replace('LuckyCrax','PolariCrax').replace('PolariCrax_FX_IMPORT.fbx','PolariCrax_ACCESSOIRES_IMPORT.fbx')
(OUT/'INSTALLER_POLARICRAX.lua').write_text(header+'local ops='+lua(ops)+'\nlocal modules='+lua(modules)+'\nlocal expected='+lua(expected)+'\n'+body)
undo=(ROOT/'integration/luckycrax/RETOUR_ARRIERE_LUCKYCRAX.lua').read_text().replace('LuckyCrax','PolariCrax').replace('LuckyOwned','PolariOwned').replace('CraxLucky','CraxPolari').replace('Crax_Lucky','Crax_Polari');(OUT/'RETOUR_ARRIERE_POLARICRAX.lua').write_text(undo)
print('POLARI BUILD',len(ops),'live operations',len(modules),'new sources')
