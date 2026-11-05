local R={}
function R.NearestWall(p,b)
 local sides={{id='Left',d=p.X-b.minX,n=Vector2.new(1,0)},{id='Right',d=b.maxX-p.X,n=Vector2.new(-1,0)},{id='Bottom',d=p.Y-b.minY,n=Vector2.new(0,1)},{id='Top',d=b.maxY-p.Y,n=Vector2.new(0,-1)}}
 local best=sides[1];for i=2,4 do if sides[i].d<best.d then best=sides[i]end end;return best.id,best.n
end
function R.Turn(v,to,rate,dt)
 if v.Magnitude<1e-8 then return v end;local d=v.Unit:Lerp(to.Unit,1-math.exp(-rate*dt));return(d.Magnitude>1e-8 and d.Unit or to.Unit)*v.Magnitude
end
function R.Repel(p,n,b,speed,angle)
 local center=Vector2.new((b.minX+b.maxX)*.5,(b.minY+b.maxY)*.5);local tangent=Vector2.new(-n.Y,n.X);local sign=(center-p):Dot(tangent)>=0 and 1 or-1;return(n*math.cos(angle)+tangent*math.sin(angle)*sign).Unit*speed
end
function R.Sweep(a,b,p,r)
 local v=b-a;local d=a-p;local cc=d:Dot(d)-r*r;if cc<=0 then return 0 end;local aa=v:Dot(v);if aa<1e-12 then return end;local bb=2*d:Dot(v);local disc=bb*bb-4*aa*cc;if disc<0 then return end;local t=(-bb-math.sqrt(disc))/(2*aa);if t>=0 and t<=1 then return t end
end
function R.Fan(center,forward,radius,count)
 local axis=forward.Magnitude>1e-8 and forward.Unit or Vector2.new(1,0);local out={}
 for i=1,count do local angle=(i-(count+1)*.5)*.22;local d=Vector2.new(axis.X*math.cos(angle)-axis.Y*math.sin(angle),axis.X*math.sin(angle)+axis.Y*math.cos(angle));out[i]={position=center-d*radius,direction=d}end;return out
end
function R.TouchWall(side,p,r,b)
 return side=='Left'and p.X-r<=b.minX+.025 or side=='Right'and p.X+r>=b.maxX-.025 or side=='Bottom'and p.Y-r<=b.minY+.025 or side=='Top'and p.Y+r>=b.maxY-.025
end
return R
