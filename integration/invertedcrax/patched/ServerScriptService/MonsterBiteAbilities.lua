local InvertedSilence=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSilenceGate'))
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxBiteAuraDuration_v3
-- CopEmRefine_v4
-- CopEmPremium_v3
-- CopEmRepair_v2
-- CopEmSourire_v1
-- CraxBiteSmooth_v1
local BiteSmoothRS=game:GetService("ReplicatedStorage")
local BiteSmoothEvent=BiteSmoothRS:WaitForChild("CraxBiteSmoothEvent")
local BiteActionEvent=BiteSmoothRS:WaitForChild("CraxBiteActionEvent")
local SkillResolver=require(game:GetService("ServerScriptService"):WaitForChild("CraxSkillResolver"))
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")

local state = workspace:WaitForChild("CombatState")
state:SetAttribute("AbilitiesReady", false)

local biteHit = ServerScriptService:WaitForChild("BiteHit")
assert(biteHit:IsA("BindableEvent"), "BiteHit doit être un BindableEvent.")

-- Trois claquements rapides.
local BITE_COUNT = 3
local CHARGE = 0.30
local OPEN = 0.16
local HOLD = 0.04
local CLOSE = 0.10
local GAP = 0.08
local RECOVER = 0.25

local BITE_DURATION = OPEN + HOLD + CLOSE
local STEP_DURATION = BITE_DURATION + GAP
local ACTIVE_END =
	CHARGE + BITE_COUNT * BITE_DURATION + (BITE_COUNT - 1) * GAP
local TOTAL = ACTIVE_END + RECOVER

local RANGE_SEGMENTS = 80
local RANGE_THICKNESS = 0.14

local fighters = {}

local function createRange(model)
	local name = "BiteRange_" .. model.Name
	local old = workspace:FindFirstChild(name)

	if old then
		old:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = workspace

	local function makePart(partName)
		local part = Instance.new("Part")
		part.Name = partName
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(255, 45, 60)
		part.Transparency = 1
		part.Parent = folder
		return part
	end

	local range = {
		segments = {},
		icons = {},
	}

	for i = 1, RANGE_SEGMENTS do
		range.segments[i] = makePart("Contour")
	end

	for i = 1, 4 do
		local anchor = makePart("Danger")

		local gui = Instance.new("SurfaceGui")
		gui.Name = "Warning"
		gui.Face = Enum.NormalId.Front
		gui.CanvasSize = Vector2.new(128, 128)
		gui.LightInfluence = 0
		gui.AlwaysOnTop = false
		gui.Enabled = false
		gui.Parent = anchor

		local triangle = Instance.new("TextLabel")
		triangle.Size = UDim2.fromScale(1, 1)
		triangle.BackgroundTransparency = 1
		triangle.Font = Enum.Font.GothamBold
		triangle.Text = "▲"
		triangle.TextScaled = true
		triangle.TextColor3 = Color3.fromRGB(255, 110, 70)
		triangle.TextStrokeColor3 = Color3.fromRGB(255, 40, 55)
		triangle.TextStrokeTransparency = 0.25
		triangle.Parent = gui

		local mark = Instance.new("TextLabel")
		mark.Position = UDim2.fromScale(0.2, 0.25)
		mark.Size = UDim2.fromScale(0.6, 0.6)
		mark.BackgroundTransparency = 1
		mark.Font = Enum.Font.GothamBlack
		mark.Text = "!"
		mark.TextScaled = true
		mark.TextColor3 = Color3.fromRGB(45, 8, 12)
		mark.ZIndex = 2
		mark.Parent = gui

		range.icons[i] = {
			part = anchor,
			gui = gui,
			triangle = triangle,
			mark = mark,
		}
	end

	return range
end

