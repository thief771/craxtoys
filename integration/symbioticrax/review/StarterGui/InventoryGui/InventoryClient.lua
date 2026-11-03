-- SymbiotiCraxIntegrationV1
-- CraxDisplayedId_v1
-- CraxTrophyTabs_v1
-- CraxBleedingLogo_v1
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local collectionNotice = require(RS:WaitForChild("CraxCollectionNotice"))
local player = Players.LocalPlayer
local gui = script.Parent

local function isInArena()
	return player:GetAttribute("ArenaSeat") ~= nil
end

assert(gui:IsA("ScreenGui"), "InventoryClient doit être dans InventoryGui")

gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local inventory = player:WaitForChild("Inventory")

local effectCatalog = require(RS:WaitForChild("CraxEffectsCatalog"))
local catalog = {}
local selected = nil
local yaw = 0
local previewData = {}

local RED = Color3.fromRGB(224, 48, 66)
local WHITE = Color3.fromRGB(255, 245, 240)
local MUTED = Color3.fromRGB(186, 163, 171)
local SKY_BLUE = Color3.fromRGB(110, 205, 255)
local INACTIVE = Color3.fromRGB(83, 38, 57)

local activeTab = "Description"
local powerButton
local descriptionButton
local effectButton

local RARITY_COLORS = {
	["Commun"] = SKY_BLUE,
	["Rare"] = Color3.fromRGB(255, 135, 45),
	["Épique"] = Color3.fromRGB(195, 115, 255),
	["LEGENDAIRE"] = Color3.fromRGB(255, 200, 75),
}

local DESCRIPTIONS = {
	Crax_Monster =
		"Un sourire de star, une hygiène de vie discutable. "
		.. "Il adore se faire des amis… surtout quand ils ressemblent à un goûter.",
}

local POWER_DESCRIPTIONS = {
	Crax_Monster =
		"MORSURE\n\n"
		.. "Quand son sourire devient suspect, gare aux crocs ! "
		.. "Il ouvre sa grande bouche et mord les adversaires à proximité, "
		.. "même sans les toucher.\n\n"
		.. "Le cercle rouge annonce le danger. "
		.. "S'il n'y a personne dedans, il croque de l'air. Bon appétit.",
}

local function make(kind, properties, parent)
	local item = Instance.new(kind)

	for key, value in pairs(properties) do
		item[key] = value
	end

	item.Parent = parent
	return item
end

local function corners(item, radius)
	make("UICorner", {
		CornerRadius = UDim.new(0, radius),
	}, item)
end

local function stroke(item, color, thickness)
	return make("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = 0.3,
	}, item)
end

local function text(parent, content, x, y, width, height, size, color)
	return make("TextLabel", {
		Text = content,
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(width, height),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = size,
		TextColor3 = color or WHITE,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)
end

local old = gui:FindFirstChild("InventoryRoot")

if old then
	old:Destroy()
end

local root = make("Frame", {
	Name = "InventoryRoot",
	Visible = not isInArena(),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
}, gui)

local click = make("Sound", {
	Name = "InventoryClick",
	SoundId = "rbxassetid://113397864512278",
	Volume = 0.22,
	PlaybackSpeed = 1,
}, root)

local function playClick()
	click:Stop()
	SoundService:PlayLocalSound(click)
end

-- Animation au survol et au clic.
local function interactive(button, action, factor)
	button.AutoButtonColor = false

	local scale = make("UIScale", {
		Scale = 1,
	}, button)

	local hovered = false
	local currentTween

	local function animate(value)
		if currentTween then
			currentTween:Cancel()
		end

		currentTween = TweenService:Create(
			scale,
			TweenInfo.new(
				0.16,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{ Scale = value }
		)

		currentTween:Play()
	end

	button.MouseEnter:Connect(function()
		hovered = true
		animate(factor or 1.05)
	end)

	button.MouseLeave:Connect(function()
		hovered = false
		animate(1)
	end)

	button.MouseButton1Down:Connect(function()
		animate(0.97)
	end)

	button.MouseButton1Up:Connect(function()
		animate(hovered and (factor or 1.05) or 1)
	end)

	button.Activated:Connect(function()
		if isInArena() then
			return
		end

		playClick()
		animate(hovered and (factor or 1.05) or 1)
		action()
	end)
end

local function button(
	parent,
	title,
	x,
	y,
	width,
	height,
	action,
	color,
	fontSize
)
	local result = make("TextButton", {
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = fontSize or 22,
		TextColor3 = WHITE,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(
			x + width / 2,
			y + height / 2
		),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = color or RED,
		BorderSizePixel = 0,
	}, parent)

	corners(result, 12)
	interactive(result, action)

	return result
end

-- Gros bouton rouge.
local openButton = make("TextButton", {
	Text = "",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 166, 1, -84),
	Size = UDim2.fromOffset(272, 82),
	BackgroundColor3 = RED,
	BorderSizePixel = 0,
}, root)

corners(openButton, 20)
stroke(openButton, Color3.fromRGB(255, 141, 127), 2)

make("UIGradient", {
	Color = ColorSequence.new(
		Color3.fromRGB(255, 76, 76),
		Color3.fromRGB(169, 26, 49)
	),
	Rotation = 30,
}, openButton)

-- Silhouette noire du Crax.
local logo = make("ViewportFrame", {
	Position = UDim2.fromOffset(16, 10),
	Size = UDim2.fromOffset(66, 62),
	BackgroundTransparency = 1,
	Ambient = Color3.new(1, 1, 1),
	LightColor = Color3.new(1, 1, 1),
	ZIndex = 2,
}, openButton)

make("TextLabel", {
	Text = "?",
	Position = UDim2.fromOffset(16, 10),
	Size = UDim2.fromOffset(66, 62),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	TextSize = 38,
	TextColor3 = Color3.new(1, 1, 1),
	ZIndex = 3,
}, openButton)

text(openButton, "MES CRAX", 86, 12, 175, 36, 30, WHITE)
text(openButton, "MA COLLECTION", 86, 49, 175, 20, 14, WHITE)

local overlay = make("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(9, 3, 9),
	BackgroundTransparency = 0.18,
	BorderSizePixel = 0,
	Visible = false,
	Active = true,
}, root)

-- La collection personnelle reste fermée pendant toute présence en arène.
-- Le menu de sélection du duel utilise un autre ScreenGui et reste disponible.
local function updateArenaVisibility()
	local blocked = isInArena()
	root.Visible = not blocked
	openButton.Visible = not blocked

	if blocked then
		overlay.Visible = false
		click:Stop()
	end
end

player:GetAttributeChangedSignal("ArenaSeat"):Connect(updateArenaVisibility)
updateArenaVisibility()

local panel = make("Frame", {
 Name="CraxInventoryPanel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(1000, 710),
	BackgroundColor3 = Color3.fromRGB(26, 15, 26),
	BorderSizePixel = 0,
}, overlay)

corners(panel, 24)
stroke(panel, Color3.fromRGB(147, 55, 76), 2)

local fitScale = make("UIScale", {
	Scale = 1,
}, panel)

local function fit()
	local screenSize = root.AbsoluteSize

	if screenSize.X > 0 and screenSize.Y > 0 then
		fitScale.Scale = math.min(
			1,
			screenSize.X * 0.93 / 1000,
			screenSize.Y * 0.92 / 710
		)
	end
end

root:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
fit()

local header = text(
	panel,
	"CRAX / COLLECTION",
	28, 18, 820, 50, 38, WHITE
)

header.Font = Enum.Font.GothamBlack

local count = text(
	panel,
	"Chargement...",
	30, 74, 535, 28, 20, MUTED
)

button(
	panel,
	"X",
	926, 24, 46, 46,
	function()
		overlay.Visible = false
	end,
	Color3.fromRGB(73, 32, 48),
	24
)

interactive(openButton, function()
	if isInArena() then
		return
	end

	overlay.Visible = not overlay.Visible
end, 1.10)

-- Notifications de nouveaux Crax : bouton jusqu'à ouverture, cases jusqu'au survol.
openButton:SetAttribute("CraxCollectionButton",true)
local newCards={}
local rainbows={}
local watched=setmetatable({},{__mode="k"})
local rainbowColors=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(255,65,116)),
 ColorSequenceKeypoint.new(.2,Color3.fromRGB(255,200,62)),
 ColorSequenceKeypoint.new(.4,Color3.fromRGB(90,245,159)),
 ColorSequenceKeypoint.new(.6,Color3.fromRGB(69,190,255)),
 ColorSequenceKeypoint.new(.8,Color3.fromRGB(191,100,255)),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(255,65,116)),
})
local function rainbow(object,enabled)
 local r=rainbows[object]
 if enabled and not r then
  local g=object:FindFirstChildOfClass("UIGradient")
  local created=not g
  if not g then g=make("UIGradient",{},object)end
  local border=object:FindFirstChildOfClass("UIStroke")
  r={gradient=g,created=created,color=g.Color,rotation=g.Rotation,background=object.BackgroundColor3,
   border=border,borderColor=border and border.Color,borderWidth=border and border.Thickness}
  rainbows[object]=r
  object.BackgroundColor3=Color3.new(1,1,1);g.Color=rainbowColors;g.Rotation=0
  if border then border.Color=Color3.fromRGB(255,238,176);border.Thickness=2.8 end
  r.tween=TweenService:Create(g,TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Rotation=360})
  r.tween:Play()
  if not watched[object] then
   watched[object]=true
   object.Destroying:Connect(function()
    local record=rainbows[object];if record then record.tween:Cancel();rainbows[object]=nil end
    newCards[object]=nil
   end)
  end
 elseif not enabled and r then
  r.tween:Cancel();object.BackgroundColor3=r.background
  if r.created then r.gradient:Destroy()else r.gradient.Color=r.color;r.gradient.Rotation=r.rotation end
  if r.border then r.border.Color=r.borderColor;r.border.Thickness=r.borderWidth end
  rainbows[object]=nil
 end
end
local function updateNotices()
 rainbow(openButton,collectionNotice.Pending())
 for card,id in pairs(newCards)do
  if card:IsDescendantOf(gui)then
   local unread=collectionNotice.Has(id);rainbow(card,unread)
   local badge=card:FindFirstChild("NewCraxBadge");if badge then badge.Visible=unread end
  else newCards[card]=nil end
 end
