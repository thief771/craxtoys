-- LuckyCraxIntegrationV1
-- CraxEnemyPause_v7
local AbilityGate=require(game:GetService("ServerScriptService"):WaitForChild("CraxAbilityGate"))
-- CraxSpideySkills_v1 : état de combat exclusivement serveur.
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local state=workspace:WaitForChild("CombatState")
local hits=SSS:WaitForChild("BiteHit")
local fx=RS:WaitForChild("CraxCombatFX")
local random=Random.new()
local confirmed=SSS:FindFirstChild("CraxSpideyDamageConfirmed")
if not confirmed then confirmed=Instance.new("BindableEvent");confirmed.Name="CraxSpideyDamageConfirmed";confirmed.Parent=SSS end
assert(confirmed:IsA("BindableEvent"))
local old=workspace:FindFirstChild("SpideySilkTraps");if old then old:Destroy()end
local folder=Instance.new("Folder");folder.Name="SpideySilkTraps";folder.Parent=workspace
local R={};local traps,poisons,timers,previous={},{},{},{};local serial=0;local lastStep=nil
local function head(model)local p=model and model:FindFirstChild("Head",true);if p and not p:IsA("BasePart")then p=p:FindFirstChildWhichIsA("BasePart",true)end;return p end
local function alive(model)return model and model.Parent and(model:GetAttribute("Health")or 0)>0 end
local function active()return state:GetAttribute("Phase")=="Fighting"end
function R.Clear()
 for model in pairs(poisons)do if model.Parent then model:SetAttribute("SpideyPoisonUntil",nil)end end
 for _,trap in ipairs(traps)do if trap.part.Parent then trap.part:Destroy()end end
 for model in pairs(previous)do if model.Parent then model:SetAttribute("SilkSlowUntil",nil);model:SetAttribute("SpideyPoisonUntil",nil)end end
 traps={};poisons={};timers={};previous={};lastStep=nil
end
function R.Volley(model)
 return(model:GetAttribute("CraxSkillLevel")or 0)>=1 and random:NextNumber()<.5 and 2 or 1
end
function R.Poisoned(model)return poisons[model]~=nil or workspace:GetServerTimeNow()<(model:GetAttribute("SpideyPoisonUntil")or 0)end
function R.Slow(model)
 return workspace:GetServerTimeNow()<(model:GetAttribute("SilkSlowUntil")or 0)and .6 or 1
end
confirmed.Event:Connect(function(attacker,defender,lost,kind,round)
 if round and round~=state:GetAttribute("RoundId")then return end
 if kind=="SpideyPoison"and lost>0 then local h=head(defender);if h then fx:FireAllClients("SpideyPoisonTick",h.Position,lost,defender)end;return end
 if not active()or kind~="SpideyInject"or lost<=0 or not alive(attacker)or not alive(defender)
  or attacker:GetAttribute("AbilityId")~="SpideyWeb"or(attacker:GetAttribute("CraxSkillLevel")or 0)<3 then return end
 -- Une nouvelle critique ne renouvelle ni n'empile un venin actif.
 if poisons[defender]then return end
 local now=workspace:GetServerTimeNow()
 serial+=1;poisons[defender]={attacker=attacker,round=state:GetAttribute("RoundId"),next=now+1,remaining=4,luckyAttackId=serial}
 defender:SetAttribute("SpideyPoisonUntil",now+4)
 local h=head(defender);if h then fx:FireAllClients("SpideyVenom",h.Position,0,defender)end
end)
local function crosses(a,b,c,r)
 local d=b-a;local t=d:Dot(d)>1e-9 and math.clamp((c-a):Dot(d)/d:Dot(d),0,1)or 0
 return(a+d*t-c).Magnitude<=r
