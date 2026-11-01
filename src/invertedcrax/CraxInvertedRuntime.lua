local RS=game:GetService('ReplicatedStorage');local SSS=game:GetService('ServerScriptService')
local Rules=require(RS:WaitForChild('CraxInvertedRules'))
local Gate=require(SSS:WaitForChild('CraxAbilityGate'));local Silence=require(RS:WaitForChild('CraxSilenceGate'))
local Deadly=require(SSS:WaitForChild('CraxDeadlyRuntime'))
local state=workspace:WaitForChild('CombatState');local FX=RS:WaitForChild('CraxInvertedFX')
local rng=Random.new();local M={};local records={};local statuses={};local time=0;local round;local serial=0
local function random(a,b)return rng:NextNumber(a,b)end
local function emit(kind,data)data=data or {};data.RoundId=state:GetAttribute('RoundId');FX:FireAllClients(kind,data)end
local function attrs(model,s)
 model:SetAttribute('InvertedSilenced',s and s.silence>time or nil)
 model:SetAttribute('InvertedVulnerable',s and(s.vulnerable or 0)>time or nil)
 model:SetAttribute('InvertedHacked',s and(s.hack or 0)>time or nil)
end
local function live(m)return m and m.Parent and(m:GetAttribute('Health')or 0)>0 end
local function publish(m,r)
 m:SetAttribute('InvertedCopyCount',r and r.count or nil)
 m:SetAttribute('InvertedCopyReady',r and r.pending~=nil or nil)
 m:SetAttribute('InvertedCopyAmount',r and r.pending and math.max(8,r.pending)or nil)
end
function M.Reset()
 for m,r in pairs(records)do if r.mark then emit('Cancel',{Owner=m})end;Rules.Cancel(r);publish(m,nil);m:SetAttribute('InvertedCtrlRemaining',nil)end
 for m in pairs(statuses)do if m.Parent then attrs(m,nil)end end
 records={};statuses={};time=0;round=state:GetAttribute('RoundId')
end
function M.Begin(fighters)
 M.Reset()
 for _,f in ipairs(fighters)do if f.model:GetAttribute('CraxId')=='Crax_Inverted'then
  require(SSS:WaitForChild('CraxSkillResolver')).Resolve(f.model)
  serial=serial+1;records[f.model]=Rules.New(round,f.model,f.model:GetAttribute('CraxSkillLevel')or 0,random)
  publish(f.model,records[f.model])
 end end
end
function M.Melee(m,normal)if normal==0 then return 0 end;local r=records[m];return r and Rules.Base(r)or normal end
function M.RawInput(attacker,target,amount)
 local s=statuses[target]
 if records[attacker]or records[target]or(s and(s.vulnerable or 0)>time)then return amount end
 return math.floor(amount+.5)
end
function M.Vulnerable(target,amount)
 local s=statuses[target]
 return amount*((s and(s.vulnerable or 0)>time)and 1.10 or 1)
end
function M.Final(target,amount,attacker)
 local s=statuses[target];local vulnerable=s and(s.vulnerable or 0)>time
 if vulnerable or records[attacker]or records[target]then return Rules.Round(amount)end
 return amount
end
function M.Confirm(a,b,lost,recoil,collision)
 if not collision then return end
 local ra,rb=records[a],records[b]
 -- Both outgoing copies are consumed before either simultaneous received-hit counter advances.
 if ra and Rules.Consume(ra,lost,true)then emit('CopyImpact',{Owner=a,Target=b,Amount=lost})end
 if rb and Rules.Consume(rb,recoil,true)then emit('CopyImpact',{Owner=b,Target=a,Amount=recoil})end
 if rb and live(b)and Rules.Received(rb,lost,true)then emit('Capture',{Owner=b,Amount=rb.pending,Boosted=rb.pending>8})end
 if ra and live(a)and Rules.Received(ra,recoil,true)then emit('Capture',{Owner=a,Amount=ra.pending,Boosted=ra.pending>8})end
 if ra then publish(a,ra)end;if rb then publish(b,rb)end
end
local function eligible(m)
 return live(m)and not m:GetAttribute('FantasticInvisible')and not m:GetAttribute('DeadlyPhantom')and not m:GetAttribute('DeadlyInvulnerable')and not m:GetAttribute('GhostInvulnerable')and not m:GetAttribute('PlumberInTransit')and not m:GetAttribute('VicePortalTransit')and not m:GetAttribute('GoldenStatue')and not m:GetAttribute('FleauFury')and workspace:GetServerTimeNow()>=(m:GetAttribute('GhostDodgeUntil')or 0)and workspace:GetServerTimeNow()>=(m:GetAttribute('PlumberStarUntil')or 0)
