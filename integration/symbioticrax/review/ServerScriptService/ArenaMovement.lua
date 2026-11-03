-- SymbiotiCraxIntegrationV1
local SymV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSymRuntime'))
-- SuperCraxIntegrationV1
local SuperCraxV1=require(game:GetService('ServerScriptService'):WaitForChild('CraxSuperRuntime'))
local Inverted=require(game:GetService('ServerScriptService'):WaitForChild('CraxInvertedRuntime'))
local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxCombinedFix_v7
-- GoldenCombatBase_v1
-- PlumberFix_v2
-- PlumberIntegration_v1
local Fleau=require(game:GetService('ServerScriptService'):WaitForChild('FleauRuntime'))
local Golden=require(game:GetService('ServerScriptService'):WaitForChild('CraxGoldenRuntime'))
local Plumber=require(game:GetService('ServerScriptService'):WaitForChild('CraxPlumberRuntime'))
local Deadly=require(game:GetService('ServerScriptService'):WaitForChild('CraxDeadlyRuntime'))
-- FantasticAbsolutePosition_v1
local PositionLock=require(game:GetService("ServerScriptService"):WaitForChild("CraxPositionLock"))
-- FantasticMovement_v1
local Fantastic=require(game:GetService("ServerScriptService"):WaitForChild("FantasticRuntime"))
-- GhostyGrandFrisson_v1
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxSpideySkills_v1
-- CopEmPremium_v3
local RunService = game:GetService("RunService")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local state = workspace:WaitForChild("CombatState")
state:SetAttribute("MovementReady", false)
local biteHit = SSS:WaitForChild("BiteHit", 10)
assert(biteHit and biteHit:IsA("BindableEvent"), "ArenaMovement : BiteHit manque.")
local fx = RS:FindFirstChild("CraxCombatFX")
if not fx then fx = Instance.new("RemoteEvent"); fx.Name = "CraxCombatFX"; fx.Parent = RS end
assert(fx:IsA("RemoteEvent"), "CraxCombatFX doit être un RemoteEvent.")
local old = workspace:FindFirstChild("SpideyWebVisuals")
if old then old:Destroy() end
local visuals = Instance.new("Folder"); visuals.Name = "SpideyWebVisuals"; visuals.Parent = workspace
local Night = require(SSS:WaitForChild("GhostyNight"))
local Skills=require(SSS:WaitForChild("CraxSpideyRuntime"))
local fighters = {}
local touching = false
local clock = 0
local function attr(f, key, fallback)
	local v = f.model:GetAttribute(key)
	return type(v) == "number" and v == v and math.abs(v) < math.huge and v or fallback
end
local function isSpider(f) return f.model:GetAttribute("AbilityId") == "SpideyWeb" end
local function speedOf(model)
	local s = model:GetAttribute("Speed")
	assert(type(s) == "number" and s > 0, "Speed invalide : " .. model.Name)
	return s
end
local function sound(head, name, id, volume)
	local oldSound = head:FindFirstChild(name); if oldSound then oldSound:Destroy() end
	local s = Instance.new("Sound"); s.Name = name; s.SoundId = id; s.Volume = volume
	s.RollOffMode = Enum.RollOffMode.InverseTapered; s.RollOffMinDistance = 60; s.RollOffMaxDistance = 180
	s.Parent = head; return s
end
local function anchor(name)
	local p = Instance.new("Part"); p.Name = name; p.Size = Vector3.one * 0.1; p.Transparency = 1
	p.Anchored = true; p.CanCollide = false; p.CanTouch = false; p.CanQuery = false; p.Parent = visuals
	local a = Instance.new("Attachment"); a.Parent = p; return p, a