end
local function trackNewCard(card,id)
 newCards[card]=id
 local badge=text(card,"NOUVEAU",236,5,124,21,12,WHITE)
 badge.Name="NewCraxBadge";badge.Font=Enum.Font.GothamBlack
 card.MouseEnter:Connect(function()collectionNotice.Inspect(id)end)
 card.SelectionGained:Connect(function()collectionNotice.Inspect(id)end)
 card.Activated:Connect(function()collectionNotice.Inspect(id)end)
 badge.Visible=collectionNotice.Has(id);rainbow(card,collectionNotice.Has(id))
end
collectionNotice.Changed:Connect(updateNotices)
overlay:GetPropertyChangedSignal("Visible"):Connect(function()
 if overlay.Visible then collectionNotice.Opened()end
end)
updateNotices()

-- Liste des Crax possédés.
local list = make("ScrollingFrame", {
 Name="CraxCollectionList",
	Position = UDim2.fromOffset(28, 120),
	Size = UDim2.fromOffset(390, 562),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = RED,
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, panel)

make("UIListLayout", {
	Padding = UDim.new(0, 16),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, list)

local detail = make("Frame", {
 Name="CraxCollectionDetail",
	Position = UDim2.fromOffset(438, 120),
	Size = UDim2.fromOffset(534, 562),
	BackgroundColor3 = Color3.fromRGB(40, 22, 37),
	BorderSizePixel = 0,
}, panel)

corners(detail, 18)

local title = text(
	detail,
	"Choisis un Crax",
	20, 12, 494, 48, 32, WHITE
)

title.Font = Enum.Font.GothamBold

local rarity = text(
	detail,
	"TA COLLECTION",
	20, 66, 494, 28, 20, SKY_BLUE
)

local largePreview = make("ViewportFrame", {
	Position = UDim2.fromOffset(145, 104),
	Size = UDim2.fromOffset(244, 184),
	BackgroundTransparency = 1,
	Ambient = Color3.fromRGB(225, 220, 205),
	LightColor = Color3.fromRGB(255, 239, 220),
	LightDirection = Vector3.new(-1, -1, -2),
}, detail)

local stats = text(
	detail,
	"",
	20, 294, 494, 32, 22, WHITE
)

local descriptionScroll = make("ScrollingFrame", {
	Position = UDim2.fromOffset(20, 337),
	Size = UDim2.fromOffset(494, 132),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = RED,
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, detail)

local description = make("TextLabel", {
	Text = "",
	Size = UDim2.new(1, -12, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	TextSize = 22,
	TextColor3 = MUTED,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, descriptionScroll)

local hint = text(
	detail,
	"",
	20, 527, 494, 25, 16, MUTED
)

-- Effets réutilisables : les identifiants sont dans CraxCatalog.Effects,
-- leur contenu et leur logo dans ReplicatedStorage.CraxEffectsCatalog.
local damageBadge = text(detail, "", 20, 337, 494, 30, 20, Color3.fromRGB(255,125,132))
damageBadge.Font = Enum.Font.GothamBold
damageBadge.Visible = false
local effectArea = make("Frame", {Name="EffectCategory",Position=UDim2.fromOffset(20,337),
 Size=UDim2.fromOffset(494,132),BackgroundTransparency=1,Visible=false},detail)
local effectHeading = text(effectArea,"Effet",0,0,494,25,19,WHITE)
effectHeading.Font=Enum.Font.GothamBold
local effectList = make("ScrollingFrame",{Position=UDim2.fromOffset(0,29),Size=UDim2.fromOffset(494,103),
 BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=RED,
 AutomaticCanvasSize=Enum.AutomaticSize.X,CanvasSize=UDim2.fromOffset(0,0),
 ScrollingDirection=Enum.ScrollingDirection.X},effectArea)
make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,12),
 SortOrder=Enum.SortOrder.LayoutOrder},effectList)
local emptyEffects = text(effectArea,"Aucun effet associé à ce Crax.",0,40,494,40,19,MUTED)
local note = make("Frame",{Name="EffectNote",Position=UDim2.fromOffset(20,206),
 Size=UDim2.fromOffset(494,116),BackgroundColor3=Color3.fromRGB(18,14,23),
 BorderSizePixel=0,Visible=false,ZIndex=30},detail)
corners(note,12)
stroke(note,Color3.fromRGB(155,35,53),2)
local accent=make("Frame",{Position=UDim2.fromOffset(0,15),Size=UDim2.fromOffset(4,85),
 BackgroundColor3=RED,BorderSizePixel=0,ZIndex=31},note)
corners(accent,2)
local noteTitle=text(note,"Saignement",18,10,450,28,22,Color3.fromRGB(255,116,127))
noteTitle.Font=Enum.Font.GothamBold;noteTitle.ZIndex=32
local noteDescription=text(note,"",18,46,450,56,20,WHITE)
noteDescription.TextYAlignment=Enum.TextYAlignment.Top;noteDescription.ZIndex=32
local noteOwner
local function hideNote()
 noteOwner=nil;note.Visible=false
end
-- Courbe de goutte tracée en bandes GUI : pointe fine, ventre arrondi et contour noir.
local function drawDrop(parent)
 local art=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
  Size=UDim2.fromOffset(50,62),BackgroundTransparency=1},parent)
 local rows=92
 for i=0,rows-1 do
  local t=(i+.5)/rows
  local half
  if t<.62 then half=22*math.sin((t/.62)*math.pi/2)^1.45
  else half=22*math.sqrt(math.max(0,1-((t-.62)/.38)^2)) end
  local y=t*60
  make("Frame",{Position=UDim2.fromOffset(25-half,y),Size=UDim2.fromOffset(half*2,60/rows+.12),
   BackgroundColor3=Color3.fromRGB(12,6,12),BorderSizePixel=0,ZIndex=4},art)
  if half>2.3 and t>.045 and t<.97 then
   local inset=2.1
   local color=Color3.fromRGB(247,35,62):Lerp(Color3.fromRGB(139,4,28),t)
   make("Frame",{Position=UDim2.fromOffset(25-half+inset,y),Size=UDim2.fromOffset((half-inset)*2,60/rows+.12),
    BackgroundColor3=color,BorderSizePixel=0,ZIndex=5},art)
  end
 end
 -- Reflet sculpté et ombre noire sur le flanc, sans animation permanente.
 for i=0,22 do
  local t=i/22
  local y=25+t*22
  local x=11-3*math.sin(t*math.pi)
  local shine=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(2.2+2*math.sin(t*math.pi),1.15),
   BackgroundColor3=Color3.fromRGB(255,184,181),BackgroundTransparency=.22+.65*t,
   BorderSizePixel=0,ZIndex=6},art)
  local dark=make("Frame",{Position=UDim2.fromOffset(34+4*math.sin(t*math.pi),y+3),
   Size=UDim2.fromOffset(2.5,1.15),BackgroundColor3=Color3.fromRGB(25,4,12),
   BackgroundTransparency=.2,BorderSizePixel=0,ZIndex=6},art)
 end
end
local function renderEffects(config)
 hideNote()
 for _,item in ipairs(effectList:GetChildren()) do
  if item:IsA("GuiObject") then item:Destroy() end
 end
 local ids=config.Effects or {}
 local count=0
 for index,id in ipairs(ids) do
  local data=effectCatalog[id]
  if data then
   count=count+1
   local item=make("TextButton",{Name=id,Size=UDim2.fromOffset(102,96),Text="",
    BackgroundColor3=Color3.fromRGB(29,17,29),BorderSizePixel=0,LayoutOrder=index},effectList)
   corners(item,12);stroke(item,Color3.fromRGB(100,32,49))
   local icon=make("Frame",{Position=UDim2.fromOffset(26,0),Size=UDim2.fromOffset(50,68),
    BackgroundTransparency=1},item)
   if id=="Bleeding" then
    icon.Position=UDim2.fromOffset(15,0);icon.Size=UDim2.fromOffset(72,68)
    local logo=make("ImageLabel",{Name="BleedingLogo",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
     Image="",ScaleType=Enum.ScaleType.Fit,ZIndex=4},icon)
    local pending=text(icon,"…",0,12,72,40,24,data.Color or WHITE)
    pending.TextXAlignment=Enum.TextXAlignment.Center
    local logoValue=RS:WaitForChild("CraxEffectLogos"):WaitForChild("Bleeding")
    local function updateBloodLogo()
     local imageId=tostring(logoValue.Value):match("^%s*(.-)%s*$")
     logo.Image=imageId:match("^%d+$") and "rbxassetid://"..imageId or (imageId:match("^rbxassetid://%d+$") and imageId or "")
     pending.Visible=logo.Image==""
    end
    local connection=logoValue:GetPropertyChangedSignal("Value"):Connect(updateBloodLogo)
    logo.Destroying:Connect(function()connection:Disconnect()end)
    updateBloodLogo()
   elseif data.Icon=="BloodDrop" then drawDrop(icon)
   elseif type(data.Image)=="string" and data.Image~="" then
    make("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=data.Image,
     ScaleType=Enum.ScaleType.Fit},icon)
   else
    local label=text(icon,data.Symbol or "◆",0,9,50,50,32,data.Color or WHITE)
    label.TextXAlignment=Enum.TextXAlignment.Center
   end
   local caption=text(item,data.DisplayName or id,2,70,98,22,14,data.Color or WHITE)
   caption.TextXAlignment=Enum.TextXAlignment.Center
   local function reveal()
    if activeTab~="Effect" or isInArena() or not overlay.Visible then return end
    noteOwner=item;noteTitle.Text=data.DisplayName or id
    noteDescription.Text=data.Description or ""
    noteDescription.TextWrapped=true;noteDescription.RichText=false
    local height=math.max(56,game:GetService("TextService"):GetTextSize(
     noteDescription.Text,noteDescription.TextSize,noteDescription.Font,Vector2.new(340,10000)).Y+4)
    noteDescription.Size=UDim2.fromOffset(340,height)
    note.Size=UDim2.fromOffset(375,64+height)
    -- La bulle se développe vers le haut et reste au-dessus des icônes.
    note.Position=UDim2.fromOffset(20,math.max(12,322-(64+height)))
    accent.Size=UDim2.fromOffset(4,math.max(85,34+height))
    note.Visible=true
   end
   interactive(item,function()
    if noteOwner==item and note.Visible then hideNote() else reveal() end
   end,1.10)
   -- La description est contrôlée par le clic sur l'effet.
   -- Elle reste ouverte lorsque la souris quitte l'icône.
  end
 end
 emptyEffects.Visible=count==0
 effectList.CanvasPosition=Vector2.zero
