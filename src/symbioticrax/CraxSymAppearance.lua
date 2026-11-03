local M={};local snapshots=setmetatable({},{__mode='k'})
local function part(m,n)local p=m:FindFirstChild(n,true);return p and(p:IsA('BasePart')and p or p:FindFirstChildWhichIsA('BasePart',true))end
function M.Restore(m)
 local s=snapshots[m];if s then for p,v in pairs(s)do if p.Parent then p.Color=v.color;p.Material=v.material;p.Reflectance=v.reflect;p.Transparency=v.alpha;if p:IsA('MeshPart')then p.TextureID=v.texture end;for _,a in ipairs(v.surfaces)do a:Clone().Parent=p end end end end
 snapshots[m]=nil;m:SetAttribute('SymPreview',nil);local old=m:FindFirstChild('SymAccessories');if old then old:Destroy()end
 local h=part(m,'Head');local a=h and h:FindFirstChild('SymMouth');if a and a:GetAttribute('SymOwned')then a:Destroy()end
end
function M.Apply(m,assets)
 M.Restore(m);local h=assert(part(m,'Head'));local left=assert(part(m,'EyeLeft'));local right=assert(part(m,'EyeRight'));local oldPivot=m:GetPivot()
 local center=assets:FindFirstChild('FIT_HeadCenter',true);local front=assets:FindFirstChild('FIT_Front',true);local up=assets:FindFirstChild('FIT_Up',true)
 local sf=(front.Position-center.Position).Unit;local su=(up.Position-center.Position).Unit;local sr=sf:Cross(su).Unit
 local src=CFrame.fromMatrix(center.Position,sr,sr:Cross(sf).Unit,-sf)
 local f=(left.Position+right.Position)*.5-h.Position;f=(f-h.CFrame.UpVector*f:Dot(h.CFrame.UpVector)).Unit
 local dst=CFrame.fromMatrix(h.Position,f:Cross(h.CFrame.UpVector).Unit,h.CFrame.UpVector,-f);local scale=(h.Size.Y*.5)/(up.Position-center.Position).Magnitude
 local function fit(cf)local r=src:ToObjectSpace(cf);return dst*(r.Rotation+r.Position*scale)end
 local hidden={};for _,p in ipairs(assets:GetDescendants())do if p.Name:match('^SymFang_')then local row,index=p.Name:match('^SymFang_Tooth([01])([0-7])1$');assert(row and index,'Correspondance dent native inconnue');hidden['tooth_'..row..'_'..index]=true end end
 local s={};snapshots[m]=s
 for _,p in ipairs(m:GetDescendants())do if p:IsA('BasePart')then
  s[p]={color=p.Color,material=p.Material,reflect=p.Reflectance,alpha=p.Transparency,texture=p:IsA('MeshPart')and p.TextureID or'',surfaces={}}
  for _,a in ipairs(p:GetChildren())do if a:IsA('SurfaceAppearance')then s[p].surfaces[#s[p].surfaces+1]=a:Clone();a:Destroy()end end
  local n=p.Name:lower();p.Color=n:find('tooth',1,true)and Color3.fromRGB(239,240,226)or(n:find('gums',1,true)and Color3.fromRGB(187,89,110)or Color3.fromRGB(8,11,17));p.Material=Enum.Material.SmoothPlastic;p.Reflectance=.04
  if p:IsA('MeshPart')then p.TextureID=''end
  if hidden[n]or n=='eyeleft'or n=='eyeright'then p.Transparency=1 end
  if n:find('cross',1,true)then p.Color=s[p].color end
 end end
 local model=Instance.new('Model');model.Name='SymAccessories'
 for _,p in ipairs(assets:GetDescendants())do if p:IsA('MeshPart')and p.Name:match('^Sym')then
  local c=p:Clone();c.Size=p.Size*scale;c.CFrame=fit(p.CFrame);c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.Massless=true;c.Material=Enum.Material.SmoothPlastic;c.Reflectance=.14;c.TextureID=''
  local n=c.Name;local row,index=n:match('^SymFang_Tooth([01])([0-7])1$');if row then c:SetAttribute('SymJawRow',row=='1'and'Lower'or'Upper')end;c.Color=(n:find('Eye',1,true)or n:find('White',1,true)or n:find('Fang',1,true))and Color3.fromRGB(239,240,226)or(n:find('Tongue',1,true)and Color3.fromRGB(196,54,79)or Color3.fromRGB(8,11,17))
  if n:find('Groove',1,true)then c.Color=Color3.fromRGB(112,22,46)end
  if n:find('Fang',1,true)or n:find('White',1,true)or n:find('Eye',1,true)then c.Reflectance=.035 end
  for _,d in ipairs(c:GetDescendants())do if d:IsA('LuaSourceContainer')or d:IsA('SurfaceAppearance')or d:IsA('Sound')then d:Destroy()end end
  local index=n:match('^SymTentacle_(%d+)$');if index then local root=assets:FindFirstChild('SYM_Root_'..index,true);assert(root,'Repère tentacule absent');c:SetAttribute('SymRootLocal',h.CFrame:ToObjectSpace(fit(root.CFrame)))end
  c.Parent=model
 end end
 model.Parent=m;m:SetAttribute('SymPreview',true);local point=assert(assets:FindFirstChild('SYM_Mouth',true));local a=Instance.new('Attachment');a.Name='SymMouth';a.CFrame=h.CFrame:ToObjectSpace(fit(point.CFrame));a:SetAttribute('SymOwned',true);a.Parent=h
 if not m.PrimaryPart then m.WorldPivot=oldPivot end
end
return M