local function updateRange(f, visible)
	local radius =
		f.head.Size.X / 2 + (f.model:GetAttribute("BiteExtraRange") or 0)

	local arc = 2 * math.pi / RANGE_SEGMENTS
	local length = 2 * radius * math.sin(arc / 2) + 0.005
	local center = f.head.Position
	local depth = -0.58

	local backdrop =
		workspace:FindFirstChild("ArenaBackdrop")
		or workspace:FindFirstChild("ArenaFloor")

	if backdrop and backdrop:IsA("BasePart") and backdrop.Size.Y > 20 then
		depth = backdrop.Position.Z - backdrop.Size.Z / 2 - 0.08
	end

	local age = f.elapsed or 0
	local opacity = 0

	if visible then
		opacity = math.clamp(
			math.min(age / 0.10, ((f.activeEnd or ACTIVE_END) + 0.15 - age) / 0.15),
			0,
			1
		)
	end

	local pulse = (math.sin(age * math.pi * 2 * 4) + 1) / 2
	local alpha = 1 - (0.60 + 0.18 * pulse) * opacity

	for i, part in ipairs(f.range.segments) do
		part.Transparency = alpha

		if opacity > 0 then
			local angle = (i - 0.5) * arc
			local midpoint = radius * math.cos(arc / 2)

			part.Size = Vector3.new(length, RANGE_THICKNESS, 0.025)
			part.CFrame = CFrame.new(
				center.X + midpoint * math.cos(angle),
				center.Y + midpoint * math.sin(angle),
				depth
			) * CFrame.Angles(0, 0, angle + math.pi / 2)
		end
	end

	for i, icon in ipairs(f.range.icons) do
		icon.gui.Enabled = opacity > 0

		if opacity > 0 then
			local angle = math.pi / 4 + (i - 1) * math.pi / 2
			local size = 1.25 * (1 + 0.05 * pulse)

			icon.part.Size = Vector3.new(size, size, 0.015)
			icon.part.CFrame = CFrame.new(
				center.X + radius * 0.82 * math.cos(angle),
				center.Y + radius * 0.82 * math.sin(angle),
				depth - 0.035
			)

			icon.triangle.TextTransparency =
				1 - (0.70 + 0.15 * pulse) * opacity
			icon.triangle.TextStrokeTransparency = 1 - 0.65 * opacity
			icon.mark.TextTransparency = 1 - 0.9 * opacity
		end
	end
end

local known = {
	"Throat",
	"UpperShell",
	"LowerShell",
	"UpperGums",
	"LowerGums",
	"InnerUpper",
	"InnerLower",
	"UpperFangs",
	"LowerFangs",
	"AngryEyeLeft",
	"AngryEyeRight",
	"AngrySocketLeft",
	"AngrySocketRight",
	"AngryPupilLeft",
	"AngryPupilRight",
	"AngryGlintLeft",
	"AngryGlintRight",
	"UpperFangGums",
	"LowerFangGums",
	"EyeLeft",
	"EyeRight",
}

local function classify(part, model)
	local current = part

	while current and current ~= model do
		for _, key in ipairs(known) do
			if current.Name == key or current.Name == key .. "_Node" then
				return key
			end
		end

		if current.Name:match("^Tooth_0_") then
			return "UpperTeeth"
		end

		if current.Name:match("^Tooth_1_") then
			return "LowerTeeth"
		end

		current = current.Parent
	end
end