end
overlay:GetPropertyChangedSignal("Visible"):Connect(function()if not overlay.Visible then hideNote() end end)

local function namedPart(model, name)
	local item = model:FindFirstChild(name, true)

	if item and not item:IsA("BasePart") then
		item = item:FindFirstChildWhichIsA("BasePart", true)
	end

	return item
end

local function clearViewport(view)
	previewData[view] = nil
	view.CurrentCamera = nil

	for _, child in ipairs(view:GetChildren()) do
		child:Destroy()
	end
end

local function showPreview(view, craxId, angle, silhouette)
	clearViewport(view)

	local folder = RS:FindFirstChild("CraxPreviews")
	local config = catalog[craxId] or {}
	local template = folder and (folder:FindFirstChild(config.TemplateName or craxId)
		or folder:FindFirstChild(craxId))

	if not template then
		make("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "APERÇU 3D\nEN ATTENTE",
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			TextColor3 = MUTED,
		}, view)

		return
	end

	local world = make("WorldModel", {}, view)
	local model = template:GetAttribute('DeadlySpiral')and require(RS:WaitForChild('CraxDeadlyVisuals')).PreviewClone(template)or template:Clone()
	model.Parent = world
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA("BasePart")then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false
  elseif o:IsA("LuaSourceContainer")or o:IsA("BillboardGui")or o:IsA("Highlight")then o:Destroy()end
 end

	if silhouette then
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("SurfaceAppearance")
				or part:IsA("Decal")
				or part:IsA("Texture") then

				part:Destroy()

			elseif part:IsA("BasePart") then
				part.Color = Color3.new(0, 0, 0)
				part.Material = Enum.Material.SmoothPlastic
				part.Reflectance = 0

				if part:IsA("MeshPart") then
					part.TextureID = ""
				end

			elseif part:IsA("SpecialMesh") then
				part.TextureId = ""
				part.VertexColor = Vector3.zero
			end
		end
	end

	local head = namedPart(model, "Head")
		or model:FindFirstChildWhichIsA("BasePart", true)

	if not head then
		return
	end

	local center = head.Position
	local leftEye = namedPart(model, "EyeLeft") or namedPart(model,"EyeLeft_Node")
	local rightEye = namedPart(model, "EyeRight") or namedPart(model,"EyeRight_Node")
	local front = Vector3.new(0, 0, -1)

	if leftEye and rightEye then
		local delta = (leftEye.Position + rightEye.Position) / 2 - center
		delta = Vector3.new(delta.X, 0, delta.Z)

		if delta.Magnitude > 0.001 then
			front = delta.Unit
		end
	end

	local camera = make("Camera", {
		FieldOfView = 36,
	}, view)

	view.CurrentCamera = camera

	local radius = math.max(head.Size.X, head.Size.Y, head.Size.Z) / 2
 if model:GetAttribute('DeadlySpiral')or model:GetAttribute('SymPreview')then local cf,sz=model:GetBoundingBox();center=cf.Position;radius=math.max(sz.X,sz.Y)/2 end

	previewData[view] = {
		camera = camera,
		center = center,
		front = front,
		radius = radius,
	}

	local direction = CFrame.Angles(
		0,
		angle or 0,
		0
	):VectorToWorldSpace(front)

	camera.CFrame = CFrame.lookAt(
		center + direction * radius * 3.8
			+ Vector3.new(0, radius * 0.12, 0),
		center
	)
 require(RS:WaitForChild('CraxDeadlyVisuals')).Fit(view,model)
end

local function rotatePreview()
 if selected=="Crax_Deadly"then return end
	local data = previewData[largePreview]

	if not data then
		return
	end

	local direction = CFrame.Angles(
		0,
		yaw,
		0
	):VectorToWorldSpace(data.front)

	data.camera.CFrame = CFrame.lookAt(
		data.center + direction * data.radius * 3.8
			+ Vector3.new(0, data.radius * 0.12, 0),
		data.center
	)
end

-- Met en rouge uniquement le bouton de l'onglet actif.
local function updateTabColors()
	if effectButton then effectButton.BackgroundColor3 = activeTab == "Effect" and RED or INACTIVE end
	if powerButton then
		powerButton.BackgroundColor3 =
			activeTab == "Power" and RED or INACTIVE
	end

	if descriptionButton then
		descriptionButton.BackgroundColor3 =
			activeTab == "Description" and RED or INACTIVE
	end
end

local function showTab(tab)
	activeTab = tab
	hideNote()
	updateTabColors()
	effectArea.Visible = tab == "Effect"
	descriptionScroll.Visible = tab ~= "Effect"
	damageBadge.Visible = false
	descriptionScroll.Position = UDim2.fromOffset(20,337)
	descriptionScroll.Size = UDim2.fromOffset(494,132)

	descriptionScroll.CanvasPosition = Vector2.zero

	if not selected then
		renderEffects({})
		description.Text = "Choisis un Crax dans ta collection."
		return
	end

	local config = catalog[selected] or {}

	if tab == "Effect" then
		renderEffects(config)
		return
	elseif tab == "Power" then
		local ability = config.Ability or {}
		if ability.Id == "GhostNightSlash" then
			damageBadge.Text = tostring(ability.Damage or 50) .. " dégâts par SLASH"
			damageBadge.Visible = true
			descriptionScroll.Position = UDim2.fromOffset(20,375)
			descriptionScroll.Size = UDim2.fromOffset(494,94)
		end
		description.Text = config.PowerDescription
			or POWER_DESCRIPTIONS[selected]
			or "Ce Crax déclenche automatiquement son pouvoir pendant le combat. "
			.. "Ses adversaires préfèrent généralement découvrir ça de loin."
	else
		description.Text = config.Description
			or DESCRIPTIONS[selected]
			or "Petit Crax, grande personnalité. "
			.. "Il prend les combats très au sérieux. Le reste, beaucoup moins."
	end
end

local rotateLeft,rotateRight
local function describe(craxId)
 detail:SetAttribute("CraxDisplayedId",craxId)
	selected = craxId
 if rotateLeft then rotateLeft.Visible=craxId~="Crax_Deadly"end
 if rotateRight then rotateRight.Visible=craxId~="Crax_Deadly"end
	yaw = 0

	local config = catalog[craxId] or {}
	local rarityName = config.Rarity or "Commun"

	title.Text = config.DisplayName
		or (craxId == "Crax_Monster" and "Crax Sourire" or craxId)

	rarity.Text = string.upper(rarityName)
	rarity.TextColor3 = RARITY_COLORS[rarityName] or SKY_BLUE
 require(RS:WaitForChild("CraxDeadlyVisuals")).EmeraldStyle(rarity,rarityName=="SECRET")

	stats.Text = tostring(config.MaxHealth or 100)
		.. " PV   •   Vitesse "
		.. tostring(config.Speed or 21)
		.. "   •   Choc "
		.. tostring(config.CollisionDamage or 5)

	hint.Text = ""
 hint.Visible=false

	showPreview(largePreview, craxId, 0)
	showTab("Description")
end

-- Flèche à gauche du Crax.
rotateLeft=button(
	detail,
	"◀",
	65, 168, 58, 58,
	function()
		yaw -= math.rad(30)
		rotatePreview()
	end,
	Color3.fromRGB(85, 37, 57),
	28
)

-- Flèche à droite du Crax.
rotateRight=button(
	detail,
	"▶",
	411, 168, 58, 58,
	function()
		yaw += math.rad(30)
		rotatePreview()
	end,
	Color3.fromRGB(85, 37, 57),
	28
)

powerButton = button(
	detail,
	"SON POUVOIR",
	20, 480, 154, 42,
	function()
		showTab("Power")
	end,
	INACTIVE,
	17
)

descriptionButton = button(
	detail,
	"SA DESCRIPTION",
	184, 480, 166, 42,
	function()
		showTab("Description")
	end,
	RED,
	17
)

effectButton = button(detail,"EFFET",360,480,154,42,function()
	showTab("Effect")
end,INACTIVE,17)

