-- Règles pures VeniCrax (sans service Roblox) : testables hors Studio.
local R={}

-- Poison : un emplacement par source ('Bite' ou 'Cobra'). Réappliquer rafraîchit la durée, sans cumuler.
function R.NewPoison(kind,perTick,duration,interval)
 return{kind=kind,perTick=perTick,ticks=math.floor(duration/interval+1e-6),interval=interval,clock=0}
end
-- Avance un poison de dt ; renvoie le nombre de ticks à infliger et si le poison est terminé.
function R.AdvancePoison(p,dt)
 p.clock+=dt;local due=0
 while p.ticks>0 and p.clock+1e-8>=p.interval do p.clock-=p.interval;p.ticks-=1;due+=1 end
 return due,p.ticks<=0
end

-- Tir du cobra : vise le reflet de la cible par le mur le plus utile, pour un ricochet puis l'impact.
local function reflect(point,side,b)
 if side=='Left'then return Vector2.new(2*b.minX-point.X,point.Y)
 elseif side=='Right'then return Vector2.new(2*b.maxX-point.X,point.Y)
 elseif side=='Bottom'then return Vector2.new(point.X,2*b.minY-point.Y)end
 return Vector2.new(point.X,2*b.maxY-point.Y)
end
function R.RicochetAim(from,target,b)
 -- Le mur dont le reflet donne le trajet le plus court (rebond lisible, pas un tir direct).
 local best,length,chosen
 for _,side in ipairs({'Left','Right','Bottom','Top'})do
  local mirrored=reflect(target,side,b);local d=(mirrored-from).Magnitude
  if d>1e-6 and(not length or d<length)then best=mirrored;length=d;chosen=side end
 end
 if not best then return Vector2.new(1,0),nil end
 return (best-from).Unit,chosen
end

-- Déplacement d'un projectile avec rebonds sur les murs de l'arène (rayon r). Renvoie position, vitesse, rebonds.
function R.Bounce(position,velocity,dt,r,b)
 local p=position+velocity*dt;local v=velocity;local walls={}
 if p.X<b.minX+r then p=Vector2.new(2*(b.minX+r)-p.X,p.Y);v=Vector2.new(-v.X,v.Y);walls[#walls+1]='Left'
 elseif p.X>b.maxX-r then p=Vector2.new(2*(b.maxX-r)-p.X,p.Y);v=Vector2.new(-v.X,v.Y);walls[#walls+1]='Right'end
 if p.Y<b.minY+r then p=Vector2.new(p.X,2*(b.minY+r)-p.Y);v=Vector2.new(v.X,-v.Y);walls[#walls+1]='Bottom'
 elseif p.Y>b.maxY-r then p=Vector2.new(p.X,2*(b.maxY-r)-p.Y);v=Vector2.new(v.X,-v.Y);walls[#walls+1]='Top'end
 return p,v,walls
end

-- Plus petite fraction 0..1 du segment relatif où deux cercles se touchent (balayage continu).
function R.Sweep(a,b,radius)
 local d=b-a;local A=d:Dot(d);local B=2*a:Dot(d);local Cc=a:Dot(a)-radius*radius
 if Cc<=0 then return 0 end;if A<1e-12 then return nil end
 local disc=B*B-4*A*Cc;if disc<0 then return nil end
 local t=(-B-math.sqrt(disc))/(2*A);if t>=0 and t<=1 then return t end;return nil
end

-- Distillation : armée après N pertes de poison, si la recharge est écoulée.
function R.DistillArmed(record,needed,now)
 return(record.poisonLosses or 0)>=needed and now>=(record.distillReadyAt or 0)
end

return R