end
local function spawn(f,now)
 local count=0;for _,t in ipairs(traps)do if t.owner==f.model then count=count+1 end end
 if count>=3 then return end
 serial=serial+1
 local p=Instance.new("Part");p.Name="SilkTrap_"..serial;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Transparency=1
 -- Diamètre égal à celui du Crax.
 local radius=f.radius;p.Size=Vector3.new(radius*2,radius*2,.05);p.Position=Vector3.new(f.position.X,f.position.Y,f.depth)
 p:SetAttribute("Born",now);p:SetAttribute("Expires",now+7);p:SetAttribute("Radius",radius);p:SetAttribute("RoundId",state:GetAttribute("RoundId"));p:SetAttribute("Owner",f.model.Name);p.Parent=folder
 traps[#traps+1]={part=p,owner=f.model,position=f.position,radius=radius,expires=now+7,inside={},armed={}}
 fx:FireAllClients("SpideyTrapWeave",p.Position,0,f.model)
end
function R.Step(fighters)
 if not active()then R.Clear();return end
 local now=workspace:GetServerTimeNow()
 local dt=lastStep and math.max(0,now-lastStep)or 0;lastStep=now
 for _,f in ipairs(fighters)do
  if AbilityGate.Paused(f.model)or f.sting or f.capturedBy and f.capturedBy.sting then
   if timers[f.model]then timers[f.model]=timers[f.model]+dt end
  end
 end
 for model,p in pairs(poisons)do
  if AbilityGate.Paused(p.attacker)or now<(p.attacker:GetAttribute("SpideyStingingUntil")or 0)then
   p.next=p.next+dt;model:SetAttribute("SpideyPoisonUntil",p.next+p.remaining-1)
  end
 end
 for i=#traps,1,-1 do local t=traps[i];if now>=t.expires then t.part:Destroy();table.remove(traps,i)end end
 local blocked=state:GetAttribute("GhostNightActive")or now<(state:GetAttribute("GhostFreezeUntil")or 0)
 for model,p in pairs(poisons)do
  if p.round~=state:GetAttribute("RoundId")or not alive(model)or not alive(p.attacker)then poisons[model]=nil;model:SetAttribute("SpideyPoisonUntil",nil)
  elseif not AbilityGate.Paused(p.attacker)and now>=p.next and now>=(p.attacker:GetAttribute("SpideyStingingUntil")or 0)then
   if not blocked then
    -- Une porte CombatHealth unique valide chaque tick et toutes les protections.
    hits:Fire(p.attacker,model,5,false,"SpideyPoison",nil,p.luckyAttackId)
    if not active()then R.Clear();return end
   end
   p.remaining=p.remaining-1;p.next=now+1
   if p.remaining==0 then poisons[model]=nil;model:SetAttribute("SpideyPoisonUntil",nil)end
  end
 end
 for _,f in ipairs(fighters)do
  if f.model:GetAttribute("AbilityId")=="SpideyWeb"and(f.model:GetAttribute("CraxSkillLevel")or 0)>=2 then
   timers[f.model]=timers[f.model]or(now+random:NextNumber(5,10))
   if not blocked and not AbilityGate.Paused(f.model)and now>=(f.model:GetAttribute("SpideyStingingUntil")or 0)and not f.model:GetAttribute("WebImmobilized")and now>=timers[f.model]then spawn(f,now);timers[f.model]=now+random:NextNumber(5,10)end
  end
 end
 for _,f in ipairs(fighters)do
  local position=f.position;local last=previous[f.model]or position
  if not blocked and alive(f.model)and not f.model:GetAttribute("GhostInvulnerable")then
   for i=#traps,1,-1 do
    local t=traps[i]
    local radius=t.radius+f.radius
    local inside=(position-t.position).Magnitude<=radius
    -- Seul le propriétaire est immunisé ; un Spidey adverse déclenche le piège.
    local armed=t.owner~=f.model
    if t.owner~=f.model or not inside then t.armed[f.model]=true end
    if armed and not t.inside[f.model]and crosses(last,position,t.position,radius)then
     if now>=(f.model:GetAttribute("SilkSlowUntil")or 0)then
      f.model:SetAttribute("SilkSlowUntil",now+4)
      fx:FireAllClients("SpideyTrapSnare",Vector3.new(position.X,position.Y,f.depth),0,f.model)
     end
    end
    if armed and not t.inside[f.model]and crosses(last,position,t.position,radius)then
     -- Consommée une seule fois, même si la cible est déjà ralentie.
     t.part:Destroy();table.remove(traps,i)
    else t.inside[f.model]=inside end
   end
  end
  previous[f.model]=position
 end
end
state:GetAttributeChangedSignal("RoundId"):Connect(R.Clear)
state:GetAttributeChangedSignal("Phase"):Connect(function()if not active()then R.Clear()end end)
return R
