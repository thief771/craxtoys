-- Apply only to a cloned template or the existing live rig. Preserve all node/pivot names.
local P={};local snapshots=setmetatable({},{__mode='k'})
function P.Restore(model)
 local saved=snapshots[model];if not saved then return end
 for part,s in pairs(saved)do if part.Parent then
  part.Color=s.color;part.Material=s.material;part.Reflectance=s.reflectance
  if part:IsA('MeshPart')then part.TextureID=s.texture end
  for _,child in ipairs(part:GetChildren())do if child:IsA('SurfaceAppearance')then child:Destroy()end end
  for _,appearance in ipairs(s.appearances)do appearance:Clone().Parent=part end
 end end
 snapshots[model]=nil
end
function P.Apply(model)
 P.Restore(model);local saved={};snapshots[model]=saved
 for _,part in ipairs(model:GetDescendants())do if part:IsA('BasePart')then
  local s={color=part.Color,material=part.Material,reflectance=part.Reflectance,texture=part:IsA('MeshPart')and part.TextureID or '',appearances={}}
  for _,child in ipairs(part:GetChildren())do if child:IsA('SurfaceAppearance')then s.appearances[#s.appearances+1]=child:Clone();child:Destroy()end end
  saved[part]=s
  local n=part.Name:lower();local ivory=n=='eyeleft'or n=='eyeright'or n:find('gums',1,true)or n:find('cross',1,true)
  part.Color=ivory and Color3.fromRGB(242,239,226)or Color3.fromRGB(9,11,14)
  part.Material=Enum.Material.SmoothPlastic;part.Reflectance=.035
  if part:IsA('MeshPart')then part.TextureID=''end
 end end
end
return P
