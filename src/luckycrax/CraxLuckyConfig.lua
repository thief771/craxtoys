local C={Id='Crax_Lucky',AbilityId='LuckyCoin',Health=105,Melee=8,
 CoinWait={6,9},PileDamage=12,FaceDamage=16,VolleyDamage=5,VolleyCount=6,VolleyLife=4,CheatDuration=7,Heal=25,
 -- Explicit prototype values, not creator-approved balancing decisions.
 CoinFaceChance=.5,CoinLife=3,CoinSpeed=32,CoinRadius=.48,FaceBounces=2,FlipDuration=.65,
 DiceWait={12,16},DiceDuration=1.2,DiceRadius=5,DiceMultiplier=2,DiceDoubleBonus=8,
 CloverHits=3,CloverDuration=4,ReelsWait={18,24},ReelsDuration=1.8,Weights={Heal=45,Coins=45,Cheat=10},VolleyInterval=.10,
 MaxTitle='LE GROS LOT',TrophyId='LuckyGrandPrize',Finale={Build=1.2,Spin=3,Result=5,Vanish=6.5,Pose=8,End=9},
 Quality='Auto',Volume=.17,AtlasId='',Icons={Dice='',Clover='',Jackpot='',Max=''},PricesReference='Crax_Spidey'}
local a=game:GetService('ReplicatedStorage'):FindFirstChild('CraxLuckyUserAssets')
if a then
 local id=a:GetAttribute('AudioAtlas');if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.AtlasId=id end
 for k in pairs(C.Icons)do local id=a:GetAttribute('Icon_'..k);if type(id)=='string'and id:match('^rbxassetid://%d+$')then C.Icons[k]=id end end
end
return C
