-- LuckyCraxIntegrationV1
local data=(function()
-- SymbiotiCraxIntegrationV1
local data=(function()
-- SuperCraxIntegrationV1
local data=(function()
local data=(function()
-- CraxFleau v1
local data=(function()
-- GoldenCombatSkin_v1
local data = (function()
local data=(function()
-- ModuleScript : ServerScriptService > CraxSkinServer
local ServerStorage=game:GetService("ServerStorage")
local RS=game:GetService("ReplicatedStorage")
local Skin={}
local originals=setmetatable({},{__mode="k"})
local function headOf(model)
 local head=model:FindFirstChild("Head",true)
 if head and not head:IsA("BasePart") then head=head:FindFirstChildWhichIsA("BasePart",true) end
 assert(head and head:IsA("BasePart"),"Head introuvable : "..model.Name)
 return head
end
local function matchingToothPart(part,model,donor)
 local tooth=part
 while tooth and tooth~=model and not tooth.Name:match("^Tooth_%d+_%d+$") do tooth=tooth.Parent end
 if not tooth or tooth==model then return nil end
 local source=donor:FindFirstChild(tooth.Name,true)
 if not source then return nil end
 if tooth==part then return source:IsA("BasePart") and source or nil end
 local path={}; local current=part
 while current~=tooth do table.insert(path,1,current.Name); current=current.Parent end
 for _,name in ipairs(path) do source=source and source:FindFirstChild(name) end
 return source and source:IsA("BasePart") and source or nil
end
function Skin.Apply(model,id,config)
 local head=headOf(model)
 originals[model]=originals[model] or {}; local saved=originals[model]
 for _,name in ipairs({"SpiderMask","GhostVisual","FantasticVisual"}) do
  local prior=model:FindFirstChild(name); if prior then prior:Destroy() end
 end
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") then
   saved[p]=saved[p] or {color=p.Color,transparency=p.Transparency,size=p.Size,relative=head.CFrame:ToObjectSpace(p.CFrame)}
   local s=saved[p]; p.Color=s.color; p.Transparency=s.transparency; p.Size=s.size
   if p~=head then p.CFrame=head.CFrame*s.relative end
  end
 end
 local upper=model:FindFirstChild("UpperShell",true)
 local lower=model:FindFirstChild("LowerShell",true)
 if upper and lower then head.Transparency=1; upper.Transparency=0; lower.Transparency=0 end
 if id~="Crax_Spidey" and id~="Crax_Ghosty" and id~="Crax_Fantastic" then return end
 local folder=ServerStorage:FindFirstChild("CraxTemplates")
 local donor=folder and folder:FindFirstChild(config.TemplateName)
 assert(donor,"Modèle absent : ServerStorage.CraxTemplates."..tostring(config.TemplateName))
 local donorHead=headOf(donor)
 local scale=math.max(head.Size.X,head.Size.Y,head.Size.Z)/math.max(donorHead.Size.X,donorHead.Size.Y,donorHead.Size.Z)
 local function remap(cf)
  local r=donorHead.CFrame:ToObjectSpace(cf)
  -- FantasticFacingFix_v1
  if id == "Crax_Fantastic" then
   r = CFrame.Angles(0, math.pi, 0) * r
  end
  return head.CFrame*(r.Rotation+r.Position*scale)

 end
 if id=="Crax_Ghosty" or id=="Crax_Fantastic" then
  if id=="Crax_Fantastic" then
   for _,p in ipairs(model:GetDescendants())do if p:IsA("BasePart")then p.Transparency=1 end end
  end
  -- Copie visuelle complète, sans remplacer le Head de physique ni les références des systèmes.
  local visual=donor:Clone(); visual.Name=id=="Crax_Fantastic" and "FantasticVisual"or "GhostVisual"
  for _,p in ipairs(visual:GetDescendants()) do
   if p:IsA("Script") or p:IsA("LocalScript") or p:IsA("BillboardGui") or p:IsA("Sound") then p:Destroy()
   elseif p:IsA("BasePart") then
    p.CFrame=remap(p.CFrame); p.Size=p.Size*scale
    p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false
   end
  end
  visual.PrimaryPart=nil
  visual.Parent=model
 else
  local donorMask=donor:FindFirstChild("SpiderMask")
  assert(donorMask,"SpiderMask manque dans le modèle Spidey")
  head.Transparency=0
  if upper then upper.Transparency=1 end
  if lower then lower.Transparency=1 end
  for _,p in ipairs(model:GetDescendants()) do
   if p:IsA("BasePart") then
    if p.Name=="EyeLeft" or p.Name=="EyeRight" or p.Name=="AngryEyeLeft" or p.Name=="AngryEyeRight" then p.Transparency=1
    else
     local original=matchingToothPart(p,model,donor)
     if original then p.Size=original.Size*scale; p.CFrame=remap(original.CFrame); p.Color=original.Color end
    end
   end
  end
  local mask=donorMask:Clone()
  if mask:IsA("BasePart") then
   mask.CFrame=remap(mask.CFrame); mask.Size=mask.Size*scale; mask.Anchored=true; mask.CanCollide=false; mask.CanTouch=false
  end
  for _,p in ipairs(mask:GetDescendants()) do
   if p:IsA("BasePart") then p.CFrame=remap(p.CFrame); p.Size=p.Size*scale; p.Anchored=true; p.CanCollide=false; p.CanTouch=false end
  end
  mask.Parent=model
 end
 local previews=RS:FindFirstChild("CraxPreviews")
 if previews and not previews:FindFirstChild(config.TemplateName) then donor:Clone().Parent=previews end
end
return Skin

end)()
local V=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxDeadlyVisuals'))
local baseScales=setmetatable({},{__mode='k'});local apply=data.Apply
function data.Apply(model,id,config)
 baseScales[model]=baseScales[model]or model:GetScale()
 local old=model:FindFirstChild('DeadlyVisual');if old then old:Destroy()end
 model:ScaleTo(baseScales[model]);model:SetAttribute('DeadlyMember',nil);model:SetAttribute('DeadlyFamilyBoost',false);model:SetAttribute('DeadlyShield',false)
 apply(model,id,config)
 if id~='Crax_Deadly'then return end
 local h=V.Head(model);model:ScaleTo(baseScales[model]*.5)
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then p.Transparency=1 end end
 local visual=V.Make(game:GetService('ServerStorage'):WaitForChild('CraxDeadlyBase'),'OG',1)
 local vh=V.Head(visual);local ratio=math.max(h.Size.X,h.Size.Y,h.Size.Z)/math.max(vh.Size.X,vh.Size.Y,vh.Size.Z)
 visual:ScaleTo(visual:GetScale()*ratio);visual:PivotTo(h.CFrame);visual.Name='DeadlyVisual';visual.Parent=model
 for _,part in ipairs(visual:GetDescendants())do if part:IsA('BasePart')then part:SetAttribute('DeadlyIntendedAlpha',part.Transparency)end end
 model:SetAttribute('DeadlyMember','OG')
end
-- PlumberCapSkinFix_v1
local previousApplyPlumber = data.Apply

local function plumberHead(model)
	local head = model:FindFirstChild("Head", true)
	if head and not head:IsA("BasePart") then
		head = head:FindFirstChildWhichIsA("BasePart", true)
	end
	assert(head and head:IsA("BasePart"), "Head absent : " .. model.Name)
	return head
end

local function plumberCapPart(part, root)
	local current = part
	while current and current ~= root do
		if current.Name:lower():sub(1, 3) == "cap" then
			return true
		end
		current = current.Parent
	end
	return false
end

function data.Apply(model, id, config)
	-- Retirer la casquette avant la restauration du skin précédent.
	local old = model:FindFirstChild("PlumberVisual")
	if old then
		old:Destroy()
	end

	previousApplyPlumber(model, id, config)

	if id ~= "Crax_Plumber" then
		return
	end

	local RS = game:GetService("ReplicatedStorage")
	local previews = assert(RS:FindFirstChild("CraxPreviews"))
	local donor = assert(previews:FindFirstChild("Crax_Plumber"))
	local head = plumberHead(model)
	local donorHead = plumberHead(donor)

	local scale = math.max(head.Size.X, head.Size.Y, head.Size.Z)
		/ math.max(donorHead.Size.X, donorHead.Size.Y, donorHead.Size.Z)

	local visual = Instance.new("Model")
	visual.Name = "PlumberVisual"

	local ok, err = pcall(function()
		for _, original in ipairs(donor:GetDescendants()) do
			if original:IsA("BasePart") and plumberCapPart(original, donor) then
				local part = assert(original:Clone(), "Pièce non clonable : " .. original.Name)

				-- Chaque pièce est copiée séparément, sans doublons imbriqués.
				for _, child in ipairs(part:GetDescendants()) do
					if child:IsA("BasePart")
						or child:IsA("LuaSourceContainer")
						or child:IsA("JointInstance")
						or child:IsA("Constraint")
						or child:IsA("Sound")
					then
						child:Destroy()
					end
				end

				local relative = donorHead.CFrame:ToObjectSpace(original.CFrame)
				part.Size = original.Size * scale
				part.CFrame = head.CFrame
					* (relative.Rotation + relative.Position * scale)

				part.Anchored = true
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part.CastShadow = true
				part.LocalTransparencyModifier = 0
				part.Parent = visual
			end
		end

		assert(#visual:GetChildren() > 0, "Aucune pièce de casquette trouvée.")
	end)

	if not ok then
		visual:Destroy()
		error(err)
	end

	visual.Parent = model
end

return data

end)()
local RS = game:GetService("ReplicatedStorage")
local V = require(RS:WaitForChild("GoldenCraxVisuals")
	:WaitForChild("GoldenVisual"))

assert(type(V.ApplyGoldPBR) == "function",
	"ApplyGoldPBR absent du module GoldenVisual.")

local previousApply = data.Apply
local saved = setmetatable({}, {__mode = "k"})

local function restore(model)
	local record = saved[model]
	if not record then return end

	for part, info in pairs(record) do
		if part:IsDescendantOf(model) then
			part.Color = info.Color
			part.Material = info.Material
			part.MaterialVariant = info.MaterialVariant
			part.Reflectance = info.Reflectance

			if part:IsA("MeshPart") then
				part.TextureID = info.TextureID
			end

			-- GoldenSolidRestore-6.0: remove the current gold surface before restoring originals.
			for _, current in ipairs(part:GetChildren()) do
				if current:IsA("SurfaceAppearance") then current:Destroy() end
			end
			for _, appearance in ipairs(info.Appearances) do
				appearance:Clone().Parent = part
			end
		end

		for _, appearance in ipairs(info.Appearances) do
			appearance:Destroy()
		end
	end

	saved[model] = nil
end

function data.Apply(model, id, config)
	-- Restaurer avant que le système existant applique le prochain skin.
	restore(model)
	previousApply(model, id, config)

	if id ~= "Crax_Golden" then return end

	local record = {}
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local appearances = {}

			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("SurfaceAppearance") then
					appearances[#appearances + 1] = child:Clone()
				end
			end

			record[part] = {
				Color = part.Color,
				Material = part.Material,
				MaterialVariant = part.MaterialVariant,
				Reflectance = part.Reflectance,
				TextureID = part:IsA("MeshPart")
					and part.TextureID or "",
				Appearances = appearances,
			}
		end
	end

	saved[model] = record

	local ok, err = pcall(V.ApplyGoldPBR, model)
	if not ok then
		restore(model)
		error("Application du rendu Golden : " .. tostring(err))
	end
end

return data

end)()
local old=data.Apply
local FleauAppearance=require(game:GetService('ReplicatedStorage').CraxFleau.FleauAppearance)
function data.Apply(model,id,config)
 FleauAppearance.Restore(model)
 old(model,id,config)
 if id=='Crax_Fleau'then FleauAppearance.Apply(model,game:GetService('ServerStorage').CraxTemplates.Crax_Fleau)end
end
-- V68: the back cross is a preview ornament, never a combat collider or visual.
local applyBeforeCrossV68=data.Apply
function data.Apply(model,id,config)
 applyBeforeCrossV68(model,id,config)
 if model.Name~="Fighter1"and model.Name~="Fighter2"then return end
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA("BasePart")then
   local ancestor=o
   while ancestor and ancestor~=model do
    if ancestor.Name=="_CraxBackCrossV1"then
     o.Transparency=1;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false;break
    end
    ancestor=ancestor.Parent
   end
  end
 end
end
return data

end)()
local palette=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxInvertedPalette'))
local apply=data.Apply
function data.Apply(model,id,config)
 palette.Restore(model)
 apply(model,id,config)
 if id=='Crax_Inverted'then palette.Apply(model)end
end
return data

end)()
local appearance=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperAppearance'))
local apply=data.Apply
function data.Apply(model,id,config)
 appearance.Restore(model);apply(model,id,config)
 if id=='Crax_Super'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSuperImportedAssets'),'Importer les accessoires de SuperCrax'))end
end
return data

end)()
local appearance=require(game:GetService('ReplicatedStorage').CraxSymAppearance);local apply=data.Apply
function data.Apply(model,id,config)appearance.Restore(model);apply(model,id,config);if id=='Crax_Symbioti'then appearance.Apply(model,assert(game:GetService('ReplicatedStorage'):FindFirstChild('CraxSymImportedAssets')))end end
return data

end)()
local appearance=require(game:GetService('ReplicatedStorage').CraxLuckyAppearance);local apply=data.Apply
function data.Apply(model,id,c)appearance.Restore(model);apply(model,id,c);if id=='Crax_Lucky'then appearance.Apply(model)end end
return data
