-- VENICRAX · SONS, TEXTURES ET ICÔNES. Studio, Play ARRÊTÉ, après INSTALLER_VENICRAX.lua.
-- Remplace les zéros par tes IDs Roblox (laisser 0 pour ne rien changer), puis exécute dans la barre de commande.
local IDS={
 AudioAtlas=0,      -- VeniCrax_Audio_Atlas.wav (assets/venicrax/audio) importé comme Audio
 HelmetColor=0,     -- VeniCrax_Helmet_Color.png (assets/venicrax/model) importé comme Image
 HelmetNormal=0,    -- VeniCrax_Helmet_Normal.png
 Icon_Bite=0,Icon_Cobra=0,Icon_Distill=0,Icon_Molt=0,Icon_Max=0,  -- illustrations du livre (facultatif)
}
do

assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play (mode Édition), puis relancer cette commande')
local SES=game:GetService('ScriptEditorService');local RS=game:GetService('ReplicatedStorage');local SS=game:GetService('ServerStorage')
local function resolve(path)local o=game;for n in path:gmatch('[^.]+')do o=o and o:FindFirstChild(n)end;return o end
local function read(o)return SES:GetEditorSource(o)end
local function write(o,before,after)SES:UpdateSourceAsync(o,function(current)assert(current==before,'Conflit éditeur : '..o:GetFullName());return after end);assert(read(o)==after,'Vérification éditeur échouée')end
local backupName='VeniCrax_Backup_V1'

local backup=assert(SS:FindFirstChild(backupName),'Installer VeniCrax d’abord');assert(not backup:GetAttribute('Incomplete'),'Installation VeniCrax incomplète')
local user=assert(RS:FindFirstChild('CraxVeniUserAssets'));local assets=assert(RS:FindFirstChild('CraxVeniImportedAssets'))
local changed={}
for k,v in pairs(IDS)do if type(v)=='number'and v>0 then user:SetAttribute(k,'rbxassetid://'..math.floor(v));changed[#changed+1]=k end end
-- Texture d'écailles : SurfaceAppearance posé ici (ColorMap ne peut pas être écrit pendant le jeu).
local shell=assets:FindFirstChild('V_HelmetShell',true);local color=user:GetAttribute('HelmetColor')
if shell and color then
 local sa=shell:FindFirstChildWhichIsA('SurfaceAppearance')or Instance.new('SurfaceAppearance')
 sa.ColorMap=color;local normal=user:GetAttribute('HelmetNormal');if normal then sa.NormalMap=normal end;sa.Parent=shell
 local appearance=require(RS.CraxVeniAppearance)
 for _,m in ipairs({SS.CraxTemplates:FindFirstChild('Crax_Veni'),RS.CraxPreviews:FindFirstChild('Crax_Veni')})do if m then appearance.Apply(m,assets)end end
end
print('VeniCrax : '..(#changed>0 and table.concat(changed,', ')or'aucun ID')..' branché(s). Enregistrer puis NOUVEAU Play.')
end
