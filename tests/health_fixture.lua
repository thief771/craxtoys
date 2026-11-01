UDim2={fromOffset=function()return {}end,fromScale=function()return {}end}
function sss:FindFirstChild(name)return self[name]end
-- Execute the actual CombatHealth handler with the actual Inverted runtime.
local function signal()
 local callbacks={};return {Connect=function(_,fn)callbacks[#callbacks+1]=fn;return {Disconnect=function()end}end,Fire=function(_,...)for _,fn in ipairs(callbacks)do fn(...)end end}
end
local function event()local s=signal();return {Event=s,Fire=function(_,...)s:Fire(...)end}end
local signals={};function state:GetAttributeChangedSignal(k)signals[k]=signals[k]or signal();return signals[k]end
local oldSet=state.SetAttribute;function state:SetAttribute(k,v)local before=self:GetAttribute(k);oldSet(self,k,v);if v~=before and signals[k]then signals[k]:Fire()end end
Color3={};local color={Lerp=function(self,other,t)return self end};function Color3.fromRGB()return color end;Color3.new=Color3.fromRGB
Enum={Font={GothamBold='GothamBold'}}
Instance={new=function(class)return {ClassName=class,FindFirstChild=function()return nil end,Destroy=function()end}end}
for _,m in ipairs({a,b})do
 local h={Parent=m,Size=Vector3.new(8,8,8),IsA=function(_,c)return c=='BasePart'end,FindFirstChild=function()return nil end}
 function m:FindFirstChild(name)if name=='Head'then return h end end
 m:SetAttribute('MaxHealth',m==a and 120 or 100);m:SetAttribute('Health',m==a and 120 or 100);m:SetAttribute('CollisionDamage',m==a and 8 or 10)
end
local oldWait=workspace.WaitForChild;function workspace:WaitForChild(n)if n=='Fighter1'then return a elseif n=='Fighter2'then return b else return oldWait(self,n)end end
local hits=event();local heals=event();sss.BiteHit=hits;sss.CraxHeal=heals;sss.FantasticDamageConfirmed=event();sss.CraxSpideyDamageConfirmed=event()
local outgoing=1
modules.golden={Outgoing=function(_,v)return v*outgoing end}
modules.plumber={ContactDamage=function(m)return m:GetAttribute('CollisionDamage')end}
modules.fleau={FlatProtect=function(_,v)return v end,AfterDamage=function()end,BeforeDeath=function()end,Contact=function(_,v)return v end,CommitContact=function()end,HealAllowed=function()return true end}
modules.bridge={CaptureFromHealth=function()end}
modules.night={TryEscape=function()return false end}
modules.mod={Apply=function(m,v)return m:GetAttribute('FantasticReinforced')and v*.5 or v end}
modules.deadly.Flash=function()return false end;modules.deadly.AdjustDamage=function(_,v)return v end;modules.deadly.IsAlly=function()return false end;modules.deadly.OnDeath=function()end
sss.CraxGoldenRuntime='golden';sss.CraxPlumberRuntime='plumber';sss.FleauRuntime='fleau';sss.FleauFinaleBridge='bridge';sss.GhostyNight='night';sss.CraxDamageModifiers='mod';sss.CraxGoldenFinaleBridge='bridge';sss.CraxInvertedRuntime='inverted'
modules.inverted=Runtime
