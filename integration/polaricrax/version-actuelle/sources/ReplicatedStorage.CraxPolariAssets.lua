-- Authored meshes are assembled at local coordinates exported from Blender.
local RS=game:GetService('ReplicatedStorage');local M={}
function M.Model(kind,parent)
 local source=assert(RS:FindFirstChild('CraxPolariImportedAssets'),'Importer PolariCrax_ACCESSOIRES_IMPORT.fbx')
 local zero=assert(source:FindFirstChild('PFX_Origin',true));local up=assert(source:FindFirstChild('PFX_Up',true));local front=assert(source:FindFirstChild('PFX_Front',true));local f=(front.Position-zero.Position).Unit;local u=(up.Position-zero.Position).Unit;local basis=CFrame.fromMatrix(zero.Position,f:Cross(u).Unit,u,-f);local scale=1/(up.Position-zero.Position).Magnitude
 local o=Instance.new('Model');o.Name='Polari'..kind
 for _,p in ipairs(source:GetDescendants())do if p:IsA('MeshPart')then
  local name=p.Name;local include=kind=='Shard'and name=='PFX_Shard'or kind=='Dial'and name:match('^PFX_Dial')or kind=='Trophy'and(name:match('^PFX_Dial')or name=='PFX_TrophyBase')
  if include then local c=p:Clone();local rel=basis:ToObjectSpace(p.CFrame);c.Size=p.Size*scale;c.CFrame=rel.Rotation+rel.Position*scale;c.Anchored=true;c.CanCollide=false;c.CanTouch=false;c.CanQuery=false;c.CastShadow=false
   local n=c.Name;local gold=n:find('Dial',1,true)or n=='PFX_TrophyBase';c.Material=Enum.Material.Metal;c.Reflectance=.18;c.Color=gold and Color3.fromRGB(241,192,67)or Color3.fromRGB(154,154,179);c.Parent=o end
 end end
 o.Parent=parent;o.WorldPivot=CFrame.identity;return o
end
return M
