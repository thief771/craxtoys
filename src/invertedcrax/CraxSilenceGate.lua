-- Check only at NEW activation sites, never in simulation/damage continuation.
local G={}
function G.CanStart(model)
 return model~=nil and model.Parent~=nil and model:GetAttribute('InvertedSilenced')~=true
end
return G
