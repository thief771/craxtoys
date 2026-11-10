-- Vérifie les valeurs du cahier des charges sur le vrai runtime.
local C=modules_config
local pass=0;local function ok(c,msg)assert(c,msg);pass+=1 end

-- Base · Morsure lente : 3 collisions -> 5 ticks de 2 = 10 dégâts.
VENI.Begin(fighters)
for i=1,3 do setNow(clock()+.5);VENI.Confirm(veni,foe,5,5,true,nil)end
ok(hasEvent('Poison'),'poison appliqué après 3 collisions')
advance(5.2)
local n,total=count('VeniPoison');ok(n==5 and total==10,('Morsure lente : 5 ticks / 10 dégâts, obtenu %d / %d'):format(n,total))
ok(hasEvent('PoisonEnd'),'fin du poison signalée')

-- 2 collisions seulement : pas de poison ; collisions trop rapprochées : comptées une fois.
reset();VENI.Begin(fighters);setNow(clock()+1);VENI.Confirm(veni,foe,5,5,true,nil);VENI.Confirm(foe,veni,5,5,true,nil);setNow(clock()+.5);VENI.Confirm(veni,foe,5,5,true,nil)
ok(not hasEvent('Poison'),'fenêtre anti-doublon des collisions')

-- N1 · Cobra Ricochet : 5 à l'impact puis 3 PV/s pendant 3 s = 14.
reset();veni:SetAttribute('CraxSkillLevel',1);VENI.Begin(fighters)
advance(4)
local cobra=hasEvent('Cobra');ok(cobra,'cobra craché au niveau 1')
ok(cobra.d.Wall~=nil,'le cobra vise un mur (ricochet)')
ok(hasEvent('CobraBounce'),'le cobra rebondit sur un mur')
local impact=hasEvent('CobraImpact');ok(impact,'le cobra touche la cible après ricochet')
-- La confirmation de CombatHealth déclenche le poison du cobra.
VENI.Confirm(veni,foe,5,0,false,'VeniCobra')
local before=select(2,count('VeniPoison'));local nCobra=count('VeniCobra')
fired={};advance(3.1)
local _,cobraPoison=count('VeniPoison')
ok(nCobra>=1,'impact du cobra envoyé à BiteHit')
ok(cobraPoison==9,('poison du cobra : 9 sur 3 s, obtenu %d'):format(cobraPoison))

-- N2 · Distillation : après 5 pertes de poison, rebond mural = +8 PV, recharge 15 s.
reset();veni:SetAttribute('CraxSkillLevel',2);VENI.Begin(fighters);advance(.1)
VENI.WallContact(veni,'Left');ok(#heals==0,'pas de soin avant 5 pertes de poison')
for i=1,5 do VENI.Confirm(veni,foe,2,0,false,'VeniPoison')end
ok(hasEvent('DistillReady'),'Distillation armée après 5 pertes')
VENI.WallContact(veni,'Left');ok(#heals==1 and heals[1].amount==8,'soin de 8 au rebond mural')
for i=1,5 do VENI.Confirm(veni,foe,2,0,false,'VeniPoison')end
VENI.WallContact(veni,'Top');ok(#heals==1,'recharge de 15 s respectée')
advance(15.1);VENI.WallContact(veni,'Top');ok(#heals==2,'nouveau soin après la recharge')

-- N3 · Mue toxique : contact -> cercle, nuage 0,7 s après, Morsure lente appliquée.
reset();veni:SetAttribute('CraxSkillLevel',3);fighters[2].position=Vector2.new(15,10);VENI.Begin(fighters)
advance(6.1)
local molt=hasEvent('Molt');ok(molt,'mue déposée au niveau 3')
ok(not hasEvent('MoltTrigger'),'la mue attend un contact')
fighters[2].position=Vector2.new(molt.d.Position.X+1,molt.d.Position.Y)
advance(.05);ok(hasEvent('MoltTrigger'),'cercle au contact de la mue')
advance(.5);ok(not hasEvent('MoltCloud'),'pas de nuage avant 0,7 s')
advance(.25);local cloud=hasEvent('MoltCloud');ok(cloud and #cloud.d.Targets==1,'nuage à 0,7 s qui touche la cible')
local p;for _,e in ipairs(events)do if e.k=='Poison'and e.d.Kind=='Bite'then p=e end end;ok(p,'le nuage applique Morsure lente')

-- Élimination par poison : marquée pour l'exécution MAX.
reset();VENI.Begin(fighters);foe:SetAttribute('Health',0);VENI.Confirm(veni,foe,2,0,false,'VeniPoison')
ok(state:GetAttribute('VeniPoisonKillRound')==1 and state:GetAttribute('VeniPoisonKillMatch')=='T1','kill par poison enregistré')
foe:SetAttribute('Health',100)

-- Changement de manche : tout est nettoyé.
reset();VENI.Begin(fighters);for i=1,3 do setNow(clock()+.5);VENI.Confirm(veni,foe,5,5,true,nil)end
state:SetAttribute('RoundId',2);fired={};advance(2);ok(count('VeniPoison')==0,'poison effacé au changement de manche')

print('VENI RUNTIME PASS',pass,'assertions')