end
for i, name in ipairs({ "Fighter1", "Fighter2" }) do
	local model = workspace:WaitForChild(name)
	local head = model:FindFirstChild("Head", true)
	if head and not head:IsA("BasePart") then head = head:FindFirstChildWhichIsA("BasePart", true) end
	assert(head and head:IsA("BasePart"), "Head introuvable : " .. name)
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") then p.Anchored = true; p.CanCollide = false end
	end
	model.PrimaryPart = head; head.PivotOffset = CFrame.identity
	local previous = model:FindFirstChild("ImpactFlash"); if previous then previous:Destroy() end
	local flash = Instance.new("Highlight"); flash.Name = "ImpactFlash"; flash.Adornee = model
	flash.FillTransparency = 1; flash.OutlineTransparency = 1; flash.Parent = model
	local p0, a0 = anchor(name .. "WebOrigin"); local p1, a1 = anchor(name .. "WebTip")
	local beam = Instance.new("Beam"); beam.Name = "SpideySilk"; beam.Attachment0 = a0; beam.Attachment1 = a1
	beam.Width0 = 0.075; beam.Width1 = 0.035; beam.FaceCamera = true; beam.LightEmission = 0.12
	beam.Color = ColorSequence.new(Color3.fromRGB(240, 245, 248)); beam.Transparency = NumberSequence.new(0.08)
	beam.Segments = 12; beam.Enabled = false; beam.Parent = visuals
	for _, key in ipairs({ "SpideyTrail", "SpideyTrailTop", "SpideyTrailBottom" }) do
		local obj = head:FindFirstChild(key); if obj then obj:Destroy() end
	end
	local top = Instance.new("Attachment"); top.Name = "SpideyTrailTop"; top.Position = Vector3.new(0, head.Size.Y * .35, 0); top.Parent = head
	local bottom = Instance.new("Attachment"); bottom.Name = "SpideyTrailBottom"; bottom.Position = Vector3.new(0, -head.Size.Y * .35, 0); bottom.Parent = head
	local second=beam:Clone();second.Name="SpideyVolleySilk";second.CurveSize0=.65;second.CurveSize1=.65;second.Parent=visuals
 local third=beam:Clone();third.Name="SpideyVolleySilk";third.CurveSize0=-.65;third.CurveSize1=-.65;third.Parent=visuals
 local trail = Instance.new("Trail"); trail.Name = "SpideyTrail"; trail.Attachment0 = top; trail.Attachment1 = bottom
	trail.Lifetime = .17; trail.MinLength = .2; trail.FaceCamera = true; trail.LightEmission = .5
	trail.Color = ColorSequence.new(Color3.fromRGB(230, 250, 255)); trail.Transparency = NumberSequence.new(.45, 1)
	trail.Enabled = false; trail.Parent = head
	local s = speedOf(model)
	fighters[i] = { model = model, head = head, start = Vector2.new(head.Position.X, head.Position.Y),
		position = Vector2.new(head.Position.X, head.Position.Y), depth = head.Position.Z, rotation = head.CFrame.Rotation,
		radius = math.max(head.Size.X, head.Size.Y) / 2, speed = s, velocity = Vector2.new(1, 0) * s,
		flash = flash, flashTime = 0, priority = 0, lastWallSound = -math.huge,
		wallSound = sound(head, "WallBounceSound", "rbxassetid://1885641628", .28),
		hitSound = sound(head, "CollisionHitSound", "rbxassetid://110024396934410", .45),
		originPart = p0, tipPart = p1, beam = beam, extraBeams={second,third}, trail = trail,
		nextWeb = 2.5, strike = false, coastUntil = 0,
	}
end
local function world(f, p) return Vector3.new(p.X, p.Y, f.depth - f.head.Size.Z * .5 - .1) end
local function flash(f, enemy)
	local priority = enemy and 2 or 1
	if f.flashTime <= 0 or priority >= f.priority then
		local c = enemy and Color3.fromRGB(255, 150, 55) or Color3.new(1, 1, 1)
		f.flash.FillColor = c; f.flash.OutlineColor = c; f.priority = priority
	end
	f.flashTime = .18
end
local function cancelCharge(f)
	local sting=f.sting
 if sting then
  local target=sting.target
  AbilityGate.Resume(target.model,"SpideyInjection")
  if target.capturedBy==f then target.capturedBy=nil;target.velocity=sting.savedVelocity;target.model:SetAttribute("WebImmobilized",false)end
  f.velocity=sting.ownVelocity;f.sting=nil;f.model:SetAttribute("SpideyStingingUntil",nil)
 end
 local charge = f.charge
	if charge and charge.target and charge.target.capturedBy == f then
		local target = charge.target
		target.capturedBy = nil
		target.velocity = charge.savedVelocity
		target.model:SetAttribute("WebImmobilized", false)
	end
	f.charge = nil; f.shot = nil; f.volley=nil; f.beam.Enabled = false
 for _,beam in ipairs(f.extraBeams)do beam.Enabled=false end
end
local pushEvent=SSS:WaitForChild("CraxTonguePush")
local function acceptTonguePush(attacker,target)
 if AbilityGate.Paused(attacker)then return end
 if state:GetAttribute("Phase")~="Fighting"or state:GetAttribute("GhostNightActive")
  or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then return end
 local a,b
 for _,f in ipairs(fighters)do if f.model==attacker then a=f elseif f.model==target then b=f end end
 if not a or not b or (b.model:GetAttribute("Health")or 0)<=0
  or b.model:GetAttribute("GhostInvulnerable")then return end
 if b.capturedBy then cancelCharge(b.capturedBy)end
 cancelCharge(b);b.strike=false;b.model:SetAttribute("WebCharging",false)
 local delta=b.position-a.position
 local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(1,0)
 b.knockback={velocity=direction*72,remaining=.24}
end
pushEvent.Event:Connect(acceptTonguePush)
local function pushStep(f,dt)
 local push=f.knockback
 if not push then return Vector2.zero end
 if state:GetAttribute("GhostNightActive")or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then
  f.knockback=nil;return Vector2.zero
 end
 local time=math.min(dt,push.remaining)
 local offset=push.velocity*((1-math.exp(-8*time))/8)
 push.velocity=push.velocity*math.exp(-8*time);push.remaining=push.remaining-time
 if push.remaining<=.00001 then f.knockback=nil end
 return offset
