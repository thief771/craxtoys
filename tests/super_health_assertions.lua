local n=0;local function check(v,msg)n+=1;assert(v,msg)end
local function reset()
 M.Reset();a:SetAttribute('CraxId','Crax_Super');a:SetAttribute('CraxSkillLevel',3);a:SetAttribute('InvertedSilenced',false)
 fa.position=Vector2.new(0,25);fb.position=Vector2.new(-12,15);for _,f in ipairs(fighters)do f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
 state:SetAttribute('RoundId',state:GetAttribute('RoundId')+1);state:SetAttribute('Phase','Fighting');M.Begin(fighters)
end
reset()
for i=1,150 do hits:Fire(a,b,15/60,false,'SuperLaser')end
check(math.abs(b:GetAttribute('Health')-62.5)<1e-7,'actual CombatHealth retains fractional 37.5 laser loss')
hits:Fire(b,a,200,false,'Ordinary');check(a:GetAttribute('Health')==1,'actual health intercepts death before round result');check(state:GetAttribute('Phase')=='Fighting','last stand does not finish round')
heals:Fire(a,90);check(a:GetAttribute('Health')==1,'actual healing callback strictly blocks heal')
hits:Fire(b,a,200,false,'Burning');check(a:GetAttribute('Health')==1,'actual periodic damage blocked')
check(not M.KillHealthBatch({{model=a,carrier=b,token='invented'}},state:GetAttribute('RoundId'),'match-test'),'forged kryptonite proof rejected');check(a:GetAttribute('Health')==1,'invalid proof preserves health')
reset();a:SetAttribute('InvertedSilenced',true);hits:Fire(b,a,200,false,'Ordinary');check(a:GetAttribute('Health')==0,'silence prevents first rescue');check(state:GetAttribute('RoundWinner')=='Fighter2','normal round winner preserved')
reset();a:SetAttribute('CraxSkillLevel',0);M.Reset();M.Begin(fighters);hits:Fire(a,b,8,true,'Collision',8);check(a:GetAttribute('Health')==92 and b:GetAttribute('Health')==92,'ordinary collision and recoil unchanged')
local function tick(dt)now+=dt;M.Step(dt,fighters,true);for _,f in ipairs(fighters)do Locks.Enforce(f);f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end end
local function advance(t)for i=1,math.floor(t*120+.5)do tick(1/120)end end
reset();a:SetAttribute('CraxSkillLevel',2);M.Reset();M.Begin(fighters)
for i=1,3 do hits:Fire(a,b,8,true,'Collision',8)end
advance(2.04);check(b:GetAttribute('SuperFrozen')==true,'real contact pipeline triggers frost on third melee')
local before=b:GetAttribute('Health');hits:Fire(a,b,8,true,'Collision',8);check(before-b:GetAttribute('Health')==35,'actual shatter loss is35 instead of8');check(not b:GetAttribute('SuperFrozen'),'actual health confirmation consumes freeze');advance(.2);check(not b:GetAttribute('SuperFrozen'),'same actual cast cannot refreeze')
reset();hits:Fire(b,a,200,false,'Ordinary');local stone
for _,e in ipairs(events)do if e.kind=='Crystal'then stone=e.data end end
fb.position=Vector2.new(stone.Position.X,stone.Position.Y);tick(.001);check(M.Speed(b)==1.5,'real health laststand creates collectible crystal')
fb.position=fa.position;tick(.001);check(a:GetAttribute('Health')==0,'actual health kill hook commits kryptonite death');check(state:GetAttribute('RoundWinner')=='Fighter2'and state:GetAttribute('Phase')=='RoundOver','kryptonite uses ordinary round result');check(M.Speed(b)==1,'real result releases carrier speed')
print('SUPER REAL COMBAT HEALTH PASS',n,'assertions')
