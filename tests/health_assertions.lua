local n=0
local function check(v,m)n+=1;assert(v,m)end
Runtime.Begin(fighters)
hits:Fire(b,a,5,true,'Collision',0);hits:Fire(b,a,20,true,'Collision',0);hits:Fire(b,a,12,true,'Collision',0)
check(a:GetAttribute('Health')==83,'actual health table applies received hits')
check(a:GetAttribute('InvertedCopyAmount')==12,'actual damage pipeline captures third12')
hits:Fire(a,b,nil,true,'Collision',0)
check(b:GetAttribute('Health')==88,'copy12 replaces8, not20')
check(not a:GetAttribute('InvertedCopyReady'),'copy consumed by actual successful impact')
for i=1,843 do now+=1/120;Runtime.Step(1/120,fighters,true)end
check(b:GetAttribute('InvertedVulnerable')==true,'pulse status present in real health test')
hits:Fire(a,b,nil,true,'Collision',0)
check(b:GetAttribute('Health')==79,'vulnerability applied once: 8 -> 9')
a:SetAttribute('FantasticReinforced',true);outgoing=1.5
local before=a:GetAttribute('Health');hits:Fire(b,a,3,true,'Collision',0)
check(a:GetAttribute('Health')==before-2,'round AFTER modifiers: 3*1.5*.5=2.25 ->2')
a:SetAttribute('FantasticReinforced',nil);outgoing=1
hits:Fire(b,a,1,true,'Collision',0);hits:Fire(b,a,1,true,'Collision',0)
check(a:GetAttribute('InvertedCopyReady')==true,'next received cycle charged')
b:SetAttribute('DeadlyInvulnerable',true);before=b:GetAttribute('Health');hits:Fire(a,b,nil,true,'Collision',0)
check(b:GetAttribute('Health')==before,'invulnerability creates no damage')
check(a:GetAttribute('InvertedCopyReady')==true,'invulnerable target does not consume copy')
b:SetAttribute('DeadlyInvulnerable',nil)
Runtime.SetHealth(a,95,1);heals:Fire(a,1)
check(a:GetAttribute('Health')==96,'CTRL setter changes internal health, not just displayed attribute')
check(state:GetAttribute('HealthReady')==true,'actual health script completes initialization')
print('ACTUAL COMBAT HEALTH + RUNTIME PASS',n,'assertions');return n
