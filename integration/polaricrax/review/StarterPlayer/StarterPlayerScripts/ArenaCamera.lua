-- PolariCraxIntegrationV1
-- LuckyCraxIntegrationV1
-- SymbiotiCraxIntegrationV1
-- DeadlyFinaleCompatibility_v1: restore visible imported OG only, retaining half-size.
local function deadlyActorHead(m)
 local visual=m and m:FindFirstChild('DeadlyVisual')
 local h=visual and visual:FindFirstChild('Head',true)
 if h and not h:IsA('BasePart')then h=h:FindFirstChildWhichIsA('BasePart',true)end
 return h
end
local function deadlyActorAlpha(c,p)
 local visual=c:FindFirstChild('DeadlyVisual')
 if not visual then return p.Transparency end
 if not p:IsDescendantOf(visual)then return 1 end
 local intended=p:GetAttribute('DeadlyIntendedAlpha')
 return intended~=nil and intended or p.Transparency
end
-- CraxDevourMax_v1
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local state = workspace:WaitForChild("CombatState")
local leaveEvent = RS:WaitForChild("ArenaLeaveRequest")

local TARGET = Vector3.new(0, 25, -0.5)
local FOV = 60
local GOLD = Color3.fromRGB(255, 211, 90)

local locked = false
local saved = {}
local countdownToken = 0
local leaving = false
local cameraPhase
local cameraSeat
local pullbackFrom
local pullbackFocus
local pullbackStarted = 0
local pullbackEnds = 0

local function waitingView()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local inward = root.Position.X <= 0 and 1 or -1
	-- L'avatar reste légèrement sur le côté, avec de l'espace vers l'arène.
	local focus = root.Position + Vector3.new(inward * 2.8, 2, 0)
	local position = focus + Vector3.new(0, 1, -16)
	return CFrame.lookAt(position, focus), CFrame.new(focus)
end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties) do
		object[key] = value
	end
	object.Parent = parent
	return object
end

local oldGui = playerGui:FindFirstChild("ArenaBattleGui")
if oldGui then
	oldGui:Destroy()
end

local gui = make("ScreenGui", {
	Name = "ArenaBattleGui",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 20,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local quitButton = make("TextButton", {
	Name = "QuitButton",
	Text = "QUITTER",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 1, -65),
	Size = UDim2.fromOffset(280, 76),
	BackgroundColor3 = Color3.fromRGB(220, 35, 55),
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBlack,
	TextSize = 32,
	TextColor3 = Color3.new(1, 1, 1),
	TextStrokeColor3 = Color3.new(1, 1, 1),
	TextStrokeTransparency = 0.5,
	AutoButtonColor = false,
	Visible = false,
}, gui)

make("UICorner", { CornerRadius = UDim.new(0, 18) }, quitButton)
make("UIStroke", {
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Color = Color3.fromRGB(255, 140, 140),
	Thickness = 2,
	Transparency = 0.2,
}, quitButton)

local quitScale = make("UIScale", { Scale = 1 }, quitButton)

local clickSound = make("Sound", {
	Name = "QuitClick",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.18,
}, gui)

-- Même son de menu discret, sans hauteur qui change.
local countSound = make("Sound", {
	Name = "SoftCountdown",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.09,
	PlaybackSpeed = 1,
}, gui)

local goSound = make("Sound", {
	Name = "SoftGo",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.14,
	PlaybackSpeed = 1,
}, gui)

local countdown = make("TextLabel", {
	Name = "GoldenCountdown",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(600, 180),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	TextSize = 120,
	TextColor3 = GOLD,
	TextStrokeColor3 = Color3.fromRGB(85, 45, 10),
	TextStrokeTransparency = 0.2,
	Visible = false,
}, gui)

make("UIGradient", {
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 200)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 210, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 150, 30)),
	}),
}, countdown)

local countScale = make("UIScale", { Scale = 1 }, countdown)
-- Interface locale : seul le joueur en attente voit ce message.
local waitingLabel = make("TextLabel", {
	Name = "WaitingForPlayers",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(740, 90),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 38,
	TextColor3 = Color3.fromRGB(255, 165, 75),
	TextStrokeColor3 = Color3.fromRGB(80, 35, 12),
	TextStrokeTransparency = 0.65,
	Text = "",
	Visible = false,
}, gui)

