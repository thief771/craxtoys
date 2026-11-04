-- LuckyCraxIntegrationV1
-- SourireDesignPro_v1 — visual redesign; authoritative timings unchanged.
-- CraxEnemyPause_v7
local AbilityClock=require(game:GetService("ReplicatedStorage"):WaitForChild("CraxAbilityClock"))
-- CopEmSourire_v1
-- LocalScript : StarterPlayer.StarterPlayerScripts.CraxBiteSmoothClient
-- CraxBiteSmooth_v1 : sons préchargés et mâchoires rendues localement.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local ContentProvider=game:GetService("ContentProvider")
local state=workspace:WaitForChild("CombatState")
local remote=RS:WaitForChild("CraxBiteSmoothEvent")
local player=Players.LocalPlayer
local VFX=require(RS:WaitForChild("CraxSourireVFXPro"))
local fighters={}
local CHARGE,OPEN,HOLD,CLOSE,GAP,RECOVER=.30,.16,.04,.10,.08,.25
local BITE_DURATION=OPEN+HOLD+CLOSE
local STEP_DURATION=BITE_DURATION+GAP
local ACTIVE_END=CHARGE+3*BITE_DURATION+2*GAP
local TOTAL=ACTIVE_END+RECOVER
local function allowed()
 return state:GetAttribute("Phase")=="Fighting" and not state:GetAttribute("GhostNightActive")
  and workspace:GetServerTimeNow()>=(state:GetAttribute("GhostFreezeUntil")or 0)
end
local function asset(value,default)
 if value==nil then value=default end
 local id=tostring(value):match("^%s*(.-)%s*$")
 return id:match("^%d+$")and "rbxassetid://"..id or(id:match("^rbxassetid://%d+$")and id or "")
end
local known = {
	"Throat",
	"UpperShell",
	"LowerShell",
	"UpperGums",
	"LowerGums",
	"InnerUpper",
	"InnerLower",
	"UpperFangs",
	"LowerFangs",
	"AngryEyeLeft",
	"AngryEyeRight",
	"AngrySocketLeft",
	"AngrySocketRight",
	"AngryPupilLeft",
	"AngryPupilRight",
	"AngryGlintLeft",
	"AngryGlintRight",
	"UpperFangGums",
	"LowerFangGums",
	"EyeLeft",
	"EyeRight",
}

local function classify(part, model)
	local current = part

	while current and current ~= model do
		for _, key in ipairs(known) do
			if current.Name == key or current.Name == key .. "_Node" then
				return key
			end
		end

		if current.Name:match("^Tooth_0_") then
			return "UpperTeeth"
		end

		if current.Name:match("^Tooth_1_") then
			return "LowerTeeth"
		end

		current = current.Parent
	end
end

local function apply(f, amount, threat)
	local r = f.radius
	local hinge = Vector3.new(
		0,
		-r * 0.29,
		r * math.sqrt(1 - 0.29 * 0.29)
	)

 local function jaw(angle)
  return f.anatomy * CFrame.new(hinge) * CFrame.Angles(math.rad(angle)*amount,0,0)
   * CFrame.new(-hinge) * f.anatomy:Inverse()
 end
 local upperTransform,lowerTransform=jaw(10),jaw(-29)
 for _,v in ipairs(f.visual)do
  local lower=v.kind:match("^Lower") or v.kind=="InnerLower"
  local transform=lower and lowerTransform or upperTransform

		if v.kind == "Throat" then
			transform = CFrame.identity
		end

		v.part.CFrame = f.head.CFrame * transform * v.rest

		if v.kind == "Throat" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperGums" or v.kind == "LowerGums" then
			v.part.Transparency = math.clamp(amount * 2, 0, 1)
		elseif v.kind == "UpperTeeth" or v.kind == "LowerTeeth" then
			v.part.Transparency = math.clamp(amount * 3, 0, 1)
		elseif v.kind == "UpperFangs"
			or v.kind == "LowerFangs"
			or v.kind == "UpperFangGums"
			or v.kind == "LowerFangGums" then
			v.part.Transparency = 1 - math.clamp(amount * 3, 0, 1)
		elseif v.kind == "EyeLeft" or v.kind == "EyeRight" then
			v.part.Transparency = threat and 1 or 0
		elseif v.kind:match("^Angry") then
			v.part.Transparency = threat and 0 or 1
		else
			v.part.Transparency = 0
		end
	end
end

local function smooth(t)
	t = math.clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

local function mouthAmount(t, activeEnd)
 if t < CHARGE then
  -- Quiet anticipation inside the existing charge window, not an extra delay.
  local u=math.clamp(t/CHARGE,0,1)
  return .07*math.sin(u*math.pi)^2
 end
 if t >= activeEnd then return 0 end
 local within=(t-CHARGE)%STEP_DURATION
 if within<OPEN then
  local u=math.clamp(within/OPEN,0,1)
  return u*u*u*(u*(u*6-15)+10)
 elseif within<OPEN+HOLD then return 1
 elseif within<BITE_DURATION then
  local u=(within-OPEN-HOLD)/CLOSE
  return 1-u*u*u -- Fast final closure exactly at the server's snap timestamp.
 end
 local u=(within-BITE_DURATION)/GAP
 return .045*math.sin(u*math.pi)*(1-u)
