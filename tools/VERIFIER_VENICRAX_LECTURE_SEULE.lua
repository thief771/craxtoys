-- VENICRAX · ÉTAT DE L'INSTALLATION, EN LECTURE SEULE. Barre de commande Studio, Play arrêté.
-- Ne crée, ne modifie et ne supprime rien ; n'exécute aucun module. Résultat dans Output.
do
local out={};local ok,missing=0,0
local function p(s)out[#out+1]=s end
local function has(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function item(label,present,detail)if present then ok+=1 else missing+=1 end;p((present and'  [OK]      'or'  [MANQUE]  ')..label..(detail and(' — '..detail)or''))end
p('=== VENICRAX : ÉTAT DANS LE JEU OUVERT ===')
p('1. Import du modèle (ServerStorage.VeniCrax_Import)')
local imp=has('ServerStorage.VeniCrax_Import');item('ServerStorage.VeniCrax_Import',imp~=nil,imp and imp.ClassName)
local parts={'V_HelmetShell','V_HelmetInner','V_HelmetCrest','V_HelmetBrow','V_VenomVeins','V_Fangs','V_FangsCore','V_VenomDrops','V_FitOrigin','V_FitUp','V_FitFront'}
if imp then for _,n in ipairs(parts)do local o=imp:FindFirstChild(n,true);local id=o and o:IsA('MeshPart')and(o.MeshId:match('%d+'))item('  '..n,o~=nil and id~=nil,o and(o:IsA('MeshPart')and('MeshId '..(id or'non publié'))or o.ClassName))end end
p('2. Modules et événement')
for _,path in ipairs({'ReplicatedStorage.CraxVeniConfig','ReplicatedStorage.CraxVeniRules','ReplicatedStorage.CraxVeniAppearance','ReplicatedStorage.CraxVeniAudio','ReplicatedStorage.CraxVeniAudioMap','ServerScriptService.CraxVeniRuntime','StarterPlayer.StarterPlayerScripts.CraxVeniClient','ReplicatedStorage.CraxVeniFX','ReplicatedStorage.CraxVeniImportedAssets','ReplicatedStorage.CraxVeniUserAssets'})do local o=has(path);item(path,o~=nil,o and o.ClassName)end
p('3. Modèle en jeu')
item('ServerStorage.CraxTemplates.Crax_Veni',has('ServerStorage.CraxTemplates.Crax_Veni')~=nil)
item('ReplicatedStorage.CraxPreviews.Crax_Veni',has('ReplicatedStorage.CraxPreviews.Crax_Veni')~=nil)
local t=has('ServerStorage.CraxTemplates.Crax_Veni');if t then item('  casque/crocs posés sur le gabarit (VeniAccessories)',t:FindFirstChild('VeniAccessories')~=nil)end
p('4. Raccordements dans les scripts existants (marqueur -- VeniCraxIntegrationV1)')
for _,path in ipairs({'ReplicatedStorage.CraxCatalog','ReplicatedStorage.CraxSkillCatalog','ReplicatedStorage.CraxEffectsCatalog','ReplicatedStorage.CraxVictoryCatalog','ReplicatedStorage.CraxRouletteConfig','ServerScriptService.CraxSkinServer','ServerScriptService.ArenaMovement','ServerScriptService.CombatHealth','ServerScriptService.RoundManager','StarterPlayer.StarterPlayerScripts.ArenaCamera','StarterPlayer.StarterPlayerScripts.CopEmClient','ReplicatedStorage.CraxBookCinema'})do
 local o=has(path);local src=o and o:IsA('LuaSourceContainer')and o.Source or''
 item(path,src:find('VeniCraxIntegrationV1',1,true)~=nil,not o and'script absent'or nil)
end
p('5. Sauvegarde')
local b=has('ServerStorage.VeniCrax_Backup_V1');item('ServerStorage.VeniCrax_Backup_V1',b~=nil and b:GetAttribute('Incomplete')==false,b and(b:GetAttribute('Incomplete')and'INCOMPLÈTE'or('révision '..tostring(b:GetAttribute('VeniRevision')))))
p('6. Sons, texture du casque, icônes (CraxVeniUserAssets)')
local u=has('ReplicatedStorage.CraxVeniUserAssets')
for _,k in ipairs({'AudioAtlas','HelmetColor','HelmetNormal','Icon_Bite','Icon_Cobra','Icon_Distill','Icon_Molt','Icon_Max'})do local v=u and u:GetAttribute(k);item(k,v~=nil,v and tostring(v)or(k:sub(1,5)=='Icon_'and'facultatif'or nil))end
local shell=has('ReplicatedStorage.CraxVeniImportedAssets')and has('ReplicatedStorage.CraxVeniImportedAssets'):FindFirstChild('V_HelmetShell',true)
item('Texture d’écailles posée (SurfaceAppearance sur V_HelmetShell)',shell~=nil and shell:FindFirstChildWhichIsA('SurfaceAppearance')~=nil)
p('7. Autres objets dont le nom contient « Veni » (hors « venir »)')
local extra=0;for _,o in ipairs(game:GetDescendants())do local n=o.Name:lower();if(n:find('veni',1,true)and not n:find('venir',1,true))then extra+=1;if extra<=40 then p('  '..o:GetFullName()..' ['..o.ClassName..']')end end end
if extra==0 then p('  aucun')elseif extra>40 then p('  … '..(extra-40)..' de plus')end
p(('=== BILAN : %d éléments présents, %d manquants (icônes facultatives comprises) ==='):format(ok,missing))
print(table.concat(out,'\n'))
end
