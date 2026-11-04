-- STOP. Lecture seule. Export des points d'intégration et des sources BlackSpida réellement présentes.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local SES=game:GetService('ScriptEditorService');local HTTP=game:GetService('HttpService');local found={};local scripts={}
local known={CraxCatalog=true,CraxSkillCatalog=true,CraxVictoryCatalog=true,CraxRouletteConfig=true,CombatHealth=true,ArenaMovement=true,CraxAbilityGate=true,CraxSilenceGate=true,CraxDeadlyRuntime=true,CraxSuperRuntime=true,CraxSymRuntime=true,CraxInvertedRuntime=true}
for _,service in ipairs({'ReplicatedStorage','ServerScriptService','StarterPlayer'})do
 for _,o in ipairs(game:GetService(service):GetDescendants())do if o:IsA('LuaSourceContainer')then
  local ok,source=pcall(function()return SES:GetEditorSource(o)end);local name=o.Name:lower();local matching=name:find('black',1,true)or name:find('spida',1,true)
  if ok and(known[o.Name]or matching or source:lower():find('blackspida',1,true))then scripts[#scripts+1]={path=o:GetFullName(),class=o.ClassName,source=source};if matching then found[#found+1]=o:GetFullName()end end
 end end
end
table.sort(scripts,function(a,b)return a.path<b.path end);local text=HTTP:JSONEncode({format='LuckyCrax-current-editor-1',blackSpidaCandidates=found,scripts=scripts});local size=12000;local count=math.ceil(#text/size)
print('LUCKY_DIAGNOSTIC_BEGIN '..count..' blocs ; aucune modification de la place')
for i=1,count do print('LUCKY_SOURCE_'..i..'/'..count..' '..text:sub((i-1)*size+1,i*size))end
print('LUCKY_DIAGNOSTIC_END ; candidats BlackSpida='..#found..', scripts='..#scripts)
end