local function prepare(name, index)
	local model = workspace:FindFirstChild(name)
	assert(model, "Introuvable : " .. name)

	local head = model:FindFirstChild("Head", true)

	if head and not head:IsA("BasePart") then
		head = head:FindFirstChildWhichIsA("BasePart", true)
	end

	assert(head, "Head introuvable dans " .. name)

	local visual = {}
	local counts = {}

	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false

			local kind = classify(part, model)

			if part == head then
				part.Transparency = 1
			elseif kind then
				table.insert(visual, {
					part = part,
					kind = kind,
					rest = head.CFrame:ToObjectSpace(part.CFrame),
				})

				counts[kind] = (counts[kind] or 0) + 1

				if kind == "AngryEyeLeft"
					or kind == "AngryEyeRight"
					or kind:match("^AngryGlint") then
					part.Material = Enum.Material.Neon
				end
			end
		end
	end

	assert(
		counts.UpperShell and counts.LowerShell,
		"Modèle MonsterHead requis : " .. name
	)

	assert(
		counts.AngryEyeLeft and counts.AngryEyeRight,
		"Les yeux rouges sont introuvables dans " .. name
	)

	local centers = {}
	local totals = {}

	for _, v in ipairs(visual) do
		centers[v.kind] =
			(centers[v.kind] or Vector3.zero) + v.rest.Position
		totals[v.kind] = (totals[v.kind] or 0) + 1
	end

	local function center(kind)
		return centers[kind] / totals[kind]
	end

	local up = (center("UpperShell") - center("LowerShell")).Unit
	local eyeCenter = (center("AngryEyeLeft") + center("AngryEyeRight")) / 2
	local front = eyeCenter - up * eyeCenter:Dot(up)

	assert(front.Magnitude > 0.001, "Orientation introuvable : " .. name)

	front = front.Unit

	local right = front:Cross(up).Unit
	up = right:Cross(front).Unit

	local anatomy = CFrame.fromMatrix(Vector3.zero, right, up, -front)
	local radius = math.max(head.Size.X, head.Size.Y, head.Size.Z) / 2

	for _, child in ipairs(head:GetChildren()) do
		if child.Name == "MonsterBiteSound"
			or child.Name == "BiteOrigin"
			or child.Name == "BiteSnapSound" then
			child:Destroy()
		end
	end

	local sound = Instance.new("Sound")
	sound.Name = "MonsterBiteSound"
	sound.Volume = 0.8
	sound.PlaybackSpeed = 1
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = 60
	sound.RollOffMaxDistance = 180
	sound.Parent = head

	local attachment = Instance.new("Attachment")
	attachment.Name = "BiteOrigin"
	attachment.Position = anatomy:PointToWorldSpace(
		Vector3.new(0, -radius * 0.15, -radius - 0.1)
	)
	attachment.Parent = head

	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Rate = 0
	emitter.Lifetime = NumberRange.new(0.2, 0.45)
	emitter.Speed = NumberRange.new(8, 16)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Color = ColorSequence.new(
		Color3.fromRGB(255, 220, 120),
		Color3.fromRGB(255, 65, 20)
	)
	emitter.LightEmission = 0.9
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	emitter.Parent = attachment

	table.insert(fighters, {
		model = model,
		head = head,
		visual = visual,
		anatomy = anatomy,
		radius = radius,
		sound = sound,
		emitter = emitter,
		range = createRange(model),
		clock = -(index - 1) * 1.25,
		elapsed = nil,
		nextBite = 1,
	})
end

prepare("Fighter1", 1)
prepare("Fighter2", 2)

local function apply(f, amount, threat)
 -- FantasticSkinGuard_v1
 if f.model:GetAttribute("CraxId") == "Crax_Fantastic"or f.model:GetAttribute("CraxId")=="Crax_Deadly"then
  return
 end

	local r = f.radius
	local hinge = Vector3.new(
		0,
		-r * 0.29,
		r * math.sqrt(1 - 0.29 * 0.29)
	)

 local function jaw(angle)
  return f.anatomy * CFrame.new(hinge) * CFrame.Angles(math.rad(angle)*amount,0,0)
   * CFrame.new(-hinge) * f.anatomy:Inverse()
 end
 local upperTransform,lowerTransform=jaw(8),jaw(-24)
 for _,v in ipairs(f.visual)do
  local lower=v.kind:match("^Lower") or v.kind=="InnerLower"
  local transform=lower and lowerTransform or upperTransform

		if v.kind == "Throat" then
			transform = CFrame.identity
		end

		v.part.CFrame = f.head.CFrame * transform * v.rest

		if v.kind == "Throat" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperGums" or v.kind == "LowerGums" then
			v.part.Transparency = math.clamp(amount * 2, 0, 1)
		elseif v.kind == "UpperTeeth" or v.kind == "LowerTeeth" then
			v.part.Transparency = math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperFangs"
			or v.kind == "LowerFangs"
			or v.kind == "UpperFangGums"
			or v.kind == "LowerFangGums" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "EyeLeft" or v.kind == "EyeRight" then
			v.part.Transparency = threat and 1 or 0
		elseif v.kind:match("^Angry") then
			v.part.Transparency = threat and 0 or 1
		else
			v.part.Transparency = 0
		end
	end
end

local function playBiteSound(f)
 -- Les trois claquements sont préchargés et synchronisés côté client.
 -- Le serveur reste responsable des trois vérifications de portée et des dégâts.
end

-- Effets de morsure réussie, indépendants des modèles des combattants.
local HIT_SOUND_ID = "9119055732"
local HIT_EFFECT_DURATION = 0.46
local hitEffects = {}

local oldEffects = workspace:FindFirstChild("CraxBiteImpactEffects")
if oldEffects then oldEffects:Destroy() end
local effectsFolder = Instance.new("Folder")
effectsFolder.Name = "CraxBiteImpactEffects"
effectsFolder.Parent = workspace