end
local function clearWebs()
 Skills.Clear()
	for _, f in ipairs(fighters) do cancelCharge(f);AbilityGate.Reset(f.model) end
	for _, f in ipairs(fighters) do
		f.attackRed=false;f.pendingSting=nil;f.followupEligible=false;f.capturedBy = nil; f.strike = false; f.coastUntil = 0; f.knockback=nil
		f.model:SetAttribute("WebImmobilized", false); f.model:SetAttribute("WebCharging", false)
		f.trail.Enabled = false; f.trail:Clear()
	end
end
local function wallEndpoint(position, direction)
	local distance = math.huge
	if direction.X > .00001 then distance = math.min(distance, (24 - position.X) / direction.X)
	elseif direction.X < -.00001 then distance = math.min(distance, (-24 - position.X) / direction.X) end
	if direction.Y > .00001 then distance = math.min(distance, (45 - position.Y) / direction.Y)
	elseif direction.Y < -.00001 then distance = math.min(distance, (5 - position.Y) / direction.Y) end
	return position + direction * math.max(0, distance)
end
local function shoot(f, enemy,red)
 if not InvertedSilence.CanStart(f.model)then return end
 if f.sting or f.capturedBy or workspace:GetServerTimeNow()<(f.model:GetAttribute("SpideyStingingUntil")or 0)then return end
	local opposite = Vector2.new(-f.position.X, 50 - f.position.Y)
	local delta = opposite - f.position
	local direction = delta.Magnitude > .001 and delta.Unit or f.velocity.Unit
	if direction.Magnitude < .001 then direction = Vector2.new(1, 0) end
	if not f.sting then cancelCharge(f)end
	f.strike = false
 f.attackRed=red==true
 f.volley=red and 2 or 1
 f.followupEligible=false;f.followupWait=not red
 if f.volley==2 then
  local speed=math.max(f.speed,f.velocity.Magnitude)
  local direction=f.velocity.Magnitude>.001 and f.velocity.Unit or Vector2.new(1,0)
  f.volleyBoostSpeed=speed+math.max(12,f.speed*.65)
  f.velocity=direction*f.volleyBoostSpeed
 end
 if f.volley==2 then fx:FireAllClients("SpideyDoubleShot",world(f,f.position),0,f.model)end
	f.shot = { position = f.position, direction = direction, anchor = wallEndpoint(f.position, direction), enemy = enemy }
	f.beam.Enabled = true
	if not red then fx:FireAllClients("WebLaunch",world(f,f.position))end
end
local function beginCharge(f, target, point)
 if f.volley==1 and f.followupWait then f.followupEligible=true;f.followupWait=false end
	if target then
		-- Être attrapé interrompt la propre charge de la cible et libère sa victime.
		cancelCharge(target); target.strike = false
	end
	local saved = target and target.velocity or nil
	f.shot = nil; f.strike = true; f.coastUntil = 0
	f.charge = { target = target, anchor = point, savedVelocity = saved,
		expires = clock + math.clamp(attr(f, "WebMaxChargeTime", 1), .1, 1) }
	if target then
		target.capturedBy = f; target.velocity = Vector2.zero; target.model:SetAttribute("WebImmobilized", true)
		fx:FireAllClients("WebCapture", world(target, target.position), 0, target.model)
	end
	f.model:SetAttribute("WebCharging", true)
end
local function segmentHits(a, b, center, radius)
	local d = b - a
	local t = d:Dot(d) > 1e-9 and math.clamp((center - a):Dot(d) / d:Dot(d), 0, 1) or 0
	return (a + d * t - center).Magnitude <= radius
