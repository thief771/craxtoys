-- SuperCraxIntegrationV1
-- Verrou serveur : immobilise la position logique et le pivot physique du lanceur.
local M={};local records={};local state=workspace:WaitForChild('CombatState')
function M.Lock(f,reason)
 reason=reason or 'Fantastic'
 if records[f.model]then records[f.model].reasons[reason]=true;return end
 local r={position=f.position,depth=f.depth,velocity=f.velocity,rotation=f.rotation,pivot=f.model:GetPivot(),restoring=false,reasons={[reason]=true}}
 records[f.model]=r
 f.model:SetAttribute('FantasticAnchorPosition',Vector3.new(f.position.X,f.position.Y,f.depth))
 f.velocity=Vector2.zero;f.knockback=nil
 r.connection=f.head:GetPropertyChangedSignal('CFrame'):Connect(function()
  if records[f.model]~=r or r.restoring or not f.model.Parent or state:GetAttribute('GhostNightActive')then return end
  if f.model:GetPivot()~=r.pivot then r.restoring=true;f.model:PivotTo(r.pivot);r.restoring=false end
 end)
end
function M.Enforce(f)
 local r=records[f.model];if not r then return end
 if state:GetAttribute('GhostNightActive')then
  if not r.night then r.night=true;f.velocity=r.velocity end
  r.position=f.position;r.pivot=f.model:GetPivot();return
 elseif r.night then r.night=false;r.position=f.position;r.pivot=f.model:GetPivot()end
 f.position=r.position;f.depth=r.depth;f.rotation=r.rotation;f.velocity=Vector2.zero;f.knockback=nil
 f.capturedBy=nil;f.sting=nil;f.pendingSting=nil
 f.model:SetAttribute('WebImmobilized',false)
 if f.model.Parent and f.model:GetPivot()~=r.pivot then
  r.restoring=true;f.model:PivotTo(r.pivot);r.restoring=false
 end
end
function M.Unlock(f,reason)
 local r=records[f.model];if not r then return end
 r.reasons[reason or 'Fantastic']=nil;if next(r.reasons)then return end
 M.Enforce(f);records[f.model]=nil
 if r.connection then r.connection:Disconnect()end
 f.velocity=r.velocity
 if f.model.Parent then f.model:SetAttribute('FantasticAnchorPosition',nil)end
end
return M