make("UIGradient", {
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 205)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 175, 100)),
	}),
}, waitingLabel)

local waitingScale = make("UIScale", { Scale = 1 }, waitingLabel)
local foundLabel = make("TextLabel", {
	Name = "OpponentFound",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(820, 110),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	TextSize = 56,
	TextColor3 = Color3.fromRGB(255, 40, 55),
	TextStrokeColor3 = Color3.fromRGB(65, 0, 8),
	TextStrokeTransparency = 0.15,
	Text = "Adversaire trouvé",
	ZIndex = 6,
	Visible = false,
}, gui)
local foundScale = make("UIScale", { Scale = 1 }, foundLabel)
local rushLayer = make("Frame", {
	Name = "PullbackSpeedLines",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 4,
	Visible = false,
}, gui)
local speedLines = {}
for i = 1, 28 do
	local angle = (i - 1) * math.pi * 2 / 28
	local streak = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(120, i % 3 == 0 and 3 or 2),
		BackgroundColor3 = i % 3 == 0
			and Color3.fromRGB(255, 55, 65) or Color3.fromRGB(255, 215, 215),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Rotation = math.deg(angle),
		ZIndex = 4,
	}, rushLayer)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}, streak)
	speedLines[i] = { frame = streak, angle = angle }
end

-- Réutilise le son déjà présent dans le jeu, avec deux couches plus graves.
local impactSound = make("Sound", {
	Name = "OpponentImpact",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.42,
	PlaybackSpeed = 0.55,
}, gui)
local rushSound = make("Sound", {
	Name = "OpponentRush",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.20,
	PlaybackSpeed = 0.85,
}, gui)
local rushActive = false

local function updateRush(seated, phase)
	local visible = seated and phase == "CameraTransition"
	if visible ~= rushActive then
		rushActive = visible
		foundLabel.Visible = visible
		rushLayer.Visible = visible
		impactSound:Stop()
		rushSound:Stop()
		if visible then
			SoundService:PlayLocalSound(impactSound)
			SoundService:PlayLocalSound(rushSound)
		else
			foundLabel.Rotation = 0
		end
	end
end

local function applyRush(camera)
	if not rushActive then
		return
	end
	local duration = state:GetAttribute("CameraTransitionDuration") or 0.85
	local ending = state:GetAttribute("CameraTransitionEnd")
		or workspace:GetServerTimeNow()
	local progress = math.clamp(
		1 - (ending - workspace:GetServerTimeNow()) / math.max(0.01, duration), 0, 1
	)
	-- Impact fort au début, puis extinction douce avant le 3–2–1.
	local strength = (1 - progress) ^ 1.5
	local t = os.clock()
	local nx = math.noise(t * 48, 12, 0) * 2
	local ny = math.noise(0, t * 53, 34) * 2
	local roll = math.noise(56, 0, t * 46) * 2
	camera.CFrame = camera.CFrame
		* CFrame.new(nx * 0.28 * strength, ny * 0.22 * strength, 0)
		* CFrame.Angles(
			math.rad(ny * 1.7 * strength),
			math.rad(nx * 1.7 * strength),
			math.rad(roll * 2.6 * strength)
		)
	camera.FieldOfView = FOV + 13 * math.sin(progress * math.pi)
	local screen = camera.ViewportSize
	local scale = math.min(1, screen.X * 0.92 / 820)
	foundScale.Scale = scale * (1 + 0.18 * strength)
	foundLabel.Position = UDim2.new(0.5, nx * 7 * strength, 0.5, ny * 5 * strength)
	foundLabel.Rotation = roll * 2 * strength
	foundLabel.TextTransparency = math.clamp((progress - 0.82) / 0.18, 0, 1)

	local radius = math.max(screen.X, screen.Y) * 0.5
	local fade = math.max(0, math.sin(math.pi * progress)) ^ 0.4 * strength
	-- Les traits accélèrent vers l'extérieur sans couvrir le texte central.
	for i, record in ipairs(speedLines) do
		local travel = (progress * 3 + i * 0.137) % 1
		local distance = radius * (0.36 + travel * 0.8)
		local streak = record.frame
		streak.Position = UDim2.fromOffset(
			screen.X / 2 + math.cos(record.angle) * distance,
			screen.Y / 2 + math.sin(record.angle) * distance
		)
		streak.Size = UDim2.fromOffset((65 + travel * 180) * scale, i % 3 == 0 and 3 or 2)
		streak.BackgroundTransparency = 1 - math.clamp(fade * 0.75, 0, 0.75)
	end
