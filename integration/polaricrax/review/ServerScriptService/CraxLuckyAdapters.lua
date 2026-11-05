-- PolariCraxIntegrationV1
-- Inspected families only. Unknown families are refused and diagnosed, never silently treated as compatible.
local SS=game:GetService('ServerScriptService');local M={};local installed=false
function M.Install()
 if installed then return end;installed=true
 local S=require(SS.CraxLuckySuppression)
 for id,name in pairs({Crax_Super='CraxSuperRuntime',Crax_Inverted='CraxInvertedRuntime',Crax_Symbioti='CraxSymRuntime',Crax_Deadly='CraxDeadlyRuntime'})do local runtime=require(SS:WaitForChild(name));assert(runtime.CancelLucky,'Annulation manquante : '..name);S.Register(id,function(m)runtime.CancelLucky(m)end,id~="Crax_Deadly")end
 for id,name in pairs({Crax_Fantastic='FantasticRuntime',Crax_Golden='CraxGoldenRuntime',Crax_Plumber='CraxPlumberRuntime',Crax_Fleau='FleauRuntime'})do local runtime=require(SS:WaitForChild(name));S.Register(id,function()runtime.Reset()end,false)end
 local night=require(SS.GhostyNight);S.Register('Crax_Ghosty',function(m,f)night.CancelLucky(m,f)end,false)
 -- Native Bite and Spidey cancellation is completed by their patched simulation sites.
 S.Register('Crax_Polari',function(m)require(SS.CraxPolariRuntime).Cancel(m)end)
 S.Register('Crax_Monster',function()end)
 S.Register('Crax_Spidey',function()require(SS.CraxSpideyRuntime).Clear();require(SS.CraxLuckyRuntime).ClearWebs=true end,false)
end
function M.Report(catalog)
 local S=require(SS.CraxLuckySuppression);local missing={};for id in pairs(catalog)do if not S.Supported(id)then missing[#missing+1]=id end end;table.sort(missing);return missing
end
return M