local function refresh()
	showPreview(logo, "Crax_Monster", 0, true)

	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("GuiObject") then
			for view in pairs(previewData) do
				if view:IsDescendantOf(child) then
					previewData[view] = nil
				end
			end

			child:Destroy()
		end
	end

	local owned = {}

	for _, item in ipairs(inventory:GetChildren()) do
		if item:IsA("BoolValue") and item.Value then
			table.insert(owned, item.Name)
		end
	end

	table.sort(owned)

	count.Text = #owned
		.. " CRAX POSSÉDÉ"
		.. (#owned == 1 and "" or "S")
		.. "  /  MA COLLECTION"

	local selectedStillOwned = false

	for index, craxId in ipairs(owned) do
		if selected == craxId then
			selectedStillOwned = true
		end

		local config = catalog[craxId] or {}
		local rarityName = config.Rarity or "Commun"

		local card = make("TextButton", {
			Text = "",
			Size = UDim2.fromOffset(368, 190),
			BackgroundColor3 = Color3.fromRGB(59, 29, 46),
			BorderSizePixel = 0,
			LayoutOrder = index,
		}, list)

		card:SetAttribute("CraxCardId",craxId) -- CraxCardIdentity_v5
		corners(card, 16)
		stroke(card, Color3.fromRGB(134, 62, 80))
		trackNewCard(card, craxId)

		local viewport = make("ViewportFrame", {
			Position = UDim2.fromOffset(10, 28),
			Size = UDim2.fromOffset(122, 130),
			BackgroundTransparency = 1,
			Ambient = Color3.fromRGB(225, 220, 205),
			LightColor = Color3.fromRGB(255, 239, 220),
			LightDirection = Vector3.new(-1, -1, -2),
		}, card)

		showPreview(viewport, craxId, 0)

		local cardTitle = text(
			card,
			config.DisplayName
				or (craxId == "Crax_Monster" and "Crax Sourire" or craxId),
			145, 18, 205, 72, 28, WHITE
		)

		cardTitle.Font = Enum.Font.GothamBold

		local cardRarity=text(
			card,
			string.upper(rarityName),
			145, 96, 205, 30, 21,
			RARITY_COLORS[rarityName] or SKY_BLUE
		)
 require(RS:WaitForChild("CraxDeadlyVisuals")).EmeraldStyle(cardRarity,rarityName=="SECRET")

		text(
			card,
			"VOIR LA FICHE →",
			145, 144, 205, 28, 18, WHITE
		)

		interactive(card, function()
			describe(craxId)
		end, 1.025)
	end

	if #owned > 0 then
		local previousTab = activeTab
		describe(selectedStillOwned and selected or owned[1])

		if selectedStillOwned then
			showTab(previousTab)
		end
	else
		selected = nil
		clearViewport(largePreview)
		title.Text = "Collection vide"
		rarity.Text = ""
		stats.Text = ""
		description.Text = "Tes prochains Crax apparaîtront ici."
		hint.Text = ""
		showTab("Description")
	end
end

-- MesCraxExplorer20261027
-- Habillage local : conserve la sélection, les vues 3D, les effets et les trophées existants.
do
 local RunService=game:GetService('RunService')
 local ContentProvider=game:GetService('ContentProvider')
 local background=Instance.new('ImageLabel')
 background.Name='MesCraxExplorerBackground';background.Image='rbxassetid://106953341524187'
 background.Size=UDim2.fromScale(1,1);background.BackgroundTransparency=1;background.ScaleType=Enum.ScaleType.Stretch
 background.ZIndex=0;background.Active=false;background.Parent=panel
 panel.BackgroundTransparency=1;panel.ClipsDescendants=false
 local border=panel:FindFirstChildWhichIsA('UIStroke');if border then border.Enabled=false end
 local mascot=Instance.new('ImageLabel');mascot.Name='CraxExplorateur';mascot.Image='rbxassetid://125001189673787'
 mascot.BackgroundTransparency=1;mascot.Size=UDim2.fromOffset(175,175);mascot.Position=UDim2.fromOffset(-32,-75)
 mascot.ScaleType=Enum.ScaleType.Fit;mascot.ZIndex=12;mascot.Active=false;mascot.Parent=panel
 header.Text='MES CRAX';header.Position=UDim2.fromOffset(160,18);header.Size=UDim2.fromOffset(500,48)
 header.TextColor3=Color3.fromRGB(255,223,155);header.TextStrokeTransparency=.15
 count.Position=UDim2.fromOffset(165,67);count.TextColor3=Color3.fromRGB(255,236,198);count.TextSize=16
 list.Position=UDim2.fromOffset(48,164);list.Size=UDim2.fromOffset(487,495)
 list.ScrollBarImageColor3=Color3.fromRGB(255,193,85)
 detail.Position=UDim2.fromOffset(552,150);detail.Size=UDim2.fromOffset(405,535)
 detail.BackgroundColor3=Color3.fromRGB(6,20,48);detail.BackgroundTransparency=.22
 title.Position=UDim2.fromOffset(16,8);title.Size=UDim2.fromOffset(370,42);title.TextSize=25
 rarity.Position=UDim2.fromOffset(16,48);rarity.Size=UDim2.fromOffset(370,25);rarity.TextSize=16
 largePreview.Position=UDim2.fromOffset(86,85);largePreview.Size=UDim2.fromOffset(230,190)
 stats.Position=UDim2.fromOffset(15,281);stats.Size=UDim2.fromOffset(375,33);stats.TextSize=17
 descriptionScroll.Position=UDim2.fromOffset(15,320);descriptionScroll.Size=UDim2.fromOffset(375,115)
 description.TextSize=18;description.TextColor3=Color3.fromRGB(235,244,255)
 effectArea.Position=UDim2.fromOffset(15,320);effectArea.Size=UDim2.fromOffset(375,115)
 effectList.Size=UDim2.fromOffset(370,83);effectHeading.Size=UDim2.fromOffset(370,25)
 note.Position=UDim2.fromOffset(10,190);note.Size=UDim2.fromOffset(385,110)
 noteTitle.Size=UDim2.fromOffset(350,28);noteDescription.Size=UDim2.fromOffset(350,55)
 hint.Visible=false
 local function buttonPlace(btn,x,w)
  btn.AnchorPoint=Vector2.new(.5,.5);btn.Position=UDim2.fromOffset(x+w/2,463);btn.Size=UDim2.fromOffset(w,42);btn.TextSize=14
 end
 buttonPlace(powerButton,10,120);buttonPlace(descriptionButton,138,135);buttonPlace(effectButton,281,114)
 rotateLeft.Position=UDim2.fromOffset(45,177);rotateRight.Position=UDim2.fromOffset(360,177)
 local layoutList=list:FindFirstChildOfClass('UIListLayout');if layoutList then layoutList:Destroy()end
 local grid=Instance.new('UIGridLayout');grid.CellSize=UDim2.fromOffset(228,205);grid.CellPadding=UDim2.fromOffset(10,10);grid.SortOrder=Enum.SortOrder.LayoutOrder;grid.Parent=list
 local colors={Commun=Color3.fromRGB(151,218,255),Rare=Color3.fromRGB(255,151,42),['Épique']=Color3.fromRGB(192,100,255),LEGEND=Color3.fromRGB(255,206,55),SECRET=Color3.fromRGB(35,230,147)}
 local function rarityKey(value)
  local v=tostring(value or 'Commun'):upper()
  if v:find('SECRET',1,true)then return 'SECRET' end
  if v:find('GEND',1,true)then return 'LEGEND' end
  if v:find('PIQUE',1,true)then return 'Épique' end
  if v:find('RARE',1,true)then return 'Rare' end
  return 'Commun'
 end
 local filters={{'TOUS','ALL'},{'COMMUN','Commun'},{'RARE','Rare'},{'ÉPIQUE','Épique'},{'LÉGENDAIRE','LEGEND'},{'SECRET','SECRET'}}
 local current='ALL';local tabs={};local hooked=setmetatable({},{__mode='k'})
 local function restyleCard(card)
  local id=card:GetAttribute('CraxCardId');if not id then return end
  local data=catalog[id] or {};local key=rarityKey(data.Rarity);local color=colors[key]
  card.Visible=current=='ALL' or current==key
  card.BackgroundColor3=Color3.fromRGB(11,23,43);card.BackgroundTransparency=.08
  local edge=card:FindFirstChildWhichIsA('UIStroke');if edge then edge.Color=color;edge.Thickness=2 end
  local view=card:FindFirstChildWhichIsA('ViewportFrame')
  if view then view.Position=UDim2.fromOffset(40,5);view.Size=UDim2.fromOffset(145,120) end
  -- Identifie chaque texte par son contenu, sans retrier selon
  -- des positions qui ont déjà été modifiées.
  local labels={}
  local expectedTitle=data.DisplayName
   or (id=='Crax_Monster' and 'Crax Sourire' or id)
  local expectedRarity=string.upper(data.Rarity or 'Commun')

  for _,child in ipairs(card:GetChildren())do
   if child:IsA('TextLabel') and not child.Name:find('Prestige')then
    if child.Text=='VOIR LA FICHE →' then
     labels[3]=child
    elseif child.Text==expectedRarity then
     labels[2]=child
    elseif child.Text==expectedTitle then
     labels[1]=child
    end
   end
  end
  if labels[1] then labels[1].Position=UDim2.fromOffset(8,129);labels[1].Size=UDim2.fromOffset(212,26);labels[1].TextSize=18;labels[1].TextXAlignment=Enum.TextXAlignment.Center end
  if labels[2] then labels[2].Position=UDim2.fromOffset(8,157);labels[2].Size=UDim2.fromOffset(212,23);labels[2].TextSize=14;labels[2].TextColor3=color;labels[2].TextXAlignment=Enum.TextXAlignment.Center end
  if labels[3] then labels[3].Position=UDim2.fromOffset(8,181);labels[3].Size=UDim2.fromOffset(212,18);labels[3].TextSize=12;labels[3].TextXAlignment=Enum.TextXAlignment.Center end
  if not hooked[card]then hooked[card]=true end
 end
 local function updateCards()for _,c in ipairs(list:GetChildren())do if c:IsA('TextButton')then restyleCard(c)end end end
 for i,entry in ipairs(filters)do
  local tab=Instance.new('TextButton');tab.Name='Filtre'..i;tab.Text=entry[1];tab.Font=Enum.Font.GothamBold;tab.TextSize=12
  tab.TextColor3=Color3.new(1,1,1);tab.BorderSizePixel=0;tab.Position=UDim2.fromOffset(46+(i-1)*82,122);tab.Size=UDim2.fromOffset(78,33)
  tab.BackgroundColor3=entry[2]=='ALL' and Color3.fromRGB(38,110,205) or (colors[entry[2]] or Color3.new(1,1,1)):Lerp(Color3.fromRGB(15,21,32),.48)
  tab.Parent=panel;corners(tab,8);tabs[i]=tab
  tab.Activated:Connect(function()current=entry[2];playClick();updateCards()end)
 end
 local prevRefresh=refresh
 refresh=function(...)prevRefresh(...);updateCards()end
 local prevShowTab=showTab
 showTab=function(...)
  prevShowTab(...)
  if descriptionScroll.Visible then descriptionScroll.Position=UDim2.fromOffset(15,320);descriptionScroll.Size=UDim2.fromOffset(375,115)end
 end
 local prevDescribe=describe
 describe=function(...)prevDescribe(...);showTab('Description')end
 list.ChildAdded:Connect(function(child)if child:IsA('TextButton')then task.defer(function()if child.Parent then restyleCard(child)end end)end end)
 overlay:GetPropertyChangedSignal('Visible'):Connect(function()
  if overlay.Visible then
   local scale=fitScale.Scale
   mascot.Rotation=-7
   TweenService:Create(mascot,TweenInfo.new(.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Rotation=0}):Play()
   task.defer(updateCards)
  end
 end)
 task.spawn(function()pcall(function()ContentProvider:PreloadAsync({background,mascot})end)end)
 updateCards()
end

local connections = {}

local function watch(item)
	if item:IsA("BoolValue") then
		connections[item] = item
			:GetPropertyChangedSignal("Value")
			:Connect(refresh)
	end
end

for _, item in ipairs(inventory:GetChildren()) do
	watch(item)
end

inventory.ChildAdded:Connect(function(item)
	watch(item)
	refresh()
end)

inventory.ChildRemoved:Connect(function(item)
	if connections[item] then
		connections[item]:Disconnect()
		connections[item] = nil
	end

	refresh()
end)

refresh()

task.spawn(function()
	local module = RS:WaitForChild("CraxCatalog", 10)

	if module and module:IsA("ModuleScript") then
		local success, result = pcall(require, module)

		if success and type(result) == "table" then
			catalog = result
			refresh()
		end
	end

	local previews = RS:WaitForChild("CraxPreviews", 10)

	if previews then
		previews.ChildAdded:Connect(refresh)
		previews.ChildRemoved:Connect(refresh)
		refresh()
	else
		warn(
			"Ajoutez CraxPreviewPublisher dans ServerScriptService pour les têtes 3D."
		)
	end
end)

-- MesCraxExplorerAudio20261027
do
	local SoundService = game:GetService("SoundService")
	local ContentProvider = game:GetService("ContentProvider")

	local ids = {
		Hover = "rbxassetid://108636920033113",
		Select = "rbxassetid://121148395203699",
		Secret = "rbxassetid://122767902046416",
		Open = "rbxassetid://83538611153863",
		Music = "rbxassetid://100220804050597",
		Click = "rbxassetid://124748302299466",
	}

	local sounds = {}

	local function sound(name, volume, looped)
		local item = Instance.new("Sound")
		item.Name = "MesCrax_" .. name
		item.SoundId = ids[name]
		item.Volume = volume
		item.Looped = looped or false
		item.Parent = gui
		sounds[name] = item
		return item
	end

	sound("Hover", 0.15)
	sound("Select", 0.28)
	sound("Secret", 0.32)
	sound("Open", 0.30)
	sound("Click", 0.20)
	local music = sound("Music", 0.18, true)

	local function play(name)
		local item = sounds[name]
		if not item or not item.Parent then return end
		item:Stop()
		SoundService:PlayLocalSound(item)
	end

	local connected = setmetatable({}, {__mode = "k"})
	local lastHover = 0

	local function connectButton(button)
		if not button:IsA("GuiButton") or connected[button] then
			return
		end

		connected[button] = true

		button.MouseEnter:Connect(function()
			-- Évite d'empiler les sons quand la souris traverse
			-- plusieurs éléments très rapidement.
			local now = os.clock()
			if now - lastHover < 0.07 then return end
			lastHover = now

			if root.Visible and (
				overlay.Visible or button == openButton
			) then
				play("Hover")
			end
		end)

		button.Activated:Connect(function()
			if not root.Visible then return end

			local id = button:GetAttribute("CraxCardId")

			if id then
				local config = catalog[id] or {}
				local rarity = tostring(config.Rarity or ""):upper()

				if rarity:find("SECRET", 1, true) then
					play("Secret")
				else
					play("Select")
				end
			elseif button ~= openButton then
				play("Click")
			end
		end)
	end

	for _, item in ipairs(root:GetDescendants()) do
		connectButton(item)
	end

	root.DescendantAdded:Connect(connectButton)

	local function updateMusic()
		local visible = overlay.Visible
			and root.Visible
			and not isInArena()

		if visible then
			play("Open")
			if not music.IsPlaying then
				music:Play()
			end
		else
			music:Stop()
		end
	end

	overlay:GetPropertyChangedSignal("Visible"):Connect(updateMusic)
	root:GetPropertyChangedSignal("Visible"):Connect(updateMusic)

	gui.Destroying:Connect(function()
		music:Stop()
	end)

	task.spawn(function()
		local list = {}
		for _, item in pairs(sounds) do
			table.insert(list, item)
		end
		pcall(function()
			ContentProvider:PreloadAsync(list)
		end)
	end)

	updateMusic()
end

-- MesCraxExplorerIconeTransparente_20261027
do
	local imageId = "rbxassetid://134815538193213"

	-- Retire l'habillage rouge et les anciens textes du bouton.
	openButton.BackgroundTransparency = 1

	for _, child in ipairs(openButton:GetChildren()) do
		if child:IsA("GuiObject") then
			child.Visible = false
		elseif child:IsA("UIStroke") then
			child.Enabled = false
		end
	end

	-- Le bouton reste le même : son clic et son animation sont conservés.
	local icon = Instance.new("ImageLabel")
	icon.Name = "CraxExplorateurBouton"
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.fromScale(1, 1)
	icon.Image = imageId
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Active = false
	icon.ZIndex = openButton.ZIndex + 2
	icon.Parent = openButton

	openButton.Size = UDim2.fromOffset(145, 145)
	openButton.Position = UDim2.new(0, 94, 1, -100)

	-- Remplace aussi l'illustration noire dans la fenêtre.
	local mascot = panel:FindFirstChild("CraxExplorateur")
	if mascot and mascot:IsA("ImageLabel") then
		mascot.Image = imageId
	end

	task.spawn(function()
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({icon})
		end)
	end)