local function clearHitEffects()
	for _, effect in pairs(hitEffects) do
		effect.model:Destroy()
	end
	hitEffects = {}
end

local function playHitSound(other)
 BiteSmoothEvent:FireAllClients(other.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow())
end

local function updateHitEffects(dt)
	local phase = state:GetAttribute("Phase")
	if state:GetAttribute("GhostNightActive") or (phase ~= "Fighting" and phase ~= "RoundOver") then
		clearHitEffects()
		return
	end

	for target, effect in pairs(hitEffects) do
		effect.age += dt
		if effect.age >= HIT_EFFECT_DURATION or not target.Parent then
			effect.model:Destroy()
			hitEffects[target] = nil
		else
			local t = effect.age
			-- Les deux mâchoires se referment très vite sur la victime.
			local closing = math.clamp(t / 0.09, 0, 1)
			closing = 1 - (1 - closing) ^ 3
			local reopening = math.clamp((t - 0.20) / 0.26, 0, 1)
			local gap = effect.radius * (0.95 * (1 - closing) + 0.12 * reopening)
			local fade = math.clamp((t - 0.24) / 0.22, 0, 1)
			local position = target.Position
			-- Devant le visage, côté caméra de l'arène.
			local center = Vector3.new(
				position.X, position.Y,
				position.Z - target.Size.Z / 2 - 0.5
			)
			for _, item in ipairs(effect.parts) do
				item.part.CFrame = CFrame.new(center)
					* CFrame.new(0, item.side * gap, 0)
					* item.rest
				item.part.Transparency = item.alpha + (1 - item.alpha) * fade
			end
			effect.flash.FillTransparency = 0.60 + 0.40 * fade
			effect.flash.OutlineTransparency = fade
		end
	end
end

local function showHitJaw(other)
	local previous = hitEffects[other.head]
	if previous then previous.model:Destroy() end

	local model = Instance.new("Model")
	model.Name = "BiteOn_" .. other.model.Name
	local radius = math.max(other.head.Size.X, other.head.Size.Y) * 0.58
	local effect = {
		model = model,
		radius = radius,
		age = 0,
		parts = {},
	}

	local function addPart(name, size, rest, side, color, alpha)
		local part = Instance.new("Part")
		part.Name = name
		part.Size = size
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = color
		part.Transparency = 1
		part.Parent = model
		table.insert(effect.parts, {
			part = part, rest = rest, side = side, alpha = alpha,
		})
	end

	-- Deux arcs de gencives rouges et deux rangées de dents ivoire.
	for _, side in ipairs({ 1, -1 }) do
		local segments = 12
		for i = 1, segments do
			local a = (i - 1) * math.pi / segments
			local b = i * math.pi / segments
			local from = Vector3.new(
				math.cos(a) * radius,
				side * (0.12 * radius + math.sin(a) * radius * 0.45), 0
			)
			local to = Vector3.new(
				math.cos(b) * radius,
				side * (0.12 * radius + math.sin(b) * radius * 0.45), 0
			)
			local delta = to - from
			addPart("Gum", Vector3.new(delta.Magnitude + 0.04, radius * 0.13, 0.16),
				CFrame.new((from + to) / 2)
					* CFrame.Angles(0, 0, math.atan2(delta.Y, delta.X)),
				side, Color3.fromRGB(255, 65, 85), 0.12)
		end

		for i = 1, 7 do
			local x = (i - 4) * radius * 0.25
			local y = 0.12 * radius
				+ math.sqrt(math.max(0, 1 - (x / radius) ^ 2)) * radius * 0.45
			local length = radius * ((i == 2 or i == 6) and 0.48 or 0.34)
			addPart("Tooth", Vector3.new(radius * 0.18, length, 0.20),
				CFrame.new(x, side * (y - length / 2), -0.04),
				side, Color3.fromRGB(255, 250, 210), 0)
		end
	end

	local flash = Instance.new("Highlight")
	flash.Name = "BiteHitFlash"
	flash.Adornee = other.model
	flash.FillColor = Color3.fromRGB(255, 85, 65)
	flash.OutlineColor = Color3.fromRGB(255, 245, 170)
	flash.FillTransparency = 0.6
	flash.OutlineTransparency = 0
	flash.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	flash.Parent = model
	effect.flash = flash
	hitEffects[other.head] = effect

	-- Positionne les pièces avant de les publier dans Workspace.
	local center = other.head.Position
	- Vector3.new(0, 0, other.head.Size.Z / 2 + 0.5)
	for _, item in ipairs(effect.parts) do
		item.part.CFrame = CFrame.new(center)
			* CFrame.new(0, item.side * radius * 0.95, 0) * item.rest
		item.part.Transparency = item.alpha
	end
	model.Parent = effectsFolder