end

local waitingStarted = 0
local waitingTween
local lastWaitingDots = -1

local function updateWaiting(seated, phase)
	local visible = seated and phase == "Waiting"

	if waitingLabel.Visible ~= visible then
		if waitingTween then
			waitingTween:Cancel()
			waitingTween = nil
		end
		waitingLabel.Visible = visible
		lastWaitingDots = -1

		if visible then
			waitingStarted = os.clock()
			waitingLabel.TextTransparency = 1
			waitingLabel.TextStrokeTransparency = 1
			waitingTween = TweenService:Create(
				waitingLabel,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ TextTransparency = 0, TextStrokeTransparency = 0.65 }
			)
			waitingTween:Play()
		end
	end

	if visible then
		local dots = math.floor((os.clock() - waitingStarted) / 0.45) % 4
		if dots ~= lastWaitingDots then
			lastWaitingDots = dots
			-- Les espaces gardent le texte stable quand les points changent.
			waitingLabel.Text = "En attente de joueurs"
				.. string.rep(".", dots) .. string.rep(" ", 3 - dots)
		end
	end
end

local countTweens = {}
local buttonTween
local hover = false

local function play(sound)
	sound:Stop()
	SoundService:PlayLocalSound(sound)
end

local function animateButton(value)
	if buttonTween then
		buttonTween:Cancel()
	end
	buttonTween = TweenService:Create(
		quitScale,
		TweenInfo.new(0.16, Enum.EasingStyle.Quad),
		{ Scale = value }
	)
	buttonTween:Play()
end

quitButton.MouseEnter:Connect(function()
	hover = true
	animateButton(1.10)
end)

quitButton.MouseLeave:Connect(function()
	hover = false
	animateButton(1)
end)

quitButton.MouseButton1Down:Connect(function()
	animateButton(0.96)
end)

quitButton.MouseButton1Up:Connect(function()
	animateButton(hover and 1.10 or 1)
end)

quitButton.Activated:Connect(function()
	local phase = state:GetAttribute("Phase")

	if leaving
		or not player:GetAttribute("ArenaSeat")
		or (phase ~= "Waiting" and phase ~= "CameraTransition" and phase ~= "Preparing") then
		return
	end

	leaving = true
	play(clickSound)
	leaveEvent:FireServer()

	task.delay(0.5, function()
		leaving = false
	end)
end)

local function cancelCountTweens()
	for _, tween in ipairs(countTweens) do
		tween:Cancel()
	end
	countTweens = {}
end

local function showNumber(text)
	cancelCountTweens()
	countdown.Text = text
	countdown.Visible = true
	countdown.TextTransparency = 1
	countdown.TextStrokeTransparency = 1
	countdown.Rotation = -4
	countScale.Scale = 0.75

	local appear = TweenService:Create(
		countdown,
		TweenInfo.new(0.22, Enum.EasingStyle.Quad),
		{
			TextTransparency = 0,
			TextStrokeTransparency = 0.2,
			Rotation = 0,
		}
	)

	local grow = TweenService:Create(
		countScale,
		TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Scale = 1 }
	)

	local fade = TweenService:Create(
		countdown,
		TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0),
		{
			TextTransparency = 1,
			TextStrokeTransparency = 1,
		}
	)

	countTweens = { appear, grow, fade }
	appear:Play()
	grow:Play()
	local animationToken = countdownToken

	task.delay(0.65, function()
		if countdownToken == animationToken
			and countdown.Text == text
			and countdown.Visible then
			fade:Play()
		end
	end)
end

local function updateCountdown()
	countdownToken += 1
	local token = countdownToken
	local seated = player:GetAttribute("ArenaSeat") ~= nil
	local phase = state:GetAttribute("Phase")

	cancelCountTweens()
	countdown.Visible = false
	countSound:Stop()
	goSound:Stop()

	if not seated then
		return
	end

	if phase == "Preparing" then
		task.spawn(function()
			for number = 3, 1, -1 do
				if token ~= countdownToken
					or state:GetAttribute("Phase") ~= "Preparing"
					or not player:GetAttribute("ArenaSeat") then
					return
				end

				showNumber(tostring(number))
				play(countSound)
				task.wait(1)
			end

			if token == countdownToken then
				countdown.Visible = false
			end
		end)

	elseif phase == "Fighting" then
		showNumber("GO !")
		play(goSound)

		task.delay(0.95, function()
			if token == countdownToken then
				countdown.Visible = false
			end
		end)
	end