end

-- MesCraxBoutonMyCrax_20261027
do
	-- Aligne l'icône sur les autres boutons à gauche.
	openButton.AnchorPoint = Vector2.new(0.5, 1)
	openButton.Position = UDim2.new(0, 65, 1, -23)
	openButton.Size = UDim2.fromOffset(112, 112)
	openButton.ClipsDescendants = false

	local icon = openButton:FindFirstChild("CraxExplorateurBouton")
	if icon and icon:IsA("ImageLabel") then
		icon.AnchorPoint = Vector2.new(0.5, 0)
		icon.Position = UDim2.fromScale(0.5, 0)
		icon.Size = UDim2.fromScale(1, 1)
		icon.ScaleType = Enum.ScaleType.Fit
	end

	local label = Instance.new("TextLabel")
	label.Name = "MyCraxTitre"
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 1, -2)
	label.Size = UDim2.fromOffset(140, 26)
	label.BackgroundTransparency = 1
	label.Text = "MY CRAX"
	label.Font = Enum.Font.GothamBlack
	label.TextSize = 19
	label.TextColor3 = Color3.fromRGB(255, 231, 151)
	label.TextStrokeColor3 = Color3.fromRGB(102, 52, 23)
	label.TextStrokeTransparency = 0.35
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Active = false
	label.ZIndex = openButton.ZIndex + 3
	label.Parent = openButton
end

-- MesCraxVitrineOuverte_20261027
do
 local Run=game:GetService('RunService');local Tween=game:GetService('TweenService')
 local function make(c,parent,props)local o=Instance.new(c);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
 local function part(parent,name,size,cf,color,material,shape)
  return make('Part',parent,{Name=name,Size=size,CFrame=cf,Color=color,Material=material,Shape=shape or Enum.PartType.Block,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false})
 end
 local palette={Commun=Color3.fromRGB(203,233,255),Rare=Color3.fromRGB(255,155,75),Epique=Color3.fromRGB(204,133,255),Legendaire=Color3.fromRGB(255,205,90),Secret=Color3.fromRGB(100,239,184)}
 local function colorFor(id)
  local c=catalog[id]or {};local r=tostring(c.Rarity or 'Commun'):upper()
  if r:find('SECRET',1,true)then return palette.Secret end
  if r:find('GEND',1,true)then return palette.Legendaire end
  if r:find('PIQUE',1,true)then return palette.Epique end
  if r:find('RARE',1,true)then return palette.Rare end
  return palette.Commun
 end
 -- Le panneau devient une vitrine ouverte : plus de petit rectangle opaque.
 detail.BackgroundColor3=Color3.fromRGB(5,20,42);detail.BackgroundTransparency=.08
 local bg=make('Frame',detail,{Name='OpenDisplayAmbient',Position=UDim2.fromOffset(5,55),Size=UDim2.new(1,-10,0,265),BackgroundColor3=Color3.fromRGB(12,40,70),BackgroundTransparency=.32,BorderSizePixel=0,ZIndex=0,Active=false})
 make('UICorner',bg,{CornerRadius=UDim.new(0,24)})
 make('UIGradient',bg,{Rotation=90,Color=ColorSequence.new(Color3.fromRGB(55,115,148),Color3.fromRGB(3,15,36)),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.2),NumberSequenceKeypoint.new(.7,.35),NumberSequenceKeypoint.new(1,1)})})
 local scene=make('ViewportFrame',detail,{Name='OpenDisplay3D',Position=UDim2.fromOffset(15,69),Size=UDim2.fromOffset(375,235),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Active=false,Ambient=Color3.fromRGB(220,220,220),LightColor=Color3.fromRGB(255,238,201),LightDirection=Vector3.new(-1,-1,-2)})
 local world=make('WorldModel',scene,{})
 local cam=make('Camera',scene,{FieldOfView=45,CFrame=CFrame.lookAt(Vector3.new(0,3.2,13),Vector3.new(0,.7,0))});scene.CurrentCamera=cam
 local rotation=CFrame.Angles(0,0,math.pi/2);local wood=Color3.fromRGB(145,80,32);local gold=Color3.fromRGB(231,172,81)
 part(world,'Base',Vector3.new(.48,6.6,6.6),CFrame.new(0,-2.1,0)*rotation,wood,Enum.Material.Wood,Enum.PartType.Cylinder)
 part(world,'Couronne',Vector3.new(.16,6.75,6.75),CFrame.new(0,-1.82,0)*rotation,gold,Enum.Material.Metal,Enum.PartType.Cylinder)
 part(world,'Dessus',Vector3.new(.12,6.1,6.1),CFrame.new(0,-1.68,0)*rotation,Color3.fromRGB(35,65,87),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)
 local glows={}
 for i=1,10 do
  local a=i*2*math.pi/10
  glows[i]=part(world,'Lumiere'..i,Vector3.new(.12,.12,.12),CFrame.new(math.cos(a)*2.75,-1.6,math.sin(a)*2.75),palette.Commun,Enum.Material.Neon,Enum.PartType.Ball)
 end
 local sparks={};local random=Random.new(371)
 for i=1,16 do
  local ball=part(world,'Lueur'..i,Vector3.new(.07,.07,.07),CFrame.new(),palette.Commun,Enum.Material.Neon,Enum.PartType.Ball)
  sparks[i]={ball=ball,x=random:NextNumber(-4,4),y=random:NextNumber(0,1),speed=random:NextNumber(.07,.15),z=random:NextNumber(-1.5,.3)}
 end
 largePreview.Position=UDim2.fromOffset(62,78);largePreview.Size=UDim2.fromOffset(282,202);largePreview.ZIndex=3
 largePreview.Ambient=Color3.fromRGB(230,230,230);largePreview.LightColor=Color3.fromRGB(255,250,238);largePreview.LightDirection=Vector3.new(-1,-1,-2)
 local base=largePreview.Position;local selectionAt=0
 local priorId
 local function selectedChanged()
  local id=detail:GetAttribute('CraxDisplayedId');if type(id)~='string'then return end
  local color=colorFor(id);for _,o in ipairs(glows)do o.Color=color end;for _,o in ipairs(sparks)do o.ball.Color=color end
  if id~=priorId then priorId=id;selectionAt=os.clock() end
 end
 detail:GetAttributeChangedSignal('CraxDisplayedId'):Connect(selectedChanged)
 -- L'ancien habillage de prestige est masqué seulement sur la grande fiche ; le badge MAX reste distinct.
 local function hideSurface(o)if o.Name=='CraxPrestigeSurface'and o.Parent==detail and o:IsA('GuiObject')then o.Visible=false end end
 for _,o in ipairs(detail:GetChildren())do hideSurface(o)end
 detail.ChildAdded:Connect(function(o)task.defer(function()if o.Parent then hideSurface(o)end end)end)
 local timer=0
 local c=Run.RenderStepped:Connect(function(dt)
  if not overlay.Visible or not detail.Visible then return end;timer+=dt
  local surface=detail:FindFirstChild('CraxPrestigeSurface');if surface then hideSurface(surface)end
  local reduced=player:GetAttribute('CraxReducedMotion')==true
  local arrival=reduced and 0 or 14*math.max(0,1-(os.clock()-selectionAt)/.35)
  largePreview.Position=base+UDim2.fromOffset(0,reduced and 0 or 3*math.sin(timer*1.65)+arrival)
  for i,s in ipairs(sparks)do local u=(s.y+timer*s.speed)%1;s.ball.CFrame=CFrame.new(s.x+math.sin(timer+i)*.1,-1+u*5,s.z);s.ball.Transparency=math.clamp(math.abs(u-.5)*1.6,.2,.85)end
 end)
 gui.Destroying:Connect(function()c:Disconnect()end);selectedChanged()
