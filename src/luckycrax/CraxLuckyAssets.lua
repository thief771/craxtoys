-- Authored meshes are assembled at local coordinates exported from Blender.
local RS=game:GetService('ReplicatedStorage');local M={}
function M.Model(kind,parent)
 local source=assert(RS:FindFirstChild('CraxLuckyImportedAssets'),'Importer LuckyCrax_FX_IMPORT.fbx')
 local zero=assert(source:FindFirstChild('LFX_Origin',true));local up=assert(source:FindFirstChild('LFX_Up',true));local front=assert(source:FindFirstChild('LFX_Front',true));local f=(front.Position-zero.Position).Unit;local u=(up.Position-zero.Position).Unit;local basis=CFrame.fromMatrix(zero.Position,f:Cross(u).Unit,u,-f);local scale=1/(up.Position-zero.Position).Magnitude
 local o=Instance.new('Model');o.Name='Lucky'..kind
 for _,p in ipairs(source:GetDescendants())do if p:IsA('MeshPart')then
  local name=p.Name;local include=kind=='Coin'and(name=='LFX_CoinBody'or name=='LFX_CoinDetail')or kind=='Dice'and(name=='LFX_Die'or name:match('^LFX_Digit_'))or kind=='Clover'and(name:match('^LFX_Clover')or name:match('^LFX_Leaf'))or kind=='Reels'and name:match('^LFX_Reel')or kind=='Chest'and name:match('^LFX_Chest')or kind=='Lid'and name=='LFX_Lid'
  if include then local c=p:Clone();local rel=basis:ToObjectSpace(p.CFrame);c.Size=p.Size*scale;c.CFrame=rel.Rotation+rel.Position*scale;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.CastShadow=false
   local n=c.Name;local gold=n:find('Coin',1,true)or n:find('Clover',1,true)or n:find('Leaf',1,true)or n=='LFX_ReelCase';c.Material=gold and Enum.Material.Metal or Enum.Material.SmoothPlastic;c.Reflectance=gold and .16 or .02;c.Color=(n=='LFX_CoinDetail'or n:find('LeafVein',1,true))and Color3.fromRGB(111,72,18)or(gold and Color3.fromRGB(232,170,43)or(n=='LFX_Die'and Color3.fromRGB(241,234,209)or Color3.fromRGB(151,27,45)));c.Parent=o end
 end end
 o.Parent=parent;o.WorldPivot=CFrame.identity;return o
end
return M
