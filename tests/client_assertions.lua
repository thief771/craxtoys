local checks=0
local function check(v,m)checks+=1;assert(v,m)end
heartbeat:Fire(.2)
local folder=workspace:FindFirstChild('InvertedCrax_LocalFX');check(folder~=nil,'local FX folder created')
local function textContains(value)
 for _,o in ipairs(objects)do if o.Parent and o:IsA('TextLabel')and type(o.Text)=='string'and o.Text:find(value,1,true)then return true end end
 return false
end
check(textContains('COPIE 0/3'),'copy counter without SILENCE constructs valid boolean GUI properties')
b:SetAttribute('InvertedSilenced',true);b:SetAttribute('InvertedHacked',true)
fx.OnClientEvent:Fire('Silence',{Owner=b,RoundId=1,Hack=true});heartbeat:Fire(.2)
check(textContains('SILENCE'),'actual client displays SILENCE')
check(textContains('PIRATÉ'),'separate hacking indicator')
fx.OnClientEvent:Fire('Mute',{Owner=a,RoundId=1,Position=Vector3.new(0,25,-2.5),Radius=24});heartbeat:Fire(.1)
fx.OnClientEvent:Fire('Mark',{Owner=a,RoundId=1,Position=Vector3.new(0,25,-2.5)})
a:SetAttribute('InvertedCtrlRemaining',2);heartbeat:Fire(.2)
fx.OnClientEvent:Fire('Restore',{Owner=a,RoundId=1,From=Vector3.new(0,25,-2.5),Position=Vector3.new(10,25,-2.5)});heartbeat:Fire(.2)
check(#folder:GetChildren()>0,'actual VFX callbacks create local presentation objects')
a:SetAttribute('InvertedCopyReady',true);a:SetAttribute('InvertedCopyAmount',8);a:SetAttribute('InvertedCopyCount',3)
heartbeat:Fire(.2);check(textContains('COPIE PRÊTE : 8'),'no false increased bonus for copied hit <=8')
check(heartbeat:Count()==1,'one limited presentation loop')
script.Destroying:Fire()
check(heartbeat:Count()==0,'presentation loop disconnected on destruction')
check(fx.OnClientEvent:Count()==0,'network connection disconnected')
check(not workspace:FindFirstChild('InvertedCrax_LocalFX'),'local parts and UI destroyed')
print('ACTUAL CLIENT VFX LIFECYCLE PASS',checks,'assertions')
return checks