end

state:GetAttributeChangedSignal("Phase"):Connect(updateCountdown)
player:GetAttributeChangedSignal("ArenaSeat"):Connect(updateCountdown)

local function showAvatar()
	local character = player.Character
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.LocalTransparencyModifier = 0
			end
		end
	end
end

local function unlock()
	if not locked then
		return
	end
	locked = false
	cameraPhase = nil
	cameraSeat = nil
	pullbackFrom = nil
	pullbackFocus = nil
	local camera = workspace.CurrentCamera

	if camera then
		camera.CameraType = Enum.CameraType.Custom
		camera.FieldOfView = saved.fov or 70
		camera.FieldOfViewMode = saved.mode or Enum.FieldOfViewMode.Vertical

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			camera.CameraSubject = humanoid
		end
	end

	UserInputService.MouseBehavior = saved.mouseBehavior
		or Enum.MouseBehavior.Default
	UserInputService.MouseIconEnabled = saved.mouseIcon ~= false
end

-- Défaite locale puis zoom du vainqueur : aucune modification des combattants serveur.
local DEFEAT_DURATION = 0.9
local WINNER_ZOOM_DURATION = 0.65
local defeat
local defeatImpact = make("Sound", {
	Name = "CraxDefeatImpact", SoundId = "rbxassetid://110024396934410",
	Volume = 0.5, PlaybackSpeed = 0.65,
}, gui)
local defeatFall = make("Sound", {
	Name = "CraxDefeatFall", SoundId = "rbxassetid://113397864512278",
	Volume = 0.3, PlaybackSpeed = 0.4,
}, gui)
local function fighterHead(model)
	local head = deadlyActorHead(model)or(model and model:FindFirstChild("Head", true))
	if head and not head:IsA("BasePart") then head = head:FindFirstChildWhichIsA("BasePart", true) end
	return head
end
local function clearDefeat()
	if defeat then
		for part, transparency in pairs(defeat.originals) do
			if part.Parent then part.LocalTransparencyModifier = transparency end
		end
		defeat.folder:Destroy()
		defeat = nil
	end
	defeatImpact:Stop(); defeatFall:Stop()
end
local function beginDefeat() -- FantasticExclusiveFinale_v4
 if state:GetAttribute('RoundVictoryKind')=='PolariFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end
 if state:GetAttribute('RoundVictoryKind')=='LuckyFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end
 if state:GetAttribute('RoundVictoryKind')=='SymFinale'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end
 if state:GetAttribute('RoundVictoryKind')=='Buldozer'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then clearDefeat();return end
 local cinemaState=workspace:FindFirstChild('CombatState')
 local winnerName=cinemaState and cinemaState:GetAttribute('RoundWinner')
 local fantasticWinner=type(winnerName)=='string'and workspace:FindFirstChild(winnerName)
 if fantasticWinner and fantasticWinner:GetAttribute('CraxId')=='Crax_Fantastic'
  and(fantasticWinner:GetAttribute('CraxSkillLevel')or 0)>=4 then
  clearDefeat();return
 end

	if defeat or not player:GetAttribute("ArenaSeat") then return end
	local winner = state:GetAttribute("RoundWinner")
	if winner ~= "Fighter1" and winner ~= "Fighter2" and winner ~= "Draw" then return end
	local folder = Instance.new("Folder"); folder.Name = "LocalCraxDefeat"; folder.Parent = workspace
	defeat = {start = os.clock(), folder = folder, victims = {}, originals = {}, winner = winner, burst = false}
	for seat = 1, 2 do
		local model = workspace:FindFirstChild("Fighter" .. seat)
		local head = fighterHead(model)
		if head and (winner == "Draw" or model.Name ~= winner) then
			local archivable = model.Archivable; model.Archivable = true
			local clone = model:Clone(); model.Archivable = archivable
			clone.Name = "DefeatedCraxVisual"
			for _, item in ipairs(clone:GetDescendants()) do
				if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("BillboardGui")
					or item:IsA("Highlight") or item:IsA("Trail") or item:IsA("Beam") then item:Destroy()
				elseif item:IsA("BasePart") then
					item.Anchored = true; item.CanCollide = false; item.CanTouch = false; item.CanQuery = false
					item.LocalTransparencyModifier = 0;item.Transparency=deadlyActorAlpha(clone,item)
     if model:GetAttribute("CraxId")=="Crax_Ghosty" then
      local current=item
      local isGhost=false
      while current and current~=clone do
       if current.Name=="GhostVisual" then isGhost=true; break end
       current=current.Parent
      end
      if not isGhost then item.Transparency=1 end
     end
    elseif item:IsA("ParticleEmitter") then item.Enabled = false; item:Clear() end
			end
			clone.Parent = folder
			local parts = {}
			for _, item in ipairs(clone:GetDescendants()) do
				if item:IsA("BasePart") then parts[item] = item.Transparency end
			end
			for _, item in ipairs(model:GetDescendants()) do
				if item:IsA("BasePart") then defeat.originals[item] = item.LocalTransparencyModifier end
			end
			local flash = make("Highlight", {
				Adornee = clone, FillColor = Color3.fromRGB(255, 35, 60), OutlineColor = Color3.fromRGB(255, 150, 150),
				FillTransparency = .25, OutlineTransparency = .1, DepthMode = Enum.HighlightDepthMode.Occluded,
			}, folder)
			table.insert(defeat.victims, {clone=clone, pivot=clone:GetPivot(), scale=clone:GetScale(),
				center=head.Position, radius=math.max(head.Size.X,head.Size.Y,head.Size.Z)*.5, parts=parts, flash=flash})
		end
	end
	play(defeatImpact); play(defeatFall)
