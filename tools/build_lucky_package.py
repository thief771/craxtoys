"""LuckyCrax editor-safe integration. Exact current sources, guarded local edits, no old file restore."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'integration/luckycrax';SRC=ROOT/'src/luckycrax';ops=[]
RS='ReplicatedStorage.';SS='ServerScriptService.';SP='StarterPlayer.StarterPlayerScripts.'
def wrap(p,a):ops.append(dict(path=p,kind='wrap',addition=a))
def patch(p,items,prepend=''):ops.append(dict(path=p,kind='patch',prepend=prepend,replacements=[dict(before=a,after=('\n'+b.rstrip()+'\n')if a.startswith('\nreturn ')else b)for a,b in items]))
wrap(RS+'CraxCatalog',"""assert(not data.Crax_Lucky,'LuckyCrax existe déjà');local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local base=assert(data.Crax_Monster);local rare=assert(data.Crax_Spidey)
data.Crax_Lucky={DisplayName='LuckyCrax',Rarity=rare.Rarity,RarityColor=rare.RarityColor,TemplateName='Crax_Lucky',MaxHealth=105,CollisionDamage=8,Speed=base.Speed,Description='Tête de vinyle blanche, grand sourire et dents dorées du vrai CraxSourire.',PowerDescription='PILE OU FACE : tir direct 12 dégâts ou tir à deux rebonds 16 dégâts. Tirage serveur toutes les 6 à 9 secondes actives ; les pièces ne donnent pas de monnaie.',Effects={'LuckyCheat'},Ability={Id='LuckyCoin',DisplayName='PILE OU FACE',Damage=8,Cooldown=6}}""")
wrap(RS+'CraxSkillCatalog',"""local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local price=assert(data.Crax_Spidey).Upgrades
local list={{Id='LuckyDice',Name='DÉS PIPÉS',Description='Prototype : toutes les 12–16 s, deux dés indépendants de 1 à 6. Zone de rayon 5 ; 2 × somme, +8 sur un double. Une seule application par ennemi.'},{Id='LuckyClover',Name='PORTE-BONHEUR',Description='Prototype : après trois attaques distinctes ayant retiré des PV, prépare une esquive pour le prochain coup admissible. Une charge, durée 4 s. Le troisième coup est subi.'},{Id='LuckyJackpot',Name='JACKPOT',Description='Trois colonnes, exactement trois signes et toujours un triplet gagnant : soin nominal 25 plafonné à 105, six pièces à 5 dégâts vivant 4 s, ou Triche 7 s. Prototype : 45/45/10 %, délai 18–24 s.'},{Id='LuckyFinale',Name=C.MaxTitle,TrophyId=C.TrophyId,Description='Proposition MAX : LE GROS LOT. Scène de casino, vraie victime, combinaison gagnante et pluie de pièces purement cosmétiques. Aucun gain réel.'}}
for i,u in ipairs(list)do u.Coins=assert(price[i].Coins);u.Gems=assert(price[i].Gems)end
local order=0;for _,v in pairs(data)do if type(v)=='table'then order=math.max(order,v.Order or 0)end end
data.Crax_Lucky={Order=order+1,AbilityId='LuckyCoin',DisplayName='LuckyCrax',Enabled=true,Upgrades=list,Finale=list[4]}""")
wrap(RS+'CraxEffectsCatalog',"data.LuckyCheat={DisplayName='TRICHE',Description='Compétences interrompues et bloquées pendant 7 secondes actives ; déplacement et mêlée ordinaires conservés.',Duration=7,Icon='LuckyCheat',Image='',Color=Color3.fromRGB(168,90,225)}")
wrap(RS+'CraxVictoryCatalog',"local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);data.Crax_Lucky={Id='LuckyFinale',DisplayName=C.MaxTitle,TrophyId=C.TrophyId,TrophyColor=Color3.fromRGB(255,211,87),MinimumLevel=4,IntroDuration=0,Duration=C.Finale.End,ZoomDuration=0,HoldDuration=0}")
wrap(RS+'CraxRouletteConfig',"""local cat=require(game:GetService('ReplicatedStorage').CraxCatalog);local entries,total={},0
for _,e in ipairs(data.Pool)do assert(e.Id~='Crax_Lucky');if cat[e.Id].Rarity==cat.Crax_Lucky.Rarity then entries[#entries+1]=e;total+=e.Weight end end
assert(#entries>0 and total>0);local weight=total/(#entries+1);for _,e in ipairs(entries)do e.Weight=weight end;data.Pool[#data.Pool+1]={Id='Crax_Lucky',Weight=total-weight*#entries} -- prototype: equal redistribution of unchanged Rare mass
""")
wrap(SS+'CraxSkinServer',"""local appearance=require(game:GetService('ReplicatedStorage').CraxLuckyAppearance);local apply=data.Apply
function data.Apply(model,id,c)appearance.Restore(model);apply(model,id,c);if id=='Crax_Lucky'then appearance.Apply(model)end end""")
patch(RS+'CraxSilenceGate',[("model:GetAttribute('InvertedSilenced')~=true","model:GetAttribute('InvertedSilenced')~=true and model:GetAttribute('LuckyTricked')~=true")])
prefix="local LuckyV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxLuckyRuntime'))\n"
patch(SS+'ArenaMovement',[(" SymV1.Begin(fighters)"," SymV1.Begin(fighters)\n LuckyV1.Begin(fighters)"),("  SymV1.Step(step*Deadly.CinematicScale()", "  LuckyV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))\n  if LuckyV1.ClearWebs then clearWebs();LuckyV1.ClearWebs=false end\n  SymV1.Step(step*Deadly.CinematicScale()")],prefix)
patch(SS+'CombatHealth',[
 ('function(attacker,defender,damage,collision,kind,recoilSnapshot)','function(attacker,defender,damage,collision,kind,recoilSnapshot,attackId)'),
 ("local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end", "local a,b=states[attacker],states[defender];if not a or not b or a.health<=0 or b.health<=0 then return end\n if attacker:GetAttribute('LuckyTricked')and not collision then return end\n attackId=LuckyV1.AttackId(attacker,kind,attackId)"),
 ('local function protected(model)','local function protected(model)\n if model:GetAttribute("LuckyTricked")then return false end'),
 ('local function adjust(model,amount,kind)','local function adjust(model,amount,kind)\n if model:GetAttribute("LuckyTricked")then return amount end'),
 ('amount=Golden.Outgoing(attacker,amount)','amount=Golden.Outgoing(attacker,amount)\n if collision and attacker:GetAttribute("LuckyTricked")then amount=require(game:GetService("ReplicatedStorage").CraxCatalog)[attacker:GetAttribute("CraxId")].CollisionDamage end'),
 (' local incoming=collision and finite(recoil)'," if collision and defender:GetAttribute('LuckyTricked')then recoil=require(game:GetService('ReplicatedStorage').CraxCatalog)[defender:GetAttribute('CraxId')].CollisionDamage end\n local incoming=collision and finite(recoil)"),
 (' if amount>0 and amount>=b.health'," local luckyDef=LuckyV1.Dodge(defender,amount,attacker,kind,attackId);local luckyAtk=collision and LuckyV1.Dodge(attacker,incoming,defender,'Collision',nil)\n if luckyDef then amount=0 end;if luckyAtk then incoming=0 end\n if amount>0 and amount>=b.health"),
 ('local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)','if luckyDef then amount=0 end;if luckyAtk then incoming=0 end\n local lost=math.min(b.health,amount);local attackerLost=math.min(a.health,incoming)'),
 ('Fleau.CommitContact(attacker,defender,fleauAttackMode);Fleau.CommitContact(defender,attacker,fleauRecoilMode)','if not luckyDef then Fleau.CommitContact(attacker,defender,fleauAttackMode)end;if not luckyAtk then Fleau.CommitContact(defender,attacker,fleauRecoilMode)end '),
 ('SymV1.Confirm(attacker,defender,lost,attackerLost,collision);','LuckyV1.Confirm(attacker,defender,lost,attackerLost,collision,kind,attackId);SymV1.Confirm(attacker,defender,lost,attackerLost,collision);'),
 ('SymV1.Healed(model,r.health-before)','LuckyV1.Healed(model,r.health-before);SymV1.Healed(model,r.health-before)')],prefix)
patch(SS+'RoundManager', [('state:SetAttribute("RoundVictoryStartedAt",start)',"if model and model:GetAttribute('CraxId')=='Crax_Lucky'then state:SetAttribute('LuckyVictoryMatch',state:GetAttribute('CraxMatchToken'))end\n state:SetAttribute(\"RoundVictoryStartedAt\",start)")])
# Per-family cancellation; legacy global resets are gated to a single owner by Suppression.Apply.
patch(SS+'CraxSuperRuntime', [('\nreturn M\n',"""function M.LuckyAttackId(m,kind)local r=records[m];return r and r.cast and r.cast.id end
function M.CancelLucky(m)
 local r=records[m];if r then r.lastStandSpent=r.lastStand or r.lastStandSpent;r.lastStand=false;r.mode=nil;r.age=0;r.cast=nil;r.nextDash=r.time+randomDummy end
end
return M""".replace('r.nextDash=r.time+randomDummy',"r.nextDash=r.time+rand(C.DashWait[1],C.DashWait[2]);r.nextLaser=r.time+rand(C.LaserWait[1],C.LaserWait[2]);r.ready={};r.contacts=0;setMode(m,r);crystals[m]=nil\n for target,group in pairs(freezes)do if group[m]then releaseFreeze(target,m)end end;emit('OwnerClear',{Owner=m})")),
 ('if r.mode==\'Dash\'or r.lastStand then return 0 end',"if m:GetAttribute('LuckyTricked')then return amount end\n if r.mode=='Dash'or r.lastStand then return 0 end\n if r.lastStandSpent then return amount end"),
 ('if not r or not alive(a)or damage<=0 then return end','if not r or a:GetAttribute("LuckyTricked")or not alive(a)or damage<=0 then return end'),
 ('if r and r.lastStand and C.LastStandHealing', 'if r and(r.lastStand or r.lastStandSpent)and C.LastStandHealing'),
 ('if r then\n   if not alive(f.model)',"if r then\n   if f.model:GetAttribute('LuckyTricked')then continue end\n   if not alive(f.model)")])
patch(SS+'CraxSymRuntime', [('\nreturn M\n',"function M.LuckyAttackId(m,kind)local r=records[m];local a=r and(kind=='SymParasite'and r.parasite or r.attack);return a and a.id end\nfunction M.CancelLucky(m)local r=records[m];if r then clear(m,r);records[m]=nil end;for i=#pending,1,-1 do if pending[i].owner==m then table.remove(pending,i)end end end\nreturn M"),('if not live(owner)then return end','if not live(owner)or owner:GetAttribute("LuckyTricked")then return end'),('if not live(m)then return end;local r=get(m)','if not live(m)or m:GetAttribute("LuckyTricked")then return end;local r=get(m)'),('if r and not Gate.Paused(f.model)','if r and not f.model:GetAttribute("LuckyTricked")and not Gate.Paused(f.model)')])
patch(SS+'CraxInvertedRuntime', [('\nreturn M\n',"""function M.CancelLucky(m)
 local r=records[m];if r then r.mark=nil;r.pending=nil;r.count=0;r.markAttempted=true;r.nextMute=r.time+random(5,9);publish(m,r)end
 for target,s in pairs(statuses)do if s.owner==m then attrs(target,nil);statuses[target]=nil end end
 emit('Cancel',{Owner=m})
end
return M"""),('statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);attrs(m,statuses[m])','statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);statuses[m].owner=f.model;attrs(m,statuses[m])'),('local ra,rb=records[a],records[b]','local ra,rb=records[a],records[b];if a:GetAttribute("LuckyTricked")then ra=nil end;if b:GetAttribute("LuckyTricked")then rb=nil end'),('function M.Melee(m,normal)','function M.Melee(m,normal)if m:GetAttribute("LuckyTricked")then return normal end '),('if r then\n   local e=Rules.Advance','if r and not f.model:GetAttribute("LuckyTricked")then\n   local e=Rules.Advance')])
# Family reset APIs are available in these inspected modules.
for name in ['FantasticRuntime','CraxGoldenRuntime','CraxPlumberRuntime','FleauRuntime']:
 if name=='FleauRuntime':patch(SS+name,[('function M.Step(dt,fighters,enabled)','function M.Step(dt,fighters,enabled)\n for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Fleau"and f.model:GetAttribute("LuckyTricked")then return end end')])
patch(SS+'GhostyNight',[('\nreturn Night\n',"function Night.CancelLucky(m,fighters)local spent=escapes[m];Night.Reset(fighters);escapes[m]=spent;m:SetAttribute('GhostEscapeUsed',spent==true)end\nreturn Night")])
patch(SS+'CraxDeadlyRuntime', [('function M.Step(dt,fighters)',"""function M.CancelLucky(model)cleanup();M.luckyRestart=true end
function M.Step(dt,fighters)
 if M.luckyRestart then local blocked=false;for _,f in ipairs(fighters)do if f.model:GetAttribute('LuckyTricked')then blocked=true end end;if not blocked then start();M.luckyRestart=false end end"""),('for _,f in pairs(M.families)do\n', 'for _,f in pairs(M.families)do\n')])
# Remove an identity replacement: it would not be a meaningful unique anchor in Deadly.
ops[-1]['replacements']=ops[-1]['replacements'][:1]
patch(SS+'MonsterBiteAbilities', [('local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"','local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"and not f.model:GetAttribute("LuckyTricked")')])
patch(SP+'CraxBiteSmoothClient', [('if not allowed()or not f.head.Parent or f.model:GetAttribute("AbilityId")~="MonsterBite"then','if f.model:GetAttribute("LuckyTricked")or not allowed()or not f.head.Parent or f.model:GetAttribute("AbilityId")~="MonsterBite"then')])
icon="""local function luckyIconV1(parent,kind,x,y,size)
 local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);local key=({LuckyDice='Dice',LuckyClover='Clover',LuckyJackpot='Jackpot',LuckyFinale='Max'})[kind]
 local f=Instance.new('Frame');f.Size=UDim2.fromOffset(size,size);f.Position=UDim2.fromOffset(x,y);f.BackgroundTransparency=1;f.Parent=parent
 if C.Icons[key]~=''then local i=Instance.new('ImageLabel');i.Size=UDim2.fromScale(1,1);i.BackgroundTransparency=1;i.Image=C.Icons[key];i.ScaleType=Enum.ScaleType.Fit;i.ZIndex=5;i.Parent=f
 else local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.Text=({Dice='2 DÉS',Clover='CHANCE',Jackpot='JACKPOT',Max='MAX'})[key];t.Font=Enum.Font.FredokaOne;t.TextScaled=true;t.TextColor3=Color3.fromRGB(255,211,87);t.BackgroundTransparency=1;t.ZIndex=5;t.Parent=f end
 return f
end
"""
patch(SP+'CopEmClient',[('local function emblem(parent,kind,color,x,y,size)',"local function emblem(parent,kind,color,x,y,size)\n if type(kind)=='string'and kind:sub(1,5)=='Lucky'then luckyIconV1(parent,kind,x,y,size);return end"),('    if i==4 and currentCrax=="Crax_Symbioti"then','    if i==4 and currentCrax=="Crax_Lucky"then\n     if revealed then luckyIconV1(node,upgrade.Id,3,3,56)else local mark=text(node,"?",0,0,62,62,35,C.muted);mark.TextXAlignment=Enum.TextXAlignment.Center end\n    elseif i==4 and currentCrax=="Crax_Symbioti"then')],icon)
patch(RS+'CraxBookCinema', [('self.trophyArt:ClearAllChildren()',"""self.trophyArt:ClearAllChildren()
 if id=='Crax_Lucky'then local C=require(game:GetService('ReplicatedStorage').CraxLuckyConfig);if C.Icons.Max~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=C.Icons.Max,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(255,211,87),ZIndex=113},self.trophyArt)end;self.trophyIcon.TrophyTitle.Text=C.MaxTitle;return end""")])
patch(SP+'ArenaCamera', [('local function beginDefeat() -- FantasticExclusiveFinale_v4',"local function beginDefeat() -- FantasticExclusiveFinale_v4\n if state:GetAttribute('RoundVictoryKind')=='LuckyFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end"),('if player:GetAttribute("SymCameraOwner")then','if player:GetAttribute("LuckyCameraOwner")then if defeat then clearDefeat()end;return end\n  if player:GetAttribute("SymCameraOwner")then')])
for name,id in [('FantasticRuntime','Crax_Fantastic'),('CraxGoldenRuntime','Crax_Golden')]:
 before='function M.Step(dt,fighters)'if name=='FantasticRuntime'else'function M.Step(dt,fighters,active)'
 patch(SS+name,[(before,before+'\n for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="'+id+'"and f.model:GetAttribute("LuckyTricked")then return end end')])
patch(SS+'CraxPlumberRuntime',[('function M.Step(dt,enabled)','function M.Step(dt,enabled)\n for _,f in ipairs(fighters)do if f.model:GetAttribute("CraxId")=="Crax_Plumber"and f.model:GetAttribute("LuckyTricked")then return end end')])
patch(SS+'GhostyNight',[('function Night.Step(clock,dt,fighters,clearWebs)','function Night.Step(clock,dt,fighters,clearWebs)\n for _,f in ipairs(fighters)do if ghost(f)and f.model:GetAttribute("LuckyTricked")then return false end end')])
patch(SS+'FleauRuntime',[('local function rec(m)\n if not is(m)then return end','local function rec(m)\n if not is(m)or m:GetAttribute("LuckyTricked")then return end')])
patch(SS+'CraxSymRuntime', [('  if first then\n',"  if first and require(SSS.CraxLuckyRuntime).Dodge(first.model,C.Damage,f.model,'SymTongue',a.id)then a.mode='Return';a.age=0;emit('Miss',{Owner=f.model,Activation=a.id});return end\n  if first then\n"), ("if(p.position-t.position).Magnitude<=t.radius+.55 then p.mode='Attached';p.age=0;emit('ParasiteAttach',{Owner=f.model,Target=t.model,Activation=p.id})end","if(p.position-t.position).Magnitude<=t.radius+.55 then if require(SSS.CraxLuckyRuntime).Dodge(t.model,C.ParasiteDPS,f.model,'SymParasite',p.id)then p.mode='Return';p.age=0 else p.mode='Attached';p.age=0;emit('ParasiteAttach',{Owner=f.model,Target=t.model,Activation=p.id})end end")])
patch(SS+'CraxBurning', [('function M.Apply(attacker,target)',"function M.CancelLuckyOwner(owner)\n local Deadly=require(SSS.CraxDeadlyRuntime);local targets={};for target,r in pairs(records)do if r.attacker==owner or Deadly.Root(r.attacker)==owner then targets[#targets+1]=target end end;for _,target in ipairs(targets)do M.Clear(target)end\nend\nfunction M.Apply(attacker,target)\n if attacker and attacker:GetAttribute('LuckyTricked')then return false end")])
# Carry activation identities across asynchronous BindableEvent callbacks.
patch(SS+'CraxSuperRuntime',[("false,'SuperDash')","false,'SuperDash',nil,tostring(cast.id)..':'..turn)"),("false,'SuperLaser')","false,'SuperLaser',nil,cast.id)")])
patch(SS+'CraxSymRuntime',[("false,'SymTongue')","false,'SymTongue',nil,a.id)"),("false,'SymParasite')","false,'SymParasite',nil,p.id)")])
patch(SS+'CraxBurning', [('false,"Burning")','false,"Burning",nil,tostring(r))')])
patch(SS+'CraxSpideyRuntime',[('false,"SpideyPoison")','false,"SpideyPoison",nil,tostring(p))')])
patch(SS+'FantasticRuntime',[("false,'FantasticElastic')","false,'FantasticElastic',nil,h.id)"),("   if chosen then enemy=chosen end", "   if chosen and require(SSS.CraxLuckyRuntime).Dodge(chosen.model,2,r.f.model,'FantasticElastic',h.id)then h.stage='return';h.index=#h.path;return end\n   if chosen then enemy=chosen end")])
patch(SS+'GhostyNight',[('false,"GhostBleed")','false,"GhostBleed",nil,tostring(bleed))'),('false,"GhostSlash")','false,"GhostSlash",nil,record.sequence)'),('    if amount>0 then spent[target]', '    local luckyMiss=amount>0 and require(SSS.CraxLuckyRuntime).Dodge(target,amount,owner,"GhostSlash",record.sequence)\n    if amount>0 then spent[target]'),('if numeric(target,"Health",0)>0 and not bleeds[target]','if not luckyMiss and numeric(target,"Health",0)>0 and not bleeds[target]')])
patch(SS+'CraxBurning',[('local M={};local records={}','local M={};local records={};local luckySerial=0'),('else record={attacker=attacker,remaining=3,tick=0,round=state:GetAttribute("RoundId")};records[target]=record end','else luckySerial+=1;record={attacker=attacker,remaining=3,tick=0,round=state:GetAttribute("RoundId"),luckyAttackId=luckySerial};records[target]=record end'),('nil,tostring(r))','nil,r.luckyAttackId)')])
patch(SS+'CraxSpideyRuntime',[(' poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4}',' serial+=1;poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4,luckyAttackId=serial}'),('nil,tostring(p))','nil,p.luckyAttackId)')])
patch(SS+'GhostyNight',[('bleeds[target]={source=owner,timer=0,remaining=10}','bleeds[target]={source=owner,timer=0,remaining=10,luckyAttackId=record.sequence}'),('nil,tostring(bleed))','nil,bleed.luckyAttackId)')])
# Merge edits to one source into one editor transaction entry.
merged=[];by={}
for op in ops:
 if op['path']in by:
  prior=by[op['path']];assert prior['kind']==op['kind']=='patch';prior['replacements']+=op['replacements'];prior['prepend']+=op.get('prepend','')
 else:merged.append(op);by[op['path']]=op
ops=merged
# Current canonical sources: published Sym changes, then prior Inverted patches, then inspected export.
fixture=ROOT/'tests/fixtures/lucky-inspected-sources.json'
if fixture.exists():
 base=json.loads(fixture.read_text());lookup={}
 if any(op['path']not in base for op in ops):
  report=json.loads(Path('/workspace/invertedcrax/current/report.json').read_text());lookup={x['path']:x['source']for x in report['scripts']}
 for op in ops:
  if op['path']not in base:base[op['path']]=lookup[op['path']]
 fixture.write_text(json.dumps(base,ensure_ascii=False,indent=2))
else:
 report=json.loads(Path('/workspace/invertedcrax/current/report.json').read_text());lookup={s['path']:s['source']for s in report['scripts']};base={}
 for name,folder in [('CraxSuperRuntime','supercrax'),('CraxSymRuntime','symbioticrax'),('CraxInvertedRuntime','invertedcrax'),('CraxSilenceGate','invertedcrax')]:lookup[(RS if name=='CraxSilenceGate'else SS)+name]=(ROOT/'src'/folder/(name+'.lua')).read_text()
 for op in ops:
  p=ROOT/'integration/symbioticrax/review'/('/'.join(op['path'].split('.'))+'.lua');q=ROOT/'integration/invertedcrax/patched'/('/'.join(op['path'].split('.'))+'.lua')
  base[op['path']]=p.read_text()if p.exists()else(q.read_text()if q.exists()else lookup[op['path']])
 # Owned runtime modules are current source files, not old inspected copies.
 for name,folder in [('CraxSuperRuntime','supercrax'),('CraxSymRuntime','symbioticrax'),('CraxInvertedRuntime','invertedcrax')]:base[SS+name]=(ROOT/'src'/folder/(name+'.lua')).read_text()
 fixture.write_text(json.dumps(base,ensure_ascii=False,indent=2))
def apply(s,op):
 if op['kind']=='wrap':return '-- LuckyCraxIntegrationV1\nlocal data=(function()\n'+s+'\nend)()\n'+op['addition']+'\nreturn data\n'
 for r in op['replacements']:
  assert s.count(r['before'])==1,(op['path'],r['before'][:100],s.count(r['before']))
  s=s.replace(r['before'],r['after'],1)
 return '-- LuckyCraxIntegrationV1\n'+op.get('prepend','')+s
written=set()
for op in ops:
 p=OUT/'review'/('/'.join(op['path'].split('.'))+'.lua');p.parent.mkdir(parents=True,exist_ok=True);p.write_text(apply(p.read_text()if op['path']in written else base[op['path']],op));written.add(op['path'])
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
 name=p.name.removesuffix('.client.lua').removesuffix('.lua');service=SP if p.name.endswith('.client.lua')else(SS if name in ['CraxLuckyRuntime','CraxLuckySuppression','CraxLuckyAdapters']else RS)
 modules.append(dict(path=service+name,className='LocalScript'if p.name.endswith('.client.lua')else'ModuleScript',source=p.read_text()))
expected=json.loads((ROOT/'assets/luckycrax/model/manifest.json').read_text())['fx']
# Share the already tested editor transaction and conflict-preserving rollback mechanics.
sym=(ROOT/'integration/symbioticrax/INSTALLER_SYMBIOTICRAX.lua').read_text();body=sym[sym.index("local backupName="):]
body=body.replace('SymbiotiCrax','LuckyCrax').replace('SymOwned','LuckyOwned').replace('CraxSym','CraxLucky').replace('Crax_Symbioti','Crax_Lucky')
body=body.replace("local selected=game:GetService('Selection'):Get();assert(#selected==1,'Sélectionner une seule racine de LuckyCrax_ACCESSOIRES_IMPORT.fbx')\nlocal imported=selected[1];", "local imported=assert(SS:FindFirstChild('LuckyCrax_Import'),'Importer LuckyCrax_FX_IMPORT.fbx puis placer sa racine sous ServerStorage avec le nom LuckyCrax_Import.');")
body=body.replace("p.Name:match('^Sym')", "p.Name:match('^LFX_')").replace('FIT_HeadCenter','LFX_Origin').replace('FIT_Front','LFX_Front').replace('FIT_Up','LFX_Up').replace('appearance.Apply(template,assets)','appearance.Apply(template)').replace("template:SetAttribute('AbilityId','SymTongue')", "template:SetAttribute('AbilityId','LuckyCoin')")
# The earlier marker remains distinct from the new integration marker.
body=body.replace('-- LuckyCraxIntegrationV1','-- LuckyCraxIntegrationV1')
header="""-- LUCKYCRAX. STOP. ServerStorage.LuckyCrax_Import doit contenir la bibliothèque FBX publiée.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local ops="""+lua(ops)+'\nlocal modules='+lua(modules)+'\nlocal expected='+lua(expected)+'\n'
(OUT/'INSTALLER_LUCKYCRAX.lua').write_text(header+body)
undo=(ROOT/'integration/symbioticrax/RETOUR_ARRIERE_SYMBIOTICRAX.lua').read_text().replace('SymbiotiCrax','LuckyCrax').replace('SymOwned','LuckyOwned').replace('CraxSym','CraxLucky').replace('Crax_Symbioti','Crax_Lucky')
(OUT/'RETOUR_ARRIERE_LUCKYCRAX.lua').write_text(undo)
print('LUCKY BUILD',len(ops),'live operations',len(modules),'new modules')