end
local function webStep(f, enemy, dt)
 if f.sting or AbilityGate.Paused(f.model)or f.capturedBy and f.capturedBy.sting then
  f.nextWeb=f.nextWeb+dt;f.coastUntil=f.coastUntil+dt
  if not f.sting then return end
 end
	if state:GetAttribute("GhostNightActive") or workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) then return end
	if f.pendingSting and attr(f,"CraxSkillLevel",0)>=3 then
  if workspace:GetServerTimeNow()<(f.pendingSting.deadline or 0)then return else f.pendingSting=nil end
 end
 if f.sting and(not f.sting.target.model.Parent or(f.sting.target.model:GetAttribute('Health')or 0)<=0 or f.sting.target.model:GetAttribute('DeadlyPhantom'))then cancelCharge(f);return end
 if f.sting then
  local sting=f.sting;local target=sting.target
  local squeeze=math.clamp((workspace:GetServerTimeNow()-sting.started)/.24,0,1);squeeze=squeeze*squeeze*(3-2*squeeze)
  f.position=target.position+sting.offset:Lerp(sting.tightOffset,squeeze)
  if workspace:GetServerTimeNow()>=sting.expires then
   local lost=sting.lost;local defender=target.model
   local shot=f.shot;local red=f.volley==2;local boost=f.volleyBoostSpeed
   cancelCharge(f);f.coastUntil=clock+.65
   if red and shot then f.shot=shot;f.shot.position=f.position;f.volley=2;f.volleyBoostSpeed=boost;f.beam.Enabled=true end
   if lost>0 and state:GetAttribute("Phase")=="Fighting"then SSS.CraxSpideyDamageConfirmed:Fire(f.model,defender,lost,"SpideyInject",state:GetAttribute("RoundId"))end
  end
  return
 end
 if not isSpider(f) or f.capturedBy then return end
	if clock >= f.nextWeb and InvertedSilence.CanStart(f.model)then
		f.nextWeb = clock + math.max(.1, attr(f, "WebCooldown", 2.5))
		shoot(f, enemy)
	end
	if f.shot then
		local shot = f.shot
		local before = shot.position
		local remaining = (shot.anchor - before).Magnitude
		local distance = math.min(remaining, math.max(1, attr(f, "WebSpeed", 400)) * dt)
		local after = before + shot.direction * distance
		local target,best=nil,math.huge
  for _,candidate in ipairs(Deadly.MotionTargets(fighters))do
   if not Deadly.SameTeam(f.model,candidate.model)and not candidate.model:GetAttribute('DeadlyPhantom')and not candidate.model:GetAttribute('FantasticInvisible')and(candidate.model:GetAttribute('Health')or 0)>0
    and segmentHits(before,after,candidate.position,candidate.radius+.12)then
    local along=(candidate.position-before):Dot(shot.direction)
    if along<best then best=along;target=candidate end
   end
  end
  if target then
			beginCharge(f, target, target.position)
		elseif remaining <= distance + .001 then
			fx:FireAllClients("WebWall", world(f, shot.anchor), 0, nil, Vector3.new(-shot.direction.X, -shot.direction.Y, 0))
			beginCharge(f, nil, shot.anchor)
		else shot.position = after end
	end
	if f.charge and f.charge.target and(not f.charge.target.model.Parent or(f.charge.target.model:GetAttribute('Health')or 0)<=0 or f.charge.target.model:GetAttribute('DeadlyPhantom'))then cancelCharge(f)end
 if f.charge then
		local charge = f.charge
		local point = charge.target and charge.target.position or charge.anchor
		local delta = point - f.position
		if clock >= charge.expires or (not charge.target and delta.Magnitude <= f.radius + .2) then
			cancelCharge(f); f.coastUntil = clock + attr(f, "WebCoastTime", .65)
		elseif delta.Magnitude > .001 then
			local maximum = math.max(f.speed, attr(f, "WebMaxSpeed", 110)*(f.volley==2 and 1.65 or 1),f.volley==2 and(f.volleyBoostSpeed or 0)or 0)
			local speed = math.min(maximum, f.velocity.Magnitude + math.max(1, attr(f, "WebAcceleration", 220))*(f.volley==2 and 2.5 or 1) * dt)
			f.velocity = delta.Unit * speed
		end
	end
	if not f.charge and not f.shot and clock >= f.coastUntil then
		f.strike = false
		local speed = f.speed + (f.velocity.Magnitude - f.speed) * math.exp(-6 * dt)
		if f.velocity.Magnitude > .001 then f.velocity = f.velocity.Unit * math.max(f.speed, speed) end
	end
end
local function damageAtSpeed(f, speed)
	local minimum = math.max(0, attr(f, "WebMinDamage", 4))
	local maximum = math.max(minimum, attr(f, "WebMaxDamage", 24))
	local scale = math.max(1, attr(f, "WebDamageScale", 35))
	return math.floor(math.clamp(minimum * math.exp(math.max(0, speed - f.speed) / scale), minimum, maximum) + .5)
end
local function followup(f)
 if not InvertedSilence.CanStart(f.model)then return false end
 if not f.followupEligible then return false end
 f.followupEligible=false
 if Skills.Volley(f.model)==2 then
  local enemy=fighters[f==fighters[1]and 2 or 1]
  shoot(f,enemy,true);return true
 end
 return false
end
local function webImpact(f,target)
 if state:GetAttribute("GhostNightActive")or not isSpider(f)or not f.strike or f.capturedBy then return false end
 local critical=f.charge and f.charge.target==target
 local speed=f.velocity.Magnitude*Skills.Slow(f.model)*Night.Slow(f.model)
 local maximum=f.attackRed and 40 or 25
 local minimum=math.min(maximum,math.max(0,attr(f,"WebMinDamage",4)))
 local ceiling=math.max(f.speed+1,attr(f,"WebMaxSpeed",110)*(f.attackRed and 1.65 or 1),f.attackRed and(f.volleyBoostSpeed or 0)or 0)
 local ratio=math.clamp((speed-f.speed)/(ceiling-f.speed),0,1)
 local amount=math.floor(minimum+(maximum-minimum)*ratio^1.5+.5)
 local velocity=f.velocity;f.strike=false;cancelCharge(f);f.coastUntil=clock+.65
 if critical then f.pendingSting={deadline=workspace:GetServerTimeNow()+.925,target=target,velocity=velocity,round=state:GetAttribute("RoundId")}end
 biteHit:Fire(f.model,target.model,amount,false,critical and "WebCritical"or "WebImpact")
 followup(f)
 return true
