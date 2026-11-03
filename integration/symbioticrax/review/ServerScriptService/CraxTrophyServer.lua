-- SymbiotiCraxIntegrationV1
-- CraxVictoryPolish_v2
-- Trophées dérivés des niveaux sauvegardés; équipement exclusivement validé serveur.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local TweenService=game:GetService("TweenService")
local definitions=require(RS:WaitForChild("CraxVictoryCatalog"))
local remote=RS:WaitForChild("CraxTrophyEvent")
local dirty=SSS:WaitForChild("CraxProfileDirty")
local registry={};for crax,spec in pairs(definitions)do if spec.TrophyId then registry[spec.TrophyId]={crax=crax,spec=spec}end end
local records={}
local function ensure(parent,kind,name)
 local item=parent:FindFirstChild(name)
 if not item then item=Instance.new(kind);item.Name=name;item.Parent=parent end
 assert(item:IsA(kind),name.." doit être un "..kind);return item
end
local function owns(player,id)
 local entry=registry[id];local folder=player:FindFirstChild("CraxSkillLevels")
 local value=entry and folder and folder:FindFirstChild(entry.crax)
 return value and value:IsA("IntValue")and value.Value>=entry.spec.MinimumLevel or false
end
local function display(player)
 local r=records[player];if not r then return end
 if r.tween then r.tween:Cancel();r.tween=nil end
 local character=player.Character;if not character then return end
 local old=character:FindFirstChild("CraxEquippedTrophy");if old then old:Destroy()end
 local oldHead=character:FindFirstChild("Head")
 local oldParticles=oldHead and oldHead:FindFirstChild("CraxTrophyGoldParticles");if oldParticles then oldParticles:Destroy()end
 local id=player:GetAttribute("EquippedCraxTrophy")
 local entry=registry[id];local head=character:FindFirstChild("Head")
 if not entry or not head or not owns(player,id)then return end
 local gui=Instance.new("BillboardGui");gui.Name="CraxEquippedTrophy";gui.Adornee=head
 gui.Size=UDim2.fromOffset(230,45);gui.StudsOffsetWorldSpace=Vector3.new(0,3.4,0)
 gui.AlwaysOnTop=true;gui.MaxDistance=130;gui.Parent=character
 local function uppercase(value)
  for lower,upper in pairs({["é"]="É",["è"]="È",["ê"]="Ê",["à"]="À",["â"]="Â",["î"]="Î",["ï"]="Ï",["ô"]="Ô",["ù"]="Ù",["û"]="Û",["ç"]="Ç"})do value=value:gsub(lower,upper)end
  return string.upper(value)
 end
 local title=uppercase(entry.spec.DisplayName)
 local text
 for n=1,5 do
  local label=Instance.new("TextLabel");label.Name=n==5 and "GoldenTitle"or "GoldenDepth"..n
  label.Size=UDim2.fromScale(1,1);label.Position=UDim2.fromOffset(0,(5-n)*.8);label.BackgroundTransparency=1
  label.Text=title;label.Font=Enum.Font.GothamBlack;label.TextSize=22
  if entry.crax=="Crax_Symbioti"then label.TextScaled=true end
  label.TextColor3=n==5 and Color3.new(1,1,1)or Color3.fromRGB(80+n*19,43+n*10,8)
  label.TextStrokeColor3=Color3.fromRGB(62,30,4);label.TextStrokeTransparency=n==5 and .22 or .6
  label.ZIndex=n;label.Parent=gui;if n==5 then text=label end
 end
 local gradient=Instance.new("UIGradient");gradient.Name="GoldenMetal";gradient.Rotation=90
 gradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,217)),
  ColorSequenceKeypoint.new(.28,Color3.fromRGB(255,224,112)),ColorSequenceKeypoint.new(.46,Color3.fromRGB(214,139,22)),
  ColorSequenceKeypoint.new(.56,Color3.fromRGB(255,246,182)),ColorSequenceKeypoint.new(1,Color3.fromRGB(237,169,38))});gradient.Parent=text
 r.tween=TweenService:Create(gradient,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Offset=Vector2.new(0,.35)})
 r.tween:Play()
 local attachment=Instance.new("Attachment");attachment.Name="CraxTrophyGoldParticles";attachment.Position=Vector3.new(0,3.4,0);attachment.Parent=head
 local particles=Instance.new("ParticleEmitter");particles.Name="GoldenPrestige"
 particles.Texture="rbxasset://textures/particles/sparkles_main.dds";particles.Rate=9;particles.Lifetime=NumberRange.new(.7,1.2)
 particles.Speed=NumberRange.new(.3,.8);particles.SpreadAngle=Vector2.new(180,180);particles.LightEmission=1
 particles.Color=ColorSequence.new(Color3.fromRGB(255,248,187),Color3.fromRGB(255,180,28))
 particles.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.2,.18),NumberSequenceKeypoint.new(1,0)})
 particles.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.18,.1),NumberSequenceKeypoint.new(1,1)})
 particles.Parent=attachment

end
local function refresh(player)
 if not player:GetAttribute("InventoryReady")then return end
 local folder=ensure(player,"Folder","CraxTrophies")
 for id in pairs(registry)do ensure(folder,"BoolValue",id).Value=owns(player,id)end
 local equipped=player:GetAttribute("EquippedCraxTrophy")or ""
 if equipped~=""and not owns(player,equipped)then player:SetAttribute("EquippedCraxTrophy","")end
 display(player)
end
local function watch(player)
 if records[player]then return end
 local r={seen={},cooldown=0};records[player]=r
 local function bind(value)
  if value:IsA("IntValue")then value.Changed:Connect(function()refresh(player)end)end
 end
 local function levels(folder)
  if folder.Name~="CraxSkillLevels"or r.folder==folder then return end
  r.folder=folder;for _,value in ipairs(folder:GetChildren())do bind(value)end
  folder.ChildAdded:Connect(function(v)bind(v);refresh(player)end);folder.ChildRemoved:Connect(function()refresh(player)end)
  refresh(player)
 end
 player.ChildAdded:Connect(levels);local folder=player:FindFirstChild("CraxSkillLevels");if folder then levels(folder)end
 player:GetAttributeChangedSignal("InventoryReady"):Connect(function()refresh(player)end)
 player:GetAttributeChangedSignal("EquippedCraxTrophy"):Connect(function()display(player)end)
 local function characterReady(character)
  task.spawn(function()character:WaitForChild("Head",10);if player.Character==character then display(player)end end)
 end
 player.CharacterAdded:Connect(characterReady)
 if player.Character then characterReady(player.Character)end
 refresh(player)
end
remote.OnServerEvent:Connect(function(player,action,id)
 local r=records[player]
 if not r or action~="Equip"or type(id)~="string"or #id>80 then return end
 if os.clock()<r.cooldown then remote:FireClient(player,{Success=false,Message="Patiente un instant."});return end;r.cooldown=os.clock()+.35
 local ok=player:GetAttribute("InventoryReady")==true and player:GetAttribute("ArenaSeat")==nil
  and(id==""or owns(player,id))
 if ok then
  player:SetAttribute("EquippedCraxTrophy",id);dirty:Fire(player)
 end
 remote:FireClient(player,{Success=ok,Message=ok and(id==""and "Trophée retiré."or "Trophée équipé !")or "Débloque ce Trophée et équipe-le hors de l'arène."})
end)
Players.PlayerAdded:Connect(watch)
Players.PlayerRemoving:Connect(function(player)local r=records[player];if r and r.tween then r.tween:Cancel()end;records[player]=nil end)
for _,player in ipairs(Players:GetPlayers())do watch(player)end
