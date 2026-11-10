-- VeniCrax : valeurs du cahier des charges (validées par le créateur) puis réglages proposés, modifiables ici.
local C={Id='Crax_Veni',AbilityId='VeniBite',Health=100,Melee=5,
 -- Base · Morsure lente (validé) : après 3 collisions de mêlée, 2 PV/s pendant 5 s = 10 dégâts.
 BiteContacts=3,BiteTick=2,BiteDuration=5,
 -- N1 · Cobra Ricochet (validé) : 5 à l'impact, puis 3 PV/s pendant 3 s = 14 au total.
 CobraDamage=5,CobraTick=3,CobraDuration=3,
 -- N2 · Distillation (proposition) : après 5 pertes de PV dues au poison, prochain rebond mural = +8 PV, recharge 15 s.
 DistillPoisonLosses=5,DistillHeal=8,DistillCooldown=15,
 -- N3 · Mue toxique (proposition) : mue au contact -> cercle, nuage 0,7 s après, applique Morsure lente.
 MoltDelay=.7,
 -- Réglages proposés (pas encore validés par le créateur).
 TickInterval=1,CobraWait={7,10},CobraFirstWait={3,5},CobraSpeed=34,CobraRadius=.55,CobraLife=3.2,CobraMaxBounces=3,
 MoltWait={14,18},MoltFirstWait={6,8},MoltLife=8,MoltTouchRadius=1.4,MoltCloudRadius=4.8,ContactWindow=.35,
 FinaleDuration=9.5,MaxTitle='ÉTREINTE DU COBRA',TrophyId='VeniCobraEmbrace',
 Volume=.2,Quality='Auto',AtlasId='',Icons={Bite='',Cobra='',Distill='',Molt='',Max=''},HelmetColor='',HelmetNormal=''}
local user=game:GetService('ReplicatedStorage'):FindFirstChild('CraxVeniUserAssets')
local function asset(v)return type(v)=='string'and v:match('^rbxassetid://%d+$')and v or nil end
if user then
 C.AtlasId=asset(user:GetAttribute('AudioAtlas'))or C.AtlasId
 C.HelmetColor=asset(user:GetAttribute('HelmetColor'))or C.HelmetColor
 C.HelmetNormal=asset(user:GetAttribute('HelmetNormal'))or C.HelmetNormal
 for k in pairs(C.Icons)do C.Icons[k]=asset(user:GetAttribute('Icon_'..k))or C.Icons[k]end
end
return C