end
-- BindableEvent callbacks sont asynchrones : utiliser la confirmation réelle de CombatHealth.
SSS:WaitForChild("CraxSpideyDamageConfirmed").Event:Connect(function(attacker,defender,lost,kind,round)
 if round~=state:GetAttribute("RoundId")or(kind~="WebCritical"and kind~="WebImpact")then return end
 local a,b;for _,f in ipairs(fighters)do if f.model==attacker then a=f elseif f.model==defender then b=f end end
 b=b or Deadly.GetMotion(defender)
 if not a or not b then return end
 if AbilityGate.Paused(attacker)or state:GetAttribute("GhostNightActive")or workspace:GetServerTimeNow()<(state:GetAttribute("GhostFreezeUntil")or 0)then a.pendingSting=nil;return end
 fx:FireAllClients(kind,world(b,b.position),lost)
 if kind~="WebCritical"then return end
 local pending=a.pendingSting;a.pendingSting=nil
 if not InvertedSilence.CanStart(attacker)or not pending or pending.target~=b or pending.round~=round or lost<=0 or state:GetAttribute("Phase")~="Fighting"or attr(a,"CraxSkillLevel",0)<3 or Skills.Poisoned(defender)then return end
 if b.capturedBy then cancelCharge(b.capturedBy)end
 cancelCharge(b);b.strike=false
 local delta=a.position-b.position;local direction=delta.Magnitude>.001 and delta.Unit or Vector2.new(-1,0)
 -- Garde le second fil rouge lancé après l'impact, mais suspend sa traction pendant la piqûre.
 local velocity=a.velocity.Magnitude>.001 and a.velocity or pending.velocity
 a.sting={target=b,started=workspace:GetServerTimeNow(),expires=workspace:GetServerTimeNow()+1.4,lost=lost,savedVelocity=b.velocity,ownVelocity=velocity,offset=direction*(a.radius+b.radius-.15),tightOffset=direction*(a.radius+b.radius)*.80}
 AbilityGate.Pause(b.model,"SpideyInjection")
 b.capturedBy=a;b.velocity=Vector2.zero;b.model:SetAttribute("WebImmobilized",true)
 a.beam.Enabled=false;a.model:SetAttribute("WebCharging",false)
 a.velocity=Vector2.zero;a.model:SetAttribute("SpideyStingingUntil",workspace:GetServerTimeNow()+1.4)
 fx:FireAllClients("SpideySting",world(b,b.position),1.4,b.model,a.model)
end)
local function walls(f)
 f.radius=math.max(f.head.Size.X,f.head.Size.Y)/2
	local x, y = f.position.X, f.position.Y; local vx, vy = f.velocity.X, f.velocity.Y
	local hit = false;local plumberSides={}
	if x < -24 + f.radius then x = -24 + f.radius; vx = math.abs(vx); hit = true;plumberSides[#plumberSides+1]='Left'
	elseif x > 24 - f.radius then x = 24 - f.radius; vx = -math.abs(vx); hit = true;plumberSides[#plumberSides+1]='Right' end
	if y < 5 + f.radius then y = 5 + f.radius; vy = math.abs(vy); hit = true;plumberSides[#plumberSides+1]='Bottom'
	elseif y > 45 - f.radius then y = 45 - f.radius; vy = -math.abs(vy); hit = true;plumberSides[#plumberSides+1]='Top' end
	f.position = Vector2.new(x, y); f.velocity = Vector2.new(vx, vy)
	if hit then
  for _,side in ipairs(plumberSides)do Plumber.Wall(f,side)end
        if isSpider(f)and not f.sting then followup(f)end
        f.knockback=nil
		if not state:GetAttribute("GhostNightActive") then flash(f, false) end
		if f.charge and not f.charge.target and f.volley~=2 then cancelCharge(f); f.coastUntil = clock + attr(f, "WebCoastTime", .65) end
		if not state:GetAttribute("GhostNightActive") and clock - f.lastWallSound >= .08 then
			f.lastWallSound = clock; f.wallSound:Stop(); f.wallSound:Play()
		end
	end
end
local function move(f)
 PositionLock.Enforce(f)
	local offset = Vector3.zero
 if workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) then
  local t=os.clock()*75
  offset=Vector3.new(math.sin(t)*.075,math.cos(t*1.13)*.055,0)
 end
 if f.model:GetAttribute("FleauFury")or state:GetAttribute("GhostNightActive")or not f.model:GetAttribute("FantasticPinned")then f.model:PivotTo(CFrame.new(f.position.X, f.position.Y, f.depth) * CFrame.new(offset) * f.rotation)end
	f.model:SetAttribute("CurrentSpeed", f.velocity.Magnitude*SymV1.Speed(f.model)*SuperCraxV1.Speed(f.model)*Plumber.Speed(f)*Skills.Slow(f.model)*Night.Slow(f.model))
	f.model:SetAttribute("WebCharging", not f.sting and not f.capturedBy and f.charge ~= nil)
	local endpoint = f.shot and f.shot.position or (f.charge and (f.charge.target and f.charge.target.position or f.charge.anchor))
	f.beam.Enabled = not f.sting and not f.capturedBy and endpoint ~= nil and state:GetAttribute("Phase") == "Fighting"
	for _,beam in ipairs(f.extraBeams)do beam.Enabled=false;beam.Width0=.065;beam.Width1=.035 end
 if endpoint then
		f.originPart.Position = world(f, f.position); f.tipPart.Position = world(f, endpoint)
		f.beam.Width0 = f.charge and .19 or .10
  local color=f.volley==2 and Color3.fromRGB(255,35,55)or Color3.fromRGB(240,245,248)
  f.beam.Color=ColorSequence.new(color)
  for _,beam in ipairs(f.extraBeams)do beam.Color=ColorSequence.new(Color3.fromRGB(255,25,45))end
  f.trail.Color=ColorSequence.new(f.volley==2 and Color3.fromRGB(255,40,55)or Color3.fromRGB(230,250,255))
	end
	f.trail.Enabled = isSpider(f) and not f.sting and not f.capturedBy and f.velocity.Magnitude > f.speed * 1.25
		and state:GetAttribute("Phase") == "Fighting"
end
Night.SetEscapeHandler(function(model,enemy)
 local defender,attacker
 for _,f in ipairs(fighters) do
  if f.model==model then defender=f elseif f.model==enemy then attacker=f end
 end
 if not defender or not attacker or state:GetAttribute("Phase")~="Fighting" then return false end
 local originalVelocity=defender.velocity
 if defender.capturedBy and defender.capturedBy.sting then originalVelocity=defender.capturedBy.sting.savedVelocity end
 if defender.capturedBy then cancelCharge(defender.capturedBy) end
 cancelCharge(defender);defender.strike=false;defender.knockback=nil
 local direction=attacker.velocity.Magnitude>.001 and attacker.velocity.Unit or Vector2.new(1,0)
 local distance=defender.radius+attacker.radius+.8
 local position=attacker.position-direction*distance
 local function fits(p)
  return p.X>=-24+defender.radius and p.X<=24-defender.radius
   and p.Y>=5+defender.radius and p.Y<=45-defender.radius
 end
 if not fits(position) then
  local best,score=nil,-math.huge
  for i=0,31 do
   local angle=i*math.pi*2/32;local offset=Vector2.new(math.cos(angle),math.sin(angle))
   local candidate=attacker.position+offset*distance
   local behind=-offset:Dot(direction)
   if fits(candidate) and behind>score then best=candidate;score=behind end
  end
  if not best then return false end
  position=best
 end
 local from=Vector3.new(defender.position.X,defender.position.Y,defender.depth)
 defender.position=position
 if originalVelocity.Magnitude>.001 then defender.velocity=originalVelocity
 else
  local x,y=model:GetAttribute("LaunchDirectionX"),model:GetAttribute("LaunchDirectionY")
  local original=type(x)=="number"and type(y)=="number"and Vector2.new(x,y)or Vector2.new(1,0)
  defender.velocity=(original.Magnitude>.001 and original.Unit or Vector2.new(1,0))*defender.speed
 end
 defender.model:SetAttribute("GhostDodgeUntil",workspace:GetServerTimeNow()+.92)
 defender.model:SetAttribute("GhostTeleportUntil",workspace:GetServerTimeNow()+.9)
 touching=false;move(defender)
 local event=RS:FindFirstChild("GhostyNightEvent")
 if event then
  for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
   local seat=p:GetAttribute("ArenaSeat")
   if seat==1 or seat==2 then event:FireClient(p,"Escape",{Owner=model.Name,From=from,
    To=Vector3.new(position.X,position.Y,defender.depth),Start=workspace:GetServerTimeNow(),Duration=.9,RoundId=state:GetAttribute("RoundId")}) end
  end
 end
 return true
end)
local function resetRound()
 Plumber.Reset()
 Fantastic.Reset()
	clearWebs(); Night.Reset(fighters); touching = false; clock = 0
	for i, f in ipairs(fighters) do
		f.position = f.start; f.speed = speedOf(f.model)
		f.velocity = Vector2.new(i == 1 and 1 or -1, .25).Unit * f.speed
		f.nextWeb = attr(f, "WebCooldown", 2.5)
		f.model:SetAttribute("LaunchDirectionX", nil); f.model:SetAttribute("LaunchDirectionY", nil)
		f.flashTime = 0; f.priority = 0; f.lastWallSound = -math.huge
		f.wallSound:Stop(); f.hitSound:Stop(); move(f)
	end
end
local function finite(v) return type(v) == "number" and v == v and math.abs(v) < math.huge end
local function launch()
 SuperCraxV1.Begin(fighters)
 SymV1.Begin(fighters)
 Inverted.Begin(fighters)
 Plumber.Reset()
 Fantastic.Reset()
	clearWebs(); Night.Reset(fighters); clock = 0
	for i, f in ipairs(fighters) do
		f.speed = speedOf(f.model)
		local x, y = f.model:GetAttribute("LaunchDirectionX"), f.model:GetAttribute("LaunchDirectionY")
		local direction = Vector2.new(i == 1 and 1 or -1, .25)
		if finite(x) and finite(y) and Vector2.new(x, y).Magnitude > .001 then direction = Vector2.new(x, y) end
		f.velocity = direction.Unit * f.speed; f.nextWeb = attr(f, "WebCooldown", 2.5)
	end
end
state:GetAttributeChangedSignal("RoundId"):Connect(resetRound)
state:GetAttributeChangedSignal("Phase"):Connect(function()
	if state:GetAttribute("Phase") == "Fighting" then launch() else Plumber.Reset();clearWebs(); Night.Reset(fighters) end
end)
resetRound()
Deadly.Bind(fighters)
Deadly.ContactHandler=function(a,b)
 local first,second=Deadly.GetMotion(a),Deadly.GetMotion(b)
 if not first or not second then return false end
 if isSpider(first)then return webImpact(first,second)elseif isSpider(second)then return webImpact(second,first)end
 return false
end
Plumber.Bind(fighters)
-- GoldenStatueContactFix_v1
local statueContact={Round=nil,Active=false,Last=-math.huge,Fixed=nil}
RunService.Heartbeat:Connect(function(deltaTime)

 if state:GetAttribute('DeadlyDemoActive')then Plumber.Reset();return end
	local alive = state:GetAttribute("Phase") == "Fighting"
	for _, f in ipairs(fighters) do if (f.model:GetAttribute("Health") or 1) <= 0 then alive = false end end
	if not alive then clearWebs();Fantastic.Reset()end
	if alive and not state:GetAttribute('GhostNightActive')then Skills.Step(fighters)end
 local dt = math.min(deltaTime, .1); local steps = math.max(1, math.ceil(dt * 120)); local step = dt / steps
	for _ = 1, steps do
		alive = alive and state:GetAttribute("Phase") == "Fighting"
		Deadly.Step(step,fighters)
		local frozen = Deadly.Flash()
  Inverted.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  if alive then
   clock = clock + step
   frozen = frozen or Night.Step(clock,step,fighters,clearWebs)
   if not frozen then Fantastic.Step(step*Deadly.CinematicScale(),fighters)end
   alive = state:GetAttribute("Phase") == "Fighting"
  end
		SuperCraxV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  SymV1.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen and not state:GetAttribute('GhostNightActive')and workspace:GetServerTimeNow()>=(state:GetAttribute('GhostFreezeUntil')or 0))
  alive=alive and state:GetAttribute('Phase')=='Fighting'
  Golden.Step(step*Deadly.CinematicScale(),fighters,alive and not frozen)
		Plumber.Step(step,alive and not frozen)
  Fleau.Step(step,fighters,alive and not frozen)
		for i, f in ipairs(fighters) do
			f.flashTime = math.max(0, f.flashTime - step)
			if alive and not frozen and not Fantastic.Hold(f)and not Deadly.Hold(f.model)then webStep(f, fighters[3-i], step*Deadly.CinematicScale()) end
		end
		for _, f in ipairs(fighters) do
			if alive and not frozen and not SymV1.Held(f.model)and not SuperCraxV1.Held(f.model)and(state:GetAttribute('GhostNightActive')or not Fantastic.Hold(f))and not Deadly.Hold(f.model)and not f.capturedBy and not Plumber.Hold(f.model)and not Golden.Hold(f.model)and not Fleau.Hold(f.model)and workspace:GetServerTimeNow()>=(f.model:GetAttribute("GhostTeleportUntil")or 0)then f.position = f.position + f.velocity * SymV1.Speed(f.model) * SuperCraxV1.Speed(f.model) * Plumber.Speed(f) * Skills.Slow(f.model) * Night.Slow(f.model) * Deadly.Slow(f.model) * Deadly.CinematicScale() * step + pushStep(f,step); walls(f) end
		end
		if alive and not frozen then
			PositionLock.Enforce(fighters[1]);PositionLock.Enforce(fighters[2]);Golden.Enforce(fighters)
 local a, b = fighters[1], fighters[2]
			local delta = b.position - a.position; local distance = delta.Magnitude; local radius = a.radius + b.radius
			local statueA=a.model:GetAttribute('GoldenStatue')==true
    or a.model:GetAttribute('FleauStunned')==true
    or a.model:GetAttribute('DeadlyStunned')==true
   local statueB=b.model:GetAttribute('GoldenStatue')==true
    or b.model:GetAttribute('FleauStunned')==true
    or b.model:GetAttribute('DeadlyStunned')==true
   local roundId=state:GetAttribute('RoundId')
   if statueContact.Round~=roundId then
    statueContact.Round=roundId;statueContact.Active=false
    statueContact.Last=-math.huge;statueContact.Fixed=nil
   end

   if statueA or statueB then
    -- Une statue n'a pas de vitesse physique, meme si sa direction
    -- sauvegardee doit etre conservee pour la fin de l'effet.
    touching=false
    if statueA and statueB then
     statueContact.Active=false;statueContact.Fixed=nil
    else
     local fixed=statueA and a or b
     local moving=statueA and b or a
     local offset=moving.position-fixed.position
     local gap=offset.Magnitude
     local blocked=Golden.Hold(moving.model)or Plumber.Hold(moving.model)
      or Deadly.Hold(moving.model)or Fantastic.Hold(moving)
      or moving.capturedBy~=nil
      or moving.model:GetAttribute('FantasticInvisible')
      or moving.model:GetAttribute('PlumberInTransit')
      or moving.model:GetAttribute('VicePortalTransit')
      or workspace:GetServerTimeNow()<(moving.model:GetAttribute('GhostTeleportUntil')or 0)

     if statueContact.Fixed~=fixed.model then
      statueContact.Active=false;statueContact.Last=-math.huge
      statueContact.Fixed=fixed.model
     end

     if not blocked and gap<radius then
      local velocity=moving.velocity
      local normal=gap>.0001 and offset/gap
       or(velocity.Magnitude>.001 and -velocity.Unit or Vector2.new(1,0))

      -- La separation deplace uniquement le Crax mobile.
      moving.position=fixed.position+normal*(radius+.003)
      moving.knockback=nil

      -- Reflexion sur obstacle immobile : v' = v - 2(v.n)n.
      local closing=velocity:Dot(normal)
      if closing<0 then
       local bounced=velocity-normal*(2*closing)
       local speed=math.max(moving.speed or 0,velocity.Magnitude)
       moving.velocity=(bounced.Magnitude>.001 and bounced.Unit or normal)*speed
      end

      local now=os.clock()
      if not state:GetAttribute('GhostNightActive')
       and not state:GetAttribute('GhostGrandFrissonActive')
       and not statueContact.Active and now-statueContact.Last>=.18 then
       statueContact.Last=now
       flash(moving,true);flash(fixed,true)
       moving.hitSound:Stop();moving.hitSound:Play()
       -- Le circuit serveur existant applique les degats normaux et
       -- Golden.Outgoing annule ceux provenant de la statue.
       biteHit:Fire(moving.model,fixed.model,nil,true)
      end
      statueContact.Active=true
     elseif blocked or gap>radius+.015 then
      statueContact.Active=false
     end
    end
   elseif distance < radius and not SymV1.SuppressContact(a.model,b.model)and not SuperCraxV1.SuppressNormalContact(a.model,b.model)and not Plumber.Hold(a.model)and not Plumber.Hold(b.model)and not Deadly.Hold(a.model)and not Deadly.Hold(b.model)and not Fantastic.BlockContact(a,b)then

				local normal = distance > .0001 and delta / distance or Vector2.new(1, 0)
				local separation = normal * (radius - distance + .002)
                if a.sting or b.sting then separation=Vector2.zero end
				if Golden.Hold(a.model)then b.position=b.position+separation
 elseif Golden.Hold(b.model)then a.position=a.position-separation
 elseif a.model:GetAttribute("FantasticPinned") then b.position=b.position+separation
 elseif b.model:GetAttribute("FantasticPinned") then a.position=a.position-separation
 elseif a.capturedBy then b.position = b.position + separation
				elseif b.capturedBy then a.position = a.position - separation
				else a.position = a.position - separation / 2; b.position = b.position + separation / 2 end
				local hitA = webImpact(a, b)
				local hitB = state:GetAttribute("Phase") == "Fighting" and webImpact(b, a)
				if state:GetAttribute("GhostGrandFrissonActive") and not touching then
     Night.Contact(a.model,b.model)
    end
    if not state:GetAttribute("GhostNightActive") and not state:GetAttribute("GhostGrandFrissonActive") and (not touching or hitA or hitB) then
					flash(a, true); flash(b, true); a.hitSound:Stop(); a.hitSound:Play()
					-- Une toile peut capturer une cible déjà au contact, sans dégât doublé.
					if not hitA and not hitB then biteHit:Fire(a.model, b.model, nil, true) end
				end
				local approach = (a.velocity - b.velocity):Dot(normal)
				if approach > 0 and not a.sting and not b.sting then
					local sa = isSpider(a) and math.max(a.speed, a.velocity.Magnitude) or a.speed
					local sb = isSpider(b) and math.max(b.speed, b.velocity.Magnitude) or b.speed
					if not a.capturedBy then
						a.velocity = a.velocity - normal * approach
						a.velocity = (a.velocity.Magnitude > .001 and a.velocity.Unit or -normal) * sa
					end
					if not b.capturedBy then
						b.velocity = b.velocity + normal * approach
						b.velocity = (b.velocity.Magnitude > .001 and b.velocity.Unit or normal) * sb
					end
				end
				touching = true
			elseif distance > radius + .15 then touching = false end
		end
		if alive and not frozen then Plumber.EnforceBarriers();Golden.Enforce(fighters)end
	end
	Golden.Enforce(fighters)
	Fleau.Enforce(fighters)
	for _, f in ipairs(fighters) do
		local fade = 1 - f.flashTime / .18
		f.flash.FillTransparency = .55 + .45 * fade; f.flash.OutlineTransparency = fade; move(f)
	end
end)
state:SetAttribute("MovementReady", true)
print("ArenaMovement prêt : SpideyCrax et directions de départ.")
