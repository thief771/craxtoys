local C={Id='Crax_Symbioti',AbilityId='SymTongue',Health=125,Melee=8,
 -- Creator confirmed these first-version values on 2026-11-03 (Europe/Paris).
 Damage=16,Wait={8,12},BurstDamage=15,BurstHeal=5,ArmourThreshold=30,ArmourDuration=4,ArmourReduction=.35,
 ParasiteDuration=3,ParasiteDPS=3,ParasiteSlow=.75,ParasiteHeal=5,
 -- Prices: creator confirmed the existing Epic GhostyCrax grid.
 -- Provisional construction choices: see docs/symbioticrax/DECISIONS.md.
 Prepare=.35,Range=24,Width=.65,ExtendSpeed=42,PullSpeed=18,CaptureMax=2.2,Retract=.4,
 MarkDuration=15,TongueMarks=false,ParasiteWait={12,16},ParasiteSpeed=21,ParasitePursuitMax=4,ParasiteReturnMax=4,
 HealOnlyEffective=true,PricesEnabled=true,Quality='Auto',Volume=.16,
 TrophyId='SymbiotiTogether',TrophyTitle='NOUS SOMMES SYMBIOTICRAX',
 Finale={Deploy=1,Capture=2.3,Close=4.3,Impact=5.1,Retract=6,Pose=7.2,ReturnEnd=9},
 AtlasId='',Audio={},Icons={Marks='',Armour='',Parasite='',Max=''}}
local ids=game:GetService('ReplicatedStorage'):FindFirstChild('CraxSymUserAssets')
if ids then
 local atlas=ids:GetAttribute('AudioAtlas');if type(atlas)=='string'and atlas:match('^rbxassetid://%d+$')then C.AtlasId=atlas end
 for k in pairs(C.Icons)do local id=ids:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