end

local TongueGeometry=require(BiteSmoothRS:WaitForChild("CraxTongueGeometry"))
local SkillConfig=require(BiteSmoothRS:WaitForChild("CraxSkillCatalog"))
local tongueEvent=BiteSmoothRS:WaitForChild("CraxTongueEvent")
local tongueRandom=Random.new()
local tonguePush=game:GetService("ServerScriptService"):WaitForChild("CraxTonguePush")
local function setupTongue(f,other)
 f.tongue=nil
 if f.attackLevel<2 then return end
 local spec=SkillConfig.Crax_Monster
 local enemyRadius=other.head.Size.X/2
 local biteReach=f.head.Size.X/2+enemyRadius+(f.model:GetAttribute("BiteExtraRange")or 0)
 local length=math.max(1,biteReach*(spec.TongueReachMultiplier or 2)-enemyRadius-f.radius*.5)
 local width=spec.TongueWidthPremium or 4.2
 local snapIndex=tongueRandom:NextInteger(1,f.biteCount)
 local start=CHARGE+(snapIndex-1)*STEP_DURATION+OPEN*.15
 f.tongue={start=start,angle=tongueRandom:NextNumber(0,math.pi*2),sign=tongueRandom:NextInteger(0,1)==0 and -1 or 1,hit=false,previous=0,previousEnemy=nil,notified=false,length=length,width=width}
 f.model:SetAttribute("TongueFXLength",length)
 f.model:SetAttribute("TongueFXWidth",width)
 f.model:SetAttribute("TongueFXAngle",f.tongue.angle)
 f.model:SetAttribute("TongueFXSign",f.tongue.sign)
 f.model:SetAttribute("TongueFXRound",state:GetAttribute("RoundId"))
 f.model:SetAttribute("TongueFXStartedAt",f.model:GetAttribute("BiteFXStartedAt")+start)
end
local function updateTongue(f,other,t)
 if AbilityGate.Paused(f.model)then return end
 local tongue=f.tongue
 if not tongue or t<tongue.start then return end
 local spec=SkillConfig.Crax_Monster
 local current=math.min(TongueGeometry.Duration,t-tongue.start)
 local origin=f.head.Position+f.head.CFrame:VectorToWorldSpace(f.anatomy:VectorToWorldSpace(Vector3.new(0,-f.radius*.17,-f.radius*.82)))
 local enemy=Vector3.new(other.head.Position.X,other.head.Position.Y,0)
 local oldEnemy=tongue.previousEnemy or enemy
 local prev=tongue.previous
 local steps=math.max(1,math.ceil((current-prev)/.008))
 if not tongue.hit and current>=TongueGeometry.SweepStart then
  for j=1,steps do
   local time=prev+(current-prev)*j/steps
   if time>=TongueGeometry.SweepStart and time<=TongueGeometry.SweepEnd then
    local target=oldEnemy:Lerp(enemy,j/steps)
    local previous=TongueGeometry.Point(origin,f.radius,tongue.length,tongue.angle,tongue.sign,time,0)
    for n=1,TongueGeometry.Segments do
     local point=TongueGeometry.Point(origin,f.radius,tongue.length,tongue.angle,tongue.sign,time,n/TongueGeometry.Segments)
     local a=Vector3.new(previous.X,previous.Y,0);local b=Vector3.new(point.X,point.Y,0)
     if TongueGeometry.DistanceSegment(target,a,b)<=math.max(other.head.Size.X,other.head.Size.Y)/2+tongue.width*.5
      and (other.model:GetAttribute("Health")or 0)>0 and not other.model:GetAttribute("GhostInvulnerable")then
      tongue.hit=true
      biteHit:Fire(f.model,other.model,spec.TongueDamage,false,"MonsterTongue")
      tonguePush:Fire(f.model,other.model)
      tongueEvent:FireAllClients(f.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow(),true,other.head.Position,other.model.Name)
      tongue.notified=true
      break
     end
     previous=point
    end
   end
   if tongue.hit then break end
  end
 end
 tongue.previous=current;tongue.previousEnemy=enemy
 if current>=TongueGeometry.SweepEnd and not tongue.notified then
  tongue.notified=true
  tongueEvent:FireAllClients(f.model.Name,state:GetAttribute("RoundId"),workspace:GetServerTimeNow(),false,origin)
 end