end

-- MesCraxFondEffetsLisibles_20261027
do
	-- Un fond bleu plus clair pour mettre le Crax en valeur.
	detail.BackgroundColor3 = Color3.fromRGB(20, 53, 78)
	detail.BackgroundTransparency = 0.02

	local fond = detail:FindFirstChild("OpenDisplayAmbient")
	if fond and fond:IsA("Frame") then
		fond.BackgroundColor3 = Color3.fromRGB(112, 180, 195)
		fond.BackgroundTransparency = 0.12

		local gradient = fond:FindFirstChildWhichIsA("UIGradient")
		if gradient then
			gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(
					0,
					Color3.fromRGB(169, 221, 220)
				),
				ColorSequenceKeypoint.new(
					0.5,
					Color3.fromRGB(68, 147, 170)
				),
				ColorSequenceKeypoint.new(
					1,
					Color3.fromRGB(24, 61, 91)
				),
			})

			gradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.12),
				NumberSequenceKeypoint.new(0.7, 0.18),
				NumberSequenceKeypoint.new(1, 0.65),
			})
		end
	end

	local function ajusterEffets()
		-- La zone commence plus haut et laisse de la place aux
		-- cartes de 96 pixels sans passer derrière les boutons.
		effectArea.Position = UDim2.fromOffset(15, 307)
		effectArea.Size = UDim2.fromOffset(375, 130)

		effectHeading.Position = UDim2.fromOffset(0, 0)
		effectHeading.Size = UDim2.fromOffset(375, 22)
		effectHeading.TextSize = 17
		effectHeading.TextColor3 = Color3.fromRGB(255, 246, 218)

		effectList.Position = UDim2.fromOffset(0, 23)
		effectList.Size = UDim2.fromOffset(375, 104)
		effectList.ScrollBarThickness = 3
		effectList.ScrollBarImageColor3 =
			Color3.fromRGB(255, 195, 95)

		emptyEffects.Position = UDim2.fromOffset(0, 34)
		emptyEffects.Size = UDim2.fromOffset(375, 50)

		for _, item in ipairs(effectList:GetChildren()) do
			if item:IsA("TextButton") then
				item.Size = UDim2.fromOffset(102, 96)
			end
		end
	end

	-- showTab peut replacer certains éléments :
	-- on applique le placement final après son travail.
	local ancienShowTab = showTab

	showTab = function(...)
		ancienShowTab(...)
		ajusterEffets()
	end

	effectList.ChildAdded:Connect(function(item)
		if item:IsA("TextButton") then
			task.defer(function()
				if item.Parent then
					ajusterEffets()
				end
			end)
		end
	end)

	ajusterEffets()
end

-- MesCraxMaxOrDiamant_20261027
do
	local RunService = game:GetService("RunService")

	local GOLD = Color3.fromRGB(255, 195, 55)
	local GOLD_LIGHT = Color3.fromRGB(255, 245, 181)
	local DIAMOND = Color3.fromRGB(158, 232, 255)

	local gradients = {}
	local attached = setmetatable({}, {__mode = "k"})
	local levelConnections = {}

	local function getLevel(id)
		local folder = player:FindFirstChild("CraxSkillLevels")
		local value = folder and folder:FindFirstChild(id)

		if value and value:IsA("IntValue") then
			return math.clamp(value.Value, 0, 4)
		end

		return 0
	end

	local function round(object, radius)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius)
		corner.Parent = object
	end

	local maxSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, GOLD),
		ColorSequenceKeypoint.new(0.30, GOLD_LIGHT),
		ColorSequenceKeypoint.new(0.48, DIAMOND),
		ColorSequenceKeypoint.new(0.62, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.78, GOLD),
		ColorSequenceKeypoint.new(1, GOLD_LIGHT),
	})

	local function attachCard(card)
		if not card:IsA("TextButton") or attached[card] then
			return
		end

		local id = card:GetAttribute("CraxCardId")
		if type(id) ~= "string" then return end

		local frame = Instance.new("Frame")
		frame.Name = "MaxGoldDiamondFrame"
		frame.Size = UDim2.new(1, -4, 1, -4)
		frame.Position = UDim2.fromOffset(2, 2)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Active = false
		frame.ZIndex = 12
		frame.Parent = card
		round(frame, 14)

		local outline = Instance.new("UIStroke")
		outline.Name = "MaxGoldDiamondOutline"
		outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		outline.Thickness = 4
		outline.Color = Color3.new(1, 1, 1)
		outline.Parent = frame

		local gradient = Instance.new("UIGradient")
		gradient.Color = maxSequence
		gradient.Rotation = 25
		gradient.Parent = outline

		gradients[gradient] = true
		attached[card] = {
			id = id,
			frame = frame,
		}
	end

	local function updateCards()
		for _, card in ipairs(list:GetChildren()) do
			attachCard(card)
		end

		for card, entry in pairs(attached) do
			if not card.Parent then
				attached[card] = nil
			else
				entry.frame.Visible = getLevel(entry.id) >= 4
			end
		end
	end

	list.ChildAdded:Connect(function(child)
		task.defer(function()
			if child.Parent then
				attachCard(child)
				updateCards()
			end
		end)
	end)

	local defaultDetailColor = Color3.fromRGB(20, 53, 78)
	local maxDetailColor = Color3.fromRGB(91, 57, 20)

	local function updateDisplay()
		local id = detail:GetAttribute("CraxDisplayedId")
		local isMax = type(id) == "string" and getLevel(id) >= 4

		detail.BackgroundColor3 =
			isMax and maxDetailColor or defaultDetailColor

		local fond = detail:FindFirstChild("OpenDisplayAmbient")
		local gradient = fond
			and fond:FindFirstChildWhichIsA("UIGradient")

		if fond and fond:IsA("Frame") then
			fond.BackgroundColor3 = Color3.new(1, 1, 1)
		end

		if gradient then
			if isMax then
				gradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(255, 220, 126)
					),
					ColorSequenceKeypoint.new(
						0.45,
						Color3.fromRGB(180, 132, 54)
					),
					ColorSequenceKeypoint.new(
						0.75,
						Color3.fromRGB(67, 113, 137)
					),
					ColorSequenceKeypoint.new(
						1,
						Color3.fromRGB(20, 45, 72)
					),
				})
			else
				gradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(169, 221, 220)
					),
					ColorSequenceKeypoint.new(
						0.5,
						Color3.fromRGB(68, 147, 170)
					),
					ColorSequenceKeypoint.new(
						1,
						Color3.fromRGB(24, 61, 91)
					),
				})
			end
		end
	end

	local function updateAll()
		updateCards()
		updateDisplay()
	end

	detail:GetAttributeChangedSignal("CraxDisplayedId")
		:Connect(updateDisplay)

	local function watchLevels(folder)
		if not folder or folder.Name ~= "CraxSkillLevels" then
			return
		end

		local function watch(value)
			if not value:IsA("IntValue") or levelConnections[value] then
				return
			end

			levelConnections[value] = value.Changed:Connect(updateAll)
		end

		for _, value in ipairs(folder:GetChildren()) do
			watch(value)
		end

		folder.ChildAdded:Connect(function(value)
			watch(value)
			updateAll()
		end)

		folder.ChildRemoved:Connect(function(value)
			if levelConnections[value] then
				levelConnections[value]:Disconnect()
				levelConnections[value] = nil
			end
			task.defer(updateAll)
		end)
	end

	watchLevels(player:FindFirstChild("CraxSkillLevels"))

	player.ChildAdded:Connect(function(child)
		if child.Name == "CraxSkillLevels" then
			watchLevels(child)
			updateAll()
		end
	end)

	local animation = RunService.RenderStepped:Connect(function()
		if not overlay.Visible then return end

		local reduced =
			player:GetAttribute("CraxReducedMotion") == true

		for gradient in pairs(gradients) do
			if not gradient.Parent then
				gradients[gradient] = nil
			elseif not reduced then
				gradient.Rotation = 25 + (os.clock() * 24) % 360
			end
		end
	end)

	gui.Destroying:Connect(function()
		animation:Disconnect()

		for _, connection in pairs(levelConnections) do
			connection:Disconnect()
		end
	end)

	updateAll()
end

