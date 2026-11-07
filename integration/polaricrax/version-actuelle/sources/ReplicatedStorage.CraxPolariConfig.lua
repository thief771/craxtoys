-- Values explicitly requested by the creator. Remaining controls are documented prototypes.
local C={Id='Crax_Polari',AbilityId='PolariImpulse',Health=110,Melee=7,
 ImpulseWait={6,9},Charge=.4,ImpulseDamage=10,AttractDuration=2,AttractDamage=8,InvertDamage=15,InvertCharge=1.5,InvertDuration=3,StopDuration=1.2,ShardDamage=6,MaxHits=3,ShardCount=5,
 -- Prototype balancing/visual timings, not implicit creator approval.
 AttractWait={10,14},InvertWait={12,16},StopFirstWait={5,7},StopWait={22,28},InvertWarning=.25,DodgeWindow=.35,TickWarning=.6,
 ProjectileSpeed=38,ProjectileLife=2.5,ProjectileRadius=.38,DeflectAngle=math.rad(13),AttractTurnRate=1.2,RepelAngle=math.rad(28),RepelSpeedScale=1,
 FanRadius=10,Volume=.18,Quality='Auto',FinaleDuration=9,MaxTitle='L’ULTIME SECONDE',TrophyId='PolariFinalSecond',AtlasId='',Textures={Flare='',Spark='',Smoke=''},Icons={Attract='',Invert='',Stop='',Max=''}}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxPolariUserAssets')
if user then
 local id=user:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Textures)do local id=user:GetAttribute('Texture_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Textures[k]=id end end
 for k in pairs(C.Icons)do local id=user:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