end
local function width()
 local l=workspace:FindFirstChild('Arenaleft');local r=workspace:FindFirstChild('ArenaRight')
 assert(l and r and l:IsA('BasePart')and r:IsA('BasePart'),'MUTE : limites canoniques introuvables')
 return math.abs((r.Position.X-r.Size.X/2)-(l.Position.X+l.Size.X/2))
end
local function blocked(f)
 local m=f.model
 return (m:GetAttribute('FleauMode')~=nil and m:GetAttribute('FleauMode')~='Normal')or Gate.Paused(m)or Deadly.Hold(m)or f.capturedBy~=nil or m:GetAttribute('GoldenStatue')or m:GetAttribute('GoldenCharging')or m:GetAttribute('FantasticPinned')or m:GetAttribute('FantasticGrabbed')or m:GetAttribute('FleauStunned')or m:GetAttribute('DeadlyStunned')or m:GetAttribute('PlumberInTransit')or m:GetAttribute('VicePortalTransit')or workspace:GetServerTimeNow()<(m:GetAttribute('GhostTeleportUntil')or 0)
end
function M.Step(dt,fighters,enabled)
 if state:GetAttribute('Phase')~='Fighting'then if next(records)or next(statuses)then M.Reset()end;return end
 if round~=state:GetAttribute('RoundId')then M.Begin(fighters)end
 if not enabled then return end
 time=time+dt
 local motions=Deadly.MotionTargets(fighters)
 for m,s in pairs(statuses)do
  if not live(m)then attrs(m,nil);statuses[m]=nil
  else
   local was=m:GetAttribute('InvertedSilenced');attrs(m,s)
   if was and not m:GetAttribute('InvertedSilenced')then emit('SilenceEnd',{Owner=m})end
   if(s.hack or 0)>time and time>=s.nextDirection then
    s.nextDirection=s.nextDirection+1
    for _,f in ipairs(motions)do if f.model==m and not blocked(f)then
     local speed=f.velocity.Magnitude
     if speed>1e-6 then local a=rng:NextNumber(0,2*math.pi);f.velocity=Vector2.new(math.cos(a),math.sin(a))*speed;emit('HackTurn',{Owner=m,Variant=rng:NextInteger(1,3)})end
     break
    end end
   end
   if s.silence<=time and(s.hack or 0)<=time and(s.vulnerable or 0)<=time then statuses[m]=nil end
  end
 end
 for _,f in ipairs(fighters)do
  local r=records[f.model]
  if r then
   local e=Rules.Advance(r,dt,{round=round,identity=f.model,alive=live(f.model),active=true,paused=Gate.Paused(f.model),silenced=not Silence.CanStart(f.model),position=f.position,health=f.model:GetAttribute('Health')},random)
   local remaining=r.mark and math.ceil(math.max(0,20-r.time)*10)/10 or nil
   if r.lastRemaining~=remaining then r.lastRemaining=remaining;f.model:SetAttribute('InvertedCtrlRemaining',remaining)end
   if e.cancel then emit('Cancel',{Owner=f.model})end
   if not r.alive then publish(f.model,nil);records[f.model]=nil
   else
    if e.mark then emit('Mark',{Owner=f.model,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Duration=10})end
    if e.restore and M.SetHealth then
     local from=Vector3.new(f.position.X,f.position.Y,f.depth)
     f.position=e.restore.position
     f.model:PivotTo(CFrame.new(f.position.X,f.position.Y,f.depth)*f.rotation)
     M.SetHealth(f.model,e.restore.health,round)
     emit('Restore',{Owner=f.model,From=from,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Health=e.restore.health})
    end
    if e.mute then
     local radius=width()/2
     emit('Mute',{Owner=f.model,Position=Vector3.new(f.position.X,f.position.Y,f.depth),Radius=radius})
     for _,target in ipairs(motions)do local m=target.model
      if m~=f.model and eligible(m)and not Deadly.SameTeam(f.model,m)and(target.position-f.position).Magnitude<=radius then
       statuses[m]=Rules.ApplyStatus(statuses[m],time,r.level>=1);attrs(m,statuses[m])
       emit('Silence',{Owner=m,Hack=r.level>=1,Duration=5})
      end
     end
    end
   end
  end
 end
end
return M