-- MesCraxMaxDiamantOrLisible_20261027
do
	local RunService = game:GetService("RunService")

	local levels = player:FindFirstChild("CraxSkillLevels")
	local connections = {}

	local function getLevel(id)
		local folder = player:FindFirstChild("CraxSkillLevels")
		local value = folder and folder:FindFirstChild(id)

		if value and value:IsA("IntValue") then
			return math.clamp(value.Value, 0, 4)
		end

		return 0
	end

	local GOLD = Color3.fromRGB(255, 193, 54)
	local GOLD_LIGHT = Color3.fromRGB(255, 239, 163)
	local DIAMOND = Color3.fromRGB(111, 218, 255)
	local DIAMOND_LIGHT = Color3.fromRGB(220, 252, 255)

	local maxColors = ColorSequence.new({
		ColorSequenceKeypoint.new(0, GOLD),
		ColorSequenceKeypoint.new(0.22, GOLD_LIGHT),
		ColorSequenceKeypoint.new(0.42, DIAMOND),
		ColorSequenceKeypoint.new(0.60, DIAMOND_LIGHT),
		ColorSequenceKeypoint.new(0.80, GOLD),
		ColorSequenceKeypoint.new(1, GOLD_LIGHT),
	})

	local baseColors = ColorSequence.new({
		ColorSequenceKeypoint.new(
			0,
			Color3.fromRGB(177, 231, 255)
		),
		ColorSequenceKeypoint.new(
			0.5,
			Color3.fromRGB(91, 184, 225)
		),
		ColorSequenceKeypoint.new(
			1,
			Color3.fromRGB(35, 113, 166)
		),
	})

	local function updateDisplay()
		local id = detail:GetAttribute("CraxDisplayedId")
		local level = type(id) == "string" and getLevel(id) or 0

		local fond = detail:FindFirstChild("OpenDisplayAmbient")
		local gradient = fond
			and fond:FindFirstChildWhichIsA("UIGradient")

		if fond and fond:IsA("Frame") then
			fond.BackgroundColor3 = Color3.new(1, 1, 1)
			fond.BackgroundTransparency = 0.08
		end

		if gradient then
			gradient.Color = level >= 4 and maxColors or baseColors
			gradient.Rotation = level >= 4 and 30 or 90
		end

		-- Le fond général reste assez sombre pour lire les textes.
		detail.BackgroundColor3 = level >= 4
			and Color3.fromRGB(45, 50, 59)
			or Color3.fromRGB(20, 75, 112)

		-- Rareté sous le nom du Crax.
		rarity.Position = UDim2.fromOffset(16, 46)
		rarity.Size = UDim2.fromOffset(250, 30)
		rarity.TextSize = 21
		rarity.Font = Enum.Font.GothamBlack
		rarity.TextStrokeColor3 = Color3.fromRGB(5, 14, 28)
		rarity.TextStrokeTransparency = 0.15

		local rarityText = tostring(rarity.Text):upper()
		if rarityText:find("SECRET", 1, true) then
			rarity.TextColor3 = Color3.fromRGB(96, 255, 185)
		elseif rarityText:find("GEND", 1, true) then
			rarity.TextColor3 = Color3.fromRGB(255, 218, 105)
		elseif rarityText:find("PIQUE", 1, true) then
			rarity.TextColor3 = Color3.fromRGB(222, 172, 255)
		elseif rarityText:find("RARE", 1, true) then
			rarity.TextColor3 = Color3.fromRGB(255, 183, 105)
		else
			rarity.TextColor3 = Color3.fromRGB(211, 245, 255)
		end
	end

	local function updateCards()
		for _, card in ipairs(list:GetChildren()) do
			if card:IsA("TextButton") then
				local id = card:GetAttribute("CraxCardId")

				if type(id) == "string" then
					local level = getLevel(id)

					-- Fond bleu ciel pour les Crax de base.
					if level == 0 then
						card.BackgroundColor3 =
							Color3.fromRGB(52, 145, 195)
						card.BackgroundTransparency = 0.05
					end
				end
			end
		end
	end

	local function updateTabs()
		for i = 1, 6 do
			local tab = panel:FindFirstChild("Filtre" .. i)

			if tab and tab:IsA("TextButton") then
				tab.TextSize = 14
				tab.Font = Enum.Font.GothamBlack
				tab.TextWrapped = true
				tab.TextColor3 = Color3.new(1, 1, 1)
				tab.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
				tab.TextStrokeTransparency = 0.2
			end
		end
	end

	local function updateAll()
		updateDisplay()
		updateCards()
		updateTabs()
	end

	local previousDescribe = describe

	describe = function(...)
		previousDescribe(...)
		updateDisplay()
	end

	local previousRefresh = refresh

	refresh = function(...)
		previousRefresh(...)
		updateCards()
	end

	list.ChildAdded:Connect(function()
		task.defer(updateCards)
	end)

	detail:GetAttributeChangedSignal("CraxDisplayedId")
		:Connect(updateDisplay)

	local function watchLevels(folder)
		if not folder or folder.Name ~= "CraxSkillLevels" then
			return
		end

		local function watch(value)
			if value:IsA("IntValue") and not connections[value] then
				connections[value] = value.Changed:Connect(updateAll)
			end
		end

		for _, value in ipairs(folder:GetChildren()) do
			watch(value)
		end

		folder.ChildAdded:Connect(function(value)
			watch(value)
			updateAll()
		end)
	end

	watchLevels(levels)

	player.ChildAdded:Connect(function(child)
		if child.Name == "CraxSkillLevels" then
			watchLevels(child)
			updateAll()
		end
	end)

	local animation = RunService.RenderStepped:Connect(function()
		if not overlay.Visible or not detail.Visible then return end
		if player:GetAttribute("CraxReducedMotion") == true then return end

		local id = detail:GetAttribute("CraxDisplayedId")
		if type(id) ~= "string" or getLevel(id) < 4 then return end

		local fond = detail:FindFirstChild("OpenDisplayAmbient")
		local gradient = fond
			and fond:FindFirstChildWhichIsA("UIGradient")

		if gradient then
			gradient.Offset = Vector2.new(
				math.sin(os.clock() * 0.7) * 0.25,
				0
			)
		end
	end)

	gui.Destroying:Connect(function()
		animation:Disconnect()

		for _, connection in pairs(connections) do
			connection:Disconnect()
		end
	end)

	updateAll()
end

-- MesCraxMaxReliefBrillant_20261027
do
	local RunService = game:GetService("RunService")

	local function make(class, parent, properties)
		local object = Instance.new(class)

		for key, value in pairs(properties) do
			object[key] = value
		end

		object.Parent = parent
		return object
	end

	local function currentLevel()
		local id = detail:GetAttribute("CraxDisplayedId")
		local folder = player:FindFirstChild("CraxSkillLevels")
		local value = folder and type(id) == "string"
			and folder:FindFirstChild(id)

		if value and value:IsA("IntValue") then
			return math.clamp(value.Value, 0, 4)
		end

		return 0
	end

	local effect = make("Frame", detail, {
		Name = "MaxReliefOrDiamant",
		Position = UDim2.fromOffset(5, 55),
		Size = UDim2.new(1, -10, 0, 265),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		Visible = false,
		ZIndex = 2,
	})

	local function rounded(object, radius)
		make("UICorner", object, {
			CornerRadius = UDim.new(0, radius),
		})
	end

	-- Cadre or en relief.
	local border = make("Frame", effect, {
		Name = "BordureOr",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		ZIndex = 2,
	})

	rounded(border, 22)

	local goldStroke = make("UIStroke", border, {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 4,
		Color = Color3.new(1, 1, 1),
		Transparency = 0.03,
	})

	local goldGradient = make("UIGradient", goldStroke, {
		Rotation = 30,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(
				0,
				Color3.fromRGB(167, 94, 12)
			),
			ColorSequenceKeypoint.new(
				0.25,
				Color3.fromRGB(255, 205, 54)
			),
			ColorSequenceKeypoint.new(
				0.5,
				Color3.fromRGB(255, 255, 220)
			),
			ColorSequenceKeypoint.new(
				0.7,
				Color3.fromRGB(255, 199, 42)
			),
			ColorSequenceKeypoint.new(
				1,
				Color3.fromRGB(151, 83, 10)
			),
		}),
	})

	-- Facettes géométriques sur les côtés pour garder le Crax dégagé.
	local crystals = {}

	for side = 1, 2 do
		for i = 1, 5 do
			local crystal = make("Frame", effect, {
				Name = "FacetteDiamant",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(
					side == 1 and 0 or 1,
					side == 1 and 16 or -16,
					0,
					34 + (i - 1) * 46
				),
				Size = UDim2.fromOffset(
					i % 2 == 0 and 16 or 21,
					i % 2 == 0 and 16 or 21
				),
				Rotation = 45,
				BackgroundColor3 = Color3.fromRGB(130, 221, 255),
				BackgroundTransparency = 0.12,
				BorderSizePixel = 0,
				Active = false,
				ZIndex = 2,
			})

			local stroke = make("UIStroke", crystal, {
				Color = Color3.fromRGB(232, 253, 255),
				Thickness = 1.5,
				Transparency = 0.05,
			})

			local gradient = make("UIGradient", crystal, {
				Rotation = 35,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(35, 118, 192)
					),
					ColorSequenceKeypoint.new(
						0.45,
						Color3.fromRGB(154, 234, 255)
					),
					ColorSequenceKeypoint.new(
						0.65,
						Color3.fromRGB(255, 255, 255)
					),
					ColorSequenceKeypoint.new(
						1,
						Color3.fromRGB(62, 155, 218)
					),
				}),
			})

			table.insert(crystals, {
				object = crystal,
				stroke = stroke,
				gradient = gradient,
				index = i + side * 5,
			})
		end
	end

	-- Reflets lumineux mobiles, sans caractères de police.
	local glints = {}

	for i = 1, 8 do
		local glint = make("Frame", effect, {
			Name = "RefletMax",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(5, 5),
			BackgroundColor3 = i % 2 == 0
				and Color3.fromRGB(255, 232, 136)
				or Color3.fromRGB(204, 247, 255),
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 3,
		})

		rounded(glint, 100)
		glints[i] = glint
	end

	local function updateVisibility()
		effect.Visible = currentLevel() >= 4
	end

	detail:GetAttributeChangedSignal("CraxDisplayedId")
		:Connect(updateVisibility)

	local folder = player:FindFirstChild("CraxSkillLevels")

	if folder then
		for _, value in ipairs(folder:GetChildren()) do
			if value:IsA("IntValue") then
				value.Changed:Connect(updateVisibility)
			end
		end

		folder.ChildAdded:Connect(function(value)
			if value:IsA("IntValue") then
				value.Changed:Connect(updateVisibility)
			end
			updateVisibility()
		end)
	end

	local animation = RunService.RenderStepped:Connect(function()
		if not overlay.Visible or not detail.Visible then return end

		local max = currentLevel() >= 4

		if effect.Visible ~= max then
			effect.Visible = max
		end

		if not max then return end

		local reduced =
			player:GetAttribute("CraxReducedMotion") == true

		local now = reduced and 0 or os.clock()

		goldGradient.Rotation = 30 + (now * 24) % 360
		goldGradient.Offset =
			Vector2.new(math.sin(now * 0.8) * 0.3, 0)

		for _, entry in ipairs(crystals) do
			local shine = (math.sin(now * 2.5 + entry.index) + 1) / 2
			entry.object.BackgroundTransparency = 0.08 + shine * 0.18
			entry.stroke.Transparency = 0.05 + shine * 0.25
			entry.gradient.Offset =
				Vector2.new(math.sin(now + entry.index) * 0.25, 0)
		end

		for i, glint in ipairs(glints) do
			local angle = now * 0.55 + i * math.pi * 2 / #glints
			local x = 0.5 + math.cos(angle) * 0.43
			local y = 0.5 + math.sin(angle) * 0.41

			glint.Position = UDim2.fromScale(x, y)
			glint.BackgroundTransparency =
				0.12 + (math.sin(now * 3 + i) + 1) * 0.2
		end
	end)

	gui.Destroying:Connect(function()
		animation:Disconnect()
	end)

	updateVisibility()
