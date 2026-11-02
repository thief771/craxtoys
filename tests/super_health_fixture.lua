UDim2={fromOffset=function()return {}end,fromScale=function()return {}end}
local color={Lerp=function(self)return self end};Color3={fromRGB=function()return color end,new=function()return color end}
Enum.Font={GothamBold=1};Instance={new=function()return{FindFirstChild=function()return nil end,Destroy=function()end}end}
local function event()local s=signal();return{Event=s,Fire=function(_,...)s:Fire(...)end}end
local heals=event();sss.CraxHeal=heals;sss.FantasticDamageConfirmed=event();sss.CraxSpideyDamageConfirmed=event()
modules.golden={Outgoing=function(_,v)return v end};modules.plumber={ContactDamage=function(m)return m:GetAttribute('CollisionDamage')or 8 end}
modules.fleau={FlatProtect=function(_,v)return v end,AfterDamage=function()end,BeforeDeath=function()end,Contact=function(_,v)return v end,CommitContact=function()end,HealAllowed=function()return true end}
modules.bridge={CaptureFromHealth=function()end};modules.night={TryEscape=function()return false end};modules.mod={Apply=function(_,v)return v end}
modules.deadly.Flash=function()return false end;modules.deadly.AdjustDamage=function(_,v)return v end;modules.deadly.IsAlly=function()return false end;modules.deadly.OnDeath=function()end
modules.inverted={RawInput=function(_,_,v)return v end,Final=function(_,v)return math.floor(v+.5)end,Vulnerable=function(_,v)return v end,Melee=function(_,v)return v end,Confirm=function()end}
sss.CraxGoldenRuntime='golden';sss.CraxPlumberRuntime='plumber';sss.FleauRuntime='fleau';sss.FleauFinaleBridge='bridge';sss.GhostyNight='night';sss.CraxDamageModifiers='mod';sss.CraxGoldenFinaleBridge='bridge';sss.CraxInvertedRuntime='inverted';sss.CraxSuperRuntime='super';modules.super=M
