-- Full accessory framing for this character only, preserving each viewer's camera orbit.
local Run=game:GetService('RunService');local R=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSymRules'))
local M={};local records={};local bound=false;local accumulator=0
local function clear(view)
 local r=records[view];if r then for _,c in ipairs(r.connections)do c:Disconnect()end;records[view]=nil end
 if not next(records)and bound then Run:UnbindFromRenderStep('SymbiotiCraxPreviewFit');bound=false end
end
local function visible(view)
 local p=view
 while p do if(p:IsA('GuiObject')and not p.Visible)or(p:IsA('ScreenGui')and not p.Enabled)then return false end;p=p.Parent end
 return view.AbsoluteSize.X>0 and view.AbsoluteSize.Y>0
end
local function fit(view,model)
 local cam=view.CurrentCamera;if not cam then return end
 local cf,size=model:GetBoundingBox();local basis=cam.CFrame
 local function extent(axis)return math.abs(cf.RightVector:Dot(axis))*size.X+math.abs(cf.UpVector:Dot(axis))*size.Y+math.abs(cf.LookVector:Dot(axis))*size.Z end
 local width,height,depth=extent(basis.RightVector),extent(basis.UpVector),extent(basis.LookVector)
 local aspect=view.AbsoluteSize.X/math.max(1,view.AbsoluteSize.Y);local d=R.FitDistance(width,height,depth,aspect,cam.FieldOfView)
 cam.CFrame=CFrame.lookAt(cf.Position-basis.LookVector*d,cf.Position,basis.UpVector);cam.Focus=CFrame.new(cf.Position)
end
function M.Bind(view,model)
 if records[view]and records[view].model==model then fit(view,model);return end
 clear(view);local r={model=model,connections={}};records[view]=r
 r.connections[1]=view.Destroying:Connect(function()clear(view)end)
 r.connections[2]=model.Destroying:Connect(function()clear(view)end)
 fit(view,model)
 if not bound then bound=true;Run:BindToRenderStep('SymbiotiCraxPreviewFit',Enum.RenderPriority.Last.Value+250,function(dt)
  accumulator+=dt;if accumulator<1/20 then return end;accumulator=0
  for surface,entry in pairs(records)do if not surface.Parent or not entry.model.Parent then clear(surface)elseif visible(surface)then fit(surface,entry.model)end end
 end)end
end
return M
