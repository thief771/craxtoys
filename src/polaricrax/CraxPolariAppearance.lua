local M={};local saved=setmetatable({},{__mode='k'})
local function part(model,name)local p=model:FindFirstChild(name,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(model)
 local accessory=model:FindFirstChild('PolariAccessories');if accessory then accessory:Destroy()end
 for _,name in ipairs({'EyeLeft','EyeRight'})do local eye=part(model,name);local origin=eye and eye:FindFirstChild('PolariLaserOriginV1');if origin and origin:GetAttribute('PolariOwned')then origin:Destroy()end end
 local map=saved[model]
 if map then for p,s in pairs(map)do if p.Parent then
  p.Color=s.color;p.Material=s.material;p.Reflectance=s.reflectance;p.Transparency=s.alpha
  if p:IsA('MeshPart')then p.TextureID=s.texture end
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then c:Destroy()end end
  for _,c in ipairs(s.surfaces)do c:Clone().Parent=p end
 end end end;saved[model]=nil
end
function M.Apply(model,assets)
 M.Restore(model);local head=assert(part(model,'Head'),'Head natif absent');local left=assert(part(model,'EyeLeft'));local right=assert(part(model,'EyeRight'))
 local origin=assert(assets:FindFirstChild('P_FitOrigin',true));local front=assert(assets:FindFirstChild('P_FitFront',true));local up=assert(assets:FindFirstChild('P_FitUp',true))
 local sourceForward=(front.Position-origin.Position).Unit;local sourceUp=(up.Position-origin.Position).Unit
 local sourceRight=sourceForward:Cross(sourceUp).Unit;sourceUp=sourceRight:Cross(sourceForward).Unit
 local sourceCF=CFrame.fromMatrix(origin.Position,sourceRight,sourceUp,-sourceForward)
 local forward=((left.Position+right.Position)*.5-head.Position);forward=(forward-head.CFrame.UpVector*forward:Dot(head.CFrame.UpVector)).Unit
 local targetRight=forward:Cross(head.CFrame.UpVector).Unit
 local targetCF=CFrame.fromMatrix(head.Position,targetRight,head.CFrame.UpVector,-forward)
 local scale=(head.Size.Y*.5)/(up.Position-origin.Position).Magnitude
 local oldPivot=model:GetPivot();local snapshots={};saved[model]=snapshots
 for _,p in ipairs(model:GetDescendants())do if p:IsA('BasePart')then
  local s={color=p.Color,material=p.Material,reflectance=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,c in ipairs(p:GetChildren())do if c:IsA('SurfaceAppearance')then s.surfaces[#s.surfaces+1]=c:Clone();c:Destroy()end end;snapshots[p]=s
  local n=p.Name:lower()
  p.Color=n:find('tooth',1,true)and Color3.fromRGB(246,245,232)or(n:find('gums',1,true)and Color3.fromRGB(216,126,113)or((n=='eyeleft'or n=='eyeright'or n:find('inner',1,true))and Color3.fromRGB(12,17,21)or Color3.fromRGB(235,238,227)))
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  if p:IsA('MeshPart')then p.TextureID=''end
  if n:find('cross',1,true)then p.Transparency=1 elseif n:find('tooth',1,true)or n:find('gums',1,true)or n=='eyeleft'or n=='eyeright'or n:find('shell',1,true)then p.Transparency=0 end
  if n=='eyeleft'or n=='eyeright'then p.Color=Color3.fromRGB(7,8,11)end
  if n=='head'then p.Transparency=1 end
 end end
 local accessory=Instance.new('Model');accessory.Name='PolariAccessories'
 for _,source in ipairs(assets:GetDescendants())do if source:IsA('BasePart')and source.Name:match('^P_')and not source.Name:match('^P_Fit')then
  local p=source:Clone();local rel=sourceCF:ToObjectSpace(source.CFrame)
  p.Size=source.Size*scale;p.CFrame=targetCF*(rel.Rotation+rel.Position*scale)
  p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true
  p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025
  local name=p.Name
  if name:find('Purple',1,true)or name:find('Cheek',1,true)then p.Color=Color3.fromRGB(132,38,178)elseif name:find('Burgundy',1,true)then p.Color=Color3.fromRGB(100,14,40)else p.Color=Color3.fromRGB(216,16,42)end;p.Reflectance=.10
  if p:IsA('MeshPart')then p.TextureID=''end
  for _,c in ipairs(p:GetDescendants())do if c:IsA('LuaSourceContainer')or c:IsA('Sound')or c:IsA('SurfaceAppearance')then c:Destroy()end end
  p.Parent=accessory
 end end
 accessory.Parent=model
 if not model.PrimaryPart then model.WorldPivot=oldPivot end
end
return M
