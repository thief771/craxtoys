local checks=0;local function check(v,msg)checks+=1;assert(v,msg)end
local function near(a,b,msg)check(math.abs(a-b)<1e-5,msg..' '..tostring(a)..' '..tostring(b))end
check(C.Health==105 and C.Melee==8 and C.PileDamage==12 and C.FaceDamage==16,'validated stats')
check(R.Dice(2,5,C)==14 and R.Dice(3,3,C)==20 and R.Dice(6,6,C)==32,'dice examples')
local total=0;for a=1,6 do for b=1,6 do check(R.Dice(a,b,C)>=4 and R.Dice(a,b,C)<=32,'all36 damage outcomes');total+=1 end end;check(total==36,'all dice pairs')
local rewards={Heal=0,Coins=0,Cheat=0};for i=0,99999 do rewards[R.Reward((i+.5)/100000,C)]+=1 end
check(rewards.Heal==45000 and rewards.Coins==45000 and rewards.Cheat==10000,'100000 weighted server samples, no losing result')
local r=R.New(3,function(a,b)return(a+b)/2 end,C);r.time=100;check(R.Next(r,C)=='Coin','oldest ready serialized');r.cast={};check(R.Next(r,C)==nil,'no simultaneous launches');r.cast=nil
check(R.Received(r,'one',8,C)==false and R.Received(r,'one',8,C)==false and r.count==1,'continuous same activation counts once');R.Received(r,'two',8,C);check(R.Received(r,'three',8,C),'third attack readies clover');check(R.Dodge(r,C)and not R.Dodge(r,C),'one dodge only')
local bnd={minX=-1,maxX=1,minY=-1,maxY=1};local t,x,y=R.Wall(Vector2.zero,Vector2.new(10,10),bnd,.2);near(t,.1,'corner wall time');check(x and y,'corner one bounce, both components');near(R.Sweep(Vector2.new(0,0),Vector2.new(10,0),Vector2.new(5,0),1),.4,'continuous first impact')
local function tick(dt)now+=dt;M.Step(dt,fighters,true);for _,f in ipairs(fighters)do f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end end
local function advance(s)for i=1,math.floor(s*120+.5)do tick(1/120)end end
local function reset(level)
 M.Reset();a:SetAttribute('CraxId','Crax_Lucky');a:SetAttribute('CraxSkillLevel',level);a:SetAttribute('MaxHealth',105);b:SetAttribute('MaxHealth',100);b:SetAttribute('CraxId','Crax_Monster');b:SetAttribute('InvertedSilenced',false)
 fa.position=Vector2.new(0,25);fb.position=Vector2.new(13,25);for _,f in ipairs(fighters)do f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth))end
 state:SetAttribute('RoundId',state:GetAttribute('RoundId')+1);state:SetAttribute('Phase','Fighting');events={};M.Begin(fighters)