end


local function stop(f,all)
 f.active=false
 if f.designVFX then
  if f.anatomy then f.designVFX:UpdateMouth(f.anatomy,f.radius,0,false,AbilityClock.Time(f.model))end
  if all then f.designVFX:Clear()end
 end
 for _,s in ipairs(f.snapSounds)do s:Stop()end
 if all then for _,s in ipairs(f.hitSounds)do s:Stop()end end
end
local function preload(f)
 f.audioVersion=f.audioVersion+1
 local version=f.audioVersion
 local sounds={}
 for _,s in ipairs(f.snapSounds)do s:Stop();s.SoundId=asset(f.model:GetAttribute("BiteSoundId"),"9125466839");table.insert(sounds,s)end
 for _,s in ipairs(f.hitSounds)do s:Stop();s.SoundId=asset(f.model:GetAttribute("BiteHitSoundId"),"9119055732");table.insert(sounds,s)end
 task.spawn(function()
  local ok,err=pcall(function()ContentProvider:PreloadAsync(sounds)end)
  if not ok and version==f.audioVersion then warn("Crax Sourire : préchargement audio impossible : "..tostring(err))end
 end)
end
local function capture(f)
 local visual,centers,totals={},{},{}
 for _,p in ipairs(f.model:GetDescendants())do
  if p:IsA("BasePart")and p~=f.head then
   local kind=classify(p,f.model)
   if kind then
    local rest=f.head.CFrame:ToObjectSpace(p.CFrame)
    table.insert(visual,{part=p,kind=kind,rest=rest})
    centers[kind]=(centers[kind]or Vector3.zero)+rest.Position;totals[kind]=(totals[kind]or 0)+1
   end
  end
 end
 local function center(k)return totals[k]and centers[k]/totals[k]end
 local upper,lower,left,right=center("UpperShell"),center("LowerShell"),center("AngryEyeLeft"),center("AngryEyeRight")
 if not upper or not lower or not left or not right or (upper-lower).Magnitude<.001 then return false end
 local up=(upper-lower).Unit;local eye=(left+right)/2;local front=eye-up*eye:Dot(up)
 if front.Magnitude<.001 then return false end
 front=front.Unit;local side=front:Cross(up)
 if side.Magnitude<.001 then return false end
 side=side.Unit;up=side:Cross(front).Unit
 f.visual=visual;f.anatomy=CFrame.fromMatrix(Vector3.zero,side,up,-front)
 f.radius=math.max(f.head.Size.X,f.head.Size.Y,f.head.Size.Z)/2
 return true
end
local function begin(f)
 local start=f.model:GetAttribute("BiteFXStartedAt")
 if type(start)~="number"or start==f.lastStart then return end
 f.lastStart=start
 if not allowed()or f.model:GetAttribute("AbilityId")~="MonsterBite"
  or f.model:GetAttribute("BiteFXRound")~=state:GetAttribute("RoundId")then return end
 -- Cache au repos avant le premier mouvement de mâchoire ; pas de dépendance au nom de skin.
 if f.poseRound~=state:GetAttribute("RoundId")then
  if not capture(f)then return end
  f.poseRound=state:GetAttribute("RoundId")
 end
 f.count=math.clamp(tonumber(f.model:GetAttribute("BiteFXCount"))or 3,3,5)
 f.activeEnd=CHARGE+f.count*BITE_DURATION+(f.count-1)*GAP
 f.total=tonumber(f.model:GetAttribute("BiteFXDuration"))or(f.activeEnd+RECOVER)
 f.started=start;f.nextSnap=1;f.lastSnap=-math.huge;f.active=true