end
local function defeatBurst(record)
	local anchor = make("Part", {Name="DefeatBurst", Anchored=true, CanCollide=false, CanTouch=false,
		CanQuery=false, Transparency=1, Size=Vector3.one*.1, Position=record.center}, defeat.folder)
	local attachment = make("Attachment", {}, anchor)
	local sparks = make("ParticleEmitter", {
		Texture="rbxasset://textures/particles/sparkles_main.dds", Rate=0, Lifetime=NumberRange.new(.3,.7),
		Speed=NumberRange.new(9,19), SpreadAngle=Vector2.new(180,180), Drag=7, LightEmission=.8,
		Color=ColorSequence.new(Color3.fromRGB(255,100,70),Color3.fromRGB(255,205,130)),
		Size=NumberSequence.new(.32,0), Transparency=NumberSequence.new(.05,1),
	}, attachment)
	sparks:Emit(45)
	for i=1,14 do
		local angle=i*math.pi*2/14
		local direction=Vector3.new(math.cos(angle),math.sin(angle),-.12)
		local center=record.center+direction*record.radius*.5
		local shard=make("Part", {Name="DefeatShard", Anchored=true, CanCollide=false, CanTouch=false,
			CanQuery=false, CastShadow=false, Material=Enum.Material.Neon, Color=Color3.fromRGB(255,90,65),
			Size=Vector3.new(.1,.16,.42), CFrame=CFrame.lookAt(center,center+direction)}, defeat.folder)
		TweenService:Create(shard,TweenInfo.new(.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
			{CFrame=shard.CFrame+direction*record.radius*2.8, Size=Vector3.one*.02, Transparency=1}):Play()
		Debris:AddItem(shard,.5)
	end
end
-- SpideyCamera_v1
local SpideyFinale=require(RS:WaitForChild("CraxSpideyFinale"))
local Devour=require(RS:WaitForChild("CraxDevourVisuals"))
-- GhostyCamera_v2
local GhostyFinale=require(RS:WaitForChild("CraxGhostyFinale"))
local function applyDefeat(camera, arenaView, arenaFocus)
 if state:GetAttribute('RoundVictoryKind')=='Buldozer'and state:GetAttribute('RoundVictoryRound')==state:GetAttribute('RoundId')then if defeat then clearDefeat()end;return end
 local deadlyWinner=workspace:FindFirstChild(state:GetAttribute('RoundWinner')or '')
 if state:GetAttribute('Phase')=='RoundOver'and deadlyWinner and deadlyWinner:GetAttribute('CraxId')=='Crax_Deadly'and(deadlyWinner:GetAttribute('CraxSkillLevel')or 0)>=4 then
  if defeat then clearDefeat()end
  return
 end
 if GhostyFinale.Eligible()then
  if defeat then clearDefeat()end
  if GhostyFinale.Apply(camera,arenaView,arenaFocus)then return end
 else GhostyFinale.Clear()end

	local phase=state:GetAttribute("Phase")
	if phase ~= "RoundOver" or not player:GetAttribute("ArenaSeat") then
		if defeat then clearDefeat() end
		return
	end
	if SpideyFinale.Eligible()then
  if defeat then clearDefeat()end
  if SpideyFinale.Apply(camera,arenaView,arenaFocus)then return end
 end
 if Devour.Eligible()then
        if defeat then clearDefeat()end
        if Devour.Apply(camera,arenaView,arenaFocus)then return end
    end
	beginDefeat()
	if not defeat then return end
	local elapsed=os.clock()-defeat.start
	for part in pairs(defeat.originals) do if part.Parent then part.LocalTransparencyModifier=1 end end
	if elapsed>=.28 and not defeat.burst then
		defeat.burst=true
		for _,record in ipairs(defeat.victims) do defeatBurst(record) end
	end
	for _,record in ipairs(defeat.victims) do
		local vanish=math.clamp((elapsed-.28)/.42,0,1)
		local strength=math.max(0,1-elapsed/.5)
		local wobble=math.sin(elapsed*100)*.12*strength
		if record.clone.Parent then
			record.clone:ScaleTo(record.scale*(1-vanish*.72))
			record.clone:PivotTo(record.pivot*CFrame.new(wobble,-vanish*record.radius*.6,0)
				*CFrame.Angles(0,0,math.rad(math.sin(elapsed*80)*9*strength+vanish*24)))
			for part,original in pairs(record.parts) do
				if part.Parent then part.Transparency=original+(1-original)*vanish end
			end
			record.flash.FillTransparency=.25+.75*vanish
			record.flash.OutlineTransparency=.1+.9*vanish
		end
	end
	-- La caméra reste large pour montrer la défaite, puis rejoint le vainqueur.
	camera.CFrame=arenaView; camera.Focus=arenaFocus
	if elapsed<DEFEAT_DURATION then
		local strength=math.max(0,1-elapsed/.35)
		camera.CFrame=arenaView*CFrame.new(math.sin(elapsed*85)*.09*strength,math.cos(elapsed*91)*.065*strength,0)
	elseif defeat.winner ~= "Draw" then
		local head=fighterHead(workspace:FindFirstChild(defeat.winner))
		if head then
			local radius=math.max(head.Size.X,head.Size.Y,head.Size.Z)*.5
			local aspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
			local distance=math.max(10,radius*3.8,radius*3.8/math.max(.1,aspect))
			local focus=head.Position+Vector3.new(0,radius*.25,0)
			local winnerView=CFrame.lookAt(focus+Vector3.new(0,0,-distance),focus)
			local progress=math.clamp((elapsed-DEFEAT_DURATION)/WINNER_ZOOM_DURATION,0,1)
			local eased=TweenService:GetValue(progress,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut)
			camera.CFrame=arenaView:Lerp(winnerView,eased)
			camera.Focus=arenaFocus:Lerp(CFrame.new(focus),eased)
		end
	end
end
state:GetAttributeChangedSignal("Phase"):Connect(function()
	if state:GetAttribute("Phase") ~= "RoundOver" then clearDefeat() end
end)
state:GetAttributeChangedSignal("RoundId"):Connect(clearDefeat)
player:GetAttributeChangedSignal("ArenaSeat"):Connect(function()
	if not player:GetAttribute("ArenaSeat") then clearDefeat() end
end)

RunService:UnbindFromRenderStep("ArenaFixedCamera")
RunService:UnbindFromRenderStep("CraxArenaFrontCamera")

RunService:BindToRenderStep(
	"CraxArenaFrontCamera",
	Enum.RenderPriority.Last.Value + 100,
	function()
  if player:GetAttribute("PolariCameraOwner")then if defeat then clearDefeat()end;return end
  if player:GetAttribute("LuckyCameraOwner")then if defeat then clearDefeat()end;return end
  if player:GetAttribute("SymCameraOwner")then if defeat then clearDefeat()end;return end
		local seated = player:GetAttribute("ArenaSeat") ~= nil

		-- QUITTER : pendant l'attente et les trois secondes initiales.
		local phase = state:GetAttribute("Phase")
		updateWaiting(seated, phase)
		updateRush(seated, phase)
		local visible = seated
			and (phase == "Waiting" or phase == "CameraTransition" or phase == "Preparing")

		if quitButton.Visible ~= visible then
			quitButton.Visible = visible
			hover = false
			animateButton(1)
		end

		if not seated then
			unlock()
			return
		end

		local camera = workspace.CurrentCamera
		if not camera then
			return
		end

		if not locked then
			locked = true
			saved.fov = camera.FieldOfView
			saved.mode = camera.FieldOfViewMode
			saved.mouseBehavior = UserInputService.MouseBehavior
			saved.mouseIcon = UserInputService.MouseIconEnabled
		end

		showAvatar()
		camera.CameraType = Enum.CameraType.Scriptable
		camera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
		camera.FieldOfView = FOV

		local screen = camera.ViewportSize
		local aspect = screen.X / math.max(screen.Y, 1)
		local tangent = math.tan(math.rad(FOV / 2))
		local distance = math.max(
			25 / tangent,
			34 / (tangent * aspect)
		) * 1.04

		local arenaView = CFrame.lookAt(
			TARGET + Vector3.new(0, 0, -distance),
			TARGET
		)
		local arenaFocus = CFrame.new(TARGET)
		local seat = player:GetAttribute("ArenaSeat")

		if cameraPhase ~= phase or cameraSeat ~= seat then
			local newSeat = cameraSeat ~= seat
			cameraPhase = phase
			cameraSeat = seat

			if phase == "CameraTransition" then
				local closeView, closeFocus = waitingView()
				pullbackFrom = newSeat and closeView or camera.CFrame
				pullbackFocus = newSeat and closeFocus or camera.Focus
				pullbackFrom = pullbackFrom or arenaView
				pullbackFocus = pullbackFocus or arenaFocus
				pullbackStarted = workspace:GetServerTimeNow()
				pullbackEnds = state:GetAttribute("CameraTransitionEnd")
					or (pullbackStarted + 0.85)
			elseif phase ~= "Preparing" then
				pullbackFrom = nil
				pullbackFocus = nil
			end
		end

		if phase == "Waiting" then
			local closeView, closeFocus = waitingView()
			camera.CFrame = closeView or arenaView
			camera.Focus = closeFocus or arenaFocus
		elseif pullbackFrom and (phase == "CameraTransition" or phase == "Preparing") then
			local duration = math.max(0.001, pullbackEnds - pullbackStarted)
			local progress = math.clamp(
				(workspace:GetServerTimeNow() - pullbackStarted) / duration, 0, 1
			)
			local eased = TweenService:GetValue(
				progress, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut
			)
			camera.CFrame = pullbackFrom:Lerp(arenaView, eased)
			camera.Focus = pullbackFocus:Lerp(arenaFocus, eased)
			if progress >= 1 then
				pullbackFrom = nil
				pullbackFocus = nil
			end
		else
			camera.CFrame = arenaView
			camera.Focus = arenaFocus
		end

		-- Position du décompte exactement au centre de l'arène.
		applyRush(camera)
		applyDefeat(camera, arenaView, arenaFocus)
  if phase == "Fighting" and state:GetAttribute("GhostNightActive") then
   local start=state:GetAttribute("GhostNightStart") or 0
   local ending=state:GetAttribute("GhostNightEnd") or start+4
   local t=math.clamp((workspace:GetServerTimeNow()-start)/math.max(.01,ending-start),0,1)
   t=t*t*(3-2*t)
   camera.CFrame=CFrame.lookAt(TARGET+Vector3.new(0,0,-distance*(1-.045*t)),TARGET)
   camera.Focus=arenaFocus
  end
		local point = camera:WorldToViewportPoint(TARGET)
		countdown.Position = UDim2.fromOffset(point.X, point.Y)
		-- Avec le cadrage proche, le message reste lisible au centre de la vue.
		waitingLabel.Position = UDim2.fromScale(0.5, 0.5)
		waitingScale.Scale = math.min(1, screen.X * 0.9 / 740)

		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
)

updateCountdown()
