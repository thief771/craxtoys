local M={};local saved=setmetatable({},{__mode='k'})
function M.Restore(m)
 local map=saved[m];if map then for p,v in pairs(map)do if p.Parent then p.Color=v.color;p.Material=v.material;p.Reflectance=v.reflect;p.Transparency=v.alpha;if p:IsA('MeshPart')then p.TextureID=v.texture end;for _,s in ipairs(v.surfaces)do s:Clone().Parent=p end end end end;saved[m]=nil
 local h=m:FindFirstChild('Head',true);local a=h and h:FindFirstChild('LuckyMouth');if a and a:GetAttribute('LuckyOwned')then a:Destroy()end
end
function M.Apply(m)
 M.Restore(m);local map={};saved[m]=map
 for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then
  local v={color=p.Color,material=p.Material,reflect=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}};map[p]=v
  for _,s in ipairs(p:GetChildren())do if s:IsA('SurfaceAppearance')then v.surfaces[#v.surfaces+1]=s:Clone();s:Destroy()end end
  local n=p.Name:lower();if n:find('tooth',1,true)then p.Color=Color3.fromRGB(232,170,43);p.Material=Enum.Material.Metal;p.Reflectance=.18;p.Transparency=0
  elseif n:find('gums',1,true)then p.Color=Color3.fromRGB(207,122,131);p.Transparency=0;p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.015
  elseif n=='eyeleft'or n=='eyeright'then p.Color=Color3.fromRGB(12,15,19);p.Transparency=0
  elseif n:find('shell',1,true)then p.Color=Color3.fromRGB(242,240,229);p.Transparency=0;p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.025 end
  if p:IsA('MeshPart')then p.TextureID=''end
 end end
 local h=assert(m:FindFirstChild('Head',true));local upper=assert(m:FindFirstChild('UpperGums',true));local lower=assert(m:FindFirstChild('LowerGums',true));h.Transparency=1
 local a=Instance.new('Attachment');a.Name='LuckyMouth';a:SetAttribute('LuckyOwned',true);a.CFrame=h.CFrame:ToObjectSpace(CFrame.new((upper.Position+lower.Position)*.5));a.Parent=h
end
return M
