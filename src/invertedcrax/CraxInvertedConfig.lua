local C={Id='Crax_Inverted',AbilityId='InvertedMute',SilenceIcon='',Quality='Auto',FinaleDuration=10.5,
 -- The reference speed and upgrade prices are read from existing catalogs, never hardcoded.
 RefreshPolicy='REFRESH_WITHOUT_STACKING',SilencedAtCtrlMark='SKIP_THIS_ROUND',
 Sounds={},CombatVolume=.16,CinematicVolume=.22,RollOffMinDistance=8,RollOffMaxDistance=110}
for _,name in ipairs({'MuteTrigger','SilenceApply','SilenceEnd','HackActivate','HackDirection01','HackDirection02','HackDirection03','CopyCapture','CopyImpact','RewindMark','RewindBuild','TeleportDepart','TeleportArrive','MarkCancel','MaxRise','MaxLoop','MaxFragment','MaxSuction','MaxClose'})do C.Sounds[name]=''end
local assets=game:GetService('ReplicatedStorage'):FindFirstChild('CraxInvertedUserAssets')
if assets then
 for name in pairs(C.Sounds)do local id=assets:GetAttribute(name);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Sounds[name]=id end end
 local icon=assets:GetAttribute('SilenceIcon');if type(icon)=='string'and icon:match('^rbxassetid://%d+$')then C.SilenceIcon=icon end
end
return C
