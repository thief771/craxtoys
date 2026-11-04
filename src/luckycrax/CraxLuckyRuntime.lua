local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerScriptService')
local C=require(RS:WaitForChild('CraxLuckyConfig'));local R=require(RS:WaitForChild('CraxLuckyRules'));local Supp=require(SS:WaitForChild('CraxLuckySuppression'))
local Gate=require(SS:WaitForChild('CraxAbilityGate'));local Silence=require(RS:WaitForChild('CraxSilenceGate'));local Deadly=require(SS:WaitForChild('CraxDeadlyRuntime'));local Resolver=require(SS:WaitForChild('CraxSkillResolver'))
local state=workspace:WaitForChild('CombatState');local Hit=SS:WaitForChild('BiteHit');local Heal=SS:WaitForChild('CraxHeal');local FX=RS:WaitForChild('CraxLuckyFX')
local M={};local records={};local projectiles={};local volleys={};local motions={};local previous={};local round;local match;local serial=0;local rand=Random.new();local roots={};local hitDedupe={};local running=false
local function random(a,b)return rand:NextNumber(a,b)end
local function alive(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function own(m)return m:GetAttribute('CraxId')==C.Id end
local function emit(k,d)d=d or{};d.Round=state:GetAttribute('RoundId');d.Match=state:GetAttribute('CraxMatchToken');FX:FireAllClients(k,d)end
local function world(f,p)return Vector3.new(p.X,p.Y,f.depth)end
local function bound(radius)
 local l=workspace:FindFirstChild('Arenaleft');local rr=workspace:FindFirstChild('ArenaRight');local b=workspace:FindFirstChild('Arenabottom');local t=workspace:FindFirstChild('ArenaTop')
 return{minX=l.Position.X+l.Size.X*.5+radius,maxX=rr.Position.X-rr.Size.X*.5-radius,minY=b.Position.Y+b.Size.Y*.5+radius,maxY=t.Position.Y-t.Size.Y*.5-radius}
end
local function origin(f)
 local h=f.model:FindFirstChild('Head',true);local a=h and h:FindFirstChild('LuckyMouth');if a then local p=a.WorldPosition+world(f,f.position)-f.model:GetPivot().Position;return Vector2.new(p.X,p.Y)end
 return f.position
end
local function enemy(a,b)return alive(b)and a~=b and not Deadly.SameTeam(a,b)and not b:GetAttribute('FantasticInvisible')and not b:GetAttribute('PlumberInTransit')and not b:GetAttribute('VicePortalTransit')and not b:GetAttribute('DeadlyPhantom')end
local function get(m)if not own(m)then return end;if not records[m]then records[m]=R.New(Resolver.Resolve(m),random,C)end;return records[m]end
local function nearest(f)local best,dist;for m,g in pairs(motions)do if enemy(f.model,m)then local d=(f.position-g.position).Magnitude;if not dist or d<dist then best=g;dist=d end end end;return best end
function M.Reset()running=false;records={};projectiles={};volleys={};motions={};previous={};hitDedupe={};Supp.Reset();round=state:GetAttribute('RoundId');match=state:GetAttribute('CraxMatchToken');emit('Clear')end
function M.Begin(fighters)M.Reset();running=true;local adapters=require(SS:WaitForChild('CraxLuckyAdapters'));adapters.Install();if adapters.Report then local missing=adapters.Report(require(RS.CraxCatalog));state:SetAttribute('LuckyUnsupportedFamilies',table.concat(missing,', '));if #missing>0 then warn('LuckyCrax / Triche : adaptateurs absents pour '..table.concat(missing,', '))end end;roots=fighters;Supp.Begin(fighters);for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f;previous[f.model]=f.position end end
function M.CancelLucky(m)
 records[m]=nil;Supp.RemoveOwner(m);for i=#projectiles,1,-1 do if projectiles[i].owner==m then emit('CoinEnd',{Id=projectiles[i].id});table.remove(projectiles,i)end end
 for i=#volleys,1,-1 do if volleys[i].owner==m then table.remove(volleys,i)end end;emit('OwnerClear',{Owner=m})
end
function M.AttackId(attacker,kind,id)
 if id then return id end
 if kind=='SuperLaser'or kind=='SuperDash'then return require(SS.CraxSuperRuntime).LuckyAttackId(attacker,kind)end
 if kind=='SymParasite'or kind=='SymTongue'then return require(SS.CraxSymRuntime).LuckyAttackId(attacker,kind)end
 -- Non-continuous legacy impacts are distinct packets. Continuous sites supply their activation above.
 if kind and kind~='Collision'then serial+=1;return 'packet:'..serial end
end
function M.Dodge(m,damage,attacker,kind,id)
 local r=records[m];if not r or damage<=0 then return false end
 local key=id and(tostring(attacker)..':'..tostring(kind)..':'..tostring(id));r.dodged=r.dodged or{}
 if key and r.dodged[key]then return true end
 -- The ongoing third attack is fully suffered; a charge only dodges a distinct following attack.
 if key and r.attackHistory and r.attackHistory[key]then return false end
 if not m:GetAttribute('LuckyTricked')and R.Dodge(r,C)then if key then r.dodged[key]=true end;emit('Dodge',{Owner=m});return true end;return false
end
function M.Confirm(a,b,loss,recoil,collision,kind,attackId)
 local function receive(m,attacker,amount)
  local r=get(m);if not r or not alive(m)or m:GetAttribute('LuckyTricked')then return end
  -- Tagged projectiles and continuous casts retain identity; ordinary contact uses a short duplicate guard.
  local key
  if attackId then key=tostring(attacker)..':'..tostring(kind)..':'..tostring(attackId)
  elseif collision then
   local d=hitDedupe[m]or{};hitDedupe[m]=d;local prior=d[attacker];if prior and r.time-prior<.18 then return end;d[attacker]=r.time;serial+=1;key='contact:'..serial
  else key=tostring(attacker)..':'..tostring(kind)end
  r.attackHistory=r.attackHistory or{};if amount<=0 or r.attackHistory[key]then return end;r.attackHistory[key]=true
  if R.Received(r,key,amount,C)then emit('Clover',{Owner=m,Duration=C.CloverDuration})end
 end
 receive(b,a,loss);if collision then receive(a,b,recoil)end
end
function M.Healed(m,amount)if own(m)then emit('Heal',{Owner=m,Amount=amount,AtMax=amount<=0})end end
local function coin(f,r,angle,damage,life,bounces,volley)
 local target=nearest(f);if not target then return end;local start=origin(f);local d=target.position-start;if d.Magnitude<.001 then d=Vector2.new(1,0)end;d=d.Unit
 local cs,sn=math.cos(angle),math.sin(angle);d=Vector2.new(d.X*cs-d.Y*sn,d.X*sn+d.Y*cs)
 local bounds=bound(C.CoinRadius);start=Vector2.new(math.clamp(start.X,bounds.minX,bounds.maxX),math.clamp(start.Y,bounds.minY,bounds.maxY))
 serial+=1;local p={id=serial,owner=f.model,position=start,velocity=d*C.CoinSpeed,age=0,life=life,bounces=bounces,damage=damage,hits={},volley=volley,network=0};projectiles[#projectiles+1]=p;emit('Coin',{Owner=f.model,Id=p.id,Position=world(f,start),Velocity=Vector3.new(p.velocity.X,p.velocity.Y,0),Volley=volley})
end
local function projectile(p,dt)
 local f=motions[p.owner];if not f or not alive(p.owner)or p.owner:GetAttribute('LuckyTricked')then return false end
 if Gate.Paused(p.owner)then return true end
 local used=math.min(dt,p.life-p.age);p.age+=used;local left=used;local bounds=bound(C.CoinRadius)
 for _=1,8 do
  if left<=1e-9 then break end
  local t,x,y=R.Wall(p.position,p.velocity,bounds,left);local to=p.position+p.velocity*t;local hits={}
  for m,g in pairs(motions)do if enemy(p.owner,m)and not p.hits[m]then local prior=previous[m]or g.position;local fraction=R.Sweep(p.position-prior,to-g.position,Vector2.zero,g.radius+C.CoinRadius);if fraction then hits[#hits+1]={model=m,t=fraction}end end end
  table.sort(hits,function(a,b)return a.t<b.t end)
  for _,entry in ipairs(hits)do local target=entry.model;if alive(target)then p.hits[target]=true;emit('CoinHit',{Owner=p.owner,Target=target,Id=p.id,Position=world(f,p.position+(to-p.position)*entry.t)});Hit:Fire(p.owner,target,p.damage,false,'LuckyCoin',nil,p.id);if not p.volley then return false end end end
  p.position=to;left-=t
  if x or y then
   if p.bounces<=0 then return false end;p.bounces-=1;p.velocity=Vector2.new(x and-p.velocity.X or p.velocity.X,y and-p.velocity.Y or p.velocity.Y);emit('Bounce',{Owner=p.owner,Id=p.id,Position=world(f,p.position)})
  else break end
 end
 p.network+=dt;if p.network>=.05 then p.network=0;emit('CoinState',{Owner=p.owner,Id=p.id,Position=world(f,p.position)})end
 return p.age<p.life-1e-9
end
local function start(f,r,kind)
 local t=nearest(f);if not t then r.due[kind]=r.time+1;return end
 serial+=1;local a={id=serial,kind=kind,age=0,target=kind=='Reels'and Deadly.Root(t.model)or t.model,position=t.position};r.cast=a
 if kind=='Coin'then a.face=random(0,1)<C.CoinFaceChance
 elseif kind=='Dice'then a.a=rand:NextInteger(1,6);a.b=rand:NextInteger(1,6)
 else a.reward=R.Reward(random(0,1),C)end
 emit('Cast',{Owner=f.model,Activation=a.id,Kind=kind,Face=a.face,A=a.a,B=a.b,Reward=a.reward,Position=world(f,a.position)})
end
local function cast(f,r,dt)
 local a=r.cast;a.age+=dt;local duration=a.kind=='Coin'and C.FlipDuration or(a.kind=='Dice'and C.DiceDuration or C.ReelsDuration)
 if a.age<duration then return end
 if a.kind=='Coin'then coin(f,r,0,a.face and C.FaceDamage or C.PileDamage,C.CoinLife,a.face and C.FaceBounces or 0,false)
 elseif a.kind=='Dice'then
  local damage=R.Dice(a.a,a.b,C);for m,g in pairs(motions)do if enemy(f.model,m)and(g.position-a.position).Magnitude<=C.DiceRadius+g.radius then Hit:Fire(f.model,m,damage,false,'LuckyDice',nil,a.id)end end;emit('DiceImpact',{Owner=f.model,Activation=a.id,Position=world(f,a.position),A=a.a,B=a.b})
 elseif a.reward=='Heal'then
  if(f.model:GetAttribute('Health')or 0)>=(f.model:GetAttribute('MaxHealth')or C.Health)then M.Healed(f.model,0)else Heal:Fire(f.model,C.Heal,'LuckyJackpot')end
 elseif a.reward=='Coins'then r.volleyBusyUntil=r.time+C.VolleyCount*C.VolleyInterval;volleys[#volleys+1]={owner=f.model,count=0,next=r.time,id=a.id};emit('Volley',{Owner=f.model,Activation=a.id})
 elseif alive(a.target)then local ok,err=Supp.Apply(f.model,a.target,C.CheatDuration,a.id);emit(ok and'Cheat'or'Unsupported',{Owner=f.model,Target=a.target,Duration=C.CheatDuration,Reason=err})end
 emit('CastEnd',{Owner=f.model,Activation=a.id});r.cast=nil;local wait=a.kind=='Coin'and C.CoinWait or(a.kind=='Dice'and C.DiceWait or C.ReelsWait);r.due[a.kind]=r.time+random(wait[1],wait[2])
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if running then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')or match~=state:GetAttribute('CraxMatchToken')then M.Begin(fighters)end
 motions={};for _,f in ipairs(Deadly.MotionTargets(fighters))do motions[f.model]=f end
 Supp.Step(dt,enabled);if not enabled then return end
 for m,r in pairs(records)do if not alive(m)or not own(m)then M.CancelLucky(m)end end
 for _,f in ipairs(fighters)do local r=get(f.model)
  if r and not Gate.Paused(f.model)and not Deadly.Hold(f.model)and not f.model:GetAttribute('LuckyTricked')then
   r.time+=dt
   if r.readyUntil and r.time>=r.readyUntil then r.readyUntil=nil;r.received={};r.count=0;emit('CloverExpire',{Owner=f.model})end
   if r.cast then cast(f,r,dt)elseif r.time>=(r.volleyBusyUntil or 0)and Silence.CanStart(f.model)and not f.model:GetAttribute('PlumberInTransit')then local kind=R.Next(r,C);if kind then start(f,r,kind)end end
  end
 end
 for i=#volleys,1,-1 do local v=volleys[i];local r=records[v.owner];local f=motions[v.owner]
  if not r or not f or not alive(v.owner)or v.owner:GetAttribute('LuckyTricked')then table.remove(volleys,i)
  elseif r.time>=v.next and not Gate.Paused(v.owner)then coin(f,r,(v.count-2.5)*.055,C.VolleyDamage,C.VolleyLife,100,true);v.count+=1;v.next=r.time+C.VolleyInterval;if v.count>=C.VolleyCount then table.remove(volleys,i)end end
 end
 for i=#projectiles,1,-1 do if not projectile(projectiles[i],dt)then emit('CoinEnd',{Id=projectiles[i].id});table.remove(projectiles,i)end end
 for m,g in pairs(motions)do previous[m]=g.position end
end
Supp.Register(C.Id,function(m)M.CancelLucky(m)end)
return M
