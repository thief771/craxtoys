-- PolariCraxIntegrationV1
-- LuckyCraxIntegrationV1
-- SymbiotiCraxIntegrationV1
-- SuperCraxIntegrationV1
-- CraxQuestIntegration_v1
-- FantasticRoundDuration_v1
-- GhostyRoundDuration_v3
-- CraxFinaleSequence_v3
-- CraxDevourMax_v1
-- CopEmPremium_v3
local RS = game:GetService("ReplicatedStorage")
local badgeEvent=RS:WaitForChild("CraxBadgeEvent")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local SELECTION_TIME = 30
local ROUNDS_TO_WIN = 3
local CAMERA_PULLBACK_TIME = 0.85
local victoryCatalog=require(RS:WaitForChild("CraxVictoryCatalog"))

local function ensureEvent(parent, name, className)
	local event = parent:FindFirstChild(name)

	if not event then
		event = Instance.new(className)
		event.Name = name
		event.Parent = parent
	end

	assert(event:IsA(className), name .. " doit être un " .. className)
	return event
end

ensureEvent(SSS, "BiteHit", "BindableEvent")

local selectionEvent = ensureEvent(
	RS,
	"CraxSelectionEvent",
	"RemoteEvent"
)

local catalog = require(RS:WaitForChild("CraxCatalog"))
local Selection = require(SSS:WaitForChild("CraxRoundSelection"))
local Direction = require(SSS:WaitForChild("CraxDirectionServer"))

local Skin = require(SSS:WaitForChild("CraxSkinServer"))
local fighters = {
	workspace:WaitForChild("Fighter1"),
	workspace:WaitForChild("Fighter2"),
}

local function configure(model, chosenId)
	local id = chosenId
		or model:GetAttribute("CraxId")
		or "Crax_Monster"

	local config = catalog[id]
	assert(config, "Crax absent du catalogue : " .. tostring(id))
	assert(type(config.Speed) == "number" and config.Speed > 0)
	assert(type(config.MaxHealth) == "number" and config.MaxHealth > 0)

	local ability = config.Ability or {}

	model:SetAttribute("CraxId", id)
	model:SetAttribute("DisplayName", config.DisplayName)
	model:SetAttribute("Rarity", config.Rarity)
	model:SetAttribute("MaxHealth", config.MaxHealth)
	model:SetAttribute("Speed", config.Speed)
	model:SetAttribute("CollisionDamage", config.CollisionDamage or 5)
	model:SetAttribute("AbilityId", ability.Id or "")
	model:SetAttribute("BiteDamage", ability.Damage or 20)
	model:SetAttribute("BiteCooldown", math.max(0.1, ability.Cooldown or 5))
	model:SetAttribute("BiteExtraRange", ability.ExtraRange or 3.25)
 local webKeys = {Cooldown="WebCooldown",WebSpeed="WebSpeed",Acceleration="WebAcceleration",
  MaxSpeed="WebMaxSpeed",CriticalDamage="WebCriticalDamage",MaxDamage="WebMaxDamage",
  MinDamage="WebMinDamage",DamageScale="WebDamageScale",MaxChargeTime="WebMaxChargeTime",CoastTime="WebCoastTime"}
 for key,attribute in pairs(webKeys) do
  model:SetAttribute(attribute,ability.Id=="SpideyWeb" and ability[key] or nil)
 end
 local nightKeys={Cooldown="NightCooldown",Duration="NightDuration",Damage="NightSlashDamage",BleedChance="NightBleedChance"}
 for key,attribute in pairs(nightKeys) do
  model:SetAttribute(attribute,ability.Id=="GhostNightSlash" and ability[key] or nil)
 end
 Skin.Apply(model,id,config)
end

configure(fighters[1])
configure(fighters[2])

local state = workspace:FindFirstChild("CombatState")

if not state then
	state = Instance.new("Folder")
	state.Name = "CombatState"
	state.Parent = workspace
end

