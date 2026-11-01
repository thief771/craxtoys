local checks=0
local function check(v,m)checks+=1;assert(v,m)end
local runtime=Runtime
runtime.SetHealth=function(m,hp,round)check(round==state:GetAttribute('RoundId'),'restore current round');m:SetAttribute('Health',hp)end
runtime.Begin(fighters)
local function advance(seconds)
 local n=math.floor(seconds*120+.5)
 for i=1,n do now+=1/120;runtime.Step(1/120,fighters,true)end
end
advance(7.02)
check(b:GetAttribute('InvertedSilenced')==true,'server applied SILENCE')
check(not Silence.CanStart(b),'gate sees replicated status')
check(b:GetAttribute('Health')==100,'wave has no direct damage')
check(b:GetAttribute('InvertedVulnerable')==true,'level1 vulnerability')
check(math.abs(fb.velocity.Magnitude-20)<1e-7,'hack preserves speed')
check(fb.velocity.X<0,'server changes direction')
local radius
for _,e in ipairs(log)do if e.kind=='Mute'then radius=e.data.Radius end end
check(radius==24,'radius half actual inner wall width, 48/2')
check(runtime.Final(b,runtime.Vulnerable(b,8),a)==9,'single vulnerability and final rounding')
check(runtime.Final(b,runtime.Vulnerable(b,12),a)==13,'copied12 becomes13')
check(runtime.Final(b,0,a)==0,'protection zero remains zero')
-- Vulnerability is applied BEFORE a protection cap, then the final result is rounded.
local protected=math.min(runtime.Vulnerable(b,100),b:GetAttribute('Health')-1)
check(runtime.Final(b,protected,a)==99,'anti-lethal cap not bypassed')
runtime.Confirm(b,a,25,0,true);runtime.Confirm(b,a,40,0,true);runtime.Confirm(b,a,12,0,true)
check(a:GetAttribute('InvertedCopyAmount')==12,'runtime third melee 12, not max40')
check(runtime.Melee(a,8)==12,'runtime copy replaces base')
runtime.Confirm(a,b,0,0,true);check(a:GetAttribute('InvertedCopyReady')==true,'blocked impact preserves copy')
runtime.Confirm(a,b,12,0,true);check(not a:GetAttribute('InvertedCopyReady')and a:GetAttribute('InvertedCopyCount')==0,'confirmed impact consumes')
advance(2.9);a:SetAttribute('Health',95);fa.position=Vector2.new(2,26);advance(.1)
local marked
for _,e in ipairs(log)do if e.kind=='Mark'then marked=e.data.Position end end
check(marked and marked.X==2 and marked.Y==26,'server stores internal position at10')
a:SetAttribute('Health',30);fa.position=Vector2.new(15,35)
advance(9.98)
check(a:GetAttribute('Health')==95 and fa.position.X==2 and fa.position.Y==26,'server restores HP and actual motion at20')
check(fa.model.pivot~=nil,'visual pivot synchronized')
runtime.Reset();check(not b:GetAttribute('InvertedSilenced')and not b:GetAttribute('InvertedHacked'),'round clears statuses')
state:SetAttribute('RoundId',2);a:SetAttribute('Health',120);runtime.Begin(fighters);log={};advance(10.1);a:SetAttribute('Health',0);advance(10)
local restored=false;for _,e in ipairs(log)do if e.kind=='Restore'then restored=true end end
check(not restored and a:GetAttribute('Health')==0,'dead fighter never resurrected')
print('REAL RUNTIME FIXTURE PASS',checks,'assertions')
return checks