end

local function snap(f, other)
 local Deadly=require(ServerScriptService:WaitForChild('CraxDeadlyRuntime'))
 if not AbilityGate.Paused(f.model)and not Deadly.Flash()and state:GetAttribute('Phase')=='Fighting'and not state:GetAttribute('GhostNightActive')then
  for _,target in ipairs(Deadly.Targets(other.model))do
   if target~=other.model then local h=target:FindFirstChild('Head',true);if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
    if h and(Vector2.new(h.Position.X,h.Position.Y)-Vector2.new(f.head.Position.X,f.head.Position.Y)).Magnitude<=f.head.Size.X/2+h.Size.X/2+(f.model:GetAttribute('BiteExtraRange')or 0)then biteHit:Fire(f.model,target,nil,false,'MonsterBite')end
   end
  end
 end
 if AbilityGate.Paused(f.model)then return end
	if state:GetAttribute("GhostNightActive") or workspace:GetServerTimeNow() < (state:GetAttribute("GhostFreezeUntil") or 0) or state:GetAttribute("Phase") ~= "Fighting" then
		return
	end

	playBiteSound(f)

	-- La portée est vérifiée à chaque morsure.
	local delta = other.head.Position - f.head.Position
	local distance = Vector2.new(delta.X, delta.Y).Magnitude
	local reach =
		f.head.Size.X / 2
		+ other.head.Size.X / 2
		+ (f.model:GetAttribute("BiteExtraRange") or 0)

	local attackerHealth = f.model:GetAttribute("Health") or 0
	local targetHealth = other.model:GetAttribute("Health") or 0
	local damage = f.model:GetAttribute("BiteDamage") or 0

	if distance <= reach and attackerHealth > 0 and targetHealth > 0 and damage > 0 then
		showHitJaw(other)
		playHitSound(other)
		f.emitter:Emit(35)
		other.emitter:Emit(15)

		-- CombatHealth utilise les dégâts habituels de morsure.
		biteHit:Fire(f.model, other.model, nil, false, "MonsterBite")
	else
		f.emitter:Emit(5)
	end
end

local function smooth(t)
	t = math.clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

local function mouthAmount(t, activeEnd)
	if t < CHARGE or t >= activeEnd then
		return 0
	end

	local within = (t - CHARGE) % STEP_DURATION

	if within < OPEN then
		return smooth(within / OPEN)
	elseif within < OPEN + HOLD then
		return 1
	elseif within < BITE_DURATION then
		return 1 - smooth((within - OPEN - HOLD) / CLOSE)
	end

	return 0
end

local function resetRound()
	clearHitEffects()
	for index, f in ipairs(fighters) do
		f.clock = -(index - 1) * 1.25
		f.elapsed = nil
		f.nextBite = 1

		for _, child in ipairs(f.head:GetChildren()) do
			if child.Name == "BiteSnapSound" or child.Name == "BiteImpactSound" then
				child:Destroy()
			end
		end

		f.emitter:Clear()
		apply(f, 0, false)
		updateRange(f, false)
	end
end

resetRound()
state:GetAttributeChangedSignal("RoundId"):Connect(resetRound)