end

-- MesCraxRarityMotion_20261027
do
	local RunService = game:GetService("RunService")
	local random = Random.new(9463)

	local function make(class, parent, properties)
		local object = Instance.new(class)

		for key, value in pairs(properties) do
			object[key] = value
		end

		object.Parent = parent
		return object
	end

	local function currentInfo()
		local id = detail:GetAttribute("CraxDisplayedId")
		local info = type(id) == "string" and catalog[id] or {}
		local rarityName = tostring(info.Rarity or "Commun"):upper()

		local folder = player:FindFirstChild("CraxSkillLevels")
		local levelValue = folder and type(id) == "string"
			and folder:FindFirstChild(id)

		local level = levelValue and levelValue:IsA("IntValue")
			and levelValue.Value or 0

		if rarityName:find("SECRET", 1, true) then
			return "Secret", level
		elseif rarityName:find("GEND", 1, true) then
			return "Legendaire", level
		elseif rarityName:find("PIQUE", 1, true) then
			return "Epique", level
		elseif rarityName:find("RARE", 1, true) then
			return "Rare", level
		end

		return "Commun", level
	end

	local colors = {
		Commun = Color3.fromRGB(224, 248, 255),
		Rare = Color3.fromRGB(255, 164, 79),
		Epique = Color3.fromRGB(213, 155, 255),
		Legendaire = Color3.fromRGB(255, 206, 89),
		Secret = Color3.fromRGB(104, 255, 182),
	}

	local layer = make("Frame", detail, {
		Name = "CraxRarityMotion",
		Position = UDim2.fromOffset(8, 59),
		Size = UDim2.new(1, -16, 0, 250),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = false,
		ZIndex = 2,
	})

	local particles = {}

	for i = 1, 14 do
		local particle = make("Frame", layer, {
			Name = "Particule" .. i,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = colors.Commun,
			BorderSizePixel = 0,
			BackgroundTransparency = 0.3,
			Active = false,
			ZIndex = 2,
		})

		make("UICorner", particle, {
			CornerRadius = UDim.new(1, 0),
		})

		particles[i] = {
			object = particle,
			phase = random:NextNumber(0, 1),
			side = i % 2 == 0 and -1 or 1,
			speed = random:NextNumber(0.08, 0.17),
			size = random:NextInteger(3, 7),
		}
	end

	-- Segments utilisables pour les éclairs et fissures.
	local segments = {}

	for i = 1, 8 do
		segments[i] = make("Frame", layer, {
			Name = "Energie" .. i,
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = colors.Legendaire,
			BorderSizePixel = 0,
			BackgroundTransparency = 0.2,
			Active = false,
			Visible = false,
			ZIndex = 2,
		})
	end

	local function placeLine(frame, x1, y1, x2, y2)
		local delta = Vector2.new(x2 - x1, y2 - y1)

		frame.Position = UDim2.fromOffset(x1, y1)
		frame.Size = UDim2.fromOffset(delta.Magnitude, 2)
		frame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	end

	local animation = RunService.RenderStepped:Connect(function()
		local visible = overlay.Visible and detail.Visible

		if not visible then
			layer.Visible = false
			return
		end

		local rarityName, level = currentInfo()

		-- L'habillage MAX or/diamant garde sa propre animation.
		if level >= 4 then
			layer.Visible = false
			return
		end

		layer.Visible = true

		local reduced =
			player:GetAttribute("CraxReducedMotion") == true

		local now = reduced and 0 or os.clock()
		local color = colors[rarityName]
		local width = layer.AbsoluteSize.X
		local height = layer.AbsoluteSize.Y

		if width < 1 or height < 1 then return end

		-- Les positions restent sur les côtés de la vitrine.
		for i, entry in ipairs(particles) do
			local phase = (entry.phase + now * entry.speed) % 1
			local sideX = entry.side == -1 and 0.13 or 0.87

			local x = sideX + math.sin(now + i) * 0.025
			local y = 0.88 - phase * 0.70

			entry.object.Position = UDim2.fromScale(x, y)
			entry.object.BackgroundColor3 = color
			entry.object.BackgroundTransparency =
				math.clamp(math.abs(phase - 0.5) * 1.6, 0.1, 0.85)

			if rarityName == "Epique" then
				-- Petites traînées violettes.
				entry.object.Size = UDim2.fromOffset(
					entry.size * 2.5,
					math.max(2, entry.size * 0.55)
				)
				entry.object.Rotation = -35
			else
				entry.object.Size = UDim2.fromOffset(
					entry.size,
					entry.size
				)
				entry.object.Rotation = 0
			end
		end

		local hasLines =
			rarityName == "Rare"
			or rarityName == "Legendaire"
			or rarityName == "Secret"

		local flash = not reduced and (now * 1.25) % 1 < 0.23

		for i, segment in ipairs(segments) do
			segment.Visible = hasLines and flash
			segment.BackgroundColor3 = color

			if segment.Visible then
				local side = i <= 4 and -1 or 1
				local step = (i - 1) % 4

				-- Coordonnées relatives à la taille logique du cadre.
				local x = side == -1 and 28 or 350
				local y = 42 + step * 25
				local bend = step % 2 == 0 and 10 or -6

				placeLine(
					segment,
					x + bend * side,
					y,
					x - bend * side,
					y + 23
				)
			end
		end
	end)

	gui.Destroying:Connect(function()
		animation:Disconnect()
	end)
end



-- MesCraxSelectionVisible_20261027
do
	local TweenService = game:GetService("TweenService")

	local entries = setmetatable({}, {__mode = "k"})
	local selectedCard

	local function attach(card)
		if not card:IsA("TextButton") or entries[card] then return end

		local id = card:GetAttribute("CraxCardId")
		if type(id) ~= "string" then return end

		-- Une échelle supplémentaire, indépendante du survol existant.
		local scale = Instance.new("UIScale")
		scale.Name = "SelectedCraxScale"
		scale.Scale = 1
		scale.Parent = card

		local frame = Instance.new("Frame")
		frame.Name = "SelectedCraxHighlight"
		frame.Position = UDim2.fromOffset(2, 2)
		frame.Size = UDim2.new(1, -4, 1, -4)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Visible = false
		frame.Active = false
		frame.ZIndex = 30
		frame.Parent = card

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 14)
		corner.Parent = frame

		local outline = Instance.new("UIStroke")
		outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		outline.Thickness = 5
		outline.Color = Color3.fromRGB(255, 211, 69)
		outline.Transparency = 0
		outline.Parent = frame

		local label = Instance.new("TextLabel")
		label.Name = "SelectedCraxLabel"
		label.AnchorPoint = Vector2.new(0.5, 0)
		label.Position = UDim2.new(0.5, 0, 0, 6)
		label.Size = UDim2.fromOffset(150, 26)
		label.BackgroundColor3 = Color3.fromRGB(255, 194, 40)
		label.BorderSizePixel = 0
		label.Text = "SÉLECTIONNÉ"
		label.Font = Enum.Font.GothamBlack
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(57, 30, 8)
		label.Active = false
		label.ZIndex = 31
		label.Parent = frame

		-- Appliqué après l'ajout au parent : les autres scripts
		-- de style ne masquent plus le texte.
		label.Size = UDim2.fromOffset(176, 30)
		label.BackgroundColor3 = Color3.fromRGB(12, 49, 81)
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextSize = 18
		label.TextStrokeTransparency = 1

		local labelBorder = Instance.new("UIStroke")
		labelBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		labelBorder.Color = Color3.fromRGB(255, 220, 105)
		labelBorder.Thickness = 2
		labelBorder.Parent = label

		local labelCorner = Instance.new("UICorner")
		labelCorner.CornerRadius = UDim.new(0, 8)
		labelCorner.Parent = label

		entries[card] = {
			id = id,
			scale = scale,
			frame = frame,
			tween = nil,
		}
	end

	local function setScale(entry, target)
		if entry.tween then
			entry.tween:Cancel()
		end

		if player:GetAttribute("CraxReducedMotion") == true then
			entry.scale.Scale = target
			return
		end

		entry.tween = TweenService:Create(
			entry.scale,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			),
			{Scale = target}
		)

		entry.tween:Play()
	end

	local function update()
		local id = detail:GetAttribute("CraxDisplayedId")

		for _, card in ipairs(list:GetChildren()) do
			attach(card)
		end

		for card, entry in pairs(entries) do
			if not card.Parent then
				entries[card] = nil
			else
				local active = entry.id == id
				entry.frame.Visible = active

				if active and selectedCard ~= card then
					selectedCard = card
					setScale(entry, 1.035)
				elseif not active and entry.scale.Scale ~= 1 then
					setScale(entry, 1)
				end
			end
		end
	end

	list.ChildAdded:Connect(function(card)
		task.defer(function()
			if card.Parent then
				attach(card)
				update()
			end
		end)
	end)

	detail:GetAttributeChangedSignal("CraxDisplayedId"):Connect(update)
	update()
end
