local R={}
function R.New(level,random,c)return{level=math.clamp(level,0,4),time=0,nextTongue=random(c.Wait[1],c.Wait[2]),nextParasite=random(c.ParasiteWait[1],c.ParasiteWait[2]),lost=0,armourUntil=0,marks={}}end
function R.Mark(r,target,loss,c)
 if r.level<1 or loss<=0 then return 0,false end
 local mark=r.marks[target];if not mark or mark.expires<=r.time then mark={count=0};r.marks[target]=mark end
 mark.count+=1;mark.expires=r.time+c.MarkDuration
 if mark.count>=3 then r.marks[target]=nil;return 0,true end
 return mark.count,false
end
function R.Lost(r,loss,c,canStart)
 if r.level<2 or loss<=0 or r.time<r.armourUntil then return false end
 r.lost=math.min(c.ArmourThreshold,r.lost+loss)
 if r.lost>=c.ArmourThreshold and canStart then r.lost=0;r.armourUntil=r.time+c.ArmourDuration;return true end
 return false
end
function R.Reduce(r,amount,c)return r and r.time<r.armourUntil and amount*(1-c.ArmourReduction)or amount end
function R.Sweep(a,b,p,r)
 local v=b-a;local offset=a-p;local rr=r*r;local c=offset:Dot(offset)-rr
 if c<=0 then return true,0 end
 local aa=v:Dot(v);if aa<1e-12 then return false end
 local bb=2*offset:Dot(v);local d=bb*bb-4*aa*c;if d<0 then return false end
 local t=(-bb-math.sqrt(d))/(2*aa);return t>=0 and t<=1,t
end
function R.StepTowards(a,b,budget)local d=b-a;local l=d.Magnitude;if l<1e-8 then return b end;return a+d*(math.min(l,budget)/l)end
function R.FitDistance(width,height,depth,aspect,fov)return math.max(height,width/math.max(.2,aspect))/(2*math.tan(math.rad(fov*.5)))*1.10+depth*.5 end
return R