RunService.Heartbeat:Connect(function(dt)
	updateHitEffects(dt)
	for index, f in ipairs(fighters) do
		local fighting = state:GetAttribute("Phase") == "Fighting" and not state:GetAttribute("GhostNightActive") and workspace:GetServerTimeNow() >= (state:GetAttribute("GhostFreezeUntil") or 0)
		local enabled = f.model:GetAttribute("AbilityId") == "MonsterBite"

		if fighting and enabled and AbilityGate.Paused(f.model)then
            -- Conserve f.clock, f.elapsed, nextBite et progression de langue.
            -- Les clients utilisent la même horloge pour figer leur rendu.
            updateRange(f,f.elapsed~=nil and f.elapsed<(f.activeEnd or ACTIVE_END)+.15)
        elseif fighting and enabled then
            local liveLevel=SkillResolver.Resolve(f.model,index)
            if f.elapsed==nil or (f.attackLevel or liveLevel)<1 then f.clock+=dt end
            local cooldown=liveLevel>=1 and 4 or (f.model:GetAttribute("BiteCooldown")or 3)

			if f.elapsed == nil
				and f.clock >= cooldown and InvertedSilence.CanStart(f.model)then
				f.clock = 0
				f.elapsed = 0
				f.nextBite = 1
				f.attackLevel=math.clamp(tonumber(f.model:GetAttribute("CraxSkillLevel"))or 0,0,3)
                f.biteCount=f.attackLevel>=1 and 5 or 3
                f.activeEnd=CHARGE+f.biteCount*BITE_DURATION+(f.biteCount-1)*GAP
                f.total=f.activeEnd+RECOVER+(f.attackLevel>=2 and .20 or 0)
                f.model:SetAttribute("BiteFXCount",f.biteCount)
                f.model:SetAttribute("BiteFXDuration",f.total)
                f.model:SetAttribute("BiteFXRound",state:GetAttribute("RoundId"))
				f.model:SetAttribute("BiteFXStartedAt",AbilityGate.Time(f.model)-dt)
                setupTongue(f,fighters[3-index])
                BiteActionEvent:FireAllClients({Name=f.model.Name,Round=state:GetAttribute("RoundId"),Started=f.model:GetAttribute("BiteFXStartedAt"),Count=f.biteCount,Duration=f.total,Level=f.attackLevel,Anatomy=f.anatomy,Tongue=f.tongue and {Started=f.model:GetAttribute("TongueFXStartedAt"),Angle=f.tongue.angle,Sign=f.tongue.sign,Length=f.tongue.length,Width=f.tongue.width}or nil})
			end

			local amount = 0
			local threat = false
			local showRange = false

			if f.elapsed ~= nil then
				f.elapsed += dt

				local t = f.elapsed
				local other = fighters[index == 1 and 2 or 1]

				updateTongue(f,other,t)
                if state:GetAttribute("Phase")=="Fighting" then
                while f.nextBite <= f.biteCount do
					local snapTime =
						CHARGE
						+ (f.nextBite - 1) * STEP_DURATION
						+ BITE_DURATION

					if t < snapTime then
						break
					end

					f.nextBite += 1
					snap(f, other)

					if state:GetAttribute("Phase") ~= "Fighting" then
						break
					end
				end

                end
				if state:GetAttribute("Phase") ~= "Fighting" then
					f.elapsed = nil
				elseif t >= f.total then
                    if f.attackLevel>=1 then f.clock=0 end
					f.elapsed = nil
				else
					amount = mouthAmount(t,f.activeEnd)
					threat = true
					showRange = t < f.activeEnd + 0.15
				end
			end

			apply(f, amount, threat)
			updateRange(f, showRange)
		else
			f.elapsed = nil
			apply(f, 0, false)
			updateRange(f, false)
		end
	end
end)

state:SetAttribute("AbilitiesReady", true)
state:GetAttributeChangedSignal("Phase"):Connect(function()
	local phase = state:GetAttribute("Phase")
	if state:GetAttribute("GhostNightActive") or (phase ~= "Fighting" and phase ~= "RoundOver") then
		clearHitEffects()
		for _, f in ipairs(fighters) do
			for _, child in ipairs(f.head:GetChildren()) do
				if child.Name == "BiteImpactSound" then child:Destroy() end
			end
		end
	end
end)

print("MonsterBiteAbilities prêt : triple morsure et impacts visuels.")
state:GetAttributeChangedSignal("GhostNightActive"):Connect(function()
 if not state:GetAttribute("GhostNightActive") then return end
 clearHitEffects()
 for _, f in ipairs(fighters) do
  f.elapsed=nil; f.emitter:Clear(); apply(f,0,false); updateRange(f,false)
  for _, child in ipairs(f.head:GetChildren()) do
   if child.Name=="BiteSnapSound" or child.Name=="BiteImpactSound" then child:Destroy() end
  end
 end
end)
