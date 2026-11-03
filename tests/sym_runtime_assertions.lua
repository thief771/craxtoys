local checks=0;local function check(v,msg)checks+=1;assert(v,msg)end
local function near(a,b,msg)check(math.abs(a-b)<1e-6,msg..' '..tostring(a)..' vs '..tostring(b))end
local function tick(dt)
 now+=dt;M.Step(dt,fighters,true)
 for _,f in ipairs(fighters)do Locks.Enforce(f);f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
end
local function advance(t)for i=1,math.floor(t*120+.5)do tick(1/120)end end
local function reset(level)
 M.Reset();a:SetAttribute('CraxId','Crax_Symbioti');a:SetAttribute('CraxSkillLevel',level);a:SetAttribute('InvertedSilenced',false);a:SetAttribute('MaxHealth',125);b:SetAttribute('MaxHealth',100)
 fa.position=Vector2.new(0,25);fb.position=Vector2.new(13,25);fa.velocity=Vector2.new(25,0);fb.velocity=Vector2.new(25,0)
 state:SetAttribute('RoundId',state:GetAttribute('RoundId')+1);state:SetAttribute('Phase','Fighting');for _,f in ipairs(fighters)do f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
 events={};hitLog={};M.Begin(fighters)
end
reset(0);advance(12)
near(b:GetAttribute('Health'),84,'real tongue bite16 without extra8');near(a:GetAttribute('Health'),125,'no fake recoil');check(not M.Held(a)and not M.Held(b)and not Gate.Paused(b),'capture fully released');check(fb.position.X>=8 and fb.position.X<13,'target pulled progressively')
reset(0);fb.position=Vector2.new(21,40);advance(10.4);b:SetAttribute('Health',0);tick(.01);check(not M.Held(a)and not M.Held(b),'invalid target cleans capture')
reset(1);a:SetAttribute('Health',100); -- authoritative health stays125, so use actual incoming hit to prepare healing
hits:Fire(b,a,25,false,'Ordinary');for i=1,3 do hits:Fire(a,b,8,true,'Collision',0)end
near(b:GetAttribute('Health'),76,'three normal hits before queued burst');tick(.01);near(b:GetAttribute('Health'),61,'one extra15 explosion');near(a:GetAttribute('Health'),105,'actual heal5 through health pipeline');tick(.01);near(b:GetAttribute('Health'),61,'no repeated explosion or self marking')
reset(1);b:SetAttribute('GhostInvulnerable',true);for i=1,3 do hits:Fire(a,b,8,true,'Collision',0)end;tick(.01);near(b:GetAttribute('Health'),100,'blocked melee adds no marks');b:SetAttribute('GhostInvulnerable',false)
reset(1);a:SetAttribute('InvertedSilenced',true);for i=1,3 do hits:Fire(a,b,8,true,'Collision',0)end;tick(.01);near(b:GetAttribute('Health'),76,'SILENCE defers new burst');a:SetAttribute('InvertedSilenced',false);tick(.01);near(b:GetAttribute('Health'),61,'pending burst runs once after silence')
reset(2);hits:Fire(b,a,30,false,'Ordinary');near(a:GetAttribute('Health'),95,'threshold hit not reduced retroactively');check(a:GetAttribute('SymArmour'),'armour triggered from actual30 loss');hits:Fire(b,a,20,false,'Ordinary');near(a:GetAttribute('Health'),82,'35 percent reduction exactly once');check(a:GetAttribute('SymLost')==0,'no recharge during armour');advance(4.02);check(not a:GetAttribute('SymArmour'),'armour expires');hits:Fire(b,a,10,false,'Ordinary');near(a:GetAttribute('Health'),72,'ordinary damage after expiry');check(a:GetAttribute('SymLost')==10,'recharge resumes')
reset(2);a:SetAttribute('InvertedSilenced',true);hits:Fire(b,a,30,false,'Ordinary');check(not a:GetAttribute('SymArmour'),'silence prevents new armour');a:SetAttribute('InvertedSilenced',false)
reset(2);hits:Fire(b,a,200,false,'Ordinary');check(a:GetAttribute('Health')==0 and state:GetAttribute('RoundWinner')=='Fighter2','armour does not rescue a lethal hit')
local oldWait=C.ParasiteWait;C.ParasiteWait={.1,.1}
reset(3);hits:Fire(b,a,20,false,'Ordinary');advance(4.2);near(b:GetAttribute('Health'),91,'actual fractional parasite ticks total9');near(a:GetAttribute('Health'),110,'parasite returns and heals5');near(M.Speed(b),1,'slow removed after return');C.ParasiteWait=oldWait
reset(0);advance(10.45);Locks.Lock(fb,'Fantastic');advance(.2);check(not M.Held(a),'external lock interrupts pull');check(fb.velocity.Magnitude==0,'external lock remains');Locks.Unlock(fb,'Fantastic');check(fb.velocity.Magnitude>0,'last lock restores motion')
reset(0);fa.position=Vector2.new(19,39);fb.position=Vector2.new(15,36);advance(12);check(fa.position.X<=20 and fa.position.Y<=41 and fb.position.X<=20 and fb.position.Y<=41,'capture respects arena margins')
reset(1);for i=1,3 do hits:Fire(a,b,8,true,'Collision',0)end;a:SetAttribute('CraxId','Crax_Monster');tick(.01);near(b:GetAttribute('Health'),76,'queued contamination cancelled on owner character change')
local oldRange=C.Range;C.Range=1;reset(0);advance(11);near(b:GetAttribute('Health'),100,'missed short tongue deals zero');check(not M.Held(a)and not Gate.Paused(b),'miss retracts without controls');C.Range=oldRange
reset(0);advance(10.7);hits:Fire(b,a,200,false,'Burning');tick(.01);check(not M.Held(a)and not M.Held(b)and not Gate.Paused(b),'caster death releases target immediately')
C.ParasiteWait={.1,.1};reset(3);hits:Fire(b,a,20,false,'Ordinary');b:SetAttribute('GhostInvulnerable',true);advance(4.2);near(a:GetAttribute('Health'),105,'fully blocked parasite yields no heal');near(b:GetAttribute('Health'),100,'invulnerability respected by parasite');b:SetAttribute('GhostInvulnerable',false);C.ParasiteWait=oldWait
M.Reset();check(not M.Held(a)and not M.Held(b)and M.Speed(b)==1,'reset cleans modifiers and controls')
print('SYM REAL RUNTIME + REAL HEALTH PASS',checks,'assertions')
