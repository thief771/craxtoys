-- Habillage VeniCrax : tête CraxSourire native + casque capuche de cobra, crête, arcade, veines, crocs et gouttes.
-- Les pièces viennent de ReplicatedStorage.CraxVeniImportedAssets (import de VeniCrax_ACCESSOIRES_IMPORT.fbx).
local RS=game:GetService('ReplicatedStorage')
local M={};local saved=setmetatable({},{__mode='k'})
local GREEN=Color3.fromRGB(14,62,26);local CREAM=Color3.fromRGB(226,203,140);local NEON=Color3.fromRGB(170,255,40);local FANG=Color3.fromRGB(128,226,18)
local STYLE={
 V_HelmetShell={GREEN,Enum.Material.SmoothPlastic,.06,0},
 V_HelmetInner={CREAM,Enum.Material.SmoothPlastic,0,0},
 V_HelmetCrest={CREAM,Enum.Material.SmoothPlastic,.08,0},
 V_HelmetBrow={GREEN,Enum.Material.SmoothPlastic,.08,0},
 V_VenomVeins={NEON,Enum.Material.Neon,0,0},
 V_Fangs={FANG,Enum.Material.Glass,.15,.22},
 V_FangsCore={NEON,Enum.Material.Neon,0,0},
 V_VenomDrops={NEON,Enum.Material.Neon,0,0},
}
M.Parts={'V_HelmetShell','V_HelmetInner','V_HelmetCrest','V_HelmetBrow','V_VenomVeins','V_Fangs','V_FangsCore','V_VenomDrops'}
M.Markers={'V_FitOrigin','V_FitUp','V_FitFront'}
local function part(model,name)local p=model:FindFirstChild(name,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(model)
 local accessory=model:FindFirstChild('VeniAccessories');if accessory then accessory:Destroy()end
 local map=saved[model]
 if map then for p,s in pairs(map)do if p.Parent then
  p.Color=s.color;p.Material=s.material;p.Reflectance=s.reflectance;p.Transparency=s.alpha
  if p:IsA('MeshPart')then p.TextureID=s.texture end
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then c:Destroy()end end
  for _,c in ipairs(s.surfaces)do c:Clone().Parent=p end
 end end end;saved[model]=nil
end
function M.Apply(model,assets)
 M.Restore(model);assets=assets or RS:FindFirstChild('CraxVeniImportedAssets')
 local head=assert(part(model,'Head'),'Head natif absent');local left=assert(part(model,'EyeLeft'));local right=assert(part(model,'EyeRight'))
 local origin=assert(assets:FindFirstChild('V_FitOrigin',true));local front=assert(assets:FindFirstChild('V_FitFront',true));local up=assert(assets:FindFirstChild('V_FitUp',true))
 local sourceForward=(front.Position-origin.Position).Unit;local sourceUp=(up.Position-origin.Position).Unit
 local sourceRight=sourceForward:Cross(sourceUp).Unit;sourceUp=sourceRight:Cross(sourceForward).Unit
 local sourceCF=CFrame.fromMatrix(origin.Position,sourceRight,sourceUp,-sourceForward)
 local forward=((left.Position+right.Position)*.5-head.Position);forward=(forward-head.CFrame.UpVector*forward:Dot(head.CFrame.UpVector)).Unit
 local targetRight=forward:Cross(head.CFrame.UpVector).Unit
 local targetCF=CFrame.fromMatrix(head.Position,targetRight,head.CFrame.UpVector,-forward)
 local scale=(head.Size.Y*.5)/(up.Position-origin.Position).Magnitude
 local oldPivot=model:GetPivot();local snapshots={};saved[model]=snapshots
 -- Tête native : vinyle blanc, sourire crème, gencives rouges, yeux fermés noirs ; la croix du dos est sous le casque.
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then
  local s={color=p.Color,material=p.Material,reflectance=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then s.surfaces[#s.surfaces+1]=c:Clone();c:Destroy()end end;snapshots[p]=s
  local n=p.Name:lower()
  p.Color=n:find('tooth',1,true)and Color3.fromRGB(243,226,190)or(n:find('gums',1,true)and Color3.fromRGB(206,36,48)or((n=='eyeleft'or n=='eyeright'or n:find('inner',1,true))and Color3.fromRGB(8,9,12)or Color3.fromRGB(236,238,230)))
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  if p:IsA('MeshPart')then p.TextureID=''end
  if n:find('cross',1,true)then p.Transparency=1 elseif n:find('tooth',1,true)or n:find('gums',1,true)or n=='eyeleft'or n=='eyeright'or n:find('shell',1,true)then p.Transparency=0 end
  if n=='head'then p.Transparency=1 end
 end end
 local accessory=Instance.new('Model');accessory.Name='VeniAccessories'
 for _,source in ipairs(assets:GetDescendants())do
  local style=source:IsA('BasePart')and STYLE[source.Name]
  if style then
   local p=source:Clone();local rel=sourceCF:ToObjectSpace(source.CFrame)
   p.Size=source.Size*scale;p.CFrame=targetCF*(rel.Rotation+rel.Position*scale)
   p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true;p.CastShadow=style[2]~=Enum.Material.Neon
   p.Color=style[1];p.Material=style[2];p.Reflectance=style[3];p.Transparency=style[4]
   for _,c in ipairs(p:GetDescendants())do if c:IsA('LuaSourceContainer')or c:IsA('Sound')then c:Destroy()end end
   if p:IsA('MeshPart')then p.TextureID=''end
   -- Écailles de cobra : le SurfaceAppearance est posé dans Studio sur la pièce importée (ColorMap non modifiable en jeu).
   if p:FindFirstChildWhichIsA('SurfaceAppearance')then p.Color=Color3.new(1,1,1)end
   p.Parent=accessory
  end
 end
 accessory.Parent=model
 if not model.PrimaryPart then model.WorldPivot=oldPivot end
end
return M