end
local function prepare(index)
 local model=workspace:WaitForChild("Fighter"..index)
 local head=model:FindFirstChild("Head",true)
 if head and not head:IsA("BasePart")then head=head:FindFirstChildWhichIsA("BasePart",true)end
 assert(head and head:IsA("BasePart"),"CraxBiteSmoothClient : Head manque.")
 local f={model=model,head=head,snapSounds={},hitSounds={},hitIndex=0,audioVersion=0,active=false}
 f.designVFX=VFX.new(model,head)
 local function sound(name,volume,pitch)
  local s=Instance.new("Sound");s.Name=name;s.Volume=volume;s.PlaybackSpeed=pitch
  s.RollOffMode=Enum.RollOffMode.InverseTapered;s.RollOffMinDistance=60;s.RollOffMaxDistance=180;s.Parent=head
  return s
 end
 for i=1,5 do f.snapSounds[i]=sound("LocalBiteSnap"..i,.8,1);f.hitSounds[i]=sound("LocalBiteImpact"..i,.9,.85)end
 fighters[model.Name]=f
 model:GetAttributeChangedSignal("BiteSoundId"):Connect(function()preload(f)end)
 model:GetAttributeChangedSignal("BiteHitSoundId"):Connect(function()preload(f)end)
 model:GetAttributeChangedSignal("AbilityId"):Connect(function()stop(f,true);f.poseRound=nil end)
 model:GetAttributeChangedSignal("BiteFXStartedAt"):Connect(function()begin(f)end)
 local function pauseAudio()
  local list={};for _,s in ipairs(f.snapSounds)do list[#list+1]=s end;for _,s in ipairs(f.hitSounds)do list[#list+1]=s end
  AbilityClock.SyncSounds(list,AbilityClock.Paused(model))
 end
 model:GetAttributeChangedSignal("CraxAbilityClock"):Connect(pauseAudio)
 preload(f)
 if capture(f)then f.poseRound=state:GetAttribute("RoundId")end
 begin(f)
end
remote.OnClientEvent:Connect(function(name,roundId,stamp)
 local f=fighters[name]
 if not f or roundId~=state:GetAttribute("RoundId")or state:GetAttribute("GhostNightActive")then return end
 local phase=state:GetAttribute("Phase")
 if phase~="Fighting"and phase~="RoundOver"then return end
 if type(stamp)~="number"or workspace:GetServerTimeNow()-stamp>.6 then return end
 f.hitIndex=f.hitIndex%5+1
 local s=f.hitSounds[f.hitIndex]
 s:Stop();s.TimePosition=0;s:Play()
 if f.radius then f.designVFX:Impact(f.head.Position,f.radius*.65,AbilityClock.Time(f.model),false,f.model)end
end)
local function cancelAll(stopImpact)
 for _,f in pairs(fighters)do
  if f.active and f.visual and f.model:GetAttribute("AbilityId")=="MonsterBite"then apply(f,0,false)end
  stop(f,stopImpact~=false)
 end
end
state:GetAttributeChangedSignal("GhostNightActive"):Connect(function()if state:GetAttribute("GhostNightActive")then cancelAll()end end)
state:GetAttributeChangedSignal("Phase"):Connect(function()
 local phase=state:GetAttribute("Phase")
 if phase~="Fighting"then cancelAll(phase~="RoundOver")end
 if phase=="Aiming"or phase=="Preparing"then
  for _,f in pairs(fighters)do
   if f.model:GetAttribute("AbilityId")=="MonsterBite"and capture(f)then f.poseRound=state:GetAttribute("RoundId")end
  end
 end
end)
state:GetAttributeChangedSignal("RoundId"):Connect(function()
 cancelAll();for _,f in pairs(fighters)do f.poseRound=nil;f.lastStart=nil end
end)
RunService:UnbindFromRenderStep("CraxSmoothBite")
RunService:BindToRenderStep("CraxSmoothBite",Enum.RenderPriority.Last.Value+150,function()
 local now=workspace:GetServerTimeNow()
 for _,f in pairs(fighters)do
  local visualNow=AbilityClock.Time(f.model)
  f.designVFX:Step(visualNow,AbilityClock.Paused(f.model))
  if f.active then
   if f.model:GetAttribute("LuckyTricked")or not allowed()or not f.head.Parent or f.model:GetAttribute("AbilityId")~="MonsterBite"then
    if f.visual and f.model:GetAttribute("AbilityId")=="MonsterBite"then apply(f,0,false)end
    stop(f,true)
   else
    local abilityNow=AbilityClock.Time(f.model)
    local elapsed=math.max(0,abilityNow-f.started)
    -- Cinq voix indépendantes, aucun Stop sur le claquement précédent.
    if not AbilityClock.Paused(f.model)and f.nextSnap<=f.count then
     local cue=CHARGE+(f.nextSnap-1)*STEP_DURATION+BITE_DURATION
     if elapsed>=cue and abilityNow-f.lastSnap>=.14 then
      local s=f.snapSounds[f.nextSnap]
      s:Stop();s.TimePosition=0;s:Play();f.lastSnap=abilityNow;f.designVFX:Snap(f.anatomy,f.radius,abilityNow);f.nextSnap=f.nextSnap+1
     end
    end
    if elapsed>=f.total then apply(f,0,false);f.designVFX:UpdateMouth(f.anatomy,f.radius,0,false,abilityNow);if f.nextSnap>f.count or elapsed>=f.total+.75 then f.active=false end
    else
     local amount=mouthAmount(elapsed,f.activeEnd)
     apply(f,amount,true)
     f.designVFX:UpdateMouth(f.anatomy,f.radius,amount,true,abilityNow)
    end
   end
  end
 end
end)
prepare(1);prepare(2)