end
reset(0);advance(9);near(b:GetAttribute('Health'),88,'real health direct Pile12')
C.CoinFaceChance=1;reset(0);advance(9);near(b:GetAttribute('Health'),84,'real health Face16');C.CoinFaceChance=.5
reset(2);for i=1,3 do hits:Fire(b,a,8,true,'Collision',0);advance(.2)end;near(a:GetAttribute('Health'),81,'third hit actually lost');hits:Fire(b,a,20,false,'Ordinary');near(a:GetAttribute('Health'),81,'next admissible hit dodged');hits:Fire(b,a,20,false,'Ordinary');near(a:GetAttribute('Health'),61,'not global invulnerability')
reset(2);for i=1,3 do hits:Fire(b,a,.25,false,'SuperLaser',nil,77);advance(.05)end;check(not M.Dodge(a,10),'three microticks of one attack do not charge clover')
reset(2);for i=1,3 do hits:Fire(b,a,1,false,'SuperLaser',nil,100+i)end;local before=a:GetAttribute('Health');hits:Fire(b,a,1,false,'SuperLaser',nil,103);near(a:GetAttribute('Health'),before-1,'remaining ticks of third attack still suffered');hits:Fire(b,a,5,false,'SuperLaser',nil,104);near(a:GetAttribute('Health'),before-1,'charge dodges distinct fourth attack');hits:Fire(b,a,5,false,'SuperLaser',nil,104);near(a:GetAttribute('Health'),before-1,'fourth attack remains dodged across microticks')
reset(2);for i=1,3 do hits:Fire(b,a,1,false,'Ordinary')end;check(M.Dodge(a,1,b,'Next',9999),'three distinct noncontinuous legacy packets charge clover')
local coinWait=C.CoinWait;local diceWait=C.DiceWait;local reelWait=C.ReelsWait;local weights=C.Weights
C.CoinWait={100,100};C.DiceWait={.01,.01};C.ReelsWait={100,100};reset(1);tick(.02);C.DiceWait={100,100};advance(1.3);near(b:GetAttribute('Health'),88,'two server dice1+1 damage12 once, no bounce damage')
C.DiceWait={100,100};C.ReelsWait={.01,.01};C.Weights={Heal=100,Coins=0,Cheat=0};reset(3);hits:Fire(b,a,15,false,'Ordinary');tick(.02);C.ReelsWait={100,100};advance(1.85);near(a:GetAttribute('Health'),105,'90 plus25 capped105');local effective;for _,e in ipairs(events)do if e.kind=='Heal'then effective=e.data.Amount end end;near(effective,15,'actual15 heal published')
C.ReelsWait={.01,.01};reset(3);tick(.02);C.ReelsWait={100,100};advance(1.85);local full=false;for _,e in ipairs(events)do if e.kind=='Heal'and e.data.AtMax then full=true end end;check(full,'PV MAX without fake25')
C.ReelsWait={.01,.01};C.Weights={Heal=0,Coins=100,Cheat=0};reset(3);tick(.02);C.ReelsWait={100,100};advance(7);near(b:GetAttribute('Health'),70,'six coins maximum30 on one victim despite repeated bounces')
C.ReelsWait={.01,.01};C.Weights={Heal=0,Coins=0,Cheat=100};reset(3);tick(.02);C.ReelsWait={100,100};advance(1.85);check(b:GetAttribute('LuckyTricked'),'actual rare result applies suppression');check(not Silence.CanStart(b),'specials suppressed');near(fb.velocity.Magnitude,25,'ordinary movement not frozen')
b:SetAttribute('InvertedSilenced',true);advance(6.8);check(b:GetAttribute('LuckyTricked'),'still active before7');advance(.3);check(not b:GetAttribute('LuckyTricked')and not Silence.CanStart(b),'exact expiry retains independent Inverted silence');b:SetAttribute('InvertedSilenced',false);check(Silence.CanStart(b),'skills eligible after both independent suppressions end')
reset(0);b:SetAttribute('CraxId','Crax_BlackSpida');local ok,why=Supp.Apply(a,b,7,999);check(not ok and why:find('Annulation'),'unknown BlackSpida explicitly refused, not silently claimed supported')
M.Reset();check(not b:GetAttribute('LuckyTricked'),'reset removes only own suppression')
reset(2);for i=1,3 do hits:Fire(b,a,8,true,'Collision',0);advance(.2)end
local hp=a:GetAttribute('Health');hits:Fire(b,a,5,false,'SuperLaser',nil,909);hits:Fire(b,a,5,false,'SuperLaser',nil,909);near(a:GetAttribute('Health'),hp,'same dodged continuous activation remains entirely dodged');hits:Fire(b,a,5,false,'SuperLaser',nil,910);near(a:GetAttribute('Health'),hp-5,'next distinct activation is eligible again')
reset(2);for i=1,3 do hits:Fire(b,a,8,true,'Collision',0);advance(.2)end
local enemyHp=b:GetAttribute('Health');local ownHp=a:GetAttribute('Health');hits:Fire(b,a,8,true,'Collision',8);near(a:GetAttribute('Health'),ownHp,'collision defender dodge only');near(b:GetAttribute('Health'),enemyHp-8,'reverse ordinary collision still damages attacker')
reset(0);Supp.Register('Crax_Monster',function()end);local other=actor('OtherLucky',{Health=105});Supp.Apply(a,b,7,1);Supp.Apply(other,b,7,2);Supp.RemoveOwner(a);check(b:GetAttribute('LuckyTricked'),'one source removal preserves independent Triche');Supp.Step(6.9,true);check(b:GetAttribute('LuckyTricked'),'other source timer preserved');Supp.Step(.2,true);check(not b:GetAttribute('LuckyTricked'),'last source expiry clears only own flag')
C.CoinWait=coinWait;C.DiceWait=diceWait;C.ReelsWait=reelWait;C.Weights=weights
print('LUCKY RULES / REAL RUNTIME / REAL HEALTH PASS',checks,'assertions')
