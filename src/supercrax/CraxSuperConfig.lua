local C={Id='Crax_Super',AbilityId='SuperHero',
 Health=100,Melee=8,DashDuration=1.5,DashTurns=3,DashDamageMultiplier=2,
 DashWait={8,12},LaserWait={5,8},LaserDuration=2.5,LaserDPS=15,
 FrostContacts=3,FrostCharge=2,FrostDuration=3.5,FreezeDuration=5,ShatterDamage=35,
 -- Creator-confirmed answers (2026-11-02):
 DashHitPolicy='PerTurn',ChannelMobile=true,LastStandHealing='LOCK_AT_ONE',
 -- Unconfirmed implementation choices, exposed rather than disguised as approved rules:
 CooldownOrigin='End',FrostContactPolicy='ConfirmedNormalMelee',DashCanShatter=false,
 LaserAim='FixedIndependent',FrostAim='FarthestCorner',LaserWidthPerRadius=.065,
 FrostWidthFraction=.28,DashRadiusPerHead=.8,DashEntryBlend=.10,
 KryptoniteRadius=1.6,KryptoniteSpeed=1.5,KryptoniteDropOnLoss=true,
 PricePolicy='ReferenceMonsterConfirmed',Quality='Auto',
 Finale={FlyEnd=1.1,FreezeStart=1.1,FreezeEnd=3.6,ChargeStart=3.6,ChargeEnd=5.1,ShotEnd=5.55,ShatterEnd=7.1,ReturnEnd=8.2},
 Audio={},Icons={Laser='',Frost='',Invincible='',Max=''},CombatVolume=.16,FinaleVolume=.22,RollOffMin=8,RollOffMax=115}
for _,n in ipairs({'SteelStart','CircleDash','DashHit','SteelEnd','LaserStart','LaserLoop','LaserEnd','FrostCharge','FrostLoop','FreezeApply','IceShatter','LastStand','KryptoniteSpawn','KryptonitePickup','KryptoniteDeath','FinaleFly','FinaleLaserCharge','FinaleLaserShot','FinaleShatter'})do C.Audio[n]=''end
local assets=game:GetService('ReplicatedStorage'):FindFirstChild('CraxSuperUserAssets')
if assets then
 for n in pairs(C.Audio)do local id=assets:GetAttribute(n);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Audio[n]=id end end
 for n in pairs(C.Icons)do local id=assets:GetAttribute('Icon_'..n);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[n]=id end end
end
return C