-- CraxAbandonRound_v1
state:SetAttribute("ForfeitResolving", false)
state:SetAttribute("CraxMatchToken", "")
state:SetAttribute("Phase", "Waiting")
state:SetAttribute("RoundId", 0)
state:SetAttribute("RoundVictoryRound",nil)
state:SetAttribute("Score1", 0)
state:SetAttribute("Score2", 0)
state:SetAttribute("RoundWinner", "")
state:SetAttribute("ScoresVisible", false)
state:SetAttribute("MatchWinner", 0)
state:SetAttribute("MatchEndDeadline", 0)

local function prepareRoundVictory()
 if state:GetAttribute("Phase")~="RoundOver"then return end
 local round=state:GetAttribute("RoundId")
 -- GoldenVictoryOrderFix_v2
 -- Le bridge vérifie lui-même si cette victoire Golden a déjà été publiée.
 if require(SSS:WaitForChild("FleauFinaleBridge")).Publish(state)then return end
 if require(SSS:WaitForChild("CraxGoldenFinaleBridge")).Publish(state)then return end
 if state:GetAttribute("RoundVictoryRound")==round then return end
 local winner=state:GetAttribute("RoundWinner")
 local model=(winner=="Fighter1"or winner=="Fighter2")and workspace:FindFirstChild(winner)
 local spec=model and model:GetAttribute("CraxId")~="Crax_Golden" and model:GetAttribute("CraxId")~="Crax_Fleau" and victoryCatalog[model:GetAttribute("CraxId")]
 local enhanced=spec and(model:GetAttribute("CraxSkillLevel")or 0)>=spec.MinimumLevel
 local start=workspace:GetServerTimeNow()
 local duration=enhanced and((spec.IntroDuration or 0)+spec.Duration+spec.ZoomDuration+spec.HoldDuration)or 3
 if model and model:GetAttribute('CraxId')=='Crax_Super'then
  state:SetAttribute('SuperVictoryCrax','Crax_Super');state:SetAttribute('SuperVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0)
  state:SetAttribute('SuperVictoryMatch',state:GetAttribute('CraxMatchToken'));state:SetAttribute('SuperVictoryOwner',model.Name)
 end
 if model and model:GetAttribute('CraxId')=='Crax_Symbioti'then
 state:SetAttribute('SymVictoryCrax','Crax_Symbioti');state:SetAttribute('SymVictoryLevel',model:GetAttribute('CraxSkillLevel')or 0);state:SetAttribute('SymVictoryMatch',state:GetAttribute('CraxMatchToken'))
 end
 if model and model:GetAttribute('CraxId')=='Crax_Lucky'then state:SetAttribute('LuckyVictoryMatch',state:GetAttribute('CraxMatchToken'))end
 if model and model:GetAttribute('CraxId')=='Crax_Polari'then state:SetAttribute('PolariVictoryMatch',state:GetAttribute('CraxMatchToken'))end
 state:SetAttribute("RoundVictoryStartedAt",start)
 state:SetAttribute("RoundVictoryKind",enhanced and spec.Id or "")
 state:SetAttribute("RoundVictoryEndsAt",start+duration)
 state:SetAttribute("RoundVictoryRound",round)
end
state:GetAttributeChangedSignal("Phase"):Connect(prepareRoundVictory)

local oldDisplay = workspace:FindFirstChild("RoundDisplay")

if oldDisplay then
	oldDisplay:Destroy()
end

local anchor = Instance.new("Part")
anchor.Name = "RoundDisplay"
anchor.Size = Vector3.new(1, 1, 1)
anchor.Position = Vector3.new(0, 49, -0.6)
anchor.Transparency = 1
anchor.Anchored = true
anchor.CanCollide = false
anchor.CanTouch = false
anchor.CanQuery = false
anchor.CastShadow = false
anchor.Parent = workspace

local victoryGui = Instance.new("BillboardGui")
victoryGui.Size = UDim2.fromOffset(760, 100)
victoryGui.Adornee = anchor
victoryGui.MaxDistance = 250
victoryGui.AlwaysOnTop = true
victoryGui.Enabled = false
victoryGui.Parent = anchor

local victoryLabel = Instance.new("TextLabel")
victoryLabel.Size = UDim2.fromScale(1, 1)
victoryLabel.BackgroundTransparency = 1
victoryLabel.Font = Enum.Font.GothamBlack
victoryLabel.TextSize = 36
victoryLabel.TextWrapped = true
victoryLabel.TextColor3 = Color3.fromRGB(255, 225, 125)
victoryLabel.TextStrokeColor3 = Color3.fromRGB(40, 15, 10)
victoryLabel.TextStrokeTransparency = 0.2
victoryLabel.Parent = victoryGui

local function clearVictory()
	victoryGui.Enabled = false
	victoryLabel.Text = ""
end

local function playerAtSeat(seat)
	for _, player in ipairs(Players:GetPlayers()) do
		if player:GetAttribute("ArenaSeat") == seat then
			return player
		end
	end
end

local matchNames = {}

local function showVictory(seat)
	local player = playerAtSeat(seat)
	local name = player and player.Name or matchNames[seat]

	if name then
		victoryLabel.Text = "Victoire de " .. name
		victoryGui.Enabled = true
	else
		clearVictory()
	end
end

local function updateScores()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character

		if character then
			local head = character:FindFirstChild("Head")
			local seat = player:GetAttribute("ArenaSeat")
			local gui = character:FindFirstChild("ArenaScoreGui")

			local visible = state:GetAttribute("ScoresVisible")
				and head ~= nil
				and (seat == 1 or seat == 2)

			if not visible then
				if gui then
					gui.Enabled = false
				end
			else
				if not gui then
					gui = Instance.new("BillboardGui")
					gui.Name = "ArenaScoreGui"
					gui.Size = UDim2.fromOffset(160, 110)
					gui.AlwaysOnTop = true
					gui.MaxDistance = 250
					gui.Parent = character

					local text = Instance.new("TextLabel")
					text.Name = "Score"
					text.Size = UDim2.fromScale(1, 1)
					text.BackgroundTransparency = 1
					text.Font = Enum.Font.GothamBlack
					text.TextSize = 64
					text.TextColor3 = Color3.new(1, 1, 1)
					text.TextStrokeColor3 = Color3.fromRGB(25, 15, 10)
					text.TextStrokeTransparency = 0.15
					text.Parent = gui
				end

				gui.Adornee = head

				-- Plus haut que dans l'ancienne version.
				gui.StudsOffsetWorldSpace = Vector3.new(0, 6, 0)
				gui.Enabled = true
				gui.Score.Text = tostring(
					state:GetAttribute("Score" .. seat) or 0
				)
			end
		end
	end
end

task.spawn(function()
	while script.Parent do
		updateScores()
		task.wait(0.15)
	end
end)

local activeSelections = {}
local selectionDeadline = 0
local fastClosing = false

local function sendOpen(player, record)
 local pricing=Selection.Snapshot(player)
	selectionEvent:FireClient(player, "Open", {
		RoundId = record.roundId,
		Offers = record.offers,
		Deadline = selectionDeadline,
		FreeChoiceAvailable = record.freeAvailable,
		SelectedId = record.selectedId,
		Locked = record.locked,
		FastClosing = fastClosing,
        MatchToken=state:GetAttribute("CraxMatchToken"),MatchRoundIndex=state:GetAttribute("MatchRoundIndex"),
        InventoryCost=pricing.InventoryCost,Gems=pricing.Gems,
	})
end

local function isOffered(record, id)
	for _, offered in ipairs(record.offers) do
		if offered == id then
			return true
		end
	end

	return false
end

local function feedback(player, record, success, message, requestId, charged)
 local pricing=Selection.Snapshot(player)
	selectionEvent:FireClient(player, "Feedback", {
		RoundId = record.roundId,
		Success = success,
		Message = message,
		SelectedId = record.selectedId,
		FreeChoiceAvailable = record.freeAvailable,
		Locked = record.locked,
        RequestId=requestId,Charged=charged or 0,InventoryCost=pricing.InventoryCost,Gems=pricing.Gems,
	})
end

selectionEvent.OnServerEvent:Connect(function(
	player,
	action,
	roundId,
	craxId,
	direct,
    requestId
)
	local record = activeSelections[player]

	if action == "Ready" then
		if record
			and state:GetAttribute("Phase") == "Selecting"
			and workspace:GetServerTimeNow() < selectionDeadline then

			sendOpen(player, record)
		end

		return
	end

	if not record
		or roundId ~= record.roundId
		or state:GetAttribute("Phase") ~= "Selecting"
		or player:GetAttribute("ArenaSeat") ~= record.seat
		or workspace:GetServerTimeNow() >= selectionDeadline then
        if record and roundId==record.roundId then feedback(player,record,false,"Sélection terminée ou indisponible.",requestId)end
		return
	end

	if record.locked then
        feedback(player,record,false,"Choix déjà verrouillé.",requestId)
		return
	end

	if action == "Lock" then
		if not record.selectedId then
			feedback(player, record, false, "Choisis d'abord un Crax.",requestId)
			return
		end

		record.locked = true
        local levels=player:FindFirstChild("CraxSkillLevels")
        local value=levels and levels:FindFirstChild(record.selectedId)
        record.badgeLevel=value and value:IsA("IntValue")and math.clamp(value.Value,0,4)or 0
        if record.badgeLevel>0 then
         badgeEvent:FireClient(player,{Round=record.roundId,Seat=record.seat,Level=record.badgeLevel})
        end
		feedback(player, record, true, "Choix verrouillé. En attente de l'autre joueur.",requestId)

		local count = 0
		local allLocked = true

		for _, other in pairs(activeSelections) do
			count += 1

			if not other.locked then
				allLocked = false
			end
		end

		if count == 2 and allLocked and not fastClosing then
			fastClosing = true

			-- Ne rallonge pas le temps s'il reste déjà moins de 3 secondes.
			selectionDeadline = math.min(
				selectionDeadline,
				workspace:GetServerTimeNow() + 3
			)

			for target, other in pairs(activeSelections) do
                Selection.SetDeadline(target,other.roundId,selectionDeadline)
				selectionEvent:FireClient(target, "Deadline", {
					RoundId = other.roundId,
					Deadline = selectionDeadline,
					FastClosing = true,
				})
			end
		end

		return
	end

	if action ~= "Choose"
		or type(craxId) ~= "string"
		or type(direct) ~= "boolean" then

		return
	end

	local success
	local message
    local charged=0

	if direct then
		success, message, charged = Selection.ChooseFromInventory(
			player, roundId, craxId, requestId
		)
	else
		success, message = Selection.Choose(
			player, roundId, craxId
		)
	end

	if success then
		record.selectedId = Selection.Selected(player, roundId)

		record.freeAvailable = Selection.Snapshot(player).FreeChoiceAvailable
	end

	feedback(player, record, success, message, requestId, charged)
end)

local function closeSelections()
	for player, record in pairs(activeSelections) do
		if player.Parent == Players then
			selectionEvent:FireClient(player, "Close", {
				RoundId = record.roundId,
			})
		end
	end

	activeSelections = {}
end

Players.PlayerRemoving:Connect(function(player)
	activeSelections[player] = nil
	Selection.RemovePlayer(player)
end)

local required = {
	{ name = "ArenaMovement", ready = "MovementReady" },
	{ name = "CombatHealth", ready = "HealthReady" },
	{ name = "MonsterBiteAbilities", ready = "AbilitiesReady" },
}

local started = os.clock()
local previousWarning = ""

while true do
	local missing = {}

	for _, system in ipairs(required) do
		local combatScript = SSS:FindFirstChild(system.name)

		if not combatScript or not combatScript:IsA("Script") then
			table.insert(missing, system.name .. " : absent ou incorrect")
		elseif not combatScript.Enabled then
			table.insert(missing, system.name .. " : désactivé")
		elseif not state:GetAttribute(system.ready) then
			table.insert(missing, system.name .. " : initialisation bloquée")
		end
	end

	if #missing == 0 then
		break
	end

	if os.clock() - started >= 5 then
		local message = table.concat(missing, " | ")

		if message ~= previousWarning then
			previousWarning = message
			warn("RoundManager — " .. message)
		end
	end

	task.wait(0.2)
end

local function twoPlayersReady()
	return state:GetAttribute("PlayersReady") == 2
		and playerAtSeat(1) ~= nil
		and playerAtSeat(2) ~= nil
end

while true do
	closeSelections()
	clearVictory()

	state:SetAttribute("ScoresVisible", false)
	state:SetAttribute("Phase", "Waiting")
	state:SetAttribute("Score1", 0)
	state:SetAttribute("Score2", 0)
	state:SetAttribute("RoundWinner", "")
	state:SetAttribute("MatchWinner", 0)

	while not twoPlayersReady() do
		task.wait(0.2)
	end

	local participants = {
		playerAtSeat(1),
		playerAtSeat(2),
	}

	matchNames = {
		participants[1].Name,
		participants[2].Name,
	}

	state:SetAttribute("MatchEndReason", "")
	state:SetAttribute("CraxMatchToken", game:GetService("HttpService"):GenerateGUID(false))
	-- CraxAbandonRound_v2
	state:SetAttribute("MatchRoundIndex", 0)
	Selection.BeginMatch(participants)

	local function participantsReady()
		return twoPlayersReady()
			and playerAtSeat(1) == participants[1]
			and playerAtSeat(2) == participants[2]
	end

	local cancelled = false

	-- Recul de caméra terminé avant le premier chiffre du décompte.
	state:SetAttribute("CameraTransitionDuration", CAMERA_PULLBACK_TIME)
	state:SetAttribute("CameraTransitionEnd", workspace:GetServerTimeNow() + CAMERA_PULLBACK_TIME)
	state:SetAttribute("Phase", "CameraTransition")

	while workspace:GetServerTimeNow() < state:GetAttribute("CameraTransitionEnd") do
		if not participantsReady()
			or state:GetAttribute("Phase") ~= "CameraTransition" then
			cancelled = true
			break
		end
		task.wait(0.03)
	end

	if not participantsReady()
		or state:GetAttribute("Phase") ~= "CameraTransition" then
		cancelled = true
	end

	-- Premier décompte : le menu et les scores restent cachés.
	if not cancelled then
		state:SetAttribute("Phase", "Preparing")
	end

	for number = 3, 1, -1 do
		if not participantsReady()
			or state:GetAttribute("Phase") ~= "Preparing" then

			cancelled = true
			break
		end

		task.wait(1)
	end

	if not participantsReady()
		or state:GetAttribute("Phase") ~= "Preparing" then

		cancelled = true
	end

	if not cancelled then
		state:SetAttribute("ScoresVisible", true)
	end

	while not cancelled
		and state:GetAttribute("Score1") < ROUNDS_TO_WIN
		and state:GetAttribute("Score2") < ROUNDS_TO_WIN do

		if not participantsReady() then
			cancelled = true
			break
		end

		clearVictory()

		local roundId = state:GetAttribute("RoundId") + 1
		state:SetAttribute("RoundWinner", "")
		for _,fighter in ipairs(fighters)do
         fighter:SetAttribute("CraxBadgeLocked",false)
         fighter:SetAttribute("CraxBadgeRound",nil)
         fighter:SetAttribute("CraxBadgeLevel",nil)
        end
        state:SetAttribute("MatchRoundIndex", (state:GetAttribute("MatchRoundIndex") or 0) + 1)
        state:SetAttribute("Phase", "Selecting")

		selectionDeadline = workspace:GetServerTimeNow() + SELECTION_TIME
		fastClosing = false
		activeSelections = {}

		for seat, player in ipairs(participants) do
			local data = Selection.BeginRound(player, roundId, selectionDeadline, seat)

			if #data.Offers == 0 then
				warn("Aucun Crax possédé pour " .. player.Name)
				cancelled = true
				break
			end

			activeSelections[player] = {
				roundId = roundId,
				seat = seat,
				offers = data.Offers,
				freeAvailable = data.FreeChoiceAvailable,
				selectedId = nil,
				locked = false,
			}
		end

		if cancelled then
			break
		end

		for player, record in pairs(activeSelections) do
			sendOpen(player, record)
		end

		while workspace:GetServerTimeNow() < selectionDeadline do
			if not participantsReady()
				or state:GetAttribute("Phase") ~= "Selecting" then

				cancelled = true
				break
			end

			task.wait(0.05)
		end

		if not participantsReady()
			or state:GetAttribute("Phase") ~= "Selecting" then

			cancelled = true
		end

		if cancelled then
			break
		end

		local chosen = {}
        local lockedBadges={}
        for _,record in pairs(activeSelections)do
         if record.locked then lockedBadges[record.seat]=record.badgeLevel or 0 end
        end

		for seat, player in ipairs(participants) do
			chosen[seat] = Selection.FinishRound(player, roundId)

			if not chosen[seat] then
				cancelled = true
			end
		end

		closeSelections()

		if cancelled then
			break
		end

		-- Révélation : les choix sont appliqués simultanément.
		for seat, player in ipairs(participants) do
			configure(fighters[seat], chosen[seat])
            fighters[seat]:SetAttribute("CraxBadgeRound",roundId)
            fighters[seat]:SetAttribute("CraxBadgeLevel",lockedBadges[seat]or 0)
            fighters[seat]:SetAttribute("CraxBadgeLocked",(lockedBadges[seat]or 0)>0)
			player:SetAttribute("SelectedCrax", chosen[seat])
		end

		state:SetAttribute("RoundId", roundId)
		task.wait(0.15)

		if not participantsReady()
			or state:GetAttribute("Phase") ~= "Selecting" then

			cancelled = true
			break
		end

		if not Direction.Run(participants, roundId) then
			cancelled = true
			break
		end

		state:SetAttribute("Phase", "Fighting")

		while state:GetAttribute("Phase") == "Fighting"
			and participantsReady() do

			task.wait(0.1)
		end

		if not participantsReady()
			or state:GetAttribute("Phase") ~= "RoundOver" then

			cancelled = true
			break
		end

		local winner = state:GetAttribute("RoundWinner")

		if winner == "Fighter1" then
			state:SetAttribute("Score1", state:GetAttribute("Score1") + 1)
            require(game:GetService("ServerScriptService").CraxDailyQuests).Round(participants[1],tostring(state:GetAttribute("CraxMatchToken"))..":"..tostring(state:GetAttribute("RoundId")))
			showVictory(1)
		elseif winner == "Fighter2" then
			state:SetAttribute("Score2", state:GetAttribute("Score2") + 1)
            require(game:GetService("ServerScriptService").CraxDailyQuests).Round(participants[2],tostring(state:GetAttribute("CraxMatchToken"))..":"..tostring(state:GetAttribute("RoundId")))
			showVictory(2)
		else
			clearVictory()
		end

		prepareRoundVictory()
        local remaining=math.max(0,(state:GetAttribute("RoundVictoryEndsAt")or workspace:GetServerTimeNow()+3)-workspace:GetServerTimeNow())
        -- GhostyRoundDuration_v3
local ghostState=workspace:FindFirstChild("CombatState")
local ghostWinner=ghostState and workspace:FindFirstChild(ghostState:GetAttribute("RoundWinner")or "")
local ghostMax=ghostWinner and (ghostWinner:GetAttribute("CraxId")=="Crax_Ghosty"or ghostWinner:GetAttribute("CraxId")=="Crax_Fantastic")and(ghostWinner:GetAttribute("CraxSkillLevel")or 0)>=4

local pauseEnd = os.clock() + (ghostMax and math.max(10, (remaining)) or (remaining))

		while os.clock() < pauseEnd do
			if not participantsReady()
				or state:GetAttribute("Phase") ~= "RoundOver" then

				cancelled = true
				break
			end

			task.wait(0.1)
		end
	end

	closeSelections()

	if cancelled then
		while state:GetAttribute("ForfeitResolving") == true do task.wait(.05) end
		clearVictory()
		state:SetAttribute("ScoresVisible", false)
		state:SetAttribute("Phase", "Waiting")
		state:SetAttribute("Score1", 0)
		state:SetAttribute("Score2", 0)
		task.wait(1)
	else
		local winnerSeat = state:GetAttribute("Score1") >= ROUNDS_TO_WIN and 1 or 2
		showVictory(winnerSeat)
        for _,p in ipairs(participants)do require(game:GetService("ServerScriptService").CraxDailyQuests).Duel(p,state:GetAttribute("CraxMatchToken"))end
		state:SetAttribute("MatchWinner", winnerSeat)
		state:SetAttribute("MatchEndDeadline", workspace:GetServerTimeNow() + 30)
		state:SetAttribute("Phase", "MatchOver")

		while state:GetAttribute("Phase") == "MatchOver" do
			task.wait(0.1)
		end

		clearVictory()
	end
end
